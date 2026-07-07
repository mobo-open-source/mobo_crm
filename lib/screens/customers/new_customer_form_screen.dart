import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/screens/customers/provider/customer_form_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Rating/review_service.dart';
import '../../core/company/session/company_session_manager.dart';
import '../../core/navigation/data_loss_warning_dialog.dart';
import '../../global_methods/services/global_error_handler.dart';
import '../../global_methods/widgets/image_widget/full_screen_image.dart';
import '../../global_methods/widgets/image_widget/get_allimage.dart';
import '../../global_methods/widgets/shimmer/custom_shimmer.dart';
import '../../utils/globals.dart';
import '../../utils/snackbar.dart';
import 'select_location_screen.dart';

import '../../global_methods/widgets/textfields/future_single_selection_textfield.dart';
import '../../global_methods/widgets/textfields/multi_select_textfield.dart';
import '../../global_methods/widgets/transition/page_transition.dart';
import '../../initilisation.dart';
import '../../models/isar/lead_and_customer_models.dart';
import '../../models/models.dart';

import '../../screens/customers/provider/customer_data_provider.dart';
import '../lead/providers/lead_form_provider.dart';
import '../lead/widgets/messge_screen.dart';

/// A full-screen form screen for creating a new customer or viewing/editing
/// an existing customer (partner) in an Odoo-based CRM system.
///
/// Features:
///   • Profile picture upload/view (base64 or Odoo image_1920)
///   • Customer type selection (individual / company)
///   • Company association (for contacts)
///   • Contact details (email, phone, mobile, website)
///   • Address fields (street, city, country, state)
///   • Tags/categories (multi-select)
///   • Sales & Purchase related fields (salesperson, team, payment terms, industry…)
///   • Quick action buttons (call, message, email, location)
///   • Edit mode toggle with unsaved changes warning
///   • Dark/light theme support
///
/// This screen uses Provider for state management (CustomerFormProvider)
/// and communicates with Odoo via JSON-RPC calls.
///
/// Usage:
///   Navigator.push(
///     context,
///     MaterialPageRoute(
///       builder: (_) => NewCustomerFormScreen(
///         customerData: existingCustomerMap,  // or null
///         isNewCustomer: true,
///       ),
///     ),
///   );
class NewCustomerFormScreen extends StatefulWidget {
  final dynamic customerData;
  final bool isNewCustomer;

  const NewCustomerFormScreen(
      {super.key, required this.customerData, this.isNewCustomer = false});

  @override
  State<NewCustomerFormScreen> createState() => _NewCustomerFormScreenState();
}

/// State class managing the customer creation / edit form UI and logic.
class _NewCustomerFormScreenState extends State<NewCustomerFormScreen> {
  int? odooVersion;
  bool _hasDropdownNetworkError = false;

  @override
  void initState() {
    initialize();
    final client =
        Provider.of<OdooClientManager>(context, listen: false).client;
    Provider.of<CustomerFormProvider>(context, listen: false)
        .fetchAllCategoryList(client!);
    if (widget.isNewCustomer == false) {
      Provider.of<CustomerFormProvider>(context, listen: false)
          .fetchCustomerData(client!, widget.customerData['id']);
    } else {
      Provider.of<CustomerFormProvider>(context, listen: false)
          .clearAll(isNotify: false);
    }
    super.initState();
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    int version = prefs.getInt('version') ?? 0;
    setState(() {
      odooVersion = version;
    });
  }

  Future<void> _pickImage(BuildContext context) async {
    final provider = Provider.of<CustomerFormProvider>(context, listen: false);

    await provider.pickImageFromUser();
  }

