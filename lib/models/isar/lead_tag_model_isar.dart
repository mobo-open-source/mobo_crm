import 'package:isar_community/isar.dart';

part 'lead_tag_model_isar.g.dart';

/// Represents a Lead Tag stored locally using Isar.
///
/// This model is used to cache CRM lead tags retrieved
/// from the server for offline access and fast querying.
@collection
class LeadTagModelIsar {
  LeadTagModelIsar();
   Id id = Isar.autoIncrement;

  int? serverId;
  String? name;

  /// Creates a [LeadTagModelIsar] instance from JSON data.
  ///
  /// Safely extracts:
  /// - `id` as integer
  /// - `name` as trimmed string
  factory LeadTagModelIsar.fromJson(Map<String, dynamic> json) {
    return LeadTagModelIsar()
      ..serverId = _asInt(json['id'])
      ..name = _asString(json['name']);
  }

  /// Safely converts a dynamic value into an integer.
  ///
  /// Returns null if the value is not an integer.
  static int? _asInt(dynamic val) => val is int ? val : null;

  /// Safely converts a dynamic value into a trimmed string.
  ///
  /// Returns null if:
  /// - Value is not a string
  /// - String is empty after trimming
  static String? _asString(dynamic val) =>
      (val is String && val.trim().isNotEmpty) ? val.trim() : null;
}
