import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:mobo_crm/global_methods/bottom_sheets/filter_design_bottomsheet.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/searchfield_widget.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';
import 'package:mobo_crm/global_methods/widgets/group_by_dropdown.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/lead/grouped_lead_list_view.dart';
import 'package:mobo_crm/screens/lead/new_lead_form.dart';
import 'package:mobo_crm/screens/lead/providers/lead_data_provider.dart';
import 'package:mobo_crm/screens/lead/lead_views.dart';
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/company/infrastructure/company_refresh_bus.dart';
import '../../core/company/providers/company_provider.dart';
import '../../core/company/widgets/company_selector_widget.dart';
import '../../services/storage_service.dart';
import '../../utils/globals.dart';
import '../../utils/snackbar.dart';
import '../others/configuration_screen.dart';

/// Main Leads hub screen.
///
/// Responsibilities:
/// - Displays leads in multiple views (List, Kanban, Calendar, Graph, Activity)
/// - Handles searching, filtering, grouping, and view switching
/// - Listens for company changes and refreshes leads accordingly
/// - Provides quick access to create a new Lead
///
/// Integrates with:
/// - [LeadDataProvider] for fetching and grouping leads
/// - [OdooClientManager] for session/client access
/// - [LeadFormProvider] for lead form state
/// - [CompanyRefreshBus] to react to company switches
class LeadMainScreen extends StatefulWidget {
  final bool isCustom;

  const LeadMainScreen({super.key, this.isCustom = true});

  @override
  LeadMainScreenState createState() => LeadMainScreenState();
}

/// State for [LeadMainScreen].
///
/// Manages:
/// - Filter flags (status, stage, activity, dates, archived, custom)
/// - Selected view index (List / Kanban / Calendar / Graph / Activity)
/// - Debounced search input
/// - Company change subscription
///
/// Acts as the coordinator between UI controls and [LeadDataProvider].
class LeadMainScreenState extends State<LeadMainScreen> {
  bool hasClosingDateFilters = false;
  bool hasLeadFilters = false;
  bool hasCreationDateFilters = false;
  bool hasStageFilters = false;
  bool hasActivityCategoryFilters = false;

  bool filterUnassigned = false;
  bool filterPartnerAssigned = false;
  bool filterMyActivities = false;

  bool filterLost = false;
  bool filterArchived = false;
  bool filterCurrentMonth = false;
  bool filterPreviousMonth = false;
  bool filterTwoMonthsAgo = false;

  bool filterPreviousMonthClose = false;
  bool filterTwoMonthsAgoClose = false;
  bool filterCurrentMonthClose = false;

  bool filterLateActivities = false;
  bool filterTodayActivities = false;
  bool filterFutureActivities = false;

  List<dynamic> customFilters = [];
  bool hasCustomFilters = false;
  late final StreamSubscription _companySub;

  /// Resets all locally cached filter flags to their default (inactive) state.
  ///
  /// This clears:
  /// - Status, stage, activity category filters
  /// - Creation & closing date filters
  /// - Archived and custom filters
  ///
  /// Does NOT trigger a lead refresh by itself.
  void resetLocalFilterFlags() {
    setState(() {
      hasLeadFilters = false;
      hasActivityCategoryFilters = false;
      hasStageFilters = false;
      filterMyActivities = false;

      filterUnassigned = false;
      filterPartnerAssigned = false;

      filterLost = false;
      filterArchived = false;
      filterLateActivities = false;
      filterTodayActivities = false;
      filterFutureActivities = false;

      filterCurrentMonth = false;
      filterPreviousMonth = false;
      filterTwoMonthsAgo = false;
      hasCreationDateFilters = false;

      filterCurrentMonthClose = false;
      filterPreviousMonthClose = false;
      filterTwoMonthsAgoClose = false;
      hasClosingDateFilters = false;

      customFilters = [];
      hasCustomFilters = false;
    });
  }

