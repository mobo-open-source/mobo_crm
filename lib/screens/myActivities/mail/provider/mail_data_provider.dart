import 'package:flutter/material.dart';
import 'package:mobo_crm/models/activity_model/activity_model.dart';
import 'package:mobo_crm/global_methods/services/isar_caching_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/company/session/company_session_manager.dart';
import '../../../../global_methods/services/global_error_handler.dart';
import '../Isar/mail_activity_model_isar.dart';
import '../mail_activity_item.dart';

/// Provider for fetching, caching, and managing mail activity groups.
///
/// The groups are the same ones the Odoo web client shows in its activity
/// systray (one row per model with overdue / today / planned counts). Where the
/// data comes from depends on the server release:
///
/// | Odoo | Source                                                        |
/// |------|---------------------------------------------------------------|
/// | 17   | `res.users.systray_get_activities`                            |
/// | 18   | `POST /mail/data` with `systray_get_activities: true`         |
/// | 19   | `POST /mail/data` with `fetch_params: [systray_get_activities]` |
/// | 20   | `POST /mail/store` (`/mail/data` was removed), same body       |
///
/// If none of those answers, the groups are rebuilt from a plain
/// `mail.activity` `search_read`, using the server-computed `state` of each
/// activity. If even that fails the saved copy is shown and flagged as such
/// ([isShowingCached]) rather than being passed off as live data.
class MailDataProvider extends ChangeNotifier {
  List<MailActivityGroup> _activityGroups = [];
  bool _isLoading = true;
  bool _isShowingCached = false;
  AppError? _errorMessage;
  bool _hasError = false;
  bool _disposed = false;

  List<MailActivityGroup> get activityGroups => _activityGroups;

  bool get isLoading => _isLoading;

  /// True when the server could not be reached and the groups shown come from
  /// the local copy saved on the last successful load.
  bool get isShowingCached => _isShowingCached;

  AppError? get errorMessage => _errorMessage;

  bool get hasError => _hasError;

  /// Technical model name → display name (e.g. `crm.lead` → "Lead/Opportunity").
  ///
  /// Used by the "All activities" list to say what each activity belongs to.
  Map<String, String> get modelNames => {
        for (final group in _activityGroups)
          if (group.model.isNotEmpty && group.name.isNotEmpty)
            group.model: group.name,
      };

  /// Computes the number of activities across all groups, whatever their state.
  ///
  /// Returns 0 if no groups are present.
  int get totalActivityCount =>
      _activityGroups.fold(0, (sum, group) => sum + group.allCount);

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  // ── request context ──────────────────────────────────────────────────────

