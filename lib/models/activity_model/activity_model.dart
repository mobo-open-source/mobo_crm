/// Represents a single activity record fetched from Odoo.
///
/// This model maps the `mail.activity` data including activity type,
/// assigned user, summary, notes, deadlines, and timestamps.
class ActivityModel {
  final int id;
  final List<dynamic> activityTypeId;
  final String summary;
  final String note;
  final String dateDeadline;
  final List<dynamic> userId;
  final String state;
  final String createDate;
  final String writeDate;

  /// Creates an [ActivityModel] instance.
  ActivityModel({
    required this.id,
    required this.activityTypeId,
    required this.summary,
    required this.note,
    required this.dateDeadline,
    required this.userId,
    required this.state,
    required this.createDate,
    required this.writeDate,
  });

  /// Creates an [ActivityModel] from a JSON map.
  ///
  /// Handles null, false, and "null" string values safely
  /// by normalizing them into empty strings.
  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    /// Normalizes dynamic values into safe strings.
    ///
    /// Returns empty string if value is:
    /// - null
    /// - false
    /// - "false"
    /// - "null"
    String _normalizeString(dynamic value) {
      if (value == null || value == false || value.toString() == 'false' || value.toString() == 'null') {
        return '';
      }
      return value.toString();
    }

    return ActivityModel(
      id: json['id'] as int? ?? 0,
      activityTypeId: json['activity_type_id'] as List<dynamic>? ?? [],
      summary: _normalizeString(json['summary']),
      note: _normalizeString(json['note']),
      dateDeadline: json['date_deadline']?.toString() ?? '',
      userId: json['user_id'] as List<dynamic>? ?? [],
      state: json['state']?.toString() ?? '',
      createDate: json['create_date']?.toString() ?? '',
      writeDate: json['write_date']?.toString() ?? '',
    );
  }

  /// Converts the [ActivityModel] instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity_type_id': activityTypeId,
      'summary': summary,
      'note': note,
      'date_deadline': dateDeadline,
      'user_id': userId,
      'state': state,
      'create_date': createDate,
      'write_date': writeDate,
    };
  }
}

/// Represents an activity type in Odoo.
///
/// Used for dropdowns or mapping activity type names.
class ActivityType {
  final int id;
  final String name;

  /// Creates an [ActivityType] instance.
  ActivityType({
    required this.id,
    required this.name,
  });

  /// Creates an [ActivityType] from JSON data.
  factory ActivityType.fromJson(Map<String, dynamic> json) {
    return ActivityType(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
    );
  }

  /// Returns the activity type name as string representation.
  @override
  String toString() => name;
}

/// Simplified activity model used for UI display.
///
/// Extracts and flattens important fields from Odoo's
/// many2one structure for easier usage.
class OdooActivity {
  final int id;
  final String type;
  final String user;
  final int? activityUserId;
  final String deadline;
  final String summary;

  /// Creates an [OdooActivity] instance.
  OdooActivity({
    required this.id,
    required this.type,
    required this.user,
    required this.activityUserId,
    required this.deadline,
    this.summary = '',
  });

  /// Creates an [OdooActivity] from JSON.
  ///
  /// Extracts values from many2one fields like:
  /// - activity_type_id → [id, name]
  /// - user_id → [id, name]
  factory OdooActivity.fromJson(Map<String, dynamic> json) {
    String normalizeString(dynamic value) {
      if (value == null ||
          value == false ||
          value.toString() == 'false' ||
          value.toString() == 'null') return '';
      return value.toString();
    }

    return OdooActivity(
      id: json['id'] ?? 0,
      type: (json['activity_type_id'] is List &&
              json['activity_type_id'].isNotEmpty)
          ? json['activity_type_id'][1] ?? 'Unknown'
          : 'Unknown',
      user: (json['user_id'] is List && json['user_id'].isNotEmpty)
          ? json['user_id'][1] ?? 'Unassigned'
          : 'Unassigned',
      activityUserId: (json['activity_user_id'] == false ||
              json['user_id'] is! List ||
              json['user_id'].isEmpty)
          ? null
          : json['user_id'][0],
      deadline: json['date_deadline'] ?? '',
      summary: normalizeString(json['summary']),
    );
  }
}

/// Represents grouped mail activities summary.
///
/// Typically returned from Odoo dashboard endpoints
/// to show counts like total, today, overdue, and planned.
class MailActivityGroup {
  final int id;
  final String name;
  final String model;
  final String icon;

  /// Odoo's own `total_count`: activities that need attention now, i.e.
  /// **overdue + today**. Planned activities are *not* part of it (this is the
  /// number on the web client's systray badge). Use [allCount] for a sum of
  /// every state.
  final int totalCount;
  final int todayCount;
  final int overdueCount;
  final int plannedCount;

  /// Ids of the activities the server listed for this group.
  ///
  /// Odoo sends them for the catch-all "Other activities" group (activities
  /// without a readable document) and, on Odoo 20, for every group. Empty when
  /// the server did not send them or the group came from the local cache.
  final List<int> activityIds;

  /// Creates a [MailActivityGroup] instance.
  MailActivityGroup({
    required this.id,
    required this.name,
    required this.model,
    required this.icon,
    required this.totalCount,
    required this.todayCount,
    required this.overdueCount,
    required this.plannedCount,
    this.activityIds = const [],
  });

  /// Model name Odoo uses for activities that are not tied to a readable
  /// document.
  static const String otherActivitiesModel = 'mail.activity';

  /// True for the catch-all "Other activities" group.
  bool get isOtherActivities => model == otherActivitiesModel;

  /// Overdue + today: what still needs doing (matches Odoo's systray badge).
  int get dueCount => overdueCount + todayCount;

  /// Overdue + today + planned: every activity the server counted.
  int get allCount => overdueCount + todayCount + plannedCount;

  /// Creates a [MailActivityGroup] from JSON data.
  ///
  /// Odoo 18, 19 and 20 all send the same keys, but numbers may arrive as
  /// `int`, `double` or numeric strings depending on the transport, and
  /// optional text fields as `false`. Anything unusable falls back to a safe
  /// default instead of throwing.
  factory MailActivityGroup.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    String asText(dynamic value) =>
        value is String && value != 'false' ? value : '';

    final rawIds = json['activity_ids'];

    return MailActivityGroup(
      id: asInt(json['id']),
      name: asText(json['name']),
      model: asText(json['model']),
      icon: asText(json['icon']),
      totalCount: asInt(json['total_count']),
      todayCount: asInt(json['today_count']),
      overdueCount: asInt(json['overdue_count']),
      plannedCount: asInt(json['planned_count']),
      activityIds: rawIds is List
          ? rawIds.whereType<num>().map((e) => e.toInt()).toList()
          : const [],
    );
  }

  /// Converts the [MailActivityGroup] into JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'icon': icon,
      'total_count': totalCount,
      'today_count': todayCount,
      'overdue_count': overdueCount,
      'planned_count': plannedCount,
      'activity_ids': activityIds,
    };
  }
}