  /// Opens the filter & group-by bottom sheet for Leads.
  ///
  /// Builds dynamic filter groups:
  /// - Status (My Activities, Unassigned)
  /// - Stages (Lost)
  /// - Activity Category (Late, Today, Future)
  /// - Creation Date (current / previous / two months ago)
  /// - Closing Date (current / previous / two months ago)
  /// - Archived
  ///
  /// Also provides "Group By" options that update [LeadDataProvider.currentGroupBy].
  ///
  /// On apply:
  /// - Updates local filter flags
  /// - Converts custom filters to Odoo domain format
  /// - Triggers a fresh lead fetch with active filters
  void showFilterBottomSheet(
      BuildContext context, OdooClientManager clientprovider) {
    final leadProvider = Provider.of<LeadDataProvider>(context, listen: false);

    DateTime now = DateTime.now();
    String currentMonth = DateFormat('MMMM yyyy').format(now);
    String previousMonth =
        DateFormat('MMMM yyyy').format(DateTime(now.year, now.month - 1, 1));
    String twoMonthsAgo =
        DateFormat('MMMM yyyy').format(DateTime(now.year, now.month - 2, 1));

    List<FilterGroup> filterGroups = [
      FilterGroup(
        title: "Status",
        options: [
          FilterOption(
            title: "My Activities",
            value: filterMyActivities,
          ),
          FilterOption(
            title: "Unassigned",
            value: filterUnassigned,
          ),
        ],
      ),
      FilterGroup(
        title: "Stages",
        options: [
          FilterOption(
            title: "Lost",
            value: filterLost,
          ),
        ],
      ),
      FilterGroup(
        title: "Activity Category",
        options: [
          FilterOption(
            title: "Late Activities",
            value: filterLateActivities,
          ),
          FilterOption(
            title: "Today Activities",
            value: filterTodayActivities,
          ),
          FilterOption(
            title: "Future Activities",
            value: filterFutureActivities,
          ),
        ],
      ),
      FilterGroup(
        title: "Creation Date",
        isExpanded: hasCreationDateFilters,
        options: [
          FilterOption(
            title: currentMonth,
            value: filterCurrentMonth,
          ),
          FilterOption(
            title: previousMonth,
            value: filterPreviousMonth,
          ),
          FilterOption(
            title: twoMonthsAgo,
            value: filterTwoMonthsAgo,
          ),
        ],
      ),
      FilterGroup(
        title: "Closing Date",
        isExpanded: hasClosingDateFilters,
        options: [
          FilterOption(
            title: currentMonth,
            value: filterCurrentMonthClose,
          ),
          FilterOption(
            title: previousMonth,
            value: filterPreviousMonthClose,
          ),
          FilterOption(
            title: twoMonthsAgo,
            value: filterTwoMonthsAgoClose,
          ),
        ],
      ),
      FilterGroup(
        title: "Archived",
        options: [
          FilterOption(
            title: "Archived",
            value: filterArchived,
          ),
        ],
      ),
    ];

    List<FilterGroup> groupByOptions = [
      FilterGroup(
        title: "Group By Options",
        isExpanded: true,
        options: [
          FilterOption(
            title: "None",
            value: leadProvider.currentGroupBy == GroupByOption.none,
          ),
          FilterOption(
            title: "Stage",
            value: leadProvider.currentGroupBy == GroupByOption.stage,
          ),
          FilterOption(
            title: "Salesperson",
            value: leadProvider.currentGroupBy == GroupByOption.salesperson,
          ),
          FilterOption(
            title: "Sales Team",
            value: leadProvider.currentGroupBy == GroupByOption.team,
          ),
          FilterOption(
            title: "Country",
            value: leadProvider.currentGroupBy == GroupByOption.country,
          ),
          FilterOption(
            title: "Creation Date",
            value: leadProvider.currentGroupBy == GroupByOption.createDate,
          ),
        ],
      ),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PremiumFilterBottomSheet(
        title: 'Filter Leads',
        primaryColor: AppStyle.primaryColor,
        filterGroups: filterGroups,
        groupByOptions: groupByOptions,
        client: clientprovider.client,
        session: clientprovider.currentsession,
        model: 'crm.lead',
        onApply: (values) {
          setState(() {
            filterMyActivities = values['status_my_activities'] ?? false;
            filterUnassigned = values['status_unassigned'] ?? false;
            filterLost = values['stages_lost'] ?? false;
            filterArchived = values['archived_archived'] ?? false;
            filterLateActivities =
                values['activity_category_late_activities'] ?? false;
            filterTodayActivities =
                values['activity_category_today_activities'] ?? false;
            filterFutureActivities =
                values['activity_category_future_activities'] ?? false;
            filterCurrentMonth = values[
                    'creation_date_${currentMonth.toLowerCase().replaceAll(' ', '_')}'] ??
                false;
            filterPreviousMonth = values[
                    'creation_date_${previousMonth.toLowerCase().replaceAll(' ', '_')}'] ??
                false;
            filterTwoMonthsAgo = values[
                    'creation_date_${twoMonthsAgo.toLowerCase().replaceAll(' ', '_')}'] ??
                false;
            filterCurrentMonthClose = values[
                    'closing_date_${currentMonth.toLowerCase().replaceAll(' ', '_')}'] ??
                false;
            filterPreviousMonthClose = values[
                    'closing_date_${previousMonth.toLowerCase().replaceAll(' ', '_')}'] ??
                false;
            filterTwoMonthsAgoClose = values[
                    'closing_date_${twoMonthsAgo.toLowerCase().replaceAll(' ', '_')}'] ??
                false;
            if (values['group_by_options_none'] == true) {
              leadProvider.setGroupBy(GroupByOption.none);
            } else if (values['group_by_options_stage'] == true) {
              leadProvider.setGroupBy(GroupByOption.stage);
            } else if (values['group_by_options_salesperson'] == true) {
              leadProvider.setGroupBy(GroupByOption.salesperson);
            } else if (values['group_by_options_sales_team'] == true) {
              leadProvider.setGroupBy(GroupByOption.team);
            } else if (values['group_by_options_country'] == true) {
              leadProvider.setGroupBy(GroupByOption.country);
            } else if (values['group_by_options_creation_date'] == true) {
              leadProvider.setGroupBy(GroupByOption.createDate);
            } else {
              bool anyGroupBySelected =
                  values['group_by_options_none'] == true ||
                      values['group_by_options_stage'] == true ||
                      values['group_by_options_salesperson'] == true ||
                      values['group_by_options_sales_team'] == true ||
                      values['group_by_options_country'] == true ||
                      values['group_by_options_creation_date'] == true;

              if (!anyGroupBySelected) {
                leadProvider.setGroupBy(GroupByOption.none);
              }
            }

            if (leadProvider.currentGroupBy != GroupByOption.none) {
              selectedTabIndex = 0;
            }

            hasLeadFilters =
                filterUnassigned || filterPartnerAssigned || filterMyActivities;
            hasStageFilters = filterLost;
            hasActivityCategoryFilters = filterLateActivities ||
                filterTodayActivities ||
                filterFutureActivities;
            hasCreationDateFilters =
                filterCurrentMonth || filterPreviousMonth || filterTwoMonthsAgo;
            hasClosingDateFilters = filterCurrentMonthClose ||
                filterPreviousMonthClose ||
                filterTwoMonthsAgoClose;
          });

          if (values.containsKey('custom_filters')) {
            final customFilterRules =
                values['custom_filters'] as Map<String, dynamic>;

            customFilters =
                _convertCustomFiltersToOdooDomain(customFilterRules);
            hasCustomFilters = customFilters.isNotEmpty;
          } else {
            customFilters = [];
            hasCustomFilters = false;
          }

          final leadDataProvider =
              Provider.of<LeadDataProvider>(context, listen: false);

          bool isFullClear = !filterMyActivities &&
              !filterUnassigned &&
              !filterLost &&
              !filterArchived &&
              !filterLateActivities &&
              !filterTodayActivities &&
              !filterFutureActivities &&
              !filterCurrentMonth &&
              !filterPreviousMonth &&
              !filterTwoMonthsAgo &&
              !filterCurrentMonthClose &&
              !filterPreviousMonthClose &&
              !filterTwoMonthsAgoClose &&
              !hasCustomFilters &&
              leadDataProvider.currentGroupBy == GroupByOption.none;

          final List<String> activeFilters = [];

          if (filterMyActivities) activeFilters.add("My Activities");
          if (filterUnassigned) activeFilters.add("Unassigned");
          if (filterLost) activeFilters.add("Lost");
          if (filterArchived) activeFilters.add("Archived");
          if (filterLateActivities) activeFilters.add("Late Activities");
          if (filterTodayActivities) activeFilters.add("Today Activities");
          if (filterFutureActivities) activeFilters.add("Future Activities");
          if (filterCurrentMonth) activeFilters.add("Created This Month");
          if (filterPreviousMonth) activeFilters.add("Created Last Month");
          if (filterTwoMonthsAgo) activeFilters.add("Created 2 Months Ago");
          if (filterCurrentMonthClose) activeFilters.add("Closing This Month");
          if (filterPreviousMonthClose) activeFilters.add("Closing Last Month");
          if (filterTwoMonthsAgoClose)
            activeFilters.add("Closing 2 Months Ago");

          if (hasCustomFilters && customFilters.isNotEmpty) {
            activeFilters.add("Custom (${customFilters.length})");
          }

          if (isFullClear) {
            leadDataProvider.clearFilters(reload: true, context: context);
          } else {
            leadDataProvider.selectedFilters = activeFilters;

            leadDataProvider.getLeads(
              hasArchived: filterArchived,
              searchText: leadDataProvider.searchController.text,
              loading: true,
              leadbeforeMonthclose: filterPreviousMonthClose,
              leadbeforetwoMonthclose: filterTwoMonthsAgoClose,
              leaddatefiltersclose: hasClosingDateFilters,
              leadmonthNowclose: filterCurrentMonthClose,
              stagefilters: hasStageFilters,
              lost: filterLost,
              partnerassigned: filterPartnerAssigned,
              unAssigned: filterUnassigned,
              leadfilter: hasLeadFilters,
              context: context,
              leadbeforeMonth: filterPreviousMonth,
              leadmonthNow: filterCurrentMonth,
              leaddatefilters: hasCreationDateFilters,
              leadbeforetwoMonth: filterTwoMonthsAgo,
              lateactivity: filterLateActivities,
              todayactivity: filterTodayActivities,
              futureactivity: filterFutureActivities,
              activitycatgoryfilter: hasActivityCategoryFilters,
              myactivities: filterMyActivities,
              customFilter: hasCustomFilters ? customFilters : null,
            );
          }
        },
      ),
    );
  }

