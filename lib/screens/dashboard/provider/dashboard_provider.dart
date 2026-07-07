import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobo_crm/global_methods/widgets/custom_filters.dart';

import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/models.dart';

import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/company/session/company_session_manager.dart';
import '../../../models/LoginPage/session_model.dart';
import '../../../services/storage_service.dart';

/// Provider responsible for managing dashboard state and CRM analytics data.
///
/// Handles:
/// - Forecast reports (pipeline & opportunities)
/// - CRM stage analytics
/// - Activity reports
/// - Graph loading states
/// - User profile image storage
/// - Dashboard filter & tab state management
///
/// Integrates with:
/// - [CompanySessionManager] for Odoo RPC calls
/// - [StorageService] for account persistence
/// - [CustomFilters] for dynamic domain filtering
///
/// Notifies listeners when dashboard data or UI state changes.
class DashboardProvider extends ChangeNotifier {
  int selectedTabIndex = 0;
  int selectedIndexlead = 0;
  int selectedIndexforecast = 0;

  bool isloading = false;
  bool isgraphLoading = true;

  int? userId;
  String url = "";
  List<Map<dynamic, dynamic>> _forecastreport = [];

  List<Map<dynamic, dynamic>> get forecastreport => _forecastreport;
  List<Map<String, dynamic>> _stageData = [];

  List<Map<String, dynamic>>? get stageData => _stageData;

  List<Map<String, dynamic>> _forecastData = [];

  List<Map<String, dynamic>>? get forecastData => _forecastData;
  List<Map<String, dynamic>> _activityData = [];

  List<Map<String, dynamic>>? get activityData => _activityData;
  String selectedFilter = 'Count';
  List<Map<dynamic, dynamic>> _activityReport = [];

  List<Map<dynamic, dynamic>> get activityReport => _activityReport;

  /// Initializes dashboard state.
  ///
  /// - Validates login status from SharedPreferences
  /// - Loads user profile image
  /// - Stores account details with image locally
  ///
  /// Returns:
  /// - `true` if initialization succeeds
  /// - `false` if an error occurs
  Future<bool> init(
    BuildContext context,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      if (prefs.getBool('isLoggedIn') ?? false) {
        if (context.mounted) {
          final userId = prefs.getInt('userId') ?? 0;
          if (userId != null) {
            await storeAccountWithImage(userId: userId);
          }

          notifyListeners();
        }
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  /// Resets the selected dashboard metric filter to "Count".
  ///
  /// Used as the default sorting/filter metric.
  void setFiltertoCount() {
    selectedFilter = 'Count';
  }

  /// Fetches user profile details from Odoo.
  ///
  /// Parameters:
  /// - [userId] The logged-in user's ID.
  ///
  /// Returns:
  /// - Map containing user image, name, and email
  /// - null if request fails
  Future<Map<String, dynamic>?> getUserProfile(int userId) async {
    try {
      final details = [
        'image_1920',
        'name',
        'email',
      ];

      final userDetails = await CompanySessionManager.callKwWithCompany({
        'model': 'res.users',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', userId],
          ],
        ],
        'kwargs': {'fields': details},
      });

      return userDetails?.isNotEmpty == true ? userDetails[0] : null;
    } catch (e) {
      return null;
    }
  }

  /// Updates locally stored account information with
  /// the latest profile image and user details.
  ///
  /// Parameters:
  /// - [userId] The user whose account needs updating.
  ///
  /// Stores:
  /// - image (base64)
  /// - name
  /// - email
  Future<void> storeAccountWithImage({
    required int userId,
  }) async {
    try {
      final storageService = StorageService();

      final userDetails = await getUserProfile(userId);
      if (userDetails == null) return;

      final imageBase64 = userDetails['image_1920'];
      if (imageBase64 == null) return;

      final currentAccounts = await storageService.getAccounts();

      final existing = currentAccounts.firstWhere(
        (a) => a['userId'] == userId,
        orElse: () => {},
      );

      if (existing.isEmpty) return;

      final accountWithImage = {
        ...existing,
        'image': imageBase64,
        'name': userDetails['name'],
        'email': userDetails['email'],
      };

      await storageService.saveAccount(accountWithImage);
    } catch (_) {}
  }

