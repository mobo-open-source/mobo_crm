import 'dart:async';
import 'dart:convert';
import 'package:hugeicons/hugeicons.dart';
import 'dart:io';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/global_methods/dialog%20boxes/loading_dialog.dart';
import 'package:mobo_crm/global_methods/services/global_error_handler.dart';
import 'package:mobo_crm/global_methods/services/isar_caching_service.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/custom_editing_fields.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/global_methods/widgets/buttons/custom_button.dart';
import 'package:mobo_crm/models/models.dart';
import 'package:mobo_crm/models/quotation_model/quotation_model.dart';
import 'package:mobo_crm/screens/quotation/isar/sale_order_models.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_view_provider.dart';
import 'package:mobo_crm/screens/quotation/new_quotation_form.dart';
import 'package:mobo_crm/screens/quotation/provider/quotebuilder_provider.dart';
import 'package:mobo_crm/global_methods/services/global_method.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/company/services/company_session_service.dart';
import '../../../core/company/session/company_session_manager.dart';
import '../../../models/LoginPage/session_model.dart';
import '../../../services/app_install_check.dart';
import '../../../utils/globals.dart';
import '../../../utils/snackbar.dart';
import '../../invoice/invoice_form.dart';

/// Provider class that manages the complete state and business logic for creating,
/// editing, viewing, and processing quotations / sale orders in an Odoo-based CRM/ERP system.
///
/// This provider handles:
/// - Form state (customer, dates, products, taxes, signature, etc.)
/// - Odoo RPC communication (create, update, read, confirm, cancel, invoice, email)
/// - Offline caching support via Isar
/// - Template application
/// - Optional products / sections / notes
/// - PDF/report generation triggers
/// - Email sending & wizard flows
///
/// Most public methods are designed to be called from widgets (forms, buttons, bottom sheets).
class QuotationFormProvider extends ChangeNotifier {
  final CompanySessionService sessionService;

  QuotationFormProvider({required this.sessionService});

  int selectedIndex = 0;
  List partnerdata = [];
  int? selectedpartnerid;

  /// Name of [selectedpartnerid], for when the app's customer list doesn't
  /// hold it — see [selectedCustomerItem].
  String? selectedPartnerName;
  int? selectedTeamId;
  List partnerdetails = [];
  String selectedAction = 'create';
  bool isAbsorbed = false;
  bool isInvoiced = false;
  late SaleOrderData saleOrderDataPdf;
  String? customerError;
  String? quotationDateError;
  String currentStatus = 'draft';
  String quotationName = "New";
  String label = "Quotation";
  bool isOffline = false;
  double totalIncluded = 0.0;
  double totalExcluded = 0.0;
  double totalTaxed = 0.0;
  Map<String, dynamic>? tempIsarData;

  TextEditingController formatDateexpire = TextEditingController();
  TextEditingController formatDateDelivery = TextEditingController();
  TextEditingController formatDateSignature = TextEditingController();
  TextEditingController formatDateQuotation = TextEditingController();
  PaymentTerm? selectedPaymentTermId;
  List<ProductLine> productlinedata = [];
  int? currencycode;
  String? currencySymbol;
  SaleOrderTemplate? selectedTemplate;
  bool isLoading = false;
  Map<String, dynamic> selectedproductlinevalue = {};
  List paymenttemplate = [];
  bool isDropdownOpen = false;
  int? activeDropdownIndex;
  bool _isChanged = false;

  /// Whether the form holds edits that aren't saved yet; it enables the Save
  /// button. Setting it notifies, so the button follows an edit made anywhere
  /// (a tab's own `setState` never reaches the form's bottom bar).
  bool get isChanged => _isChanged;
  set isChanged(bool value) {
    if (_isChanged == value) return;
    _isChanged = value;
    notifyListeners();
  }

  List alltemplateresponse = [];
  List<dynamic> selectedTaxIds = [];
  List<Tax> taxList = [];
  int? countryId;
  int? saleId;
  int? currentopportunityId;
  List<int> producttemplateIdsList = [];
  List optionalProductData = [];
  bool _hasOptionalProductsModel = true;
  Map<int, List<int>> selectedProductDocuments = {};
  List selectedTagIds = [];
  Campaign? selectedcampaignId;
  Medium? selectedMediumId;
  Source? selectedSourceId;
  FiscalPosition? selectedFiscalId;
  AccountJournal? journalId;
  String? jsonData;
  List<int> selectedDocumentids = [];
  AppError? quoteError;
  bool hasError = false;
  String? errorMessage;
  String? taxIdFieldName;
  int? orderpersonValue;
  bool isEdit = false;
  List<int> invoiceIds = [];
  String? orderteamname;
  int? companyid;
  int? opportunityid;
  bool onlineSignature = true;
  bool onlinePayment = true;
  String loadingMessage = "Loading...";
  TextEditingController signedByController = TextEditingController();
  XFile? pickedFile;
  File? image;
  String? imageBase64;
  TextEditingController referenceController = TextEditingController();
  TextEditingController documentController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool isSaleInstalled = false;
  bool isSaleManagementInstalled = false;
  bool isAdmin = false;

  /// Starts a new quotation on a blank sheet, then loads Odoo's defaults
  /// (order date, payment term, the company's default template and its
  /// lines), for both the Quotation menu and an opportunity's "New
  /// Quotation" — the caller sets the customer afterwards.
  ///
  /// This provider is app-wide, so the reset also drops what the previously
  /// opened quotation left behind and the create call would otherwise send
  /// again: its lines, opportunity link, tags, UTM fields, signature and
  /// references. It runs synchronously, before the first await, so the
  /// defaults always land after it — resetting later (from the form) raced
  /// them and blanked the order date the form was still showing.
  Future<void> prepareNewQuotation({
    required OdooClient client,
    required BuildContext context,
    int? currentCountryId,
  }) {
    resetForCreate();
    quotationName = 'New';
    currentopportunityId = null;
    selectedTagIds = [];
    selectedcampaignId = null;
    selectedMediumId = null;
    selectedSourceId = null;
    selectedFiscalId = null;
    journalId = null;
    orderpersonValue = null;
    formatDateDelivery.clear();
    formatDateSignature.clear();
    signedByController.clear();
    referenceController.clear();
    documentController.clear();
    selectedDocumentids = [];
    selectedProductDocuments = {};
    pickedFile = null;
    image = null;
    imageBase64 = null;
    return setDefaultData(
        client: client, context: context, currentCountryId: currentCountryId);
  }

