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
import 'package:mobo_crm/screens/quotation/grouped_quotation_list_view.dart';
import 'package:mobo_crm/screens/quotation/new_quotation_form.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_form_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_view_provider.dart';
import 'package:mobo_crm/screens/quotation/quotation_views.dart';
import 'package:mobo_crm/screens/settings/screens/profile/provider/provider_profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/company/infrastructure/company_refresh_bus.dart';
import '../../core/company/providers/company_provider.dart';
import '../../core/company/session/company_session_manager.dart';
import '../../core/company/widgets/company_selector_widget.dart';
import '../../services/storage_service.dart';
import '../../utils/globals.dart';
import '../../utils/snackbar.dart';
import '../others/configuration_screen.dart';

/// Main screen for displaying and managing quotations.
///
/// Provides the following features:
/// - List, Kanban, Calendar, Graph, and Activity views for quotations.
/// - Search by quotation ID or customer.
/// - Filter and Group By options with dynamic bottom sheet.
/// - Floating action button to create a new quotation (if Sale module installed).
/// - Integration with multiple companies and user profile.
class QuotationMainScreen extends StatefulWidget {
  final bool isCustom;

  const QuotationMainScreen({super.key, this.isCustom = true});

  @override
  State<QuotationMainScreen> createState() => QuotationMainScreenState();
}

Timer? _debounce;
bool isMyquotation = true;
bool isQuotation = false;
bool isSale = false;
bool isSalesOrder = false;
bool isLocked = false;
bool isCancelled = false;
bool showCreationDate = false;
bool currentMonthBool = false;
bool previousMonthBool = false;
bool twoMonthsBefore = false;
String selectedDateFilter = 'All';

/// Holds the state for [QuotationMainScreen].
///
/// Manages UI state, filters, search, group by options, and interactions with
/// `QuotationViewProvider` and `QuotationFormProvider`.
class QuotationMainScreenState extends State<QuotationMainScreen> {
  int _selectedIndex = 0;
  late final StreamSubscription _companySub;

