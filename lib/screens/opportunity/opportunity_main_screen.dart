import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:mobo_crm/global_methods/dialog%20boxes/lead_creation_dialog.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/dashboard/views/pipeline_view.dart';
import 'package:mobo_crm/screens/myActivities/mail/provider/mail_data_provider.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:mobo_crm/screens/opportunity/opportunity_views.dart';
import 'package:mobo_crm/screens/opportunity/grouped_opportunity_list_view.dart';
import 'package:mobo_crm/screens/others/configuration_screen.dart';
import 'package:mobo_crm/global_methods/bottom_sheets/filter_design_bottomsheet.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/searchfield_widget.dart';
import 'package:mobo_crm/global_methods/services/global_error_handler.dart';
import 'package:mobo_crm/global_methods/widgets/group_by_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/company/infrastructure/company_refresh_bus.dart';
import '../../core/company/providers/company_provider.dart';
import '../../core/company/widgets/company_selector_widget.dart';
import '../../services/storage_service.dart';
import '../../utils/globals.dart';
import '../../utils/snackbar.dart';

/// The main screen for managing and viewing opportunities.
///
/// This screen provides multiple views and filtering options for opportunities
/// in the CRM system. Users can interact with opportunities using various
/// views like Kanban, List (grouped or flat), Calendar, Graph, and Activity.
///
/// Features:
/// - Search opportunities by name or customer with debounce support.
/// - Apply complex filters, including status, stages, creation/closing dates,
///   and custom filters.
/// - Group opportunities dynamically by stage, salesperson, sales team,
///   customer, expected revenue, or probability.
/// - Pull-to-refresh and automatic data fetching on company switch.
/// - Floating action button to quickly create a new opportunity.
/// - Dynamic switching between different views (Kanban, List, Calendar, Graph, Activity).
/// - Handles loading, errors, and empty states gracefully.
/// - Shows the current user's avatar with navigation to settings.
///
/// Filtering:
/// - Status: Pipeline, Unassigned, Partner Assigned, Open
/// - Stage: Won, Lost, Ongoing
/// - Creation/Closing Dates: Current month, previous month, two months ago
/// - Custom filters can be applied and converted into Odoo domains.
///
/// Usage:
/// ```dart
/// OpportunityMainScreen(isCustom: true);
/// ```
///
/// Notes:
/// - This screen listens to the `CompanyRefreshBus` to reload data when
///   the selected company changes.
/// - Uses `OpportunityDataProvider` and `OdooClientManager` for data management.
/// - Integrates multiple UI components such as `GroupedOpportunityListView`,
///   `OpportunityListView`, `OpportunityKanbanView`, `OpportunityCalendar`,
///   `PipelineGraphWidget`, and `OpportunityActivity`.
/// - Search input supports clearing and opens the filter & group-by bottom sheet.
///
/// Example of showing filters programmatically:
/// ```dart
/// showOpportunityFilterBottomSheet(context, clientProvider);
/// ```
class OpportunityMainScreen extends StatefulWidget {
  final bool isCustom;

  const OpportunityMainScreen({super.key, this.isCustom = true});

  @override
  State<OpportunityMainScreen> createState() => OpportunityMainScreenState();
}

/// The state of [OpportunityMainScreen].
///
/// Manages:
/// - Search input and debounce for querying opportunities.
/// - Filtering and grouping logic with UI state.
/// - View switching and pagination.
/// - Handling company change events.
/// - Refreshing data for different views.
/// - Floating action button for creating new opportunities.
class OpportunityMainScreenState extends State<OpportunityMainScreen> {
  late final StreamSubscription _companySub;