  void resetForCreate() {
    saleId = null;
    quotationName = '';
    selectedpartnerid = null;
    selectedPartnerName = null;
    selectedTemplate = null;
    selectedPaymentTermId = null;

    productlinedata = [];
    optionalProductData = [];
    _hasOptionalProductsModel = true;

    addressController.clear();
    formatDateexpire.clear();
    formatDateQuotation.clear();

    totalExcluded = 0.0;
    totalTaxed = 0.0;
    totalIncluded = 0.0;

    customerError = null;
    quotationDateError = null;

    label = 'Quotation';
    currentStatus = 'draft';
    isChanged = false;
    isEdit = true;
    isAbsorbed = false;

    notifyListeners();
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

  Future<void> checkSaleModuleInstallation(OdooClient client) async {
    try {
      final checker = AppInstallCheck();
      isSaleManagementInstalled =
          await checker.isModuleInstalled('sale_management');
      bool isSaleModuleInstalled = await checker.isModuleInstalled('sale');

      isSaleInstalled = isSaleManagementInstalled || isSaleModuleInstalled;
    } on ModuleAccessDeniedException {
      isSaleInstalled = false;
    } catch (e) {
      // Couldn't tell (expired session, offline) — don't report the module
      // as missing; the next check or data fetch surfaces the real error.
      isSaleInstalled = true;
    }
    notifyListeners();
  }

  /// Safe conversion helpers (null/false/empty handling)
  String? _safeString(dynamic value) {
    if (value == null || value == false) return null;
    if (value is String) return value.isEmpty ? null : value;
    if (value is List && value.length > 1) return value[1]?.toString();
    return value.toString();
  }

  int? _safeInt(dynamic value) {
    if (value == null || value == false) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  double? _safeDouble(dynamic value) {
    if (value == null || value == false) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  bool _safeBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    if (value is int) return value != 0;
    return false;
  }

  int? _safeListInt(dynamic value, int index) {
    if (value is List && value.length > index) {
      return _safeInt(value[index]);
    }
    return null;
  }

  String? _safeListString(dynamic value, int index) {
    if (value is List && value.length > index) {
      return _safeString(value[index]);
    }
    return null;
  }

  List<int> _safeIntList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => _safeInt(item))
          .where((item) => item != null)
          .cast<int>()
          .toList();
    }
    return [];
  }

  FiscalPosition? _createFiscalPosition(dynamic value) {
    if (value is List && value.length >= 2) {
      final id = _safeInt(value[0]);
      final name = _safeString(value[1]);
      if (id != null && name != null) {
        return FiscalPosition(id: id, name: name);
      }
    }
    return null;
  }

  AccountJournal? _createAccountJournal(dynamic value) {
    if (value is List && value.length >= 2) {
      final id = _safeInt(value[0]);
      final name = _safeString(value[1]);
      if (id != null && name != null) {
        return AccountJournal(id: id, name: name);
      }
    }
    return null;
  }

  Campaign? _createCampaign(dynamic value) {
    if (value is List && value.length >= 2) {
      final id = _safeInt(value[0]);
      final name = _safeString(value[1]);
      if (id != null && name != null) {
        return Campaign(id: id, name: name);
      }
    }
    return null;
  }

  Medium? _createMedium(dynamic value) {
    if (value is List && value.length >= 2) {
      final id = _safeInt(value[0]);
      final name = _safeString(value[1]);
      if (id != null && name != null) {
        return Medium(id: id, name: name);
      }
    }
    return null;
  }

  Source? _createSource(dynamic value) {
    if (value is List && value.length >= 2) {
      final id = _safeInt(value[0]);
      final name = _safeString(value[1]);
      if (id != null && name != null) {
        return Source(id: id, name: name);
      }
    }
    return null;
  }

  SaleOrderTemplate? _createSaleOrderTemplate(dynamic value) {
    if (value is List && value.length >= 2) {
      final id = _safeInt(value[0]);
      final name = _safeString(value[1]);
      if (id != null && name != null) {
        return SaleOrderTemplate(mailTemplateId: [], id: id, name: name);
      }
    }
    return null;
  }

  PaymentTerm? _createPaymentTerm(dynamic value) {
    if (value is List && value.length >= 2) {
      final id = _safeInt(value[0]);
      final name = _safeString(value[1]);
      if (id != null && name != null) {
        return PaymentTerm(id: id, name: name);
      }
    }
    return null;
  }

  String? _getProductName(Map<String, dynamic> line) {
    try {
      if (_safeBool(line['is_downpayment']) == false &&
          line['product_id'] != false) {
        return _safeListString(line['product_id'], 1);
      }
      return _safeString(line['name']);
    } catch (e) {
      return _safeString(line['name']) ?? 'Unknown Product';
    }
  }

  /// Clears almost all form-related state variables to prepare for a new quotation
  void clearAll() {
    currentStatus = 'draft';
    quotationName = "New";
    label = "Quotation";
    formatDateexpire.clear();
    formatDateQuotation.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    formatDateDelivery.text = '';
    formatDateSignature.text = '';
    selectedPaymentTermId = null;
    productlinedata.clear();
    currencycode = null;
    currencySymbol = null;
    isLoading = false;
    selectedproductlinevalue.clear();
    paymenttemplate.clear();
    isDropdownOpen = false;
    activeDropdownIndex = null;
    alltemplateresponse.clear();
    selectedTaxIds.clear();
    taxList.clear();
    countryId = null;
    saleId = null;
    currentopportunityId = null;
    producttemplateIdsList.clear();
    optionalProductData.clear();
    _hasOptionalProductsModel = true;
    selectedProductDocuments.clear();
    selectedTemplate = null;
    selectedTagIds.clear();
    selectedcampaignId = null;
    selectedMediumId = null;
    selectedSourceId = null;
    selectedFiscalId = null;
    journalId = null;
    jsonData = null;
    selectedDocumentids.clear();
    isLoading = true;
    errorMessage = null;
    orderpersonValue = null;
    invoiceIds.clear();
    orderteamname = null;
    companyid = null;
    opportunityid = null;
    onlineSignature = true;
    onlinePayment = true;
    loadingMessage = "Loading...";
    signedByController.clear();
    referenceController.clear();
    documentController.clear();
    pickedFile = null;
    image = null;
    imageBase64 = null;
    notifyListeners();
  }

  Future<bool> validateQuotationExists(
      int quotationId, OdooClient client) async {
    try {
      final searchResult = await CompanySessionManager.callKwWithCompany({
        'model': 'sale.order',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', quotationId]
          ]
        ],
        'kwargs': {
          'fields': ['id', 'name', 'state', 'partner_id'],
          'limit': 1,
        },
      });

      if (searchResult is List && searchResult.isNotEmpty) {
        return true;
      }

      // The check above scopes to the app's currently-selected company,
      // which can briefly lag the real value right after login while
      // CompanyProvider is still resolving the user's companies. Before
      // concluding the record was deleted, re-check without that scoping
      // (Odoo's own record rules still apply, so this can't reveal a
      // record the user isn't otherwise allowed to see).
      final countResult = await CompanySessionManager.safeCallKwWithoutCompany({
        'model': 'sale.order',
        'method': 'search_count',
        'args': [
          [
            ['id', '=', quotationId]
          ]
        ],
        'kwargs': {},
      });

      final exists = countResult > 0;
      return exists;
    } catch (e) {
      return true;
    }
  }

  /// Resets error/loading flags
  void clearVariables() {
    hasError = false;
    errorMessage = null;
    quoteError = null;
    isLoading = false;
  }

  @override
  void dispose() {
    signedByController.dispose();
    referenceController.dispose();
    documentController.dispose();
    _optionalSyncTimer?.cancel();
    clearVariables();
    super.dispose();
  }

  /// Picks the payment term; null clears it.
  void setPaymenttermId(PaymentTerm? payment) {
    selectedPaymentTermId = payment;
    notifyListeners();
  }

  void changeToEdit() {
    isEdit = true;
    isChanged = false;
    isAbsorbed = false;
    notifyListeners();
  }

  /// Applies the picked template's lines. Like any other edit, it is saved
  /// with the quotation rather than on its own.
  Future<void> setTemplateId(int id, OdooClient client, SessionModel session,
      BuildContext context, SaleOrderTemplate temp) async {
    await gettemplatedata(client, session, id, context, temp);
    isChanged = true;
    notifyListeners();
  }

  /// Unlinks the template; the lines it added stay, as in Odoo.
  void clearTemplate() {
    selectedTemplate = null;
    isChanged = true;
    notifyListeners();
  }

  void indexSelection(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void updateSectionText(int index, String newText) {
    productlinedata[index] = productlinedata[index].copyWith(product: newText);
    isChanged = true;
    notifyListeners();
  }

  void setupState() {
    switch (currentStatus) {
      case 'draft':
        label = "Quotation";

        break;
      case 'sent':
        label = "Quotation Sent";

        break;
      case 'sale':
        label = "Sale Order";

        break;
      case 'cancel':
        label = "Cancelled";

        break;
      default:
        label = "Quotation";
        break;
    }
    notifyListeners();
  }


  /// Adds [product] as a new order line (qty 1, list price incl. variant
  /// extras), pulling its sales description and company taxes like the old
  /// line sheet did on selection.
  Future<void> addProductLineFromProduct(
      dynamic product, OdooClient client, SessionModel session) async {
    String description = product['name'] ?? '';
    List<int> taxIds = [];
    try {
      if (taxList.isEmpty) taxList = await fetchTaxes(client, session);
      final template = await CompanySessionManager.callKwWithCompany({
        'model': 'product.template',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', product['product_tmpl_id'][0]],
          ]
        ],
        'kwargs': {
          'fields': ['description_sale', 'taxes_id'],
        },
      });
      if (template is List && template.isNotEmpty) {
        if (template[0]['description_sale'] != false) {
          description = template[0]['description_sale'];
        }
        if (template[0]['taxes_id'] != false) {
          taxIds = List<int>.from(template[0]['taxes_id'])
              .where((id) =>
                  isTaxBelongsToCompany(id, session.companyId!, taxList))
              .toList();
        }
      }
    } catch (_) {}

    final unitPrice = _productTotalPrice(product);
    productlinedata.add(ProductLine(
      taxIds: taxIds,
      description: description,
      id: product['id'],
      product: product['name'],
      quantity: 1.0,
      unitPrice: unitPrice,
      amount: unitPrice,
    ));
    isChanged = true;
    notifyListeners();
  }

  /// Edits a line in place from the inline line card.
  void updateProductLine(int index,
      {double? quantity, double? unitPrice, List<int>? taxIds}) {
    final line = productlinedata[index];
    final qty = quantity ?? line.quantity ?? 0.0;
    final price = unitPrice ?? line.unitPrice ?? 0.0;
    productlinedata[index] = ProductLine(
      taxIds: taxIds ?? line.taxIds,
      orderlineId: line.orderlineId,
      description: line.description,
      id: line.id,
      product: line.product,
      quantity: qty,
      unitPrice: price,
      amount: qty * price,
      discount: line.discount,
      type: line.type,
      isDownPayment: line.isDownPayment,
      productDocumentIds: line.productDocumentIds,
    );
    isChanged = true;
    notifyListeners();
  }

  Future<void>? _taxLoad;

  /// Loads [taxList] once for the inline line cards' tax pickers.
  Future<void> ensureTaxList(OdooClient client, SessionModel session) {
    if (taxList.isNotEmpty) return Future.value();
    return _taxLoad ??= () async {
      try {
        taxList = await fetchTaxes(client, session);
        notifyListeners();
      } catch (_) {
      } finally {
        _taxLoad = null;
      }
    }();
  }

  void removeProductLine(int index) {
    productlinedata.removeAt(index);
    isChanged = true;
    notifyListeners();
  }

  Timer? _optionalSyncTimer;

  /// Pushes optional products to a saved quotation. [debounce] batches the
  /// per-keystroke edits from the inline cards into one call.
  void _syncOptionalProducts(OdooClient client, {bool debounce = false}) {
    _optionalSyncTimer?.cancel();
    if (saleId == null) return;
    void push() {
      _hasOptionalProductsModel = true;
      addOptionalProducts(client, saleId!);
    }

    if (debounce) {
      _optionalSyncTimer = Timer(const Duration(milliseconds: 800), push);
    } else {
      push();
    }
  }

  /// Adds [product] as an optional product (qty 1, list price incl. variant
  /// extras) with its sales description, like the old optional sheet did.
  Future<void> addOptionalProductFromProduct(
      dynamic product, OdooClient client) async {
    String description = product['name'] ?? '';
    try {
      final template = await CompanySessionManager.callKwWithCompany({
        'model': 'product.template',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', product['product_tmpl_id'][0]],
          ]
        ],
        'kwargs': {
          'fields': ['description_sale'],
        },
      });
      if (template is List &&
          template.isNotEmpty &&
          template[0]['description_sale'] != false) {
        description = template[0]['description_sale'];
      }
    } catch (_) {}

    optionalProductData.add({
      'id': product['id'],
      'product_id': product['id'],
      'product_name': product['name'],
      'quantity': 1.0,
      'price': _productTotalPrice(product),
      'description': description,
      'taxes': <int>[],
    });
    notifyListeners();
    _syncOptionalProducts(client);
  }

  /// Edits an optional product in place from its inline card.
  void updateOptionalProduct(int index, OdooClient client,
      {double? quantity, double? price}) {
    final item = Map<String, dynamic>.from(optionalProductData[index]);
    if (quantity != null) item['quantity'] = quantity;
    if (price != null) item['price'] = price;
    optionalProductData[index] = item;
    notifyListeners();
    _syncOptionalProducts(client, debounce: true);
  }

  void removeOptionalProduct(int index, OdooClient client) {
    optionalProductData.removeAt(index);
    notifyListeners();
    _syncOptionalProducts(client);
  }

  void addOptionalProductsToMain({
    required String productName,
    required int id,
    required double quantity,
    required double unitPrice,
  }) {
    bool isAlreadyAdded = productlinedata.any((line) => line.id == id);

    if (!isAlreadyAdded) {
      productlinedata.add(ProductLine(
        description: productName,
        id: id,
        product: productName,
        quantity: quantity,
        unitPrice: unitPrice,
        amount: quantity * unitPrice,
        taxIds: [],
      ));
    }

    isChanged = true;
    notifyListeners();
  }

  bool isIdPresentInEither(int id) {
    final inProductLines = productlinedata.any((line) => line.id == id);
    final inOptionalProducts =
        optionalProductData.any((item) => item['id'] == id);

    final result = inProductLines || inOptionalProducts;
    return result;
  }

  /// Opens bottom sheet to add/edit section or note line
  Future<void> showEditSectionBottomSheet(String type, int? index,
      bool isAlreadyCreated, BuildContext context) async {
    late TextEditingController nameController;
    int? orderlineId;
    if (isAlreadyCreated) {
      final existingProduct = productlinedata[index!];
      orderlineId = existingProduct.orderlineId;

      nameController = TextEditingController(
          text: existingProduct.product ?? "Untitled Section");
    } else {
      nameController = TextEditingController();
    }

    if (context.mounted) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      showModalBottomSheet(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Edit Section / Note",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type == 'line_section' ? "Section" : "Note",
                      style: TextStyle(
                          color: isDark ? Colors.white60 : Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      maxLines: type == 'line_section' ? 1 : 3,
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: type == 'line_section'
                            ? "Add Section Name"
                            : "Add Note",
                        floatingLabelStyle: const TextStyle(color: Colors.grey),
                        labelStyle: const TextStyle(color: Colors.grey),
                        fillColor: isDark ? Colors.grey[850] : const Color(0xFFF2F4F6),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (isAlreadyCreated) ...[
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppStyle.primaryColor,
                            side: BorderSide(
                              color: AppStyle.primaryColor,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            productlinedata.removeAt(index!);
                            isChanged = true;
                            notifyListeners();
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: AppStyle.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppStyle.primaryColor,
                            side: BorderSide(
                              color: AppStyle.primaryColor,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppStyle.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (isAlreadyCreated) {
                            productlinedata[index!] =
                                productlinedata[index].copyWith(
                              product: nameController.text,
                              type: type,
                              description: nameController.text,
                              orderlineId: orderlineId,
                            );
                          } else {
                            productlinedata.add(ProductLine(
                              description: null,
                              id: null,
                              quantity: null,
                              unitPrice: null,
                              amount: null,
                              taxIds: [],
                              product: nameController.text,
                              type: type,
                              orderlineId: null,
                            ));
                          }
                          isChanged = true;
                          notifyListeners();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isAlreadyCreated ? "Update" : "Save",
                          style: TextStyle(
                            color: Colors.white,
                              fontWeight: FontWeight.bold, fontSize: 16
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    }
  }

  Future<void> showQuotationDialog(BuildContext context, OdooClient client,
      int leadId, SessionModel session) {
    int? selectedPartnerId;

    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final odoomanagerprovider =
            Provider.of<OdooClientManager>(context, listen: false);
        final allcustomer = odoomanagerprovider.customerItems;
        final formKey = GlobalKey<FormState>();
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Select Customer Action",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isDark ? Colors.white : const Color(0xFF101010),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Choose how to link a customer to this quotation.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey[400] : const Color(0xFF666666),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ToggleButtons(
                        isSelected: [
                          selectedAction == "create",
                          selectedAction == "exist",
                          selectedAction == "nothing"
                        ],
                        onPressed: (index) {
                          setState(() {
                            selectedAction =
                                ["create", "exist", "nothing"][index];
                            if (selectedAction == "nothing") {
                              selectedPartnerId = null;
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        selectedColor: Colors.white,
                        fillColor: const Color(0xFFC03355),
                        color: isDark ? Colors.white70 : const Color(0xFF101010),
                        borderColor: isDark ? Colors.grey[700] : const Color(0xFFE0E0E0),
                        selectedBorderColor: const Color(0xFFC03355),
                        constraints: const BoxConstraints(
                          minHeight: 40,
                          minWidth: 90,
                        ),
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "New Customer",
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Existing",
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "None",
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      if (selectedAction == "exist") ...[
                        const SizedBox(height: 16),
                        CustomDropdown.search(
                          validateOnChange: true,
                          validator: (value) =>
                              value == null ? "Please select a customer" : null,
                          hintBuilder: (context, hint, enabled) {
                            return Text(
                              "Select A Customer",
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : const Color(0xFF666666)),
                            );
                          },
                          items: allcustomer,
                          listItemBuilder:
                              (context, item, isSelected, onItemSelect) {
                            return GestureDetector(
                              onTap: onItemSelect,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(
                                  children: [
                                    Text(item.name),
                                    const Spacer(),
                                    if (isSelected)
                                      const Icon(Icons.check,
                                          color: Color(0xFFC03355), size: 18),
                                  ],
                                ),
                              ),
                            );
                          },
                          onChanged: (values) {
                            setState(() {
                              selectedPartnerId = values!.id;
                            });
                          },
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFC03355),
                                  side: const BorderSide(
                                    color: Color(0xFFC03355),
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                ),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    if (formKey.currentState!.validate()) {
                                      bool success =
                                          await createQuotationPartner(
                                              client,
                                              leadId,
                                              selectedAction,
                                              selectedPartnerId,
                                              context,
                                              session);

                                      if (success) {
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              SlidingPageTransitionRL(
                                                  page: NewQuotationForm(
                                                leadid: leadId,
                                              )));
                                        }
                                      } else {
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                        throw Exception(
                                            "unexpected error occured");
                                      }
                                    }
                                  } catch (_) {}
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC03355),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                ),
                                child: const Text(
                                  "Apply",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Opens dialog to choose invoice type (regular / down payment % / fixed)
  /// and creates invoice via sale.advance.payment.inv wizard
  Future<int?> createInvoiceDialog(
      BuildContext context, OdooClient client, SessionModel session) async {
    return showDialog<int?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        final formKey = GlobalKey<FormState>();
        String? invoiceAction = "delivered";
        final TextEditingController amountController = TextEditingController();
        final TextEditingController fixedAmountController =
            TextEditingController();
        bool _isSubmitting = false;

        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return Dialog(
              backgroundColor:
                  isDark ? const Color(0xFF1E1E1E) : AppColors().fillColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                constraints: BoxConstraints(
                    maxHeight:
                        MediaQuery.of(dialogContext).size.height * 0.80),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 24),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Create Invoice",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(dialogContext, null),
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.close,
                                size: 22,
                                color: isDark ? Colors.white60 : Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Select the type of invoice you want to create",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors().subHeading.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInvoiceOption(
                                context: context,
                                title: "Regular Invoice",
                                value: "delivered",
                                groupValue: invoiceAction,
                                onChanged: (value) {
                                  setState(() {
                                    invoiceAction = value;
                                    amountController.clear();
                                    fixedAmountController.clear();
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildInvoiceOption(
                                context: context,
                                title: "Down Payment (Percentage)",
                                value: "percentage",
                                groupValue: invoiceAction,
                                onChanged: (value) {
                                  setState(() {
                                    invoiceAction = value;
                                    fixedAmountController.clear();
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildInvoiceOption(
                                context: context,
                                title: "Down Payment (Fixed)",
                                value: "fixed",
                                groupValue: invoiceAction,
                                onChanged: (value) {
                                  setState(() {
                                    invoiceAction = value;
                                    amountController.clear();
                                  });
                                },
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: _buildInputFields(
                                  invoiceAction: invoiceAction,
                                  amountController: amountController,
                                  fixedAmountController: fixedAmountController,
                                  isDark: isDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: CustomButton(
                          text: "Create Invoice",
                          borderRadius: 8,
                          height: 48,
                          fontSize: 16,
                          isLoading: _isSubmitting,
                          onPressed: () async {
                                  if (_isSubmitting) return;
                                  if (formKey.currentState!.validate()) {
                                    double orderTotal = 0.0;
                                    try {
                                      final odoomanagerprovider =
                                          Provider.of<OdooClientManager>(
                                              dialogContext,
                                              listen: false);
                                      final totals =
                                          await calculateQuotationTotals(
                                              odoomanagerprovider.client!);
                                      orderTotal = totals['total'] ?? 0.0;
                                    } catch (_) {
                                      orderTotal = 0.0;
                                    }
                                    double? downPayment;
                                    bool isDownPayment = false;
                                    if (invoiceAction == 'percentage' &&
                                        amountController.text.isNotEmpty) {
                                      final percent = double.tryParse(
                                          amountController.text
                                              .replaceAll('%', '')
                                              .trim());
                                      if (percent != null) {
                                        downPayment =
                                            orderTotal * percent / 100.0;
                                        isDownPayment = true;
                                      }
                                    } else if (invoiceAction == 'fixed' &&
                                        fixedAmountController.text.isNotEmpty) {
                                      downPayment = double.tryParse(
                                          fixedAmountController.text);
                                      isDownPayment = true;
                                    }

                                    if (isDownPayment &&
                                        downPayment != null &&
                                        downPayment > orderTotal) {
                                      showDialog(
                                        context: dialogContext,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: isDark
                                              ? const Color(0xFF1E1E1E)
                                              : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          title: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 72,
                                                height: 72,
                                                decoration: BoxDecoration(
                                                  color: AppStyle.primaryColor
                                                      .withOpacity(0.08),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Center(
                                                  child: HugeIcon(
                                                    icon: HugeIcons
                                                        .strokeRoundedAlert02,
                                                    color:
                                                        AppStyle.primaryColor,
                                                    size: 36,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                'Invalid Down Payment',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: isDark
                                                    ? Colors.white70
                                                    : Colors.black87,
                                              ),
                                              children: [
                                                const TextSpan(
                                                    text:
                                                        'The down payment amount '),
                                                TextSpan(
                                                  text:
                                                      '(${currencySymbol ?? '\$'}${downPayment?.toStringAsFixed(2)})',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const TextSpan(
                                                    text:
                                                        ' exceeds the order total '),
                                                TextSpan(
                                                  text:
                                                      '(${currencySymbol ?? '\$'}${orderTotal.toStringAsFixed(2)})',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const TextSpan(text: '.'),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            Builder(builder: (context) {
                                              final screenWidth = MediaQuery.of(context).size.width;
                                              final btnHeight = screenWidth < 360 ? 42.0 : 48.0;
                                              return Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 0, 8, 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: btnHeight,
                                                      child: OutlinedButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              AppStyle
                                                                  .primaryColor,
                                                          backgroundColor: isDark
                                                              ? const Color(
                                                                  0xFF1E1E1E)
                                                              : Colors.white,
                                                          side: BorderSide(
                                                              color: AppStyle
                                                                  .primaryColor,
                                                              width: 1.5),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                        ),
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            'Close',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: AppStyle
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: btnHeight,
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          setState(() => _isSubmitting = true);
                                                          try {
                                                            await _continueWithInvoiceCreation(
                                                              context,
                                                              dialogContext,
                                                              setState,
                                                              formKey,
                                                              invoiceAction,
                                                              amountController,
                                                              fixedAmountController,
                                                              client,
                                                              session,
                                                            );
                                                          } finally {
                                                            if (dialogContext.mounted) {
                                                              setState(() => _isSubmitting = false);
                                                            }
                                                          }
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              AppStyle
                                                                  .primaryColor,
                                                          foregroundColor:
                                                              Colors.white,
                                                          elevation: 0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                        ),
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: const Text(
                                                            'Continue',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                            }),
                                          ],
                                        ),
                                      );
                                      return;
                                    }
                                    setState(() => _isSubmitting = true);
                                    try {
                                      await _continueWithInvoiceCreation(
                                        context,
                                        dialogContext,
                                        setState,
                                        formKey,
                                        invoiceAction,
                                        amountController,
                                        fixedAmountController,
                                        client,
                                        session,
                                      );
                                    } finally {
                                      if (dialogContext.mounted) {
                                        setState(() => _isSubmitting = false);
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInvoiceOption({
    required BuildContext context,
    required String title,
    required String value,
    required String? groupValue,
    required Function(String?) onChanged,
  }) {
    final isSelected = groupValue == value;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey.shade200,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isDark ? Colors.grey[850] : Colors.white,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              fillColor: WidgetStatePropertyAll(
                isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade400,
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields({
    required String? invoiceAction,
    required TextEditingController amountController,
    required TextEditingController fixedAmountController,
    bool isDark = false,
  }) {
    if (invoiceAction == 'percentage') {
      return Column(
        key: const ValueKey('percentage'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          RichText(
            text: TextSpan(
              text: "Percentage %",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: isDark ? Colors.white : Colors.black,
              ),
              children: [
                TextSpan(
                  text: " *",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_PercentageSuffixFormatter()],
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  validator: (value) {
                    final numStr =
                        (value ?? '').replaceAll('%', '').trim();
                    if (numStr.isEmpty) {
                      return 'Please enter a percentage';
                    }
                    final parsed = double.tryParse(numStr);
                    if (parsed == null) return 'Enter a valid number';
                    if (parsed <= 0 || parsed > 100) {
                      return 'Enter a value between 0 and 100';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    errorStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      height: 1.2,
                    ),
                    hintText: "0",
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontStyle: FontStyle.italic,
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                    prefix: const SizedBox(width: 14),
                    contentPadding: const EdgeInsets.fromLTRB(0, 14, 14, 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide:
                          BorderSide(color: Color(0xFFC03355), width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1),
                    ),
                  ),
                ),
        ],
      );
    } else if (invoiceAction == 'fixed') {
      return Column(
        key: const ValueKey('fixed'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          RichText(
            text: TextSpan(
              text: "Fixed Amount",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: isDark ? Colors.white : Colors.black,
              ),
              children: [
                TextSpan(
                  text: " *",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: fixedAmountController,
            keyboardType: TextInputType.number,
            cursorColor: const Color(0xFFC03355),
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a fixed amount';
              }
              final parsed = double.tryParse(value);
              if (parsed == null) return 'Enter a valid number';
              if (parsed <= 0) return 'Amount must be greater than 0';
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
              errorStyle: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                height: 1.2,
              ),
              hintText: "Enter fixed amount",
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.grey[400],
                fontStyle: FontStyle.italic,
              ),
              prefix: const SizedBox(width: 14),
              contentPadding: const EdgeInsets.fromLTRB(0, 14, 14, 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xFFC03355), width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink(key: ValueKey('none'));
  }

  void toggleAttachmentSelection(int attachmentId) {
    if (selectedDocumentids.contains(attachmentId)) {
      selectedDocumentids.remove(attachmentId);
    } else {
      selectedDocumentids.add(attachmentId);
    }
    notifyListeners();
  }

  void toggleProductSelection(
      int orderLineId, int productDocId, List<ProductLine> productLines) {
    if (!selectedProductDocuments.containsKey(orderLineId)) {
      selectedProductDocuments[orderLineId] = [productDocId];
    } else {
      if (selectedProductDocuments[orderLineId]!.contains(productDocId)) {
        selectedProductDocuments[orderLineId]!.remove(productDocId);

        if (selectedProductDocuments[orderLineId]!.isEmpty) {
          selectedProductDocuments.remove(orderLineId);
        }
      } else {
        selectedProductDocuments[orderLineId]!.add(productDocId);
      }
    }

    int index = productLines.indexWhere((line) => line.id == orderLineId);
    if (index != -1) {
      productLines[index] = productLines[index].copyWith(
        productDocumentIds:
            List<int>.from(selectedProductDocuments[orderLineId] ?? []),
      );
    }

    notifyListeners();
  }

  Future<List<dynamic>> fetchProductDocuments(
      OdooClient client, List<int> productIds) async {
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'ir.attachment',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['res_model', '=', 'product.template'],
            ['res_id', 'in', productIds]
          ],
          'fields': ['id', 'name', 'mimetype', 'res_model', 'res_id', 'type'],
        },
      });

      return response;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> fetchOptionalProductsWithDetails(
      OdooClient client, int id) async {
    try {
      final optionalProducts = await CompanySessionManager.callKwWithCompany({
        'model': 'sale.order.template.option',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['sale_order_template_id', '=', id]
          ],
          'fields': ['product_id', 'quantity'],
        },
      });

      final productIds = optionalProducts
          .where((item) => item['product_id'] != null)
          .map<int>((item) => item['product_id'][0] as int)
          .toList();

      if (productIds.isEmpty) {
        return [];
      }

      final productDetails = await CompanySessionManager.callKwWithCompany({
        'model': 'product.product',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['id', 'in', productIds]
          ],
          'fields': [
            'id',
            'name',
            'list_price',
            'default_code',
            'product_tmpl_id'
          ],
        },
      });

      final productTemplateIds = productDetails
          .where((product) => product['product_tmpl_id'] != null)
          .map<int>((product) => product['product_tmpl_id'][0] as int)
          .toList();

      final productTaxResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'product.template',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['id', 'in', productTemplateIds]
          ],
          'fields': ['id', 'description_sale', 'taxes_id'],
        },
      });

      final productDescriptionsMap = {
        for (var item in productTaxResponse)
          item['id']: {
            'description': item['description_sale'],
            'taxes': (item['taxes_id'] as List<dynamic>?)
                    ?.map((id) => id as int)
                    .toList() ??
                []
          }
      };

      final productMap = {
        for (var product in productDetails) product['id']: product
      };

      final mergedData = optionalProducts.map((option) {
        final product = productMap[option['product_id'][0]];
        final productTmplIdField = product?['product_tmpl_id'] ?? false;
        final productTemplateId =
            (productTmplIdField is List && productTmplIdField.isNotEmpty)
                ? productTmplIdField[0]
                : null;
        final descriptionData = productDescriptionsMap[productTemplateId] ?? {};

        final merged = {
          'id': option['id'],
          'product_id': product?['id'],
          'product_name': product?['name'],
          'quantity': option['quantity'],
          'price': product?['list_price'],
          'description': descriptionData['description'] != false
              ? descriptionData['description']
              : product?['name'],
          'taxes': descriptionData['taxes'],
        };

        return merged;
      }).toList();

      optionalProductData = mergedData;
      notifyListeners();

      return mergedData;
    } catch (e) {
      return [];
    }
  }

  /// The picked customer as an item for the Customer dropdown.
  ///
  /// The customer list is loaded once per session, so it misses customers
  /// made since — e.g. the one a lead conversion creates. Looking one up
  /// without a fallback threw while building and left a blank screen; it
  /// falls back to the customer's own name instead.
  CustomerItem? selectedCustomerItem(List<CustomerItem> items) {
    final id = selectedpartnerid;
    if (id == null) return null;
    for (final item in items) {
      if (item.id == id) return item;
    }
    final name = selectedPartnerName ?? 'Unknown';
    return CustomerItem(id: id, name: name, fullname: name, email: '');
  }

  /// Links the quotation to an opportunity, or unlinks it on `null`. Saved
  /// with the quotation like any other edit; the Opportunity picker on the
  /// form and the one under Other Info both read [currentopportunityId].
  void setOpportunityId(int? id) {
    currentopportunityId = id;
    // isChanged only notifies on a false → true flip, and the two pickers
    // have to follow each other on every pick.
    isChanged = true;
    notifyListeners();
  }

  /// Sets selected partner and loads address
  Future<void> setpartnerid(int id, OdooClient client) async {
    selectedpartnerid = id;

    try {
      final partnerDetailsResponse =
          await CompanySessionManager.callKwWithCompany({
        'model': 'res.partner',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', selectedpartnerid],
          ]
        ],
        'kwargs': {
          'fields': [
            'name',
            'street',
            'vat',
            'city',
            'state_id',
            'zip',
            'country_id'
          ],
        },
      });

      if (partnerDetailsResponse == null || partnerDetailsResponse.isEmpty) {
        throw Exception("Partner details are missing or invalid.");
      }

      final updatedList = partnerDetailsResponse.map((item) {
        return item.map((key, value) {
          return MapEntry(key, value == false ? null : value);
        });
      }).toList();

      partnerdetails = updatedList;

      final partnerDetails = updatedList.first;
      if (selectedpartnerid == id && partnerDetails['name'] is String) {
        selectedPartnerName = partnerDetails['name'];
      }
      String street = partnerDetails['street'] ?? "";
      String city = partnerDetails['city'] ?? "";
      String state = (partnerDetails['state_id'] is List &&
              partnerDetails['state_id'].length > 1)
          ? partnerDetails['state_id'][1] ?? ""
          : "";
      String zip = partnerDetails['zip'] ?? "";
      String country = (partnerDetails['country_id'] is List &&
              partnerDetails['country_id'].length > 1)
          ? partnerDetails['country_id'][1] ?? ""
          : "";

      List<String> addressParts = [street, city, state, zip, country]
          .where((element) => element.trim().isNotEmpty)
          .toList();

      String fullAddress;

      if (addressParts.isEmpty) {
        fullAddress = "No Address Available";
      } else {
        fullAddress = addressParts.join(", ");
      }

      addressController.text = fullAddress;
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> fetchSaleAndPartnerData(OdooClient client, SessionModel session,
      int leadid, bool path, BuildContext context) async {
    isLoading = true;
    selectedpartnerid = null;
    selectedPartnerName = null;

    jsonData = null;
    currentopportunityId = leadid;
    currentStatus = 'draft';
    quotationName = "New";

    try {
      final partnerResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'search_read',
        'args': [
          [
            ['type', '=', 'opportunity'],
            [
              "active",
              "=",
              [true, false]
            ],
            ['id', '=', leadid],
          ]
        ],
        'kwargs': {
          'fields': ['partner_id'],
        },
      });

      if (partnerResponse == null || partnerResponse.isEmpty) {
        throw Exception("Partner data is missing or invalid from the server.");
      }

      partnerdata = partnerResponse;
      if (selectedAction != "nothing") {
        if (!path) {
          selectedpartnerid = partnerdata[0]['partner_id'][0];
          selectedPartnerName =
              _safeListString(partnerdata[0]['partner_id'], 1);
          await setpartnerid(selectedpartnerid!, client);
          notifyListeners();
          return true;
        }
      } else {
        selectedpartnerid = null;
      }
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Tax>> fetchTaxes(
    OdooClient client,
    SessionModel session,
  ) async {
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'account.tax',
        'method': 'search_read',
        'args': [
          [
            '&',
            '&',
            ['type_tax_use', '=', 'sale'],
            ['company_id', 'parent_of', client.sessionId!.companyId],
            ['country_id', '=', countryId]
          ]
        ],
        'kwargs': {
          'fields': [
            'id',
            'name',
            'amount',
            'type_tax_use',
            'amount_type',
            'active',
          ],
        },
      });

      return response.map<Tax>((map) => Tax.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Loads and applies sale order template lines + optional products
  Future<void> gettemplatedata(
    OdooClient client,
    SessionModel session,
    int id,
    BuildContext context,
    SaleOrderTemplate template,
  ) async {
    try {
      final saleOrderTemplateLines =
          await CompanySessionManager.callKwWithCompany({
        'model': 'sale.order.template.line',
        'method': 'search_read',
        'args': [
          [
            ['sale_order_template_id', '=', id]
          ]
        ],
        'kwargs': {
          'fields': [
            'product_id',
            'product_uom_qty',
            'display_type',
            'name',
          ]
        }
      });

      final productIds = saleOrderTemplateLines
          .where((line) =>
              line['product_id'] != null && line['product_id'] != false)
          .map((line) => line['product_id'][0] as int)
          .toList();

      List<dynamic> templateproductsresponse = [];
      Map<int, dynamic> productDescriptionsMap = {};
      if (productIds.isNotEmpty) {
        templateproductsresponse =
            await CompanySessionManager.callKwWithCompany({
          'model': 'product.product',
          'method': 'search_read',
          'args': [],
          'kwargs': {
            'domain': [
              ['id', 'in', productIds]
            ],
            'fields': [
              'name',
              'list_price',
              'uom_id',
              'default_code',
              'product_tmpl_id'
            ],
            'context': {
              'partner_id': selectedpartnerid,
              'company_id': session.companyId,
            },
          },
        });

        final productTemplateIds = templateproductsresponse
            .map<int>((product) => product['product_tmpl_id'][0] as int)
            .toList();

        producttemplateIdsList = productTemplateIds;

        notifyListeners();

        final productTaxResponse =
            await CompanySessionManager.callKwWithCompany({
          'model': 'product.template',
          'method': 'search_read',
          'args': [],
          'kwargs': {
            'domain': [
              ['id', 'in', productTemplateIds],
            ],
            'fields': [
              'id',
              'description_sale',
              'taxes_id',
            ],
          },
        });

        List<Tax> taxesList = await fetchTaxes(client, session);
        productDescriptionsMap = {
          for (var item in productTaxResponse)
            item['id']: {
              'description': item['description_sale'],
              'taxes': (item['taxes_id'] as List<dynamic>?)
                      ?.where((id) => isTaxBelongsToCompany(
                          id as int, session.companyId!, taxesList))
                      .map((id) => id as int)
                      .toList() ??
                  []
            }
        };
      }

      List<ProductLine> productLineDataraw = saleOrderTemplateLines
          .map<ProductLine?>((orderLine) {
            final productId = orderLine['product_id'];
            final displayType = orderLine['display_type'];
            final name = orderLine['name'];

            if (productId != null &&
                productId != false &&
                (displayType == null || displayType == false)) {
              final product = templateproductsresponse.firstWhere(
                (product) => product['id'] == productId[0],
                orElse: () {
                  return null;
                },
              );

              if (product != null) {
                final productTemplateId = product['product_tmpl_id'][0];
                final descriptionData =
                    productDescriptionsMap[productTemplateId] ?? {};
                final description =
                    descriptionData['description'] ?? product['name'];
                final taxIds = descriptionData['taxes'] ?? [];

                return ProductLine(
                  description: (description != false && description != null)
                      ? description
                      : product['name'],
                  id: product['id'],
                  product: product['name'],
                  quantity:
                      (orderLine['product_uom_qty'] as num?)?.toDouble() ?? 0.0,
                  unitPrice: (product['list_price'] as num?)?.toDouble() ?? 0.0,
                  amount: ((orderLine['product_uom_qty'] as num?)?.toDouble() ??
                          0.0) *
                      ((product['list_price'] as num?)?.toDouble() ?? 0.0),
                  taxIds: taxIds,
                  type: null,
                );
              } else {
                return null;
              }
            } else if (displayType != null && displayType != false) {
              return ProductLine(
                description: null,
                id: null,
                product: (name != false && name != null) ? name : null,
                quantity: null,
                unitPrice: null,
                amount: null,
                taxIds: [],
                type: displayType,
              );
            } else {
              return null;
            }
          })
          .whereType<ProductLine>()
          .toList();

      productlinedata = productLineDataraw;

      notifyListeners();

      await fetchOptionalProductsWithDetails(client, id);
    } catch (_) {}
  }

  bool isTaxBelongsToCompany(
      int taxId, int sessionCompanyId, List<Tax> taxesList) {
    return taxesList.any((tax) => tax.id == taxId);
  }

  Future<String> fetchTaxFieldName(OdooClient client) async {
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'sale.order.line',
        'method': 'fields_get',
        'args': [],
        'kwargs': {
          'attributes': ['string'],
        },
      });

      if (response.containsKey('tax_ids')) {
        return 'tax_ids';
      } else if (response.containsKey('tax_id')) {
        return 'tax_id';
      } else {
        throw Exception("No tax field found in sale.order.line");
      }
    } catch (e) {
      throw Exception("Error fetching tax field: $e");
    }
  }

  void showSendByEmailDialog(BuildContext context, OdooClient client) {
    final quotationProvider =
        Provider.of<QuotationFormProvider>(context, listen: false);
    final saleOrderData = quotationProvider.saleOrderDataPdf;
    final int? saleId = quotationProvider.saleId;

    if (saleId == null) {
      CustomSnackbar.showSuccess(context, "Sale Order ID is missing");

      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final isDark =
            Theme.of(dialogContext).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          title: Text(
            "Send Quotation by Email",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Quotation",
                      style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        saleOrderData?.quotationName ?? 'N/A',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.end,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Customer",
                      style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        saleOrderData?.customerName ?? 'N/A',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.end,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Quotation Date",
                      style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        saleOrderData?.orderDate ?? 'N/A',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.end,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Expiration Date",
                      style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        saleOrderData?.validityDate ?? 'N/A',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.end,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Amount",
                      style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "${saleOrderData?.currencySymbol ?? '\$'}${saleOrderData?.totalAmount?.toStringAsFixed(2) ?? '0.00'}",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.end,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Subtotal",
                      style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "${saleOrderData?.currencySymbol ?? '\$'}${saleOrderData?.totaluntaxed?.toStringAsFixed(2) ?? '0.00'}",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.end,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tax",
                      style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "${saleOrderData?.currencySymbol ?? '\$'}${saleOrderData?.taxedAmount?.toStringAsFixed(2) ?? '0.00'}",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.end,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side:
                          BorderSide(color: AppStyle.primaryColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppStyle.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyle.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await quotationProvider.sendQuotationEmail(
                        client,
                        saleId,
                        dialogContext,
                        isOdoo18: true,
                      );
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text(
                      "Send",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Opens email composer and sends quotation to customer
  /// Also marks as "sent" if still in draft
  Future<void> sendQuotationEmail(
      OdooClient client, int saleId, BuildContext context,
      {bool isOdoo18 = true}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const GlobalLoadingDialog(message: "Sending Email..."),
    );
    // The dialog comes down exactly once; popping it again on a later
    // failure closed the quotation screen itself.
    var dialogOpen = true;
    void closeDialog() {
      if (!dialogOpen || !context.mounted) return;
      dialogOpen = false;
      Navigator.pop(context);
    }

    var sent = false;
    try {
      final quotationResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'sale.order',
        'method': 'action_quotation_send',
        'args': [saleId],
        'kwargs': {},
      });

      final contextData = quotationResponse['context'];
      int? templateId = contextData?['default_template_id'];

      if (templateId == null) {
        closeDialog();
        if (context.mounted) {
          CustomSnackbar.showError(
              context, 'No email template is set up for quotations.');
        }
        return;
      }

      List datalist = ['partner_id'];

      final saleOrder = await CompanySessionManager.callKwWithCompany({
        'model': 'sale.order',
        'method': 'read',
        'args': [
          [saleId]
        ],
        'kwargs': {'fields': datalist},
      });

      if (saleOrder.isEmpty || saleOrder[0]['partner_id'] is! List) {
        closeDialog();
        if (context.mounted) {
          CustomSnackbar.showError(context, 'This quotation has no customer.');
        }
        return;
      }

      int partnerId = saleOrder[0]['partner_id'][0] as int;

      final mailComposeResponse =
          await CompanySessionManager.callKwWithCompany({
        'model': 'mail.compose.message',
        'method': 'create',
        'args': [
          {
            'model': 'sale.order',
            'res_ids': [saleId],
            'template_id': templateId,
            'composition_mode': 'comment',
            'force_send': true,
            'email_layout_xmlid':
                'mail.mail_notification_layout_with_responsible_signature',
            'partner_ids': [partnerId],
          }
        ],
        'kwargs': {},
      });

      int mailComposeId = mailComposeResponse;

      await CompanySessionManager.callKwWithCompany({
        'model': 'mail.compose.message',
        'method': 'action_send_mail',
        'args': [
          [mailComposeId]
        ],
        'kwargs': {},
      });

      sent = true;
      closeDialog();
      if (context.mounted) {
        CustomSnackbar.showSuccess(context, 'Email Sent Successfully');
      }

      if (currentStatus == 'draft') {
        await CompanySessionManager.callKwWithCompany({
          'model': 'sale.order',
          'method': 'action_quotation_sent',
          'args': [
            [saleId]
          ],
          'kwargs': {},
        });
      }

      final quotaData = await CompanySessionManager.callKwWithCompany({
        'model': 'sale.order',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', saleId]
          ]
        ],
        'kwargs': {
          'fields': ['state'],
        },
      });

      currentStatus = quotaData[0]['state'];
      notifyListeners();
      setupState();

      final quotationViewProvider =
          Provider.of<QuotationViewProvider>(context, listen: false);
      final clientManager =
          Provider.of<OdooClientManager>(context, listen: false);
      if (context.mounted) {
        await quotationViewProvider.getQuotationsAndReport(
          context: context,
          session: clientManager.currentsession!,
        );
      }
    } catch (e, stack) {
      debugPrint('[QuotationFormProvider] sendQuotationEmail: $e\n$stack');
      closeDialog();
      // Past this point the email is out; only the follow-up refresh failed.
      if (!sent && context.mounted) {
        CustomSnackbar.showError(
            context, 'Error sending email: ${_rpcErrorReason(e)}');
      }
    }
  }

  /// The server's own message inside an RPC error, for showing to the user.
  String _rpcErrorReason(Object error) {
    final text = error.toString();
    final match = RegExp(r'message: (.+?), arguments:', dotAll: true)
        .firstMatch(text);
    final reason = match?.group(1)?.trim();
    if (reason != null && reason.isNotEmpty) return reason;
    return 'Please try again.';
  }

  /// Creates a new quotation (sale.order) record in Odoo
  /// Returns `true` on success
  Future<bool> createQuotationOnly(
      QuoteBuilderProvider qoutebuilder,
      QuotationViewProvider viewprovider,
      OdooClient client,
      int? currentopportunityId,
      int? partnerId,
      SessionModel session,
      BuildContext context) async {
    if (partnerId == null) {
      if (context.mounted) {
        customerError = "Customer Field Cant Be Empty";
        notifyListeners();
        CustomSnackbar.showWarning(context, 'Select A customer First');
      }
      return false;
    }

    if (formatDateQuotation.text == '') {
      quotationDateError = "Quotation Date Cant Be Empty";
      notifyListeners();
      if (context.mounted) {
        CustomSnackbar.showWarning(context, 'Quotation Date Cant Be Empty');
      }
      return false;
    }

    if (productlinedata.isEmpty) {
      if (context.mounted) {
        CustomSnackbar.showWarning(
            context, 'Add at least one product before creating the quotation');
      }
      return false;
    }

    try {
      formatDateQuotation.text =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      dynamic response;
      isLoading = true;
      notifyListeners();
      final taxfield = await fetchTaxFieldName(client);
      Map<String, dynamic> orderData = {
        'user_id': orderpersonValue ?? session.userId,
        'signature': imageBase64,
        'signed_by':
            signedByController.text.isEmpty ? null : signedByController.text,
        'signed_on':
            formatDateSignature.text.isEmpty ? null : formatDateSignature.text,
        'commitment_date':
            formatDateDelivery.text.isEmpty ? null : formatDateDelivery.text,
        'company_id': session.companyId,
        'require_signature': onlineSignature,
        'require_payment': onlinePayment,
        'client_order_ref': referenceController.text,
        // Left out when empty, so Odoo derives it from the customer.
        if (selectedFiscalId != null)
          'fiscal_position_id': selectedFiscalId!.id,
        'journal_id': journalId?.id,
        'origin': documentController.text,
        'opportunity_id': currentopportunityId,
        'campaign_id': selectedcampaignId?.id,
        'medium_id': selectedMediumId?.id,
        'source_id': selectedSourceId?.id,
        'tag_ids': selectedTagIds,
        'validity_date':
            formatDateexpire.text.isEmpty ? null : formatDateexpire.text,
        'date_order':
            formatDateQuotation.text.isEmpty ? null : formatDateQuotation.text,
        'payment_term_id': selectedPaymentTermId?.id,
        'partner_id': partnerId,
        'order_line': productlinedata.map((product) {
          return [
            0,
            0,
            {
              'display_type': product.type,
              'product_id': product.id,
              'product_uom_qty': product.quantity,
              'price_unit': product.unitPrice,
              'name': product.type == null
                  ? (product.description ?? product.product)
                  : product.product,
              taxfield: [
                [6, 0, product.taxIds]
              ],
            }
          ];
        }).toList(),
      };

      // Sent even when empty: left out, Odoo falls back to the company's
      // default template, undoing a template the user removed.
      if (isSaleManagementInstalled) {
        orderData['sale_order_template_id'] = selectedTemplate?.id;
      }

      response = await sessionService.callKwWithCompany({
        'model': 'sale.order',
        'method': 'create',
        'args': [orderData],
        'kwargs': {},
      });

      if (response != null) {
        saleId = response;

        final quotaData = await sessionService.callKwWithCompanyDynamic({
          'model': 'sale.order',
          'method': 'search_read',
          'args': [
            [
              ['id', '=', saleId]
            ]
          ],
          'kwargs': {
            'fields': [
              'name',
            ],
          },
        });

        quotationName = quotaData[0]['name'];

        _hasOptionalProductsModel = true;
        await addOptionalProducts(client, saleId!);

        if (context.mounted) {
          await fetchAndReplaceOrderLines(
              saleId!, client, session, productlinedata, context);
        }

        if (context.mounted) {
          CustomSnackbar.showSuccess(context, 'Quotation Created Successfully');
        }
        isLoading = false;

        notifyListeners();
        return true;
      } else {
        isLoading = false;

        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('createQuotationOnly failed: $e');
      if (context.mounted) {
        final detail = e.toString();
        CustomSnackbar.showError(
          context,
          'Error Occurred While Saving'
          '${detail.isNotEmpty ? ': ${detail.substring(0, detail.length > 200 ? 200 : detail.length)}' : ''}',
        );
      }
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Updates an existing quotation with current form data
  /// Handles line create/update/delete commands intelligently
  Future<bool> updateQuotation(
    QuoteBuilderProvider qoutebuilder,
    OdooClient client,
    int saleId,
    BuildContext context,
    int? opportunityId,
    int? partnerId,
    SessionModel session, {
    bool isQuote = false,
    bool isOdoo18 = true,
    bool loading = false,
  }) async {
    if (partnerId == null) {
      if (context.mounted) {
        customerError = "Customer Field Cant Be Empty";
        notifyListeners();
        CustomSnackbar.showWarning(context, 'Select A customer First');
      }
      return false;
    }
    if (formatDateQuotation.text == '') {
      quotationDateError = "Quotation Date Cant Be Empty";
      notifyListeners();
      if (context.mounted) {
        CustomSnackbar.showWarning(context, 'Quotation Date Cant Be Empty');
      }
      return false;
    }
    try {
      formatDateQuotation.text =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      dynamic response;
      isEdit = false;
      if (loading) {
        isLoading = true;
      }
      notifyListeners();

      if (context.mounted && isOdoo18 && isQuote) {
        qoutebuilder.setLoading();
      }
      final taxfield = await fetchTaxFieldName(client);

      final existingOrderLines = await sessionService.callKwWithCompanyDynamic({
        'model': 'sale.order.line',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['order_id', '=', saleId]
          ],
          'fields': ['id', 'product_id', 'name', 'display_type', taxfield],
        },
      });

      Map<int, Map<String, dynamic>> existingLinesMap = {
        for (var line in existingOrderLines) line['id']: line
      };

      final List<dynamic> orderLineCommands = [];

      Set<int> remainingOrderLineIds = {};

      for (var product in productlinedata) {
        if (product.orderlineId != null &&
            existingLinesMap.containsKey(product.orderlineId)) {
          orderLineCommands.add([
            1,
            product.orderlineId,
            {
              'product_id': product.id,
              'product_uom_qty': product.quantity,
              'price_unit': product.unitPrice,
              'name': product.description ?? product.product,
              taxfield: [
                [6, 0, product.taxIds]
              ],
            }
          ]);
          remainingOrderLineIds.add(product.orderlineId!);
        } else {
          orderLineCommands.add([
            0,
            0,
            {
              'order_id': saleId,
              'display_type': product.type,
              'product_id': product.id,
              'product_uom_qty': product.quantity,
              'price_unit': product.unitPrice,
              'name': product.description ?? product.product,
              taxfield: [
                [6, 0, product.taxIds]
              ],
            }
          ]);
        }
      }

      for (var line in existingOrderLines) {
        int lineId = line['id'];
        if (!remainingOrderLineIds.contains(lineId)) {
          orderLineCommands.add([2, lineId, 0]);
        }
      }

      Map<String, dynamic> data = {
        'signature': imageBase64,
        'signed_by': signedByController.text,
        'signed_on': formatDateSignature.text,
        'user_id': orderpersonValue,
        'commitment_date': formatDateDelivery.text,
        'require_signature': onlineSignature,
        'require_payment': onlinePayment,
        'client_order_ref': referenceController.text,
        // Was always null, which wiped the order's fiscal position on every
        // save.
        'fiscal_position_id': selectedFiscalId?.id,
        'journal_id': journalId?.id,
        'origin': documentController.text,
        'opportunity_id': currentopportunityId,
        'campaign_id': selectedcampaignId?.id,
        'medium_id': selectedMediumId?.id,
        'source_id': selectedSourceId?.id,
        'tag_ids': selectedTagIds,
        'validity_date': formatDateexpire.text,
        'date_order': formatDateQuotation.text,
        'payment_term_id': selectedPaymentTermId?.id,
        'partner_id': partnerId,
        'team_id': selectedTeamId,
      };
      // Sent even when empty, so removing the template is saved too.
      if (isSaleManagementInstalled) {
        data['sale_order_template_id'] = selectedTemplate?.id;
      }
      if (!isAbsorbed) {
        data['order_line'] = orderLineCommands;
      }

      response = await sessionService.callKwWithCompanyUpdate({
        'model': 'sale.order',
        'method': 'write',
        'args': [
          [saleId],
          data
        ],
        'kwargs': {
          'context': {
            'lang': 'en_US',
            'uid': session.userId,
            'allowed_company_ids': [session.companyId],
            'active_test': true,
            'company_id': session.companyId,
          },
        }
      });

      if (context.mounted) {
        CustomSnackbar.showSuccess(context, 'Quotation Updated Successfully');
      }

      if (response == true) {
        await addOptionalProducts(client, saleId);
        if (context.mounted) {
          await fetchAndReplaceOrderLines(
            isQuoteBuilder: isQuote,
            saleId,
            client,
            session,
            productlinedata,
            context,
          );
        }

        if (context.mounted && isOdoo18) {
          await qoutebuilder.saveIncludedPDF(saleId, client, context);
        }

        isChanged = false;
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Loads full quotation data (header + lines + optional products + signature)
  /// and updates local state. Falls back to cache if network fails.
  Future<void> fetchAndReplaceOrderLines(
      int saleOrderId,
      OdooClient client,
      SessionModel session,
      List<ProductLine> productlinedata,
      BuildContext context,
      {bool isQuoteBuilder = false,
      bool loading = false,
      int? currencyId,
      bool isOdoo18 = true,
      int? currentCountryId}) async {
    try {
      saleId = saleOrderId;
      isEdit = false;
      isChanged = false;
      if (isQuoteBuilder == false && loading == true) {
        hasError = false;
        isLoading = true;
        notifyListeners();
      }

      if (currentCountryId != null) {
        countryId = currentCountryId;
      }

      if (saleOrderId == null || saleOrderId <= 0) {
        throw Exception(
            'Invalid quotation ID provided. Please select a valid quotation.');
      }

      List<String> fields;

      if (isSaleManagementInstalled) {
        fields = [
          'state',
          'name',
          'invoice_ids',
          'signature',
          'signed_by',
          'signed_on',
          'user_id',
          'commitment_date',
          'company_id',
          'require_signature',
          'require_payment',
          'client_order_ref',
          'fiscal_position_id',
          'journal_id',
          'origin',
          'amount_untaxed',
          'opportunity_id',
          'campaign_id',
          'medium_id',
          'source_id',
          'team_id',
          'invoice_status',
          'tag_ids',
          'validity_date',
          'date_order',
          'payment_term_id',
          'partner_id',
          'amount_total',
          'amount_tax',
          'currency_id',
          'sale_order_template_id',
        ];
      } else {
        fields = [
          'state',
          'name',
          'invoice_ids',
          'signature',
          'signed_by',
          'signed_on',
          'user_id',
          'commitment_date',
          'company_id',
          'require_signature',
          'require_payment',
          'client_order_ref',
          'fiscal_position_id',
          'journal_id',
          'origin',
          'amount_untaxed',
          'opportunity_id',
          'campaign_id',
          'medium_id',
          'source_id',
          'team_id',
          'invoice_status',
          'tag_ids',
          'validity_date',
          'date_order',
          'payment_term_id',
          'partner_id',
          'amount_total',
          'amount_tax',
          'currency_id',
        ];
      }

      final saleorderData = await CompanySessionManager.callKwWithCompany({
        'model': 'sale.order',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', saleOrderId]
          ],
        ],
        'kwargs': {'fields': fields},
      });

      final taxfield = await fetchTaxFieldName(client);

      if (saleorderData.isEmpty) {
        try {
          final alternativeSearch =
              await CompanySessionManager.callKwWithCompany({
            'model': 'sale.order',
            'method': 'search_read',
            'args': [
              [
                ['id', '=', saleOrderId]
              ],
            ],
            'kwargs': {
              'fields': ['id', 'name', 'state'],
              'limit': 1,
            },
          });

          if (alternativeSearch is List && alternativeSearch.isNotEmpty) {
            throw Exception(
                'Access denied: You may not have permission to view this quotation (ID: $saleOrderId).');
          }
        } catch (_) {}

        throw Exception(
            'Sale order not found with ID: $saleOrderId. The quotation may have been deleted or you may not have access to it.');
      }

      if (saleorderData.isNotEmpty) {
        final order = saleorderData[0];
        isInvoiced = false;
        isAbsorbed = false;

        if (order['invoice_status'] == 'to invoice') {
          isInvoiced = true;
        }

        if (order['state'] == 'cancel' || order['state'] == 'sale') {
          isAbsorbed = true;
        }
        invoiceIds = _safeIntList(order['invoice_ids']);

        orderpersonValue = _safeListInt(order['user_id'], 0);
        currentStatus = _safeString(order['state']) ?? 'draft';

        quotationName = _safeString(order['name']) ?? 'New';
        signedByController.text = _safeString(order['signed_by']) ?? "";
        imageBase64 = _safeString(order['signature']);
        formatDateSignature.text = _safeString(order['signed_on']) ?? '';
        formatDateDelivery.text = _safeString(order['commitment_date']) ?? '';

        companyid = _safeListInt(order['company_id'], 0);

        onlineSignature = _safeBool(order['require_signature']);
        onlinePayment = _safeBool(order['require_payment']);

        referenceController.text = _safeString(order['client_order_ref']) ?? "";
        selectedFiscalId = _createFiscalPosition(order['fiscal_position_id']);
        journalId = _createAccountJournal(order['journal_id']);
        documentController.text = _safeString(order['origin']) ?? "";

        currentopportunityId = _safeListInt(order['opportunity_id'], 0);

        selectedcampaignId = _createCampaign(order['campaign_id']);
        selectedMediumId = _createMedium(order['medium_id']);
        selectedSourceId = _createSource(order['source_id']);

        selectedTagIds = _safeIntList(order['tag_ids']);

        selectedTemplate =
            _createSaleOrderTemplate(order['sale_order_template_id']);
        formatDateexpire.text = _safeString(order['validity_date']) ?? '';
        formatDateQuotation.text = _safeString(order['date_order']) ?? '';

        selectedPaymentTermId = _createPaymentTerm(order['payment_term_id']);
        selectedpartnerid = _safeListInt(order['partner_id'], 0);
        selectedPartnerName = _safeListString(order['partner_id'], 1);
        selectedTeamId = _safeListInt(order['team_id'], 0);

        currencycode = _safeListInt(order['currency_id'], 0);
      }

      List<dynamic> fetchedOptions = [];
      try {
        fetchedOptions = await CompanySessionManager.callKwWithCompany({
          'model': 'sale.order.option',
          'method': 'search_read',
          'args': [],
          'kwargs': {
            'domain': [
              ['order_id', '=', saleOrderId]
            ],
            'fields': ['id', 'product_id', 'name', 'price_unit', 'quantity'],
          },
        });
        _hasOptionalProductsModel = true;
      } catch (e) {
        _hasOptionalProductsModel = false;
        fetchedOptions = [];
      }

      optionalProductData = fetchedOptions.map((option) {
        return {
          'product_name': option['name'],
          'id': option['id'],
          'product_id':
              option['product_id'] is List ? option['product_id'][0] : null,
          'description': option['name'] ?? '',
          'price': option['price_unit'] ?? 0.0,
          'quantity': option['quantity'] ?? 1,
        };
      }).toList();

      final orderLines = await CompanySessionManager.callKwWithCompany({
        'model': 'sale.order.line',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['order_id', '=', saleOrderId]
          ],
          'fields': [
            'id',
            'product_id',
            'name',
            'product_uom_qty',
            'price_unit',
            'display_type',
            taxfield,
            'discount',
            'is_downpayment'
          ],
        },
      });

      productlinedata.clear();

      for (var line in orderLines) {
        try {
          productlinedata.add(ProductLine(
            isDownPayment: _safeBool(line['is_downpayment']),
            taxIds: line[taxfield],
            amount: (() {
              final qty = _safeDouble(line['product_uom_qty']) ?? 0.0;
              final unitPrice = _safeDouble(line['price_unit']) ?? 0.0;
              final discount = _safeDouble(line['discount']) ?? 0.0;
              final discountedPrice = unitPrice * (1 - (discount / 100));
              return qty * discountedPrice;
            })(),
            discount: _safeDouble(line['discount']),
            description: _safeString(line['name']),
            orderlineId: _safeInt(line['id']),
            id: _safeListInt(line['product_id'], 0),
            product: _getProductName(line),
            quantity: _safeDouble(line['product_uom_qty']),
            unitPrice: _safeDouble(line['price_unit']),
            type: _safeString(line['display_type']),
          ));
        } catch (e) {
          continue;
        }
      }

      await setpartnerid(selectedpartnerid!, client);
      setupState();

      if (saleorderData.isNotEmpty) {
        try {
          final orderData = saleorderData[0];
          saleOrderDataPdf = SaleOrderData(
            base64: _safeString(orderData['signature']),
            taxedAmount: _safeDouble(orderData['amount_tax']) ?? 0.0,
            totaluntaxed: _safeDouble(orderData['amount_untaxed']) ?? 0.0,
            saleOrderId: saleOrderId,
            quotationName: _safeString(orderData['name']) ?? 'Unknown',
            status: _safeString(orderData['state']) ?? 'draft',
            customerName:
                _safeListString(orderData['partner_id'], 1) ?? "Unknown",
            companyName:
                _safeListString(orderData['company_id'], 1) ?? "Unknown",
            salesperson: _safeListString(orderData['user_id'], 1) ?? "Unknown",
            campaign: _safeListString(orderData['campaign_id'], 1),
            medium: _safeListString(orderData['medium_id'], 1),
            source: _safeListString(orderData['source_id'], 1),
            validityDate: _safeString(orderData['validity_date']),
            orderDate: _safeString(orderData['date_order']),
            requireSignature: _safeBool(orderData['require_signature']),
            requirePayment: _safeBool(orderData['require_payment']),
            currencySymbol: currencySymbol ?? "",
            totalAmount: _safeDouble(orderData['amount_total']) ?? 0.0,
            orderLines: List.from(productlinedata),
            optionalProducts: List.from(optionalProductData),
          );
        } catch (_) {}
      }

      if (saleorderData.isNotEmpty) {
        try {
          tempIsarData = saleorderData[0];
          tempIsarData!['customerAddress'] = addressController.text;
          final saleOrderCache = SaleOrderIsarCache.fromJson(tempIsarData!);

          final List<SaleOrderLineIsarCache> orderLinesCache = [];
          for (var line in orderLines) {
            try {
              if (line is Map<String, dynamic>) {
                orderLinesCache.add(SaleOrderLineIsarCache.fromOrderLine(
                    line, saleOrderId, taxfield));
              }
            } catch (_) {}
          }

          final List<SaleOrderOptionIsarCache> optionsCache = [];
          for (var option in fetchedOptions) {
            try {
              optionsCache.add(
                  SaleOrderOptionIsarCache.fromOption(option, saleOrderId));
            } catch (_) {}
          }

          try {
            await IsarService.saveSaleOrderComplete(
              saleOrder: saleOrderCache,
              orderLines: orderLinesCache,
              options: optionsCache,
            );
          } catch (_) {}
        } catch (_) {}
      }

      isOffline = false;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e.toString().contains('type') &&
          e.toString().contains('is not a subtype of')) {
        quoteError = AppError(
          message:
              'Data format error: The quotation data received from the server has an unexpected format. This may be due to custom fields or Odoo version differences. Please try refreshing or contact support.',
          type: ErrorType.dataFormat,
          originalError: e,
        );
      } else if (e.toString().contains('Sale order not found')) {
        quoteError = AppError(
          message:
              'Quotation not found. The quotation with ID $saleOrderId does not exist or has been deleted. Please refresh the quotation list and try again.',
          type: ErrorType.notFound,
          originalError: e,
        );

        if (context != null && context.mounted) {
          Future.microtask(() {
            try {
              final quotationProvider =
                  Provider.of<QuotationViewProvider>(context, listen: false);
              quotationProvider.getQuotationsAndReport(
                context: context,
                session: session,
                isQuotation: true,
              );
            } catch (_) {}
          });
        }
      } else {
        quoteError = await ErrorHandler.handleException(e);
      }

      final success = await loadSaleOrderFromCache(saleOrderId);
      if (success == false) {
        Future.delayed(const Duration(seconds: 2), () {
          isLoading = false;
          hasError = true;
          notifyListeners();
        });
      } else {
        hasError = false;
        quoteError = null;
      }
    }
  }

  Future<bool> loadSaleOrderFromCache(int saleOrderId) async {
    try {
      final cachedData = await IsarService.getSaleOrderComplete(saleOrderId);

      if (cachedData != null) {
        await _loadFromCache(cachedData);
        isOffline = true;
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> _loadFromCache(Map<String, dynamic> cachedData) async {
    try {
      isLoading = true;
      notifyListeners();

      final saleOrder = cachedData['saleOrder'] as SaleOrderIsarCache?;
      final orderLines =
          cachedData['orderLines'] as List<SaleOrderLineIsarCache>?;

      if (saleOrder == null) {
        throw Exception('Sale order data is null in cache');
      }

      isInvoiced = saleOrder.invoiceStatus == 'to invoice';
      isAbsorbed = saleOrder.state == 'cancel' || saleOrder.state == 'sale';

      addressController.text = saleOrder.customerAddress ?? "No Address";
      orderpersonValue = saleOrder.userId;
      currentStatus = saleOrder.state ?? 'draft';
      quotationName = saleOrder.name ?? 'New';
      signedByController.text = saleOrder.signedBy ?? '';
      imageBase64 = saleOrder.signature;
      formatDateSignature.text = saleOrder.signedOn ?? '';
      formatDateDelivery.text = saleOrder.commitmentDate ?? '';
      companyid = saleOrder.companyId;
      onlineSignature = saleOrder.requireSignature ?? false;
      onlinePayment = saleOrder.requirePayment ?? false;
      referenceController.text = saleOrder.clientOrderRef ?? '';
      totalIncluded = saleOrder.amountTotal!;
      totalTaxed = saleOrder.amountTax!;
      totalExcluded = saleOrder.amountUntaxed!;

      selectedFiscalId = saleOrder.fiscalPositionId != null &&
              saleOrder.fiscalPositionName != null
          ? FiscalPosition(
              id: saleOrder.fiscalPositionId!,
              name: saleOrder.fiscalPositionName!)
          : null;

      journalId = saleOrder.journalId != null && saleOrder.journalName != null
          ? AccountJournal(
              id: saleOrder.journalId!, name: saleOrder.journalName!)
          : null;

      documentController.text = saleOrder.origin ?? '';
      currentopportunityId = saleOrder.opportunityId;

      selectedcampaignId = saleOrder.campaignId != null &&
              saleOrder.campaignName != null
          ? Campaign(id: saleOrder.campaignId!, name: saleOrder.campaignName!)
          : null;

      selectedMediumId =
          saleOrder.mediumId != null && saleOrder.mediumName != null
              ? Medium(id: saleOrder.mediumId!, name: saleOrder.mediumName!)
              : null;

      selectedSourceId =
          saleOrder.sourceId != null && saleOrder.sourceName != null
              ? Source(id: saleOrder.sourceId!, name: saleOrder.sourceName!)
              : null;

      selectedTemplate = saleOrder.saleOrderTemplateId != null &&
              saleOrder.saleOrderTemplateName != null
          ? SaleOrderTemplate(
              mailTemplateId: [],
              id: saleOrder.saleOrderTemplateId!,
              name: saleOrder.saleOrderTemplateName!)
          : null;

      formatDateexpire.text = saleOrder.validityDate ?? '';
      formatDateQuotation.text = saleOrder.dateOrder ?? '';

      selectedPaymentTermId =
          saleOrder.paymentTermId != null && saleOrder.paymentTermName != null
              ? PaymentTerm(
                  id: saleOrder.paymentTermId!,
                  name: saleOrder.paymentTermName!)
              : null;

      selectedpartnerid = saleOrder.partnerId;
      selectedPartnerName = saleOrder.partnerName;
      selectedTeamId = saleOrder.teamId;

      currencycode = saleOrder.currencyId ?? currencycode;
      currencySymbol = saleOrder.currencySymbol ?? currencySymbol;

      productlinedata.clear();
      for (var line in orderLines ?? []) {
        productlinedata.add(ProductLine(
          isDownPayment: line.isDownPayment ?? false,
          taxIds: line.taxIds ?? [],
          amount: line.amount ?? 0.0,
          discount: line.discount,
          description: line.name,
          orderlineId: line.orderLineId,
          id: line.productId,
          product: line.isDownPayment == false && line.productId != null
              ? line.productName ?? line.name
              : line.name,
          quantity: line.productUomQty,
          unitPrice: line.priceUnit,
          type: line.displayType,
        ));
      }

      isOffline = true;
      isLoading = false;

      notifyListeners();
    } catch (e) {
      isLoading = false;
      hasError = true;
      quoteError = AppError(
        message: 'Error loading cached data: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
      );
      notifyListeners();
      rethrow;
    }
  }

  Future<List<Campaign>> fetchCampaigns(OdooClient client) async {
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'utm.campaign',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'fields': ['id', 'name'],
        },
      });

      return (response as List<dynamic>)
          .map((item) => Campaign.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Medium>> fetchMediums(OdooClient client) async {
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'utm.medium',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'fields': ['id', 'name'],
        },
      });

      return (response as List<dynamic>)
          .map((item) => Medium.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Source>> fetchSources(OdooClient client) async {
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'utm.source',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'fields': ['id', 'name'],
        },
      });

      return (response as List<dynamic>)
          .map((item) => Source.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Confirms quotation → turns it into a sale order
  Future<bool> confirmSaleOrder(OdooClient client, BuildContext context) async {
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'sale.order',
        'method': 'action_confirm',
        'args': [
          [saleId]
        ],
        'kwargs': {},
      });

      if (response != null) {
        final quotaData = await CompanySessionManager.callKwWithCompany({
          'model': 'sale.order',
          'method': 'search_read',
          'args': [
            [
              ['id', '=', saleId]
            ]
          ],
          'kwargs': {
            'fields': ['state'],
          },
        });

        currentStatus = quotaData[0]['state'];
        isAbsorbed = true;
        notifyListeners();
        setupState();

        if (context.mounted) {
          final quotationViewProvider =
              Provider.of<QuotationViewProvider>(context, listen: false);
          final clientManager =
              Provider.of<OdooClientManager>(context, listen: false);

          await quotationViewProvider.getQuotationsAndReport(
            context: context,
            session: clientManager.currentsession!,
          );
        }

        if (context.mounted) {
          CustomSnackbar.showSuccess(
              context, 'Sale Order Confirmed Successfully');
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Sets confirmed/cancelled order back to quotation (draft)
  Future<void> setToQuotation(
      OdooClient client, int saleOrderId, BuildContext context) async {
    try {
      final draftresponse = await CompanySessionManager.callKwWithCompany({
        'model': 'sale.order',
        'method': 'action_draft',
        'args': [
          saleOrderId,
        ],
        'kwargs': {},
      });

      final quotaData = await CompanySessionManager.callKwWithCompany({
        'model': 'sale.order',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', saleOrderId]
          ]
        ],
        'kwargs': {
          'fields': [
            'state',
          ],
        },
      });

      isAbsorbed = false;
      currentStatus = quotaData[0]['state'];
      notifyListeners();
      setupState();

      if (draftresponse == true) {
        if (context.mounted) {
          final quotationViewProvider =
              Provider.of<QuotationViewProvider>(context, listen: false);
          final clientManager =
              Provider.of<OdooClientManager>(context, listen: false);

          await quotationViewProvider.getQuotationsAndReport(
            context: context,
            session: clientManager.currentsession!,
          );

          if (context.mounted) {
            CustomSnackbar.showSuccess(context, 'Order Set To Quotation');
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.showError(context, 'Error Setting Order to Quotation');
      }
    }
  }

  /// Cancels the sale order directly (no mail wizard/status-change dialog)
  Future<void> handleCancelOnChange(
      OdooClient client, BuildContext context, int saleOrderId) async {
    try {
      await CompanySessionManager.callKwWithCompany({
        'model': 'sale.order',
        'method': 'action_cancel',
        'args': [
          [saleOrderId]
        ],
        'kwargs': {},
      });

      final quotaData = await CompanySessionManager.callKwWithCompany({
        'model': 'sale.order',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', saleOrderId]
          ]
        ],
        'kwargs': {
          'fields': ['state'],
        },
      });

      currentStatus = quotaData[0]['state'];
      isAbsorbed = true;
      notifyListeners();
      setupState();
      if (context.mounted) {
        final quotationViewProvider =
            Provider.of<QuotationViewProvider>(context, listen: false);
        final clientManager =
            Provider.of<OdooClientManager>(context, listen: false);

        await quotationViewProvider.getQuotationsAndReport(
          context: context,
          session: clientManager.currentsession!,
        );

        if (context.mounted) {
          CustomSnackbar.showSuccess(context, 'Order Cancelled Successfully');
        }
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.showError(context, 'Failed to cancel order: $e');
      }
    }
  }

  /// Syncs local optional products to Odoo sale.order.option model
  Future<void> addOptionalProducts(OdooClient client, int saleId) async {
    if (!_hasOptionalProductsModel) {
      return;
    }

    try {
      List<dynamic> existingOptions = [];
      try {
        existingOptions = await CompanySessionManager.callKwWithCompany({
          'model': 'sale.order.option',
          'method': 'search_read',
          'args': [],
          'kwargs': {
            'domain': [
              ['order_id', '=', saleId]
            ],
            'fields': ['id'],
          },
        });
      } catch (e) {
        _hasOptionalProductsModel = false;
        return;
      }

      final existingOptionIds =
          existingOptions.map<int>((option) => option['id'] as int).toList();

      if (existingOptionIds.isNotEmpty) {
        try {
          await CompanySessionManager.callKwWithCompany({
            'model': 'sale.order.option',
            'method': 'unlink',
            'args': [existingOptionIds],
            'kwargs': {},
          });
        } catch (_) {}
      }

      for (final product in optionalProductData) {
        try {
          final description = product['description']?.toString() ?? '';
          final productName = product['product_name']?.toString() ?? '';
          final name =
              description.isNotEmpty ? description : productName;
          if (name.isEmpty || product['product_id'] == null) continue;
          await CompanySessionManager.callKwWithCompany({
            'model': 'sale.order.option',
            'method': 'create',
            'args': [
              {
                'order_id': saleId,
                'product_id': product['product_id'],
                'name': name,
                'price_unit': product['price'] ?? 0.0,
                'quantity': product['quantity'] ?? 1.0,
              }
            ],
            'kwargs': {},
          });
        } catch (_) {}
      }
    } catch (_) {}
  }

  /// Calculates current totals (untaxed / tax / total) locally
  Future<Map<String, double>> calculateQuotationTotals(
      OdooClient client) async {
    double totalUntaxed = 0.0;
    double totalTaxed = 0.0;
    double total = 0.0;

    for (var product in productlinedata) {
      try {
        double discount = product.discount ?? 0.0;
        double discountedUnitPrice = product.unitPrice! * (1 - discount / 100);
        final taxData = await CompanySessionManager.callKwWithCompany({
          'model': 'account.tax',
          'method': 'compute_all',
          'args': [product.taxIds],
          'kwargs': {
            'price_unit': discountedUnitPrice,
            'quantity': product.quantity,
            'product': null,
            'partner': null,
            'is_refund': false,
            'handle_price_include': true,
          },
        });

        double productUntaxed = (taxData['total_excluded'] as num).toDouble();
        double productTotal = (taxData['total_included'] as num).toDouble();
        double productTaxed = productTotal - productUntaxed;

        totalUntaxed += productUntaxed;
        totalTaxed += productTaxed;
        total += productTotal;
      } catch (_) {}
    }

    return {
      'total_untaxed': totalUntaxed,
      'total_taxed': totalTaxed,
      'total': total,
    };
  }

  Future<void> _continueWithInvoiceCreation(
    BuildContext parentContext,
    BuildContext dialogContext,
    StateSetter setState,
    GlobalKey<FormState> formKey,
    String? invoiceAction,
    TextEditingController amountController,
    TextEditingController fixedAmountController,
    OdooClient client,
    SessionModel session,
  ) async {
    setState(() {
      isLoading = true;
      loadingMessage = "Creating invoice wizard...";
    });

    try {
      setState(() {
        loadingMessage = "Setting up invoice...";
      });

      final wizardContext = {
        'active_model': 'sale.order',
        'active_id': saleId,
        'active_ids': [saleId],
      };

      final createVals = <String, dynamic>{
        'advance_payment_method': invoiceAction ?? 'delivered',
        'sale_order_ids': [[6, 0, [saleId]]],
      };
      if (amountController.text.isNotEmpty) {
        final v = double.tryParse(amountController.text.replaceAll('%', '').trim());
        if (v != null) createVals['amount'] = v;
      }
      if (fixedAmountController.text.isNotEmpty) {
        final v = double.tryParse(fixedAmountController.text);
        if (v != null) createVals['fixed_amount'] = v;
      }

      final wizardId = await CompanySessionManager.callKwWithCompany({
        'model': 'sale.advance.payment.inv',
        'method': 'create',
        'args': [createVals],
        'kwargs': {'context': wizardContext},
      });

      setState(() {
        loadingMessage = "Generating invoice...";
      });

      final invoiceResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'sale.advance.payment.inv',
        'method': 'create_invoices',
        'args': [[wizardId]],
        'kwargs': {'context': wizardContext},
      });

      int? invoiceId;
      if (invoiceResponse is Map<String, dynamic> &&
          invoiceResponse.containsKey('res_id')) {
        invoiceId = invoiceResponse['res_id'] as int?;
      } else if (invoiceResponse is Map<String, dynamic> &&
          invoiceResponse.containsKey('res_ids') &&
          invoiceResponse['res_ids'] is List &&
          invoiceResponse['res_ids'].isNotEmpty) {
        invoiceId = invoiceResponse['res_ids'][0] as int?;
      }

      setState(() {
        loadingMessage = "Finalizing...";
      });

      CustomSnackbar.showSuccess(dialogContext, 'Invoice created successfully');

      await fetchAndReplaceOrderLines(
        saleId!,
        client,
        session,
        productlinedata,
        dialogContext,
      );

      Navigator.pop(dialogContext, invoiceId);
      if (invoiceId != null) {
        final nonNullableInvoiceId = invoiceId;
        await Navigator.push(
          dialogContext,
          SlidingPageTransitionRL(
              page: InvoiceDetailScreen(
            invoiceId: nonNullableInvoiceId,
            client: client,
          )),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);

      String errorMsg = 'Failed to create invoice';
      if (e is OdooException) {
        final match = RegExp(r'name: [^,]+, message: (.+?), arguments:')
            .firstMatch(e.message);
        if (match != null && match.group(1) != null) {
          errorMsg = match.group(1)!.trim();
        }
      }

      if (dialogContext.mounted) Navigator.of(dialogContext).pop();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (parentContext.mounted) {
          CustomSnackbar.showError(parentContext, errorMsg);
        }
      });
    }
  }

  Future<bool> createQuotationPartner(
      OdooClient client,
      int leadId,
      String action,
      int? partnerId,
      BuildContext context,
      SessionModel session) async {
    try {
      final recordId = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.quotation.partner',
        'method': 'create',
        'args': [
          {
            'lead_id': leadId,
            'action': action,
            'partner_id': partnerId,
          }
        ],
        'kwargs': {
          'context': {
            'active_model': 'crm.lead',
            'active_id': leadId,
          }
        },
      });

      await CompanySessionManager.callKwWithCompany({
        'model': 'crm.quotation.partner',
        'method': 'action_apply',
        'args': [
          [recordId]
        ],
        'kwargs': {
          'context': {
            'active_model': 'crm.lead',
            'active_id': leadId,
          }
        },
      });
      if (context.mounted) {
        await Provider.of<OdooClientManager>(context, listen: false)
            .getCrmLead();
      }

      if (context.mounted) {
        await fetchSaleAndPartnerData(client, session, leadId, false, context);

        if (context.mounted) {
          Navigator.pop(context);
        }
        return true;
      }

      return false;
    } catch (e) {
      if (context.mounted) {
        GlobalMethod.showErrorDialog(error: "$e", ctx: context);
      }
      return false;
    }
  }

  /// Initial partner/lead → quotation flow with possible "new/existing/none" choice
  Future<void> checkPartner(
    OdooClient client,
    dynamic lead,
    BuildContext context,
    SessionModel session, {
    required bool forceNoPartner,
  }) async {
    // Callers show a loading dialog first; it has to come down exactly once
    // on every path, or it sits under the next screen or blocks the app.
    var loadingClosed = false;
    void closeLoading() {
      if (loadingClosed || !context.mounted) return;
      loadingClosed = true;
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
    }

    try {
      saleId = null;
      selectedIndex = 0;

      final salenew = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'action_sale_quotations_new',
        'args': [
          [lead['id']],
        ],
        'kwargs': {},
      });

      int? defaultPartnerId;
      if (salenew['context'] is Map &&
          salenew['context'].containsKey('default_partner_id')) {
        defaultPartnerId = (salenew['context']['default_partner_id'] as int?);
        selectedpartnerid = defaultPartnerId;
        selectedPartnerName = null;

        notifyListeners();
      }

      if (defaultPartnerId != null) {
        if (salenew.containsKey('context') && salenew['context'] is Map) {
          var context = salenew['context'] as Map;

          if (context.containsKey('default_tag_ids')) {
            var defaultTagIds = context['default_tag_ids'];

            if (defaultTagIds is List && defaultTagIds.isNotEmpty) {
              if (defaultTagIds[0] is List && defaultTagIds[0].length > 2) {
                selectedTagIds = List<int>.from(defaultTagIds[0][2]);
              } else {}
            } else {}
          } else {}
        } else {}

        notifyListeners();

        if (context.mounted) {
          bool success = await fetchSaleAndPartnerData(
              client, session, lead['id'], false, context);

          // The form's Customer and Opportunity pickers read lists loaded
          // once per session; a customer or lead made since (e.g. by a lead
          // conversion) is fetched in before the form opens.
          if (success && context.mounted) {
            final clientManager =
                Provider.of<OdooClientManager>(context, listen: false);
            final hasCustomer = clientManager.customerItems
                .any((item) => item.id == selectedpartnerid);
            final hasLead =
                clientManager.leadItems.any((item) => item.id == lead['id']);
            if (!hasCustomer || !hasLead) {
              await clientManager.getCrmLead();
            }
          }

          closeLoading();
          if (success && context.mounted) {
            Navigator.push(
              context,
              SlidingPageTransitionRL(
                page: NewQuotationForm(leadid: lead['id']),
              ),
            );
          }
        }
      } else {
        closeLoading();
        if (context.mounted) {
          showQuotationDialog(context, client, lead['id'], session);
        }
      }
    } catch (e) {
      debugPrint('[QuotationFormProvider] checkPartner failed: $e');
      closeLoading();
      if (context.mounted) {
        CustomSnackbar.showError(context, 'Could not start the quotation.');
      }
    }
  }

  /// Clears current signature
  void cleanSignature() {
    pickedFile = null;
    imageBase64 = null;
    image = null;
    isChanged = true;
    notifyListeners();
  }

  bool _isPickingImage = false;

  /// Picks signature image from gallery and converts to base64
  Future<void> pickImage() async {
    if (_isPickingImage) return;
    _isPickingImage = true;
    try {
      final ImagePicker picker = ImagePicker();
      pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        image = File(pickedFile!.path);
        final bytes = await image!.readAsBytes();
        imageBase64 = base64Encode(bytes);
        isChanged = true;
        notifyListeners();
      }
    } finally {
      _isPickingImage = false;
    }
  }

  /// Loads default values (template, payment term, dates, taxes country, etc.)
  /// Usually called when creating a brand-new quotation
  Future<void> setDefaultData({
    required OdooClient client,
    required BuildContext context,
    int? currentCountryId,
  }) async {
    final session = await CompanySessionManager.getCurrentSession();

    try {
      isLoading = true;
      isEdit = true;
      notifyListeners();
      if (currentCountryId != null) {
        countryId = currentCountryId;
      }
      clearVariables();
      formatDateQuotation.text =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      int? defaultTemplateId;
      String? defaultTemplateName;
      if (isSaleInstalled) {
        final companyData = await CompanySessionManager.callKwWithCompany({
          'model': 'res.company',
          'method': 'read',
          'args': [
            [client.sessionId?.companyId ?? 1],
            ['sale_order_template_id'],
          ],
          'kwargs': {},
        });

        if (companyData is List && companyData.isNotEmpty) {
          final template = companyData[0]['sale_order_template_id'];
          if (template is List && template.length == 2) {
            defaultTemplateId = template[0];
            defaultTemplateName = template[1];
            selectedTemplate = SaleOrderTemplate(
              id: defaultTemplateId!,
              name: defaultTemplateName!,
            );
          }
        }
      }

      final response = await CompanySessionManager.callSaleOnchange(
        defaultTemplateId: defaultTemplateId,
      );
      if (response is Map<String, dynamic>) {
        final value = response['value'] as Map<String, dynamic>;

        if (value['payment_term_id'] != false) {
          selectedPaymentTermId = PaymentTerm(
            id: value['payment_term_id']['id'],
            name: value['payment_term_id']['display_name'],
          );
        }

        if (value['date_order'] != false) {
          formatDateQuotation.text = value['date_order'].toString();
        }

        if (value['validity_date'] != false) {
          formatDateexpire.text = value['validity_date'].toString();
        }

        if (value['currency_id'] != false) {
          currencycode = (value['currency_id'] as Map?)?['id'];
        }

        if (value['tax_country_id'] != false) {
          countryId = (value['tax_country_id'] as Map?)?['id'];
        }

        if (selectedTemplate != null && context.mounted) {
          await gettemplatedata(
            client,
            session!,
            selectedTemplate!.id,
            context,
            selectedTemplate!,
          );
        }
      } else {
        throw Exception('Invalid response structure');
      }
    } catch (_) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

/// A [TextInputFormatter] that appends ' %' immediately after the numeric
/// input so the field always displays e.g. "10 %".
class _PercentageSuffixFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll('%', '').trimRight();

    if (digits.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    final clean = digits.replaceAll(RegExp(r'[^0-9.]'), '');
    final display = '$clean %';

    return TextEditingValue(
      text: display,
      selection: TextSelection.collapsed(offset: clean.length),
    );
  }
}

/// List price plus the extra price of every selected variant attribute.
double _productTotalPrice(dynamic item) {
  final double basePrice = (item['list_price'] ?? 0.0) as double;
  final double extraPrice = item['attributes']?.fold(0.0, (sum, attr) {
        return sum + (attr['extra_price'] ?? 0.0);
      }) ??
      0.0;
  return basePrice + extraPrice;
}
