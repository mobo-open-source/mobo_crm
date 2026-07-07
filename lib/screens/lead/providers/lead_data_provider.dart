import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/services/isar_caching_service.dart';
import 'package:mobo_crm/global_methods/widgets/custom_filters.dart';
import 'package:mobo_crm/global_methods/widgets/group_by_dropdown.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/models.dart';
import 'package:mobo_crm/global_methods/services/global_error_handler.dart';
import 'package:mobo_crm/screens/lead/isar/lead_model_isar_graph.dart';
import 'package:mobo_crm/screens/lead/isar/leads_model_isar_cache.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/company/session/company_session_manager.dart';

/// `LeadDataProvider` is a `ChangeNotifier` that manages the state and data
/// of CRM leads in the application. It handles fetching leads from Odoo,
/// caching them in Isar, applying filters, grouping, pagination, and
/// transforming lead data into graph-ready formats.
///
/// This provider supports:
/// - Fetching leads from the Odoo backend using various filters.
/// - Fetching leads from local Isar cache for offline support.
/// - Applying custom filters, stage filters, date filters, activity filters.
/// - Grouping leads by stage, salesperson, team, priority, partner, country,
///   creation date, expected revenue, and probability.
/// - Paginating leads for easy navigation.
/// - Maintaining a list of activity names from `mail.activity.type`.
/// - Calculating aggregate values like revenue, probability, and day-to-close
///   totals for each stage.
/// - Managing lead-related UI state like search, loading, and error handling.
///
/// Example usage:
/// ```dart
/// final leadProvider = LeadDataProvider();
/// await leadProvider.initlead(context);
/// leadProvider.setGroupBy(GroupByOption.stage);
/// final leadsByStage = leadProvider.groupedLeads;
/// ```
class LeadDataProvider extends ChangeNotifier {
  int? _userId;
  final String _url = "";
  List<Map<dynamic, dynamic>> _leads = [];
  final bool _isSearching = false;
  bool _isLoading = true;
  AppError? leadError;
  bool hasError = false;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> _stageDatalead = [];

  List<Map<String, dynamic>>? get stageData => _stageDatalead;
  final String _selectedOption = '';
  final String _valueStatus = '';
  String selectedFilterLead = 'Count';
  int? _selectedPriority;

  String _lastSearchText = '';

  final int limit = 40;
  int _currentPage = 0;
  int _totalCount = 0;
  int _graphViewIndex = 0;

  int get graphViewIndex => _graphViewIndex;

  void setGraphViewIndex(int index) {
    _graphViewIndex = index;
    notifyListeners();
  }

  int? get userId => _userId;

  String get url => _url;

  List<Map<dynamic, dynamic>> get leads => _leads;

  bool get isLoading => _isLoading;

  String get selectedOption => _selectedOption;

  bool get isSearching => _isSearching;
  bool canNavigate = true;

  String get valueStatus => _valueStatus;
  List allleadpagination = [];

  GroupByOption _currentGroupBy = GroupByOption.none;
  Map<String, List<Map<dynamic, dynamic>>> _groupedLeads = {};
  Map<String, bool> _groupExpansionState = {};

  GroupByOption get currentGroupBy => _currentGroupBy;

  Map<String, List<Map<dynamic, dynamic>>> get groupedLeads => _groupedLeads;

  Map<String, bool> get groupExpansionState => _groupExpansionState;
  List<String> _selectedFilters = [];

  List<String> get selectedFilters => _selectedFilters;

  set selectedFilters(List<String> value) {
    _selectedFilters = value;
    notifyListeners();
  }

  int get currentPage => _currentPage;

  int get totalCount => _totalCount;

  bool get hasPreviousPage => _currentPage > 0;

  bool get hasNextPage {
    if (_currentGroupBy != GroupByOption.none) {
      return (_currentPage + 1) * limit < _groupedLeads.keys.length;
    }
    return (_currentPage + 1) * limit < _totalCount;
  }

  int get startRecord => (_currentPage * limit) + 1;

