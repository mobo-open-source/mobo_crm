import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/global_methods/services/global_error_handler.dart';
import 'package:mobo_crm/global_methods/widgets/date_picker/custom_date_picker.dart';
import 'package:mobo_crm/global_methods/widgets/shimmer/custom_shimmer.dart';
import 'package:mobo_crm/global_methods/widgets/stage_widget.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/custom_editing_fields.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/future_single_selection_textfield.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/single_selection_textfield.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/models.dart';
import 'package:mobo_crm/models/quotation_model/quotation_model.dart';
import 'package:mobo_crm/screens/invoice/invoice_list_view.dart';
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_form_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_view_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotebuilder_provider.dart';
import 'package:mobo_crm/screens/quotation/widgets/quotation_tab_bar.dart';
import 'package:mobo_crm/utils/globals.dart';
import 'package:mobo_crm/utils/snackbar.dart';
import 'package:provider/provider.dart';

import '../../Rating/review_service.dart';
import '../../core/company/session/company_session_manager.dart';
import '../../core/navigation/data_loss_warning_dialog.dart';

/// A StatefulWidget that provides a detailed form for creating or editing
/// a quotation in the CRM system.
///
/// This widget handles both the "new quotation" and "edit quotation" flows,
/// including customer selection, quotation templates, payment terms, and
/// expiration/quotation dates. It also manages fetching associated invoice IDs
/// if an existing sale order is being edited.
///
/// Features:
/// - Display quotation information (name, customer, status, totals).
/// - Edit mode with form fields for customer, template, dates, and payment terms.
/// - Fetch and view invoices linked to a sale order.
/// - Handle unsaved changes with a warning dialog.
/// - Popup menu for actions: Cancel, Confirm, Email, Create Invoice, View Invoices.
///
/// Example usage:
/// ```dart
/// NewQuotationForm(
///   leadid: 123,
///   ordersaleid: 456,
///   isNew: true,
/// )
/// ```
class NewQuotationForm extends StatefulWidget {
  final int? leadid;
  final int? ordersaleid;
  final bool isNew;

  const NewQuotationForm({
    super.key,
    this.leadid,
    this.ordersaleid,
    this.isNew = false,
  });

  @override
  State<NewQuotationForm> createState() => _NewQuotationFormState();
}

/// The state class for [NewQuotationForm] handling form logic, UI, and
/// data fetching.
class _NewQuotationFormState extends State<NewQuotationForm> with RouteAware {
  List<int> invoiceIds = [];
  bool isFetchingInvoices = false;
  bool isCreate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final quotationProvider =
          Provider.of<QuotationFormProvider>(context, listen: false);
      quotationProvider.canManageSkills();
      final clientManager =
          Provider.of<OdooClientManager>(context, listen: false);
      final client = clientManager.client!;
      quotationProvider.checkSaleModuleInstallation(client);

      if (widget.isNew) {
        quotationProvider.resetForCreate();
        setState(() {
          isCreate = true;
        });
      }

