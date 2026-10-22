import 'package:flutter/material.dart';
import 'package:mobo_crm/models/activity_model/activity_model.dart';
import 'package:mobo_crm/global_methods/services/isar_caching_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/company/session/company_session_manager.dart';
import '../../../../global_methods/services/global_error_handler.dart';
import '../Isar/mail_activity_model_isar.dart';

/// Provider for fetching, caching, and managing mail activity groups.
///
/// This [ChangeNotifier] handles the retrieval of mail activity data
/// from the server (via `CompanySessionManager`), maintains loading and
/// error states, and persists data locally using Isar for offline support.
///
/// Supports different Odoo server versions (17.0 and 18.0), converting
/// responses into [MailActivityGroup] models, and caching them in
/// [MailActivityGroupIsar].
class MailDataProvider extends ChangeNotifier {
  List<MailActivityGroup> _activityGroups = [];
  bool _isLoading = true;
  AppError? _errorMessage;
  bool _hasError = false;

  List<MailActivityGroup> get activityGroups => _activityGroups;

  bool get isLoading => _isLoading;

  AppError? get errorMessage => _errorMessage;

  bool get hasError => _hasError;

  /// Computes the total count of all activities across all groups.
  ///
  /// Returns 0 if no groups are present.
  int get totalActivityCount {
    return _activityGroups.isNotEmpty
        ? _activityGroups.map((g) => g.totalCount).fold(0, (a, b) => a + b)
        : 0;
  }

  Future<List<MailActivityGroup>> _fetchViaSystray(int userId) async {
    try {
      final result = await CompanySessionManager.callSystrayActivity(
        context: {'lang': 'en_US', 'uid': userId},
      );
      final rawGroups = result as List<dynamic>?;
      if (rawGroups != null && rawGroups.isNotEmpty) {
        return rawGroups
            .cast<Map<dynamic, dynamic>>()
            .map((e) => Map<String, dynamic>.from(e))
            .map((e) => MailActivityGroup.fromJson(e))
            .toList();
      }
    } catch (e) {
    }

    try {
      final result = await CompanySessionManager.callActivity(
        model: 'res.users',
        method: 'systray_get_activities',
        args: [],
        kwargs: {'context': {'lang': 'en_US', 'uid': userId}},
      );
      final rawGroups = result as List<dynamic>?;
      if (rawGroups != null && rawGroups.isNotEmpty) {
        return rawGroups
            .cast<Map<dynamic, dynamic>>()
            .map((e) => Map<String, dynamic>.from(e))
            .map((e) => MailActivityGroup.fromJson(e))
            .toList();
      }
    } catch (e) {
    }

    return _fetchViaSearchRead(userId);
  }

  /// Directly queries mail.activity records for [userId] and groups them by
  /// res_model to build [MailActivityGroup] objects.
  ///
  /// Used as a last-resort fallback when systray_get_activities returns nothing.
  Future<List<MailActivityGroup>> _fetchViaSearchRead(int userId) async {
    try {
      final now = DateTime.now();
      final today =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final rawActivities = await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'search_read',
        'args': [
          [
            ['user_id', '=', userId]
          ],
        ],
        'kwargs': {
          'fields': ['id', 'res_model', 'date_deadline'],
        },
      });

      final List list = rawActivities as List? ?? [];
      if (list.isEmpty) return [];

      final Map<String, List<Map<String, dynamic>>> grouped = {};
      for (final raw in list) {
        final activity = Map<String, dynamic>.from(raw as Map);
        final model = activity['res_model']?.toString() ?? 'unknown';
        grouped.putIfAbsent(model, () => []).add(activity);
      }

      final groups = <MailActivityGroup>[];
      grouped.forEach((model, activities) {
        int todayCount = 0, overdueCount = 0, plannedCount = 0;
        for (final a in activities) {
          final deadline = a['date_deadline']?.toString() ?? '';
          if (deadline.isEmpty) {
            plannedCount++;
          } else if (deadline == today) {
            todayCount++;
          } else if (deadline.compareTo(today) < 0) {
            overdueCount++;
          } else {
            plannedCount++;
          }
        }
        groups.add(MailActivityGroup(
          id: model.hashCode.abs(),
          name: _modelDisplayName(model, activities),
          model: model,
          icon: _modelIcon(model),
          totalCount: activities.length,
          todayCount: todayCount,
          overdueCount: overdueCount,
          plannedCount: plannedCount,
        ));
      });

