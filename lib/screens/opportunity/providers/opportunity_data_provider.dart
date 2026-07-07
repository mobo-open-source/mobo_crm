import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/services/isar_caching_service.dart';
import 'package:mobo_crm/global_methods/widgets/custom_filters.dart';
import 'package:mobo_crm/global_methods/widgets/group_by_dropdown.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/models.dart';
import 'package:mobo_crm/global_methods/services/global_error_handler.dart';
import 'package:mobo_crm/screens/opportunity/isar/opportunity_model_isar_cache.dart';
import 'package:mobo_crm/screens/opportunity/isar/opportunity_model_isar_graph.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/company/services/company_session_service.dart';
import '../../../core/company/session/company_session_manager.dart';
import '../../../services/app_install_check.dart';
import '../../../utils/snackbar.dart';

/// A provider class that manages opportunity data in the CRM system.
///
/// Handles fetching opportunities from Odoo, caching with Isar, filtering,
/// grouping, pagination, and updating stages. Also provides utilities to
/// calculate aggregated metrics like total revenue or probability.
class OpportunityDataProvider extends ChangeNotifier {
  final CompanySessionService sessionService;

  OpportunityDataProvider({required this.sessionService});

  List<Map<dynamic, dynamic>> opportunities = [];
  String _lastSearchText = '';
  bool isSearching = false;
  bool isLoading = false;
  bool isIsarDataLoaded = false;
  AppError? catchError;
  bool hasError = false;
  TextEditingController searchController = TextEditingController();
  int selectedViewIndex = 0;

  List<Map<String, dynamic>> viewItems = [
    {
      'icon': Icons.view_kanban,
      'label': 'Kanban',
    },
    {
      'icon': Icons.menu,
      'label': 'List',
    },
    {
      'icon': Icons.calendar_month,
      'label': 'Calendar',
    },
    {
      'icon': Icons.bar_chart,
      'label': 'Graph',
    },
    {
      'icon': Icons.access_time,
      'label': 'Activity',
    },
  ];

  void updateViewIndex(int index) {
    selectedViewIndex = index;
    notifyListeners();
  }

  List<Map<String, dynamic>> _stageOpportunityData = [];

  List<Map<String, dynamic>>? get stageOpportunityData => _stageOpportunityData;

  List<Map<String, dynamic>> selectedCRMTags = [];
  int? selectedPriority;
  int selectedindexpipeline = 0;
  final int limit = 40;
  bool hasMoreData = true;
  int offset = 0;
  int _currentPage = 0;
  int _totalCount = 0;
  List lastFilter = [];
  List<String> activityNames = [];
  List<Map<String, dynamic>> crmStages = [];
  List<String> _selectedFilters = [];

  List<String> get selectedFilters => _selectedFilters;
  bool filterWon = false;
  bool filterLost = false;
  bool filterOngoing = false;
  bool filterCurrentMonth = false;

  bool isAdmin = false;

  /// Resets all filters and search inputs.
  void resetAllFilters() {
    filterWon = false;
    filterLost = false;
    filterOngoing = false;
    filterCurrentMonth = false;

    _selectedFilters = [];
    selectedCRMTags.clear();
    selectedPriority = null;
    _currentGroupBy = GroupByOption.none;
    searchController.clear();
    isSearching = false;
    resetPagination();

    notifyListeners();
  }

  /// Updates selected filters and resets pagination.
  void setSelectedFilters(List<String> filters) {
    _selectedFilters = List.unmodifiable(filters);
    resetPagination();
    notifyListeners();
  }

  /// Clears filters, optionally reloads opportunities.
  void clearFilters({bool reload = true, BuildContext? context}) async {
    resetAllFilters();

    if (reload && context != null) {
      isLoading = true;
      notifyListeners();
      await getOpportunities(
        context: context,
        isOpportunity: true,
        isLead: false,
        loading: true,
      );
    }
  }

  /// Maps technical group names to enum values.
  static const Map<String, GroupByOption> groupTechnicalNames = {
    'Stage': GroupByOption.stage,
    'Salesperson': GroupByOption.salesperson,
    'Team': GroupByOption.team,
    'Priority': GroupByOption.priority,
    'Customer': GroupByOption.partner,
    'Country': GroupByOption.country,
    'Creation Date': GroupByOption.createDate,
    'Expected Revenue': GroupByOption.expectedRevenue,
    'Probability': GroupByOption.probability,
  };

  /// Maps activity states to UI colors.
  final Map<String, Color> activityStateColors = {
    "overdue": Colors.red,
    "today": Colors.orange,
    "planned": const Color(0xFF43B75D),
  };

  Map<int, String> partnerCurrencySymbolMap = {};