      if (widget.ordersaleid != null) {
        fetchInvoiceIds();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      RouteObserver<ModalRoute>().subscribe(this, modalRoute);
    }
  }

  @override
  void didPopNext() {
    if (widget.ordersaleid != null) {
      fetchInvoiceIds();
    }
  }

  @override
  void dispose() {
    RouteObserver<ModalRoute>().unsubscribe(this);
    super.dispose();
  }

  /// Fetches invoice IDs associated with the current sale order.
  Future<void> fetchInvoiceIds() async {
    setState(() => isFetchingInvoices = true);
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'sale.order',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['id', '=', widget.ordersaleid]
          ],
          'fields': ['invoice_ids'],
          'limit': 1,
        },
      });

      if (response.isNotEmpty && response[0]['invoice_ids'] is List) {
        setState(() {
          invoiceIds = List<int>.from(response[0]['invoice_ids']);
        });
      } else {
        setState(() {
          invoiceIds = [];
        });
      }
    } catch (e) {
      CustomSnackbar.showError(context, 'Failed to fetch invoices: $e');
    } finally {
      setState(() => isFetchingInvoices = false);
    }
  }

  bool _hasCreateChanges(QuotationFormProvider provider) {
    return provider.selectedpartnerid != null ||
        provider.referenceController.text.trim().isNotEmpty ||
        provider.documentController.text.trim().isNotEmpty ||
        provider.addressController.text.trim().isNotEmpty;
  }

  /// Handles back navigation, showing an unsaved changes dialog if needed.
  Future<void> _handleBack() async {
    final provider = context.read<QuotationFormProvider>();

    if (!isCreate && provider.isEdit) {
      final shouldDiscard = await _showUnsavedChangesDialog(context);

      if (shouldDiscard && mounted) {
        provider.isEdit = false;
        provider.notifyListeners();
      }
      return;
    }

    if (isCreate && _hasCreateChanges(provider)) {
      final shouldDiscard = await _showUnsavedChangesDialog(context);
      if (!shouldDiscard) return;
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  /// Displays a warning dialog if there are unsaved changes.
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
    return Consumer5<QuotationFormProvider, OdooClientManager,
        QuoteBuilderProvider, QuotationViewProvider, LeadFormProvider>(
      builder: (context, provider, clientprovider, quotebuilderprovider,
          quotationviewprovider, messageprovider, child) {
        if (provider.isLoading || isFetchingInvoices) {
          return const ShimmerQuotationDetail();
        } else if (provider.hasError && provider.quoteError != null) {
          return ErrorScreen(
            error: provider.quoteError!,
            goBack: true,
            onRetry: () {
              provider.fetchAndReplaceOrderLines(
                provider.saleId!,
                clientprovider.client!,
                clientprovider.currentsession!,
                provider.productlinedata,
                context,
                loading: true,
              );
            },
          );
        } else {
          return WillPopScope(
            onWillPop: () async {
              await _handleBack();
              return false;
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.grey[50],
              appBar: AppBar(
                backgroundColor: Colors.grey[50],
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 0,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () async {
                    await _handleBack();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.black, size: 20),
                ),
                centerTitle: false,
                title: Text(
                  (!isCreate && provider.isEdit)
                      ? "Update Quotation"
                      : (isCreate ? "Create Quotation" : 'Quotation Details'),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
                actions: [
                  if (provider.isAbsorbed == false)
                    if (!provider.isEdit)
                      IconButton(
                        icon: Icon(
                          HugeIcons.strokeRoundedPencilEdit02,
                          color: Colors.black,
                          size: 22,
                        ),
                        onPressed: () async {
                          provider.changeToEdit();
                        },
                      ),
                  if(!isCreate)
                    PopupMenuButton<String>(
                      position: PopupMenuPosition.under,
                    icon: Icon(Icons.more_vert, color: Colors.black),
                    color: Colors.white,
                    onSelected: (value) async {
                      if (value == 'Cancel' &&
                          provider.currentStatus != 'cancel' &&
                          provider.saleId != null) {
                        await provider.handleCancelOnChange(
                          clientprovider.client!,
                          context,
                          provider.saleId!,
                        );
                      } else if (value == 'Confirm' &&
                          provider.currentStatus != 'sale' &&
                          provider.currentStatus != 'cancel') {
                        if (provider.saleId != null) {
                          provider.confirmSaleOrder(
                              clientprovider.client!, context);
                        } else {
                          CustomSnackbar.showWarning(
                              context, 'Please Save The Quotation');
                        }
                      } else if (value == 'Email' &&
                          provider.currentStatus != 'cancel') {
                        if (provider.saleId != null) {
                          provider.showSendByEmailDialog(
                              context, clientprovider.client!);
                        } else {
                          CustomSnackbar.showWarning(
                              context, 'Please Save The Quotation');
                        }
                      } else if (value == 'Invoice' &&
                          provider.currentStatus == 'sale') {
                        provider
                            .createInvoiceDialog(
                          context,
                          clientprovider.client!,
                          clientprovider.currentsession!,
                        )
                            .then((newInvoiceId) {
                          if (newInvoiceId != null &&
                              widget.ordersaleid != null) {
                            fetchInvoiceIds();
                          }
                        });
                      } else if (value == 'Set Quotation' &&
                          provider.currentStatus == 'cancel') {
                        provider.setToQuotation(
                          clientprovider.client!,
                          provider.saleId!,
                          context,
                        );
                      } else if (value == 'View Invoices' &&
                          invoiceIds.isNotEmpty) {
                        Navigator.push(
                          context,
                          SlidingPageTransitionRL(
                              page: InvoiceListScreen(
                            invoiceIds: invoiceIds,
                            client: clientprovider.client!,
                          )),
                        ).then((_) {
                          if (widget.ordersaleid != null) {
                            fetchInvoiceIds();
                          }
                        });
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        if (provider.currentStatus != 'cancel' &&
                            provider.saleId != null)
                          PopupMenuItem<String>(
                            value: 'Cancel',
                            child: Text('Cancel'),
                          ),
                        if (provider.currentStatus != 'sale' &&
                            provider.currentStatus != 'cancel')
                          PopupMenuItem<String>(
                            value: 'Confirm',
                            child: Text('Confirm'),
                          ),
                        if (provider.currentStatus != 'cancel')
                          PopupMenuItem<String>(
                            value: 'Email',
                            child: Text('Send Email'),
                          ),
                        if (provider.currentStatus == 'sale')
                          PopupMenuItem<String>(
                            value: 'Invoice',
                            child: Text('Create Invoice'),
                          ),
                        if (invoiceIds.isNotEmpty)
                          PopupMenuItem<String>(
                            value: 'View Invoices',
                            child: Text('View Invoices'),
                          ),
                        if (provider.currentStatus == 'cancel')
                          PopupMenuItem<String>(
                            value: 'Set Quotation',
                            child: Text('Set to Quotation'),
                          ),
                      ];
                    },
                  ),
                ],
              ),
              bottomNavigationBar: provider.isLoading || !provider.isEdit
                  ? null
                  : Container(
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
                          onPressed: (provider.selectedpartnerid == null ||
                                  (!isCreate && !provider.isChanged))
                              ? null
                              : () async {
                                  if (provider.saleId == null) {
                                    final result =
                                        await provider.createQuotationOnly(
                                      quotebuilderprovider,
                                      quotationviewprovider,
                                      clientprovider.client!,
                                      widget.leadid,
                                      provider.selectedpartnerid,
                                      clientprovider.currentsession!,
                                      context,
                                    );
                                    if (result) {
                                      setState(() {
                                        isCreate = false;
                                      });
                                      final clientManager =
                                          Provider.of<OdooClientManager>(
                                              context,
                                              listen: false);
                                      await QuotationViewProvider()
                                          .getQuotationsAndReport(
                                              context: context,
                                              session: clientManager
                                                  .currentsession!);
                                    }
                                  } else {
                                    provider.updateQuotation(
                                      loading: true,
                                      isOdoo18: clientprovider.isOdoo18,
                                      quotebuilderprovider,
                                      clientprovider.client!,
                                      provider.saleId!,
                                      context,
                                      widget.leadid,
                                      provider.selectedpartnerid,
                                      clientprovider.currentsession!,
                                    );
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
                            disabledBackgroundColor: Colors.grey[400]!,
                            disabledForegroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(13),
                          ),
                          child: Text(
                            isCreate ? "Create Quotation" : "Save Changes",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
              body: !provider.isEdit
                  ? Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      provider.quotationName ?? 'New',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppStyle.primaryColor,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.green[50],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        provider.label ?? 'Quotation',
                                        style: TextStyle(
                                          color: Colors.green[700],
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  provider.selectedpartnerid != null &&
                                          clientprovider
                                              .customerItems.isNotEmpty
                                      ? clientprovider.customerItems
                                          .firstWhere(
                                            (item) =>
                                                item.id ==
                                                provider.selectedpartnerid,
                                            orElse: () => CustomerItem(
                                                id: 0,
                                                name: 'Select Customer',
                                                fullname: '',
                                                email: ''),
                                          )
                                          .name
                                      : 'Select Customer',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (provider.addressController.text.isNotEmpty)
                                  Text(
                                    provider.addressController.text,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                      height: 1.4,
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                if (provider.selectedPaymentTermId != null)
                                  Text(
                                    'Payment Terms : ${provider.selectedPaymentTermId!.name}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                if (provider.formatDateexpire.text.isNotEmpty)
                                  Text(
                                    provider.formatDateexpire.text,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.blue[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Expanded(
                            child: QuotationTabBar(),
                          ),
                            ],
                          ),
                          ),
                        ),
                          FutureBuilder<Map<String, double>>(
                            future: provider.calculateQuotationTotals(
                                clientprovider.client!),
                            builder: (context, snapshot) {
                              final data = snapshot.data ??
                                  {
                                    'total_untaxed': provider.totalExcluded,
                                    'total_taxed': provider.totalTaxed,
                                    'total': provider.totalIncluded,
                                  };

                              final untaxed = data['total_untaxed'] ?? 0;
                              final taxed = data['total_taxed'] ?? 0;
                              final taxPercent = (untaxed > 0)
                                  ? ((taxed / untaxed) * 100)
                                  : 0;
                              final taxLabel = taxPercent > 0
                                  ? 'Tax ${taxPercent.toStringAsFixed(0)}%'
                                  : 'Tax';
                              return Container(
                                width: double.infinity,
                                color: AppStyle.primaryColor
                                    .withOpacity(0.10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 12, 16, 6),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Untaxed Amount',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            '\$ ${untaxed.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 6, 16, 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            taxLabel,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            '\$ ${taxed.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.fromLTRB(
                                        20,
                                        16,
                                        20,
                                        16 +
                                            MediaQuery.of(context)
                                                .padding
                                                .bottom,
                                      ),
                                      color: AppStyle.primaryColor,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '\$ ${(data['total'] ?? 0).toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      )
                  : CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: Column(
                              children: [
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (clientprovider
                                        .customerItems.isNotEmpty) ...[
                                      Text.rich(
                                        TextSpan(
                                          text: "Customer",
                                          style: TextStyle(
                                            color: AppColors().subHeading,
                                            fontSize: 16,
                                          ),
                                          children: const [
                                            TextSpan(
                                              text: ' *',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SingleSelectSearchableDropdown<
                                          CustomerItem>(
                                        isEditable: provider.isEdit &&
                                            provider.isAbsorbed == false,
                                        items: clientprovider.customerItems,
                                        displayText: (item) => item.name,
                                        hasImage: true,
                                        initialValue:
                                            provider.selectedpartnerid != null
                                                ? clientprovider.customerItems
                                                    .firstWhere(
                                                    (item) =>
                                                        item.id ==
                                                        provider
                                                            .selectedpartnerid,
                                                  )
                                                : null,
                                        imageUrl: (item) {
                                          return "${clientprovider.url}/web/image/res.partner/${item.id}/avatar_128";
                                        },
                                        httpHeaders: (item) => {
                                          "Cookie":
                                              "session_id=${clientprovider.currentsession!.sessionId}",
                                        },
                                        onSelectionChanged: (selected) {
                                          if (selected != null) {
                                            setState(() {
                                              provider.customerError = null;
                                              provider.selectedpartnerid =
                                                  selected.id;
                                            });
                                            provider.setpartnerid(selected.id,
                                                clientprovider.client!);
                                            provider.isChanged = true;
                                          } else {
                                            setState(() {
                                              provider.selectedpartnerid = null;
                                            });
                                          }
                                        },
                                        hintText: "Customer",
                                      ),
                                      if (provider.customerError != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 6),
                                          child: Text(
                                            provider.customerError!,
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 13),
                                          ),
                                        ),
                                      const SizedBox(height: 20),
                                      CustomEditingFields(
                                        isExpanable: true,
                                        title: "Customer Address",
                                        controller: provider.addressController,
                                        hintText:
                                            'Choose a Customer to view address',
                                        isEditable: false,
                                      ),
                                    ],
                                    const SizedBox(height: 20),
                                    Text(
                                      "Expiration Date",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors().subHeading,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    CustomDatePickerField(
                                      isEditable: provider.isEdit &&
                                          provider.isAbsorbed == false,
                                      initialValue:
                                          provider.formatDateexpire.text,
                                      onDateChanged: (value) {
                                        setState(() {
                                          provider.quotationDateError = null;
                                          provider.formatDateexpire.text =
                                              value!;
                                          provider.isChanged = true;
                                        });
                                      },
                                      hintText: "Expiration Date",
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "Quotation Date",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors().subHeading,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    CustomDatePickerField(
                                      isEditable: provider.isEdit &&
                                          provider.isAbsorbed == false,
                                      initialValue:
                                          provider.formatDateQuotation.text,
                                      onDateChanged: (value) {
                                        setState(() {
                                          provider.formatDateQuotation.text =
                                              value!;
                                          provider.isChanged = true;
                                        });
                                      },
                                      hintText: "Quotation Date",
                                    ),
                                    if (provider.quotationDateError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          provider.quotationDateError!,
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 13),
                                        ),
                                      ),
                                    const SizedBox(height: 20),
                                    if (provider.isSaleManagementInstalled) ...[
                                      Text(
                                        "Quotation Template",
                                        style: TextStyle(
                                          color: AppColors().subHeading,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SingleSelectSearchableFuture<
                                          SaleOrderTemplate>(
                                        initialValue: provider.selectedTemplate,
                                        items: [],
                                        idSelector: (template) => template.id,
                                        displayText: (template) =>
                                            template.name,
                                        onSelectionChanged: (template) {
                                          if (template != null) {
                                            provider.selectedTemplate =
                                                template;
                                            provider.setTemplateId(
                                              quotebuilderprovider,
                                              template.id,
                                              clientprovider.client!,
                                              clientprovider.currentsession!,
                                              widget.leadid,
                                              context,
                                              template,
                                              isOdoo18: clientprovider.isOdoo18,
                                            );
                                            provider.isChanged = true;
                                          } else {
                                            setState(() {
                                              provider.selectedTemplate = null;
                                              provider.clear(
                                                quotebuilderprovider,
                                                clientprovider.client!,
                                                context,
                                                widget.leadid,
                                                clientprovider.currentsession!,
                                                clientprovider.isOdoo18,
                                              );
                                            });
                                          }
                                        },
                                        hintText: 'Select a Template',
                                        onEmptyItemsFetch: () async {
                                          final templateResponse =
                                              await CompanySessionManager
                                                  .callKwWithCompany({
                                            'model': 'sale.order.template',
                                            'method': 'search_read',
                                            'args': [],
                                            'kwargs': {
                                              'fields': [
                                                'name',
                                                'mail_template_id',
                                                'number_of_days'
                                              ],
                                              'limit': 50,
                                            },
                                          });
                                          return (templateResponse as List)
                                              .map((item) => SaleOrderTemplate
                                                  .fromJson(item
                                                      as Map<String, dynamic>))
                                              .toList();
                                        },
                                        isEditable: provider.isEdit &&
                                            provider.isAbsorbed == false,
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                    Text(
                                      "Payment Term",
                                      style: TextStyle(
                                        color: AppColors().subHeading,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SingleSelectSearchableFuture<PaymentTerm>(
                                      initialValue:
                                          provider.selectedPaymentTermId,
                                      items: [],
                                      idSelector: (payment) => payment.id,
                                      displayText: (payment) => payment.name,
                                      onSelectionChanged: (payment) {
                                        if (payment != null) {
                                          provider.setPaymenttermId(payment);
                                          provider.isChanged = true;
                                        }
                                      },
                                      hintText: 'Select a Payment Method',
                                      onEmptyItemsFetch: () async {
                                        final paymenttermResponse =
                                            await CompanySessionManager
                                                .callKwWithCompany({
                                          'model': 'account.payment.term',
                                          'method': 'search_read',
                                          'args': [],
                                          'kwargs': {
                                            'fields': ['name'],
                                            'limit': 50
                                          },
                                        });
                                        return (paymenttermResponse as List)
                                            .map((item) => PaymentTerm.fromJson(
                                                item as Map<String, dynamic>))
                                            .toList();
                                      },
                                      isEditable: provider.isEdit &&
                                          provider.isAbsorbed == false,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 500,
                              child: QuotationTabBar(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ),
          );
        }
      },
    );
  }
}
