import 'package:flutter/material.dart';

import '../../../core/company/session/company_session_manager.dart';

/// A provider for managing CRM stages in a Flutter application.
///
/// This class uses [ChangeNotifier] to notify listeners about changes
/// in the stages list and loading state. It fetches CRM stages from
/// the backend via [CompanySessionManager] and caches the result to
/// avoid redundant network calls.
///
/// Example usage:
/// ```dart
/// final stageProvider = StageProvider();
/// stageProvider.fetchCrmStages(context);
/// ```
class StageProvider with ChangeNotifier {
  List<Map<String, dynamic>> _stages = [];
  bool _isLoading = true;
  bool _hasFetched = false;

  List<Map<String, dynamic>> get stages => _stages;

  bool get isLoading => _isLoading;

  /// Fetches CRM stages from the backend if not already fetched.
  ///
  /// This method calls the `crm.stage` model using
  /// [CompanySessionManager.callKwWithCompany] with `search_read`.
  /// The results are stored in [_stages] and listeners are notified.
  ///
  /// If the stages have already been fetched once, this method
  /// will return immediately to avoid unnecessary network requests.
  ///
  /// Any errors during the fetch are silently caught.
  ///
  /// [context] is required for potential UI-related operations,
  /// such as showing snackbars or dialogs (currently unused).
  Future<void> fetchCrmStages(BuildContext context) async {
    if (_hasFetched) return;

    try {
      _isLoading = true;
      notifyListeners();

      final result = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.stage',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name'],
          'order': 'id ASC',
        },
      });

      if (result is List) {
        _stages = List<Map<String, dynamic>>.from(result);
        _hasFetched = true;
      }
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Resets the provider state.
  ///
  /// Clears the cached stages and marks the provider as not fetched,
  /// allowing [fetchCrmStages] to reload data from the backend.
  void reset() {
    _hasFetched = false;
    _stages = [];
    notifyListeners();
  }
}
