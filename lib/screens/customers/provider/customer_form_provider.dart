import 'dart:convert';
import 'package:mobo_crm/global_methods/services/isar_caching_service.dart';
import 'package:mobo_crm/screens/customers/isar/customer_form_isar_cache.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobo_crm/global_methods/services/global_error_handler.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/models.dart';
import 'package:geocoding/geocoding.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/company/services/company_session_service.dart';
import '../../../core/company/session/company_session_manager.dart';
import '../../../models/isar/lead_and_customer_models.dart';
import '../../../services/app_install_check.dart';
import '../../../utils/snackbar.dart';

/// Provider responsible for managing customer form state,
/// including create, edit, update, caching, geolocation,
/// category handling, and image processing.
///
/// Responsibilities:
/// - Fetch and populate customer details from Odoo
/// - Create and update customer records
/// - Manage form controllers and validation
/// - Handle company, salesperson, and payment selections
/// - Cache customer data locally using Isar
/// - Fallback to offline cache when API fails
/// - Manage partner geolocation (latitude/longitude)
/// - Handle image upload and Base64 conversion
/// - Track edit state and unsaved changes
///
/// Acts as the main state manager for the Customer Form screen.
class CustomerFormProvider with ChangeNotifier {
  final CompanySessionService sessionService;

  CustomerFormProvider({required this.sessionService});

  bool isEdit = false;
  bool isLoading = false;
  String? name;
  String? city;
  StateClass? selectedState;
  Country? selectedCountry;
  String? zip;
  String? phone;
  String? mobile;
  String? companyName;
  String? email;
  String? website;
  String? lang;
  int? customerIdRaw;
  String? _otherDetails;
  String? _errorMessage;
  final Map<String, dynamic> _data = {};

  Map<String, dynamic> get data => _data;
  AppError? customerError;
  bool hasError = false;
  List<int> tags = [];
  List<String>? categoryList = [];
  List contacts = [];
  List<int> selectedCategoriesId = [];
  List<int> childIds = [];
  final List<dynamic> _leadTags = [];

  List<dynamic> get leadTags => _leadTags;
  List<Map<dynamic, dynamic>> childContacts = [];
  List<Category> _categoyListValues = [];
  List paymentterms = [];
  List paymentMethodList = [];
  List industryList = [];
  bool isChanged = false;
  Map<String, dynamic> _initialSnapshot = {};
  List fiscalPositionList = [];

  List<Category> get categoyListValues => _categoyListValues;
  List<Category> _allCategoryList = [];

  List<Category> get allCategoryList => _allCategoryList;
  CustomerItemModel? selectedCompanyID;
  String? checkType;
  bool isAddessEditable = false;
  CustomerItemModel? tempCustomer;
  String? selectedImageBase64;
  double? lat;
  double? long;
  TextEditingController nameController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController street2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController langController = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  TextEditingController companyIDController = TextEditingController();
  TextEditingController jobPositionController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  CustomerItemModel? selectedSalesperson;
  CustomerItemModel? selectedSalesTeam;
  AccountPaymentTerm? selectedCustomerPaymentTerm;
  TextEditingController companyRegistryController = TextEditingController();
  IndustryModel? selectedIndustry;
  AccountPaymentTerm? selectedSupplierPaymentTerm;
  AccountPaymentMethod? selectedPaymentMethod;

  String _customerType = 'individual';

  String get customerType => _customerType;
  bool isSaleInstalled = false;

  bool usedFallbackFields = false;

  Future<void> checkSaleModuleInstallation(OdooClient client) async {
    try {
      final checker = AppInstallCheck();
      bool isSaleManagementInstalled =
      await checker.isModuleInstalled('sale_management');
      bool isSaleModuleInstalled =
      await checker.isModuleInstalled('sale');

      isSaleInstalled = isSaleManagementInstalled || isSaleModuleInstalled;
      notifyListeners();
    } catch (e) {
      isSaleInstalled = false;
    }
  }

  /// Checks whether any form field has been modified.
  ///
  /// Compares current controller values against
  /// the originally loaded `_data` snapshot.
  ///
  /// Returns true if changes are detected.
  /// Captures a snapshot of all current form field values.
  /// Call this after data is fully loaded to establish the baseline.
  Map<String, dynamic> _captureSnapshot() {
    return {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'mobile': mobileController.text,
      'website': websiteController.text,
      'street': streetController.text,
      'street2': street2Controller.text,
      'city': cityController.text,
      'zip': zipController.text,
      'jobPosition': jobPositionController.text,
      'comment': commentController.text,
      'companyRegistry': companyRegistryController.text,
      'reference': referenceController.text,
      'lang': langController.text,
      'countryId': selectedCountry?.id,
      'stateId': selectedState?.id,
      'companyId': selectedCompanyID?.serverId,
      'salespersonId': selectedSalesperson?.serverId,
      'salesTeamId': selectedSalesTeam?.serverId,
      'customerPaymentTermId': selectedCustomerPaymentTerm?.id,
      'industryId': selectedIndustry?.id,
      'supplierPaymentTermId': selectedSupplierPaymentTerm?.id,
      'paymentMethodId': selectedPaymentMethod?.id,
      'imageBase64': selectedImageBase64,
      'customerType': _customerType,
      'categoryIds': List<int>.from(selectedCategoriesId),
    };
  }