  /// Resets all local filter flags to their default values.
  void resetLocalFilterFlags() {
    setState(() {
      filterByPipeline = true;
      hasPipelineFilters = false;
      hasStageFilters = false;
      filterUnassigned = false;
      filterPartnerAssigned = false;
      filterOpenOpportunities = false;
      filterWon = false;
      filterLost = false;
      filterOngoing = false;

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initialize());
  }

  Future<void> initialize() async {
    final clientManager =
        Provider.of<OdooClientManager>(context, listen: false);

    context.read<CompanyProvider>().initialize();

    Provider.of<OpportunityDataProvider>(context, listen: false)
        .canManageSkills();
    if (widget.isCustom) {
      final opportunityProvider =
          Provider.of<OpportunityDataProvider>(context, listen: false);

      opportunityProvider.getOpportunities(
          context: context,
          isOpportunity: true,
          isLead: false,
          disablePagination: true);
    }
    if (clientManager.client != null) {
      Provider.of<MailDataProvider>(context, listen: false).fetchMailData();
    }
    _companySub = CompanyRefreshBus.stream.listen((_) async {
      if (!mounted) return;
      await context.read<CompanyProvider>().initialize();
      if (!mounted) return;
      final opportunityProvider =
          Provider.of<OpportunityDataProvider>(context, listen: false);
      opportunityProvider.getOpportunities(
          context: context,
          isOpportunity: true,
          isLead: false,
          disablePagination: true);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider =
          Provider.of<OpportunityDataProvider>(context, listen: false);
      provider.setSelectedFilters(["Pipeline"]);
    });
  }

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _companySub.cancel();
    super.dispose();
  }

  bool filterByPipeline = true;
  bool hasPipelineFilters = false;
  bool hasStageFilters = false;
  bool filterUnassigned = false;
  bool filterPartnerAssigned = false;
  bool filterOpenOpportunities = false;
  bool filterWon = false;

  bool filterLost = false;
  bool filterOngoing = false;
  bool filterCurrentMonth = false;
  bool filterPreviousMonth = false;
  bool filterTwoMonthsAgo = false;
  bool hasCreationDateFilters = false;
  bool filterPreviousMonthClose = false;
  bool filterTwoMonthsAgoClose = false;
  bool hasClosingDateFilters = false;
  bool filterCurrentMonthClose = false;

  List<dynamic> customFilters = [];
  bool hasCustomFilters = false;