  /// Initializes forecast report data.
  ///
  /// - Resets filter to default ("Count")
  /// - Fetches grouped forecast report
  /// - Loads upcoming closing opportunities
  Future<void> initForecast(BuildContext context) async {
    if (context.mounted) {
      setFiltertoCount();
      final odooClientManager =
          Provider.of<OdooClientManager>(context, listen: false);

      await getGroupedForecastReport(
          isPipeline: true,
          upcomingClosing: true,
          client: odooClientManager.client!,
          session: odooClientManager.currentsession!);
    }
  }

  /// Initializes activity report data for the dashboard.
  ///
  /// Fetches activity analytics from Odoo.
  Future<void> initActivity(BuildContext context) async {
    final odooClientManager =
        Provider.of<OdooClientManager>(context, listen: false);
    await getActivityReport(
      client: odooClientManager.client!,
    );
  }

  /// Returns the first date of the current month
  /// formatted as `yyyy-MM-dd`.
  String firstDateOfCurrentMonth() {
    DateTime now = DateTime.now();
    DateTime firstDay = DateTime(now.year, now.month, 1);
    return firstDay.toIso8601String().split('T')[0];
  }

  /// Fetches grouped forecast report data from Odoo.
  ///
  /// Supports multiple filtering options:
  /// - Pipeline ownership filters
  /// - Stage filters (Won, Lost, Ongoing)
  /// - Date filters (creation, closing)
  /// - Opportunity type filters
  /// - Upcoming closing filter
  ///
  /// Processes response into:
  /// - [_forecastreport] (raw lead data)
  /// - [_forecastData] (aggregated monthly analytics)
  ///
  /// Notifies listeners after completion.
  Future<void> getGroupedForecastReport(
      {OdooClient? client,
      SessionModel? session,
      bool toogglepipeline = false,
      bool pipelinefilters = true,
      bool unAssigned = false,
      bool partnerassigned = false,
      bool opeopportunity = false,
      bool stagefilters = false,
      bool won = false,
      bool lost = false,
      bool ongoing = false,
      bool datefilters = false,
      bool monthNow = false,
      bool beforeMonth = false,
      bool beforetwoMonth = false,
      bool datefilterclose = false,
      bool monthNowclose = false,
      bool beforeMonthclose = false,
      bool beforetwoMonthclose = false,
      bool isPipeline = true,
      bool upcomingClosing = true}) async {
    isloading = true;
    isgraphLoading = true;
    final firsday = firstDateOfCurrentMonth();
    _forecastreport.clear();

    List<dynamic> filters = [
      ['type', '=', 'opportunity'],
    ];

    if (pipelinefilters) {
      List filterspipeline = [];

      if (isPipeline == true) {
        filterspipeline.add('|');

        filterspipeline.add(['user_id', '=', session!.userId]);
      }

      if (unAssigned) {
        filterspipeline.add('|');

        filterspipeline.add(["user_id", "=", false]);
      }
      if (partnerassigned) {
        filterspipeline.add('|');

        filterspipeline
            .add(["partner_assigned_id.user_id", "=", session!.userId]);
      }

      final List<dynamic> open = [];
      if (opeopportunity) {
        open.add("&");
        open.add("&");
        open.add(
          ["probability", "<", 100],
        );

        open.add(["active", "=", true]);
        open.add(['type', '=', 'opportunity']);
        filterspipeline = [...filterspipeline, ...open];
      }

      if (filterspipeline.length >= 2 && opeopportunity == false) {
        filterspipeline.removeAt(filterspipeline.length - 2);
      }
      filters = [...filters, ...filterspipeline];
    }

    final List stage = CustomFilters().getStageFilters(
        stagefilters: stagefilters, lost: lost, won: won, onGoing: ongoing);

    filters = [...filters, ...stage];

    final List dateFilterList = CustomFilters().getLeadDateFilters(
        leaddatefilters: datefilters,
        leadmonthNow: monthNow,
        leadbeforeMonth: beforeMonth,
        leadbeforetwoMonth: beforetwoMonth);
    final List dateFilterCloseList = CustomFilters().getLeadDateFiltersClose(
        leaddatefiltersclose: datefilterclose,
        leadmonthNowclose: monthNowclose,
        leadbeforeMonthclose: beforeMonthclose,
        leadbeforetwoMonthclose: beforetwoMonthclose);
    final List alldatefilter = CustomFilters().mergeDateFilters(
        leaddatefilters: datefilters,
        leaddatefiltersclose: datefilterclose,
        leaddatefilterExpected: false,
        leadDateFilters: dateFilterList,
        leadDateFilterExpected: [],
        leadDateFiltersClose: dateFilterCloseList);
    filters = [...filters, ...alldatefilter];

    if (upcomingClosing) {
      filters.add("|");
      filters.add(
        ["date_deadline", "=", false],
      );
      filters.add(
        ["date_deadline", ">=", firsday],
      );
    }

    try {
      final forecastResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'search_read',
        'args': [filters],
        'kwargs': {
          'fields': [
            'id',
            'name',
            'user_id',
            'date_deadline',
            'stage_id',
            'expected_revenue',
            'create_date',
            'email_from',
            'city',
            'country_id',
            'team_id',
            'type',
            'activity_date_deadline',
            'activity_ids',
            'activity_type_id',
            'activity_state',
            'activity_user_id',
            'probability',
            'partner_id',
            'partner_name',
            'street',
            'contact_name',
            'email_cc',
            'function',
            'phone',
            'mobile',
            'priority',
            'tag_ids',
            'prorated_revenue',
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
          ],
        },
      });