  void saveInitialSnapshot() {
    _initialSnapshot = _captureSnapshot();
  }

  bool hasFormChanged() {
    if (_initialSnapshot.isEmpty) return false;
    final current = _captureSnapshot();
    for (final key in current.keys) {
      final currentVal = current[key];
      final initialVal = _initialSnapshot[key];
      if (key == 'categoryIds') {
        final curList = currentVal as List<int>;
        final initList = initialVal as List<int>? ?? [];
        if (curList.length != initList.length) return true;
        final sortedCur = List<int>.from(curList)..sort();
        final sortedInit = List<int>.from(initList)..sort();
        for (int i = 0; i < sortedCur.length; i++) {
          if (sortedCur[i] != sortedInit[i]) return true;
        }
      } else if (currentVal != initialVal) {
        return true;
      }
    }
    return false;
  }

  int? _safeListInt(dynamic value, int index) {
    if (value is List && value.length > index) {
      final v = value[index];
      return v is int ? v : int.tryParse(v?.toString() ?? '');
    }
    return null;
  }

  bool setEquals<T>(Set<T> a, Set<T> b) =>
      a.length == b.length && a.containsAll(b);

  /// Listenable that merges all form text controllers.
  /// Use this with [ListenableBuilder] to reactively enable/disable
  /// the save button when any text field changes.
  late final Listenable formFieldsListenable = Listenable.merge([
    nameController,
    streetController,
    street2Controller,
    cityController,
    zipController,
    phoneController,
    mobileController,
    emailController,
    websiteController,
    jobPositionController,
    commentController,
    companyRegistryController,
  ]);

  void setCustomerType(String type) {
    _customerType = type;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    streetController.dispose();
    street2Controller.dispose();
    cityController.dispose();
    zipController.dispose();
    phoneController.dispose();
    mobileController.dispose();
    emailController.dispose();
    websiteController.dispose();
    langController.dispose();
    referenceController.dispose();
    companyIDController.dispose();
    jobPositionController.dispose();
    commentController.dispose();
    companyNameController.dispose();
    locationController.dispose();
    super.dispose();
  }

  /// Clears all form fields and resets provider state.
  ///
  /// Parameters:
  /// - [isNotify]: If true, triggers UI update.
  ///   If false, sets default form mode without notifying.
  void clearAll({bool isNotify = true}) {
    nameController.clear();
    streetController.clear();
    street2Controller.clear();
    cityController.clear();
    zipController.clear();
    phoneController.clear();
    mobileController.clear();
    emailController.clear();
    websiteController.clear();
    langController.clear();
    referenceController.clear();
    jobPositionController.clear();
    commentController.clear();
    locationController.clear();
    cityController.clear();
    selectedCategoriesId = [];
    categoyListValues.clear();
    selectedImageBase64 = null;
    customerIdRaw = null;
    selectedCompanyID = null;
    tempCustomer = null;
    selectedCountry = null;
    selectedState = null;
    _data.clear();

    _customerType = '';
    checkType = '';

    isLoading = false;
    isEdit = false;
    isChanged = false;

    if (isNotify) {
      notifyListeners();
    } else {
      _customerType = 'individual';
      checkType = 'contact';
      isEdit = true;
    }
  }

  /// Fetches active internal users for salesperson selection.
  Future<List<CustomerItemModel>> fetchSalespersons(OdooClient client) async {
    final response = await CompanySessionManager.callKwWithCompany({
      'model': 'res.users',
      'method': 'search_read',
      'args': [
        [
          ['share', '=', false],
          ['active', '=', true]
        ]
      ],
      'kwargs': {
        'fields': ['id', 'name'],
        'limit': 100
      },
    });
    return (response as List)
        .map((e) => CustomerItemModel.fromJson(e))
        .toList();
  }

  /// Fetches active CRM sales teams.
  Future<List<CustomerItemModel>> fetchSalesTeams(OdooClient client) async {
    final response = await CompanySessionManager.callKwWithCompany({
      'model': 'crm.team',
      'method': 'search_read',
      'args': [
        [
          ['active', '=', true]
        ]
      ],
      'kwargs': {
        'fields': ['id', 'name'],
        'limit': 50
      },
    });
    return (response as List)
        .map((e) => CustomerItemModel.fromJson(e))
        .toList();
  }

  /// Fetches available customer payment terms.
  Future<List<AccountPaymentTerm>> fetchPaymentTerms(OdooClient client) async {
    final response = await CompanySessionManager.callKwWithCompany({
      'model': 'account.payment.term',
      'method': 'search_read',
      'args': [[]],
      'kwargs': {
        'fields': ['id', 'name'],
        'limit': 50
      },
    });
    return (response as List)
        .map((e) => AccountPaymentTerm.fromJson(e))
        .toList();
  }

  /// Fetches available payment methods.
  Future<List<AccountPaymentMethod>> fetchPaymentMethod(
      OdooClient client) async {
    final response = await CompanySessionManager.callKwWithCompany({
      'model': 'account.payment.method',
      'method': 'search_read',
      'args': [[]],
      'kwargs': {
        'fields': ['id', 'name'],
        'limit': 50
      },
    });
    return (response as List)
        .map((e) => AccountPaymentMethod.fromJson(e))
        .toList();
  }

