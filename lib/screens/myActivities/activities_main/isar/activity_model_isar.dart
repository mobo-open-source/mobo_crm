import 'package:isar_community/isar.dart';
import 'package:intl/intl.dart';

part 'activity_model_isar.g.dart';

/// Represents an activity in the application that can be stored using Isar database.
///
/// This model contains information about the activity itself (type, summary, note),
/// the associated user, related record (resModel and resId), deadlines, state,
/// and contact information if relevant.
@collection
class ActivityModelIsar {
  ActivityModelIsar();

  Id id = Isar.autoIncrement;

  int? activityId;

  int? activityTypeId;
  String? activityTypeName;
  String? summary;
  String? note;
  String? dateDeadline;
  int? userId;
  String? userName;
  String? resModel;
  String? resName;
  String? state;
  String? createDate;
  int? resId;

  String? contactPhone;
  String? contactMobile;
  String? contactEmail;
  String? contactName;

  /// Creates an [ActivityModelIsar] instance from a JSON map.
  ///
  /// Handles conversion of nested fields (like `[id, name]` arrays) and
  /// formats dates into 'yyyy-MM-dd'.
  ///
  /// Example JSON input:
  /// ```json
  /// {
  ///   "id": 1,
  ///   "activity_type_id": [2, "Call"],
  ///   "summary": "Follow up",
  ///   "note": "Call the client",
  ///   "date_deadline": "2026-02-26",
  ///   "user_id": [3, "John Doe"],
  ///   "res_model": "res.partner",
  ///   "res_name": "Acme Corp",
  ///   "state": "planned",
  ///   "create_date": "2026-02-25T12:34:56",
  ///   "res_id": 45,
  ///   "contact_phone": "1234567890",
  ///   "contact_mobile": "9876543210",
  ///   "contact_email": "client@example.com",
  ///   "contact_name": "Jane Smith"
  /// }
  /// ```
  factory ActivityModelIsar.fromJson(Map<String, dynamic> json) {
    return ActivityModelIsar()
      ..activityId = _asInt(json['id'])
      ..activityTypeId = _getId(json['activity_type_id'])
      ..activityTypeName = _getName(json['activity_type_id'])
      ..summary = _asString(json['summary'])
      ..note = _asString(json['note'])
      ..dateDeadline = _parseDate(json['date_deadline'])
      ..userId = _getId(json['user_id'])
      ..userName = _getName(json['user_id'])
      ..resModel = _asString(json['res_model'])
      ..resName = _asString(json['res_name'])
      ..state = _asString(json['state'])
      ..createDate = _asString(json['create_date'])
      ..resId = _asInt(json['res_id'])
      ..contactPhone = _asString(json['contact_phone'])
      ..contactMobile = _asString(json['contact_mobile'])
      ..contactEmail = _asString(json['contact_email'])
      ..contactName = _asString(json['contact_name']);
  }
}

/// Converts a dynamic value to a [String] if possible.
///
/// Returns null if the value is `false` or empty.
String? _asString(dynamic val) {
  if (val == false) return null;
  if (val is String && val.trim().isNotEmpty) return val.trim();
  return null;
}

/// Converts a dynamic value to an [int] if possible.
///
/// Returns null if the value is `false` or not an integer.
int? _asInt(dynamic val) {
  if (val == false) return null;
  if (val is int) return val;
  return null;
}

/// Parses a date string and returns it in 'yyyy-MM-dd' format.
///
/// Returns null if parsing fails or value is invalid.
String? _parseDate(dynamic val) {
  if (val is String && val.isNotEmpty) {
    final parsed = DateTime.tryParse(val);
    if (parsed != null) {
      return DateFormat('yyyy-MM-dd').format(parsed);
    }
  }
  return null;
}

/// Extracts the ID from a `[id, name]` list.
///
/// Returns null if input is not a valid list with an integer ID at index 0.
int? _getId(dynamic val) {
  return (val is List && val.isNotEmpty && val[0] is int) ? val[0] : null;
}

/// Extracts the name from a `[id, name]` list.
///
/// Returns null if input is not a valid list with a string name at index 1.
String? _getName(dynamic val) {
  return (val is List && val.length > 1 && val[1] is String)
      ? (val[1] as String).trim()
      : null;
}
