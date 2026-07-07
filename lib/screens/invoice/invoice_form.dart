import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/invoice/services/invoice_service.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../core/company/session/company_session_manager.dart';
import '../../global_methods/services/global_method.dart';
import '../../utils/app_theme.dart';
import '../../utils/snackbar.dart';

/// Displays detailed information about a specific invoice.
///
/// Features:
/// - Fetches invoice details, partner data, and invoice lines from Odoo
/// - Supports invoice state transitions (Confirm, Cancel, Reset to Draft)
/// - Generates and shares a professional PDF invoice
/// - Displays invoice summary with currency formatting
///
/// This screen interacts with:
/// - [CompanySessionManager] for RPC calls
/// - [InvoiceService] for state transition actions
/// - [OdooClientManager] for company session handling
///
/// Requires:
/// - [invoiceId] to identify the invoice
/// - [client] active Odoo RPC client instance
class InvoiceDetailScreen extends StatefulWidget {
  final int invoiceId;
  final OdooClient client;

  const InvoiceDetailScreen({required this.invoiceId, required this.client});

  @override
  _InvoiceDetailScreenState createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  Map<String, dynamic>? invoiceData;
  List<Map<String, dynamic>> invoiceLines = [];
  bool isLoading = true;
  bool isProcessing = false;
  Map<String, dynamic>? invoicePartnerData;
  String currencySymbol = ' 24';

  @override
  void initState() {
    super.initState();
    fetchInvoiceDetails();
  }