  /// The context the web client would send: the user's real language and
  /// timezone plus the companies currently enabled in the app.
  ///
  /// Without `allowed_company_ids` Odoo counts activities of *every* company
  /// the user belongs to, while the website only counts the enabled ones —
  /// one of the reasons the numbers used to disagree.
  static Future<Map<String, dynamic>> activityContext({int? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = userId ?? prefs.getInt('userId') ?? 0;
    final lang = prefs.getString('userLang');
    final tz = prefs.getString('userTimezone');

    final selected = await CompanySessionManager.getSelectedCompanyId();
    final allowed = await CompanySessionManager.getSelectedAllowedCompanyIds();
    // Odoo takes env.company from the first allowed id, so the selected
    // company must lead the list.
    final companies = <int>{if (selected != null) selected, ...allowed}.toList();

    return {
      'lang': (lang == null || lang.isEmpty) ? 'en_US' : lang,
      if (tz != null && tz.isNotEmpty) 'tz': tz,
      'uid': uid,
      if (companies.isNotEmpty) 'allowed_company_ids': companies,
    };
  }

  /// Major Odoo version of the connected server (0 if it cannot be told).
  Future<int> _serverMajorVersion(SharedPreferences prefs) async {
    try {
      final info = await CompanySessionManager.callVersion();
      final raw = info is Map ? info['server_version']?.toString() ?? '' : '';
      // Handles "18.0", "saas~18.2" and "19.0+e".
      final match = RegExp(r'\d+').firstMatch(raw);
      final parsed = match == null ? null : int.tryParse(match.group(0)!);
      if (parsed != null) return parsed;
    } catch (_) {
      // Fall through to the version stored at login.
    }
    return prefs.getInt('version') ?? 0;
  }

  // ── sources ──────────────────────────────────────────────────────────────

  /// Reads the activity groups out of a `/mail/data` or `/mail/store` reply.
  ///
  /// Returns null when the reply has no activity-group key at all (so the
  /// caller can try something else), and an empty list when the server really
  /// answered "no activities".
  List<MailActivityGroup>? _parseStoreGroups(dynamic result) {
    if (result is! Map) return null;
    dynamic store = result['Store'] ?? result['store'];
    if (store is List && store.isNotEmpty) store = store.first;
    if (store is! Map) return null;

    // Odoo 18 and 19 use camelCase, Odoo 20 snake_case.
    final raw = store['activityGroups'] ??
        store['activity_groups'] ??
        store['ActivityGroup'];
    if (raw is! List) return null;

    return raw
        .whereType<Map>()
        .map((e) => MailActivityGroup.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Odoo 18+: the web client's own systray request.
  Future<List<MailActivityGroup>?> _fetchViaMailStore(
    int major,
    Map<String, dynamic> context,
  ) async {
    const fetchParams = ['systray_get_activities'];
    final unknown = major == 0;

    final attempts = <Future<dynamic> Function()>[
      if (major >= 20 || unknown)
        () => CompanySessionManager.callMailData(
              route: '/mail/store',
              fetchParams: fetchParams,
              context: context,
            ),
      if (major >= 19 || unknown)
        () => CompanySessionManager.callMailData(
              fetchParams: fetchParams,
              context: context,
            ),
      if (major == 18 || unknown)
        () => CompanySessionManager.callMailData(context: context),
    ];

    for (final attempt in attempts) {
      try {
        final groups = _parseStoreGroups(await attempt());
        if (groups != null) return groups;
      } catch (_) {
        // This release does not know that route/body; try the next shape.
      }
    }
    return null;
  }

  /// Odoo 17 and earlier: `res.users.systray_get_activities`.
  ///
  /// The method no longer exists from Odoo 18, so it is not tried there.
  Future<List<MailActivityGroup>?> _fetchViaSystray(
    Map<String, dynamic> context,
  ) async {
    final attempts = <Future<dynamic> Function()>[
      () => CompanySessionManager.callSystrayActivity(context: context),
      () => CompanySessionManager.callActivity(
            model: 'res.users',
            method: 'systray_get_activities',
            kwargs: {'context': context},
          ),
    ];

    for (final attempt in attempts) {
      try {
        final raw = await attempt();
        if (raw is List) {
          return raw
              .whereType<Map>()
              .map((e) =>
                  MailActivityGroup.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
      } catch (_) {
        // Try the next call.
      }
    }
    return null;
  }

  /// Last resort: rebuild the groups from the user's `mail.activity` rows.
  ///
  /// Uses the server-computed `state` of every activity (evaluated in the
  /// assignee's timezone, exactly as the systray does) instead of comparing
  /// dates against the phone's clock. Throws when the server cannot be
  /// reached so the caller can fall back to the saved copy; an empty list
  /// means the user genuinely has no activities.
  Future<List<MailActivityGroup>> _fetchViaSearchRead(
    int userId,
    Map<String, dynamic> context,
  ) async {
    final raw = await CompanySessionManager.callKwWithCompany({
      'model': 'mail.activity',
      'method': 'search_read',
      'args': [
        [
          ['user_id', '=', userId],
        ],
      ],
      'kwargs': {
        'fields': ['res_model', 'date_deadline', 'state'],
        'context': context,
      },
    });
    if (raw is! List) throw Exception('Unexpected response format');

    final byModel = <String, List<Map<String, dynamic>>>{};
    for (final row in raw.whereType<Map>()) {
      final activity = Map<String, dynamic>.from(row);
      final model = activity['res_model'];
      final key = model is String && model.isNotEmpty
          ? model
          : MailActivityGroup.otherActivitiesModel;
      byModel.putIfAbsent(key, () => []).add(activity);
    }
    if (byModel.isEmpty) return [];

    final names = await _resolveModelNames(byModel.keys);

    final groups = <MailActivityGroup>[];
    byModel.forEach((model, activities) {
      var today = 0, overdue = 0, planned = 0;
      for (final activity in activities) {
        switch (MailActivityItem.fromJson(activity).state) {
          case 'today':
            today++;
          case 'overdue':
            overdue++;
          case 'planned':
          case 'none':
            planned++;
        }
      }
      groups.add(MailActivityGroup(
        id: _stableId(model),
        name: model == MailActivityGroup.otherActivitiesModel
            ? 'Other activities'
            : names[model] ?? readableModelName(model),
        model: model,
        icon: _modelIcon(model),
        // Same meaning as Odoo's total_count: what is due now.
        totalCount: today + overdue,
        todayCount: today,
        overdueCount: overdue,
        plannedCount: planned,
        activityIds: activities
            .map((a) => a['id'])
            .whereType<int>()
            .toList(),
      ));
    });

    groups.sort((a, b) {
      if (a.isOtherActivities != b.isOtherActivities) {
        return a.isOtherActivities ? 1 : -1;
      }
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return groups;
  }

  /// Technical model name → the name Odoo shows for it, in the user's language.
  Future<Map<String, String>> _resolveModelNames(
      Iterable<String> models) async {
    try {
      final raw = await CompanySessionManager.callKwWithCompany({
        'model': 'ir.model',
        'method': 'search_read',
        'args': [
          [
            ['model', 'in', models.toList()],
          ],
        ],
        'kwargs': {
          'fields': ['model', 'name'],
        },
      });
      if (raw is! List) return {};
      return {
        for (final row in raw.whereType<Map>())
          if (row['model'] is String && row['name'] is String)
            row['model'] as String: row['name'] as String,
      };
    } catch (_) {
      return {};
    }
  }

  /// Stable id for a model when the server gave none.
  ///
  /// `String.hashCode` is not guaranteed to be the same between app runs, and
  /// the id keys the saved activity list of the group.
  int _stableId(String model) {
    var hash = 0;
    for (final unit in model.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return hash;
  }

  /// Readable name for a model the server did not name: `project.task` →
  /// "Task", `x_custom.thing` → "X Custom Thing".
  static String readableModelName(String model) {
    const known = {
      'crm.lead': 'Lead/Opportunity',
      'sale.order': 'Sales Order',
      'res.partner': 'Contact',
      'account.move': 'Journal Entry',
      'project.task': 'Task',
      'hr.applicant': 'Applicant',
    };
    final name = known[model];
    if (name != null) return name;
    return model
        .split(RegExp(r'[._]'))
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  String _modelIcon(String model) {
    switch (model) {
      case 'crm.lead':
        return '/crm/static/description/icon.png';
      case 'sale.order':
        return '/sale/static/description/icon.png';
      case 'res.partner':
        return '/contacts/static/description/icon.png';
      case 'account.move':
        return '/account/static/description/icon.png';
      case 'project.task':
      case 'project.project':
        return '/project/static/description/icon.png';
      case 'hr.applicant':
        return '/hr_recruitment/static/description/icon.png';
      case 'purchase.order':
        return '/purchase/static/description/icon.png';
      case 'stock.picking':
        return '/stock/static/description/icon.png';
      case 'calendar.event':
        return '/calendar/static/description/icon.png';
      default:
        return '';
    }
  }

  // ── public API ───────────────────────────────────────────────────────────

  /// Fetches mail activity data from the server and caches it locally.
  ///
  /// Parameters:
  /// - [isNotify]: if true, `notifyListeners()` is called before the fetch
  ///   to update the UI with the loading state.
  /// - [silent]: refresh in the background (pull-to-refresh): the groups
  ///   already on screen stay visible instead of being replaced by shimmers.
  ///
  /// On failure the last saved copy is shown and [isShowingCached] is set; the
  /// error screen is used only when there is nothing saved either.
  Future<void> fetchMailData({
    bool isNotify = false,
    bool silent = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    final url = prefs.getString('url') ?? '';

    try {
      if (!silent) _isLoading = true;
      _errorMessage = null;
      _hasError = false;
      if (isNotify) {
        notifyListeners();
      }

      final context = await activityContext(userId: userId);
      final major = await _serverMajorVersion(prefs);

      final groups = (major >= 18 || major == 0
              ? await _fetchViaMailStore(major, context)
              : await _fetchViaSystray(context)) ??
          await _fetchViaSearchRead(userId, context);

      _activityGroups = groups;
      _isShowingCached = false;

      try {
        await IsarService.saveMailActivityGroups(
          groups.map((e) => MailActivityGroupIsar.fromJson(e.toJson())).toList(),
        );
      } catch (_) {
        // A failed cache write must not hide freshly loaded data.
      }
    } catch (e) {
      if (silent && _activityGroups.isNotEmpty) {
        // Keep what is on screen, but say it may be out of date.
        _isShowingCached = true;
      } else {
        final cachedGroups = await IsarService.getCachedMailActivityGroups();
        if (cachedGroups.isNotEmpty) {
          _activityGroups = cachedGroups
              .map((e) => MailActivityGroup.fromJson(e.toJson()))
              .toList();
          _isShowingCached = true;
        } else {
          _activityGroups = [];
          _isShowingCached = false;
          _errorMessage = await ErrorHandler.handleException(e, uri: url);
          _hasError = true;
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Loads the activities of [group] for the current user.
  ///
  /// Uses the same context (language, timezone, enabled companies) as the
  /// group counts so the list and the counts describe the same records. Falls
  /// back to the saved copy when the server cannot be reached; rethrows when
  /// there is no saved copy either.
  static Future<MailActivityList> loadActivities(MailActivityGroup group) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;

    try {
      final context = await activityContext(userId: userId);

      final domain = <dynamic>[
        ['user_id', '=', userId],
      ];
      if (group.isOtherActivities) {
        // "Other activities" is not a model: it is the activities whose
        // document the user cannot read (or that have none), so filtering on
        // res_model would always come back empty.
        domain.add(group.activityIds.isNotEmpty
            ? ['id', 'in', group.activityIds]
            : [
                'res_model',
                'in',
                [false, ''],
              ]);
      } else if (group.model.isNotEmpty) {
        domain.add(['res_model', '=', group.model]);
      }

      final result = await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'search_read',
        'args': [domain],
        'kwargs': {
          'fields': [
            'summary',
            'note',
            'date_deadline',
            'activity_type_id',
            'res_name',
            'user_id',
            'res_model',
            'res_id',
            'state',
          ],
          'context': context,
        },
      });
      if (result is! List) throw Exception('Unexpected response format');

      final rows = result
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      try {
        await IsarService.saveMailActivities(
          group.id,
          rows
              .map((e) => MailActivityIsar.fromJson({...e, 'group_id': group.id}))
              .toList(),
        );
      } catch (_) {
        // Caching is best effort.
      }

      return MailActivityList(
        items: rows.map((e) => MailActivityItem.fromJson(e)).toList(),
      );
    } catch (_) {
      final cached = await IsarService.getCachedMailActivities(group.id);
      if (cached.isNotEmpty) {
        return MailActivityList(
          items: cached.map((a) => MailActivityItem.fromJson(a.toJson())).toList(),
          fromCache: true,
        );
      }
      rethrow;
    }
  }
}
