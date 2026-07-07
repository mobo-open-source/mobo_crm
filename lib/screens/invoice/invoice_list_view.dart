import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';
import 'package:mobo_crm/screens/invoice/invoice_form.dart';
import 'package:mobo_crm/utils/app_theme.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import '../../core/company/session/company_session_manager.dart';

/// Displays a dashboard list of invoices.
///
/// Features:
/// - Fetches invoices using provided invoice IDs
/// - Displays partner name, due date, totals, and state
/// - Fetches and maps currency symbols dynamically
/// - Supports pull-to-refresh
/// - Navigates to [InvoiceDetailScreen] for full invoice view
///
/// Uses:
/// - [CompanySessionManager] for company-aware RPC calls
/// - [OdooClient] for Odoo session handling
///
/// Parameters:
/// - [invoiceIds]: List of invoice IDs to display
/// - [client]: Active Odoo RPC client
class InvoiceListScreen extends StatefulWidget {
  final List<int> invoiceIds;
  final OdooClient client;

  const InvoiceListScreen({required this.invoiceIds, required this.client});

  @override
  _InvoiceListScreenState createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  List<Map<String, dynamic>> invoices = [];
  bool isLoading = true;
  Map<int, String> currencyIdToSymbol = {};

  @override
  void initState() {
    super.initState();
    fetchInvoices();
  }

  /// Fetches invoices from Odoo using `search_read`.
  ///
  /// Steps:
  /// 1. Retrieves invoice basic fields.
  /// 2. Extracts unique currency IDs.
  /// 3. Fetches corresponding currency symbols.
  /// 4. Updates local state with invoice data and currency mapping.
  ///
  /// Handles:
  /// - Empty invoice list
  /// - Safe mounted checks before updating UI
  /// - Graceful error fallback (loading state reset)
  ///
  /// Updates:
  /// - [invoices]
  /// - [currencyIdToSymbol]
  /// - [isLoading]
  Future<void> fetchInvoices() async {
    if (widget.invoiceIds.isEmpty) {
      if (mounted) {
        setState(() => isLoading = false);
      }
      return;
    }

    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'account.move',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['id', 'in', widget.invoiceIds]
          ],
          'fields': [
            'name',
            'partner_id',
            'invoice_date',
            'invoice_date_due',
            'amount_total',
            'state',
            'amount_untaxed',
            'currency_id',
          ],
          'limit': 10,
        },
      });

      final Set<int> uniqueCurrencyIds = {};
      for (final inv in response) {
        if (inv['currency_id'] is List && inv['currency_id'].isNotEmpty) {
          uniqueCurrencyIds.add(inv['currency_id'][0] as int);
        }
      }
      Map<int, String> currencyMap = {};
      if (uniqueCurrencyIds.isNotEmpty) {
        final currencyResponse = await CompanySessionManager.callKwWithCompany({
          'model': 'res.currency',
          'method': 'search_read',
          'args': [
            [
              ['id', 'in', uniqueCurrencyIds.toList()]
            ]
          ],
          'kwargs': {
            'fields': ['id', 'symbol'],
          },
        });
        for (final c in currencyResponse) {
          if (c['id'] != null && c['symbol'] != null) {
            currencyMap[c['id'] as int] = c['symbol'] as String;
          }
        }
      }
      if (mounted) {
        setState(() {
          invoices = List<Map<String, dynamic>>.from(response);
          currencyIdToSymbol = currencyMap;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.grey[50],
        title: const Text(
          "Invoices Dashboard",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
        ),
        actions: const [],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            )
          : invoices.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: fetchInvoices,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: invoices.length,
                    itemBuilder: (context, index) {
                      var invoice = invoices[index];
                      return _buildInvoiceCard(invoice);
                    },
                  ),
                ),
    );
  }

  /// Builds the empty state UI when no invoices are found.
  ///
  /// Displays:
  /// - Receipt icon
  /// - Informational text
  /// - Suggestion to refresh or check connection
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "No Invoices Found",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try refreshing or check your connection",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  /// Builds a styled invoice summary card.
  ///
  /// Displays:
  /// - Partner name
  /// - Invoice state badge
  /// - Due date
  /// - Total amount
  /// - Untaxed amount
  /// - Navigation button to invoice details
  ///
  /// Automatically resolves currency symbol
  /// using [currencyIdToSymbol] mapping.
  ///
  /// Parameters:
  /// - [invoice]: Invoice data map from Odoo
  Widget _buildInvoiceCard(Map<String, dynamic> invoice) {
    String currencySymbol = ' 24';
    if (invoice["currency_id"] is List && invoice["currency_id"].isNotEmpty) {
      int currencyId = invoice["currency_id"][0] as int;
      currencySymbol = currencyIdToSymbol[currencyId] ?? currencySymbol;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 5,
        color: AppColors().fillColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      invoice["partner_id"] != false
                          ? invoice["partner_id"][1]
                          : "Unknown Partner",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  StatusColors.buildStatusBadge(
                    invoice["state"]?.toString() ?? '',
                    StatusColors.getStatusColor(invoice["state"]?.toString()),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Due Date',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    invoice["invoice_date_due"] != false
                        ? invoice["invoice_date_due"]
                        : "N/A",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "$currencySymbol${invoice["amount_total"]?.toStringAsFixed(2) ?? '0.00'}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Untaxed',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "$currencySymbol${invoice["amount_untaxed"]?.toStringAsFixed(2) ?? '0.00'}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      SlidingPageTransitionRL(
                          page: InvoiceDetailScreen(
                            invoiceId: invoice['id'],
                            client: widget.client,
                          )),
                    ).then((_) {
                      fetchInvoices();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "View Details",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a labeled detail column used inside invoice cards.
  ///
  /// Parameters:
  /// - [label]: Field title (e.g., "Total")
  /// - [value]: Display value
  ///
  /// Returns:
  /// - Column widget with styled label and value
  Widget _buildDetailColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
