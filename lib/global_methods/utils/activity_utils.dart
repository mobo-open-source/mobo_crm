/// Utility class containing helper methods for extracting, formatting,
/// and visualizing activity-related information from Odoo `crm.lead` / `res.partner` records.
///
/// Main responsibilities:
///   - Extract activity summary, type, user, deadline, and state from raw record maps
///   - Determine semantic activity state ('overdue', 'today', 'planned')
///   - Format deadlines into human-readable strings (e.g. "Today", "Tomorrow", "3 days overdue")
///   - Provide color and icon recommendations based on activity state
///   - Quick checks for presence of activity data
///
/// All methods are static and safe to use with raw RPC responses (Map<dynamic, dynamic>).
/// Handles common Odoo edge cases (false/null/empty values, malformed dates).
class ActivityUtils {
  /// Extracts key activity information from a raw Odoo record map.
  ///
  /// Safely handles:
  ///   - Many2one fields (List format: [id, display_name])
  ///   - False/null/empty values
  ///   - Missing keys
  ///
  /// Returns a clean map with:
  ///   - 'state'      → activity_state ('planned', 'today', 'overdue', etc.)
  ///   - 'type'       → activity type display name
  ///   - 'user'       → assigned user name
  ///   - 'deadline'   → date string (YYYY-MM-DD)
  ///   - 'summary'    → short description
  ///   - 'hasActivity' → true if any activity field is present
  static Map<String, dynamic> extractActivityInfo(
      Map<dynamic, dynamic> record) {
    try {
      String? activityState = record['activity_state']?.toString();

      if (activityState == 'false' ||
          activityState == null ||
          activityState.isEmpty) {
        activityState = null;
      }

      String? activityType;
      if (record['activity_type_id'] is List &&
          (record['activity_type_id'] as List).length > 1) {
        activityType = record['activity_type_id'][1]?.toString();
      }

      if (activityType == 'false' ||
          activityType == null ||
          activityType.isEmpty) {
        activityType = null;
      }

      String? activityUser;
      if (record['activity_user_id'] is List &&
          (record['activity_user_id'] as List).length > 1) {
        activityUser = record['activity_user_id'][1]?.toString();
      }

      if (activityUser == 'false' ||
          activityUser == null ||
          activityUser.isEmpty) {
        activityUser = null;
      }

      String? activityDeadline = record['activity_date_deadline']?.toString();

      if (activityDeadline == 'false' ||
          activityDeadline == null ||
          activityDeadline.isEmpty) {
        activityDeadline = null;
      }

      String? activitySummary = record['activity_summary']?.toString();

      if (activitySummary == 'false' ||
          activitySummary == null ||
          activitySummary.isEmpty) {
        activitySummary = null;
      }

      final result = {
        'state': activityState,
        'type': activityType,
        'user': activityUser,
        'deadline': activityDeadline,
        'summary': activitySummary,
        'hasActivity': activityState != null ||
            activityType != null ||
            activityDeadline != null,
      };

      return result;
    } catch (e) {
      return {
        'state': null,
        'type': null,
        'user': null,
        'deadline': null,
        'summary': null,
        'hasActivity': false,
      };
    }
  }

  /// Returns a hex color code suitable for displaying the activity state.
  ///
  /// - overdue → red (#F44336)
  /// - today   → orange (#FF9800)
  /// - planned → green (#4CAF50)
  /// - unknown → grey (#9E9E9E)
  static String getActivityStateColor(String? state) {
    switch (state?.toLowerCase()) {
      case 'overdue':
        return '#F44336';
      case 'today':
        return '#FF9800';
      case 'planned':
        return '#43B75D';
      default:
        return '#9E9E9E';
    }
  }

  /// Returns a Material Icons name (string) for the given activity state.
  ///
  /// Useful for Icon(Icons...) or icon font packages.
  /// - overdue  → 'alarm_clock'
  /// - today    → 'calendar_today'
  /// - planned  → 'schedule'
  /// - default  → 'calendar_month'
  static String getActivityStateIcon(String? state) {
    switch (state?.toLowerCase()) {
      case 'overdue':
        return 'alarm_clock';
      case 'today':
        return 'calendar_today';
      case 'planned':
        return 'schedule';
      default:
        return 'calendar_month';
    }
  }

  /// Determines the semantic state of an activity based on its deadline.
  ///
  /// Returns:
  ///   - 'overdue'  → deadline before today
  ///   - 'today'    → deadline is today
  ///   - 'planned'  → deadline in future
  ///   - null       → invalid/missing deadline
  static String? determineActivityState(String? deadline) {
    if (deadline == null || deadline.isEmpty || deadline == 'false') {
      return null;
    }

    try {
      final deadlineDate = DateTime.parse(deadline);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final deadlineDay =
          DateTime(deadlineDate.year, deadlineDate.month, deadlineDate.day);

      if (deadlineDay.isBefore(today)) {
        return 'overdue';
      } else if (deadlineDay.isAtSameMomentAs(today)) {
        return 'today';
      } else {
        return 'planned';
      }
    } catch (e) {
      return null;
    }
  }

  /// Formats an activity deadline into a user-friendly string.
  ///
  /// Examples:
  ///   - Today           → "Today"
  ///   - Tomorrow        → "Tomorrow"
  ///   - Future          → "In 5 days"
  ///   - Past            → "3 days overdue"
  ///   - Invalid/missing → ""
  static String formatActivityDeadline(String? deadline) {
    if (deadline == null || deadline.isEmpty || deadline == 'false') {
      return '';
    }

    try {
      final deadlineDate = DateTime.parse(deadline);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final deadlineDay =
          DateTime(deadlineDate.year, deadlineDate.month, deadlineDate.day);

      if (deadlineDay.isBefore(today)) {
        final difference = today.difference(deadlineDay).inDays;
        return '$difference day${difference > 1 ? 's' : ''} overdue';
      } else if (deadlineDay.isAtSameMomentAs(today)) {
        return 'Today';
      } else {
        final difference = deadlineDay.difference(today).inDays;
        if (difference == 1) {
          return 'Tomorrow';
        } else {
          return 'In $difference days';
        }
      }
    } catch (e) {
      return deadline;
    }
  }

  /// Quick check if the record has any active activity data.
  ///
  /// Uses `extractActivityInfo` internally.
  static bool hasActivity(Map<dynamic, dynamic> record) {
    final activityInfo = extractActivityInfo(record);
    return activityInfo['hasActivity'] as bool;
  }

  /// Safely extracts the record name (title/display name).
  static String getRecordName(Map<dynamic, dynamic> record) {
    return record['name']?.toString() ?? 'Unnamed Record';
  }

  /// Safely extracts the record ID (integer).
  static int getRecordId(Map<dynamic, dynamic> record) {
    return record['id'] as int? ?? 0;
  }

  /// Determines the Odoo model name based on the record's 'type' field.
  ///
  /// Currently always returns 'crm.lead' (lead/opportunity share the same model).
  /// Ready for future extension if other types are added.
  static String getRecordModel(Map<dynamic, dynamic> record) {
    final type = record['type']?.toString();
    switch (type) {
      case 'opportunity':
        return 'crm.lead';
      case 'lead':
        return 'crm.lead';
      default:
        return 'crm.lead';
    }
  }
}