  int get endRecord {
    if (_currentGroupBy != GroupByOption.none) {
      final groupCount = _groupedLeads.keys.length;
      final startGroup = _currentPage * limit;
      final endGroup = ((startGroup + limit).clamp(0, groupCount));
      return endGroup;
    }
    if (leads.isEmpty || _totalCount == 0) return 0;
    final calculatedEnd = startRecord + leads.length - 1;
    return calculatedEnd.clamp(1, _totalCount > 0 ? _totalCount : 1);
  }

  int get totalPages {
    if (_currentGroupBy != GroupByOption.none) {
      return (_groupedLeads.keys.length / limit).ceil();
    }
    return (_totalCount / limit).ceil();
  }

  int get currentPageNumber => _currentPage + 1;

  bool isAdmin = false;

  /// Clear all filters and optionally reload leads
  void clearFilters({bool reload = true, BuildContext? context}) async {
    selectedFilters = [];
    _leads.clear();
    _groupedLeads.clear();
    _currentPage = 0;

    if (reload && context != null) {
      _isLoading = true;
      notifyListeners();
      await getLeads(context: context, loading: true);
    }
  }

  /// Set the current group by option and refresh grouped leads
  void setGroupBy(GroupByOption option) {
    _currentGroupBy = option;
    _currentPage = 0;
    _applyGrouping();
    notifyListeners();
  }

  Future<void> updatePriority({
    required int leadId,
    required int newPriority,
  }) async {
    try {
      await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'write',
        'args': [
          [leadId],
          {'priority': newPriority.toString()}
        ],
        'kwargs': {},
      });

      final index = _leads.indexWhere((e) => e['id'] == leadId);