  /// Displays the bottom sheet for filtering and grouping opportunities.
  ///
  /// Applies changes to the [OpportunityDataProvider] and refreshes the list.
  void showOpportunityFilterBottomSheet(
      BuildContext context, OdooClientManager clientprovider) {
    final opportunityProvider =
        Provider.of<OpportunityDataProvider>(context, listen: false);

    DateTime now = DateTime.now();
    String currentMonth = DateFormat('MMMM yyyy').format(now);
    String previousMonth =
        DateFormat('MMMM yyyy').format(DateTime(now.year, now.month - 1, 1));
    String twoMonthsAgo =
        DateFormat('MMMM yyyy').format(DateTime(now.year, now.month - 2, 1));

    List<FilterGroup> opportunityFilters = [
      FilterGroup(
        title: "Status",
        options: [
          FilterOption(
            title: "Pipeline",
            value: filterByPipeline,
          ),
          FilterOption(
            title: "Unassigned",
            value: filterUnassigned,
          ),
          FilterOption(
            title: "Partner Assigned",
            value: filterPartnerAssigned,
          ),
          FilterOption(
            title: "Open Opportunities",
            value: filterOpenOpportunities,
          ),
        ],
      ),
      FilterGroup(title: "Stages", options: [
        FilterOption(
          title: "Won",
          value: filterWon,
        ),
        FilterOption(
          title: "Lost",
          value: filterLost,
        ),
        FilterOption(
          title: "Ongoing",
          value: filterOngoing,
        ),
      ]),
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
    ];

    List<FilterGroup> groupByOptions = [
      FilterGroup(
        title: "Group By Options",
        isExpanded: true,
        options: [
          FilterOption(
            title: "None",
            value: opportunityProvider.currentGroupBy == GroupByOption.none,
          ),
          FilterOption(
            title: "Stage",
            value: opportunityProvider.currentGroupBy == GroupByOption.stage,
          ),
          FilterOption(
            title: "Salesperson",
            value:
                opportunityProvider.currentGroupBy == GroupByOption.salesperson,
          ),
          FilterOption(
            title: "Sales Team",
            value: opportunityProvider.currentGroupBy == GroupByOption.team,
          ),
          FilterOption(
            title: "Customer",
            value: opportunityProvider.currentGroupBy == GroupByOption.partner,
          ),
          FilterOption(
            title: "Expected Revenue",
            value: opportunityProvider.currentGroupBy ==
                GroupByOption.expectedRevenue,
          ),
          FilterOption(
            title: "Probability",
            value:
                opportunityProvider.currentGroupBy == GroupByOption.probability,
          ),
        ],
      ),
    ];

    List<String> _buildActiveFilterLabels() {
      final labels = <String>[];

      if (filterByPipeline) labels.add("Pipeline");
      if (filterUnassigned) labels.add("Unassigned");
      if (filterPartnerAssigned) labels.add("With Partner");
      if (filterOpenOpportunities) labels.add("Open");
      if (filterWon) labels.add("Won");
      if (filterLost) labels.add("Lost");
      if (filterOngoing) labels.add("Ongoing");

      if (filterCurrentMonth) labels.add("Created This Month");
      if (filterPreviousMonth) labels.add("Created Last Month");
      if (filterTwoMonthsAgo) labels.add("Created 2 Months Ago");

      if (filterCurrentMonthClose) labels.add("Closing This Month");
      if (filterPreviousMonthClose) labels.add("Closing Last Month");
      if (filterTwoMonthsAgoClose) labels.add("Closing 2 Months Ago");

      if (hasCustomFilters) {
        labels.add("Custom Filters");
      }

      return labels;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PremiumFilterBottomSheet(
        title: 'Filter Opportunities',
        primaryColor: AppStyle.primaryColor,
        filterGroups: opportunityFilters,
        groupByOptions: groupByOptions,
        client: clientprovider.client,
        session: clientprovider.currentsession,
        model: 'crm.lead',
        onApply: (values) async {
          setState(() {
            filterByPipeline = values['status_pipeline'] ?? false;
            filterUnassigned = values['status_unassigned'] ?? false;
            filterPartnerAssigned = values['status_partner_assigned'] ?? false;
            filterOpenOpportunities =
                values['status_open_opportunities'] ?? false;
            filterWon = values['stages_won'] ?? false;
            filterLost = values['stages_lost'] ?? false;
            filterOngoing = values['stages_ongoing'] ?? false;

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

            bool groupByChanged = false;
            if (values['group_by_options_none'] == true) {
              opportunityProvider.setGroupBy(GroupByOption.none);
              groupByChanged = true;
            } else if (values['group_by_options_stage'] == true) {
              opportunityProvider.setGroupBy(GroupByOption.stage);
              groupByChanged = true;
            } else if (values['group_by_options_salesperson'] == true) {
              opportunityProvider.setGroupBy(GroupByOption.salesperson);
              groupByChanged = true;
            } else if (values['group_by_options_sales_team'] == true) {
              opportunityProvider.setGroupBy(GroupByOption.team);
              groupByChanged = true;
            } else if (values['group_by_options_customer'] == true) {
              opportunityProvider.setGroupBy(GroupByOption.partner);
              groupByChanged = true;
            } else if (values['group_by_options_expected_revenue'] == true) {
              opportunityProvider.setGroupBy(GroupByOption.expectedRevenue);
              groupByChanged = true;
            } else if (values['group_by_options_probability'] == true) {
              opportunityProvider.setGroupBy(GroupByOption.probability);
              groupByChanged = true;
            } else {
              bool anyGroupBySelected =
                  values['group_by_options_none'] == true ||
                      values['group_by_options_stage'] == true ||
                      values['group_by_options_salesperson'] == true ||
                      values['group_by_options_sales_team'] == true ||
                      values['group_by_options_customer'] == true ||
                      values['group_by_options_expected_revenue'] == true ||
                      values['group_by_options_probability'] == true;

              if (!anyGroupBySelected) {
                opportunityProvider.setGroupBy(GroupByOption.none);
                groupByChanged = true;
              }
            }

            bool shouldSwitchToGroupedList = false;

            if (groupByChanged) {
              shouldSwitchToGroupedList =
                  opportunityProvider.currentGroupBy != GroupByOption.none;
            }

            if (shouldSwitchToGroupedList) {
              if (opportunityProvider.selectedViewIndex != 1) {
                opportunityProvider.updateViewIndex(1);
              }
            }

            hasPipelineFilters = filterUnassigned ||
                filterPartnerAssigned ||
                filterOpenOpportunities ||
                filterByPipeline;
            hasStageFilters = filterLost || filterWon || filterOngoing;
            hasCreationDateFilters =
                filterCurrentMonth || filterPreviousMonth || filterTwoMonthsAgo;
            hasClosingDateFilters = filterCurrentMonthClose ||
                filterPreviousMonthClose ||
                filterTwoMonthsAgoClose;
          });
          final activeLabels = _buildActiveFilterLabels();
          opportunityProvider.setSelectedFilters(activeLabels);
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

          final dataProvider =
              Provider.of<OpportunityDataProvider>(context, listen: false);

          dataProvider.resetPagination();

          dataProvider.getOpportunities(
              searchText: dataProvider.searchController.text,
              isOpportunity: true,
              loading: true,
              beforeMonthclose: filterPreviousMonthClose,
              beforetwoMonthclose: filterTwoMonthsAgoClose,
              monthNowclose: filterCurrentMonthClose,
              unAssigned: filterUnassigned,
              monthNow: filterCurrentMonth,
              beforeMonth: filterPreviousMonth,
              beforetwoMonth: filterTwoMonthsAgo,
              lost: filterLost,
              datefilters: hasCreationDateFilters,
              ongoing: filterOngoing,
              opeopportunity: filterOpenOpportunities,
              partnerassigned: filterPartnerAssigned,
              context: context,
              isPipeline: filterByPipeline,
              pipelinefilters: true,
              stagefilters: hasStageFilters,
              datefilterclose: hasClosingDateFilters,
              won: filterWon,
              customFilter: hasCustomFilters ? customFilters : null,
              disablePagination: dataProvider.selectedViewIndex == 0);
        },
      ),
    );
  }