  /// Converts custom filter rules into an Odoo-compatible domain list.
  ///
  /// Input example:
  /// {
  ///   "rule_1": { "field": "name", "operator": "contains", "value": "CRM" }
  /// }
  ///
  /// Output:
  /// [ ["name", "ilike", "CRM"] ]
  ///
  /// Returns:
  /// - A list of Odoo domain expressions used in RPC calls.
  List<dynamic> _convertCustomFiltersToOdooDomain(
      Map<String, dynamic> customFilterRules) {
    List<dynamic> domain = [];

    customFilterRules.forEach((key, ruleData) {
      if (ruleData is Map<String, dynamic>) {
        final field = ruleData['field'] as String?;
        final operator = ruleData['operator'] as String?;
        final value = ruleData['value'];

        if (field != null && operator != null && value != null) {
          String odooOperator = _convertOperatorToOdoo(operator);
          domain.add([field, odooOperator, value]);
        }
      }
    });

    return domain;
  }

  /// Maps UI filter operators to Odoo domain operators.
  ///
  /// Examples:
  /// - "equals"       → "="
  /// - "contains"     → "ilike"
  /// - "greater_than" → ">"
  /// - "is_set"       → "!="
  ///
  /// Falls back to the original operator if no mapping is found.
  String _convertOperatorToOdoo(String operator) {
    switch (operator) {
      case 'equals':
        return '=';
      case 'not_equals':
        return '!=';
      case 'contains':
        return 'ilike';
      case 'not_contains':
        return 'not ilike';
      case 'starts_with':
        return '=ilike';
      case 'ends_with':
        return '=ilike';
      case 'greater_than':
        return '>';
      case 'greater_equal':
        return '>=';
      case 'less_than':
        return '<';
      case 'less_equal':
        return '<=';
      case 'in':
        return 'in';
      case 'not_in':
        return 'not in';
      case 'is_set':
        return '!=';
      case 'is_not_set':
        return '=';
      default:
        return operator;
    }
  }