  /// Fetches partner industries for dropdown selection.
  Future<List<IndustryModel>> fetchIndustries(OdooClient client) async {
    final response = await CompanySessionManager.callKwWithCompany({
      'model': 'res.partner.industry',
      'method': 'search_read',
      'args': [[]],
      'kwargs': {
        'fields': ['id', 'name'],
        'limit': 100
      },
    });
    return (response as List).map((e) => IndustryModel.fromJson(e)).toList();
  }

  /// Fetches full customer details from Odoo
  /// and populates the form controllers.
  ///
  /// Features:
  /// - Loads relational fields (state, country, salesperson)
  /// - Initializes category list
  /// - Saves a local cache copy
  /// - Handles geolocation initialization
  /// - Falls back to local Isar cache on failure
  ///
  /// Parameters:
  /// - [client]: Active Odoo client
  /// - [customerId]: Partner ID
  /// - [loading]: Whether to notify UI immediately
  Future<void> fetchCustomerData(OdooClient client, int customerId,
      {bool loading = false}) async {
    final prefs = await SharedPreferences.getInstance();
    int version = prefs.getInt('version') ?? 0;

    isLoading = true;
    isEdit = false;
    isChanged = false;
    hasError = false;
    customerIdRaw = customerId;
    if (loading) {
      notifyListeners();
    }
    await enableGeolocationIfNotEnabled(client);
    await checkSaleModuleInstallation(client);

    try {
      dynamic response;
      final fields = [
        'name',
        'street',
        'street2',
        'city',
        'state_id',
        'country_id',
        'zip',
        'phone',
        'function',
        'email',
        'website',
        'lang',
        'category_id',
        'child_ids',
        'is_company',
        'parent_id',
        'user_id',
        'commercial_partner_id',
        'type',
        'child_ids',
        'ref',
        if (isSaleInstalled) ...['property_supplier_payment_term_id'],
        if (isSaleInstalled && version < 18) ...['property_payment_method_id'],
        'company_registry',
        'industry_id',
        'company_id',
        'partner_latitude',
        'partner_longitude',
        'comment',
        if (isSaleInstalled) ...['property_payment_term_id'],
      ];

      List<String> optionalFields = [
        if (version <= 18) 'mobile',
        if (version < 18)'team_id',
      ];

      List<String> finalFields = [...fields, ...optionalFields];

      try {
        response = await CompanySessionManager.callKwWithCompany({
          'model': 'res.partner',
          'method': 'search_read',
          'args': [
            [
              ['id', '=', customerId]
            ]
          ],
          'kwargs': {
            'fields': finalFields,
          },
        });
      } catch (e) {
        usedFallbackFields = true;

        response = await CompanySessionManager.callKwWithCompany({
          'model': 'res.partner',
          'method': 'search_read',
          'args': [
            [
              ['id', '=', customerId]
            ]
          ],
          'kwargs': {
            'fields': fields,
          },
        });
      }

      if (response.isNotEmpty) {
        final result = response[0];
        final customer = CustomerFormIsarCache.fromJson(result);

        await IsarService.saveCustomerFormData(customer);
        _data.addAll({
          'name': _sanitize(result['name']),
          'street': _sanitize(result['street']),
          'street2': _sanitize(result['street2']),
          'city': _sanitize(result['city']),
          'state': _sanitize(result['state_id']),
          'country': _sanitize(result['country_id']),
          'zip': _sanitize(result['zip']),
          'phone': _sanitize(result['phone']),
          'mobile': _sanitize(
            !usedFallbackFields ? result['mobile'] ?? '' : '',
          ),
          'email': _sanitize(result['email']),
          'website': _sanitize(result['website']),
          'lang': _sanitize(result['lang']),
          'commercial_partner_id': _sanitize(result['commercial_partner_id']),
          'jobposition': _sanitize(result['function']),
          'category_id': _sanitize(result['category_id']),
          'child_ids': _sanitize(result['child_ids']),
          'is_company': result['is_company'] ?? false,
          'user_id': _sanitize(result['user_id']),
          'parent_id': _sanitize(result['parent_id']),
          'type': _sanitize(result['type']),
          'lat': _sanitize(result['partner_latitude']),
          'long': _sanitize(result['partner_longitude']),
          'comment': _sanitize(result['comment']),
          'ref': _sanitize(result['ref']),
          'company_registry': _sanitize(result['company_registry']),
        });

        if (result['user_id'] is List && result['user_id'].length > 1) {
          selectedSalesperson = CustomerItemModel()
            ..serverId = result['user_id'][0]
            ..name = result['user_id'][1];
        } else {
          selectedSalesperson = null;
        }

        if (!usedFallbackFields &&
            result.containsKey('team_id') &&
            result['team_id'] is List &&
            result['team_id'].length > 1) {
          selectedSalesTeam = CustomerItemModel()
            ..serverId = result['team_id'][0]
            ..name = result['team_id'][1];
        } else {
          selectedSalesTeam = null;
        }

        selectedCustomerPaymentTerm =
            result['property_payment_term_id'] is List &&
                    result['property_payment_term_id'].length > 1
                ? AccountPaymentTerm(
                    id: result['property_payment_term_id'][0],
                    name: result['property_payment_term_id'][1])
                : null;

        companyRegistryController.text =
            result['company_registry']?.toString() ?? '';

        selectedIndustry =
            result['industry_id'] is List && result['industry_id'].length > 1
                ? IndustryModel(
                    id: result['industry_id'][0],
                    name: result['industry_id'][1])
                : null;

        selectedSupplierPaymentTerm =
            result['property_supplier_payment_term_id'] is List &&
                    result['property_supplier_payment_term_id'].length > 1
                ? AccountPaymentTerm(
                    id: result['property_supplier_payment_term_id'][0],
                    name: result['property_supplier_payment_term_id'][1])
                : null;

        selectedPaymentMethod = result['property_payment_method_id'] is List &&
                result['property_payment_method_id'].length > 1
            ? AccountPaymentMethod(
                id: result['property_payment_method_id'][0],
                name: result['property_payment_method_id'][1])
            : null;

        _customerType = _data['is_company'] ? 'company' : 'individual';
        checkType = _data['type'];
        lat =
            _data['partner_latitude'] == 0 || _data['partner_latitude'] == null
                ? 0
                : _data['partner_latitude'];
        long = _data['partner_longitude'] == 0 ||
                _data['partner_longitude'] == null
            ? 0
            : _data['partner_longitude'];
        nameController.text = _data['name'] ?? '';
        streetController.text = _data['street'] ?? '';
        street2Controller.text = _data['street2'] ?? '';
        cityController.text = _data['city'] ?? '';
        zipController.text = _data['zip'] ?? '';
        phoneController.text = _data['phone'] ?? '';
        mobileController.text = _data['mobile'] ?? '';
        emailController.text = _data['email'] ?? '';
        websiteController.text = _data['website'] ?? '';
        langController.text = _data['lang'] ?? '';
        referenceController.text = _data['ref'] ?? '';
        jobPositionController.text = _data['jobposition'] ?? '';

        selectedCompanyID =
            _data['parent_id'] is List && _data['parent_id'].length > 1
                ? (CustomerItemModel()
                  ..serverId = _data['parent_id'][0]
                  ..name = _data['parent_id'][1]
                  ..email = ""
                  ..fullName = "")
                : null;
        tempCustomer = selectedCompanyID;
        commentController.text = _data['comment'] ?? '';
        selectedCountry =
            _data['country'] is List && _data['country'].length > 1
                ? Country(id: _data['country'][0], name: _data['country'][1])
                : null;

        selectedState = _data['state'] is List && _data['state'].length > 1
            ? StateClass(id: _data['state'][0], name: _data['state'][1])
            : null;
        String cityText = cityController.text.trim();
        String stateText = selectedState?.name.trim() ?? '';
        String countryText = selectedCountry?.name.trim() ?? '';
        String street1 = streetController.text.trim();
        String street2 = street2Controller.text.trim();

        List<String> parts = [];

        if (cityText.isNotEmpty) parts.add(cityText);
        if (stateText.isNotEmpty) parts.add(stateText);
        if (countryText.isNotEmpty) parts.add(countryText);
        if (street1.isNotEmpty) parts.add(street1);
        if (street2.isNotEmpty) parts.add(street2);

        locationController.text = parts.join(', ');
      }

      await initializeCategoryList(client, customerId);
      if (long == 0 && lat == 0 ||
          long == null && lat == null ||
          lat == null && long == 0 ||
          long == null && lat == 0) {
        await fetchPartnerGeolocation(client, customerId);
      }

      isLoading = false;
      saveInitialSnapshot();
      notifyListeners();
    } catch (e, stack) {
      final success = await loadCustomerFromCache(customerId);
      if (success == false) {
        customerError = await ErrorHandler.handleException(e);
        isLoading = false;
        hasError = true;
        notifyListeners();
      }
    }
  }