  Map<int, String> get partnerSymbolMap => partnerCurrencySymbolMap;

  GroupByOption _currentGroupBy = GroupByOption.none;
  Map<String, List<Map<dynamic, dynamic>>> _groupedOpportunities = {};
  Map<String, bool> _groupExpansionState = {};

  GroupByOption get currentGroupBy => _currentGroupBy;

  Map<String, List<Map<dynamic, dynamic>>> get groupedOpportunities =>
      _groupedOpportunities;

  Map<String, bool> get groupExpansionState => _groupExpansionState;

  int get currentPage => _currentPage;

  int get totalCount => _totalCount;

  bool get hasPreviousPage => _currentPage > 0;

  bool get hasNextPage {
    if (_currentGroupBy != GroupByOption.none) {
      return false;
    }
    return (offset + opportunities.length) < _totalCount;
  }

  int get startRecord => offset + 1;

  int get endRecord {
    if (opportunities.isEmpty) return 0;
    return (offset + opportunities.length).clamp(0, _totalCount);
  }

  int get totalPages {
    if (_currentGroupBy != GroupByOption.none) {
      return (_groupedOpportunities.keys.length / limit).ceil();
    }
    return (_totalCount / limit).ceil();
  }

  int get currentPageNumber => _currentPage + 1;

  /// Sets the grouping option and applies grouping.
  void setGroupBy(GroupByOption groupBy) {
    _currentGroupBy = groupBy;
    _currentPage = 0;
    _applyGrouping();
    notifyListeners();
  }