  /// Converts custom filter rules to an Odoo domain format.
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

  /// Converts user-friendly operators to Odoo-compatible operators.
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

  /// Refreshes the opportunities list, optionally for the Kanban view.
  Future<void> _refreshOpportunities({bool forKanban = false}) async {
    final provider =
        Provider.of<OpportunityDataProvider>(context, listen: false);
    await provider.getOpportunities(
      isOpportunity: true,
      searchText: provider.searchController.text,
      beforeMonthclose: filterPreviousMonthClose,
      beforetwoMonthclose: filterTwoMonthsAgoClose,
      monthNowclose: filterCurrentMonthClose,
      unAssigned: filterUnassigned,
      monthNow: filterCurrentMonth,
      beforeMonth: filterPreviousMonth,
      beforetwoMonth: filterTwoMonthsAgo,
      lost: filterLost,
      datefilters: hasCreationDateFilters,
      ongoing: filterOngoing,
      opeopportunity: filterOpenOpportunities,
      partnerassigned: filterPartnerAssigned,
      context: context,
      isPipeline: filterByPipeline,
      pipelinefilters: true,
      stagefilters: hasStageFilters,
      datefilterclose: hasClosingDateFilters,
      won: filterWon,
      customFilter: hasCustomFilters ? customFilters : null,
      loading: true,
      disablePagination: forKanban,
    );
  }

  /// Returns the list of view widgets corresponding to the tab index.
  List<Widget> get viewWidgets {
    final provider =
        Provider.of<OpportunityDataProvider>(context, listen: false);
    return [
      OpportunityKanbanView(
          onRefresh: () => _refreshOpportunities(forKanban: true)),
      provider.currentGroupBy != GroupByOption.none
          ? GroupedOpportunityListView(
              isPipeline: true,
              onRefresh: () => _refreshOpportunities(forKanban: false))
          : OpportunityListView(
              isPipeline: true,
              onRefresh: () => _refreshOpportunities(forKanban: false)),
      OpportunityCalendar(
          onRefresh: () => _refreshOpportunities(forKanban: false)),
      PipelineGraphWidget(),
      OpportunityActivity(
          onRefresh: () => _refreshOpportunities(forKanban: false))
    ];
  }

  final List<IconData> tabIconsOpportunity = [
    Icons.view_kanban,
    Icons.menu,
    Icons.calendar_today,
    Icons.pie_chart_outline_sharp,
    Icons.access_time,
  ];

  /// Retrieves the current user's profile image from local storage.
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