  /// Loads customer form data from local Isar cache.
  ///
  /// Used when API call fails.
  /// Returns true if cached data is successfully loaded.
  Future<bool> loadCustomerFromCache(int customerId) async {
    final model = await IsarService.getCustomerData(customerId);

    if (model == null) {
      return false;
    }

    _data.clear();
    _data.addAll({
      'id': model.serverId,
      'name': model.name,
      'street': model.street,
      'street2': model.street2,
      'city': model.city,
      'state': [model.stateId, model.stateName],
      'country': [model.countryId, model.countryName],
      'zip': model.zip,
      'phone': model.phone,
      'mobile': model.mobile,
      'email': model.email,
      'website': model.website,
      'lang': model.lang,
      'category_id': model.categoryIds,
      'is_company': model.isCompany ?? false,
      'user_id': [model.userId, model.userName],
      'parent_id': model.parentId != null && model.parentName != null
          ? [model.parentId, model.parentName]
          : null,
      'commercial_partner_id': [
        model.commercialPartnerId,
        model.commercialPartnerName
      ],
      'type': model.type,
      'ref': model.ref,
      'company_registry': model.companyRegistry,
      'industry_id': [model.industryId, model.industryName],
      'company_id': [model.companyId, model.companyName],
      'partner_latitude': model.partnerLatitude,
      'partner_longitude': model.partnerLongitude,
      'comment': model.comment,
      'jobposition': model.jobPosition,
    });
    _customerType = model.isCompany == true ? 'company' : 'individual';
    checkType = model.type;

    lat = model.partnerLatitude ?? 0;
    long = model.partnerLongitude ?? 0;

    nameController.text = model.name ?? '';
    streetController.text = model.street ?? '';
    street2Controller.text = model.street2 ?? '';
    cityController.text = model.city ?? '';
    zipController.text = model.zip ?? '';
    phoneController.text = model.phone ?? '';
    mobileController.text = model.mobile ?? '';
    emailController.text = model.email ?? '';
    websiteController.text = model.website ?? '';
    langController.text = model.lang ?? '';
    referenceController.text = model.ref ?? '';
    jobPositionController.text = model.jobPosition ?? '';
    commentController.text = model.comment ?? '';

    selectedCompanyID = model.parentId != null
        ? (CustomerItemModel()
          ..serverId = model.parentId!
          ..name = model.parentName ?? ''
          ..email = ''
          ..fullName = '')
        : null;

    selectedCountry = model.countryId != null
        ? Country(id: model.countryId!, name: model.countryName ?? '')
        : null;

    selectedState = model.stateId != null
        ? StateClass(id: model.stateId!, name: model.stateName ?? '')
        : null;

    List<String> parts = [];
    final cityText = cityController.text.trim();
    final stateText = selectedState?.name.trim() ?? '';
    final countryText = selectedCountry?.name.trim() ?? '';
    final street1 = streetController.text.trim();
    final street2 = street2Controller.text.trim();

    if (cityText.isNotEmpty) parts.add(cityText);
    if (stateText.isNotEmpty) parts.add(stateText);
    if (countryText.isNotEmpty) parts.add(countryText);
    if (street1.isNotEmpty) parts.add(street1);
    if (street2.isNotEmpty) parts.add(street2);

    locationController.text = parts.join(', ');

    isLoading = false;
    saveInitialSnapshot();
    notifyListeners();
    return true;
  }