  /// Reusable dropdown search widget with Future-loaded items,
  /// search support, and dark mode styling.
  Widget _buildDropdownSearch<T>({
    required String label,
    required Future<List<T>> itemsFuture,
    required T? selectedItem,
    required String Function(T) itemAsString,
    required void Function(T?) onChanged,
    String? hint,
    bool isDark = false,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white70 : const Color(0xff7F7F7F),
            ),
            children: isRequired
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF181A20) : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.transparent, width: 1),
          ),
          child: FutureBuilder<List<T>>(
            future: itemsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(12.0),
                  child:
                      Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }
              if (snapshot.hasError) {
                final err = snapshot.error;
                final isNetworkErr = err is SocketException ||
                    err.toString().toLowerCase().contains('socket') ||
                    err.toString().toLowerCase().contains('network') ||
                    err.toString().toLowerCase().contains('connection') ||
                    err.toString().toLowerCase().contains('timeout');
                if (isNetworkErr && !_hasDropdownNetworkError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _hasDropdownNetworkError = true);
                  });
                }
                return const SizedBox.shrink();
              }

              final items = snapshot.data ?? [];

              return DropdownSearch<T>(
                dropdownBuilder: (context, selectedItem) {
                  if (selectedItem == null) {
                    return Text(
                      hint ?? "Select",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: isDark ? Colors.white54 : Colors.grey[600],
                          fontStyle: FontStyle.italic,
                          fontSize: 16),
                    );
                  }

                  return Text(
                    itemAsString(selectedItem),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDark ? Colors.white70 : const Color(0xff000000),
                    ),
                  );
                },
                items: items,
                selectedItem: selectedItem,
                itemAsString: itemAsString,
                onChanged: onChanged,
                popupProps: PopupProps.menu(
                  fit: FlexFit.loose,
                  constraints: BoxConstraints(
                    maxHeight: items.length <= 3 ? items.length * 90.0 : 250,
                  ),
                  menuProps: MenuProps(
                    backgroundColor: isDark
                        ? const Color(0xFF23272E)
                        : Colors.white,
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: "Search...",
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF181A20)
                          : const Color(0xFFF3F4F6),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: Color(0xFFC03355),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    hintText: hint ?? "Select",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white54 : Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color: Color(0xFFC03355),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  bool _hasCreateChanges(CustomerFormProvider provider) {
    return provider.nameController.text.trim().isNotEmpty ||
        provider.phoneController.text.trim().isNotEmpty ||
        provider.mobileController.text.trim().isNotEmpty ||
        provider.emailController.text.trim().isNotEmpty ||
        provider.companyNameController.text.trim().isNotEmpty ||
        provider.selectedCompanyID != null;
  }

  /// Handles back navigation with unsaved changes warning when in edit mode.
  Future<void> _handleBack() async {
    final provider = context.read<CustomerFormProvider>();

    if (!widget.isNewCustomer && provider.isEdit) {
      if (provider.hasFormChanged()) {
        final shouldDiscard = await _showUnsavedChangesDialog(context);

        if (shouldDiscard && mounted) {
          provider.isEdit = false;
          provider.notifyListeners();
        }
        return;
      } else {
        provider.isEdit = false;
        provider.notifyListeners();
        return;
      }
    }

    if (widget.isNewCustomer && _hasCreateChanges(provider)) {
      final shouldDiscard = await _showUnsavedChangesDialog(context);
      if (!shouldDiscard) return;
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<bool> _showUnsavedChangesDialog(BuildContext context) async {
    final result = await DataLossWarningDialog.show(
      context: context,
      title: 'Discard Changes?',
      message: 'You have unsaved changes. Do you want to discard them?',
      confirmText: 'Discard',
      cancelText: 'Keep Editing',
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<CustomerFormProvider, OdooClientManager,
            CustomerDataProvider>(
        builder:
            (context, provider, clientprovider, customerdataprovider, child) {
      if (_hasDropdownNetworkError) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.isNewCustomer ? 'Create Customer' : 'Customer Details'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ErrorScreen(
            error: AppError(
              type: ErrorType.network,
              message: 'No internet connection. Please check your network and try again.',
            ),
            onRetry: () => setState(() => _hasDropdownNetworkError = false),
          ),
        );
      } else if (provider.isLoading) {
        return const ShimmerCustomerDetails();
      } else if (provider.hasError) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Customer Details'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ErrorScreen(
            error: provider.customerError ??
                AppError(
                  type: ErrorType.unknown,
                  message: 'Unable to load customer details. Please try again.',
                ),
            onRetry: () {
              if (clientprovider.client != null &&
                  widget.customerData['id'] != null) {
                provider.fetchCustomerData(
                    loading: true,
                    clientprovider.client!,
                    widget.customerData['id']);
              }
            },
          ),
        );
      } else {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return WillPopScope(
          onWillPop: () async {
            await _handleBack();
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () async {
                  await _handleBack();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              centerTitle: false,
              title: Text(
                (!widget.isNewCustomer && provider.isEdit)
                    ? "Update Customer"
                    : (widget.isNewCustomer
                        ? 'Create Customer'
                        : 'Customer Details'),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
              actions: [
                if (!provider.isEdit)
                  IconButton(
                    icon: Icon(
                      HugeIcons.strokeRoundedPencilEdit02,
                      color: Colors.black,
                      size: 22,
                    ),
                    onPressed: () async {
                      provider.toggleEdit();
                    },
                  ),
                if (provider.customerIdRaw != null)
                  IconButton(
                    icon: Icon(
                      HugeIcons.strokeRoundedMessageMultiple01,
                      color: Colors.black87,
                      size: 22,
                    ),
                    onPressed: () {
                      if (provider.customerIdRaw != null) {
                        final leadProvider = Provider.of<LeadFormProvider>(
                            context,
                            listen: false);
                        leadProvider.fetchMessages(clientprovider.client!,
                            'res.partner', provider.customerIdRaw!,
                            loading: true);
                        Navigator.push(
                            context,
                            SlidingPageTransitionRL(
                                page: MessagesScreen(
                              model: 'res.partner',
                              id: provider.customerIdRaw!,
                              leadData: {'type': 'customer'},
                            )));
                      }
                    },
                  ),
                const SizedBox(width: 8),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.18)
                              : Colors.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          provider.isEdit
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: GestureDetector(
                                        onTap: () => _pickImage(context),
                                        child: Stack(
                                          children: [
                                            ClipOval(
                                              child: (provider.selectedImageBase64 !=
                                                          null &&
                                                      provider
                                                          .selectedImageBase64!
                                                          .isNotEmpty)
                                                  ? Image.memory(
                                                      base64Decode(provider
                                                          .selectedImageBase64!),
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        color: isDark
                                                            ? Colors.grey[800]
                                                            : Colors.grey[100],
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.person,
                                                        size: 60,
                                                        color: isDark
                                                            ? Colors.white
                                                            : AppStyle
                                                                .primaryColor,
                                                      ),
                                                    ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              bottom: 0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: isDark
                                                      ? Colors.white
                                                      : AppStyle.primaryColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  HugeIcons
                                                      .strokeRoundedImageAdd02,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    _buildModernTextField(
                                      label: "Customer",
                                      controller: provider.nameController,
                                      hintText: "Enter customer name",
                                      isEditable: provider.isEdit,
                                      isDark: isDark,
                                      isRequired: true,
                                    ),
                                    _buildModernDropdown(
                                      label: 'Customer Type',
                                      value: provider.customerType,
                                      items: ['individual', 'company'],
                                      onChanged: provider.isEdit
                                          ? (value) =>
                                              provider.setCustomerType(value!)
                                          : null,
                                      isDark: isDark,
                                      isRequired: true,
                                    ),
                                    const SizedBox(height: 10),
                                    if ((provider.customerType ==
                                        'individual')) ...[
                                      Text(
                                        "Company",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: isDark
                                              ? Colors.white70
                                              : const Color(0xff7F7F7F),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? const Color(0xFF181A20)
                                              : const Color(0xFFF8F9FA),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.transparent,
                                              width: 1),
                                        ),
                                        child: Consumer<OdooClientManager>(
                                          builder:
                                              (context, clientProvider, _) {
                                            return FutureBuilder<
                                                List<CustomerItemModel>>(
                                              future: provider.fetchCompanyList(
                                                  clientProvider.client!),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                  );
                                                }

                                                final companies =
                                                    snapshot.data ?? [];

                                                final List<Map<String, dynamic>>
                                                    dropdownItems = [
                                                  {
                                                    'id': null,
                                                    'name':
                                                        "— No Company / Independent —",
                                                    'vat': null,
                                                  },
                                                  ...companies.map((company) {
                                                    final displayName = (company
                                                                .name ??
                                                            'Unnamed Company') +
                                                        (company.vat != null &&
                                                                company.vat!
                                                                    .trim()
                                                                    .isNotEmpty
                                                            ? ' - ${company.vat!.trim()}'
                                                            : '');

                                                    return {
                                                      'id': company.serverId,
                                                      'name': displayName,
                                                      'vat': company.vat,
                                                      'original': company,
                                                    };
                                                  }),
                                                ];

                                                return DropdownSearch<
                                                    Map<String, dynamic>>(
                                                  dropdownBuilder:
                                                      (context, selectedItem) {
                                                    final text =
                                                        selectedItem?['name'] ??
                                                            '';

                                                    final isHint =
                                                        text.startsWith(
                                                                "Select") ||
                                                            text.contains(
                                                                "Independent");

                                                    return Text(
                                                      text,
                                                      style: isHint
                                                          ? TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: isDark
                                                                  ? Colors
                                                                      .white54
                                                                  : Colors.grey[
                                                                      600],
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                            )
                                                          : TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: isDark
                                                                  ? Colors
                                                                      .white70
                                                                  : Color(
                                                                      0xff000000),
                                                            ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    );
                                                  },
                                                  popupProps: PopupProps.menu(
                                                    fit: FlexFit.loose,
                                                    constraints: BoxConstraints(
                                                      maxHeight: dropdownItems
                                                                  .length <=
                                                              5
                                                          ? dropdownItems
                                                                  .length *
                                                              48.0
                                                          : 250,
                                                    ),
                                                    menuProps: MenuProps(
                                                      backgroundColor: isDark
                                                          ? Colors.grey[900]
                                                          : Colors.grey[50],
                                                      elevation: 12,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                      ),
                                                    ),
                                                    showSearchBox: true,
                                                    searchFieldProps:
                                                        TextFieldProps(
                                                      decoration:
                                                          InputDecoration(
                                                        errorBorder:
                                                            InputBorder.none,
                                                        focusedErrorBorder:
                                                            InputBorder.none,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 12,
                                                          vertical: 8,
                                                        ),
                                                        hintText:
                                                            "Search company name or VAT...",
                                                        hintStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: isDark
                                                              ? Colors.white54
                                                              : Colors
                                                                  .grey[600],
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                        prefixIcon:
                                                            Icon(Icons.search),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 1.5,
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          borderSide:
                                                              BorderSide(
                                                            color: isDark
                                                                ? Colors.white
                                                                : AppStyle
                                                                    .primaryColor,
                                                            width: 2,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  items: dropdownItems,
                                                  itemAsString: (item) =>
                                                      item?['name'] ?? '',
                                                  selectedItem:
                                                      dropdownItems.firstWhere(
                                                    (element) =>
                                                        (provider.selectedCompanyID
                                                                    ?.serverId !=
                                                                null &&
                                                            element['id'] ==
                                                                provider
                                                                    .selectedCompanyID
                                                                    ?.serverId) ||
                                                        (element['id'] ==
                                                                null &&
                                                            provider.selectedCompanyID ==
                                                                null),
                                                    orElse: () => {
                                                      'id': null,
                                                      'name':
                                                          "— No Company / Independent —",
                                                    },
                                                  ),
                                                  onChanged: provider.isEdit
                                                      ? (val) {
                                                          FocusScope.of(context)
                                                              .unfocus();

                                                          if (val != null &&
                                                              val['id'] !=
                                                                  null) {
                                                            final selectedCompany =
                                                                companies
                                                                    .firstWhere(
                                                              (c) =>
                                                                  c.serverId ==
                                                                  val['id'],
                                                              orElse: () =>
                                                                  CustomerItemModel(),
                                                            );

                                                            provider.selectedCompanyID =
                                                                selectedCompany;
                                                            provider
                                                                .notifyListeners();

                                                            provider
                                                                .fetchAddressData(
                                                              client:
                                                                  clientProvider
                                                                      .client!,
                                                              customerId:
                                                                  selectedCompany
                                                                          .serverId ??
                                                                      0,
                                                            );
                                                          } else {
                                                            provider.selectedCompanyID =
                                                                null;
                                                            provider
                                                                .notifyListeners();

                                                            provider
                                                                .streetController
                                                                .clear();
                                                            provider
                                                                .street2Controller
                                                                .clear();
                                                            provider
                                                                .cityController
                                                                .clear();
                                                            provider
                                                                .zipController
                                                                .clear();
                                                            provider.selectedCountry =
                                                                null;
                                                            provider.selectedState =
                                                                null;
                                                            provider
                                                                .locationController
                                                                .clear();
                                                          }
                                                        }
                                                      : null,
                                                  dropdownDecoratorProps:
                                                      DropDownDecoratorProps(
                                                    dropdownSearchDecoration:
                                                        InputDecoration(
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .all(Radius.circular(12)),
                                                        borderSide: BorderSide(
                                                          color:
                                                              Color(0xFFC03355),
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 16,
                                                              vertical: 12),
                                                      hintText:
                                                          "Select company (optional)",
                                                      hintStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: isDark
                                                            ? Colors.white54
                                                            : Colors.grey[600],
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    ),
                                                  ),
                                                  validator: (value) => null,
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 15),
                                    if ((provider.customerType ==
                                        'individual')) ...[
                                      _buildModernTextField(
                                        label: "Position",
                                        controller:
                                            provider.jobPositionController,
                                        hintText: "Job Position",
                                        isEditable: provider.isEdit,
                                        isDark: isDark,
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        InkWell(
                                          onTap: widget.isNewCustomer
                                              ? () =>
                                                  provider?.pickImageFromUser()
                                              : () async {
                                                  final result =
                                                      await CompanySessionManager
                                                          .callKwWithCompany({
                                                    'model': 'res.partner',
                                                    'method': 'search_read',
                                                    'args': [
                                                      [
                                                        [
                                                          'id',
                                                          '=',
                                                          widget.customerData[
                                                              'id']
                                                        ]
                                                      ]
                                                    ],
                                                    'kwargs': {
                                                      'fields': ['image_1920'],
                                                      'limit': 1,
                                                    },
                                                  });
                                                  if (result != null &&
                                                      result.isNotEmpty) {
                                                    final imageBase64 =
                                                        result[0]['image_1920'];
                                                    if (imageBase64 != null &&
                                                        imageBase64 !=
                                                            'false') {
                                                      final imageData =
                                                          base64Decode(
                                                              imageBase64);
                                                      Navigator.push(
                                                        context,
                                                        SlidingPageTransitionRL(
                                                          page: FullScreenImage(
                                                            imageProvider:
                                                                MemoryImage(Uint8List
                                                                    .fromList(
                                                                        imageData)),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                          child: ClipOval(
                                            child: widget.isNewCustomer
                                                ? Base64ImageView(
                                                    base64String: provider
                                                        .selectedImageBase64,
                                                    size: 80,
                                                    borderRadius: 40,
                                                  )
                                                : OdooByteImage(
                                                    squareBorderRadius: 40,
                                                    shape: ImageShape.circle,
                                                    size: 80,
                                                    model: 'res.partner',
                                                    recordId: widget
                                                        .customerData['id'],
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            provider.nameController.text
                                                    .isNotEmpty
                                                ? provider.nameController.text
                                                : 'New Customer',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width < 360 ? 18 : 22,
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? Colors.white
                                                  : const Color(0xFF1A1A1A),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                          const SizedBox(height: 3),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                  provider.customerType ==
                                                          'company'
                                                      ? HugeIcons
                                                          .strokeRoundedBuilding02
                                                      : HugeIcons
                                                          .strokeRoundedUser,
                                                  color: isDark
                                                      ? Colors.white54
                                                      : Colors.black54,
                                                  size: 14),
                                              const SizedBox(width: 3),
                                              Text(
                                                provider.customerType ==
                                                        'company'
                                                    ? 'Company'
                                                    : 'Customer',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isDark
                                                      ? Colors.white60
                                                      : Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (provider.emailController
                                              .text.isNotEmpty) ...[
                                            const SizedBox(height: 3),
                                            Row(
                                              children: [
                                                Icon(
                                                    HugeIcons.strokeRoundedMail01,
                                                    color: isDark
                                                        ? Colors.white54
                                                        : Colors.black54,
                                                    size: 14),
                                                const SizedBox(width: 4),
                                                Flexible(
                                                  child: Text(
                                                    provider.emailController
                                                        .text,
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(context).size.width < 360 ? 10 : 12,
                                                      color: isDark
                                                          ? Colors.white60
                                                          : Colors.black54,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                          if (provider.jobPositionController
                                              .text.isNotEmpty) ...[
                                            const SizedBox(height: 3),
                                            Row(
                                              children: [
                                                Icon(
                                                    HugeIcons
                                                        .strokeRoundedNewJob,
                                                    color: isDark
                                                        ? Colors.white54
                                                        : Colors.black54,
                                                    size: 14),
                                                const SizedBox(width: 4),
                                                Flexible(
                                                  child: Text(
                                                    provider.jobPositionController
                                                        .text,
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(context).size.width < 360 ? 10 : 12,
                                                      color: isDark
                                                          ? Colors.white60
                                                          : Colors.black54,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                          if (!provider.isEdit) ...[
                            const SizedBox(height: 10),
                            Divider(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.grey.shade200,
                              thickness: 1,
                            ),
                            const SizedBox(height: 12),
                            _buildQuickActionButtons(isDark, provider),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (provider.isEdit) ...[
                    _buildExpansionTile(
                      title: "Contact Information",
                      isDark: isDark,
                      children: [
                        _buildModernTextField(
                          label: "Email",
                          controller: provider.emailController,
                          hintText: "Enter email address",
                          isEditable: provider.isEdit,
                          isDark: isDark,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        if ((odooVersion ?? 0) <= 18) ...[
                          _buildModernTextField(
                            label: "Mobile",
                            controller: provider.mobileController,
                            hintText: "Enter mobile number",
                            isEditable: provider.isEdit,
                            isDark: isDark,
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                        _buildModernTextField(
                          label: "Phone",
                          controller: provider.phoneController,
                          hintText: "Enter phone number",
                          isEditable: provider.isEdit,
                          isDark: isDark,
                          keyboardType: TextInputType.phone,
                        ),
                        _buildModernTextField(
                          label: "Website",
                          controller: provider.websiteController,
                          hintText: "Enter website URL",
                          isEditable: provider.isEdit,
                          isDark: isDark,
                          keyboardType: TextInputType.url,
                        ),
                        if (provider.isEdit == false) ...[
                          _buildModernTextField(
                            label: "Address",
                            controller: provider.locationController,
                            hintText: "Address (Cannot edit this field)",
                            isEditable: false,
                            isDark: isDark,
                          ),
                        ],
                      ],
                    ),
                  ] else ...[
                    _buildExpansionTile(
                      title: "Contact Information",
                      isDark: isDark,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Email",
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Expanded(
                              child: Text(
                                provider.emailController.text.isEmpty
                                    ? "None"
                                    : provider.emailController.text.toString(),
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        if ((odooVersion ?? 0) <= 18) ...[
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Mobile",
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Expanded(
                                child: Text(
                                  provider.mobileController.text.isEmpty
                                      ? "None"
                                      : provider.mobileController.text
                                          .toString(),
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        ],
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Phone",
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Expanded(
                              child: Text(
                                provider.phoneController.text.isEmpty
                                    ? "None"
                                    : provider.phoneController.text.toString(),
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Website",
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Expanded(
                              child: Text(
                                provider.websiteController.text.isEmpty
                                    ? "None"
                                    : provider.websiteController.text
                                        .toString(),
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Address",
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Expanded(
                              child: Text(
                                provider.locationController.text.isEmpty
                                    ? "None"
                                    : provider.locationController.text
                                        .toString(),
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                  if (provider.isEdit == true)
                    _buildExpansionTile(
                      title: "Address Information",
                      isDark: isDark,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Country",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xff7F7F7F),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF181A20)
                                    : const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              child: SingleSelectSearchableFuture<Country>(
                                items: [],
                                idSelector: (item) => item.id,
                                initialValue: provider.selectedCountry,
                                displayText: (country) => country.name,
                                onSelectionChanged: (country) {
                                  if (country != null) {
                                    setState(() {
                                      provider.selectedCountry = country;
                                      provider.selectedState = null;
                                    });
                                  } else {
                                    setState(() {
                                      provider.selectedCountry = null;
                                    });
                                  }
                                },
                                hintText: 'Select a country',
                                onEmptyItemsFetch: () async {
                                  final countrylist =
                                      await CompanySessionManager
                                          .callKwWithCompany({
                                    'model': 'res.country',
                                    'method': 'search_read',
                                    'args': [[]],
                                    'kwargs': {
                                      'fields': ['id', 'name']
                                    },
                                  });
                                  return (countrylist as List<dynamic>)
                                      .map((item) => Country.fromJson(
                                          item as Map<String, dynamic>))
                                      .toList();
                                },
                                isEditable: provider.isEdit,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (provider.selectedCountry != null) ...[
                              Text(
                                "State",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? Colors.white70
                                      : const Color(0xff7F7F7F),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF181A20)
                                      : const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.08)
                                        : Colors.grey.shade200,
                                    width: 1,
                                  ),
                                ),
                                child: SingleSelectSearchableFuture<StateClass>(
                                  refresh: true,
                                  items: [],
                                  idSelector: (item) => item.id,
                                  clear: provider.selectedCountry == null,
                                  initialValue: provider.selectedState,
                                  displayText: (state) => state.name,
                                  onSelectionChanged: (state) {
                                    if (state != null) {
                                      setState(() {
                                        provider.selectedState = state;
                                      });
                                    }
                                  },
                                  showMessage: provider.selectedCountry == null,
                                  message: "Select s country first",
                                  hintText: 'Select a State',
                                  onEmptyItemsFetch: () async {
                                    final stateList =
                                        await CompanySessionManager
                                            .callKwWithCompany({
                                      'model': 'res.country.state',
                                      'method': 'search_read',
                                      'args': [
                                        [
                                          [
                                            'country_id',
                                            '=',
                                            provider.selectedCountry!.id
                                          ]
                                        ]
                                      ],
                                      'kwargs': {
                                        'fields': ['id', 'name', 'country_id']
                                      },
                                    });
                                    return (stateList as List<dynamic>)
                                        .map((item) => StateClass.fromJson(
                                            item as Map<String, dynamic>))
                                        .toList();
                                  },
                                  isEditable: provider.isEdit &&
                                      provider.selectedCountry != null,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                            _buildModernTextField(
                              label: "City",
                              controller: provider.cityController,
                              hintText: "Enter city",
                              isEditable: provider.checkType == 'contact' &&
                                  provider.data['parent_id'] == null &&
                                  provider.isEdit,
                              isDark: isDark,
                            ),
                            _buildModernTextField(
                              label: "Street",
                              controller: provider.streetController,
                              hintText: "Enter street address",
                              isEditable: provider.checkType == 'contact' &&
                                  provider.data['parent_id'] == null &&
                                  provider.isEdit,
                              isDark: isDark,
                            ),
                            _buildModernTextField(
                              label: "Street 2",
                              controller: provider.street2Controller,
                              hintText: "Enter additional address",
                              isEditable: provider.checkType == 'contact' &&
                                  provider.data['parent_id'] == null &&
                                  provider.isEdit,
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  _buildExpansionTile(
                    title: "Categories",
                    isDark: isDark,
                    children: [
                      provider.isEdit
                          ? Container(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF181A20)
                                    : const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              child: MultiSelectSearchableDropdown<Category>(
                                idSelector: (item) => item.id,
                                iseditable: provider.isEdit,
                                initialValue: provider.categoyListValues,
                                items: provider.allCategoryList,
                                displayText: (item) => item.name,
                                onSelectionChanged: (item) {
                                  setState(() {
                                    provider.selectedCategoriesId =
                                        item.map((e) => e.id).toList();
                                  });
                                },
                                hintText: "Select Tags",
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tags',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Wrap(
                                      alignment: WrapAlignment.end,
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: provider.selectedCategoriesId
                                          .map((tagId) {
                                        try {
                                          final tag = provider.allCategoryList
                                              .firstWhere(
                                            (t) => t.id == tagId,
                                          );

                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFCE7EE),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: const Color(0xFFC03355)
                                                    .withValues(alpha: 0.35),
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              tag.name,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFFC03355),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          );
                                        } catch (_) {
                                          return const SizedBox.shrink();
                                        }
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                  _buildExpansionTile(
                    title: "Sales & Purchase",
                    isDark: isDark,
                    children: [
                      provider.isEdit
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sales",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF1A1A1A),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildDropdownSearch<CustomerItemModel>(
                                  label: "Salesperson",
                                  itemsFuture: provider.fetchSalespersons(
                                      clientprovider.client!),
                                  selectedItem: provider.selectedSalesperson,
                                  itemAsString: (item) =>
                                      item?.name ?? 'Unnamed',
                                  onChanged: (val) {
                                    provider.selectedSalesperson = val;
                                    provider.notifyListeners();
                                  },
                                  hint: "Select salesperson",
                                  isDark: isDark,
                                ),
                                if ((odooVersion ?? 0) < 18) ...[
                                  const SizedBox(height: 10),
                                  _buildDropdownSearch<CustomerItemModel>(
                                    label: "Sales Team",
                                    itemsFuture: provider.fetchSalesTeams(
                                        clientprovider.client!),
                                    selectedItem: provider.selectedSalesTeam,
                                    itemAsString: (item) =>
                                        item?.name ?? 'Unnamed',
                                    onChanged: (val) {
                                      provider.selectedSalesTeam = val;
                                      provider.notifyListeners();
                                    },
                                    hint: "Select Sales Team",
                                    isDark: isDark,
                                  ),
                                ],
                                if (provider.isSaleInstalled) ...[
                                  const SizedBox(height: 10),
                                  _buildDropdownSearch<AccountPaymentTerm>(
                                    label: "Customer Payment Terms",
                                    itemsFuture: provider.fetchPaymentTerms(
                                        clientprovider.client!),
                                    selectedItem:
                                        provider.selectedCustomerPaymentTerm,
                                    itemAsString: (item) =>
                                        item?.name ?? 'Unnamed',
                                    onChanged: (val) {
                                      provider.selectedCustomerPaymentTerm =
                                          val;
                                      provider.notifyListeners();
                                    },
                                    hint: "Select Payment Terms",
                                    isDark: isDark,
                                  ),
                                ],
                                const SizedBox(height: 20),
                                Text(
                                  "Misc",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF1A1A1A),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildModernTextField(
                                  label: "Company ID",
                                  controller:
                                      provider.companyRegistryController,
                                  hintText: "Enter Company ID",
                                  isEditable: provider.isEdit,
                                  isDark: isDark,
                                ),
                                const SizedBox(height: 10),
                                _buildModernTextField(
                                  label: "Reference",
                                  controller: provider.referenceController,
                                  hintText: "Enter Reference",
                                  isEditable: provider.isEdit,
                                  isDark: isDark,
                                ),
                                const SizedBox(height: 10),
                                _buildDropdownSearch<IndustryModel>(
                                  label: "Industry",
                                  itemsFuture: provider
                                      .fetchIndustries(clientprovider.client!),
                                  selectedItem: provider.selectedIndustry,
                                  itemAsString: (item) =>
                                      item?.name ?? 'Unnamed',
                                  onChanged: (val) {
                                    provider.selectedIndustry = val;
                                    provider.notifyListeners();
                                  },
                                  hint: "Select Industry",
                                  isDark: isDark,
                                ),
                                if (provider.isSaleInstalled) ...[
                                  const SizedBox(height: 20),
                                  Text(
                                    "Purchase",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildDropdownSearch<AccountPaymentTerm>(
                                    label: "Payment Terms",
                                    itemsFuture: provider.fetchPaymentTerms(
                                        clientprovider.client!),
                                    selectedItem:
                                        provider.selectedSupplierPaymentTerm,
                                    itemAsString: (item) =>
                                        item?.name ?? 'Unnamed',
                                    onChanged: (val) {
                                      provider.selectedSupplierPaymentTerm =
                                          val;
                                      provider.notifyListeners();
                                    },
                                    hint: "Select Payment Terms",
                                    isDark: isDark,
                                  ),
                                  if ((odooVersion ?? 0) < 18) ...[
                                    const SizedBox(height: 10),
                                    _buildDropdownSearch<AccountPaymentMethod>(
                                      label: "Payment Method",
                                      itemsFuture: provider.fetchPaymentMethod(
                                          clientprovider.client!),
                                      selectedItem:
                                          provider.selectedPaymentMethod,
                                      itemAsString: (item) =>
                                          item?.name ?? 'Unnamed',
                                      onChanged: (val) {
                                        provider.selectedPaymentMethod = val;
                                        provider.notifyListeners();
                                      },
                                      hint: "Select Method",
                                      isDark: isDark,
                                    ),
                                  ],
                                ],
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sales",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF1A1A1A),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Salesperson",
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Expanded(
                                          child: Text(
                                            provider.selectedSalesperson
                                                    ?.name ??
                                                "None",
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    if ((odooVersion ?? 0) < 18) ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Sales Team",
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.grey[400]
                                                  : Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          Expanded(
                                            child: Text(
                                              provider.selectedSalesTeam
                                                      ?.name ??
                                                  "None",
                                              style: TextStyle(
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Payment Terms",
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Expanded(
                                          child: Text(
                                            provider.selectedCustomerPaymentTerm
                                                    ?.name ??
                                                "None",
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Misc",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF1A1A1A),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Company ID",
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Expanded(
                                          child: Text(
                                            provider.companyRegistryController
                                                        .text.isEmpty ||
                                                    provider.companyRegistryController
                                                            .text ==
                                                        "false"
                                                ? "None"
                                                : provider
                                                    .companyRegistryController
                                                    .text,
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Reference",
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Expanded(
                                          child: Text(
                                            provider.referenceController.text
                                                    .isEmpty
                                                ? "None"
                                                : provider
                                                    .referenceController.text
                                                    .toString(),
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Industry",
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Expanded(
                                          child: Text(
                                            provider.selectedIndustry?.name ??
                                                "None",
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Purchase",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF1A1A1A),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Payment Terms",
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Expanded(
                                          child: Text(
                                            provider.selectedSupplierPaymentTerm
                                                    ?.name ??
                                                "None",
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    if ((odooVersion ?? 0) < 18) ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Payment Method",
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.grey[400]
                                                  : Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          Expanded(
                                            child: Text(
                                              provider.selectedPaymentMethod
                                                      ?.name ??
                                                  "None",
                                              style: TextStyle(
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            bottomNavigationBar: !provider.isEdit
                ? null
                : ListenableBuilder(
                    listenable: Listenable.merge(
                        [provider.formFieldsListenable, provider]),
                    builder: (context, _) {
                      final bool isDisabled =
                          provider.nameController.text.trim().isEmpty ||
                              (provider.customerIdRaw != null &&
                                  !provider.hasFormChanged());
                      return Container(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: TextButton(
                            onPressed: isDisabled
                                ? null
                                : () async {
                                    if (provider.customerIdRaw != null) {
                                      bool success =
                                          await provider.saveCustomerData(
                                              clientprovider.client!,
                                              provider.customerIdRaw!,
                                              context);
                                      if (success && context.mounted) {
                                        await customerdataprovider
                                            .fetchCustomerData(
                                                context: context);
                                      }
                                    } else {
                                      provider.createCustomerData(context);
                                    }
                                    await ReviewService()
                                        .trackSignificantEvent();
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) async {
                                      if (mounted) {
                                        await ReviewService()
                                            .checkAndShowRating(context);
                                      }
                                    });
                                  },
                            style: TextButton.styleFrom(
                              backgroundColor: AppStyle.primaryColor,
                              disabledBackgroundColor: isDark
                                  ? Colors.grey[700]!
                                  : Colors.grey[400]!,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(13),
                            ),
                            child: Text(
                              provider.customerIdRaw != null
                                  ? "Save Changes"
                                  : "Create Customer",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        );
      }
    });
  }

  /// Builds a modern-looking text field with label, consistent styling,
  /// and dark mode support.
  Widget _buildModernTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required bool isEditable,
    required bool isDark,
    TextInputType? keyboardType,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white70 : const Color(0xff7F7F7F),
            ),
            children: isRequired
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent, width: 1),
          ),
          child: TextFormField(
            controller: controller,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : const Color(0xff000000),
            ),
            enabled: isEditable,
            keyboardType: keyboardType,
            cursorColor: AppStyle.primaryColor,
            decoration: InputDecoration(
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: TextStyle(fontWeight: FontWeight.w600).fontFamily,
                color: isDark ? Colors.grey[500] : Colors.grey[500],
                fontStyle: FontStyle.italic,
                fontSize: 14,
                height: 1.0,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1.5,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(
                  color: Color(0xFFC03355),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// Builds a styled dropdown for simple string selections (e.g. customer type)
  Widget _buildModernDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?)? onChanged,
    required bool isDark,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white70 : const Color(0xff7F7F7F),
            ),
            children: isRequired
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF181A20) : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent, width: 1),
          ),
          child: DropdownButtonFormField2<String>(
            isDense: true,
            alignment: Alignment.centerLeft,
            value: items.contains(value) ? value : null,
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              hintStyle: TextStyle(
                fontFamily: TextStyle(fontWeight: FontWeight.w600).fontFamily,
                color: isDark ? Colors.grey[500] : Colors.grey[500],
                fontStyle: FontStyle.italic,
                fontSize: 14,
                height: 1.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1.5,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(
                  color: Color(0xFFC03355),
                  width: 1.5,
                ),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 250,
              offset: const Offset(0, 2),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF23272E) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            selectedItemBuilder: (context) {
              return items.map((item) {
                return Text(
                  item[0].toUpperCase() + item.substring(1),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : const Color(0xff000000),
                  ),
                );
              }).toList();
            },
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : const Color(0xff000000),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item[0].toUpperCase() + item.substring(1),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Builds circular quick action buttons (Call, Message, Email, Location)
  Widget _buildQuickActionButtons(bool isDark, CustomerFormProvider provider) {
    bool isReal(String? v) =>
        v != null && v.trim().isNotEmpty && v.trim().toLowerCase() != 'false';

    final List<Map<String, dynamic>> actions = [
      {
        'icon': HugeIcons.strokeRoundedCall,
        'label': 'Call',
        'color': Colors.blue,
        'isEnabled': isReal(provider.phoneController.text) ||
            isReal(provider.mobileController.text),
        'onTap': () => _handleCall(provider),
      },
      {
        'icon': HugeIcons.strokeRoundedMessage01,
        'label': 'SMS',
        'color': Colors.orange,
        'isEnabled': isReal(provider.phoneController.text) ||
            isReal(provider.mobileController.text),
        'onTap': () => _handleSMS(provider),
      },
      {
        'icon': HugeIcons.strokeRoundedWhatsapp,
        'label': 'WhatsApp',
        'color': Colors.green,
        'isEnabled': isReal(provider.phoneController.text) ||
            isReal(provider.mobileController.text),
        'onTap': () => _handleWhatsApp(provider),
      },
      {
        'icon': HugeIcons.strokeRoundedMail02,
        'label': 'Email',
        'color': Colors.red,
        'isEnabled': isReal(provider.emailController.text),
        'onTap': () => _handleEmail(provider),
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions.map((action) {
        return _buildActionButton(
          icon: action['icon'],
          label: action['label'],
          color: action['color'],
          onTap: action['onTap'],
          isDark: isDark,
          isEnabled: action['isEnabled'] ?? true,
        );
      }).toList(),
    );
  }

  /// Creates consistent action button UI used in quick actions row
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
    bool isEnabled = true,
  }) {
    final effectiveColor =
        isEnabled ? color : (isDark ? Colors.grey[600]! : Colors.grey[400]!);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        splashColor: effectiveColor.withOpacity(0.2),
        highlightColor: effectiveColor.withOpacity(0.1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: effectiveColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: effectiveColor,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// Builds modern ExpansionTile with shadow card style, used for
  /// grouping related form sections (Contact, Address, Categories, Sales…)
  Widget _buildExpansionTile({
    required String title,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF23272E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: false,
          iconColor: AppStyle.primaryColor,
          collapsedIconColor: Colors.grey[600],
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          children: children,
        ),
      ),
    );
  }

  /// Opens phone dialer with multiple fallback strategies.
  void _handleCall(CustomerFormProvider provider) async {
    final phone = provider.phoneController.text.isNotEmpty
        ? provider.phoneController.text
        : null;

    if (phone != null && phone.isNotEmpty) {
      try {
        String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
        if (cleanPhone.isEmpty) {
          CustomSnackbar.showError(context, 'Invalid phone number format');

          return;
        }
        bool launched = false;
        List<String> attemptedMethods = [];
        try {
          final String telUrl = 'tel:${Uri.encodeComponent(cleanPhone)}';
          final Uri uri = Uri.parse(telUrl);
          attemptedMethods.add('Method 1: $telUrl');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
            launched = true;
          }
        } catch (_) {}

        if (!launched) {
          try {
            final Uri uri = Uri(scheme: 'tel', path: cleanPhone);
            attemptedMethods.add('Method 2: ${uri.toString()}');
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
              launched = true;
            }
          } catch (_) {}
        }

        if (!launched) {
          try {
            final Uri uri = Uri.parse('tel:$cleanPhone');
            attemptedMethods.add('Method 3: tel:$cleanPhone');
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
              launched = true;
            }
          } catch (_) {}
        }

        if (!launched && cleanPhone.startsWith('+')) {
          try {
            String phoneWithoutPlus = cleanPhone.substring(1);
            final Uri uri = Uri.parse('tel:$phoneWithoutPlus');
            attemptedMethods.add('Method 4: tel:$phoneWithoutPlus');
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
              launched = true;
            }
          } catch (_) {}
        }

        if (!launched) {
          try {
            final Uri uri = Uri.parse('tel:$cleanPhone');
            attemptedMethods.add('Method 5: Platform default');
            await launchUrl(uri, mode: LaunchMode.platformDefault);
            launched = true;
          } catch (_) {}
        }

        if (launched) {
          CustomSnackbar.showSuccess(
              context, 'Opening dialer for $cleanPhone...');
        } else {
          CustomSnackbar.showError(context,
              'Could not open dialer. No compatible dialer app found.');

          _showDialerErrorDialog(cleanPhone, attemptedMethods);
        }
      } catch (e) {
        CustomSnackbar.showError(
            context, 'Error opening dialer: ${e.toString()}');
      }
    } else {
      _showDisabledActionFeedback('No phone number available for this contact');
    }
  }

  /// Sends an SMS message to the provided phone number.
  void _handleSMS(CustomerFormProvider provider) async {
    final phone = provider.phoneController.text.isNotEmpty
        ? provider.phoneController.text
        : provider.mobileController.text;

    if (phone.isNotEmpty) {
      try {
        String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
        if (cleanPhone.isEmpty) {
          CustomSnackbar.showError(context, 'Invalid phone number format');
          return;
        }

        final Uri uri = Uri(scheme: 'sms', path: cleanPhone);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          CustomSnackbar.showSuccess(context, 'Opening SMS for $cleanPhone...');
        } else {
          CustomSnackbar.showError(context, 'Could not open SMS app');
        }
      } catch (e) {
        CustomSnackbar.showError(context, 'Error opening SMS: ${e.toString()}');
      }
    } else {
      _showDisabledActionFeedback('No phone number available for messaging');
    }
  }

  /// Opens a WhatsApp chat with the provided number.
  void _handleWhatsApp(CustomerFormProvider provider) async {
    final phone = provider.phoneController.text.isNotEmpty
        ? provider.phoneController.text
        : provider.mobileController.text;

    if (phone.isNotEmpty) {
      try {
        String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
        if (cleanPhone.isEmpty) {
          CustomSnackbar.showError(context, 'Invalid phone number format');
          return;
        }

        final Uri uri = Uri.parse('https://wa.me/$cleanPhone');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          CustomSnackbar.showSuccess(
              context, 'Opening WhatsApp for $cleanPhone...');
        } else {
          CustomSnackbar.showError(context, 'Could not open WhatsApp');
        }
      } catch (e) {
        CustomSnackbar.showError(
            context, 'Error opening WhatsApp: ${e.toString()}');
      }
    } else {
      _showDisabledActionFeedback('No phone number available for WhatsApp');
    }
  }

  /// Opens default email client with pre-filled recipient.
  void _handleEmail(CustomerFormProvider provider) async {
    final email = provider.emailController.text;

    if (email.isNotEmpty) {
      try {
        final Uri uri = Uri.parse('mailto:$email');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
          CustomSnackbar.showSuccess(context, 'Opening email for $email...');
        } else {
          CustomSnackbar.showError(context, 'Could not open email client');
        }
      } catch (e) {
        CustomSnackbar.showError(
            context, 'Error opening email: ${e.toString()}');
      }
    } else {
      _showDisabledActionFeedback(
          'No email address available for this contact');
    }
  }

  void _showDisabledActionFeedback(String message) {
    CustomSnackbar.showWarning(context, message);
  }

  void _showDialerErrorDialog(
      String phoneNumber, List<String> attemptedMethods) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.orange,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Dialer Not Available',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Unable to open dialer for: $phoneNumber',
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Possible solutions:',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '• Install a phone dialer app\n• Check if phone permissions are granted\n• Try copying the number manually',
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.content_copy,
                    size: 16,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      phoneNumber,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              CustomSnackbar.showInfo(context, 'Phone number: $phoneNumber');
            },
            child: Text(
              'Copy Number',
              style: TextStyle(
                color: const Color(0xFFD32F2F),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'OK',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigates to SelectLocationScreen and handles returned coordinates/address.
  Future<void> _openLocationSelector(CustomerFormProvider provider) async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectLocationScreen(
            initialLatitude: provider.lat,
            initialLongitude: provider.long,
            onLocationSelected: (latitude, longitude) {
              provider.setLocation(latitude, longitude);
            },
          ),
        ),
      );

      if (result != null && result is Map<String, dynamic>) {
        final latitude = result['latitude'] as double?;
        final longitude = result['longitude'] as double?;
        final address = result['address'] as String?;

        if (latitude != null && longitude != null) {
          provider.setLocation(latitude, longitude);

          if (address != null && address.isNotEmpty) {
            provider.locationController.text = address;
          }

          await provider.updateAddressFromLocation();
          CustomSnackbar.showSuccess(context, 'Location updated successfully!');
        }
      }
    } catch (e) {
      CustomSnackbar.showError(
          context, 'Error setting location: ${e.toString()}');
    }
  }

  /// Attempts to geocode current address → lat/long using provider method.
  Future<void> _getLocationFromAddress(CustomerFormProvider provider) async {
    try {
      CustomSnackbar.showInfo(context, 'Getting location from address...');

      await provider.updateLocationFromAddress();

      if (provider.hasLocation) {
        CustomSnackbar.showSuccess(context, 'Location found from address!');
      } else {
        CustomSnackbar.showWarning(
            context, 'Could not find location for this address');
      }
    } catch (e) {
      CustomSnackbar.showError(
          context, 'Error getting location: ${e.toString()}');
    }
  }
}