      if (forecastResponse != null && forecastResponse is List) {
        final forecastdetails = forecastResponse.map((lead) {
          return lead.map(
              (key, value) => MapEntry(key, value == false ? null : value));
        }).toList();

        if (forecastdetails.isNotEmpty) {
          List<Map<dynamic, dynamic>> updatedforecast = [];

          for (var forecast in forecastdetails) {
            forecast['user_image'] = null;

            updatedforecast.add(forecast);
          }

          _forecastreport = updatedforecast;
          List<ForecastModel> forecasts = forecastResponse
              .map((data) {
                try {
                  return ForecastModel.fromJson(data);
                } catch (e) {
                  return null;
                }
              })
              .whereType<ForecastModel>()
              .toList();

          Map<String, int> dateCounts = {};
          Map<String, double> dateExpectedRevenue = {};
          Map<String, double> dateProratedRevenue = {};

          for (var forecast in forecasts) {
            String? deadline = forecast.dateDeadline;
            String groupKey;

            if (deadline == null || deadline == "false") {
              groupKey = "None";
            } else {
              try {
                DateTime parsedDate = DateTime.parse(deadline);
                groupKey = DateFormat('MMMM yyyy').format(parsedDate);
              } catch (e) {
                groupKey = "Invalid Date";
              }
            }

            dateCounts[groupKey] = (dateCounts[groupKey] ?? 0) + 1;
            dateExpectedRevenue[groupKey] =
                (dateExpectedRevenue[groupKey] ?? 0) + forecast.expectedRevenue;
            dateProratedRevenue[groupKey] =
                (dateProratedRevenue[groupKey] ?? 0) + forecast.proratedRevenue;
          }

          _forecastData = dateCounts.entries.map((e) {
            return {
              'month': e.key,
              'count': e.value,
              'total_expected_revenue': dateExpectedRevenue[e.key] ?? 0,
              'prorated_revenue': dateProratedRevenue[e.key] ?? 0,
            };
          }).toList();

          _forecastData.sort((a, b) {
            if (a['month'] == "None") return -1;
            if (b['month'] == "None") return 1;
            return DateFormat('MMMM yyyy')
                .parse(a['month'])
                .compareTo(DateFormat('MMMM yyyy').parse(b['month']));
          });
        }
      } else {
        _forecastreport = [];
        _forecastData = [];
        notifyListeners();
      }

      isloading = false;
      isgraphLoading = false;

