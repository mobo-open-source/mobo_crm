import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/widgets/custom_filters.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/models.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/company/session/company_session_manager.dart';

/// Provider for managing activity-related data and filters in CRM.
///
/// Responsibilities:
/// - Fetch activity data from Odoo using dynamic filters.
/// - Maintain a graph-friendly dataset for visualization.
/// - Handle search, stage, and date filters.
/// - Provide color coding for activity states.
class ActivityDataProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Map<dynamic, dynamic>> activityData = [];
  List<String> activityNames = [];
  final Map<String, Color> activityStateColors = {
    "overdue": Colors.red,
    "today": Colors.orange,
    "planned": const Color(0xFF43B75D),
  };
  bool isAdmin = false;
  int selectedViewIndex = 1;

  int _currentPage = 0;
  final int _limit = 40;
  int _totalCount = 0;
  bool _hasMoreData = false;

  int get currentPage => _currentPage;
  int get limit => _limit;
  int get totalCount => _totalCount;
  bool get hasMoreData => _hasMoreData;

  bool get hasPreviousPage => _currentPage > 0;
  bool get hasNextPage => (_currentPage + 1) * _limit < _totalCount;

  int get totalPages => (_totalCount / _limit).ceil();

  int get startRecord => _totalCount == 0 ? 0 : (_currentPage * _limit) + 1;

  int get endRecord {
    if (_totalCount == 0) return 0;
    return ((_currentPage + 1) * _limit > _totalCount
        ? _totalCount
        : (_currentPage + 1) * _limit);
  }

  List<Map<String, dynamic>> viewItems = [
    {
      'icon': Icons.vertical_distribute_rounded,
      'label': 'List',
    },
    {
      'icon': Icons.view_kanban,
      'label': 'Kanban',
    },
    {
      'icon': Icons.bar_chart,
      'label': 'Graph',
    },
    {
      'icon': Icons.calendar_month,
      'label': 'Calendar',
    },
    {
      'icon': Icons.access_time,
      'label': 'Schedule',
    },
  ];

  void updateViewIndex(int index) {
    selectedViewIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
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

  /// Delete activity.
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

      activityData.removeWhere((lead) => lead['id'] == id);

      notifyListeners();
    } catch (_) {}
  }

  String selectedFilter = "Count";
  int selectedIndexActivity = 0;
  List<Map<String, dynamic>> activityGraphData = [];
  TextEditingController searchController = TextEditingController();

  /// Fetches activity data from Odoo and processes it for display.
  ///
  /// Supports a wide variety of filters:
  /// - Date filters (current month, past months)
  /// - Stage filters (lost, won, ongoing)
  /// - Activity filters (late, today, future, category)
  /// - Search text
  ///
  /// Populates both `activityData` and `activityGraphData` for visualization.
  Future<void> getActivityData({
    BuildContext? context,
    bool dateFiltersClose = false,
    bool filter = true,
    bool dateFilters = false,
    bool stageFilters = false,
    bool unAssigned = false,
    bool partnerAssigned = false,
    bool myActivities = true,
    bool lost = false,
    bool monthNow = false,
    bool beforeMonth = false,
    bool beforeTwoMonth = false,
    bool beforeMonthClose = false,
    bool beforeTwoMonthClose = false,
    bool monthNowClose = false,
    bool lateActivity = false,
    bool todayActivity = false,
    bool futureActivity = false,
    bool activityCategoryFilter = false,
    String searchText = "",
    bool resetPagination = true,
  }) async {
    isLoading = true;
    final clientProvider =
        Provider.of<OdooClientManager>(context!, listen: false);

    if (resetPagination) {
      _currentPage = 0;
    }

    activityData.clear();
    activityGraphData.clear();

    List<dynamic> filters = [];
    if (myActivities) {
      filters.add(
          ['activity_user_id', '=', clientProvider.currentsession!.userId]);
    } else {
      filters.add(['activity_user_id', '!=', false]);
    }

    List<dynamic> dataFilterList = CustomFilters().getLeadDataFilter(
      leadfilter: filter,
      myactivities: false,
      unAssigned: unAssigned,
      partnerassigned: partnerAssigned,
    );
    filters = [...filters, ...dataFilterList];

    List<dynamic> stageFiltersList = CustomFilters().getStageFilters(
      stagefilters: stageFilters,
      lost: lost,
      won: false,
      onGoing: false,
    );

    filters = [...filters, ...stageFiltersList];

    List<dynamic> allDateFilterList = CustomFilters().getLeadDateFilters(
      leaddatefilters: dateFilters,
      leadmonthNow: monthNow,
      leadbeforeMonth: beforeMonth,
      leadbeforetwoMonth: beforeTwoMonth,
    );

    List<dynamic> allDateFilterListClose =
        CustomFilters().getLeadDateFiltersClose(
      leaddatefiltersclose: dateFiltersClose,
      leadmonthNowclose: monthNowClose,
      leadbeforeMonthclose: beforeMonthClose,
      leadbeforetwoMonthclose: beforeTwoMonthClose,
    );

    List<dynamic> mergeDateFilters = CustomFilters().mergeDateFilters(
      leadDateFilterExpected: [],
      leaddatefilterExpected: false,
      leaddatefilters: dateFilters,
      leaddatefiltersclose: dateFiltersClose,
      leadDateFilters: allDateFilterList,
      leadDateFiltersClose: allDateFilterListClose,
    );

    filters = [...filters, ...mergeDateFilters];

    List activityFilter = CustomFilters().getActivityFilters(
      activitycatgoryfilter: activityCategoryFilter,
      lateactivity: lateActivity,
      todayactivity: todayActivity,
      futureactivity: futureActivity,
    );

    filters = [...filters, ...activityFilter];

    if (searchText.isNotEmpty) {
      filters.add('|');
      filters.add(['name', 'ilike', '%$searchText']);
      filters.add(['team_id', 'ilike', '%$searchText']);
    }

    try {
      final countResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'search_count',
        'args': [filters],
        'kwargs': {},
      });

      _totalCount = countResponse as int? ?? 0;
      _hasMoreData = (_currentPage + 1) * _limit < _totalCount;

      final detailsRaw = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'search_read',
        'args': [filters],
        'kwargs': {
          'limit': _limit,
          'offset': _currentPage * _limit,
          'fields': [
            'name',
            'create_date',
            'stage_id',
            'email_from',
            'city',
            'type',
            'country_id',
            'team_id',
            'user_id',
            'activity_date_deadline',
            'activity_ids',
            'activity_type_id',
            'activity_state',
            'activity_user_id',
            'probability',
            'partner_id',
            'company_currency',
            'expected_revenue',
            'partner_name',
            'street',
            'contact_name',
            'email_cc',
            'function',
            'phone',
            'mobile',
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
          ],
        },
      });

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
      }

      if (detailsRaw != null && detailsRaw is List) {
        final details = detailsRaw.map((lead) {
          return lead.map(
              (key, value) => MapEntry(key, value == false ? null : value));
        }).toList();

        if (details.isNotEmpty) {
          List<Map<dynamic, dynamic>> updatedDetails = [];

          for (var detail in details) {
            detail['user_image'] = null;
            updatedDetails.add(detail);
          }

          activityData = updatedDetails;

          List<LeadCrmModel> leads = detailsRaw.map<LeadCrmModel>((lead) {
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

          activityGraphData = stageCounts.entries.map((e) {
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

          isLoading = false;
          notifyListeners();
        } else {
          isLoading = false;
          notifyListeners();
        }
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Applies a filter to the activity graph.
  void applyFilter(String filter) {
    selectedFilter = filter;
    updateStageData();
    notifyListeners();
  }

  /// Updates stage data ordering based on the selected filter.
  ///
  /// Supported filters: Count, Days to Close, Expected Revenue, Expected MRR,
  /// Probability, Prorated MRR, Prorated Recurring Revenue, Prorated Revenue, Recurring Revenue
  void updateStageData() {
    Map<String, String> filterKeyMap = {
      'Count': "count",
      'Days to Close': 'total_day_close',
      'Expected Revenue': 'total_expected_revenue',
      'Expected MRR': 'recurring_revenue_monthly',
      'Probability': 'probability',
      'Prorated MRR': 'recurring_revenue_monthly_prorated',
      'Prorated Recurring Revenue': 'recurring_revenue_prorated',
      'Prorated Revenue': 'prorated_revenue',
      'Recurring Revenue': 'recurring_revenue',
    };

    String dataKey = filterKeyMap[selectedFilter] ?? '';

    List<Map<String, dynamic>> stageDataToSort;
    stageDataToSort = activityGraphData;
    if (dataKey.isNotEmpty) {
      stageDataToSort.sort((a, b) {
        var valueA = a[dataKey] ?? 0;
        var valueB = b[dataKey] ?? 0;
        return valueA.compareTo(valueB);
      });
    }
  }

  /// Go to next pagination page
  Future<void> goToNextPage({
    required BuildContext context,
    bool myActivities = true,
    bool monthNowClose = false,
    bool beforeMonthClose = false,
    bool beforeTwoMonthClose = false,
    bool monthNow = false,
    bool beforeMonth = false,
    bool beforeTwoMonth = false,
    bool dateFilters = false,
    bool dateFiltersClose = false,
    bool lateActivity = false,
    bool todayActivity = false,
    bool futureActivity = false,
    bool unAssigned = false,
    bool partnerAssigned = false,
    bool stageFilters = false,
    bool lost = false,
    bool activityCategoryFilter = false,
  }) async {
    if (!hasNextPage || isLoading) return;

    _currentPage++;
    await getActivityData(
      context: context,
      searchText: searchController.text,
      myActivities: myActivities,
      monthNowClose: monthNowClose,
      beforeMonthClose: beforeMonthClose,
      beforeTwoMonthClose: beforeTwoMonthClose,
      monthNow: monthNow,
      beforeMonth: beforeMonth,
      beforeTwoMonth: beforeTwoMonth,
      dateFilters: dateFilters,
      dateFiltersClose: dateFiltersClose,
      lateActivity: lateActivity,
      todayActivity: todayActivity,
      futureActivity: futureActivity,
      unAssigned: unAssigned,
      partnerAssigned: partnerAssigned,
      stageFilters: stageFilters,
      lost: lost,
      activityCategoryFilter: activityCategoryFilter,
      resetPagination: false,
    );
  }

  /// Go to previous pagination page
  Future<void> goToPreviousPage({
    required BuildContext context,
    bool myActivities = true,
    bool monthNowClose = false,
    bool beforeMonthClose = false,
    bool beforeTwoMonthClose = false,
    bool monthNow = false,
    bool beforeMonth = false,
    bool beforeTwoMonth = false,
    bool dateFilters = false,
    bool dateFiltersClose = false,
    bool lateActivity = false,
    bool todayActivity = false,
    bool futureActivity = false,
    bool unAssigned = false,
    bool partnerAssigned = false,
    bool stageFilters = false,
    bool lost = false,
    bool activityCategoryFilter = false,
  }) async {
    if (!hasPreviousPage || isLoading) return;

    _currentPage--;
    await getActivityData(
      context: context,
      searchText: searchController.text,
      myActivities: myActivities,
      monthNowClose: monthNowClose,
      beforeMonthClose: beforeMonthClose,
      beforeTwoMonthClose: beforeTwoMonthClose,
      monthNow: monthNow,
      beforeMonth: beforeMonth,
      beforeTwoMonth: beforeTwoMonth,
      dateFilters: dateFilters,
      dateFiltersClose: dateFiltersClose,
      lateActivity: lateActivity,
      todayActivity: todayActivity,
      futureActivity: futureActivity,
      unAssigned: unAssigned,
      partnerAssigned: partnerAssigned,
      stageFilters: stageFilters,
      lost: lost,
      activityCategoryFilter: activityCategoryFilter,
      resetPagination: false,
    );
  }
}
