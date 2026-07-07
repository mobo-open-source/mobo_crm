import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/services/isar_caching_service.dart';
import 'package:mobo_crm/global_methods/widgets/custom_filters.dart';
import 'package:mobo_crm/global_methods/widgets/group_by_dropdown.dart';
import 'package:mobo_crm/global_methods/services/global_error_handler.dart';
import 'package:mobo_crm/screens/customers/isar/customer_list_data_isar.dart';
import 'package:mobo_crm/utils/snackbar.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/company/session/company_session_manager.dart';
import '../../../services/app_install_check.dart';
import '../customers_main_screen.dart';

/// Provider responsible for managing customer list data,
/// filtering, pagination, grouping, caching, and activity enrichment.
///
/// Responsibilities:
/// - Fetch customer data from Odoo (`res.partner`)
/// - Apply company, invoice/vendor, archive, and custom filters
/// - Handle pagination and infinite scrolling
/// - Support dynamic grouping options
/// - Cache customer data locally using Isar
/// - Fallback to offline cache on API failure
/// - Fetch and attach related activity data
/// - Maintain UI loading and error states
///
/// This provider acts as the main data controller
/// for the Customers Main Screen.
class CustomerDataProvider extends ChangeNotifier {
  List<Map<dynamic, dynamic>> _customers = [];
  Map<int, List<Map<dynamic, dynamic>>> _customerActivities = {};
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentPage = 0;
  final int _limit = 40;
  int _totalCount = 0;

  AppError? customerError;
  bool hasError = false;
  Timer? _errorTimer;
  TextEditingController searchcontroller = TextEditingController();

  List<dynamic>? _currentCustomFilterDomain;
  Map<String, dynamic>? _customFilters;
  bool _hasCustomFilters = false;

  List<dynamic>? get currentCustomFilterDomain => _currentCustomFilterDomain;

  Map<String, dynamic>? get customFilters => _customFilters;

  bool get hasCustomFilters => _hasCustomFilters;

  bool filterIndividual = false;
  bool filterCompany = false;
  bool filterCustomerInvoice = false;
  bool filterVendorBills = false;
  bool filterIsarchived = false;

  bool hasCompanyTypeFilters = false;
  bool hasInvoiceVendorFilter = false;
  List<String> _selectedFilters = [];

  List<String> get selectedFilters => _selectedFilters;

  set selectedFilters(List<String> value) {
    _selectedFilters = value;
    notifyListeners();
  }

  /// Resets all filter flags and clears custom filter state.
  ///
  /// Does not automatically reload data.
  void resetAllFilters() {
    filterIndividual = false;
    filterCompany = false;
    filterCustomerInvoice = false;
    filterVendorBills = false;
    filterIsarchived = false;

    hasCompanyTypeFilters = false;
    hasInvoiceVendorFilter = false;

    selectedFilters = [];
    _currentCustomFilterDomain = null;
    _hasCustomFilters = false;

    notifyListeners();
  }

  /// Clears all filters and optionally reloads customer data.
  ///
  /// Parameters:
  /// - [reload]: Whether to refetch data after clearing.
  /// - [context]: Required if reload is true.
  void clearFilters({bool reload = true, BuildContext? context}) async {
    resetAllFilters();

    setGroupBy(CustomerGroupByOption.none);
    _groupExpansionState.clear();

    if (reload && context != null) {
      _isLoading = true;
      notifyListeners();
      await fetchCustomerData(
        context: context,
        loading: true,
      );
    }
  }

  /// Clears only custom domain filters
  /// without affecting predefined filter flags.
  void clearCustomFilters() {
    _currentCustomFilterDomain = null;
    _customFilters = null;
    _hasCustomFilters = false;
    notifyListeners();
  }

  CustomerGroupByOption _currentGroupBy = CustomerGroupByOption.none;
  Map<String, List<Map<dynamic, dynamic>>> _groupedCustomers = {};
  Map<String, bool> _groupExpansionState = {};