  /// Triggers server-side geolocation for a partner
  /// and retrieves updated latitude and longitude.
  ///
  /// Returns a map containing:
  /// - latitude
  /// - longitude
  /// - address details
  /// - localization date
  Future<Map<String, dynamic>?> fetchPartnerGeolocation(
    OdooClient client,
    int partnerId,
  ) async {
    try {
      await CompanySessionManager.callKwWithCompany({
        'model': 'res.partner',
        'method': 'geo_localize',
        'args': [
          [partnerId]
        ],
        'kwargs': {
          'context': {
            'lang': 'en_US',
            'tz': 'Asia/Calcutta',
            'uid': 2,
            'allowed_company_ids': [1],
            'default_is_company': true,
          }
        }
      });

      final result = await CompanySessionManager.callKwWithCompany({
        'model': 'res.partner',
        'method': 'web_read',
        'args': [
          [partnerId]
        ],
        'kwargs': {
          'context': {
            'lang': 'en_US',
            'tz': 'Asia/Calcutta',
            'allowed_company_ids': [1],
            'default_is_company': true,
          },
          'specification': {
            'partner_latitude': {},
            'partner_longitude': {},
            'date_localization': {},
            'name': {},
            'street': {},
            'street2': {},
            'city': {},
            'zip': {},
            'state_id': {
              'fields': {'display_name': {}}
            },
            'country_id': {
              'fields': {'display_name': {}}
            },
          }
        }
      });

      if (result is List && result.isNotEmpty) {
        final data = result.first;
        final latVal = data['partner_latitude'];
        final longVal = data['partner_longitude'];

        if (latVal != null && longVal != null) {
          lat = latVal;
          long = longVal;
          notifyListeners();

          return {
            'latitude': lat,
            'longitude': long,
            'partner_id': partnerId,
            'partner_name': data['name'],
            'address': {
              'street': data['street'],
              'street2': data['street2'],
              'city': data['city'],
              'zip': data['zip'],
              'country': data['country_id']?['display_name'],
            },
            'date_localization': data['date_localization'],
          };
        } else {
          return null;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Fetches active company partners from Odoo.
  ///
  /// Used for parent company selection dropdown.
  Future<List<CustomerItemModel>> fetchCompanyList(OdooClient client) async {
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'res.partner',
        'method': 'search_read',
        'args': [
          [
            ['is_company', '=', true],
            ['active', '=', true],
          ]
        ],
        'kwargs': {
          'fields': ['id', 'vat', 'name', 'email', 'complete_name'],
          'limit': 100,
        },
      });

      return (response as List)
          .map((json) => CustomerItemModel.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Creates a new customer record in Odoo.
  ///
  /// Performs validation before submission.
  /// Handles:
  /// - Company vs individual logic
  /// - Category many2many mapping
  /// - Optional sale-related fields
  /// - Image upload (Base64)
  ///
  /// Shows error snackbar on failure.
  Future<void> createCustomerData(
    BuildContext ctx, {
    bool loading = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    int version = prefs.getInt('version') ?? 0;

    if (nameController.text.isEmpty || nameController.text == '') {
      CustomSnackbar.showWarning(ctx, "Name is required");
      return;
    }
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      final Map<String, dynamic> values = {
        'name': nameController.text.trim(),
        'is_company': _customerType == 'company',
        'company_type': _customerType == 'company' ? 'company' : 'person',
        'type': checkType ?? 'contact',
        'street': streetController.text.trim(),
        'street2': street2Controller.text.trim(),
        'city': cityController.text.trim(),
        'zip': zipController.text.trim(),
        'state_id': selectedState?.id,
        'country_id': selectedCountry?.id,
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'website': websiteController.text.trim(),
        'lang': langController.text.trim().isEmpty
            ? 'en_US'
            : langController.text.trim(),
        'parent_id': selectedCompanyID?.serverId,
        'user_id': selectedSalesperson?.serverId ?? false,
        'category_id': selectedCategoriesId.isNotEmpty
            ? [
                [6, 0, selectedCategoriesId]
              ]
            : [],
        'function': jobPositionController.text.trim(),
        'comment': commentController.text.trim(),
        if (version < 18) 'team_id': selectedSalesTeam?.serverId ?? false,
        'ref': referenceController.text,
        if (isSaleInstalled)
          'property_payment_term_id': selectedCustomerPaymentTerm?.id ?? false,
        if (isSaleInstalled)
          'property_supplier_payment_term_id':
              selectedSupplierPaymentTerm?.id ?? false,
        if (isSaleInstalled && version < 18)
          'property_payment_method_id': selectedPaymentMethod?.id ?? false,
        'company_registry': companyRegistryController.text.trim(),
        'industry_id': selectedIndustry?.id ?? false,
      };
      if (selectedImageBase64 != null) {
        values['image_1920'] = selectedImageBase64;
      }
      final context = {
        'lang': 'en_US',
        'tz': 'Asia/Kolkata',
        'allowed_company_ids': [1],
        'default_is_company': _customerType == 'company',
      };

      final int newPartnerId = await sessionService.callKwWithCompany({
        'model': 'res.partner',
        'method': 'create',
        'args': [values],
        'kwargs': {'context': context},
      });

      customerIdRaw = newPartnerId;
      isLoading = false;
      isEdit = false;
      notifyListeners();
    } catch (e) {
      customerError = await ErrorHandler.handleException(e);
      isLoading = false;
      hasError = true;
      notifyListeners();
    }
  }

  /// Ensures that the Odoo geolocation module
  /// (`base_geolocalize`) is enabled.
  ///
  /// Automatically installs and activates the module
  /// if not already active.
  Future<void> enableGeolocationIfNotEnabled(OdooClient client) async {
    try {
      final defaultGetResult = await CompanySessionManager.callKwWithCompany({
        'model': 'res.config.settings',
        'method': 'default_get',
        'args': [
          ['module_base_geolocalize']
        ],
        'kwargs': {}
      });

      final isEnabled = defaultGetResult['module_base_geolocalize'] == true;

      if (isEnabled) {
        return;
      }

      final settingsId = await CompanySessionManager.callKwWithCompany({
        'model': 'res.config.settings',
        'method': 'create',
        'args': [
          {
            'module_base_geolocalize': true,
          }
        ]
      });

      await CompanySessionManager.callKwWithCompany({
        'model': 'res.config.settings',
        'method': 'execute',
        'args': [
          [settingsId],
        ]
      });
    } catch (_) {}
  }

  /// Opens gallery picker and converts selected image
  /// to Base64 for upload.
  Future<void> pickImageFromUser() async {
    try {
      final picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        selectedImageBase64 = base64Encode(bytes);
        notifyListeners();
      }
    } catch (_) {}
  }

  /// Converts Odoo `false` values to null
  /// for consistent null-safe handling.
  dynamic _sanitize(dynamic value) {
    if (value == false || value == null) return null;
    return value;
  }

  /// Fetches child contact records linked to the customer.
  ///
  /// Populates the `childContacts` list.
  Future<void> fetchChildContacts(OdooClient client) async {
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'res.partner',
        'method': 'search_read',
        'args': [
          [
            ['id', 'in', childIds]
          ]
        ],
        'kwargs': {
          'fields': [
            'id',
            'name',
            'email',
            'phone',
          ],
        },
      });

      if (response is List && response.isNotEmpty) {
        childContacts = List<Map<String, dynamic>>.from(response);
      } else {
        childContacts = [];
      }

      notifyListeners();
    } catch (_) {}
  }

