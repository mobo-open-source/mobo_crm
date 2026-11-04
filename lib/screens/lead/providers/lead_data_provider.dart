import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
import '../../../utils/snackbar.dart';

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

  /// Id of the newest [getLeads] request; see the guard there.
  int _fetchSeq = 0;

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

  bool _isSearchPending = false;

  /// True from the keystroke that starts a search until the matching fetch
  /// finishes — covering both the debounce and the request itself.
  ///
  /// Search deliberately runs with `loading: false` so the search field stays
  /// usable while typing, which left [isLoading] false for that whole window.
  /// The list read "not loading + no rows" and rendered its "nothing found"
  /// placeholder over data that simply had not come back yet.
  bool get isSearchPending => _isSearchPending;

  /// What a list should treat as "still working": a fetch that asked for a
  /// loading state, or a search that has not landed yet.
  bool get isBusy => _isLoading || _isSearchPending;

  /// Called from the search field on every keystroke, before the debounce, so
  /// the list switches to its skeleton immediately instead of after the wait.
  void markSearchPending() {
    if (_isSearchPending) return;
    _isSearchPending = true;
    notifyListeners();
  }

  String get selectedOption => _selectedOption;

  bool get isSearching => _isSearching;
  bool canNavigate = true;

  String get valueStatus => _valueStatus;
  List allleadpagination = [];

  GroupByOption _currentGroupBy = GroupByOption.none;

  /// Every group, built from every lead the grouped fetch returned.
  Map<String, List<Map<dynamic, dynamic>>> _groupedLeads = {};

  /// The slice of [_groupedLeads] the current page shows.
  Map<String, List<Map<dynamic, dynamic>>> _visibleGroups = {};
  Map<String, bool> _groupExpansionState = {};

  GroupByOption get currentGroupBy => _currentGroupBy;

  bool get isGrouped => _currentGroupBy != GroupByOption.none;

  /// The groups on the current page. A grouped fetch loads every lead, so the
  /// pager pages through groups ([limit] per page) rather than through rows.
  Map<String, List<Map<dynamic, dynamic>>> get groupedLeads => _visibleGroups;

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

  /// What the pager counts: every lead the filters match for a flat list, or
  /// the number of groups for a grouped one. This is the "/ total" shown next
  /// to the range, so it must never be read from the groups of a flat list
  /// (there are none, which printed "1-13 / 0").
  int get pagerTotal => isGrouped ? _groupedLeads.length : _totalCount;

  bool get hasNextPage => (_currentPage + 1) * limit < pagerTotal;

  int get startRecord => pagerTotal == 0 ? 0 : (_currentPage * limit) + 1;

  /// Derived from the page and the total rather than from how many rows are
  /// loaded, so the range stays right while a page is still being fetched.
  int get endRecord {
    final pageEnd = (_currentPage + 1) * limit;
    return pageEnd < pagerTotal ? pageEnd : pagerTotal;
  }

  int get totalPages => (pagerTotal / limit).ceil();

  int get currentPageNumber => _currentPage + 1;

  /// The current year as Odoo's "Created on" year filter bounds it: midnight
  /// on 1 January to midnight on the next 1 January in the device's
  /// timezone, as the web client works it out, written as the UTC datetimes
  /// the server compares against.
  (String, String) _currentYearBounds([DateTime? now]) {
    final today = now ?? DateTime.now();
    final format = DateFormat('yyyy-MM-dd HH:mm:ss');
    return (
      format.format(DateTime(today.year, 1, 1).toUtc()),
      format.format(DateTime(today.year + 1, 1, 1).toUtc()),
    );
  }

  bool isAdmin = false;

  /// Clear all filters and optionally reload leads
  void clearFilters({bool reload = true, BuildContext? context}) async {
    selectedFilters = [];
    _leads.clear();
    _groupedLeads.clear();
    _visibleGroups = {};
    _currentPage = 0;

    if (reload && context != null) {
      _isLoading = true;
      notifyListeners();
      // Clearing the filters leaves a search the user typed in place.
      await getLeads(
        context: context,
        loading: true,
        searchText: searchController.text,
      );
    }
  }

  /// Set the current group by option and refresh grouped leads
  void setGroupBy(GroupByOption option) {
    _currentGroupBy = option;
    _currentPage = 0;
    _applyGrouping();
    notifyListeners();
  }

  /// Shows [page] of a grouped list.
  ///
  /// Every group is already in memory, so nothing is fetched; only the slice
  /// of groups on screen changes.
  void showGroupPage(int page) {
    if (!isGrouped || page < 0 || page >= totalPages) return;
    _currentPage = page;
    _updateVisibleGroups();
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
    final int userId = prefs.getInt('userId') ?? 0;
    final int majorVersion = prefs.getInt('version') ?? 0;

    // has_group(self, group_ext_id)'s call signature differs by Odoo major
    // version: 17 and earlier take just the group's external id (the
    // dispatcher forwards it onto an unbrowsed `res.users` recordset,
    // which falls back to the session's own uid); 18+ expect the user id
    // leading the args instead, since their dispatcher browses args[0] as
    // the id before calling the method. Sending the wrong shape throws a
    // TypeError server-side before has_group ever runs.
    Future<bool> hasGroup(String groupExtId) async {
      return await CompanySessionManager.callKwWithCompany({
            'model': 'res.users',
            'method': 'has_group',
            'args': majorVersion >= 18
                ? [userId, groupExtId]
                : [groupExtId],
            'kwargs': {},
          }) ==
          true;
    }

    final bool admin;
    try {
      admin = await hasGroup('base.group_system');
    } catch (_) {
      // A failed lookup (e.g. expired session) isn't a "no"; keep the flag.
      return;
    }

    isAdmin = admin;
    notifyListeners();
  }

  /// Delete lead.
  Future<void> deleteLead(int id, BuildContext context) async {
    try {
      await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'unlink',
        'args': [
          [id]
        ],
        'kwargs': {},
      });

      final before = _leads.length;
      _leads.removeWhere((lead) => lead['id'] == id);
      // The pager's total and the groups were built with this lead in them.
      if (_leads.length < before && _totalCount > 0) _totalCount--;
      _applyGrouping();

      notifyListeners();
      if (context.mounted) {
        CustomSnackbar.showSuccess(context, 'Lead deleted successfully');
      }
    } catch (_) {
      if (context.mounted) {
        CustomSnackbar.showError(context, 'Failed to delete lead');
      }
    }
  }

  /// Clears all lead data and resets pagination, filters, grouping and search.
  ///
  /// Called when the session changes (logout, new login, account switch). The
  /// filters and group-by belong to the user who chose them, so the next
  /// account must start from the plain list rather than inherit them.
  void clearAll() {
    // A fetch still in flight belongs to the account being left; invalidating
    // it keeps its rows, or its failure, out of the next account's list.
    _fetchSeq++;
    _isSearchPending = false;
    hasError = false;
    leadError = null;
    leads.clear();
    _groupedLeads.clear();
    _visibleGroups = {};
    _groupExpansionState.clear();
    _currentPage = 0;
    _totalCount = 0;
    _selectedFilters = [];
    _currentGroupBy = GroupByOption.none;
    _lastSearchText = '';
    searchController.clear();
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
  /// [searchText] - Matched against the lead name, customer, contact, email,
  /// phone and sales team, across every record the filters allow (not just the
  /// page on screen).
  /// [loading] - Show loading indicator.
  /// [page] - Fetch this (0-based) page of the same query. Only the rows are
  /// re-read; the graph aggregates stay as they are.
  /// [resetPage] - The query changed (search, filters, company), so start from
  /// the first page instead of an offset the new result may not reach.
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
      String searchText = "",
      int? page,
      bool resetPage = false}) async {
    hasError = false;
    leadError = null;
    searchText = searchText.trim();

    // A fetch without a search means the list is not a search result, so the
    // box must stop showing a query the list no longer reflects.
    if (searchText.isEmpty && searchController.text.trim().isNotEmpty) {
      searchController.clear();
    }

    // The list on screen is the previous search's result, and the cache holds
    // neither it nor the active filters and grouping, so clearing a search
    // must refetch rather than reload the cache.
    final bool wasSearching = _lastSearchText.isNotEmpty;
    if (searchText.isEmpty &&
        customFilter == null &&
        !wasSearching &&
        page == null) {
      if (_leads.isNotEmpty && !loading) {
        _isSearchPending = false;
        notifyListeners();
        return;
      }
      // First open: put the offline copy up so the screen is not blank, but
      // carry on to the server. The copy is only the last first page, so its
      // length says nothing about how many leads there are; returning here
      // left the pager reading "1-N / N" with no way to reach the rest.
      if (_leads.isEmpty && !loading && await getLeadDataFromIsar()) {
        _isLoading = false;
        _isSearchPending = false;
        notifyListeners();
      }
    }

    if (page != null) {
      _currentPage = page < 0 ? 0 : page;
    } else if (resetPage) {
      _currentPage = 0;
    }

    _lastSearchText = searchText;
    // Search and clear can overlap; only the newest request may apply its
    // result, or a slow earlier search lands over the cleared list.
    final int fetchSeq = ++_fetchSeq;

    if (loading) {
      // An explicit reload shows the skeleton, not the rows of the old query.
      _leads = [];
      _applyGrouping();
      _isLoading = true;
      notifyListeners();
    } else if (_leads.isEmpty && !_isSearchPending) {
      // Not for a search: it already reads as busy through [isSearchPending],
      // and [isLoading] locks the search box, which after a "no results" would
      // freeze the field in the middle of the user's next keystroke.
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

      // What Odoo's Leads Analysis opens on: Active or Inactive (the two
      // filters share a group, so they are OR-ed) and no filter on type, so
      // leads and opportunities are both counted, as in the web client. Which
      // records a user may read is left to the server's record rules: an
      // administrator gets them all, a salesperson only their own.
      //
      // A custom filter narrows that list; it must not replace it.
      List<dynamic> filters = [
        '|',
        ['active', '=', true],
        ['active', '=', false],
        ...?customFilter,
      ];

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
        filters.addAll(_searchDomain(searchText));
      }

      // The graph, unlike the list, opens on "Created on: this year" as Odoo's
      // Leads Analysis does, and drops that facet once another creation-date
      // filter is picked. The year bound used to sit on `filters`, so the list,
      // its record count and its search all silently stopped at 1 January and
      // every older lead was unreachable.
      final List<dynamic> graphFilters = [...filters];
      if (!leaddatefilters) {
        final (yearStart, yearEnd) = _currentYearBounds();
        graphFilters.addAll([
          ['create_date', '>=', yearStart],
          ['create_date', '<', yearEnd],
        ]);
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
        // Computed per lead; 19 checks read access on each duplicate while
        // computing it and fails the whole read for restricted users.
        if (version < 19) 'duplicate_lead_ids',
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

      bool countKnown = false;
      try {
        final countResponse = await CompanySessionManager.callKwWithCompany({
          'model': 'crm.lead',
          'method': 'search_count',
          'args': [filters],
          'kwargs': {},
        });
        _totalCount = countResponse ?? 0;
        countKnown = countResponse != null;
      } catch (e) {
        debugPrint('[LeadDataProvider] search_count failed: $e');
        _totalCount = 0;
      }

      // A grouped list loads every lead and pages through the groups instead.
      final bool paged = _currentGroupBy == GroupByOption.none;

      // A page past the end would come back empty and read as "nothing found":
      // the search or filters narrowed the result, or leads were deleted since
      // the page was last shown. Land on the last page that exists.
      if (paged && countKnown) {
        final int lastPage = _totalCount > 0 ? (_totalCount - 1) ~/ limit : 0;
        if (_currentPage > lastPage) _currentPage = lastPage;
      }

      final int fetchLimit = paged ? limit : 0;
      final int fetchOffset = paged ? _currentPage * limit : 0;

      Future<dynamic> readLeads() => CompanySessionManager.callKwWithCompany({
            'model': 'crm.lead',
            'method': 'search_read',
            'args': [filters],
            'kwargs': {
              'fields': fieldsToFetch,
              if (paged) 'limit': fetchLimit,
              if (paged) 'offset': fetchOffset,
            },
          });

      dynamic leadDetailsraw;
      try {
        leadDetailsraw = await readLeads();
      } catch (e) {
        fieldsToFetch.remove('mobile');
        leadDetailsraw = await readLeads();
      }

      // A newer search/clear has started since this request went out.
      if (fetchSeq != _fetchSeq) return;

      // The cache is the offline copy of the plain first page, so it never
      // holds search results, a filtered list or a later page: reopening the
      // app would otherwise start on whichever of those was fetched last.
      // Best-effort: a record it can't store must not abort showing the
      // fetched list.
      final bool isPlainFirstPage = paged &&
          fetchOffset == 0 &&
          searchText.isEmpty &&
          customFilter == null &&
          !(leadfilter ||
              leaddatefilters ||
              leaddatefiltersclose ||
              stagefilters ||
              activitycatgoryfilter ||
              hasArchived);
      if (isPlainFirstPage &&
          leadDetailsraw != null &&
          leadDetailsraw.isNotEmpty) {
        try {
          final leadCacheObjects = leadDetailsraw
              .map((e) =>
                  LeadsModelIsarCache.fromJson(e.cast<String, dynamic>()))
              .toList()
              .cast<LeadsModelIsarCache>();
          await IsarService.saveLeadsCache(leadCacheObjects);
        } catch (_) {}
      }

      // The graph counts every record [graphFilters] match, so it must not be
      // shrunk to the page on screen, and it is not the same set as the list
      // whenever the year bound applies. The list rows can stand in for it
      // only when no year bound was added and they are the whole result.
      // A page flip keeps the query, so the aggregates already on hand are
      // still right and are left alone.
      dynamic graphRaw;
      if (page == null) {
        graphRaw = leadDetailsraw;
        final bool listIsWholeResult = leaddatefilters &&
            leadDetailsraw is List &&
            (fetchLimit == 0 ||
                (fetchOffset == 0 && leadDetailsraw.length < fetchLimit));
        if (!listIsWholeResult) {
          try {
            graphRaw = await CompanySessionManager.callKwWithCompany({
              'model': 'crm.lead',
              'method': 'search_read',
              'args': [graphFilters],
              'kwargs': {
                'fields': [
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
                ],
              },
            });
          } catch (e) {
            // The page is still a fair picture; better than no graph.
            debugPrint('[LeadDataProvider] graph fetch failed: $e');
          }
          if (fetchSeq != _fetchSeq) return;
        }
      }

      if (graphRaw != null && graphRaw.isNotEmpty) {
        List<LeadCrmModel> leads = graphRaw.map<LeadCrmModel>((lead) {
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

      // The activity types do not change with the page. Reading them is a side
      // errand: a failure here must not throw away the leads already fetched.
      if (page == null) {
        try {
          final activityResponse =
              await CompanySessionManager.callKwWithCompany({
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
        } catch (e) {
          debugPrint('[LeadDataProvider] activity types failed: $e');
        }
      }

      if (fetchSeq != _fetchSeq) return;

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
          // The previous rows are no longer cleared up front, so an empty
          // result has to replace them. Regroup too, or the grouped view
          // keeps the previous result's groups.
          _leads = [];
          _applyGrouping();
          _isLoading = false;
          notifyListeners();
        }
      }
    } catch (e, stack) {
      debugPrint('[LeadDataProvider] getLeads failed: $e\n$stack');
      if (fetchSeq != _fetchSeq) return;
      bool success = false;
      if (_leads.isEmpty) {
        success = await getLeadDataFromIsar();
        _isLoading = false;
        notifyListeners();
      }
      if (selectedFilters.isEmpty) {
        // Rows on screen (the offline copy, or the list a failed search left
        // in place) mean there is something to show, so no error screen.
        if (success == false && _leads.isEmpty) {
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
              // A retry, refresh or account switch inside the delay owns the
              // flags now; this must not paint its error over the new result.
              if (fetchSeq != _fetchSeq) return;
              _isLoading = false;
              hasError = true;
              notifyListeners();
            });
          }
        }
      } else {
        _leads = [];
        _applyGrouping();
      }
    } finally {
      // A superseded request leaves the flags to the newer one, which is
      // still running.
      if (fetchSeq == _fetchSeq) {
        _isLoading = false;
        _isSearchPending = false;
        notifyListeners();
      }
    }
  }

  /// The Odoo domain a search term expands to: a lead matches when the term
  /// appears in any field the list shows or the hint promises (name or
  /// customer), plus the sales team. The fields are OR-ed, so the domain needs
  /// one `|` for every field but the first.
  ///
  /// The term is passed as typed: `ilike` already wraps it in wildcards, and a
  /// leading `%` of our own would be taken literally by servers that escape it.
  List<dynamic> _searchDomain(String term) {
    const fields = [
      'name',
      'partner_id',
      'partner_name',
      'contact_name',
      'email_from',
      'phone',
      'team_id',
    ];
    return [
      for (var i = 1; i < fields.length; i++) '|',
      for (final field in fields) [field, 'ilike', term],
    ];
  }

  /// Slices [_groupedLeads] down to the groups of the current page.
  void _updateVisibleGroups() {
    if (!isGrouped || _groupedLeads.isEmpty) {
      _visibleGroups = {};
      return;
    }
    final int lastPage = (_groupedLeads.length - 1) ~/ limit;
    if (_currentPage > lastPage) _currentPage = lastPage;
    _visibleGroups = {
      for (final key
          in _groupedLeads.keys.skip(_currentPage * limit).take(limit))
        key: _groupedLeads[key]!,
    };
  }

  void _applyGrouping() {
    _groupedLeads.clear();
    if (_currentGroupBy == GroupByOption.none) {
      _visibleGroups = {};
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
    _updateVisibleGroups();
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
      // The copy holds the first page only, whatever page was on screen.
      if (_leads.isNotEmpty) _currentPage = 0;
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

    if (isGrouped) {
      showGroupPage(_currentPage + 1);
      return;
    }

    await getLeads(
      page: _currentPage + 1,
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

    if (isGrouped) {
      showGroupPage(_currentPage - 1);
      return;
    }

    await getLeads(
      page: _currentPage - 1,
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