  /// Toggles expansion state of a group.
  void toggleGroupExpansion(String groupKey) {
    _groupExpansionState[groupKey] = !(_groupExpansionState[groupKey] ?? true);
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

      final index = opportunities.indexWhere((e) => e['id'] == leadId);

      if (index != -1) {
        opportunities[index]['priority'] = newPriority.toString();
        notifyListeners();
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    searchController.dispose();
    _stageOpportunityData.clear();
    opportunities.clear();

    super.dispose();
  }

  /// Clears all opportunities and grouping data.
  void clearAll() {
    opportunities.clear();
    _groupedOpportunities.clear();
    _groupExpansionState.clear();
    _stageOpportunityData.clear();
    _currentPage = 0;
    _totalCount = 0;
    _selectedFilters.clear();
    searchController.clear();
    isLoading = false;
    hasError = false;
    catchError = null;
    _currentGroupBy = GroupByOption.none;
    resetAllFilters();
    resetPagination();

    notifyListeners();
  }

  /// Resets pagination values.
  void resetPagination() {
    offset = 0;
    _currentPage = 0;
    notifyListeners();
  }

  /// Initializes opportunity list.
  Future<void> initializeopportunitylist(
      BuildContext context, bool isCrm) async {
    await getOpportunities(
        context: context,
        isOpportunity: true,
        isLead: false,
        disablePagination: true);
  }

  /// Updates the selected pipeline index.
  void pipelineIndexChange(int index) {
    selectedindexpipeline = index;
    notifyListeners();
  }

  /// Fetches opportunities from Odoo with filters, pagination, and caching.
  Future<bool> getOpportunities({
    bool fromScroll = false,
    bool isPop = false,
    bool loading = false,
    BuildContext? context,
    bool isLead = false,
    bool isOpportunity = true,
    bool toogglepipeline = false,
    bool pipelinefilters = true,
    bool unAssigned = false,
    bool partnerassigned = false,
    bool opeopportunity = false,
    bool stagefilters = true,
    bool won = false,
    bool lost = false,
    OdooClient? rawclient,
    bool ongoing = false,
    bool datefilters = false,
    bool monthNow = false,
    bool beforeMonth = false,
    bool beforetwoMonth = false,
    bool datefilterclose = false,
    bool monthNowclose = false,
    bool beforeMonthclose = false,
    bool beforetwoMonthclose = false,
    String searchText = "",
    bool currentmonthExpected = false,
    bool monthbeforeExpected = false,
    bool monthbeforetwoExpected = false,
    bool showExpectedDate = false,
    List? customFilter,
    int? salespersinId,
    bool isPipeline = true,
    bool disablePagination = false,
  }) async {
    hasError = false;
    catchError = null;

    if (searchText.isEmpty && customFilter == null) {
      if (opportunities.isNotEmpty && !loading && _lastSearchText.isEmpty) {
        return true;
      }
      _lastSearchText = '';
      final bool hasCacheData = await getOpportunityDataFromIsar();
      if (hasCacheData && !loading) {
        isLoading = false;
        notifyListeners();
        return true;
      }
    }

    _lastSearchText = searchText;

    if (loading || opportunities.isEmpty) {
      isLoading = true;
      notifyListeners();
    }

    try {
      opportunities.clear();
      OdooClient? client;
      if (context == null) {
        client = rawclient;
      } else {
        client = await context.read<OdooClientManager>().ensureClient();
      }
      if (searchText.isEmpty) {
        opportunities.clear();
      }

      List<dynamic> filters = [];

      if (customFilter != null) {
        filters = customFilter;
      }

      if (isLead) {
        filters.add(['type', '=', 'lead']);
      }

      if (isOpportunity) {
        filters.add(['type', '=', 'opportunity']);
      }

      if (isOpportunity && isLead) {
        filters.clear();
        filters.add("|");
        filters.add(['type', '=', 'lead']);
        filters.add(['type', '=', 'opportunity']);
      }

      List filterspipeline = CustomFilters().getPipelineFilter(
          pipelinefilters: pipelinefilters,
          isPipeline: isPipeline,
          unAssigned: unAssigned,
          partnerassigned: partnerassigned,
          opeopportunity: opeopportunity,
          userId: client!.sessionId!.userId);

      filters = [...filters, ...filterspipeline];

      if (stagefilters) {
        List<dynamic> stage = CustomFilters().getStageFilters(
            stagefilters: stagefilters, lost: lost, won: won, onGoing: ongoing);

        filters = [...filters, ...stage];
      }
      List<dynamic> alldatefilterList = CustomFilters().getLeadDateFilters(
          leaddatefilters: datefilters,
          leadmonthNow: monthNow,
          leadbeforeMonth: beforeMonth,
          leadbeforetwoMonth: beforetwoMonth);
      List<dynamic> alldatefilterListClose = CustomFilters()
          .getLeadDateFiltersClose(
              leaddatefiltersclose: datefilterclose,
              leadmonthNowclose: monthNowclose,
              leadbeforeMonthclose: beforeMonthclose,
              leadbeforetwoMonthclose: beforetwoMonthclose);

      List<dynamic> filterExpectedDate = CustomFilters().getLeadExpectedClosing(
          expectedClosingBool: showExpectedDate,
          leadmonthNowexpected: currentmonthExpected,
          leadbeforeMonthexpected: monthbeforeExpected,
          leadbeforetwoexpected: monthbeforetwoExpected);

      List<dynamic> mergeDateFilters = CustomFilters().mergeDateFilters(
          leadDateFilterExpected: filterExpectedDate,
          leaddatefilterExpected: showExpectedDate,
          leaddatefilters: datefilters,
          leaddatefiltersclose: datefilterclose,
          leadDateFilters: alldatefilterList,
          leadDateFiltersClose: alldatefilterListClose);

      filters = [...filters, ...mergeDateFilters];
      if (salespersinId != null) {
        filters.add(['user_id', '=', salespersinId]);
      }

      filters.add(['stage_id', '!=', false]);

      if (searchText.isNotEmpty) {
        filters.add('|');
        filters.add(['name', 'ilike', '%$searchText']);
        filters.add(['team_id', 'ilike', '%$searchText']);
      }
      lastFilter = filters;
      List<String> fieldsToFetch = [
        'name',
        'phone',
        'mobile',
        'email_from',
        'city',
        'country_id',
        'team_id',
        'user_id',
        'probability',
        'partner_id',
        'priority',
        'tag_ids',
        'date_open',
        'date_closed',
        'activity_date_deadline',
        'activity_ids',
        'activity_type_id',
        'activity_state',
        'activity_user_id',
        'activity_summary',
        'expected_revenue',
        'prorated_revenue',
        'description',
        'contact_name',
        'active',
        'type',
        'create_date',
        'stage_id',
        'day_close',
        'recurring_revenue_monthly',
        'recurring_revenue_monthly_prorated',
        'recurring_revenue_prorated',
        'recurring_revenue',
        'date_deadline',
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

      int fetchLimit = disablePagination ? 0 : limit;
      int fetchOffset = disablePagination ? 0 : offset;

      if (_currentGroupBy != GroupByOption.none || disablePagination) {
        fetchLimit = 0;
        fetchOffset = 0;
      }

      dynamic opportunityDetailsRaw;
      try {
        opportunityDetailsRaw = await CompanySessionManager.callKwWithCompany({
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
        if (e.toString().contains('mobile')) {
          fieldsToFetch.remove('mobile');
          opportunityDetailsRaw =
              await CompanySessionManager.callKwWithCompany({
            'model': 'crm.lead',
            'method': 'search_read',
            'args': [filters],
            'kwargs': {
              'fields': fieldsToFetch,
              'limit': fetchLimit,
              'offset': fetchOffset,
            },
          });
        } else {
          rethrow;
        }
      }

      final opportunityCacheObjects = opportunityDetailsRaw
          .map((e) =>
              OpportunityModelIsarCache.fromJson(e.cast<String, dynamic>()))
          .toList()
          .cast<OpportunityModelIsarCache>();

      if (searchText.isEmpty) {
        await IsarService.saveOpportunitiesCache(opportunityCacheObjects);
      }

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

      final stageResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.stage',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name', 'sequence'],
          'order': 'sequence asc',
        },
      });
      if (stageResponse is List) {
        crmStages = List<Map<String, dynamic>>.from(stageResponse);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('crm_stages', json.encode(crmStages));
      }

      if (opportunityDetailsRaw != null && opportunityDetailsRaw is List) {
        final Set<int> uniquePartnerIds = {};
        for (final q in opportunityDetailsRaw) {
          if (q['partner_id'] is List && q['partner_id'].isNotEmpty) {
            uniquePartnerIds.add(q['partner_id'][0] as int);
          }
        }

        final isInstalled = await AppInstallCheck().isModuleInstalled('sale');
        if (isInstalled && uniquePartnerIds.isNotEmpty) {
          final partnerResponse =
              await CompanySessionManager.callKwWithCompany({
            'model': 'res.partner',
            'method': 'search_read',
            'args': [
              [
                ['id', 'in', uniquePartnerIds.toList()]
              ]
            ],
            'kwargs': {
              'fields': ['id', 'currency_id'],
            },
          });

          final Set<int> uniqueCurrencyIds = {};
          for (final p in partnerResponse) {
            if (p['currency_id'] is List && p['currency_id'].isNotEmpty) {
              uniqueCurrencyIds.add(p['currency_id'][0] as int);
            }
          }

          Map<int, String> currencyIdToSymbol = {};
          if (uniqueCurrencyIds.isNotEmpty) {
            final currencyResponse =
                await CompanySessionManager.callKwWithCompany({
              'model': 'res.currency',
              'method': 'search_read',
              'args': [
                [
                  ['id', 'in', uniqueCurrencyIds.toList()]
                ]
              ],
              'kwargs': {
                'fields': ['id', 'symbol'],
              },
            });
            currencyIdToSymbol = {
              for (final c in currencyResponse)
                if (c['id'] != null && c['symbol'] != null)
                  c['id'] as int: c['symbol'] as String
            };
          }

          partnerCurrencySymbolMap = {
            for (final p in partnerResponse)
              if (p['id'] != null &&
                  p['currency_id'] is List &&
                  p['currency_id'].isNotEmpty)
                p['id'] as int:
                    currencyIdToSymbol[p['currency_id'][0] as int] ?? ''
          };
        }

        final opportunityDetails = opportunityDetailsRaw.map((opportunity) {
          return opportunity.map(
              (key, value) => MapEntry(key, value == false ? null : value));
        }).toList();

        List<Map<dynamic, dynamic>> updatedOpportunities =
            mapOpportunitiesimagesnull(opportunityDetails);

        opportunities = updatedOpportunities;

        opportunities = opportunities.toSet().toList();

        if (disablePagination || opportunities.length < fetchLimit) {
          _totalCount = offset + opportunities.length;
        } else if (_totalCount == 0 && opportunities.isNotEmpty) {
          _totalCount = offset + opportunities.length + 1;
        }

        _applyGrouping();

        List<OpportunityModel> opportunitiesReport = opportunityDetailsRaw
            .map<OpportunityModel>((data) => OpportunityModel.fromJson(data))
            .toList();

        Map<String, int> stageCounts = {};

        Map<String, double> stageDayCloseTotal = {};
        Map<String, double> stageExpectedRevenue = {};
        Map<String, double> stageRecurringRevenueMonthly = {};
        Map<String, double> stageProbability = {};
        Map<String, double> stageRecurringRevenueMonthlyProrated = {};
        Map<String, double> stageRecurringRevenueProrated = {};
        Map<String, double> stageProratedRevenue = {};
        Map<String, double> stageRecurringRevenue = {};

        for (var opportunity in opportunitiesReport) {
          String stageName = opportunity.stageName;

          stageCounts[stageName] = (stageCounts[stageName] ?? 0) + 1;

          stageDayCloseTotal[stageName] =
              (stageDayCloseTotal[stageName] ?? 0) + opportunity.dayClose;
          stageExpectedRevenue[stageName] =
              (stageExpectedRevenue[stageName] ?? 0) +
                  opportunity.expectedRevenue;
          stageRecurringRevenueMonthly[stageName] =
              (stageRecurringRevenueMonthly[stageName] ?? 0) +
                  opportunity.recurringRevenueMonthly;
          stageProbability[stageName] =
              (stageProbability[stageName] ?? 0) + opportunity.probability;
          stageRecurringRevenueMonthlyProrated[stageName] =
              (stageRecurringRevenueMonthlyProrated[stageName] ?? 0) +
                  opportunity.recurringRevenueMonthlyProrated;
          stageRecurringRevenueProrated[stageName] =
              (stageRecurringRevenueProrated[stageName] ?? 0) +
                  opportunity.recurringRevenueProrated;
          stageProratedRevenue[stageName] =
              (stageProratedRevenue[stageName] ?? 0) +
                  opportunity.proratedRevenue;
          stageRecurringRevenue[stageName] =
              (stageRecurringRevenue[stageName] ?? 0) +
                  opportunity.recurringRevenue;
        }

        _stageOpportunityData = stageCounts.entries.map((e) {
          String stage = e.key;
          return {
            'stage': stage,
            'count': e.value,
            'total_day_close': stageDayCloseTotal[stage] ?? 0,
            'total_expected_revenue': stageExpectedRevenue[stage] ?? 0,
            'recurring_revenue_monthly':
                stageRecurringRevenueMonthly[stage] ?? 0,
            'probability': stageProbability[stage] ?? 0,
            'recurring_revenue_monthly_prorated':
                stageRecurringRevenueMonthlyProrated[stage] ?? 0,
            'recurring_revenue_prorated':
                stageRecurringRevenueProrated[stage] ?? 0,
            'prorated_revenue': stageProratedRevenue[stage] ?? 0,
            'recurring_revenue': stageRecurringRevenue[stage] ?? 0,
          };
        }).toList();
        final graphData = _stageOpportunityData.map((stageMap) {
          return OpportunityModelIsarGraph()
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

        await IsarService.saveOpportunitiesGraph(graphData);

        isLoading = false;

        notifyListeners();

        if (isPop) {
          if (context!.mounted) {
            Navigator.pop(context);
          }
        }
        return true;
      }

      return true;
    } catch (e) {
      _selectedFilters = [];
      bool success = false;
      if (opportunities.isEmpty && selectedFilters.isEmpty) {
        final bool hasCacheData = await getOpportunityDataFromIsar();
        if (hasCacheData) {
          success = true;
        } else {
          success = false;
        }
      }
      if (success == false) {
        if (selectedFilters.isEmpty) {
          final prefs = await SharedPreferences.getInstance();
          final String? url = prefs.getString('url');

          catchError = await ErrorHandler.handleException(e, uri: url);

          if (opportunities.isEmpty) {
            Future.delayed(const Duration(seconds: 2), () {
              isLoading = false;
              hasError = true;
              notifyListeners();
            });
          }
        } else {
          opportunities = [];
        }
      }
      return success;
    } finally {
      isLoading = false;
      notifyListeners();
    }
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

  /// Delete opportunity.
  Future<void> deleteOpportunity(int id) async {
    try {
      final aa = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'unlink',
        'args': [
          [id]
        ],
        'kwargs': {},
      });

      opportunities.removeWhere((lead) => lead['id'] == id);

      notifyListeners();
    } catch (_) {}
  }

  /// Fetches opportunity graph data from Isar cache.
  Future<void> getGraphDataFromIsar() async {
    final cachedGraphItems = await IsarService.getCachedOpportunitiesGraph();

    _stageOpportunityData = cachedGraphItems.map((e) {
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

  /// Fetches opportunity data from Isar cache.
  Future<bool> getOpportunityDataFromIsar() async {
    final cachedItems = await IsarService.getCachedOpportunitiesCache();

    opportunities = cachedItems.map((item) {
      return {
        'id': item.serverId,
        'name': item.name,
        'phone': item.phone,
        'mobile': item.mobile,
        'email_from': item.emailFrom,
        'city': item.city,
        'country_id':
            item.countryId != null ? [item.countryId, item.countryName] : null,
        'team_id': item.teamId != null ? [item.teamId, item.teamName] : null,
        'user_id': item.userId != null ? [item.userId, item.userName] : null,
        'probability': item.probability,
        'partner_id':
            item.partnerId != null ? [item.partnerId, item.partnerName] : null,
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
    final prefs = await SharedPreferences.getInstance();
    final stagesJson = prefs.getString('crm_stages');
    if (stagesJson != null) {
      crmStages = List<Map<String, dynamic>>.from(json.decode(stagesJson));
    }
    await getGraphDataFromIsar();
    if (opportunities.isNotEmpty && _totalCount == 0) {
      _totalCount = opportunities.length;
    }
    notifyListeners();
    opportunities = mapOpportunitiesimagesnull(opportunities);
    _applyGrouping();
    if (opportunities.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  /// Applies grouping logic to opportunities.
  void _applyGrouping() {
    _groupedOpportunities.clear();

    if (_currentGroupBy == GroupByOption.none) {
      return;
    }

    for (var opportunity in opportunities) {
      String groupKey = _getGroupKey(opportunity, _currentGroupBy);

      if (!_groupedOpportunities.containsKey(groupKey)) {
        _groupedOpportunities[groupKey] = [];
        if (!_groupExpansionState.containsKey(groupKey)) {
          _groupExpansionState[groupKey] = true;
        }
      }

      _groupedOpportunities[groupKey]!.add(opportunity);
    }

    final sortedKeys = _groupedOpportunities.keys.toList()..sort();
    final sortedGroups = <String, List<Map<dynamic, dynamic>>>{};
    for (String key in sortedKeys) {
      sortedGroups[key] = _groupedOpportunities[key]!;
    }
    _groupedOpportunities = sortedGroups;
  }

  /// Generates a group key for a given opportunity based on `GroupByOption`.
  String _getGroupKey(
      Map<dynamic, dynamic> opportunity, GroupByOption groupBy) {
    switch (groupBy) {
      case GroupByOption.stage:
        return opportunity['stage_id'] != null &&
                opportunity['stage_id'] is List
            ? opportunity['stage_id'][1]?.toString() ?? 'Undefined'
            : 'Undefined';

      case GroupByOption.salesperson:
        return opportunity['user_id'] != null && opportunity['user_id'] is List
            ? opportunity['user_id'][1]?.toString() ?? 'Unassigned'
            : 'Unassigned';

      case GroupByOption.team:
        return opportunity['team_id'] != null && opportunity['team_id'] is List
            ? opportunity['team_id'][1]?.toString() ?? 'No Team'
            : 'No Team';

      case GroupByOption.priority:
        final priority = opportunity['priority']?.toString() ?? '0';
        switch (priority) {
          case '0':
            return 'Low Priority';
          case '1':
            return 'Normal Priority';
          case '2':
            return 'High Priority';
          case '3':
            return 'Urgent Priority';
          default:
            return 'No Priority';
        }

      case GroupByOption.partner:
        return opportunity['partner_id'] != null &&
                opportunity['partner_id'] is List
            ? opportunity['partner_id'][1]?.toString() ?? 'No Customer'
            : 'No Customer';

      case GroupByOption.country:
        return opportunity['country_id'] != null &&
                opportunity['country_id'] is List
            ? opportunity['country_id'][1]?.toString() ?? 'No Country'
            : 'No Country';

      case GroupByOption.createDate:
        if (opportunity['create_date'] != null) {
          try {
            final date = DateTime.parse(opportunity['create_date']);
            return DateFormat('MMMM yyyy').format(date);
          } catch (e) {
            return 'Invalid Date';
          }
        }
        return 'No Date';

      case GroupByOption.expectedRevenue:
        final revenue = opportunity['expected_revenue'] ?? 0.0;
        if (revenue == 0) return 'No Revenue';
        if (revenue < 1000) return 'Under \$1K';
        if (revenue < 10000) return '\$1K - \$10K';
        if (revenue < 50000) return '\$10K - \$50K';
        if (revenue < 100000) return '\$50K - \$100K';
        return 'Over \$100K';

      case GroupByOption.probability:
        final prob = opportunity['probability'] ?? 0.0;
        if (prob == 0) return '0%';
        if (prob <= 25) return '1% - 25%';
        if (prob <= 50) return '26% - 50%';
        if (prob <= 75) return '51% - 75%';
        if (prob <= 99) return '76% - 99%';
        return '100%';

      default:
        return 'Other';
    }
  }

  /// Calculates total expected revenue for a group of opportunities.
  double getGroupTotalRevenue(List<Map<dynamic, dynamic>> groupOpportunities) {
    double total = 0.0;
    for (var opportunity in groupOpportunities) {
      final revenue = opportunity['expected_revenue'];
      if (revenue != null) {
        total += (revenue is double) ? revenue : (revenue as num).toDouble();
      }
    }
    return total;
  }

  /// Returns sorted group keys based on grouping type.
  List<String> getSortedGroupKeys() {
    final keys = _groupedOpportunities.keys.toList();

    switch (_currentGroupBy) {
      case GroupByOption.priority:
        keys.sort((a, b) {
          const priorityOrder = {
            'Urgent Priority': 0,
            'High Priority': 1,
            'Normal Priority': 2,
            'Low Priority': 3,
            'No Priority': 4,
          };
          return (priorityOrder[a] ?? 999).compareTo(priorityOrder[b] ?? 999);
        });
        break;

      case GroupByOption.expectedRevenue:
        keys.sort((a, b) {
          const revenueOrder = {
            'Over \$100K': 0,
            '\$50K - \$100K': 1,
            '\$10K - \$50K': 2,
            '\$1K - \$10K': 3,
            'Under \$1K': 4,
            'No Revenue': 5,
          };
          return (revenueOrder[a] ?? 999).compareTo(revenueOrder[b] ?? 999);
        });
        break;

      case GroupByOption.probability:
        keys.sort((a, b) {
          const probOrder = {
            '100%': 0,
            '76% - 99%': 1,
            '51% - 75%': 2,
            '26% - 50%': 3,
            '1% - 25%': 4,
            '0%': 5,
          };
          return (probOrder[a] ?? 999).compareTo(probOrder[b] ?? 999);
        });
        break;

      default:
        keys.sort();
    }

    return keys;
  }

  /// Maps opportunity images to null placeholder (for caching/display).
  List<Map<dynamic, dynamic>> mapOpportunitiesimagesnull(
      List<dynamic> opportunityDetails) {
    List<Map<dynamic, dynamic>> updatedOpportunities = [];

    for (var opportunity in opportunityDetails) {
      opportunity['user_image'] = null;

      updatedOpportunities.add(opportunity as Map<dynamic, dynamic>);
    }

    return updatedOpportunities;
  }

  /// Updates the stage of an opportunity on the server and locally.
  Future<bool> updateOpportunityStage({
    required BuildContext context,
    required int opportunityId,
    required int newStageId,
    required String newStageName,
  }) async {
    try {
      await sessionService.callKwWithCompanyUpdate({
        'model': 'crm.lead',
        'method': 'write',
        'args': [
          [opportunityId],
          {'stage_id': newStageId}
        ],
        'kwargs': {},
      });

      final opportunityIndex =
          opportunities.indexWhere((opp) => opp['id'] == opportunityId);
      if (opportunityIndex != -1) {
        opportunities[opportunityIndex]
            ['stage_id'] = [newStageId, newStageName];
        _applyGrouping();
        notifyListeners();
      }

      return true;
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.showError(context, 'Failed to update stage: $e');
      }
      return false;
    }
  }

  /// Optimistically updates the stage locally before server confirmation.
  void optimisticallyUpdateStage({
    required int opportunityId,
    required int newStageId,
    required String newStageName,
  }) {
    final opportunityIndex =
        opportunities.indexWhere((opp) => opp['id'] == opportunityId);
    if (opportunityIndex != -1) {
      opportunities[opportunityIndex]['stage_id'] = [newStageId, newStageName];
      _applyGrouping();
      notifyListeners();
    }
  }

  /// Rolls back a stage update locally in case of failure.
  void rollbackStageUpdate({
    required int opportunityId,
    required int originalStageId,
    required String originalStageName,
  }) {
    final opportunityIndex =
        opportunities.indexWhere((opp) => opp['id'] == opportunityId);
    if (opportunityIndex != -1) {
      opportunities[opportunityIndex]
          ['stage_id'] = [originalStageId, originalStageName];
      _applyGrouping();
      notifyListeners();
    }
  }

  /// Creates a new CRM stage on the server.
  Future<bool> createCrmStage({
    required BuildContext context,
    required String stageName,
  }) async {
    try {
      final existingStages = await sessionService.callKwWithCompanyDynamic({
        'model': 'crm.stage',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['sequence'],
          'order': 'sequence desc',
          'limit': 1,
        },
      });

      int nextSequence = 10;
      if (existingStages.isNotEmpty) {
        nextSequence = (existingStages[0]['sequence'] ?? 0) + 10;
      }

      final result = await sessionService.callKwWithCompany({
        'model': 'crm.stage',
        'method': 'create',
        'args': [
          {
            'name': stageName,
            'sequence': nextSequence,
          }
        ],
        'kwargs': {},
      });

      if (result != null) {
        return true;
      }

      return false;
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.showError(context, 'Failed to create stage: $e');
      }
      return false;
    }
  }

  /// Retrieves the list of CRM stages.
  Future<List<Map<String, dynamic>>> getCrmStages(BuildContext context) async {
    if (crmStages.isNotEmpty) return crmStages;

    final prefs = await SharedPreferences.getInstance();
    final stagesJson = prefs.getString('crm_stages');
    if (stagesJson != null) {
      crmStages = List<Map<String, dynamic>>.from(json.decode(stagesJson));
      return crmStages;
    }

    try {
      final result = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.stage',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name', 'sequence'],
          'order': 'sequence asc',
        },
      });

      if (result is List) {
        crmStages = List<Map<String, dynamic>>.from(result);
        await prefs.setString('crm_stages', json.encode(crmStages));
      }
    } catch (_) {}

    return crmStages;
  }

  /// Updates the name of an existing CRM stage.
  Future<bool> updateCrmStage({
    required BuildContext context,
    required int stageId,
    required String stageName,
  }) async {
    try {
      await sessionService.callKwWithCompanyUpdate({
        'model': 'crm.stage',
        'method': 'write',
        'args': [
          [stageId],
          {
            'name': stageName,
          }
        ],
        'kwargs': {},
      });

      return true;
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.showError(context, 'Failed to update stage: $e');
      }
      return false;
    }
  }

  /// Returns the number of opportunities in a given stage.
  Future<int> searchCountFn(int stageId) async {
    final result = await sessionService.callKwWithCompany({
      'model': 'crm.lead',
      'method': 'search_count',
      'args': [
        [
          ['stage_id', '=', stageId],
          ['type', '=', 'opportunity'],
        ]
      ],
      'kwargs': {},
    });
    return result as int;
  }

  /// Deletes a CRM stage if it contains no opportunities.
  Future<bool> deleteCrmStage({
    required BuildContext context,
    required Future<int> Function(int) searchCountFn,
    required int stageId,
    required String stageName,
  }) async {
    try {
      final opportunitiesInStage = await searchCountFn(stageId);
      if (opportunitiesInStage > 0) {
        if (context.mounted) {
          CustomSnackbar.showWarning(context,
              'Cannot delete stage "$stageName". It contains $opportunitiesInStage opportunities.');
        }
        return false;
      }

      await sessionService.callKwWithCompanyUpdate({
        'model': 'crm.stage',
        'method': 'unlink',
        'args': [
          [stageId]
        ],
        'kwargs': {},
      });

      return true;
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.showError(context, 'Failed to delete stage: $e');
      }
      return false;
    }
  }

