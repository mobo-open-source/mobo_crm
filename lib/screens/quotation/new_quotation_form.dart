import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/global_methods/services/global_error_handler.dart';
import 'package:mobo_crm/global_methods/widgets/date_picker/custom_date_picker.dart';
import 'package:mobo_crm/global_methods/widgets/forms/field_label.dart';
import 'package:mobo_crm/global_methods/widgets/forms/mobo_form_card.dart';
import 'package:mobo_crm/global_methods/widgets/forms/mobo_submit_button.dart';
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
import 'package:mobo_crm/screens/lead/widgets/messge_screen.dart';
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

    // No sale order behind this screen means it was opened to create one, from
    // the pipeline's "New Quotation" action or the quotation list.
    isCreate = widget.isNew || widget.ordersaleid == null;
    // A new quotation arrives already reset and loading its defaults: every
    // way in goes through QuotationFormProvider.prepareNewQuotation() before
    // opening this screen. Resetting again from here raced those defaults —
    // it blanked the order date the date field was still showing ("Quotation
    // Date Cant Be Empty") and dropped the default template's lines or kept
    // them depending on which finished first.

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final quotationProvider =
          Provider.of<QuotationFormProvider>(context, listen: false);
      quotationProvider.canManageSkills();
      final clientManager =
          Provider.of<OdooClientManager>(context, listen: false);
      final client = clientManager.client!;
      quotationProvider.checkSaleModuleInstallation(client);

      if (isCreate) {
        // Edit mode only; the data was prepared before this screen opened.
        quotationProvider.changeToEdit();
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

  /// Opens the quotation's chatter, on the Send Message composer by default
  /// or on [action] (1 Log Note, 2 Activity).
  void _openChatter(QuotationFormProvider provider,
      OdooClientManager clientprovider, LeadFormProvider messageprovider,
      {int action = 0}) {
    messageprovider.fetchMessages(
      clientprovider.client!,
      'sale.order',
      provider.saleId!,
      loading: true,
    );
    Navigator.push(
      context,
      SlidingPageTransitionRL(
        page: MessagesScreen(
          model: 'sale.order',
          id: provider.saleId!,
          leadData: const {'type': 'quotation'},
          initialAction: action,
        ),
      ),
    );
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
        final isDark = Theme.of(context).brightness == Brightness.dark;
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
              backgroundColor: isDark ? const Color(0xFF181A20) : Colors.grey[50],
              appBar: AppBar(
                backgroundColor: isDark ? const Color(0xFF181A20) : Colors.grey[50],
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 0,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () async {
                    await _handleBack();
                  },
                  icon: Icon(Icons.arrow_back_ios_new,
                      color: isDark ? Colors.white : Colors.black, size: 20),
                ),
                centerTitle: false,
                title: Text(
                  (!isCreate && provider.isEdit)
                      ? "Update Quotation"
                      : (isCreate ? "Create Quotation" : 'Quotation Details'),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                actions: [
                  if (provider.isAbsorbed == false)
                    if (!provider.isEdit)
                      IconButton(
                        icon: Icon(
                          HugeIcons.strokeRoundedPencilEdit02,
                          color: isDark ? Colors.white : Colors.black,
                          size: 22,
                        ),
                        onPressed: () async {
                          provider.changeToEdit();
                        },
                      ),
                  // sale.order carries a chatter like the pipeline and the
                  // customer form do; LeadFormProvider was already wired into
                  // this screen for it (`messageprovider`) but had no way in.
                  if (!isCreate && provider.saleId != null)
                    IconButton(
                      icon: Icon(
                        HugeIcons.strokeRoundedMessageMultiple01,
                        color: isDark ? Colors.white : Colors.black,
                        size: 22,
                      ),
                      onPressed: () => _openChatter(
                          provider, clientprovider, messageprovider),
                    ),
                  if(!isCreate)
                    PopupMenuButton<String>(
                      position: PopupMenuPosition.under,
                    icon: Icon(Icons.more_vert, color: isDark ? Colors.white : Colors.black),
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    onSelected: (value) async {
                      if (value == 'Send Message' && provider.saleId != null) {
                        _openChatter(provider, clientprovider, messageprovider);
                      } else if (value == 'Log Note' &&
                          provider.saleId != null) {
                        _openChatter(provider, clientprovider, messageprovider,
                            action: 1);
                      } else if (value == 'Cancel' &&
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
                      final itemTextColor =
                          isDark ? Colors.white : Colors.black87;
                      return [
                        if (provider.currentStatus != 'cancel' &&
                            provider.saleId != null)
                          PopupMenuItem<String>(
                            value: 'Cancel',
                            child: Text('Cancel',
                                style: TextStyle(color: itemTextColor)),
                          ),
                        if (provider.currentStatus != 'sale' &&
                            provider.currentStatus != 'cancel')
                          PopupMenuItem<String>(
                            value: 'Confirm',
                            child: Text('Confirm',
                                style: TextStyle(color: itemTextColor)),
                          ),
                        if (provider.currentStatus != 'cancel')
                          PopupMenuItem<String>(
                            value: 'Email',
                            child: Text('Send Email',
                                style: TextStyle(color: itemTextColor)),
                          ),
                        if (provider.currentStatus == 'sale')
                          PopupMenuItem<String>(
                            value: 'Invoice',
                            child: Text('Create Invoice',
                                style: TextStyle(color: itemTextColor)),
                          ),
                        if (invoiceIds.isNotEmpty)
                          PopupMenuItem<String>(
                            value: 'View Invoices',
                            child: Text('View Invoices',
                                style: TextStyle(color: itemTextColor)),
                          ),
                        if (provider.currentStatus == 'cancel')
                          PopupMenuItem<String>(
                            value: 'Set Quotation',
                            child: Text('Set to Quotation',
                                style: TextStyle(color: itemTextColor)),
                          ),
                        if (provider.saleId != null) ...[
                          PopupMenuItem<String>(
                            value: 'Send Message',
                            child: Text('Send Message',
                                style: TextStyle(color: itemTextColor)),
                          ),
                          PopupMenuItem<String>(
                            value: 'Log Note',
                            child: Text('Log Note',
                                style: TextStyle(color: itemTextColor)),
                          ),
                        ],
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
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: MoboSubmitButton(
                          label: isCreate ? "Create Quotation" : "Save Changes",
                          isReady: !(provider.selectedpartnerid == null ||
                              (!isCreate && !provider.isChanged)),
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
                                      // The picked opportunity, not the one
                                      // the screen opened with: the form can
                                      // change it, and a quotation started
                                      // from the pipeline arrives without one.
                                      provider.currentopportunityId,
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
                                      provider.currentopportunityId,
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
                              color: isDark ? Colors.grey[850] : Colors.white,
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
                                        color: isDark
                                            ? Colors.white
                                            : AppStyle.primaryColor,
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
                                  provider
                                          .selectedCustomerItem(
                                              clientprovider.customerItems)
                                          ?.name ??
                                      'Select Customer',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (provider.addressController.text.isNotEmpty)
                                  Text(
                                    provider.addressController.text,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
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
                                      color: isDark ? Colors.white : Colors.black87,
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
                                              color: isDark ? Colors.white : Colors.black87,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            '\$ ${untaxed.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: isDark ? Colors.white : Colors.black87,
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
                                              color: isDark ? Colors.white : Colors.black87,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            '\$ ${taxed.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: isDark ? Colors.white : Colors.black87,
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
                            MoboFormCard(
                                  spacing: 0,
                                  children: [
                                    if (clientprovider
                                        .customerItems.isNotEmpty) ...[
                                      const FieldLabel("Customer",
                                          isRequired: true),
                                      const SizedBox(height: 10),
                                      SingleSelectSearchableDropdown<
                                          CustomerItem>(
                                        isEditable: provider.isEdit &&
                                            provider.isAbsorbed == false,
                                        items: clientprovider.customerItems,
                                        displayText: (item) => item.name,
                                        hasImage: true,
                                        initialValue:
                                            provider.selectedCustomerItem(
                                                clientprovider.customerItems),
                                        imageUrl: (item) {
                                          return "${clientprovider.url}/web/image/res.partner/${item.id}/avatar_128";
                                        },
                                        httpHeaders: (item) => {
                                          ...CompanySessionManager.skipSessionRotationHeader,
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
                                            // Cleared: the address shown
                                            // under it was the old customer's.
                                            setState(() {
                                              provider.selectedpartnerid = null;
                                              provider.selectedPartnerName =
                                                  null;
                                              provider.addressController
                                                  .clear();
                                            });
                                            provider.isChanged = true;
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
                                      const SizedBox(height: 10),
                                      CustomEditingFields(
                                        isExpanable: true,
                                        title: "Customer Address",
                                        controller: provider.addressController,
                                        hintText:
                                            'Choose a Customer to view address',
                                        isEditable: false,
                                        bottomPadding: 0,
                                      ),
                                    ],
                                    if (clientprovider
                                        .leadItems.isNotEmpty) ...[
                                      const SizedBox(height: 10),
                                      const FieldLabel("Opportunity"),
                                      const SizedBox(height: 10),
                                      SingleSelectSearchableDropdown<LeadItem>(
                                        isEditable: provider.isEdit,
                                        items: clientprovider.leadItems,
                                        displayText: (item) =>
                                            item.name ?? 'Unknown',
                                        // The list is loaded once per session
                                        // and can miss the record; an empty
                                        // pick beats a blank screen.
                                        initialValue: clientprovider.leadItems
                                            .where((item) =>
                                                item.id ==
                                                provider.currentopportunityId)
                                            .firstOrNull,
                                        // null when cleared.
                                        onSelectionChanged: (selected) =>
                                            provider
                                                .setOpportunityId(selected?.id),
                                        hintText: "Opportunity",
                                      ),
                                    ],
                                    const SizedBox(height: 10),
                                    const FieldLabel("Expiration Date"),
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
                                    const SizedBox(height: 10),
                                    const FieldLabel("Quotation Date"),
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
                                    const SizedBox(height: 10),
                                    if (provider.isSaleManagementInstalled) ...[
                                      const FieldLabel("Quotation Template"),
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
                                              template.id,
                                              clientprovider.client!,
                                              clientprovider.currentsession!,
                                              context,
                                              template,
                                            );
                                            provider.isChanged = true;
                                          } else {
                                            provider.clearTemplate();
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
                                      const SizedBox(height: 10),
                                    ],
                                    const FieldLabel("Payment Term"),
                                    const SizedBox(height: 10),
                                    SingleSelectSearchableFuture<PaymentTerm>(
                                      initialValue:
                                          provider.selectedPaymentTermId,
                                      items: [],
                                      idSelector: (payment) => payment.id,
                                      displayText: (payment) => payment.name,
                                      onSelectionChanged: (payment) {
                                        // null when cleared.
                                        provider.setPaymenttermId(payment);
                                        provider.isChanged = true;
                                      },
                                      hintText: 'Select a Payment Term',
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