  CustomerGroupByOption get currentGroupBy => _currentGroupBy;

  Map<String, List<Map<dynamic, dynamic>>> get groupedCustomers =>
      _groupedCustomers;

  Map<String, bool> get groupExpansionState => _groupExpansionState;

  /// Sets the active grouping option and reapplies grouping logic.
  ///
  /// Resets pagination and updates grouped results.
  void setGroupBy(CustomerGroupByOption option) {
    _currentGroupBy = option;
    _currentPage = 0;
    _applyGrouping();
    notifyListeners();
  }

  /// Toggles expansion state for a specific group key.
  void toggleGroupExpansion(String groupKey) {
    _groupExpansionState[groupKey] = !(_groupExpansionState[groupKey] ?? true);
    notifyListeners();
  }

  List<Map<dynamic, dynamic>> get customers => _customers;

  Map<int, List<Map<dynamic, dynamic>>> get customerActivities =>
      _customerActivities;

  bool get isLoading => _isLoading;

  bool get isLoadingMore => _isLoadingMore;

  bool get hasMoreData => _hasMoreData;

  int get currentPage => _currentPage;

  int get limit => _limit;

  int get totalCount => _totalCount;

  bool get hasPreviousPage => _currentPage > 0;

  bool get hasNextPage {
    if (_currentGroupBy != CustomerGroupByOption.none) {
      return (_currentPage + 1) * _limit < _groupedCustomers.keys.length;
    }
    return (_currentPage + 1) * _limit < _totalCount;
  }

  int get totalDisplayed => _customers.length;

  int get startRecord =>
      _customers.isEmpty ? 0 : (_currentPage * _limit) + 1;

  int get endRecord {
    if (_currentGroupBy != CustomerGroupByOption.none) {
      final groupCount = _groupedCustomers.keys.length;
      final startGroup = _currentPage * _limit;
      return (startGroup + _limit).clamp(0, groupCount);
    }
    if (_customers.isEmpty) return 0;
    return startRecord + _customers.length - 1;
  }

  int get totalPages {
    if (_currentGroupBy != CustomerGroupByOption.none) {
      return (_groupedCustomers.keys.length / _limit).ceil();
    }
    return (_totalCount / _limit).ceil();
  }

  int get currentPageNumber => _currentPage + 1;

  List<String> activityNames = [];
  final Map<String, Color> activityStateColors = {
    "overdue": Colors.red,
    "today": Colors.orange,
    "planned": Colors.green,
  };

  bool isSaleInstalled = false;

  String _lastSearchText = '';

  Future<void> checkSaleModuleInstallation(OdooClient client) async {
    try {
      final checker = AppInstallCheck();
      isSaleInstalled = await checker.isModuleInstalled('sale_management');
      notifyListeners();
    } catch (e) {
      isSaleInstalled = false;
    }
  }

  /// Disposes search controller to prevent memory leaks.
  @override
  void dispose() {
    _errorTimer?.cancel();
    searchcontroller.dispose();
    super.dispose();
  }

  /// Recursively converts `false` values from Odoo responses to `null`.
  ///
  /// Ensures consistent null handling in UI logic.
  dynamic _convertFalseToNull(dynamic value) {
    if (value == false) {
      return null;
    } else if (value is List) {
      return value.map((item) => _convertFalseToNull(item)).toList();
    } else if (value is Map) {
      return value.map((key, val) => MapEntry(key, _convertFalseToNull(val)));
    }
    return value;
  }

  /// Clears customer list, pagination state,
  /// and grouped results without affecting filters.
  void clearAll() {
    _customers.clear();
    _currentPage = 0;
    _hasMoreData = true;
    _totalCount = 0;
    _groupedCustomers.clear();
    notifyListeners();
  }

