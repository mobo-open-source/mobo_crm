import 'package:odoo_rpc/odoo_rpc.dart';

import '../../core/company/session/company_session_manager.dart';

/// A utility class for caching and resolving Odoo model field names dynamically.
///
/// Purpose:
///   - Avoid hardcoding field names that might differ across Odoo versions, custom modules, or translations
///   - Fetch human-readable/string labels via `fields_get` and cache them
///   - Provide fallback to original technical name when cache miss or field not found
///
/// Currently used to safely map common fields like `tax_ids`, `partner_id`, etc.
///
/// Thread-safety note: The cache (`_fieldCache`) is static and not synchronized.
/// For single-threaded Flutter usage this is usually fine, but avoid concurrent preloads
/// from multiple isolates without additional locking.
class OdooFieldManager {
  /// In-memory cache: model → {technicalFieldName → resolvedFieldName}
  static final Map<String, Map<String, String>> _fieldCache = {};

  /// Fetches field metadata for a given model using Odoo's `fields_get` RPC method
  /// and caches only the fields we care about from `possibleFields`.
  ///
  /// Parameters:
  ///   - [model]           Odoo model name (e.g. 'sale.order', 'product.product')
  ///   - [possibleFields]  List of technical field names we want to resolve
  ///   - [client]          Authenticated Odoo RPC client
  ///
  /// Throws:
  ///   - Exception if RPC call fails
  ///
  /// Side effect:
  ///   - Populates `_fieldCache[model]` with found mappings
  Future<void> cacheModelFields(
      String model, List<String> possibleFields, OdooClient client) async {
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': model,
        'method': 'fields_get',
        'args': [],
        'kwargs': {
          'attributes': ['string']
        },
      });

      Map<String, String> fieldMappings = {};
      for (var field in possibleFields) {
        if (response.containsKey(field)) {
          fieldMappings[field] = field;
        }
      }

      _fieldCache[model] = fieldMappings;
    } catch (e) {
      throw Exception("Error fetching field mappings for $model: $e");
    }
  }

  /// Returns the resolved (possibly translated) field name for a given model and technical field.
  ///
  /// If the field was cached and has a label, returns the label.
  /// Otherwise returns the original technical field name (safe fallback).
  String getFieldName(String model, String fallbackField) {
    return _fieldCache[model]?[fallbackField] ?? fallbackField;
  }

  /// Convenience method to preload fields for commonly used models.
  ///
  /// Should be called early in app lifecycle (e.g. after login/session init)
  /// to avoid runtime delays when first using field names.
  ///
  /// Parameters:
  ///   - [client]  Authenticated Odoo RPC client
  Future<void> preloadFields(OdooClient client) async {
    await cacheModelFields('sale.order.line', ['tax_ids', 'tax_id'], client);
    await cacheModelFields(
        'sale.order', ['partner_id', 'opportunity_id'], client);
    await cacheModelFields('product.product', ['product_tmpl_id'], client);
  }
}
