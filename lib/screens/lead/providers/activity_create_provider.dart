import 'package:flutter/material.dart';
import 'package:mobo_crm/models/activity_model/activity_model.dart';

import '../../../core/company/session/company_session_manager.dart';

/// Provider responsible for fetching and managing Odoo activities
/// related to a specific record (Lead, Opportunity, etc.).
///
/// This class:
/// - Fetches activities from Odoo backend
/// - Stores them locally in memory
/// - Handles loading state
/// - Provides helper methods for deadline calculations
/// - Notifies listeners for UI updates
class ActivityCreateProvider extends ChangeNotifier {
  List<OdooActivity> activities = [];
  bool expanded = false;
  bool loading = true;

  /// Fetches activities from Odoo for a specific record.
  ///
  /// Parameters:
  /// - [context]: Required for session/company context
  /// - [resId]: Record ID (e.g., lead ID)
  /// - [model]: Model name (e.g., 'crm.lead')
  ///
  /// Returns:
  /// - `true` if fetch succeeds
  /// - `false` if an error occurs
  ///
  /// Fetches up to 10 activities sorted by default backend order.
  /// Fields retrieved:
  /// - id
  /// - date_deadline
  /// - user_id
  /// - activity_type_id
  Future<bool> fetchActivities(
      BuildContext context, int resId, String model) async {
    try {
      final result = await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['res_id', '=', resId],
            ['res_model', '=', model]
          ],
          'fields': [
            'id',
            'date_deadline',
            'user_id',
            'activity_type_id',
            'summary',
          ],
          'limit': 10,
        },
      });

      activities = List<Map<String, dynamic>>.from(result)
          .map(OdooActivity.fromJson)
          .toList();
      loading = false;

      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
      notifyListeners();
      return false;
    }
  }

  /// Calculates the number of days remaining until the deadline.
  ///
  /// Returns:
  /// - Negative value → Overdue
  /// - 0 → Due today
  /// - Positive value → Upcoming
  int daysLeft(String dateStr) {
    final deadline = DateTime.tryParse(dateStr);
    if (deadline == null) return 0;
    return deadline.difference(DateTime.now()).inDays;
  }

  /// Returns a color based on deadline status.
  ///
  /// Color logic:
  /// - Red → Overdue
  /// - Orange → Due today
  /// - Green → Upcoming
  Color getDeadlineColor(int days) {
    if (days < 0) return Colors.red;
    if (days == 0) return Colors.orange;
    return Colors.green;
  }
}
