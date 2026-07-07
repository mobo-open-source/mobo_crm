import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/global_methods/bottom_sheets/filter_design_bottomsheet.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/searchfield_widget.dart';
import 'package:mobo_crm/global_methods/widgets/group_by_dropdown.dart';

import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/customers/new_customer_form_screen.dart';
import 'package:mobo_crm/screens/customers/provider/customer_data_provider.dart';
import 'package:mobo_crm/screens/customers/customer_views.dart';
import 'package:mobo_crm/screens/customers/provider/customer_form_provider.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/company/infrastructure/company_refresh_bus.dart';
import '../../core/company/providers/company_provider.dart';
import '../../core/company/session/company_session_manager.dart';
import '../../core/company/widgets/company_selector_widget.dart';
import '../../services/storage_service.dart';
import '../../utils/snackbar.dart';
import '../others/configuration_screen.dart';

/// Main screen for displaying and managing customers.
///
/// This screen provides:
/// - Customer listing with pagination
/// - Search functionality with debounce
/// - Filter and custom filter support
/// - Group By functionality
/// - Company switching support
/// - Navigation to create/edit customer screen
///
/// It integrates with [CustomerDataProvider] for data handling
/// and [CustomerFormProvider] for customer form operations.
class CustomersMainScreen extends StatefulWidget {
  const CustomersMainScreen({super.key});

  @override
  State<CustomersMainScreen> createState() => CustomersMainScreenState();
}

/// A helper class that maintains a static reference to
/// [CustomersMainScreenState] for accessing and managing
/// active filter states globally.
///
/// This allows external widgets (like grid or filter chips)
/// to:
/// - Retrieve active filters
/// - Clear specific filters
/// - Clear group-by selections
class CustomerFilterState {
  static CustomersMainScreenState? _instance;

  static void setInstance(CustomersMainScreenState instance) {
    _instance = instance;
  }

  static void clearInstance() {
    _instance = null;
  }

  static List<String> getActiveFilters() {
    return _instance?.getActiveFilters() ?? [];
  }

  static void clearFilter(String filterName, CustomerDataProvider provider,
      OdooClientManager clientProvider) {
    _instance?.clearFilter(filterName, provider, clientProvider);
  }

  static void clearGroupBy(
      CustomerDataProvider provider, OdooClientManager clientProvider) {
    _instance?.clearGroupBy(provider, clientProvider);
  }
}

Timer? _debounce;

/// State class for [CustomersMainScreen].
///
/// Handles:
/// - Filter state management
/// - Group By logic
/// - Search with debounce
/// - Company change refresh handling
/// - Customer data refresh based on active filters
class CustomersMainScreenState extends State<CustomersMainScreen> {
  late final StreamSubscription _companySub;

  /// Converts custom filter rules from UI format
  /// into Odoo-compatible domain format.
  ///
  /// Example Output:
  /// [
  ///   ['field_name', '=', value],
  ///   ['another_field', '>', 10]
  /// ]
  ///
  /// Returns a list of domain conditions to be used
  /// in Odoo search queries.
  List<dynamic> _convertCustomFiltersToOdooDomain(
      Map<String, dynamic> customFilterRules) {
    List<dynamic> domain = [];

    if (customFilterRules['custom_filters'] != null) {
      final customFilters =
          customFilterRules['custom_filters'] as Map<String, dynamic>;

      customFilters.forEach((key, filterData) {
        if (filterData is Map<String, dynamic>) {
          final field = filterData['field'] as String;
          final operator = filterData['operator'] as String;
          final value = filterData['value'];

          final odooOperator = operator;
          domain.add([field, odooOperator, value]);
        }
      });
    }

    return domain;
  }

