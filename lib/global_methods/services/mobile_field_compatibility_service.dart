import '../../core/company/session/company_session_manager.dart';

/// Service that detects and handles compatibility differences for the `mobile` field
/// across various Odoo versions and configurations.
///
/// Background:
///   - In older Odoo versions (< v14/v15 in some custom forks), the `res.partner` model
///     used `phone` instead of `mobile` (or both fields were inconsistent).
///   - Some custom modules or stripped-down mobile apps may lack the `mobile` field entirely.
///
/// This service:
///   1. Probes `fields_get` on key models to detect if `mobile` exists
///   2. Provides safe read/write/search_read wrappers that:
///      - Remove `mobile` from fields/values if unavailable
///      - Fall back to `phone` field when reading (if `mobile` was requested)
///      - Map `mobile` → `phone` when writing (if `mobile` is unavailable)
///
/// Usage:
///   - Call `initialize()` early (e.g. after login)
///   - Use `safeRead`, `safeSearchRead`, `safeWrite` instead of direct RPC calls
///     when `mobile` field might be involved
class MobileFieldCompatibilityService {
  static final Map<String, bool> _mobileFieldAvailability = {};
  static bool _initialized = false;

  /// Initializes compatibility checks for key models.
  ///
  /// Should be called once after successful login/session initialization.
  /// Safe to call multiple times (idempotent).
  static Future<void> initialize() async {
    if (_initialized) return;

    final models = ['res.users', 'res.partner', 'crm.lead'];

    for (String model in models) {
      await _checkMobileFieldAvailability(model);
    }

    _initialized = true;
  }

  /// Checks whether the `mobile` field exists on the given model.
  ///
  /// Caches result to avoid repeated RPC calls.
  /// Returns `true` if `mobile` is present in `fields_get`.
  static Future<bool> _checkMobileFieldAvailability(String model) async {
    if (_mobileFieldAvailability.containsKey(model)) {
      return _mobileFieldAvailability[model]!;
    }

    try {
      final result = await CompanySessionManager.callKwWithCompany({
        'model': model,
        'method': 'fields_get',
        'args': [],
        'kwargs': {
          'attributes': ['string'],
          'allfields': ['mobile']
        },
      });

      bool hasMobile = result != null && result.containsKey('mobile');
      _mobileFieldAvailability[model] = hasMobile;

      if (hasMobile) {
      } else {}

      return hasMobile;
    } catch (e) {
      _mobileFieldAvailability[model] = false;
      String errorMsg = e.toString();
      if (errorMsg.contains('Invalid field') || errorMsg.contains('mobile')) {
      } else {}
      return false;
    }
  }

  /// Returns whether the `mobile` field is available on the specified model.
  ///
  /// Returns `false` if not yet checked or unavailable.
  static bool isMobileFieldAvailable(String model) {
    return _mobileFieldAvailability[model] ?? false;
  }

  /// Safe version of `read` that handles missing `mobile` field gracefully.
  ///
  /// - Removes `mobile` from requested fields if unavailable
  /// - If `mobile` was requested but unavailable, copies value from `phone`
  ///
  /// Throws original exception if RPC fails for other reasons.
  static Future<dynamic> safeRead(
    String model,
    dynamic recordIds,
    List<String> fields,
  ) async {
    if (!_initialized) {
      await CompanySessionManager.getCurrentSession();
    }

    List<String> safeFields = List.from(fields);
    if (!isMobileFieldAvailable(model) && safeFields.contains('mobile')) {
      safeFields.remove('mobile');
    }

    try {
      final result = await CompanySessionManager.callKwWithCompany({
        'model': model,
        'method': 'read',
        'args': recordIds is List ? recordIds : [recordIds],
        'kwargs': {
          'fields': safeFields,
        },
      });

      if (fields.contains('mobile') &&
          !safeFields.contains('mobile') &&
          result is List) {
        for (var record in result) {
          if (record is Map<String, dynamic>) {
            record['mobile'] = record['phone'] ?? '';
          }
        }
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  /// Safe version of `search_read` that handles missing `mobile` field.
  ///
  /// Same fallback logic as `safeRead`.
  static Future<dynamic> safeSearchRead(
    String model,
    List<dynamic> domain,
    List<String> fields, {
    int? offset,
    int? limit,
    String? order,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    List<String> safeFields = List.from(fields);
    if (!isMobileFieldAvailable(model) && safeFields.contains('mobile')) {
      safeFields.remove('mobile');
    }

    try {
      final result = await CompanySessionManager.callKwWithCompany({
        'model': model,
        'method': 'search_read',
        'args': [domain],
        'kwargs': {
          'fields': safeFields,
          if (offset != null) 'offset': offset,
          if (limit != null) 'limit': limit,
          if (order != null) 'order': order,
        },
      });

      if (fields.contains('mobile') &&
          !safeFields.contains('mobile') &&
          result is List) {
        for (var record in result) {
          if (record is Map<String, dynamic>) {
            record['mobile'] = record['phone'] ?? '';
          }
        }
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  /// Safe version of `write` that maps `mobile` → `phone` when `mobile` is unavailable.
  ///
  /// Removes `mobile` from write values if field doesn't exist,
  /// and copies value to `phone` instead.
  static Future<dynamic> safeWrite(
    String model,
    dynamic recordIds,
    Map<String, dynamic> values,
  ) async {
    if (!_initialized) {
      await initialize();
    }

    Map<String, dynamic> safeValues = Map.from(values);
    if (safeValues.containsKey('mobile')) {
      if (isMobileFieldAvailable(model)) {
      } else {
        final mobileValue = safeValues.remove('mobile');
        safeValues['phone'] = mobileValue;
      }
    }

    try {
      return await CompanySessionManager.callKwWithCompany({
        'model': model,
        'method': 'write',
        'args': [
          recordIds is List ? recordIds : [recordIds],
          safeValues
        ],
        'kwargs': {},
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Resets internal state (useful on logout or session change).
  static void reset() {
    _mobileFieldAvailability.clear();
    _initialized = false;
  }

  static Map<String, bool> getFieldAvailabilityStatus() {
    return Map.from(_mobileFieldAvailability);
  }
}
