import 'package:isar_community/isar.dart';

part 'mail_activity_model_isar.g.dart';

/// Represents a summary group of mail activities.
///
/// Stored in Isar local database as a collection. Each group corresponds
/// to a category of activities (e.g., "Leads", "Opportunities") and
/// holds counters for total, planned, overdue, and today’s activities.
@collection
class MailActivityGroupIsar {
   Id id = Isar.autoIncrement;
  int? serverId;
  String? name;
  String? model;
  String? icon;
  int? totalCount;
  int? todayCount;
  int? overdueCount;
  int? plannedCount;

   /// Constructor for initializing a [MailActivityGroupIsar] object.
   MailActivityGroupIsar({
    this.serverId,
    this.name,
    this.model,
    this.icon,
    this.totalCount,
    this.todayCount,
    this.overdueCount,
    this.plannedCount,
  });

   /// Creates a [MailActivityGroupIsar] instance from JSON data.
   ///
   /// Expects server keys: `id`, `name`, `model`, `icon`, `total_count`, `today_count`,
   /// `overdue_count`, `planned_count`.
  factory MailActivityGroupIsar.fromJson(Map<String, dynamic> json) {
    return MailActivityGroupIsar(
      serverId: json['id'],
      name: json['name'],
      model: json['model'],
      icon: json['icon'],
      totalCount: json['total_count'],
      todayCount: json['today_count'],
      overdueCount: json['overdue_count'],
      plannedCount: json['planned_count'],
    );
  }

   /// Converts the [MailActivityGroupIsar] instance to JSON format.
   Map<String, dynamic> toJson() {
    return {
      'id': serverId,
      'name': name,
      'model': model,
      'icon': icon,
      'total_count': totalCount,
      'today_count': todayCount,
      'overdue_count': overdueCount,
      'planned_count': plannedCount,
    };
  }
}

/// Represents a single mail activity in Isar database.
///
/// Each activity corresponds to a task, meeting, or reminder related to a model record
/// (e.g., a CRM lead). Contains metadata for scheduling, assignment, and categorization.
@collection
class MailActivityIsar {
   Id id = Isar.autoIncrement;
  int? activityId;
  String? summary;
  String? note;
  String? dateDeadline;
  String? activityTypeId;
  String? activityTypeName;
  String? resName;
  int? userId;
  String? userName;
  String? resModel;
  int? resId;
  int? groupId;

   /// Constructor for initializing a [MailActivityIsar] object.
   MailActivityIsar({
    this.activityId,
    this.summary,
    this.note,
    this.dateDeadline,
    this.activityTypeId,
    this.activityTypeName,
    this.resName,
    this.userId,
    this.userName,
    this.resModel,
    this.resId,
    this.groupId,
  });

   /// Creates a [MailActivityIsar] instance from JSON data.
   ///
   /// Handles type checks and converts nested arrays for activity type and user info.
  factory MailActivityIsar.fromJson(Map<String, dynamic> json) {
    return MailActivityIsar(
      activityId: json['id'],
      summary: json['summary'] is String ? json['summary'] : null,
      note: json['note'] is String ? json['note'] : null,
      dateDeadline: json['date_deadline'] is String ? json['date_deadline'] : null,
      activityTypeId: json['activity_type_id'] is List ? json['activity_type_id'][0].toString() : null,
      activityTypeName: json['activity_type_id'] is List ? json['activity_type_id'][1] : null,
      resName: json['res_name'] is String ? json['res_name'] : null,
      userId: json['user_id'] is List ? json['user_id'][0] : null,
      userName: json['user_id'] is List ? json['user_id'][1] : null,
      resModel: json['res_model'] is String ? json['res_model'] : null,
      resId: json['res_id'] is int ? json['res_id'] : null,
      groupId: json['group_id'] is int ? json['group_id'] : null,
    );
  }

   /// Converts the [MailActivityIsar] instance to JSON format.
   ///
   /// Nested fields like `activity_type_id` and `user_id` are converted back to list format
   /// if available; otherwise, defaults to `'N/A'`.
  Map<String, dynamic> toJson() {
    return {
      'id': activityId,
      'summary': summary ?? 'N/A',
      'note': note ?? 'N/A',
      'date_deadline': dateDeadline ?? 'N/A',
      'activity_type_id': activityTypeId != null && activityTypeName != null
          ? [int.parse(activityTypeId!), activityTypeName]
          : 'N/A',
      'res_name': resName ?? 'N/A',
      'user_id': userId != null && userName != null ? [userId, userName] : 'N/A',
      'res_model': resModel ?? 'N/A',
      'res_id': resId ?? 'N/A',
      'group_id': groupId,
    };
  }
}