      notifyListeners();
      updateStageData();
    } catch (e) {
      isloading = false;
      notifyListeners();
    }
  }

  /// Fetches CRM activity report data.
  ///
  /// Supports:
  /// - Date range filtering
  /// - Lead/Opportunity filtering
  /// - Won stage filtering
  /// - Completion month filtering
  ///
  /// Aggregates activity counts grouped by month
  /// and stores result in [_activityData].
  Future<void> getActivityReport(
      {OdooClient? client,
      bool trial12Months = true,
      bool isLead = false,
      bool isWon = false,
      bool currentMonth = false,
      bool previousMonth = false,
      bool twoMonthsbefore = false,
      bool isOpportunity = false}) async {
    isgraphLoading = true;
    isloading = true;
    _activityReport.clear();
    DateTime now = DateTime.now();
    String oneYearAgo = DateFormat("yyyy-MM-dd HH:mm:ss")
        .format(now.subtract(Duration(days: 365)));
    String todayEnd = DateFormat("yyyy-MM-dd HH:mm:ss")
        .format(DateTime(now.year, now.month, now.day, 23, 59, 59));
    List<dynamic> filter = [];

    if (trial12Months) {
      filter.add("&");
      filter.add(
        ["date", ">=", oneYearAgo],
      );
      filter.add(["date", "<=", todayEnd]);
    }

    if (isLead || isOpportunity) {
      if (isLead && isOpportunity == false) {
        filter.add(['lead_type', '=', 'lead']);
      } else if (isOpportunity && isLead == false) {
        filter.add(['lead_type', '=', 'opportunity']);
      } else if (isLead && isOpportunity) {
        filter.add("|");
        filter.add(['lead_type', '=', 'lead']);
        filter.add(['lead_type', '=', 'opportunity']);
      }
    }

    if (isWon) {
      filter.add("&");
      filter.add(["active", "=", true]);
      filter.add(["stage_id.is_won", "=", true]);
    }

    final List completionDateFilter = CustomFilters().getActivityCompletion(
        currentMonth: currentMonth,
        prevoiusMonth: previousMonth,
        twoMonthsbefore: twoMonthsbefore);

    filter = [...filter, ...completionDateFilter];

    try {
      final activitydetails = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.activity.report',
        'method': 'search_read',
        'args': [filter],
        'kwargs': {
          'fields': [
            'date',
            'author_id',
            'mail_activity_type_id',
            'company_id',
            'tag_ids'
          ]
        }
      });

      if (activitydetails != null && activitydetails is List) {
        final active = activitydetails.map((activity) {
          return activity.map(
              (key, value) => MapEntry(key, value == false ? null : value));
        }).toList();

        if (active.isNotEmpty) {
          List<Map<dynamic, dynamic>> updatedactivity = [];

          for (var activity in active) {
            updatedactivity.add(activity);
          }

          _activityReport = updatedactivity;

          notifyListeners();
        }
      }

      Map<String, int> activityCount = {};

      for (var activity in activitydetails) {
        String formattedMonth = _formatDate(activity['date']);
        activityCount[formattedMonth] =
            (activityCount[formattedMonth] ?? 0) + 1;
      }

      List<Map<String, dynamic>> processedActivityData =
          activityCount.entries.map((entry) {
        return {"month": entry.key, "count": entry.value};
      }).toList();

      _activityData = processedActivityData;
      isgraphLoading = false;
      isloading = false;
      notifyListeners();
    } catch (e) {
      isgraphLoading = false;
      isloading = false;
      notifyListeners();
    } finally {
      isgraphLoading = false;
      isloading = false;
      notifyListeners();
    }
  }

  /// Formats a date string into `Month Year` format.
  ///
  /// Returns:
  /// - Formatted string (e.g., "January 2026")
  /// - "None" if null
  /// - "Invalid Date" if parsing fails
  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return "None";
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat.yMMMM().format(parsedDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  /// Fetches CRM lead analytics grouped by month.
  ///
  /// Calculates:
  /// - Lead count
  /// - Days to close
  /// - Expected revenue
  /// - Recurring revenue
  /// - Probability
  /// - Prorated values
  ///
  /// Stores processed data in [_stageData]
  /// and sorts it chronologically.
  Future<void> getLeadCrmReport(OdooClient client, SessionModel session) async {
    isgraphLoading = true;
    _stageData.clear();
    try {
      final leadDetails = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'search_read',
        'args': [
          [
            "|",
            ["active", "=", true],
            ["active", "=", false],
            "&",
            ["create_date", ">=", "2024-12-31 18:30:00"],
            ["create_date", "<=", "2025-12-31 18:29:59"]
          ]
        ],
        'kwargs': {
          'fields': [
            'id',
            'create_date',
            'stage_id',
            'day_close',
            'expected_revenue',
            'recurring_revenue_monthly',
            'probability',
            'recurring_revenue_monthly_prorated',
            'recurring_revenue_prorated',
            'prorated_revenue',
            'recurring_revenue',
            'city',
          ],
        },
      });

      if (leadDetails != null && leadDetails.isNotEmpty) {
        List<LeadCrmModel> leads = leadDetails.map<LeadCrmModel>((lead) {
          return LeadCrmModel.fromJson(Map<String, dynamic>.from(lead));
        }).toList();

        Map<String, int> dateCounts = {};
        Map<String, num> dateDayCloseTotal = {};
        Map<String, num> dateExpectedRevenue = {};
        Map<String, num> dateRecurringRevenueMonthly = {};
        Map<String, num> dateProbability = {};
        Map<String, num> dateRecurringRevenueMonthlyProrated = {};
        Map<String, num> dateRecurringRevenueProrated = {};
        Map<String, num> dateProratedRevenue = {};
        Map<String, num> dateRecurringRevenue = {};

        for (var lead in leads) {
          String groupKey = DateFormat('MMMM yyyy').format(lead.createDate);
          dateCounts[groupKey] = (dateCounts[groupKey] ?? 0) + 1;
          dateDayCloseTotal[groupKey] =
              (dateDayCloseTotal[groupKey] ?? 0) + lead.dayClose;
          dateExpectedRevenue[groupKey] =
              (dateExpectedRevenue[groupKey] ?? 0) + lead.expectedRevenue;
          dateRecurringRevenueMonthly[groupKey] =
              (dateRecurringRevenueMonthly[groupKey] ?? 0) +
                  lead.recurringRevenueMonthly;
          dateProbability[groupKey] =
              (dateProbability[groupKey] ?? 0) + lead.probability;
          dateRecurringRevenueMonthlyProrated[groupKey] =
              (dateRecurringRevenueMonthlyProrated[groupKey] ?? 0) +
                  lead.recurringRevenueMonthlyProrated;
          dateRecurringRevenueProrated[groupKey] =
              (dateRecurringRevenueProrated[groupKey] ?? 0) +
                  lead.recurringRevenueProrated;
          dateProratedRevenue[groupKey] =
              (dateProratedRevenue[groupKey] ?? 0) + lead.proratedRevenue;
          dateRecurringRevenue[groupKey] =
              (dateRecurringRevenue[groupKey] ?? 0) + lead.recurringRevenue;
        }
        _stageData = dateCounts.entries.map((e) {
          return {
            'month': e.key,
            'count': e.value,
            'total_day_close': dateDayCloseTotal[e.key] ?? 0,
            'total_expected_revenue': dateExpectedRevenue[e.key] ?? 0,
            'recurring_revenue_monthly':
                dateRecurringRevenueMonthly[e.key] ?? 0,
            'probability': dateProbability[e.key] ?? 0,
            'recurring_revenue_monthly_prorated':
                dateRecurringRevenueMonthlyProrated[e.key] ?? 0,
            'recurring_revenue_prorated':
                dateRecurringRevenueProrated[e.key] ?? 0,
            'prorated_revenue': dateProratedRevenue[e.key] ?? 0,
            'recurring_revenue': dateRecurringRevenue[e.key] ?? 0,
          };
        }).toList();

        _stageData.sort((a, b) {
          return DateFormat('MMMM yyyy')
              .parse(a['month'])
              .compareTo(DateFormat('MMMM yyyy').parse(b['month']));
        });

        isgraphLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isgraphLoading = false;
      notifyListeners();
    }
  }

  /// Applies a dashboard metric filter.
  ///
  /// Example filters:
  /// - "Count"
  /// - "Expected Revenue"
  /// - "Probability"
  ///
  /// Re-sorts stage data based on selected metric.
  void applyFilter(String filter) {
    selectedFilter = filter;
    updateStageData();
    notifyListeners();
  }

  /// Updates and sorts stage/forecast data
  /// based on the currently selected filter metric.
  ///
  /// Determines correct dataset based on:
  /// - selectedTabIndex
  ///
  /// Sorts data in ascending order of selected metric.
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
    switch (selectedTabIndex) {
      case 0:
        stageDataToSort = _stageData;
        break;
      case 1:
        stageDataToSort = [];
        break;
      case 2:
        stageDataToSort = _forecastData;
        break;
      default:
        stageDataToSort = _stageData;
    }

    if (dataKey.isNotEmpty) {
      stageDataToSort.sort((a, b) {
        var valueA = a[dataKey] ?? 0;
        var valueB = b[dataKey] ?? 0;
        return valueA.compareTo(valueB);
      });
    }
  }

  /// Resets dashboard provider state.
  ///
  /// Clears:
  /// - Selected tabs
  /// - Loading states
  /// - Forecast data
  /// - Stage data
  /// - Activity data
  /// - Selected filter
  ///
  /// Notifies listeners after reset.
  void clear() {
    selectedTabIndex = 0;
    selectedIndexlead = 0;
    selectedIndexforecast = 0;
    isloading = false;
    isgraphLoading = true;
    userId = null;
    url = "";

    _forecastreport.clear();
    _stageData.clear();
    _forecastData.clear();
    _activityData.clear();
    _activityReport.clear();

    selectedFilter = 'Count';

    notifyListeners();
  }

  @override
  void dispose() {
    clear();
    super.dispose();
  }
}