  /// Fetches invoice details from Odoo.
  ///
  /// Retrieves:
  /// - Basic invoice fields (amounts, state, dates)
  /// - Currency symbol
  /// - Partner details
  /// - Invoice line items
  ///
  /// Updates:
  /// - [invoiceData]
  /// - [invoiceLines]
  /// - [invoicePartnerData]
  /// - [currencySymbol]
  ///
  /// Handles RPC errors using [ErrorHandlerCustom].
  Future<void> fetchInvoiceDetails() async {
    try {
      setState(() => isLoading = true);
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'account.move',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['id', '=', widget.invoiceId]
          ],
          'fields': [
            'name',
            'partner_id',
            'invoice_date',
            'invoice_date_due',
            'amount_total',
            'state',
            'move_type',
            'amount_untaxed',
            'amount_tax',
            'amount_residual',
            'invoice_line_ids',
            'currency_id',
          ],
          'limit': 1,
        },
      });

      if (response.isNotEmpty && response[0] is Map<String, dynamic>) {
        setState(() {
          invoiceData = response[0];
          if (invoiceData!['state'] == false || invoiceData!['state'] == null) {
            invoiceData!['state'] = 'draft';
          }
          if (invoiceData!['move_type'] == null) {
            invoiceData!['move_type'] = 'out_invoice';
          }
        });

        if (invoiceData!["currency_id"] is List &&
            invoiceData!["currency_id"].isNotEmpty) {
          int currencyId = invoiceData!["currency_id"][0] as int;
          final currencyResponse =
              await CompanySessionManager.callKwWithCompany({
            'model': 'res.currency',
            'method': 'search_read',
            'args': [
              [
                ['id', '=', currencyId]
              ]
            ],
            'kwargs': {
              'fields': ['symbol'],
            },
          });
          if (currencyResponse.isNotEmpty &&
              currencyResponse[0]['symbol'] != null) {
            setState(() {
              currencySymbol = currencyResponse[0]['symbol'] as String;
            });
          }
        }

        if (invoiceData!['partner_id'] is List &&
            invoiceData!['partner_id'].isNotEmpty) {
          int partnerId = invoiceData!['partner_id'][0];
          await fetchPartnerDetails(partnerId);
        }

        if (invoiceData!['invoice_line_ids'] is List &&
            invoiceData!['invoice_line_ids'].isNotEmpty) {
          final lineResponse = await CompanySessionManager.callKwWithCompany({
            'model': 'account.move.line',
            'method': 'search_read',
            'args': [],
            'kwargs': {
              'domain': [
                ['id', 'in', invoiceData!['invoice_line_ids']]
              ],
              'fields': ['name', 'quantity', 'price_unit', 'price_subtotal'],
              'limit': 100,
            },
          });

          setState(() {
            invoiceLines = List<Map<String, dynamic>>.from(lineResponse);
          });
        }
      } else {}
    } catch (e) {
      if (context.mounted) {
        ErrorHandlerCustom.handleError(context, e);
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// Fetches partner (customer) details associated with the invoice.
  ///
  /// Retrieves:
  /// - Name
  /// - Email
  /// - Phone
  /// - Address fields
  ///
  /// Updates:
  /// - [invoicePartnerData]
  Future<void> fetchPartnerDetails(int partnerId) async {
    try {
      final partnerDetails = await CompanySessionManager.callKwWithCompany({
        'model': 'res.partner',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', partnerId]
          ]
        ],
        'kwargs': {
          'fields': [
            'image_1920',
            'name',
            'email',
            'phone',
            'street',
            'city',
            'state_id',
            'zip',
            'country_id'
          ]
        },
      });

      if (partnerDetails.isNotEmpty) {
        setState(() {
          invoicePartnerData = partnerDetails[0];
        });
      }
    } catch (_) {}
  }

  /// Confirms (posts) the invoice.
  ///
  /// Calls [InvoiceService.postInvoice].
  /// Shows success snackbar on completion.
  /// Refreshes invoice details after confirmation.
  ///
  /// Displays loading overlay while processing.
  Future<void> confirmInvoice() async {
    try {
      setState(() => isProcessing = true);

      await InvoiceService().postInvoice(widget.invoiceId);
      if (context.mounted) {
        CustomSnackbar.showSuccess(context, 'Invoice posted successfully');
      }

      await fetchInvoiceDetails();
    } catch (e) {
      if (context.mounted) {
        ErrorHandlerCustom.handleError(context, e);
      }
    } finally {
      setState(() => isProcessing = false);
    }
  }

  /// Cancels the invoice.
  ///
  /// Validates current state before cancellation.
  /// Calls [InvoiceService.actionCancel].
  /// Refreshes invoice details after cancellation.
  ///
  /// Displays loading overlay while processing.
  Future<void> cancelInvoice() async {
    try {
      setState(() => isProcessing = true);

      String currentState = _formatOdooValue(invoiceData!['state']);

      await InvoiceService().actionCancel(widget.invoiceId, currentState);
      if (context.mounted) {
        CustomSnackbar.showSuccess(context, 'Invoice cancelled successfully');
      }

      await fetchInvoiceDetails();
    } catch (e) {
      if (context.mounted) {
        ErrorHandlerCustom.handleError(context, e);
      }
    } finally {
      setState(() => isProcessing = false);
    }
  }

  /// Resets the invoice back to draft state.
  ///
  /// If invoice is in 'posted' state:
  /// - Cancels it first
  /// - Then resets to draft
  ///
  /// Calls [InvoiceService.actionDraft].
  /// Refreshes invoice details after reset.
  ///
  /// Displays loading overlay while processing.
  Future<void> resetToDraft() async {
    try {
      setState(() => isProcessing = true);

      String currentState = _formatOdooValue(invoiceData!['state']);

      await InvoiceService().actionDraft(
        invoiceId: widget.invoiceId,
        currentState: currentState,
        cancelInvoiceCallback: () async {
          await cancelInvoice();
          return _formatOdooValue(invoiceData!['state']);
        },
      );

      if (context.mounted) {
        CustomSnackbar.showSuccess(
            context, 'Invoice reset to draft successfully');
      }

      await fetchInvoiceDetails();
    } catch (e) {
      if (context.mounted) {
        ErrorHandlerCustom.handleError(context, e);
      }
    } finally {
      setState(() => isProcessing = false);
    }
  }

  String _formatOdooValue(dynamic value) {
    return (value == false || value == null) ? "-" : value.toString();
  }

  /// Safely converts dynamic Odoo numeric values to double.
  ///
  /// Handles:
  /// - null
  /// - false
  /// - String
  /// - num
  ///
  /// Returns 0.0 if conversion fails.
  double _odooToDouble(dynamic value) {
    if (value == null || value == false) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Safely converts dynamic Odoo values to String.
  ///
  /// Handles:
  /// - null / false → "-"
  /// - String
  /// - num
  /// - Many2one list format [id, name]
  String _odooToString(dynamic value) {
    if (value == null || value == false) return "-";
    if (value is String) return value;
    if (value is num) return value.toString();
    if (value is List && value.length > 1) return value[1].toString();
    return value.toString();
  }

  /// Generates a styled PDF invoice and opens the share dialog.
  ///
  /// Includes:
  /// - Company logo (if available)
  /// - Invoice metadata
  /// - Customer details
  /// - Line items
  /// - Totals summary
  /// - Pagination footer
  ///
  /// Uses:
  /// - `pdf` package for document creation
  /// - `printing` package for sharing
  ///
  /// [logoBytes] Optional company logo image bytes.
  Future<void> generateAndShareInvoicePdf(Uint8List? logoBytes) async {
    try {
      final ttf = pw.Font.ttf(
          await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'));
      final ttfBold =
          pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Bold.ttf'));
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            margin: const pw.EdgeInsets.all(40),
            theme: pw.ThemeData.withFont(
              base: ttf,
              bold: ttfBold,
            ),
          ),
          header: (context) => _buildHeader(logoBytes),
          footer: (context) => _buildFooter(context),
          build: (pw.Context context) => [
            _buildInvoiceTitle(),
            pw.SizedBox(height: 30),
            _buildBillingSection(),
            pw.SizedBox(height: 30),
            _buildItemsSection(),
            pw.SizedBox(height: 25),
            _buildTotalSection(),
          ],
        ),
      );

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'invoice_${invoiceData!["name"]?.replaceAll("/", "-")}.pdf',
      );
    } catch (_) {}
  }

  pw.Widget _buildHeader(Uint8List? logoBytes) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 20),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
            bottom: pw.BorderSide(color: PdfColors.grey200, width: 1)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Row(
            children: [
              if (logoBytes != null)
                pw.Container(
                  decoration: pw.BoxDecoration(
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Image(pw.MemoryImage(logoBytes),
                      width: 60, height: 60),
                ),
              pw.SizedBox(width: logoBytes != null ? 15 : 0),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "INVOICE",
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  pw.Text(
                    "#${invoiceData!["name"] ?? ""}",
                    style: pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.grey600,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                "Issue Date",
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                "${invoiceData!["invoice_date"] ?? "-"}",
                style: const pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.black,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                "Due Date",
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                "${invoiceData!["invoice_date_due"] ?? "-"}",
                style: const pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.only(top: 20),
      decoration: const pw.BoxDecoration(
        border:
            pw.Border(top: pw.BorderSide(color: PdfColors.grey200, width: 1)),
      ),
      child: pw.Text(
        "Page ${context.pageNumber} of ${context.pagesCount}",
        style: const pw.TextStyle(
          fontSize: 9,
          color: PdfColors.grey500,
        ),
      ),
    );
  }

  pw.Widget _buildInvoiceTitle() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.blue100),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            "Invoice Summary",
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: pw.BoxDecoration(
              color: _getStatusColor(invoiceData!["state"]),
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Text(
              _formatOdooValue(invoiceData!["state"]).toUpperCase(),
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildBillingSection() {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey50,
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(color: PdfColors.grey200),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Bill To",
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.SizedBox(height: 12),
                _buildDetailRow(
                    "Customer", _odooToString(invoicePartnerData?["name"])),
                _buildDetailRow(
                    "Email", _odooToString(invoicePartnerData?["email"])),
                _buildDetailRow(
                    "Phone", _odooToString(invoicePartnerData?["phone"])),
                _buildDetailRow("Address",
                    _odooToString(invoicePartnerData?["street"] ?? "N/A")),
              ],
            ),
          ),
        ),
        pw.SizedBox(width: 30),
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey50,
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(color: PdfColors.grey200),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Invoice Details",
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.SizedBox(height: 12),
                _buildDetailRow(
                    "Invoice Number", _odooToString(invoiceData?["name"])),
                _buildDetailRow(
                    "Issue Date", _odooToString(invoiceData?["invoice_date"])),
                _buildDetailRow("Due Date",
                    _odooToString(invoiceData?["invoice_date_due"])),
                _buildDetailRow(
                    "Payment Terms",
                    _odooToString(
                        invoiceData?["payment_term_id"]?[1] ?? "Net 30")),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildItemsSection() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "Items & Services",
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 15),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey200, width: 1),
          columnWidths: {
            0: const pw.FlexColumnWidth(3),
            1: const pw.FlexColumnWidth(1),
            2: const pw.FlexColumnWidth(1.5),
            3: const pw.FlexColumnWidth(1.5),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.blue800),
              children: [
                _buildTableHeader("Description"),
                _buildTableHeader("Qty"),
                _buildTableHeader("Unit Price"),
                _buildTableHeader("Amount"),
              ],
            ),
            ...invoiceLines.map((line) {
              return pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.white),
                children: [
                  _buildTableCell(line['name'] ?? "-", isFirst: true),
                  _buildTableCell(line['quantity']?.toString() ?? "0",
                      isCenter: true),
                  _buildTableCell(
                      "${currencySymbol}${_odooToDouble(line['price_unit']).toStringAsFixed(2)}",
                      isRight: true),
                  _buildTableCell(
                      "${currencySymbol}${_odooToDouble(line['price_subtotal']).toStringAsFixed(2)}",
                      isRight: true),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildTotalSection() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 280,
          padding: const pw.EdgeInsets.all(20),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey50,
            borderRadius: pw.BorderRadius.circular(6),
            border: pw.Border.all(color: PdfColors.grey200),
          ),
          child: pw.Column(
            children: [
              _buildTotalRow("Subtotal", invoiceData!["amount_untaxed"]),
              pw.SizedBox(height: 8),
              _buildTotalRow("Tax", invoiceData!["amount_tax"]),
              pw.SizedBox(height: 8),
              _buildTotalRow("Outstanding", invoiceData!["amount_residual"]),
              pw.SizedBox(height: 12),
              pw.Container(
                height: 1,
                color: PdfColors.grey300,
              ),
              pw.SizedBox(height: 12),
              _buildTotalRow("Total Amount", invoiceData!["amount_total"],
                  isBold: true, isLarge: true),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 70,
            child: pw.Text(
              "$label:",
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey600,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTableHeader(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
      ),
    );
  }

  pw.Widget _buildTableCell(String text,
      {bool isFirst = false, bool isCenter = false, bool isRight = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          color: PdfColors.black,
          fontWeight: isFirst ? pw.FontWeight.normal : pw.FontWeight.normal,
        ),
        textAlign: isCenter
            ? pw.TextAlign.center
            : (isRight ? pw.TextAlign.right : pw.TextAlign.left),
      ),
    );
  }

  pw.Widget _buildTotalRow(String label, dynamic value,
      {bool isBold = false, bool isLarge = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: isLarge ? 14 : 12,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: isBold ? PdfColors.blue800 : PdfColors.grey700,
          ),
        ),
        pw.Text(
          "${currencySymbol}${_odooToDouble(value).toStringAsFixed(2)}",
          style: pw.TextStyle(
            fontSize: isLarge ? 14 : 12,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: isBold ? PdfColors.blue800 : PdfColors.black,
          ),
        ),
      ],
    );
  }

  PdfColor _getStatusColor(dynamic status) {
    switch (status?.toString().toLowerCase()) {
      case 'paid':
        return PdfColors.green600;
      case 'draft':
        return PdfColors.grey600;
      case 'posted':
        return PdfColors.blue600;
      case 'cancel':
        return PdfColors.red600;
      default:
        return PdfColors.orange600;
    }
  }

  pw.Widget detailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.Text("$label: ",
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Text(value, style: const pw.TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  pw.Widget totalRow(String label, dynamic value, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style:
                  const pw.TextStyle(fontSize: 14, color: PdfColors.grey600)),
          pw.Text(
            "${currencySymbol}${_odooToDouble(value).toStringAsFixed(2)}",
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  static const white = Colors.white;
  static const greyText = Color(0xFF616161);
  static const dividerColor = Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    return Consumer<OdooClientManager>(builder: (context, provider, child) {
      final state = invoiceData?['state'];
      return Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.grey[50],
            floatingActionButton: invoiceData != null && state == 'posted'
                ? FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () async {
                      try {
                        await generateAndShareInvoicePdf(provider.logo);
                      } catch (e) {
                        if (context.mounted) {
                          CustomSnackbar.showError(context,
                              'Error generating PDF: \\${e.toString()}');
                        }
                      }
                    },
                    child: Icon(Icons.download, color: AppColors().fillColor),
                  )
                : null,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text(
                "Invoice Details",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.grey[50],
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.black, size: 20),
              ),
              actions: [
                if (state == 'draft') ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      splashRadius: 14,
                      color: Colors.white,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.grey[600],
                        size: 22,
                      ),
                      onSelected: (value) {
                        if (value == 'confirm') {
                          confirmInvoice();
                        } else if (value == 'cancel') {
                          cancelInvoice();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem<String>(
                          value: 'confirm',
                          child: Row(
                            children: [
                              const Icon(
                                HugeIcons.strokeRoundedCheckmarkCircle01,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Confirm',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'cancel',
                          child: Row(
                            children: [
                              const Icon(
                                HugeIcons.strokeRoundedCancelCircle,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (state == 'cancel' || state == 'posted') ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      splashRadius: 14,
                      color: Colors.white,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.grey[600],
                        size: 22,
                      ),
                      onSelected: (value) {
                        if (value == 'reset') {
                          resetToDraft();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem<String>(
                          value: 'reset',
                          child: Row(
                            children: [
                              Icon(
                                Icons.refresh,
                                color: Colors.grey[800],
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Reset to Draft",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
            body: isLoading && !isProcessing
                ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor))
                : invoiceData == null
                    ? const Center(
                        child: Text(
                          "Invoice not found",
                          style: TextStyle(color: greyText, fontSize: 18),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Column(
                            children: [
                            SizedBox(
                              width: double.infinity,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.06),
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
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              invoicePartnerData!['name'] ??
                                                  "-",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context).brightness == Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        StatusColors.buildStatusBadge(
                                          () {
                                            final s = _formatOdooValue(invoiceData!["state"]);
                                            return s.isEmpty ? '' : '${s[0].toUpperCase()}${s.substring(1)}';
                                          }(),
                                          StatusColors.getStatusColor(
                                              _formatOdooValue(invoiceData!["state"])),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Customer Invoice",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: greyText,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 4),
                                    _buildPartnerAddress(),
                                  ],
                                ),
                              ),
                            ),
                            _buildInvoiceDetailsCard(),
                            _buildInvoiceSummary(),
                          ],
                        ),
                      ),
                    ),
          ),
          if (isProcessing)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildInvoiceDetailsCard() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice Lines',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF2D2D2D)
                    : Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black26
                        : Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: IntrinsicWidth(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[700]!
                            : Colors.grey[300]!,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildOrderLineHeader(),
                        if (invoiceLines.isNotEmpty)
                          ...invoiceLines.expand((line) => [
                            _buildInvoiceLineItem(line),
                            Divider(
                              height: 1,
                              thickness: 0.8,
                              color: Colors.grey[300],
                            ),
                          ]).toList()
                            ..removeLast()
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 24, horizontal: 16),
                            child: Center(
                              child: Text(
                                'No invoice lines',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceSummary() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 15),
            _buildSummaryRow("Untaxed Amount", invoiceData!["amount_untaxed"],
                Colors.black87),
            _buildSummaryRow(
                "Taxes", invoiceData!["amount_tax"], Colors.black87),
            _buildSummaryRow(
                "Amount Due", invoiceData!["amount_residual"], Colors.black87),
            const Divider(color: dividerColor),
            _buildSummaryRow(
                "Total", invoiceData!["amount_total"], Colors.black87,
                isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, dynamic value, Color textColor,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: label == "Total"
                ? TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  )
                : TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
          ),
          Text(
            "$currencySymbol${_odooToDouble(value).toStringAsFixed(2)}",
            style: label == "Total"
                ? TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  )
                : TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerAddress() {
    if (invoicePartnerData == null) {
      return Text("No Address Available",
          style: TextStyle(color: greyText, fontSize: 14));
    }

    String? _val(dynamic v) =>
        (v == false || v == null || v.toString().trim().isEmpty) ? null : v.toString().trim();

    final street = _val(invoicePartnerData!['street']);
    final city = _val(invoicePartnerData!['city']);
    final state = (invoicePartnerData!['state_id'] is List &&
            invoicePartnerData!['state_id'].length > 1)
        ? _val(invoicePartnerData!['state_id'][1])
        : null;
    final zip = _val(invoicePartnerData!['zip']);
    final country = (invoicePartnerData!['country_id'] is List &&
            invoicePartnerData!['country_id'].length > 1)
        ? _val(invoicePartnerData!['country_id'][1])
        : null;

    final stateZip = [state, zip].where((e) => e != null).join(' ');
    final addressLine = [street, city, if (stateZip.isNotEmpty) stateZip]
        .where((e) => e != null && e.isNotEmpty)
        .join(', ');

    if (addressLine.isEmpty && (country == null || country.isEmpty)) {
      return Text("No Address Available",
          style: TextStyle(color: greyText, fontSize: 14));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (addressLine.isNotEmpty)
          Text(
            addressLine,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
          ),
        if (country != null && country.isNotEmpty)
          Text(country, style: TextStyle(fontSize: 14, color: greyText)),
      ],
    );
  }

  Widget _buildOrderLineHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF8F9FA),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          _headerCell('Product', 190, isDark),
          _headerCell('Quantity', 120, isDark),
          _headerCell('Price', 120, isDark),
          _headerCell('Total', 120, isDark, alignEnd: true),
        ],
      ),
    );
  }

  Widget _headerCell(String label, double width, bool isDark,
      {bool alignEnd = false}) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          label,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.grey[800],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceLineItem(Map<String, dynamic> line) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final index = invoiceLines.indexOf(line) + 1;
    final qty = _odooToDouble(line['quantity']);

    return Container(
      decoration: const BoxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 190,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                    child: Text(
                      '${index + 1}.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _formatOdooValue(line['name']),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    qty.toStringAsFixed(2),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "$currencySymbol${_odooToDouble(line['price_unit']).toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "$currencySymbol${_odooToDouble(line['price_subtotal']).toStringAsFixed(2)}",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