  /// Toggles edit mode for the customer form.
  ///
  /// Enables or disables field editing.
  void toggleEdit() {
    isEdit = !isEdit;
    notifyListeners();
  }

  /// Updates an existing customer record.
  ///
  /// Validates required fields before sending update.
  /// Shows success/error snackbar based on result.
  ///
  /// Returns true if update succeeds.
  Future<bool> saveCustomerData(
      OdooClient client, int customerId, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    int version = prefs.getInt('version') ?? 0;

    if (nameController.text.isEmpty || nameController.text == '') {
      CustomSnackbar.showWarning(context, "Name is required");

      return false;
    }
    isChanged = true;
    isEdit = false;
    tempCustomer = selectedCompanyID;
    notifyListeners();

    try {
      final updatedData = {
        'function': jobPositionController.text,
        'name': nameController.text,
        'street': streetController.text,
        'street2': street2Controller.text,
        'city': cityController.text,
        'state_id': selectedState?.id ?? false,
        'category_id': selectedCategoriesId,
        'country_id': selectedCountry?.id ?? false,
        'zip': zipController.text,
        'phone': phoneController.text,
        if (version <= 18) 'mobile': mobileController.text,
        'email': emailController.text,
        'website': websiteController.text,
        'commercial_partner_id': selectedCompanyID?.serverId ?? false,
        'is_company': _customerType == 'company',
        'parent_id': selectedCompanyID?.serverId ?? false,
        'image_1920': selectedImageBase64,
        'user_id': selectedSalesperson?.serverId ?? false,
        if (version < 18) 'team_id': selectedSalesTeam?.serverId ?? false,
        'ref': referenceController.text,
        if (isSaleInstalled)
          'property_payment_term_id': selectedCustomerPaymentTerm?.id ?? false,
        if (isSaleInstalled)
          'property_supplier_payment_term_id':
              selectedSupplierPaymentTerm?.id ?? false,
        if (isSaleInstalled && version < 18)
          'property_payment_method_id': selectedPaymentMethod?.id ?? false,
        'company_registry': companyRegistryController.text.trim(),
        'industry_id': selectedIndustry?.id ?? false,
      };

      await sessionService.callKwWithCompanyUpdate({
        'model': 'res.partner',
        'method': 'write',
        'args': [
          [customerId],
          updatedData,
        ],
        'kwargs': {},
      });
      if (context.mounted) {
        CustomSnackbar.showSuccess(context, 'Changes saved successfully');
      }
      await initializeCategoryList(client, customerId);

      isEdit = false;
      return true;
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.showError(context, 'Unexpected Error Occurred');
      }
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetches only address-related fields
  /// and updates form controllers.
  ///
  /// Also refreshes geolocation if required.
  Future<void> fetchAddressData({
    required OdooClient client,
    required int customerId,
  }) async {
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'res.partner',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', customerId]
          ]
        ],
        'kwargs': {
          'fields': [
            'city',
            'street',
            'street2',
            'state_id',
            'country_id',
          ],
        },
      });

      if (response.isNotEmpty) {
        final result = response[0];

        final dynamic rawCity = result['city'];
        final dynamic rawState = result['state_id'];
        final dynamic rawCountry = result['country_id'];
        final dynamic rawstreet = result['street'];
        final dynamic rawstreet2 = result['street2'];

        final String city = rawCity?.toString().trim() ?? '';
        final String street1 = rawstreet?.toString().trim() ?? '';
        final String street2 = rawstreet2?.toString().trim() ?? '';
        selectedState;
        selectedCountry;

        if (rawState is List && rawState.length == 2) {
          selectedState = StateClass(id: rawState[0], name: rawState[1]);
        } else {
          selectedState = null;
        }

        if (rawCountry is List && rawCountry.length == 2) {
          selectedCountry = Country(id: rawCountry[0], name: rawCountry[1]);
        } else {
          selectedCountry = null;
        }

        streetController.text = street1;
        street2Controller.text = street2;

        cityController.text = city;

        List<String> parts = [];
        if (city.isNotEmpty) parts.add(city);
        if (selectedState?.name.isNotEmpty ?? false) {
          parts.add(selectedState!.name);
        }
        if (selectedCountry?.name.isNotEmpty ?? false) {
          parts.add(selectedCountry!.name);
        }

        locationController.text = parts.join(', ');
        fetchPartnerGeolocation(client, customerId);
      }
    } catch (_) {}
  }

  /// Loads selected categories for the customer
  /// and maps them into Category model objects.
  Future<void> initializeCategoryList(OdooClient client, int customerId) async {
    try {
      final customerResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'res.partner',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', customerId]
          ]
        ],
        'kwargs': {
          'fields': ['category_id'],
        },
      });

      if (customerResponse.isEmpty ||
          customerResponse[0]['category_id'] == false) {
        _categoyListValues = [];
        return;
      }

      List<int> categoryIds =
          List<int>.from(customerResponse[0]['category_id'] as List);

      if (categoryIds.isEmpty) {
        _categoyListValues = [];
        return;
      }

      selectedCategoriesId = categoryIds;

      final categoryResponse = await CompanySessionManager.callKwWithCompany({
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

      if (categoryResponse is! List || categoryResponse.isEmpty) {
        _categoyListValues = [];
        return;
      }

      _categoyListValues = categoryResponse
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .toList();

      notifyListeners();
    } catch (e) {
      _categoyListValues = [];
    }
  }

  /// Fetches all available partner categories
  /// for selection.
  Future<void> fetchAllCategoryList(OdooClient client) async {
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'res.partner.category',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name', 'parent_id'],
        },
      });

      if (response is List && response.isNotEmpty) {
        _allCategoryList = response
            .map((json) => Category.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        _allCategoryList = [];
      }

      notifyListeners();
    } catch (e) {
      _allCategoryList = [];
    }
  }

  /// Handles location selection from map search.
  ///
  /// Matches country and state names from Odoo,
  /// updates controllers, and refreshes UI state.
  Future<void> handleMapSelection(
    BuildContext context,
    Map<String, dynamic> selectedPlace,
    OdooClientManager clientprovider,
  ) async {
    isLoading = true;
    notifyListeners();

    if (selectedPlace.isNotEmpty) {
      try {
        final countryList = await CompanySessionManager.callKwWithCompany({
          'model': 'res.country',
          'method': 'search_read',
          'args': [[]],
          'kwargs': {
            'fields': ['id', 'name']
          },
        });

        final countries = (countryList as List<dynamic>)
            .map((item) => Country.fromJson(item as Map<String, dynamic>))
            .toList();

        selectedCountry = null;
        selectedState = null;

        String normalize(String? val) => val?.toLowerCase().trim() ?? '';

        final selectedCountryName = normalize(selectedPlace['country']);
        final mapStateName = normalize(selectedPlace['state']);
        final mapCityName = normalize(selectedPlace['city']);

        if (selectedCountryName.isNotEmpty) {
          final matchedCountry = countries.firstWhere(
            (country) => normalize(country.name) == selectedCountryName,
            orElse: () => Country(id: -1, name: ''),
          );

          if (matchedCountry.id == -1) {
            return;
          }

          selectedCountry = matchedCountry;
          final selectedCountryId = matchedCountry.id;

          String? selectedStateName;
          String finalCityName = selectedPlace['city'] ?? '';

          final stateList = await CompanySessionManager.callKwWithCompany({
            'model': 'res.country.state',
            'method': 'search_read',
            'args': [
              [
                ['country_id', '=', selectedCountryId]
              ]
            ],
            'kwargs': {
              'fields': ['id', 'name', 'country_id'],
            },
          });

          final states = (stateList as List<dynamic>)
              .map((item) => StateClass.fromJson(item as Map<String, dynamic>))
              .toList();

          StateClass matchedState = states.firstWhere(
            (state) => normalize(state.name) == mapStateName,
            orElse: () => StateClass(id: -1, name: ''),
          );

          bool swapped = false;
          if (matchedState.id == -1 && mapCityName.isNotEmpty) {
            matchedState = states.firstWhere(
              (state) => normalize(state.name) == mapCityName,
              orElse: () => StateClass(id: -1, name: ''),
            );

            if (matchedState.id != -1) {
              swapped = true;
              finalCityName = selectedPlace['state'] ?? '';
            }
          }

          if (matchedState.id != -1) {
            selectedState = matchedState;
            selectedStateName = matchedState.name;
          }
          final parts = [
            if (finalCityName.isNotEmpty) finalCityName,
            if ((selectedStateName ?? '').isNotEmpty) selectedStateName,
            if ((selectedPlace['country'] ?? '').toString().isNotEmpty)
              selectedPlace['country'],
          ];
          cityController.text = finalCityName;
          locationController.text = parts.join(', ');
          isLoading = false;
          notifyListeners();
        }
      } catch (e) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  /// Sets latitude and longitude manually.
  void setLocation(double latitude, double longitude) {
    lat = latitude;
    long = longitude;
    notifyListeners();
  }

  /// Clears stored latitude and longitude.
  void clearLocation() {
    lat = null;
    long = null;
    notifyListeners();
  }

  bool get hasLocation => lat != null && long != null;

  String get locationString {
    if (hasLocation) {
      return '${lat!.toStringAsFixed(6)}, ${long!.toStringAsFixed(6)}';
    }
    return 'No location set';
  }

  Future<void> updateLocationFromAddress() async {
    try {
      if (streetController.text.isEmpty && cityController.text.isEmpty) {
        return;
      }

      String address = '';
      if (streetController.text.isNotEmpty) {
        address += streetController.text;
      }
      if (cityController.text.isNotEmpty) {
        if (address.isNotEmpty) address += ', ';
        address += cityController.text;
      }
      if (selectedState != null) {
        if (address.isNotEmpty) address += ', ';
        address += selectedState!.name;
      }
      if (selectedCountry != null) {
        if (address.isNotEmpty) address += ', ';
        address += selectedCountry!.name;
      }

      if (address.isNotEmpty) {
        List<Location> locations = await locationFromAddress(address);
        if (locations.isNotEmpty) {
          Location location = locations[0];
          setLocation(location.latitude, location.longitude);
        }
      }
    } catch (_) {}
  }

  Future<void> updateAddressFromLocation() async {
    try {
      if (!hasLocation) return;

      List<Placemark> placemarks = await placemarkFromCoordinates(lat!, long!);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        if (streetController.text.isEmpty && place.street != null) {
          streetController.text = place.street!;
        }
        if (cityController.text.isEmpty && place.locality != null) {
          cityController.text = place.locality!;
        }
        if (zipController.text.isEmpty && place.postalCode != null) {
          zipController.text = place.postalCode!;
        }

        String fullAddress = '';
        if (place.street != null && place.street!.isNotEmpty) {
          fullAddress += place.street!;
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          if (fullAddress.isNotEmpty) fullAddress += ', ';
          fullAddress += place.locality!;
        }
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          if (fullAddress.isNotEmpty) fullAddress += ', ';
          fullAddress += place.administrativeArea!;
        }
        if (place.country != null && place.country!.isNotEmpty) {
          if (fullAddress.isNotEmpty) fullAddress += ', ';
          fullAddress += place.country!;
        }

        if (fullAddress.isNotEmpty) {
          locationController.text = fullAddress;
        }

        notifyListeners();
      }
    } catch (_) {}
  }
}