      return groups;
    } catch (e) {
      return [];
    }
  }

  String _modelDisplayName(String model, List<Map<String, dynamic>> activities) {
    final serverName = activities.firstOrNull?['res_model_name'];
    if (serverName != null &&
        serverName != false &&
        serverName.toString().isNotEmpty) {
      return serverName.toString();
    }
    switch (model) {
      case 'crm.lead':
        return 'CRM';
      case 'sale.order':
        return 'Sales';
      case 'res.partner':
        return 'Contacts';
      case 'account.move':
        return 'Invoicing';
      case 'project.task':
        return 'Project';
      case 'hr.applicant':
        return 'Recruitment';
      default:
        return model;
    }
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
        return '/project/static/description/icon.png';
      case 'hr.applicant':
        return '/recruitment/static/description/icon.png';
      default:
        return '';
    }
  }

  /// Fetches mail activity data from the server and caches it locally.
  ///
  /// Handles Odoo version-specific API calls:
  /// - `18.0` → `callMailData` returning a structured store with `activityGroups`.
  /// - `17.0` → `callSystrayActivity` returning a list of activity groups.
  ///
  /// The fetched data is converted into [MailActivityGroup] objects and
  /// also stored in Isar for offline access.
  ///
  /// If an error occurs, the provider tries to load cached groups from Isar.
  ///
  /// Parameters:
  /// - [isNotify]: if true, `notifyListeners()` is called before the fetch
  ///   to update the UI with the loading state.
  ///
  /// Throws an [Exception] if:
  /// - The response structure is invalid
  /// - The server version is unsupported
  Future<void> fetchMailData({
    bool isNotify = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    final url = prefs.getString('url') ?? '';

    try {
      _isLoading = true;
      _errorMessage = null;
      _hasError = false;
      if (isNotify) {
        notifyListeners();
      }

      final versionResponse = await CompanySessionManager.callVersion();
      final serverVersion = versionResponse['server_version']?.toString() ?? '';

      List<MailActivityGroup> groups = [];

      final versionMajor = int.tryParse(serverVersion.split('.').first) ?? 0;
      final useMailData = versionMajor >= 18;

      if (useMailData) {
        try {
          final result = versionMajor >= 19
              ? await CompanySessionManager.callMailData(
                  fetchParams: ['systray_get_activities'],
                )
              : await CompanySessionManager.callMailData(
                  context: {'lang': 'en_US', 'uid': userId},
                );

          final response = result as Map<String, dynamic>?;

          if (response != null) {
            final store = response['Store'] ?? response['store'];
            if (store is Map) {
              final storeMap = Map<String, dynamic>.from(store);
              final rawGroups = storeMap['activityGroups'] ??
                  storeMap['activity_groups'] ??
                  storeMap['ActivityGroup'];
              if (rawGroups is List && rawGroups.isNotEmpty) {
                groups = rawGroups
                    .cast<Map<dynamic, dynamic>>()
                    .map((e) => Map<String, dynamic>.from(e))
                    .map((e) => MailActivityGroup.fromJson(e))
                    .toList();
              }
            } else {
            }
          }

          if (groups.isEmpty) {
            groups = await _fetchViaSystray(userId);
          }
        } catch (e) {
          groups = await _fetchViaSystray(userId);
        }
      } else {
        groups = await _fetchViaSystray(userId);
      }

      _activityGroups = groups;

      final groupCacheObjects = groups
          .map((e) => MailActivityGroupIsar.fromJson(e.toJson()))
          .toList();
      await IsarService.saveMailActivityGroups(groupCacheObjects);
    } catch (e) {
      final cachedGroups = await IsarService.getCachedMailActivityGroups();
      if (cachedGroups.isNotEmpty) {
        _activityGroups = cachedGroups
            .map((e) => MailActivityGroup.fromJson(e.toJson()))
            .toList();
      } else {
        _activityGroups = [];
        final appError = await ErrorHandler.handleException(e, uri: url);
        if (appError.type == ErrorType.socket ||
            appError.type == ErrorType.network ||
            appError.type == ErrorType.timeout ||
            appError.type == ErrorType.client) {
          _errorMessage = appError;
          _hasError = true;
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