  @override
  void initState() {
    super.initState();

    _loadQuotationData();

    final quotationProvider =
        Provider.of<QuotationFormProvider>(context, listen: false);
    final clientManager =
        Provider.of<OdooClientManager>(context, listen: false);
    final client = clientManager.client;

    if (client != null) {
      quotationProvider.checkSaleModuleInstallation(client);
      Provider.of<QuotationViewProvider>(context, listen: false)
          .checkSaleModuleInstallation(client);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        final freshClient = await CompanySessionManager.getClientEnsured();
        if (!mounted) return;
        quotationProvider.checkSaleModuleInstallation(freshClient);
        Provider.of<QuotationViewProvider>(context, listen: false)
            .checkSaleModuleInstallation(freshClient);
      });
    }

    _companySub = CompanyRefreshBus.stream.listen((_) async {
      if (!mounted) return;
      await context.read<CompanyProvider>().initialize();
      if (!mounted) return;
      _loadQuotationData();
    });
  }

  /// Resets all local filter flags to their default values.
  void resetLocalFilterFlags() {
    setState(() {
      isMyquotation = true;
      isQuotation = false;
      isSale = false;
      isSalesOrder = false;
      isLocked = false;
      isCancelled = false;
      showCreationDate = false;
      currentMonthBool = false;
      previousMonthBool = false;
      twoMonthsBefore = false;
      selectedDateFilter = 'All';
    });
  }

  @override
  void dispose() {
    _companySub.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadQuotationData();
  }

  /// Loads quotations and reports using the current session and client.
  void _loadQuotationData() {
    final clientprovider =
        Provider.of<OdooClientManager>(context, listen: false);

    if (widget.isCustom &&
        clientprovider.client != null &&
        clientprovider.currentsession != null) {
      final quotationprvider =
          Provider.of<QuotationViewProvider>(context, listen: false);

      quotationprvider.getQuotationsAndReport(
          context: context, session: clientprovider.currentsession!);
    }
  }

  /// Opens the filter bottom sheet for quotations.
  ///
  /// Provides options for:
  /// - Quotation type (My Quotation, Quotation, Sale)
  /// - Creation date filters (Current month, Previous month, Two months ago)
  /// - Custom filters (Status, Invoice Status, Amount, Activity, Order Date)
  /// - Dynamic Group By options fetched from the server
  Future<void> showQuotationFilterSheet(BuildContext context) async {
    final quotationProvider =
        Provider.of<QuotationViewProvider>(context, listen: false);
    final clientProvider =
        Provider.of<OdooClientManager>(context, listen: false);

    DateTime now = DateTime.now();
    String currentMonth = DateFormat('MMMM yyyy').format(now);
    String previousMonth =
        DateFormat('MMMM yyyy').format(DateTime(now.year, now.month - 1, 1));
    String twoMonthsAgo =
        DateFormat('MMMM yyyy').format(DateTime(now.year, now.month - 2, 1));

    List<FilterGroup> filterGroups = [
      FilterGroup(
        title: "Quotation Type",
        options: [
          FilterOption(
            title: "My Quotation",
            value: isMyquotation,
          ),
          FilterOption(
            title: "Quotations",
            value: isQuotation,
          ),
          FilterOption(
            title: "Sale",
            value: isSale,
          ),
        ],
      ),
      FilterGroup(
        title: "Creation Date",
        isExpanded: showCreationDate,
        options: [
          FilterOption(
            title: currentMonth,
            value: currentMonthBool,
          ),
          FilterOption(
            title: previousMonth,
            value: previousMonthBool,
          ),
          FilterOption(
            title: twoMonthsAgo,
            value: twoMonthsBefore,
          ),
        ],
      ),
    ];

    List<FilterGroup> groupByOptions =
        await _fetchDynamicGroupByOptions(context, quotationProvider);

    List<FilterGroup> customFilterGroups = [
      FilterGroup(
        title: "Status Filters",
        isExpanded: true,
        options: [
          FilterOption(
            title: "Status",
            value: false,
            type: 'multi_select',
            options: [
              {'id': 'draft', 'name': 'Quotation'},
              {'id': 'sent', 'name': 'Quotation Sent'},
              {'id': 'sale', 'name': 'Sales Order'},
              {'id': 'done', 'name': 'Locked'},
              {'id': 'cancel', 'name': 'Cancelled'},
            ],
            selectedValue: <int>[],
          ),
          FilterOption(
            title: "Invoice Status",
            value: false,
            type: 'multi_select',
            options: [
              {'id': 'upselling', 'name': 'Upselling Opportunity'},
              {'id': 'invoiced', 'name': 'Fully Invoiced'},
              {'id': 'to invoice', 'name': 'To Invoice'},
              {'id': 'no', 'name': 'Nothing to Invoice'},
            ],
            selectedValue: <int>[],
          ),
        ],
      ),
      FilterGroup(
        title: "Amount & Date Filters",
        isExpanded: false,
        options: [
          FilterOption(
            title: "Amount Range",
            value: false,
            type: 'range',
            rangeData: {'min': 0.0, 'max': 1000000.0},
            selectedValue: {'min': 0.0, 'max': 1000000.0},
          ),
          FilterOption(
            title: "Order Date Range",
            value: false,
            type: 'date_range',
            selectedValue: <String, DateTime?>{},
          ),
        ],
      ),
      FilterGroup(
        title: "Activity Filters",
        isExpanded: false,
        options: [
          FilterOption(
            title: "Has Activities",
            value: false,
            type: 'checkbox',
          ),
          FilterOption(
            title: "Overdue Activities",
            value: false,
            type: 'checkbox',
          ),
          FilterOption(
            title: "My Quotations Only",
            value: false,
            type: 'checkbox',
          ),
        ],
      ),
    ];

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PremiumFilterBottomSheet(
        title: 'Filter Quotations',
        primaryColor: AppStyle.primaryColor,
        filterGroups: filterGroups,
        customFilterGroups: customFilterGroups,
        groupByOptions: groupByOptions,
        client: clientProvider.client,
        session: clientProvider.currentsession,
        model: 'sale.order',
        onApply: (values) {
          final clientProvider =
              Provider.of<OdooClientManager>(context, listen: false);
          final quotationProvider =
              Provider.of<QuotationViewProvider>(context, listen: false);

          List<String> newSelectedFilters = [];
          if (values['quotation_type_my_quotation'] == true) {
            newSelectedFilters.add("My Quotations");
          }
          if (values['quotation_type_quotations'] == true) {
            newSelectedFilters.add("Quotations");
          }
          if (values['quotation_type_sale'] == true) {
            newSelectedFilters.add("Sales Orders");
          }
          if (values.values.any((v) =>
              v == true &&
              (values.keys.any((k) => k.startsWith('creation_date_'))))) {
            if (currentMonthBool) newSelectedFilters.add("This Month");
            if (previousMonthBool) newSelectedFilters.add("Previous Month");
            if (twoMonthsBefore) newSelectedFilters.add("Two Months Ago");
          }
          setState(() {
            quotationProvider.selectedFilters = newSelectedFilters;
          });

          Map<String, dynamic>? customFilterRules;
          if (values['custom_filters'] != null) {
            customFilterRules = values;
          }

          setState(() {
            isMyquotation = values['quotation_type_my_quotation'] ?? false;
            isQuotation = values['quotation_type_quotations'] ?? false;
            isSale = values['quotation_type_sale'] ?? false;
            currentMonthBool = values.values.contains(true) &&
                values.keys.any((key) =>
                    key.startsWith('creation_date_') &&
                    key.contains(DateFormat('MMMM')
                        .format(DateTime.now())
                        .toLowerCase()) &&
                    values[key] == true);

            previousMonthBool = values.values.contains(true) &&
                values.keys.any((key) =>
                    key.startsWith('creation_date_') &&
                    key.contains(DateFormat('MMMM')
                        .format(DateTime(
                            DateTime.now().year, DateTime.now().month - 1))
                        .toLowerCase()) &&
                    values[key] == true);

            twoMonthsBefore = values.values.contains(true) &&
                values.keys.any((key) =>
                    key.startsWith('creation_date_') &&
                    key.contains(DateFormat('MMMM')
                        .format(DateTime(
                            DateTime.now().year, DateTime.now().month - 2))
                        .toLowerCase()) &&
                    values[key] == true);

            if (currentMonthBool) {
              selectedDateFilter = 'This Month';
            } else if (previousMonthBool) {
              selectedDateFilter = 'Previous Month';
            } else if (twoMonthsBefore) {
              selectedDateFilter = 'Two Months Ago';
            } else {
              selectedDateFilter = 'All';
            }

            if (values['group_by_options_none'] == true) {
              quotationProvider.setGroupBy(GroupByOption.none);
            } else if (values['group_by_options_status'] == true) {
              quotationProvider.setGroupBy(GroupByOption.stage);
            } else if (values['group_by_options_salesperson'] == true) {
              quotationProvider.setGroupBy(GroupByOption.salesperson);
            } else if (values['group_by_options_customer'] == true) {
              quotationProvider.setGroupBy(GroupByOption.partner);
            } else if (values['group_by_options_sales_team'] == true) {
              quotationProvider.setGroupBy(GroupByOption.team);
            } else if (values['group_by_options_country'] == true) {
              quotationProvider.setGroupBy(GroupByOption.country);
            } else if (values['group_by_options_creation_date'] == true) {
              quotationProvider.setGroupBy(GroupByOption.createDate);
            } else if (values['group_by_options_expected_revenue'] == true) {
              quotationProvider.setGroupBy(GroupByOption.expectedRevenue);
            } else if (values['group_by_options_invoice_status'] == true) {
              quotationProvider.setGroupBy(GroupByOption.priority);
            } else {
              bool anyGroupBySelected = values.keys.any((key) =>
                  key.startsWith('group_by_options_') && values[key] == true);

              if (!anyGroupBySelected) {
                quotationProvider.setGroupBy(GroupByOption.none);
              }
            }

            if (quotationProvider.currentGroupBy != GroupByOption.none) {
              _selectedIndex = 0;
            }
            showCreationDate =
                currentMonthBool || previousMonthBool || twoMonthsBefore;
          });

          quotationProvider.getQuotationsAndReport(
            searchText: quotationProvider.searchController.text,
            context: context,
            loading: true,
            isQuotation: isQuotation,
            isSale: isSale,
            isPipeline: isMyquotation,
            showCreationDate: showCreationDate,
            currentMonth: currentMonthBool,
            previousMonth: previousMonthBool,
            twoMonthsBefore: twoMonthsBefore,
            customFilterRules: customFilterRules,
            session: clientProvider.currentsession!,
          );
        },
      ),
    );
  }

  /// Fetches dynamic Group By options from the server.
  ///
  /// Returns a list of [FilterGroup] containing the available Group By options.
  Future<List<FilterGroup>> _fetchDynamicGroupByOptions(
      BuildContext context, QuotationViewProvider quotationProvider) async {
    final clientProvider =
        Provider.of<OdooClientManager>(context, listen: false);
    final client = clientProvider.client;

    List<FilterOption> groupByFilterOptions = [
      FilterOption(
        title: "None",
        value: quotationProvider.currentGroupBy == GroupByOption.none,
      ),
    ];

    if (client != null) {
      try {
        final sampleResponse = await CompanySessionManager.callKwWithCompany({
          'model': 'sale.order',
          'method': 'search_read',
          'args': [[]],
          'kwargs': {
            'fields': [
              'state',
              'user_id',
              'partner_id',
              'team_id',
              'company_id',
              'date_order',
              'amount_total',
              'invoice_status',
              'pricelist_id',
              'payment_term_id',
              'tag_ids',
              'country_id'
            ],
            'limit': 100,
            'order': 'id desc',
          },
        });

        if (sampleResponse is List && sampleResponse.isNotEmpty) {
          Set<String> states = {};
          Set<int?> salespeople = {};
          Set<int?> customers = {};
          Set<int?> teams = {};
          Set<int?> companies = {};
          Set<String> invoiceStatuses = {};
          Set<int?> pricelists = {};
          Set<int?> paymentTerms = {};
          Set<int?> countries = {};

          for (var quotation in sampleResponse) {
            if (quotation['state'] != null) {
              states.add(quotation['state'].toString());
            }

            if (quotation['user_id'] is List &&
                quotation['user_id'].length > 1) {
              salespeople.add(quotation['user_id'][0] as int?);
            }

            if (quotation['partner_id'] is List &&
                quotation['partner_id'].length > 1) {
              customers.add(quotation['partner_id'][0] as int?);
            }

            if (quotation['team_id'] is List &&
                quotation['team_id'].length > 1) {
              teams.add(quotation['team_id'][0] as int?);
            }

            if (quotation['company_id'] is List &&
                quotation['company_id'].length > 1) {
              companies.add(quotation['company_id'][0] as int?);
            }

            if (quotation['invoice_status'] != null) {
              invoiceStatuses.add(quotation['invoice_status'].toString());
            }

            if (quotation['pricelist_id'] is List &&
                quotation['pricelist_id'].length > 1) {
              pricelists.add(quotation['pricelist_id'][0] as int?);
            }

            if (quotation['payment_term_id'] is List &&
                quotation['payment_term_id'].length > 1) {
              paymentTerms.add(quotation['payment_term_id'][0] as int?);
            }

            if (quotation['country_id'] is List &&
                quotation['country_id'].length > 1) {
              countries.add(quotation['country_id'][0] as int?);
            }
          }

          if (states.length > 1) {
            groupByFilterOptions.add(FilterOption(
              title: "Status",
              value: quotationProvider.currentGroupBy == GroupByOption.stage,
            ));
          }

          if (salespeople.length > 1) {
            groupByFilterOptions.add(FilterOption(
              title: "Salesperson",
              value:
                  quotationProvider.currentGroupBy == GroupByOption.salesperson,
            ));
          }

          if (customers.length > 1) {
            groupByFilterOptions.add(FilterOption(
              title: "Customer",
              value: quotationProvider.currentGroupBy == GroupByOption.partner,
            ));
          }

          if (teams.length > 1) {
            groupByFilterOptions.add(FilterOption(
              title: "Sales Team",
              value: quotationProvider.currentGroupBy == GroupByOption.team,
            ));
          }

          if (invoiceStatuses.length > 1) {
            groupByFilterOptions.add(FilterOption(
              title: "Invoice Status",
              value: quotationProvider.currentGroupBy == GroupByOption.priority,
            ));
          }

          if (countries.length > 1) {
            groupByFilterOptions.add(FilterOption(
              title: "Country",
              value: quotationProvider.currentGroupBy == GroupByOption.country,
            ));
          }

          groupByFilterOptions.add(FilterOption(
            title: "Creation Date",
            value: quotationProvider.currentGroupBy == GroupByOption.createDate,
          ));

          groupByFilterOptions.add(FilterOption(
            title: "Expected Revenue",
            value: quotationProvider.currentGroupBy ==
                GroupByOption.expectedRevenue,
          ));
        }
      } catch (e) {
        groupByFilterOptions.addAll([
          FilterOption(
            title: "Status",
            value: quotationProvider.currentGroupBy == GroupByOption.stage,
          ),
          FilterOption(
            title: "Salesperson",
            value:
                quotationProvider.currentGroupBy == GroupByOption.salesperson,
          ),
          FilterOption(
            title: "Customer",
            value: quotationProvider.currentGroupBy == GroupByOption.partner,
          ),
        ]);
      }
    } else {
      groupByFilterOptions.addAll([
        FilterOption(
          title: "Status",
          value: quotationProvider.currentGroupBy == GroupByOption.stage,
        ),
        FilterOption(
          title: "Salesperson",
          value: quotationProvider.currentGroupBy == GroupByOption.salesperson,
        ),
        FilterOption(
          title: "Customer",
          value: quotationProvider.currentGroupBy == GroupByOption.partner,
        ),
      ]);
    }

    return [
      FilterGroup(
        title: "Group By Options",
        isExpanded: true,
        options: groupByFilterOptions,
      ),
    ];
  }

  /// Refreshes the quotation list by fetching data from the server.
  Future<void> _refreshQuotations() async {
    final quotationProvider =
        Provider.of<QuotationViewProvider>(context, listen: false);
    final clientProvider =
        Provider.of<OdooClientManager>(context, listen: false);

    await quotationProvider.getQuotationsAndReport(
      loading: true,
      context: context,
      session: clientProvider.currentsession!,
    );
  }

  /// Returns a list of widgets representing different quotation views.
  ///
  /// Views include:
  /// - List / Grouped List
  /// - Kanban
  /// - Calendar
  /// - Graph
  /// - Activity
  List<Widget> get widgets {
    final quotationProvider =
        Provider.of<QuotationViewProvider>(context, listen: false);
    return [
      quotationProvider.currentGroupBy != GroupByOption.none
          ? GroupedQuotationListView(onRefresh: _refreshQuotations)
          : QuotationListView(onRefresh: _refreshQuotations),
      QuotationKanbanView(onRefresh: _refreshQuotations),
      QuotationCalendarView(onRefresh: _refreshQuotations),
      QuotationGraphView(onRefresh: _refreshQuotations),
      QuotationActivityView(onRefresh: _refreshQuotations),
    ];
  }

  /// List of icons for the different quotation views.
  final List<IconData> quotationicons = [
    Icons.menu,
    Icons.view_kanban,
    Icons.calendar_today,
    Icons.pie_chart_outline_sharp,
    Icons.access_time,
  ];

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

  /// Builds top pagination bar for grouped quotation list
  Widget _buildTopPaginationBar(
      QuotationViewProvider provider, OdooClientManager odooInitProvider) {
    if (!provider.isLoading &&
        provider.groupedQuotations.isEmpty &&
        provider.totalCount == 0) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                final activeFilters = provider.selectedFilters;
                final hasGroupBy =
                    provider.currentGroupBy != GroupByOption.none;
                final bool hasAnyActiveFilter = activeFilters.isNotEmpty ||
                    provider.isDefaultPipelineFilterActive ||
                    provider.hasCustomFilters;

                if (!hasAnyActiveFilter && !hasGroupBy) {
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

                if (activeFilters.isEmpty &&
                    provider.isDefaultPipelineFilterActive) {
                  final isDarkQ =
                      Theme.of(context).brightness == Brightness.dark;
                  chips.add(
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: isDarkQ ? Colors.grey[400]! : Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '1',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDarkQ ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkQ ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (activeFilters.isNotEmpty) {
                  final isDarkQ =
                      Theme.of(context).brightness == Brightness.dark;
                  chips.add(
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: isDarkQ ? Colors.grey[400]! : Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            activeFilters.length.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDarkQ ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkQ ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (hasGroupBy) {
                  String groupName =
                      provider.currentGroupBy.toString().split('.').last;
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
                  "${provider.startRecord}-${provider.endRecord} / ${provider.currentGroupBy == GroupByOption.none ? provider.totalCount : provider.groupedQuotations.keys.length}",
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

  /// Go to next pagination page
  Future<void> _goToNextPage(QuotationViewProvider provider,
      OdooClientManager odooInitProvider) async {
    await provider.goToNextPage(
      context: context,
      client: odooInitProvider.client!,
      session: odooInitProvider.currentsession!,
      isQuotation: true,
      customFilterRules: provider.customFilters,
    );
  }

  /// Go to previous pagination page
  Future<void> _goToPreviousPage(QuotationViewProvider provider,
      OdooClientManager odooInitProvider) async {
    await provider.goToPreviousPage(
      context: context,
      client: odooInitProvider.client!,
      session: odooInitProvider.currentsession!,
      isQuotation: true,
      customFilterRules: provider.customFilters,
    );
  }

  Widget _buildViewSelector(QuotationViewProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedItem = items[_selectedIndex];

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
          value: _selectedIndex,

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
                _selectedIndex = index;
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
            final isSelected = _selectedIndex == entry.key;

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
      QuotationViewProvider provider, OdooClientManager clientprovider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Text(
              "${provider.startRecord}-${provider.endRecord}/${provider.totalCount}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
        if (provider.totalPages > 1) ...[
          const SizedBox(width: 2),
          InkWell(
            onTap: provider.hasPreviousPage
                ? () => provider.getQuotationsAndReport(
                      context: context,
                      searchText: provider.searchController.text,
                      isQuotation: isQuotation,
                      isSale: isSale,
                      isPipeline: isMyquotation,
                      showCreationDate: showCreationDate,
                      currentMonth: currentMonthBool,
                      previousMonth: previousMonthBool,
                      twoMonthsBefore: twoMonthsBefore,
                      session: clientprovider.currentsession!,
                      resetPagination: false,
                    )
                : null,
            child: Icon(
              HugeIcons.strokeRoundedArrowLeft01,
              size: 18,
              color: provider.hasPreviousPage
                  ? (isDark ? Colors.white : Colors.grey[700])
                  : Colors.grey[400],
            ),
          ),
          const SizedBox(width: 2),
          InkWell(
            onTap: provider.hasNextPage
                ? () => provider.getQuotationsAndReport(
                      context: context,
                      searchText: provider.searchController.text,
                      isQuotation: isQuotation,
                      isSale: isSale,
                      isPipeline: isMyquotation,
                      showCreationDate: showCreationDate,
                      currentMonth: currentMonthBool,
                      previousMonth: previousMonthBool,
                      twoMonthsBefore: twoMonthsBefore,
                      session: clientprovider.currentsession!,
                      resetPagination: false,
                      loading: true,
                    )
                : null,
            child: Icon(
              HugeIcons.strokeRoundedArrowRight01,
              size: 18,
              color: provider.hasNextPage
                  ? (isDark ? Colors.white : Colors.grey[700])
                  : Colors.grey[400],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMeasureDropdown(QuotationViewProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filters = [
      'Count',
      'Currency Rate',
      'Prepayment Percentage',
      'Tax',
      'Total',
      'Untaxed Amount',
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
          value: provider.selectedFilterQuotation,
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

  Widget _buildGraphTypeToggles(QuotationViewProvider provider) {
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

  @override
  Widget build(BuildContext context) {
    return Consumer4<QuotationViewProvider, OdooClientManager,
            QuotationFormProvider, ProfileConfigurationProvider>(
        builder: (context, provider, clientprovider, quotationformprovider,
            profileprovider, child) {
      return Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF181A20) : const Color(0xFFFAFAFA),
          floatingActionButton: (quotationformprovider.isSaleInstalled)
              ? FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onPressed: () {
                    if (context.mounted) {
                      quotationformprovider.clearVariables();
                      quotationformprovider.setDefaultData(
                          context: context,
                          client: clientprovider.client!,
                          currentCountryId: clientprovider.countryId);
                      Navigator.push(
                          context,
                          SlidingPageTransitionRL(
                              page: NewQuotationForm(
                            isNew: true,
                            leadid: null,
                          ))).then((result) {
                        if (result == true && mounted) {
                          _refreshQuotations();
                        }
                      });
                    }
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 28,
                  ),
                )
              : null,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF181A20) : const Color(0xFFFAFAFA),
            elevation: 0,
            title: Text(
              'Quotations',
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
              SizedBox(
                height: 10,
              ),
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
                  hintText: 'Search by quotation ID or customer',
                  onFilterTap: () async => await showQuotationFilterSheet(context),
                  onChanged: (query) {
                    if (query.isNotEmpty) {
                      _debounce?.cancel();
                      _debounce =
                          Timer(const Duration(milliseconds: 500), () {
                        provider.getQuotationsAndReport(
                          searchText: query,
                          context: context,
                          isQuotation: isQuotation,
                          isSale: isSale,
                          isPipeline: isMyquotation,
                          showCreationDate: showCreationDate,
                          currentMonth: currentMonthBool,
                          previousMonth: previousMonthBool,
                          twoMonthsBefore: twoMonthsBefore,
                          customFilterRules: provider.hasCustomFilters
                              ? provider.customFilters
                              : null,
                          session: clientprovider.currentsession!,
                        );
                      });
                    } else {
                      provider.getQuotationsAndReport(
                        searchText: '',
                        context: context,
                        isQuotation: isQuotation,
                        isSale: isSale,
                        isPipeline: isMyquotation,
                        showCreationDate: showCreationDate,
                        currentMonth: currentMonthBool,
                        previousMonth: previousMonthBool,
                        twoMonthsBefore: twoMonthsBefore,
                        customFilterRules: provider.hasCustomFilters
                            ? provider.customFilters
                            : null,
                        session: clientprovider.currentsession!,
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  left: 16.0,
                  right: 16.0,
                  bottom: 16.0,
                ),
                child: _buildTopPaginationBar(provider, clientprovider),
              ),
              Expanded(
                child: widgets[_selectedIndex],
              ),
            ],
          ));
    });
  }
}