  @override
  void initState() {
    super.initState();
    CustomerFilterState.setInstance(this);

    final customerprovider =
        Provider.of<CustomerDataProvider>(context, listen: false);
    if (customerprovider.customers.isEmpty) {
      customerprovider.fetchAllData(
        context,
      );
    }

    final customerProvider =
        Provider.of<CustomerFormProvider>(context, listen: false);
    final clientManager =
        Provider.of<OdooClientManager>(context, listen: false);
    final client = clientManager.client;

    if (client != null) {
      customerProvider.checkSaleModuleInstallation(client);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        final freshClient = await CompanySessionManager.getClientEnsured();
        if (!mounted) return;
        customerProvider.checkSaleModuleInstallation(freshClient);
      });
    }

    _companySub = CompanyRefreshBus.stream.listen((_) async {
      if (!mounted) return;
      await context.read<CompanyProvider>().initialize();
      if (!mounted) return;
      final customerprovider =
          Provider.of<CustomerDataProvider>(context, listen: false);
      customerprovider.fetchAllData(
        context,
      );
    });
  }

  @override
  void dispose() {
    CustomerFilterState.clearInstance();
    _companySub.cancel();
    super.dispose();
  }

  bool filterIndividual = false;
  bool filterCompany = false;
  bool filterCustomerInvoice = false;
  bool filterVendorBills = false;
  bool filterIsarchived = false;
  bool hascompanyTypeFilters = false;
  bool hasInvoiceVendorFilter = false;

  /// Resets all locally maintained filter flags.
  ///
  /// This clears:
  /// - Company type filters
  /// - Invoice/vendor filters
  /// - Archived filter
  void resetLocalFilterFlags() {
    setState(() {
      filterIndividual = false;
      filterCompany = false;
      filterCustomerInvoice = false;
      filterVendorBills = false;

      filterIsarchived = false;
      hasInvoiceVendorFilter = false;
    });
  }

  /// Returns a list of currently active filter names.
  ///
  /// Used for:
  /// - Displaying filter chips
  /// - Showing active filter count
  List<String> getActiveFilters() {
    List<String> activeFilters = [];

    if (filterIndividual) activeFilters.add('Individual');
    if (filterCompany) activeFilters.add('Company');
    if (filterCustomerInvoice) activeFilters.add('Customer Invoice');
    if (filterVendorBills) activeFilters.add('Vendor Bills');
    if (filterIsarchived) activeFilters.add('Archived');

    return activeFilters;
  }

  /// Clears a specific filter by name and refreshes data.
  ///
  /// Parameters:
  /// - [filterName]: The filter label to clear.
  /// - [provider]: Customer data provider.
  /// - [clientprovider]: Odoo client manager.
  void clearFilter(String filterName, CustomerDataProvider provider,
      OdooClientManager clientprovider) {
    setState(() {
      switch (filterName) {
        case 'Individual':
          filterIndividual = false;
          hascompanyTypeFilters = filterCompany;
          break;
        case 'Company':
          filterCompany = false;
          hascompanyTypeFilters = filterIndividual;
          break;
        case 'Customer Invoice':
          filterCustomerInvoice = false;
          hasInvoiceVendorFilter = filterVendorBills;
          break;
        case 'Vendor Bills':
          filterVendorBills = false;
          hasInvoiceVendorFilter = filterCustomerInvoice;
          break;
        case 'Archived':
          filterIsarchived = false;
          break;
      }
    });

    _refreshDataWithCurrentState(provider, clientprovider);
  }

  /// Clears the currently selected group-by option
  /// and refreshes the customer data.
  void clearGroupBy(
      CustomerDataProvider provider, OdooClientManager clientprovider) {
    provider.setGroupBy(CustomerGroupByOption.none);

    _refreshDataWithCurrentState(provider, clientprovider);
  }

  /// Refreshes customer data using the current filter
  /// and group-by state.
  ///
  /// Optionally accepts [customFilters] which override
  /// existing custom filter domain.
  void _refreshDataWithCurrentState(
      CustomerDataProvider provider, OdooClientManager clientProvider,
      [List<dynamic>? customFilters]) {
    provider.fetchCustomerData(
      loading: true,
      context: context,
      searchText: provider.searchcontroller.text,
      filterIndividual: filterIndividual,
      filterCompany: filterCompany,
      filterCustomerInvoice: filterCustomerInvoice,
      filterVendorBills: filterVendorBills,
      filterIsarchived: filterIsarchived,
      hascompanyTypeFilters: hascompanyTypeFilters,
      hasInvoiceVendorFilter: hasInvoiceVendorFilter,
      customFilter: customFilters ??
          (provider.hasCustomFilters
              ? provider.currentCustomFilterDomain
              : null),
    );
  }

  /// Displays the advanced filter bottom sheet.
  ///
  /// Supports:
  /// - Standard filters
  /// - Custom filter rules
  /// - Dynamic group-by options
  ///
  /// On apply:
  /// - Updates local filter flags
  /// - Applies group-by selection
  /// - Refreshes customer data
  Future<void> _showFilterDialog() async {
    final customerprovider =
        Provider.of<CustomerDataProvider>(context, listen: false);

    bool tempFilterIndividual = filterIndividual;
    bool tempFilterCompany = filterCompany;
    bool tempFilterCustomerInvoice = filterCustomerInvoice;
    bool tempFilterVendorBills = filterVendorBills;
    bool tempFilterIsArchived = filterIsarchived;

    List<FilterGroup> customFilterGroups = [
      FilterGroup(
        title: "Customer Information",
        isExpanded: true,
        options: [
          FilterOption(
            title: "Customer Type",
            value: false,
            type: 'multi_select',
            options: [
              {'id': 'person', 'name': 'Individual'},
              {'id': 'company', 'name': 'Company'},
            ],
            selectedValue: <String>[],
          ),
          FilterOption(
            title: "Customer Rank",
            value: false,
            type: 'range',
            rangeData: {'min': 0.0, 'max': 10.0},
            selectedValue: {'min': 0.0, 'max': 10.0},
          ),
        ],
      ),
      FilterGroup(
        title: "Business Metrics",
        isExpanded: false,
        options: [
          FilterOption(
            title: "Sale Orders Count",
            value: false,
            type: 'range',
            rangeData: {'min': 0.0, 'max': 100.0},
            selectedValue: {'min': 0.0, 'max': 100.0},
          ),
          FilterOption(
            title: "Opportunity Count",
            value: false,
            type: 'range',
            rangeData: {'min': 0.0, 'max': 50.0},
            selectedValue: {'min': 0.0, 'max': 50.0},
          ),
          FilterOption(
            title: "Meeting Count",
            value: false,
            type: 'range',
            rangeData: {'min': 0.0, 'max': 20.0},
            selectedValue: {'min': 0.0, 'max': 20.0},
          ),
        ],
      ),
      FilterGroup(
        title: "Status Filters",
        isExpanded: false,
        options: [
          FilterOption(
            title: "Is Customer",
            value: false,
            type: 'checkbox',
          ),
          FilterOption(
            title: "Is Supplier",
            value: false,
            type: 'checkbox',
          ),
          FilterOption(
            title: "Is Company",
            value: false,
            type: 'checkbox',
          ),
          FilterOption(
            title: "Active Only",
            value: false,
            type: 'checkbox',
          ),
        ],
      ),
    ];

    List<FilterGroup> filterGroups = [
      FilterGroup(
        title: "Company Type",
        options: [
          FilterOption(title: "Individual", value: tempFilterIndividual),
          FilterOption(title: "Company", value: tempFilterCompany),
        ],
      ),
      FilterGroup(
        title: "Accounting",
        options: [
          FilterOption(
              title: "Customer Invoice", value: tempFilterCustomerInvoice),
          FilterOption(title: "Vendor Bills", value: tempFilterVendorBills),
        ],
      ),
      FilterGroup(
        title: "Archived",
        options: [
          FilterOption(title: "Archived", value: tempFilterIsArchived),
          FilterOption(title: "Not Archived", value: false),
        ],
      ),
    ];

    List<FilterGroup> groupByOptions = [];
    try {
      final odooClient = Provider.of<OdooClientManager>(context, listen: false);
      final customerProvider =
          Provider.of<CustomerFormProvider>(context, listen: false);

      final client = odooClient.client;
      if (client != null) {
        List<String> fields = [
          'company_type',
          'country_id',
          'state_id',
          'category_id',
          'user_id',
          'supplier_rank',
          'is_company',
          'active'
        ];
        if (customerProvider.isSaleInstalled) {
          fields.add('customer_rank');
        }

        final sampleResponse = await CompanySessionManager.callKwWithCompany({
          'model': 'res.partner',
          'method': 'search_read',
          'args': [[]],
          'kwargs': {
            'fields': fields,
            'limit': 100,
            'order': 'id desc',
          },
        });

        List<FilterOption> groupByFilterOptions = [];

        if (sampleResponse is List && sampleResponse.isNotEmpty) {
          Set<String> companyTypes = {};
          Set<int?> countries = {};
          Set<int?> states = {};
          Set<int?> categories = {};
          Set<int?> salespeople = {};
          Set<int> customerRanks = {};
          Set<int> supplierRanks = {};
          Set<bool> isCompanyValues = {};
          Set<bool> activeValues = {};

          for (var customer in sampleResponse) {
            if (customer['company_type'] != null &&
                customer['company_type'] != false) {
              companyTypes.add(customer['company_type'].toString());
            }

            if (customer['country_id'] is List &&
                customer['country_id'].length > 1) {
              countries.add(customer['country_id'][0] as int?);
            }

            if (customer['state_id'] is List &&
                customer['state_id'].length > 1) {
              states.add(customer['state_id'][0] as int?);
            }

            if (customer['category_id'] is List &&
                customer['category_id'].isNotEmpty) {
              for (var catId in customer['category_id']) {
                if (catId is int) categories.add(catId);
              }
            }

            if (customer['user_id'] is List && customer['user_id'].length > 1) {
              salespeople.add(customer['user_id'][0] as int?);
            }

            if (customerProvider.isSaleInstalled) {
              if (customer['customer_rank'] != null) {
                customerRanks.add(customer['customer_rank'] as int);
              }
            }

            if (customer['supplier_rank'] != null) {
              supplierRanks.add(customer['supplier_rank'] as int);
            }

            if (customer['is_company'] != null) {
              isCompanyValues.add(customer['is_company'] as bool);
            }

            if (customer['active'] != null) {
              activeValues.add(customer['active'] as bool);
            }
          }

          final currentGroupBy = customerprovider.currentGroupBy;

          if (companyTypes.length > 1) {
            groupByFilterOptions.add(FilterOption(
                title: "Company Type",
                value: currentGroupBy == CustomerGroupByOption.companyType));
          }

          if (countries.length > 1) {
            groupByFilterOptions.add(FilterOption(
                title: "Country",
                value: currentGroupBy == CustomerGroupByOption.country));
          }

          if (states.length > 1) {
            groupByFilterOptions.add(FilterOption(
                title: "State",
                value: currentGroupBy == CustomerGroupByOption.state));
          }

          if (categories.isNotEmpty) {
            groupByFilterOptions.add(FilterOption(
                title: "Category",
                value: currentGroupBy == CustomerGroupByOption.category));
          }

          if (salespeople.length > 1) {
            groupByFilterOptions.add(FilterOption(
                title: "Salesperson",
                value: currentGroupBy == CustomerGroupByOption.salesperson));
          }

          if (customerRanks.length > 1) {
            groupByFilterOptions.add(FilterOption(
                title: "Customer Rank",
                value: currentGroupBy == CustomerGroupByOption.customerRank));
          }

          if (supplierRanks.length > 1) {
            groupByFilterOptions.add(FilterOption(
                title: "Supplier Rank",
                value: currentGroupBy == CustomerGroupByOption.supplierRank));
          }

          if (isCompanyValues.length > 1) {
            groupByFilterOptions.add(FilterOption(
                title: "Is Company",
                value: currentGroupBy == CustomerGroupByOption.isCompany));
          }

          if (activeValues.length > 1) {
            groupByFilterOptions.add(FilterOption(
                title: "Active Status",
                value: currentGroupBy == CustomerGroupByOption.active));
          }
        }

        if (groupByFilterOptions.isEmpty) {
          final currentGroupBy = customerprovider.currentGroupBy;
          groupByFilterOptions = [
            FilterOption(
                title: "Company Type",
                value: currentGroupBy == CustomerGroupByOption.companyType),
            FilterOption(
                title: "Salesperson",
                value: currentGroupBy == CustomerGroupByOption.salesperson),
            FilterOption(
                title: "Is Company",
                value: currentGroupBy == CustomerGroupByOption.isCompany),
            FilterOption(
                title: "Active Status",
                value: currentGroupBy == CustomerGroupByOption.active),
          ];
        }

        groupByOptions = [
          FilterGroup(
            title: "Group By",
            options: groupByFilterOptions,
          ),
        ];
      }
    } catch (e) {
      final currentGroupBy = customerprovider.currentGroupBy;
      groupByOptions = [
        FilterGroup(
          title: "Group By",
          options: [
            FilterOption(
                title: "Company Type",
                value: currentGroupBy == CustomerGroupByOption.companyType),
            FilterOption(
                title: "Salesperson",
                value: currentGroupBy == CustomerGroupByOption.salesperson),
            FilterOption(
                title: "Is Company",
                value: currentGroupBy == CustomerGroupByOption.isCompany),
            FilterOption(
                title: "Active Status",
                value: currentGroupBy == CustomerGroupByOption.active),
          ],
        ),
      ];
    }

    if (!context.mounted) return;

    PremiumFilterBottomSheet.show(
      context: context,
      title: 'Filter Customers',
      filterGroups: filterGroups,
      customFilterGroups: customFilterGroups,
      groupByOptions: groupByOptions,
      client: Provider.of<OdooClientManager>(context, listen: false).client,
      session:
          Provider.of<OdooClientManager>(context, listen: false).currentsession,
      model: 'res.partner',
      onApply: (values) {
        Map<String, dynamic>? customFilterRules;
        if (values['custom_filters'] != null) {
          customFilterRules = values;
        }
        setState(() {
          filterIndividual = values['company_type_individual'] ?? false;
          filterCompany = values['company_type_company'] ?? false;

          filterCustomerInvoice =
              values['accounting_customer_invoice'] ?? false;
          filterVendorBills = values['accounting_vendor_bills'] ?? false;

          filterIsarchived = values['archived_archived'] ?? false;

          hascompanyTypeFilters = filterIndividual || filterCompany;
          hasInvoiceVendorFilter = filterCustomerInvoice || filterVendorBills;
        });

        final customerprovider =
            Provider.of<CustomerDataProvider>(context, listen: false);

        bool hasGroupBySelection = false;
        CustomerGroupByOption? selectedGroupBy;

        if (values['group_by_company_type'] == true) {
          hasGroupBySelection = true;
          selectedGroupBy = CustomerGroupByOption.companyType;
        } else if (values['group_by_country'] == true) {
          hasGroupBySelection = true;
          selectedGroupBy = CustomerGroupByOption.country;
        } else if (values['group_by_state'] == true) {
          hasGroupBySelection = true;
          selectedGroupBy = CustomerGroupByOption.state;
        } else if (values['group_by_category'] == true) {
          hasGroupBySelection = true;
          selectedGroupBy = CustomerGroupByOption.category;
        } else if (values['group_by_salesperson'] == true) {
          hasGroupBySelection = true;
          selectedGroupBy = CustomerGroupByOption.salesperson;
        } else if (values['group_by_customer_rank'] == true) {
          hasGroupBySelection = true;
          selectedGroupBy = CustomerGroupByOption.customerRank;
        } else if (values['group_by_supplier_rank'] == true) {
          hasGroupBySelection = true;
          selectedGroupBy = CustomerGroupByOption.supplierRank;
        } else if (values['group_by_is_company'] == true) {
          hasGroupBySelection = true;
          selectedGroupBy = CustomerGroupByOption.isCompany;
        } else if (values['group_by_active_status'] == true) {
          hasGroupBySelection = true;
          selectedGroupBy = CustomerGroupByOption.active;
        }

        if (!hasGroupBySelection) {
          customerprovider.setGroupBy(CustomerGroupByOption.none);
        } else if (hasGroupBySelection && selectedGroupBy != null) {
          customerprovider.setGroupBy(selectedGroupBy);
        }

        _refreshDataWithCurrentState(
            customerprovider,
            Provider.of<OdooClientManager>(context, listen: false),
            customFilterRules != null
                ? _convertCustomFiltersToOdooDomain(customFilterRules)
                : null);
      },
    );
  }

  /// Retrieves the current logged-in user's image
  /// from local storage.
  ///
  /// Returns:
  /// - Base64 encoded image string if available
  /// - null if no image exists
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
    return Consumer2<CustomerDataProvider, OdooClientManager>(
        builder: (context, provider, clientprovider, child) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: isDark
              ? Colors.white
              : Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.add,
            color: isDark ? Colors.black : Colors.white,
            size: 28,
          ),
          onPressed: () {
            if (context.mounted) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewCustomerFormScreen(
                            customerData: {},
                            isNewCustomer: true,
                          )));
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        backgroundColor: isDark ? const Color(0xFF181A20) : const Color(0xFFFAFAFA),
        appBar: AppBar(
          iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
          centerTitle: false,
          title: Text(
            'Customers',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: isDark ? const Color(0xFF181A20) : const Color(0xFFFAFAFA),
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            CompanySelectorWidget(
              onCompanyChanged: () async {
                if (!mounted) return;
                final provider = context.read<CompanyProvider>();
                final clientProvider = context.read<OdooClientManager>();

                final companyName =
                    provider.selectedCompany?['name']?.toString() ?? 'company';

                await clientProvider.loadCurrentUserImage();
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
                        await Provider.of<OdooClientManager>(context, listen: false).updateUserImage();
                        setState(() {});
                      }
                    });
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: (imageBase64 != null && !isSvgBytes(imageBase64))
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
                controller: provider.searchcontroller,
                readOnly: provider.isLoading,
                hintText: 'Search by customer name or email',
                onFilterTap: () => _showFilterDialog(),
                onChanged: (query) {
                  if (query.isNotEmpty) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      provider.fetchCustomerData(
                        context: context,
                        searchText: provider.searchcontroller.text,
                        filterIndividual: filterIndividual,
                        filterCompany: filterCompany,
                        filterCustomerInvoice: filterCustomerInvoice,
                        filterVendorBills: filterVendorBills,
                        filterIsarchived: filterIsarchived,
                        hascompanyTypeFilters: hascompanyTypeFilters,
                        hasInvoiceVendorFilter: hasInvoiceVendorFilter,
                        customFilter: provider.hasCustomFilters
                            ? provider.currentCustomFilterDomain
                            : null,
                      );
                    });
                  } else {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    provider.fetchCustomerData(
                      loading: false,
                      context: context,
                      searchText: '',
                      filterIndividual: filterIndividual,
                      filterCompany: filterCompany,
                      filterCustomerInvoice: filterCustomerInvoice,
                      filterVendorBills: filterVendorBills,
                      filterIsarchived: filterIsarchived,
                      hascompanyTypeFilters: hascompanyTypeFilters,
                      hasInvoiceVendorFilter: hasInvoiceVendorFilter,
                      customFilter: provider.hasCustomFilters
                          ? provider.currentCustomFilterDomain
                          : null,
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: CustomerGridScreen(),
            ),
          ],
        ),
      );
    });
  }
}