  /// Returns the stage ID for a given stage name.
  Future<int?> getStageIdByName(BuildContext context, String stageName) async {
    try {
      final stages = await getCrmStages(context);
      for (var stage in stages) {
        if (stage['name'] == stageName) {
          return stage['id'] as int;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Goes to the next page in pagination and fetches opportunities.
  Future<void> goToNextPage({
    required BuildContext context,
    bool isOpportunity = true,
    bool isLead = false,
    String searchText = "",
    bool isPipeline = true,
    bool pipelinefilters = true,
    bool unAssigned = false,
    bool partnerassigned = false,
    bool opeopportunity = false,
    bool stagefilters = true,
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
    List? customFilter,
  }) async {
    if (!hasNextPage || isLoading) return;

    offset += limit;
    _currentPage++;

    await getOpportunities(
      context: context,
      isOpportunity: isOpportunity,
      isLead: isLead,
      searchText: searchText,
      isPipeline: isPipeline,
      pipelinefilters: pipelinefilters,
      unAssigned: unAssigned,
      partnerassigned: partnerassigned,
      opeopportunity: opeopportunity,
      stagefilters: stagefilters,
      won: won,
      lost: lost,
      ongoing: ongoing,
      datefilters: datefilters,
      monthNow: monthNow,
      beforeMonth: beforeMonth,
      beforetwoMonth: beforetwoMonth,
      datefilterclose: datefilterclose,
      monthNowclose: monthNowclose,
      beforeMonthclose: beforeMonthclose,
      beforetwoMonthclose: beforetwoMonthclose,
      customFilter: customFilter,
      loading: true,
    );
  }

  /// Goes to the previous page in pagination and fetches opportunities.
  Future<void> goToPreviousPage({
    required BuildContext context,
    bool isOpportunity = true,
    bool isLead = false,
    String searchText = "",
    bool isPipeline = true,
    bool pipelinefilters = true,
    bool unAssigned = false,
    bool partnerassigned = false,
    bool opeopportunity = false,
    bool stagefilters = true,
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
    List? customFilter,
  }) async {
    if (!hasPreviousPage || isLoading) return;

    offset -= limit;
    if (offset < 0) offset = 0;
    _currentPage--;

    await getOpportunities(
      context: context,
      isOpportunity: isOpportunity,
      isLead: isLead,
      searchText: searchText,
      isPipeline: isPipeline,
      pipelinefilters: pipelinefilters,
      unAssigned: unAssigned,
      partnerassigned: partnerassigned,
      opeopportunity: opeopportunity,
      stagefilters: stagefilters,
      won: won,
      lost: lost,
      ongoing: ongoing,
      datefilters: datefilters,
      monthNow: monthNow,
      beforeMonth: beforeMonth,
      beforetwoMonth: beforetwoMonth,
      datefilterclose: datefilterclose,
      monthNowclose: monthNowclose,
      beforeMonthclose: beforeMonthclose,
      beforetwoMonthclose: beforetwoMonthclose,
      customFilter: customFilter,
      loading: true,
    );
  }
}