  @override
  Widget build(BuildContext context) {
    return Consumer2<OpportunityDataProvider, OdooClientManager>(
        builder: (context, provider, clientprovider, child) {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => OpportunityLeadDialog(
                  stageId: 1,
                ),
              );
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 28,
            ),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF181A20) : const Color(0xFFFAFAFA),
          appBar: AppBar(
            backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF181A20) : const Color(0xFFFAFAFA),
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: false,
            title: Text(
              'Opportunity',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
                color: Colors.black,
              ),
            ),
            automaticallyImplyLeading: false,
            actions: [
              CompanySelectorWidget(
                onCompanyChanged: () async {
                  if (!mounted) return;
                  final provider = context.read<CompanyProvider>();
                  final companyName =
                      provider.selectedCompany?['name']?.toString() ??
                          'company';
                  CompanyRefreshBus.notify();

                  CustomSnackbar.showSuccess(
                      context, 'Switched to $companyName');
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
                        await Provider.of<OdooClientManager>(context,
                                listen: false)
                            .updateUserImage();

                        if (!mounted) return;

                        setState(() {});
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
                  bottom: 16.0,
                ),
                child: CustomSearchTextField(
                  controller: provider.searchController,
                  readOnly: provider.isLoading,
                  hintText: 'Search by opportunity name or customer',
                  onFilterTap: () => showOpportunityFilterBottomSheet(
                      context, clientprovider),
                  onChanged: (query) {
                    if (query.isNotEmpty) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce =
                          Timer(const Duration(milliseconds: 500), () {
                        provider.getOpportunities(
                          isOpportunity: true,
                          searchText: provider.searchController.text,
                          beforeMonthclose: filterPreviousMonthClose,
                          beforetwoMonthclose: filterTwoMonthsAgoClose,
                          monthNowclose: filterCurrentMonthClose,
                          unAssigned: filterUnassigned,
                          monthNow: filterCurrentMonth,
                          beforeMonth: filterPreviousMonth,
                          beforetwoMonth: filterTwoMonthsAgo,
                          lost: filterLost,
                          datefilters: hasCreationDateFilters,
                          ongoing: filterOngoing,
                          opeopportunity: filterOpenOpportunities,
                          partnerassigned: filterPartnerAssigned,
                          context: context,
                          isPipeline: filterByPipeline,
                          pipelinefilters: true,
                          stagefilters: hasStageFilters,
                          datefilterclose: hasClosingDateFilters,
                          won: filterWon,
                          disablePagination: provider.selectedViewIndex == 0,
                        );
                      });
                    } else {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      provider.getOpportunities(
                        isOpportunity: true,
                        searchText: '',
                        beforeMonthclose: filterPreviousMonthClose,
                        beforetwoMonthclose: filterTwoMonthsAgoClose,
                        monthNowclose: filterCurrentMonthClose,
                        unAssigned: filterUnassigned,
                        monthNow: filterCurrentMonth,
                        beforeMonth: filterPreviousMonth,
                        beforetwoMonth: filterTwoMonthsAgo,
                        lost: filterLost,
                        datefilters: hasCreationDateFilters,
                        ongoing: filterOngoing,
                        opeopportunity: filterOpenOpportunities,
                        partnerassigned: filterPartnerAssigned,
                        context: context,
                        isPipeline: filterByPipeline,
                        pipelinefilters: true,
                        stagefilters: hasStageFilters,
                        datefilterclose: hasClosingDateFilters,
                        won: filterWon,
                        disablePagination: provider.selectedViewIndex == 0,
                      );
                    }
                  },
                ),
              ),
              if (provider.hasError && provider.catchError != null) ...[
                Expanded(
                  child: ErrorScreen(
                    error: provider.catchError!,
                    onRetry: () {
                      provider.getOpportunities(
                          context: context,
                          isOpportunity: true,
                          isLead: false,
                          loading: true);
                    },
                  ),
                )
              ] else ...[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                  ),
                  child: _buildTopPaginationBar(provider, clientprovider),
                ),
                Expanded(child: viewWidgets[provider.selectedViewIndex])
              ],
            ],
          ));
    });
  }

  Widget _buildTopPaginationBar(
      OpportunityDataProvider provider, OdooClientManager odooInitProvider) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 400;
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
              buildViewSelector(context, provider),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmall ? 6 : 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Text(
                  "${provider.startRecord}-${provider.endRecord} / ${provider.totalCount}",
                  style: TextStyle(fontSize: isSmall ? 11 : 13, color: Colors.black87),
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

  void _goToPreviousPage(
      OpportunityDataProvider provider, OdooClientManager odooInitProvider) {
    provider.goToPreviousPage(
      context: context,
      isOpportunity: true,
      isLead: false,
      searchText: provider.searchController.text,
    );
  }

  void _goToNextPage(
      OpportunityDataProvider provider, OdooClientManager odooInitProvider) {
    provider.goToNextPage(
      context: context,
      isOpportunity: true,
      isLead: false,
      searchText: provider.searchController.text,
    );
  }
}