  /// Initializes the Leads screen.
  ///
  /// Behavior:
  /// - Loads initial leads when screen is opened
  /// - Subscribes to [CompanyRefreshBus] to reload leads when company changes
  @override
  void initState() {
    super.initState();
    final leadprovider = Provider.of<LeadDataProvider>(context, listen: false);
    leadprovider.canManageSkills();

    if (widget.isCustom) {
      if (leadprovider.leads.isEmpty) {
        leadprovider.initlead(context);
      }
    }
    _companySub = CompanyRefreshBus.stream.listen((_) async {
      if (!mounted) return;
      await context.read<CompanyProvider>().initialize();
      if (!mounted) return;
      final leadprovider =
          Provider.of<LeadDataProvider>(context, listen: false);
      leadprovider.initlead(context);
    });
  }

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _companySub.cancel();
    super.dispose();
  }

  int selectedTabIndex = 0;

  /// Refreshes the leads list using the currently active filters and search query.
  ///
  /// Used by:
  /// - Pull-to-refresh
  /// - View widgets (List, Kanban, Calendar, etc.)
  Future<void> _refreshLeads() async {
    final leadProvider = Provider.of<LeadDataProvider>(context, listen: false);
    await leadProvider.getLeads(
      context: context,
      loading: true,
      searchText: leadProvider.searchController.text,
      unAssigned: filterUnassigned,
      partnerassigned: filterPartnerAssigned,
      myactivities: filterMyActivities,
      lost: filterLost,
      hasArchived: filterArchived,
      leadmonthNow: filterCurrentMonth,
      leadbeforeMonth: filterPreviousMonth,
      leadbeforetwoMonth: filterTwoMonthsAgo,
      leadmonthNowclose: filterCurrentMonthClose,
      leadbeforeMonthclose: filterPreviousMonthClose,
      leadbeforetwoMonthclose: filterTwoMonthsAgoClose,
      lateactivity: filterLateActivities,
      todayactivity: filterTodayActivities,
      futureactivity: filterFutureActivities,
      leaddatefilters: hasCreationDateFilters,
      leaddatefiltersclose: hasClosingDateFilters,
      leadfilter: hasLeadFilters,
      stagefilters: hasStageFilters,
      activitycatgoryfilter: hasActivityCategoryFilters,
      customFilter: hasCustomFilters ? customFilters : null,
    );
  }

  /// Returns the active view widget based on the selected tab index.
  ///
  /// Views:
  /// 0 → List or Grouped List (based on group-by)
  /// 1 → Kanban
  /// 2 → Calendar
  /// 3 → Graph
  /// 4 → Activity
  List<Widget> get viewWidgets {
    final leadProvider = Provider.of<LeadDataProvider>(context, listen: false);
    return [
      leadProvider.currentGroupBy != GroupByOption.none
          ? GroupedLeadListView(onRefresh: _refreshLeads)
          : LeadListView(onRefresh: _refreshLeads),
      LeadKanbanScreen(onRefresh: _refreshLeads),
      LeadsCalendar(onRefresh: _refreshLeads),
      LeadGraphWidget(onRefresh: _refreshLeads),
      LeadActivity(onRefresh: _refreshLeads),
    ];
  }

  List<Map<String, dynamic>> items = [
    {'icon': Icons.menu, 'label': 'List', 'assetUrl': 'assets/list.svg'},
    {
      'icon': Icons.view_kanban,
      'label': 'Kanban',
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

  /// Loads the current user's profile image from local storage.
  ///
  /// Reads:
  /// - userId from [SharedPreferences]
  /// - account data from [StorageService]
  ///
  /// Returns:
  /// - Base64 image string if available, otherwise null
  Future<String?> getCurrentUserImage() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    final storage = StorageService();
    final accounts = await storage.getAccounts();

    final currentUserId = userId;

    if (currentUserId == null) return null;

    final currentAccount = accounts.firstWhere(
      (acc) => acc['userId'] == currentUserId,
      orElse: () => {},
    );

    return currentAccount['image'];
  }

  bool isSvgBytes(String base64String) {
    final bytes = base64Decode(base64String);
    final content = String.fromCharCodes(bytes);
    return content.contains('<svg');
  }

  Widget _buildSecondaryHeader(
      LeadDataProvider provider, OdooClientManager clientprovider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (selectedTabIndex) {
      case 0:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              _buildActiveFiltersChip(provider),
              const Spacer(),
              _buildViewSelector(provider),
              const SizedBox(width: 8),
              _buildPaginationControls(provider, clientprovider),
            ],
          ),
        );
      case 3:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Flexible(child: _buildMeasureDropdown(provider)),
              const Spacer(),
              _buildViewSelector(provider),
              const SizedBox(width: 8),
              Flexible(child: _buildGraphTypeToggles(provider)),
            ],
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "My Leads",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              _buildViewSelector(provider),
            ],
          ),
        );
    }
  }

  Widget _buildActiveFiltersChip(LeadDataProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final count = provider.selectedFilters.length;

    if (count == 0) {
      return Text(
        "No filters applied",
        style: TextStyle(
          fontSize: 12.5,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: isDark ? Colors.grey[400]! : Colors.black,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            "Active",
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewSelector(LeadDataProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedItem = items[selectedTabIndex];

    return Container(
      constraints: const BoxConstraints(minHeight: 35),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<int>(
          value: selectedTabIndex,

          /// ✅ THIS replaces buttonStyleData
          customButton: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selectedItem['icon'],
                size: 17,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  selectedItem['label'],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: isDark ? Colors.white : Colors.black,
              ),
            ],
          ),

          onChanged: (index) {
            if (index != null) {
              setState(() {
                selectedTabIndex = index;
              });
            }
          },

          /// ✅ Dropdown styling
          dropdownStyleData: DropdownStyleData(
            maxHeight: 250,
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
              color: isDark ? Colors.grey[900] : Colors.white,
            ),
          ),

          /// ✅ Items
          items: items.asMap().entries.map((entry) {
            final isSelected = selectedTabIndex == entry.key;

            return DropdownMenuItem<int>(
              value: entry.key,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.grey.withValues(alpha: 0.15))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      entry.value['icon'],
                      size: 20,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      entry.value['label'],
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPaginationControls(
      LeadDataProvider provider, OdooClientManager clientprovider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Text(
            "${provider.startRecord}-${provider.endRecord} / ${provider.totalCount}",
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        if (provider.totalPages > 1) ...[
          InkWell(
            onTap: provider.hasPreviousPage
                ? () => provider.goToPreviousPage(
                      context: context,
                      searchText: provider.searchController.text,
                    )
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 4.0),
              child: Icon(
                HugeIcons.strokeRoundedArrowLeft01,
                size: 20,
                color: provider.hasPreviousPage
                    ? (isDark ? Colors.white : Colors.grey[700])
                    : Colors.grey[400],
              ),
            ),
          ),
          InkWell(
            onTap: provider.hasNextPage
                ? () => provider.goToNextPage(
                      context: context,
                      searchText: provider.searchController.text,
                    )
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 4.0),
              child: Icon(
                HugeIcons.strokeRoundedArrowRight01,
                size: 20,
                color: provider.hasNextPage
                    ? (isDark ? Colors.white : Colors.grey[700])
                    : Colors.grey[400],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMeasureDropdown(LeadDataProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filters = [
      "Count",
      "Days to Close",
      "Expected Revenue",
      "Expected MRR",
      "Probability",
      "Prorated MRR",
      "Prorated Recurring Revenue",
      "Prorated Revenue",
      "Recurring Revenue"
    ];

    return Container(
      width: 110,
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          value: provider.selectedFilterLead,
          onChanged: (value) {
            if (value != null) {
              provider.applyFilter(value);
            }
          },
          buttonStyleData: const ButtonStyleData(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 8),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down,
                size: 16, color: isDark ? Colors.white : Colors.black),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 250,
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                width: 1,
              ),
              color: isDark ? Colors.grey[900] : Colors.white,
            ),
          ),
          items: filters.map((filter) {
            return DropdownMenuItem<String>(
              value: filter,
              child: Text(
                filter,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildGraphTypeToggles(LeadDataProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildToggleIcon(
          icon: HugeIcons.strokeRoundedChartLineData03,
          selected: provider.graphViewIndex == 0,
          onTap: () => provider.setGraphViewIndex(0),
        ),
        const SizedBox(width: 6),
        _buildToggleIcon(
          icon: Icons.bar_chart,
          selected: provider.graphViewIndex == 1,
          onTap: () => provider.setGraphViewIndex(1),
        ),
      ],
    );
  }

  Widget _buildToggleIcon({
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selected
              ? (isDark ? Colors.white : Colors.black)
              : isDark
                  ? Colors.grey[900]
                  : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected
                ? (isDark ? Colors.white : Colors.black)
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: selected
              ? (isDark ? Colors.black : Colors.white)
              : (isDark ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  /// Builds the main Leads UI.
  ///
  /// Layout:
  /// - AppBar with company selector & user avatar
  /// - Search bar with filter & view selector
  /// - Floating action button to create a new Lead
  /// - Active view widget (List / Kanban / Calendar / Graph / Activity)
  @override
  Widget build(BuildContext context) {
    return Consumer3<LeadDataProvider, OdooClientManager, LeadFormProvider>(
        builder: (context, provider, clientprovider, leadformprovider, child) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onPressed: () async {
            bool cleared = leadformprovider.clearAll('lead');

            if (cleared) {
              Navigator.push(
                context,
                SlidingPageTransitionRL(
                    page: NewLeadForm(
                  lead: {},
                  isNew: true,
                  type: 'lead',
                )),
              ).then((result) {
                if (result == true && mounted) {
                  _refreshLeads();
                }
              });
            }
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 28,
          ),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF181A20) : const Color(0xFFFAFAFA),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF181A20) : const Color(0xFFFAFAFA),
          elevation: 0,
          title: Text(
            'Leads',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
          actions: [
            CompanySelectorWidget(
              onCompanyChanged: () async {
                if (!mounted) return;
                final provider = context.read<CompanyProvider>();
                final companyName =
                    provider.selectedCompany?['name']?.toString() ?? 'company';
                CompanyRefreshBus.notify();

                CustomSnackbar.showSuccess(context, 'Switched to $companyName');
              },
            ),
            SizedBox(
              width: 10,
            ),
            Consumer<OdooClientManager>(
              builder: (context, provider, child) {
                final imageBase64 = provider.currentUserImage;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConfigurationScreen(),
                      ),
                    ).then((_) async {
                      if (mounted) {
                        await Provider.of<OdooClientManager>(context,
                                listen: false)
                            .updateUserImage();
                        setState(() {});
                      }
                    });
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage:
                        (imageBase64 != null && !isSvgBytes(imageBase64))
                            ? MemoryImage(base64Decode(imageBase64))
                            : null,
                    child: imageBase64 == null
                        ? const Icon(
                            HugeIcons.strokeRoundedUserCircle,
                            size: 20,
                            color: Colors.black,
                          )
                        : isSvgBytes(imageBase64)
                            ? ClipOval(
                                child: SvgPicture.memory(
                                  base64Decode(imageBase64),
                                  width: 36,
                                  height: 36,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : null,
                  ),
                );
              },
            ),
            SizedBox(
              width: 12,
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 0.0,
                left: 16.0,
                right: 16.0,
                bottom: 8.0,
              ),
              child: CustomSearchTextField(
                controller: provider.searchController,
                readOnly: provider.isLoading,
                hintText: 'Search by lead name or customer',
                onFilterTap: () =>
                    showFilterBottomSheet(context, clientprovider),
                onChanged: (query) {
                  if (query.isNotEmpty) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      provider.getLeads(
                          loading: false,
                          searchText: provider.searchController.text,
                          leadbeforeMonthclose: filterPreviousMonthClose,
                          leadbeforetwoMonthclose: filterTwoMonthsAgoClose,
                          leaddatefiltersclose: hasClosingDateFilters,
                          leadmonthNowclose: filterCurrentMonthClose,
                          stagefilters: hasStageFilters,
                          lost: filterLost,
                          partnerassigned: filterPartnerAssigned,
                          unAssigned: filterUnassigned,
                          leadfilter: hasLeadFilters,
                          context: context,
                          leadbeforeMonth: filterPreviousMonth,
                          leadmonthNow: filterCurrentMonth,
                          leaddatefilters: hasCreationDateFilters,
                          leadbeforetwoMonth: filterTwoMonthsAgo,
                          lateactivity: filterLateActivities,
                          todayactivity: filterTodayActivities,
                          futureactivity: filterFutureActivities,
                          activitycatgoryfilter: hasActivityCategoryFilters,
                          myactivities: filterMyActivities);
                    });
                  } else {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    provider.getLeads(
                        loading: false,
                        searchText: '',
                        leadbeforeMonthclose: filterPreviousMonthClose,
                        leadbeforetwoMonthclose: filterTwoMonthsAgoClose,
                        leaddatefiltersclose: hasClosingDateFilters,
                        leadmonthNowclose: filterCurrentMonthClose,
                        stagefilters: hasStageFilters,
                        lost: filterLost,
                        partnerassigned: filterPartnerAssigned,
                        unAssigned: filterUnassigned,
                        leadfilter: hasLeadFilters,
                        context: context,
                        leadbeforeMonth: filterPreviousMonth,
                        leadmonthNow: filterCurrentMonth,
                        leaddatefilters: hasCreationDateFilters,
                        leadbeforetwoMonth: filterTwoMonthsAgo,
                        lateactivity: filterLateActivities,
                        todayactivity: filterTodayActivities,
                        futureactivity: filterFutureActivities,
                        activitycatgoryfilter: hasActivityCategoryFilters,
                        myactivities: filterMyActivities);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
              ),
              child: _buildTopPaginationBar(provider, clientprovider),
            ),
            Expanded(
              child: viewWidgets[selectedTabIndex],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTopPaginationBar(
      LeadDataProvider provider, OdooClientManager odooInitProvider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                final groupBy = provider.currentGroupBy;
                final filters = provider.selectedFilters;

                final hasActiveFilters = filters.isNotEmpty;
                final hasGrouping = groupBy != GroupByOption.none;

                if (!hasActiveFilters && !hasGrouping) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 6),
                    child: Text(
                      "No filters applied",
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                List<Widget> chips = [];

                if (hasActiveFilters) {
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;
                  chips.add(
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: isDark ? Colors.grey[400]! : Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            filters.length.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (hasGrouping) {
                  String groupName = groupBy.toString().split('.').last;
                  groupName =
                      groupName[0].toUpperCase() + groupName.substring(1);

                  final displayNames = {
                    'stage': 'Stage',
                    'salesperson': 'Salesperson',
                    'team': 'Team',
                    'priority': 'Priority',
                    'partner': 'Customer',
                    'country': 'Country',
                    'createDate': 'Creation Date',
                    'expectedRevenue': 'Expected Revenue',
                    'probability': 'Probability',
                  };

                  groupName =
                      displayNames[groupName.toLowerCase()] ?? groupName;

                  chips.add(
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedLayer,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 50),
                            child: Text(
                              groupName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: chips
                        .expand((c) => [c, const SizedBox(width: 8)])
                        .toList()
                      ..removeLast(),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildViewSelector(provider),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Text(
                  "${provider.startRecord}-${provider.endRecord} / ${provider.groupedLeads.keys.length}",
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
              if (provider.totalPages > 1) ...[
                InkWell(
                  onTap: provider.hasPreviousPage
                      ? () => _goToPreviousPage(provider, odooInitProvider)
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    child: Icon(
                      HugeIcons.strokeRoundedArrowLeft01,
                      size: 20,
                      color: provider.hasPreviousPage
                          ? Colors.grey[700]
                          : Colors.grey[400],
                    ),
                  ),
                ),
                InkWell(
                  onTap: provider.hasNextPage
                      ? () => _goToNextPage(provider, odooInitProvider)
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    child: Icon(
                      HugeIcons.strokeRoundedArrowRight01,
                      size: 20,
                      color: provider.hasNextPage
                          ? Colors.grey[700]
                          : Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// Navigates to the previous page of leads.
  void _goToPreviousPage(
      LeadDataProvider provider, OdooClientManager odooInitProvider) {
    provider.goToPreviousPage(
      context: context,
      searchText: provider.searchController.text,
    );
  }

  /// Navigates to the next page of leads.
  void _goToNextPage(
      LeadDataProvider provider, OdooClientManager odooInitProvider) {
    provider.goToNextPage(
      context: context,
      searchText: provider.searchController.text,
    );
  }
}
