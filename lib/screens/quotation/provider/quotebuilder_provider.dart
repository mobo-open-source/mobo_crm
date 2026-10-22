import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import '../../../core/company/services/company_session_service.dart';

/// Provider to manage the building and customization of quotation PDFs.
///
/// Handles fetching PDF templates from Odoo, selecting headers, footers,
/// product line documents, saving customized form fields, and updating the
/// sale order with the selected PDF configuration.
class QuoteBuilderProvider extends ChangeNotifier {
  final CompanySessionService sessionService;

  QuoteBuilderProvider({required this.sessionService});

  Map<String, dynamic> _pdfData = {};
  final Set<int> _selectedHeaderIds = {};
  final Set<int> _selectedFooterIds = {};
  final Map<int, Set<int>> _selectedProductDocs = {};
  bool isLoading = false;
  Map<String, TextEditingController> headerFieldControllers = {};
  Map<String, TextEditingController> footerFieldControllers = {};
  Map<String, TextEditingController> productFieldControllers = {};

  Map<String, dynamic> get pdfData => _pdfData;

  Set<int> get selectedHeaderIds => _selectedHeaderIds;

  Set<int> get selectedFooterIds => _selectedFooterIds;

  Map<int, Set<int>> get selectedProductDocs => _selectedProductDocs;

  /// Disposes all TextEditingControllers used for header, footer, and product fields.
  void disposeVariables() {
    for (var controller in headerFieldControllers.values) {
      controller.dispose();
    }
    headerFieldControllers.clear();

    for (var controller in footerFieldControllers.values) {
      controller.dispose();
    }
    footerFieldControllers.clear();

    for (var controller in productFieldControllers.values) {
      controller.dispose();
    }
    productFieldControllers.clear();

    super.dispose();
  }

  /// Sets [isLoading] to true and notifies listeners.
  void setLoading() {
    isLoading = true;
    notifyListeners();
  }