  /// Internal helper to build the Odoo filter domain consistently across
  /// count and data fetch operations.
  List<dynamic> _buildFilters({
    bool filterIndividual = false,
    bool filterCompany = false,
    bool filterCustomerInvoice = false,
    bool filterVendorBills = false,
    bool filterIsarchived = false,
    bool hascompanyTypeFilters = false,
    bool hasInvoiceVendorFilter = false,
    String searchText = "",
    List<dynamic>? customFilter,
  }) {
    List filters = [];

    final companyFiler = CustomFilters().getCompanyTypeFilters(
        hasCompanyTypeFilters: hascompanyTypeFilters,
        filterIndividual: filterIndividual,
        filterCompany: filterCompany);

    filters = [...filters, ...companyFiler];
    final vendorInvoiceFilter = CustomFilters().getInvoiceVendorFilters(
        hasInvoiceVendorFilter: hasInvoiceVendorFilter,
        filterCustomerInvoice: filterCustomerInvoice,
        filterVendorBills: filterVendorBills);
    filters = [...filters, ...vendorInvoiceFilter];

    if (filterIsarchived) {
      filters.add(["active", "=", false]);
    }

    final effectiveSearchText =
        searchText.isNotEmpty ? searchText : searchcontroller.text;
    if (effectiveSearchText.isNotEmpty) {
      filters.add('|');
      filters.add('|');
      filters.add('|');
      filters.add(['name', 'ilike', '%$effectiveSearchText%']);
      filters.add(['ref', 'ilike', '%$effectiveSearchText%']);
      filters.add(['email', 'ilike', '%$effectiveSearchText%']);
      filters.add(['phone', 'ilike', '%$effectiveSearchText%']);
    }

    if (customFilter != null && customFilter.isNotEmpty) {
      filters.addAll(customFilter);
    } else if (_currentCustomFilterDomain != null &&
        _currentCustomFilterDomain!.isNotEmpty) {
      filters.addAll(_currentCustomFilterDomain!);
    }

    return filters;
  }

  /// Fetches total customer count from the backend
  /// using the currently applied filters.
  ///
  /// Returns total record count.
  Future<int> fetchCustomerCount(
    BuildContext context, {
    bool filterIndividual = false,
    bool filterCompany = false,
    bool filterCustomerInvoice = false,
    bool filterVendorBills = false,
    bool filterIsarchived = false,
    bool hascompanyTypeFilters = false,
    bool hasInvoiceVendorFilter = false,
    String searchText = "",
    List<dynamic>? customFilter,
  }) async {
    final filters = _buildFilters(
      filterIndividual: filterIndividual,
      filterCompany: filterCompany,
      filterCustomerInvoice: filterCustomerInvoice,
      filterVendorBills: filterVendorBills,
      filterIsarchived: filterIsarchived,
      hascompanyTypeFilters: hascompanyTypeFilters,
      hasInvoiceVendorFilter: hasInvoiceVendorFilter,
      searchText: searchText,
      customFilter: customFilter,
    );

    try {
      final countResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'res.partner',
        'method': 'search_count',
        'args': [filters],
        'kwargs': {},
      });