      if (index != -1) {
        _leads[index]['priority'] = newPriority.toString();
        notifyListeners();
      }
    } catch (_) {}
  }

  /// Toggle expanded/collapsed state of a group in UI
  void toggleGroupExpansion(String groupKey) {
    _groupExpansionState[groupKey] = !(_groupExpansionState[groupKey] ?? true);
    notifyListeners();
  }

  double getGroupRevenue(List<Map<dynamic, dynamic>> groupLeads) {
    return groupLeads.fold(0.0, (sum, lead) {
      final revenue = lead['expected_revenue'];
      if (revenue is num) {
        return sum + revenue.toDouble();
      }
      return sum;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    leads.clear();
    super.dispose();
  }

  /// Parses the major version number from a server version string.
  int parseMajorVersion(String serverVersion) {
    final match = RegExp(r'\d+').firstMatch(serverVersion);
    if (match != null) {
      return int.tryParse(match.group(0)!) ?? 0;
    }
    return 0;
  }

  /// Checks whether the current user has admin permissions.
  Future<void> canManageSkills() async {
    final prefs = await SharedPreferences.getInstance();
    final String version = prefs.getString('serverVersion') ?? '0';
    final int userId = prefs.getInt('userId') ?? 0;
    final int majorVersion = parseMajorVersion(version);

    Future<bool> hasGroup(String groupExtId) async {
      if (majorVersion >= 18) {
        return await CompanySessionManager.callKwWithCompany({
              'model': 'res.users',
              'method': 'has_group',
              'args': [userId, groupExtId],
              'kwargs': {},
            }) ==
            true;
      } else {
        return await CompanySessionManager.callKwWithCompany({
              'model': 'res.users',
              'method': 'has_group',
              'args': [groupExtId],
              'kwargs': {},
            }) ==
            true;
      }
    }

    final admin = await hasGroup('base.group_system');

    isAdmin = admin;
    notifyListeners();
  }

  /// Delete lead.
  Future<void> deleteLead(int id) async {
    try {
      await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'unlink',
        'args': [
          [id]
        ],
        'kwargs': {},
      });

      leads.removeWhere((lead) => lead['id'] == id);

      notifyListeners();
    } catch (_) {}
  }

  /// Clears all lead data and resets pagination
  void clearAll() {
    leads.clear();
    _currentPage = 0;
    _totalCount = 0;
  }

  int? get selectedPriority => _selectedPriority;

  List<String> activityNames = [];
  final Map<String, Color> activityStateColors = {
    "overdue": Colors.red,
    "today": Colors.orange,
    "planned": Colors.green,
  };

  /// Initializes lead data by fetching from backend or cache
  ///
  /// [context] - BuildContext for accessing providers.
  /// [loading] - Optional flag to show loading indicator.
  Future<void> initlead(BuildContext context, {bool loading = false}) async {
    await getLeads(context: context, loading: loading);
  }

  void clear() {
    leads.clear();
    notifyListeners();
  }

  /// Apply a filter for counting or other aggregation
  void applyFilter(String filter) {
    selectedFilterLead = filter;

    notifyListeners();
  }

  /// Fetch leads from Odoo with optional filters, search, and pagination
  ///
  /// [context] - Optional BuildContext for accessing OdooClient.
  /// [leadfilter] - Apply lead-specific filters.
  /// [leaddatefilters] - Apply date-based filters.
  /// [stagefilters] - Filter by stage.
  /// [unAssigned] - Include unassigned leads.
  /// [hasArchived] - Include archived leads.
  /// [partnerassigned] - Filter by assigned partner.
  /// [myactivities] - Filter by user's activities.
  /// [lost] - Include lost leads.
  /// [customFilter] - Provide custom domain filter.
  /// [searchText] - Search text for lead name or team.
  /// [loading] - Show loading indicator.
  Future<void> getLeads(
      {BuildContext? context,
      bool leaddatefiltersclose = false,
      bool leadfilter = false,
      bool leaddatefilters = false,
      bool stagefilters = false,
      bool unAssigned = false,
      bool hasArchived = false,
      bool partnerassigned = false,
      bool myactivities = false,
      bool lost = false,
      OdooClient? clientraw,
      bool useRawClient = false,
      bool leadmonthNow = false,
      bool leadbeforeMonth = false,
      bool leadbeforetwoMonth = false,
      bool leadbeforeMonthclose = false,
      bool leadbeforetwoMonthclose = false,
      bool leadmonthNowclose = false,
      bool lateactivity = false,
      bool todayactivity = false,
      bool futureactivity = false,
      bool activitycatgoryfilter = false,
      List? customFilter,
      bool loading = false,
      String searchText = ""}) async {
    hasError = false;
    leadError = null;

    if (searchText.isEmpty && customFilter == null) {
      if (_leads.isNotEmpty && !loading && _lastSearchText.isEmpty) {
        return;
      }
      _lastSearchText = '';
      final success = await getLeadDataFromIsar();
      if (success && !loading) {
        _isLoading = false;
        notifyListeners();
        return;
      }
    }

    _lastSearchText = searchText;

    if (loading || _leads.isEmpty) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      OdooClient? client;
      if (context == null) {
        client = clientraw;
      } else {
        final clientprovider =
            Provider.of<OdooClientManager>(context, listen: false);
        client = clientprovider.client;
      }

      _leads.clear();

      List<dynamic> filters = [
        ['type', '=', 'lead'],
      ];

      if (customFilter != null) {
        filters = customFilter;
      }

      List<dynamic> leadDatafilterList = CustomFilters().getLeadDataFilter(
          leadfilter: leadfilter,
          myactivities: myactivities,
          unAssigned: unAssigned,
          userId: client!.sessionId!.userId,
          partnerassigned: partnerassigned);
      filters = [...filters, ...leadDatafilterList];

      List<dynamic> stageFiltersList = CustomFilters().getStageFilters(
          stagefilters: stagefilters, lost: lost, won: false, onGoing: false);

      filters = [...filters, ...stageFiltersList];

      List<dynamic> alldatefilterList = CustomFilters().getLeadDateFilters(
          leaddatefilters: leaddatefilters,
          leadmonthNow: leadmonthNow,
          leadbeforeMonth: leadbeforeMonth,
          leadbeforetwoMonth: leadbeforetwoMonth);
      List<dynamic> alldatefilterListClose = CustomFilters()
          .getLeadDateFiltersClose(
              leaddatefiltersclose: leaddatefiltersclose,
              leadmonthNowclose: leadmonthNowclose,
              leadbeforeMonthclose: leadbeforeMonthclose,
              leadbeforetwoMonthclose: leadbeforetwoMonthclose);

      List<dynamic> mergeDateFilters = CustomFilters().mergeDateFilters(
          leadDateFilterExpected: [],
          leaddatefilterExpected: false,
          leaddatefilters: leaddatefilters,
          leaddatefiltersclose: leaddatefiltersclose,
          leadDateFilters: alldatefilterList,
          leadDateFiltersClose: alldatefilterListClose);

      filters = [...filters, ...mergeDateFilters];

      List activityFilter = CustomFilters().getActivityFilters(
          activitycatgoryfilter: activitycatgoryfilter,
          lateactivity: lateactivity,
          todayactivity: todayactivity,
          futureactivity: futureactivity);

      filters = [...filters, ...activityFilter];

      if (hasArchived) {
        List archived = [
          ['active', '=', false]
        ];
        filters = [...filters, ...archived];
      }

      if (searchText.isNotEmpty) {
        filters.add('|');
        filters.add(['name', 'ilike', '%$searchText']);
        filters.add(['team_id', 'ilike', '%$searchText']);
      }

      final prefs = await SharedPreferences.getInstance();
      int version = prefs.getInt('version') ?? 0;

      List<String> fieldsToFetch = [
        'name',
        'create_date',
        'stage_id',
        'email_from',
        'activity_ids',
        'activity_state',
        'activity_type_id',
        'activity_user_id',
        'activity_summary',
        'activity_date_deadline',
        'probability',
        'partner_id',
        'expected_revenue',
        'partner_name',
        'street',
        'contact_name',
        'email_cc',
        'function',
        'phone',
        if (version <= 18) 'mobile',
        'priority',
        'tag_ids',
        'campaign_id',
        'medium_id',
        'source_id',
        'referred',
        'date_open',
        'date_closed',
        'message_bounce',
        'description',
        'duplicate_lead_ids',
        'active',
        'activity_user_id',
        'day_close',
        'recurring_revenue_monthly',
        'recurring_revenue_monthly_prorated',
        'recurring_revenue_prorated',
        'prorated_revenue',
        'recurring_revenue',
        'team_id',
        'user_id',
        'country_id',
        'activity_date_deadline',
        'type',
      ];

      try {
        final countResponse = await CompanySessionManager.callKwWithCompany({
          'model': 'crm.lead',
          'method': 'search_count',
          'args': [filters],
          'kwargs': {},
        });
        _totalCount = countResponse ?? 0;
      } catch (e) {
        _totalCount = 0;
      }

      int fetchLimit = limit;
      int fetchOffset = _currentPage * limit;

      if (_currentGroupBy != GroupByOption.none) {
        fetchLimit = 0;
        fetchOffset = 0;
      }

      dynamic leadDetailsraw;
      try {
        leadDetailsraw = await CompanySessionManager.callKwWithCompany({
          'model': 'crm.lead',
          'method': 'search_read',
          'args': [filters],
          'kwargs': {
            'fields': fieldsToFetch,
            'limit': fetchLimit,
            'offset': fetchOffset,
          },
        });
      } catch (e) {
        fieldsToFetch.remove('mobile');
        leadDetailsraw = await CompanySessionManager.callKwWithCompany({
          'model': 'crm.lead',
          'method': 'search_read',
          'args': [filters],
          'kwargs': {
            'fields': fieldsToFetch,
            'limit': fetchLimit,
            'offset': fetchOffset,
          },
        });
      }

      if (leadDetailsraw != null && leadDetailsraw.isNotEmpty) {
        final leadCacheObjects = leadDetailsraw
            .map((e) => LeadsModelIsarCache.fromJson(e.cast<String, dynamic>()))
            .toList()
            .cast<LeadsModelIsarCache>();

        if (searchText.isEmpty) {
          await IsarService.saveLeadsCache(leadCacheObjects);
        }
      }

      if (leadDetailsraw != null && leadDetailsraw.isNotEmpty) {
        List<LeadCrmModel> leads = leadDetailsraw.map<LeadCrmModel>((lead) {
          return LeadCrmModel.fromJson(Map<String, dynamic>.from(lead));
        }).toList();

        Map<String, int> stageCounts = {};
        Map<String, num> stageDayCloseTotal = {};
        Map<String, num> stageExpectedRevenue = {};
        Map<String, num> stageRecurringRevenueMonthly = {};
        Map<String, num> stageProbability = {};
        Map<String, num> stageRecurringRevenueMonthlyProrated = {};
        Map<String, num> stageRecurringRevenueProrated = {};
        Map<String, num> stageProratedRevenue = {};
        Map<String, num> stageRecurringRevenue = {};

        for (var lead in leads) {
          String stageName = lead.stageName;

          stageCounts[stageName] = (stageCounts[stageName] ?? 0) + 1;

          stageDayCloseTotal[stageName] =
              (stageDayCloseTotal[stageName] ?? 0) + lead.dayClose;
          stageExpectedRevenue[stageName] =
              (stageExpectedRevenue[stageName] ?? 0) + lead.expectedRevenue;
          stageRecurringRevenueMonthly[stageName] =
              (stageRecurringRevenueMonthly[stageName] ?? 0) +
                  lead.recurringRevenueMonthly;
          stageProbability[stageName] =
              (stageProbability[stageName] ?? 0) + lead.probability;
          stageRecurringRevenueMonthlyProrated[stageName] =
              (stageRecurringRevenueMonthlyProrated[stageName] ?? 0) +
                  lead.recurringRevenueMonthlyProrated;
          stageRecurringRevenueProrated[stageName] =
              (stageRecurringRevenueProrated[stageName] ?? 0) +
                  lead.recurringRevenueProrated;
          stageProratedRevenue[stageName] =
              (stageProratedRevenue[stageName] ?? 0) + lead.proratedRevenue;
          stageRecurringRevenue[stageName] =
              (stageRecurringRevenue[stageName] ?? 0) + lead.recurringRevenue;
        }

        _stageDatalead = stageCounts.entries.map((e) {
          return {
            'stage': e.key,
            'count': e.value,
            'total_day_close': stageDayCloseTotal[e.key] ?? 0,
            'total_expected_revenue': stageExpectedRevenue[e.key] ?? 0,
            'recurring_revenue_monthly':
                stageRecurringRevenueMonthly[e.key] ?? 0,
            'probability': stageProbability[e.key] ?? 0,
            'recurring_revenue_monthly_prorated':
                stageRecurringRevenueMonthlyProrated[e.key] ?? 0,
            'recurring_revenue_prorated':
                stageRecurringRevenueProrated[e.key] ?? 0,
            'prorated_revenue': stageProratedRevenue[e.key] ?? 0,
            'recurring_revenue': stageRecurringRevenue[e.key] ?? 0,
          };
        }).toList();
        final graphData = _stageDatalead.map((stageMap) {
          return LeadModelIsarGraph()
            ..stageName = stageMap['stage']
            ..count = (stageMap['count'] ?? 0)
            ..expectedRevenue =
                (stageMap['total_expected_revenue'] ?? 0).toDouble()
            ..recurringRevenueMonthly =
                (stageMap['recurring_revenue_monthly'] ?? 0).toDouble()
            ..recurringRevenue = (stageMap['recurring_revenue'] ?? 0).toDouble()
            ..probability = (stageMap['probability'] ?? 0).toDouble()
            ..dayClose = (stageMap['total_day_close'] ?? 0).toDouble()
            ..recurringRevenueMonthlyProrated =
                (stageMap['recurring_revenue_monthly_prorated'] ?? 0).toDouble()
            ..recurringRevenueProrated =
                (stageMap['recurring_revenue_prorated'] ?? 0).toDouble()
            ..proratedRevenue = (stageMap['prorated_revenue'] ?? 0).toDouble();
        }).toList();

        await IsarService.saveLeadsGraph(graphData);

        notifyListeners();
      } else {}
      final activityResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity.type',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'fields': ['name']
        }
      });
      if (activityResponse is List) {
        activityNames = activityResponse
            .whereType<Map<String, dynamic>>()
            .map((activity) => activity['name'].toString())
            .toList();
        await IsarService.saveActivityNames(activityNames);
      }

      if (leadDetailsraw != null && leadDetailsraw is List) {
        final leadDetails = leadDetailsraw.map((lead) {
          return lead.map(
              (key, value) => MapEntry(key, value == false ? null : value));
        }).toList();

        if (leadDetails.isNotEmpty) {
          List<Map<dynamic, dynamic>> updatedLeads = [];

          for (var lead in leadDetails) {
            lead['user_image'] = null;

            updatedLeads.add(lead);
          }
          _leads = updatedLeads;

          if (fetchLimit == 0 || _leads.length < fetchLimit) {
            _totalCount = fetchOffset + _leads.length;
          } else if (_totalCount == 0 && _leads.isNotEmpty) {
            _totalCount = fetchOffset + _leads.length + 1;
          }

          _applyGrouping();
          _isLoading = false;
          notifyListeners();
        } else {
          _isLoading = false;
          notifyListeners();
        }
      }
    } catch (e) {
      bool success = false;
      if (_leads.isEmpty) {
        success = await getLeadDataFromIsar();
        _isLoading = false;
        notifyListeners();
      }
      if (selectedFilters.isEmpty) {
        if (success == false) {
          OdooClient? client;
          if (clientraw != null) {
            client = clientraw;
          } else {
            final clientprovider =
                Provider.of<OdooClientManager>(context!, listen: false);
            client = clientprovider.client;
          }

          leadError =
              await ErrorHandler.handleException(e, uri: client!.baseURL);
          if (_leads.isEmpty) {
            Future.delayed(const Duration(seconds: 2), () {
              _isLoading = false;
              hasError = true;
              notifyListeners();
            });
          }
        }
      } else {
        _leads = [];
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _applyGrouping() {
    _groupedLeads.clear();
    if (_currentGroupBy == GroupByOption.none) {
      return;
    }

    for (var lead in leads) {
      String groupKey = _getGroupKey(lead, _currentGroupBy);
      if (!_groupedLeads.containsKey(groupKey)) {
        _groupedLeads[groupKey] = [];
        if (!_groupExpansionState.containsKey(groupKey)) {
          _groupExpansionState[groupKey] = true;
        }
      }
      _groupedLeads[groupKey]!.add(lead);
    }

    final sortedKeys = _groupedLeads.keys.toList()..sort();
    final sortedGroups = <String, List<Map<dynamic, dynamic>>>{};
    for (String key in sortedKeys) {
      sortedGroups[key] = _groupedLeads[key]!;
    }
    _groupedLeads = sortedGroups;
  }

  String _getGroupKey(Map<dynamic, dynamic> lead, GroupByOption groupBy) {
    switch (groupBy) {
      case GroupByOption.stage:
        if (lead['stage_id'] is List && lead['stage_id'].length > 1) {
          return lead['stage_id'][1].toString();
        }
        return 'No Stage';
      case GroupByOption.salesperson:
        if (lead['user_id'] is List && lead['user_id'].length > 1) {
          return lead['user_id'][1].toString();
        }
        return 'Unassigned';
      case GroupByOption.team:
        if (lead['team_id'] is List && lead['team_id'].length > 1) {
          return lead['team_id'][1].toString();
        }
        return 'No Team';
      case GroupByOption.priority:
        final priority = lead['priority'];
        if (priority == '0') return 'Low';
        if (priority == '1') return 'Normal';
        if (priority == '2') return 'High';
        if (priority == '3') return 'Very High';
        return 'Normal';
      case GroupByOption.partner:
        if (lead['partner_id'] is List && lead['partner_id'].length > 1) {
          return lead['partner_id'][1].toString();
        }
        return 'No Customer';
      case GroupByOption.country:
        if (lead['country_id'] is List && lead['country_id'].length > 1) {
          return lead['country_id'][1].toString();
        }
        return 'No Country';
      case GroupByOption.createDate:
        final createDate = lead['create_date'];
        if (createDate != null) {
          try {
            final date = DateTime.parse(createDate.toString());
            return '${date.year}-${date.month.toString().padLeft(2, '0')}';
          } catch (e) {
            return 'Invalid Date';
          }
        }
        return 'No Date';
      case GroupByOption.expectedRevenue:
        final revenue = lead['expected_revenue'];
        if (revenue is num) {
          final revenueValue = revenue.toDouble();
          if (revenueValue == 0) return '\$0';
          if (revenueValue < 1000) return '< \$1K';
          if (revenueValue < 10000) return '\$1K - \$10K';
          if (revenueValue < 100000) return '\$10K - \$100K';
          return '> \$100K';
        }
        return '\$0';
      case GroupByOption.probability:
        final probability = lead['probability'];
        if (probability is num) {
          final probValue = probability.toDouble();
          if (probValue == 0) return '0%';
          if (probValue < 25) return '< 25%';
          if (probValue < 50) return '25% - 50%';
          if (probValue < 75) return '50% - 75%';
          return '≥ 75%';
        }
        return '0%';
      case GroupByOption.none:
      default:
        return 'All';
    }
  }

  /// Fetch aggregated graph data from Isar cache
  Future<void> getGraphDataFromIsar() async {
    final cachedGraphItems = await IsarService.getCachedLeadsGraph();

    _stageDatalead = cachedGraphItems.map((e) {
      return {
        'stage': e.stageName ?? 'Unknown',
        'count': e.count,
        'total_day_close': e.dayClose,
        'total_expected_revenue': e.expectedRevenue,
        'recurring_revenue_monthly': e.recurringRevenueMonthly,
        'probability': e.probability,
        'recurring_revenue_monthly_prorated': e.recurringRevenueMonthlyProrated,
        'recurring_revenue_prorated': e.recurringRevenueProrated,
        'prorated_revenue': e.proratedRevenue,
        'recurring_revenue': e.recurringRevenue,
      };
    }).toList();
  }

  /// Fetch leads from Isar cache for offline mode
  ///
  /// Returns true if leads were successfully fetched from cache
  Future<bool> getLeadDataFromIsar() async {
    try {
      final cachedItems = await IsarService.getLeadsCache();

      _leads = cachedItems.map((item) {
        return {
          'id': item.serverId,
          'name': item.name,
          'phone': item.phone,
          'email_from': item.emailFrom,
          'city': item.city,
          'country_id': item.countryId != null
              ? [item.countryId, item.countryName]
              : null,
          'team_id': item.teamId != null ? [item.teamId, item.teamName] : null,
          'user_id': item.userId != null ? [item.userId, item.userName] : null,
          'probability': item.probability,
          'partner_id': item.partnerId != null
              ? [item.partnerId, item.partnerName]
              : null,
          'priority': item.priority,
          'tag_ids': item.tagIds ?? [],
          'date_open': item.dateOpen,
          'date_closed': item.dateClosed,
          'activity_date_deadline': item.activityDateDeadline,
          'activity_ids': item.activityIds ?? [],
          'activity_type_id': item.activityTypeId != null
              ? [item.activityTypeId, item.activityTypeName]
              : null,
          'activity_state': item.activityState,
          'activity_user_id': item.activityUserId != null
              ? [item.activityUserId, item.activityUserName]
              : null,
          'expected_revenue': item.expectedRevenue,
          'prorated_revenue': item.proratedRevenue,
          'description': item.description,
          'contact_name': item.contactName,
          'mobile': item.mobile ?? item.phone,
          'active': item.active,
          'type': item.type,
          'create_date': item.createDate,
          'stage_id':
              item.stageId != null ? [item.stageId, item.stageName] : null,
          'day_close': item.dayClose,
          'recurring_revenue_monthly': item.recurringRevenueMonthly,
          'recurring_revenue_monthly_prorated':
              item.recurringRevenueMonthlyProrated,
          'recurring_revenue_prorated': item.recurringRevenueProrated,
          'recurring_revenue': item.recurringRevenue,
          'date_deadline': item.dateDeadline,
          'user_image': null,
        };
      }).toList();
      activityNames = await IsarService.getActivityNames();
      await getGraphDataFromIsar();
      if (_leads.isNotEmpty && _totalCount == 0) {
        _totalCount = _leads.length;
      }
      _applyGrouping();
      notifyListeners();

      if (_leads.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (cacheError) {
      return false;
    }
  }

  /// Go to next page of leads (pagination)
  Future<void> goToNextPage({
    required BuildContext context,
    bool leadfilter = false,
    bool leaddatefilters = false,
    bool stagefilters = false,
    bool unAssigned = false,
    bool hasArchived = false,
    bool partnerassigned = false,
    bool myactivities = false,
    bool lost = false,
    bool leadmonthNow = false,
    bool leadbeforeMonth = false,
    bool leadbeforetwoMonth = false,
    bool leaddatefiltersclose = false,
    bool leadbeforeMonthclose = false,
    bool leadbeforetwoMonthclose = false,
    bool leadmonthNowclose = false,
    bool lateactivity = false,
    bool todayactivity = false,
    bool futureactivity = false,
    bool activitycatgoryfilter = false,
    List? customFilter,
    String searchText = "",
  }) async {
    if (!hasNextPage || _isLoading) return;

    _currentPage++;

    await getLeads(
      context: context,
      leadfilter: leadfilter,
      leaddatefilters: leaddatefilters,
      stagefilters: stagefilters,
      unAssigned: unAssigned,
      hasArchived: hasArchived,
      partnerassigned: partnerassigned,
      myactivities: myactivities,
      lost: lost,
      leadmonthNow: leadmonthNow,
      leadbeforeMonth: leadbeforeMonth,
      leadbeforetwoMonth: leadbeforetwoMonth,
      leaddatefiltersclose: leaddatefiltersclose,
      leadbeforeMonthclose: leadbeforeMonthclose,
      leadbeforetwoMonthclose: leadbeforetwoMonthclose,
      leadmonthNowclose: leadmonthNowclose,
      lateactivity: lateactivity,
      todayactivity: todayactivity,
      futureactivity: futureactivity,
      activitycatgoryfilter: activitycatgoryfilter,
      customFilter: customFilter,
      searchText: searchText,
      loading: true,
    );
  }

  /// Go to previous page of leads (pagination)
  Future<void> goToPreviousPage({
    required BuildContext context,
    bool leadfilter = false,
    bool leaddatefilters = false,
    bool stagefilters = false,
    bool unAssigned = false,
    bool hasArchived = false,
    bool partnerassigned = false,
    bool myactivities = false,
    bool lost = false,
    bool leadmonthNow = false,
    bool leadbeforeMonth = false,
    bool leadbeforetwoMonth = false,
    bool leaddatefiltersclose = false,
    bool leadbeforeMonthclose = false,
    bool leadbeforetwoMonthclose = false,
    bool leadmonthNowclose = false,
    bool lateactivity = false,
    bool todayactivity = false,
    bool futureactivity = false,
    bool activitycatgoryfilter = false,
    List? customFilter,
    String searchText = "",
  }) async {
    if (!hasPreviousPage || _isLoading) return;

    _currentPage--;

    await getLeads(
      context: context,
      leadfilter: leadfilter,
      leaddatefilters: leaddatefilters,
      stagefilters: stagefilters,
      unAssigned: unAssigned,
      hasArchived: hasArchived,
      partnerassigned: partnerassigned,
      myactivities: myactivities,
      lost: lost,
      leadmonthNow: leadmonthNow,
      leadbeforeMonth: leadbeforeMonth,
      leadbeforetwoMonth: leadbeforetwoMonth,
      leaddatefiltersclose: leaddatefiltersclose,
      leadbeforeMonthclose: leadbeforeMonthclose,
      leadbeforetwoMonthclose: leadbeforetwoMonthclose,
      leadmonthNowclose: leadmonthNowclose,
      lateactivity: lateactivity,
      todayactivity: todayactivity,
      futureactivity: futureactivity,
      activitycatgoryfilter: activitycatgoryfilter,
      customFilter: customFilter,
      searchText: searchText,
      loading: true,
    );
  }
}