  /// Fetches PDF data for a given sale order from Odoo.
  ///
  /// Resets selected headers, footers, and line documents, then populates
  /// [_pdfData] with fetched data. Initializes selected IDs for pre-selected
  /// documents.
  ///
  /// Returns `true` if data was successfully fetched, `false` on error.
  Future<bool> fetchPDFData(
      int saleOrderId, OdooClient client, BuildContext context) async {
    _selectedFooterIds.clear();
    _selectedHeaderIds.clear();
    _selectedProductDocs.clear();
    headerFieldControllers = {};
    footerFieldControllers = {};
    productFieldControllers = {};
    isLoading = true;
    notifyListeners();
    try {
      final response = await sessionService.callKwWithCompanyDynamic({
        'model': 'sale.order',
        'method': 'get_update_included_pdf_params',
        'args': [
          [saleOrderId]
        ],
        'kwargs': {
          'context': {'active_id': saleOrderId}
        },
      });

      await sessionService.callKwWithCompanyUpdate({
        'model': 'sale.order',
        'method': 'write',
        'args': [
          [saleOrderId],
          {
            'quotation_document_ids': [],
          }
        ],
        'kwargs': {},
      });

      _pdfData = jsonDecode(jsonEncode(response));
      notifyListeners();
      for (var header in _pdfData['headers']?['files'] ?? []) {
        if (header['is_selected'] == true) {
          _selectedHeaderIds.add(header['id']);
        }
      }

      for (var footer in _pdfData['footers']?['files'] ?? []) {
        if (footer['is_selected'] == true) {
          _selectedFooterIds.add(footer['id']);
        }
      }

      for (var line in _pdfData['lines'] ?? []) {
        int lineId = line['id'];
        for (var file in line['files'] ?? []) {
          if (file['is_selected'] == true) {
            _selectedProductDocs.putIfAbsent(lineId, () => {});
            _selectedProductDocs[lineId]!.add(file['id']);
          }
        }
      }
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Saves selected headers, footers, and product line documents for a sale order.
  ///
  /// Updates the Odoo sale order with selected documents and their custom form fields.
  /// Re-fetches PDF data after saving.
  Future<void> saveIncludedPDF(
      int saleOrderId, OdooClient client, BuildContext context) async {
    final Map<String, dynamic> selectedPdf = {
      'header': _selectedHeaderIds.toList(),
      'lines': _selectedProductDocs
          .map((key, value) => MapEntry(key.toString(), value.toList())),
      'footer': _selectedFooterIds.toList(),
    };

    final List<dynamic> orderLineList =
        selectedPdf['lines'].keys.map((key) => int.parse(key)).toList();

    try {
      await sessionService.callKwWithCompanyUpdate({
        'model': 'sale.order',
        'method': 'write',
        'args': [
          [saleOrderId],
          {'quotation_document_ids': null}
        ],
        'kwargs': {},
      });
      await sessionService.callKwWithCompanyUpdate({
        'model': 'sale.order.line',
        'method': 'write',
        'args': [
          orderLineList,
          {'product_document_ids': null}
        ],
        'kwargs': {},
      });

      await sessionService.callKwWithCompanyDynamic({
        'model': 'sale.order',
        'method': 'save_included_pdf',
        'args': [
          [saleOrderId],
          selectedPdf
        ],
        'kwargs': {
          'context': {'active_id': saleOrderId}
        },
      });

      Map<String, dynamic> jsonData = {"header": {}, "line": {}, "footer": {}};

      for (int headerId in _selectedHeaderIds) {
        var header = _pdfData['headers']['files']
            .firstWhere((file) => file['id'] == headerId, orElse: () => {});
        jsonData["header"]["$headerId"] = {
          "document_name":
              header.containsKey('name') ? header['name'] : "Unknown",
          "custom_form_fields": {}
        };

        if (header.containsKey("custom_form_fields")) {
          for (var field in header["custom_form_fields"]) {
            jsonData["header"]["$headerId"]["custom_form_fields"]
                    [field["name"]] =
                headerFieldControllers["${headerId}_${field['name']}"]?.text ??
                    "";
          }
        }
      }

      for (int footerId in _selectedFooterIds) {
        var footer = _pdfData['footers']['files']
            .firstWhere((file) => file['id'] == footerId, orElse: () => {});
        jsonData["footer"]["$footerId"] = {
          "document_name":
              footer.containsKey('name') ? footer['name'] : "Unknown",
          "custom_form_fields": {}
        };

        if (footer.containsKey("custom_form_fields")) {
          for (var field in footer["custom_form_fields"]) {
            jsonData["footer"]["$footerId"]["custom_form_fields"]
                    [field["name"]] =
                footerFieldControllers["${footerId}_${field['name']}"]?.text ??
                    "";
          }
        }
      }

      _selectedProductDocs.forEach((lineId, docIds) {
        if (!jsonData["line"].containsKey("$lineId")) {
          jsonData["line"]["$lineId"] = {};
        }

        for (int docId in docIds) {
          var productFile = _pdfData['lines']
                  .firstWhere((line) => line['id'] == lineId, orElse: () => {})
                  .containsKey('files')
              ? _pdfData['lines']
                  .firstWhere((line) => line['id'] == lineId)['files']
                  .firstWhere((file) => file['id'] == docId, orElse: () => {})
              : {};

          jsonData["line"]["$lineId"]["$docId"] = {
            "document_name": productFile.containsKey('name')
                ? productFile['name']
                : "Unknown",
            "custom_form_fields": {}
          };

          if (productFile.containsKey("custom_form_fields")) {
            for (var field in productFile["custom_form_fields"]) {
              jsonData["line"]["$lineId"]["$docId"]["custom_form_fields"]
                      [field["name"]] =
                  productFieldControllers["${docId}_${field['name']}"]?.text ??
                      "";
            }
          }
        }
      });

      await sessionService.callKwWithCompanyUpdate({
        'model': 'sale.order',
        'method': 'write',
        'args': [
          [saleOrderId],
          {'customizable_pdf_form_fields': jsonEncode(jsonData)}
        ],
        'kwargs': {},
      });

      if (context.mounted) {
        await fetchPDFData(saleOrderId, client, context);
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Toggles selection for headers, footers, or product line documents.
  ///
  /// [docId] is the document ID to toggle.
  /// [section] is one of 'header', 'footer', or 'lines'.
  /// [lineId] is required for product line documents.
  void toggleSelection(int docId, String section, {int? lineId}) {
    if (section == 'header') {
      _selectedHeaderIds.contains(docId)
          ? _selectedHeaderIds.remove(docId)
          : _selectedHeaderIds.add(docId);
    } else if (section == 'footer') {
      _selectedFooterIds.contains(docId)
          ? _selectedFooterIds.remove(docId)
          : _selectedFooterIds.add(docId);
    } else if (section == 'lines' && lineId != null) {
      _selectedProductDocs.putIfAbsent(lineId, () => {});
      if (_selectedProductDocs[lineId]!.contains(docId)) {
        _selectedProductDocs[lineId]!.remove(docId);
      } else {
        _selectedProductDocs[lineId]!.add(docId);
      }
    }
    notifyListeners();
  }
}