      _totalCount = countResponse ?? 0;
      return _totalCount;
    } catch (e) {
      _totalCount = 0;
      return 0;
    }
  }

  /// Clears search input and reloads customer data from page 0.
  ///
  /// Displays snackbar on failure.
  Future<void> fetchAllData(BuildContext context) async {
    searchcontroller.clear();
    _currentPage = 0;
    _hasMoreData = true;
    try {
      await fetchCustomerData(context: context);
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.showError(context, 'Error fetching data');
      }
    }
  }

  /// Fetches paginated customer data from Odoo.
  ///
  /// Features:
  /// - Applies all filters and custom domains
  /// - Supports grouping mode
  /// - Stores results in Isar cache
  /// - Enriches customers with category values
  /// - Fetches related activities
  /// - Falls back to local cache on API failure
  ///
  /// Parameters control filter combinations and loading state.
  Future<void> fetchCustomerData({
    bool filterIndividual = false,
    bool filterCompany = false,
    bool filterCustomerInvoice = false,
    bool filterVendorBills = false,
    bool filterIsarchived = false,
    bool hascompanyTypeFilters = false,
    bool hasInvoiceVendorFilter = false,
    String searchText = "",
    bool loading = false,
    List<dynamic>? customFilter,
    required BuildContext context,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('url') ?? '';
    _errorTimer?.cancel();
    _errorTimer = null;
    hasError = false;

    final bool hasActiveFilters =
        hascompanyTypeFilters || hasInvoiceVendorFilter || filterIsarchived;
    if (searchText.isEmpty && customFilter == null && !hasActiveFilters) {
      if (_customers.isNotEmpty && !loading && _lastSearchText.isEmpty) {
        return;
      }
      _lastSearchText = '';
      final bool hasCacheData = await getCustomerListFromIsar();
      if (hasCacheData && !loading) {
        unawaited(fetchCustomerCount(context));
        _isLoading = false;
        notifyListeners();
        return;
      }
    }

    _lastSearchText = searchText;

    if (loading || _customers.isEmpty) {
      _isLoading = true;
      if (loading) {
        _currentPage = 0;
        _customers.clear();
      }
      notifyListeners();
    }

    final checker = AppInstallCheck();
    bool isSaleManagementInstalled =
        await checker.isModuleInstalled('sale_management');
    bool isSaleModuleInstalled = await checker.isModuleInstalled('sale');
    bool isModuleInstalled = isSaleManagementInstalled || isSaleModuleInstalled;

    await fetchCustomerCount(
      context!,
      filterIndividual: filterIndividual,
      filterCompany: filterCompany,
      filterCustomerInvoice: filterCustomerInvoice,
      filterVendorBills: filterVendorBills,
      filterIsarchived: filterIsarchived,
      hascompanyTypeFilters: hascompanyTypeFilters,
      hasInvoiceVendorFilter: hasInvoiceVendorFilter,
      searchText: searchText,
      customFilter: customFilter,
    );

    final filters = _buildFilters(
      filterIndividual: filterIndividual,
      filterCompany: filterCompany,
      filterCustomerInvoice: filterCustomerInvoice,
      filterVendorBills: filterVendorBills,
      filterIsarchived: filterIsarchived,
      hascompanyTypeFilters: hascompanyTypeFilters,
      hasInvoiceVendorFilter: hasInvoiceVendorFilter,
      searchText: searchText,
      customFilter: customFilter,
    );

    if (customFilter != null && customFilter.isNotEmpty) {
      _currentCustomFilterDomain = customFilter;
      _hasCustomFilters = true;
    }

    try {
      int fetchLimit = _limit;
      int fetchOffset = _currentPage * _limit;

      if (_currentGroupBy != CustomerGroupByOption.none) {
        fetchLimit = 0;
        fetchOffset = 0;
      }

      List<String> fields = [
        'id',
        'name',
        'email',
        'phone',
        'city',
        'state_id',
        'country_id',
        'category_id',
        'company_type',
        'company_name',
        'meeting_count',
        'opportunity_count',
        'company_id',
        'commercial_partner_id',
        'function',
        'is_company',
        'active',
        'activity_date_deadline',
        'activity_ids',
        'activity_type_id',
        'activity_user_id',
        'activity_state',
        'activity_summary',
        'activity_type_icon',
      ];
      if (isModuleInstalled) {
        fields.add('customer_rank');
        fields.add('sale_order_count');
        fields.add('supplier_rank');
      }

      dynamic response;
      try {
        response = await CompanySessionManager.callKwWithCompany({
          'model': 'res.partner',
          'method': 'search_read',
          'args': [filters],
          'kwargs': {
            'fields': fields,
            'limit': fetchLimit,
            'offset': fetchOffset,
          },
        });
      } catch (e1) {
        for (final f in [
          'activity_type_icon',
          'meeting_count',
          'opportunity_count',
          'activity_ids',
          'activity_date_deadline',
          'activity_type_id',
          'activity_user_id',
          'activity_state',
          'activity_summary',
          'customer_rank',
          'sale_order_count',
          'supplier_rank',
        ]) {
          fields.remove(f);
        }
        try {
          response = await CompanySessionManager.callKwWithCompany({
            'model': 'res.partner',
            'method': 'search_read',
            'args': [filters],
            'kwargs': {
              'fields': fields,
              'limit': fetchLimit,
              'offset': fetchOffset,
            },
          });
        } catch (e2) {
          response = await CompanySessionManager.callKwWithCompany({
            'model': 'res.partner',
            'method': 'search_read',
            'args': [filters],
            'kwargs': {
              'fields': [
                'id', 'name', 'email', 'phone', 'city',
                'state_id', 'country_id', 'category_id',
                'company_type', 'company_name', 'company_id',
                'commercial_partner_id', 'function', 'is_company', 'active',
              ],
              'limit': fetchLimit,
              'offset': fetchOffset,
            },
          });
        }
      }

      List<CustomerListDataIsar> customerObjects = [];
      try {
        customerObjects = (response is List ? response : [])
            .map<CustomerListDataIsar>((e) => CustomerListDataIsar.fromJson(e))
            .toList();
      } catch (_) {
      }
      if (searchText.isEmpty && !hascompanyTypeFilters && !hasInvoiceVendorFilter && !filterIsarchived) {
        await IsarService.saveCustomersList(customerObjects);
      }

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
        }
      } catch (_) {
      }


      final processedResponse =
          response is List ? _convertFalseToNull(response) : null;
      final newCustomers =
          List<Map<dynamic, dynamic>>.from(processedResponse ?? []);

      if (_currentPage == 0) {
        _customers.clear();
      }

      if (_currentGroupBy != CustomerGroupByOption.none) {
        _customers.addAll(newCustomers);
        _applyGrouping();
        _hasMoreData =
            (_currentPage + 1) * _limit < _groupedCustomers.keys.length;
      } else {
        _hasMoreData = (_currentPage + 1) * _limit < _totalCount;
        _customers.addAll(newCustomers);
      }

      for (var cus in newCustomers) {
        if (cus['category_id'] is List && (cus['category_id'] as List).isNotEmpty) {
          try {
            final categoryIds = cus['category_id'];

            final categoryResponse =
                await CompanySessionManager.callKwWithCompany({
              'model': 'res.partner.category',
              'method': 'search_read',
              'args': [
                [
                  ['id', 'in', categoryIds]
                ]
              ],
              'kwargs': {
                'fields': ['id', 'name', 'parent_id'],
              },
            });

            List<String>? categoryValues;

            if (categoryResponse is List && categoryResponse.isNotEmpty) {
              categoryValues = categoryResponse
                  .map((category) {
                    try {
                      final parent = category['parent_id'];
                      final categoryName = category['name'];

                      if (categoryName is! String) return null;

                      if (parent == false || parent == null) {
                        return categoryName;
                      } else if (parent is List && parent.length >= 2) {
                        return "${parent[1]}/$categoryName";
                      }
                      return categoryName;
                    } catch (_) {
                      return null;
                    }
                  })
                  .where((e) => e != null)
                  .cast<String>()
                  .toList();

              if (categoryValues.isEmpty) {
                categoryValues = null;
              }
            }

            cus['category_values'] = categoryValues;
          } catch (_) {
            cus['category_values'] = null;
          }
        } else {
          cus['category_values'] = null;
        }
      }

      await fetchActivityData();
      _applyGrouping();
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      if (searchText.isNotEmpty) {
        _customers = [];
        _isLoading = false;
        notifyListeners();
        return;
      }

      final activeFilters = CustomerFilterState.getActiveFilters();
      if (activeFilters.isEmpty && _customers.isEmpty) {
        final hasCacheData = await getCustomerListFromIsar();
        if (hasCacheData) {
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      customerError = await ErrorHandler.handleException(e, uri: url);
      _customers = [];
      _errorTimer?.cancel();
      _errorTimer = Timer(const Duration(seconds: 2), () {
        _isLoading = false;
        hasError = true;
        notifyListeners();
      });
    }
  }

  /// Retrieves customer list data from local Isar cache.
  ///
  /// Used as a fallback when API calls fail.
  /// Returns true if cached data was successfully loaded.
  Future<bool> getCustomerListFromIsar() async {
    try {
      final allCached = await IsarService.getCustomersList();

      if (allCached.isEmpty) return false;

      _totalCount = allCached.length;
      final int start = _currentPage * _limit;
      final cachedCustomers = allCached.skip(start).take(_limit).toList();

      _customers = cachedCustomers.map((item) {
        return <dynamic, dynamic>{
          'id': item.serverId,
          'name': item.name,
          'email': item.email,
          'phone': item.phone,
          'city': item.city,
          'state_id':
              item.stateId != null ? [item.stateId, item.stateName] : null,
          'country_id': item.countryId != null
              ? [item.countryId, item.countryName]
              : null,
          'category_id': item.categoryValues,
          'company_type': item.companyType,
          'company_name': item.companyName,
          'meeting_count': item.meetingCount,
          'opportunity_count': item.opportunityCount,
          'sale_order_count': item.saleOrderCount,
          'company_id': item.companyId != null
              ? [item.companyId, item.companyDisplayName]
              : null,
          'commercial_partner_id': item.commercialPartnerId != null &&
                  item.commercialPartnerName != null
              ? [item.commercialPartnerId, item.commercialPartnerName]
              : null,
          'function': item.function,
          'is_company': item.isCompany,
          'customer_rank': item.customerRank,
          'supplier_rank': item.supplierRank,
          'active': item.isActive,
          'activity_date_deadline': item.activityDateDeadline,
          'activity_type_id': item.activityTypeId != null
              ? [item.activityTypeId, item.activityTypeName]
              : null,
          'activity_user_id': item.activityUserId != null
              ? [item.activityUserId, item.activityUserName]
              : null,
          'activity_state': item.activityState,
          'activity_summary': item.activitySummary,
          'activity_type_icon': item.activityTypeIcon,
          'activity_ids': [],
        };
      }).toList();

      activityNames = await IsarService.getActivityNames();

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Navigates to the next page and fetches updated data.
  ///
  /// Prevents execution if already loading or no more data.
  Future<void> goToNextPage({
    required BuildContext context,
    required OdooClient client,
    bool filterIndividual = false,
    bool filterCompany = false,
    bool filterCustomerInvoice = false,
    bool filterVendorBills = false,
    bool filterIsarchived = false,
    bool hascompanyTypeFilters = false,
    bool hasInvoiceVendorFilter = false,
    String searchText = "",
    List<dynamic>? customFilter,
  }) async {
    if (!hasNextPage || _isLoading) return;

    _currentPage++;
    await fetchCustomerData(
      context: context,
      filterIndividual: filterIndividual,
      filterCompany: filterCompany,
      filterCustomerInvoice: filterCustomerInvoice,
      filterVendorBills: filterVendorBills,
      filterIsarchived: filterIsarchived,
      hascompanyTypeFilters: hascompanyTypeFilters,
      hasInvoiceVendorFilter: hasInvoiceVendorFilter,
      searchText: searchText,
      customFilter: customFilter,
      loading: true,
    );
  }

  /// Navigates to the previous page and refetches data.
  Future<void> goToPreviousPage({
    required BuildContext context,
    required OdooClient client,
    bool filterIndividual = false,
    bool filterCompany = false,
    bool filterCustomerInvoice = false,
    bool filterVendorBills = false,
    bool filterIsarchived = false,
    bool hascompanyTypeFilters = false,
    bool hasInvoiceVendorFilter = false,
    String searchText = "",
    List<dynamic>? customFilter,
  }) async {
    if (!hasPreviousPage || _isLoading) return;

    _currentPage--;
    await fetchCustomerData(
      context: context,
      filterIndividual: filterIndividual,
      filterCompany: filterCompany,
      filterCustomerInvoice: filterCustomerInvoice,
      filterVendorBills: filterVendorBills,
      filterIsarchived: filterIsarchived,
      hascompanyTypeFilters: hascompanyTypeFilters,
      hasInvoiceVendorFilter: hasInvoiceVendorFilter,
      searchText: searchText,
      customFilter: customFilter,
      loading: true,
    );
  }

  /// Loads additional customers for infinite scrolling.
  ///
  /// Increments page index and appends results.
  Future<void> loadMoreCustomers({
    required BuildContext context,
    required OdooClient client,
    bool filterIndividual = false,
    bool filterCompany = false,
    bool filterCustomerInvoice = false,
    bool filterVendorBills = false,
    bool filterIsarchived = false,
    bool hascompanyTypeFilters = false,
    bool hasInvoiceVendorFilter = false,
    String searchText = "",
    List<dynamic>? customFilter,
  }) async {
    if (_isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;
    _currentPage++;
    notifyListeners();

    try {
      await fetchCustomerData(
        context: context,
        filterIndividual: filterIndividual,
        filterCompany: filterCompany,
        filterCustomerInvoice: filterCustomerInvoice,
        filterVendorBills: filterVendorBills,
        filterIsarchived: filterIsarchived,
        hascompanyTypeFilters: hascompanyTypeFilters,
        hasInvoiceVendorFilter: hasInvoiceVendorFilter,
        searchText: searchText,
        customFilter: customFilter,
      );
    } catch (e) {
      _currentPage--;
      if (context.mounted) {
        CustomSnackbar.showError(context, 'Error loading more customers');
      }
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Fetches related mail activities for all loaded customers.
  ///
  /// Enriches activities with:
  /// - User name
  /// - User profile image
  ///
  /// Maps activity data by customer ID.
  Future<void> fetchActivityData() async {
    try {
      List<int> customerIds = _customers
          .map((customer) => customer['id'])
          .whereType<int>()
          .toList();

      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'search_read',
        'args': [
          [
            ['res_id', 'in', customerIds],
            ['res_model', '=', 'res.partner'],
          ]
        ],
        'kwargs': {
          'fields': [
            'res_id',
            'activity_type_id',
            'date_deadline',
            'summary',
            'user_id'
          ],
        },
      });

      if (response != null) {
        final processedResponse = _convertFalseToNull(response);
        Map<int, List<Map<dynamic, dynamic>>> tempActivities = {};
        for (var activity in processedResponse) {
          int customerId = activity['res_id'];
          tempActivities.putIfAbsent(customerId, () => []).add(activity);
        }

        Set<int> userIds = {};
        for (var activities in tempActivities.values) {
          for (var activity in activities) {
            if (activity['user_id'] != null &&
                activity['user_id'] is List &&
                activity['user_id'].isNotEmpty) {
              userIds.add(activity['user_id'][0]);
            }
          }
        }

        if (userIds.isNotEmpty) {
          final userResponse = await CompanySessionManager.callKwWithCompany({
            'model': 'res.users',
            'method': 'search_read',
            'args': [
              [
                ['id', 'in', userIds.toList()]
              ]
            ],
            'kwargs': {
              'fields': ['id', 'name', 'image_128'],
            },
          });

          if (userResponse != null) {
            final processedUserResponse = _convertFalseToNull(userResponse);
            Map<int, Map<dynamic, dynamic>> userMap = {};
            for (var user in processedUserResponse) {
              userMap[user['id']] = user;
            }

            for (var activities in tempActivities.values) {
              for (var activity in activities) {
                if (activity['user_id'] != null &&
                    activity['user_id'] is List &&
                    activity['user_id'].isNotEmpty) {
                  int userId = activity['user_id'][0];
                  if (userMap.containsKey(userId)) {
                    activity['user_name'] = userMap[userId]!['name'];
                    activity['user_image'] = userMap[userId]!['image_128'];
                  }
                }
              }
            }
          }
        }

        _customerActivities = tempActivities;
      }
    } catch (_) {
    }
  }

  /// Groups customer records based on the selected grouping option.
  ///
  /// Also maintains expansion state and sorts group keys alphabetically.
  void _applyGrouping() {
    _groupedCustomers.clear();
    if (_currentGroupBy == CustomerGroupByOption.none) {
      return;
    }

    for (var customer in _customers) {
      String groupKey = _getGroupKey(customer, _currentGroupBy);
      if (!_groupedCustomers.containsKey(groupKey)) {
        _groupedCustomers[groupKey] = [];
        if (!_groupExpansionState.containsKey(groupKey)) {
          _groupExpansionState[groupKey] = true;
        }
      }
      _groupedCustomers[groupKey]!.add(customer);
    }

    final sortedKeys = _groupedCustomers.keys.toList()..sort();
    final sortedGroups = <String, List<Map<dynamic, dynamic>>>{};
    for (String key in sortedKeys) {
      sortedGroups[key] = _groupedCustomers[key]!;
    }
    _groupedCustomers = sortedGroups;
  }

  /// Returns a group label for a customer based on the
  /// selected [CustomerGroupByOption].
  ///
  /// Handles safe extraction of relational fields.
  String _getGroupKey(
      Map<dynamic, dynamic> customer, CustomerGroupByOption groupBy) {
    switch (groupBy) {
      case CustomerGroupByOption.companyType:
        final companyType = customer['company_type'];
        if (companyType == 'company') return 'Company';
        if (companyType == 'person') return 'Individual';
        return 'Unknown';
      case CustomerGroupByOption.country:
        if (customer['country_id'] is List &&
            customer['country_id'].length > 1) {
          return customer['country_id'][1].toString();
        }
        return 'No Country';
      case CustomerGroupByOption.state:
        if (customer['state_id'] is List && customer['state_id'].length > 1) {
          return customer['state_id'][1].toString();
        }
        return 'No State';
      case CustomerGroupByOption.category:
        final categoryValues = customer['category_values'];
        if (categoryValues is List && categoryValues.isNotEmpty) {
          return categoryValues.first.toString();
        }
        return 'No Category';
      case CustomerGroupByOption.salesperson:
        if (customer['user_id'] is List && customer['user_id'].length > 1) {
          return customer['user_id'][1].toString();
        }
        return 'Unassigned';
      case CustomerGroupByOption.customerRank:
        final rank = customer['customer_rank'] ?? 0;
        if (rank > 0) return 'Customer (Rank: $rank)';
        return 'Not a Customer';
      case CustomerGroupByOption.supplierRank:
        final rank = customer['supplier_rank'] ?? 0;
        if (rank > 0) return 'Supplier (Rank: $rank)';
        return 'Not a Supplier';
      case CustomerGroupByOption.isCompany:
        final isCompany = customer['is_company'] ?? false;
        return isCompany ? 'Company' : 'Individual';
      case CustomerGroupByOption.active:
        final active = customer['active'] ?? true;
        return active ? 'Active' : 'Archived';
      case CustomerGroupByOption.none:
      default:
        return 'All';
    }
  }

  /// Calculates total revenue (based on sale order count)
  /// for a grouped set of customers.
  double getGroupRevenue(List<Map<dynamic, dynamic>> groupCustomers) {
    return groupCustomers.fold(0.0, (sum, customer) {
      final saleOrderCount = customer['sale_order_count'];
      if (saleOrderCount is num) {
        return sum + saleOrderCount.toDouble();
      }
      return sum;
    });
  }

  /// Fully resets provider state including:
  /// - Customer list
  /// - Activities
  /// - Grouping
  /// - Custom filters
  /// - Pagination state
  void clearData() {
    _customers = [];
    _customerActivities = {};
    _currentPage = 0;
    _hasMoreData = true;
    _groupedCustomers.clear();
    _currentCustomFilterDomain = null;
    _customFilters = null;
    _hasCustomFilters = false;
    notifyListeners();
  }
}
