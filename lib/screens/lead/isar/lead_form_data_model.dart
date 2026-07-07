import 'package:isar_community/isar.dart';

part 'lead_form_data_model.g.dart';

/// A local Isar collection model that represents a CRM Lead form.
///
/// This model is used for offline caching and local storage of lead data
/// fetched from the Odoo backend.
///
/// It maps Odoo lead fields into a structured Dart object and
/// provides a [fromJson] factory constructor to safely parse API responses.
///
/// ### Key Features:
/// - Stores relational fields (many2one) as both `Id` and `Name`
/// - Stores many2many fields like `tag_ids` as a list of integers
/// - Provides safe type conversion helpers for null-safe parsing
/// - Designed for offline-first architecture using Isar database
///
/// ### Notes:
/// - `id` is the local Isar auto-increment primary key.
/// - `leadId` refers to the actual Odoo lead ID.
/// - Relational fields like `user_id`, `stage_id`, etc. are parsed
///   into separate `Id` and `Name` properties for easier UI usage.
/// - Date fields are stored as `String` to match backend format.
@collection
class LeadFormDataModel {
  LeadFormDataModel();

  Id id = Isar.autoIncrement;

  int? leadId;
  String? name;
  String? type;
  String? phone;
  String? mobile;
  String? emailFrom;
  String? city;
  String? street;
  String? zip;
  String? website;
  String? contactName;
  String? jobPosition;
  String? description;
  String? referred;
  double? expectedRevenue;
  double? probability;

  List<int> tagIds = [];

  int? userId;
  String? userName;

  int? partnerId;
  String? partnerName;

  int? stageId;
  String? stageName;

  int? teamId;
  String? teamName;

  int? campaignId;
  String? campaignName;

  int? mediumId;
  String? mediumName;

  int? sourceId;
  String? sourceName;

  int? countryId;
  String? countryName;

  int? stateId;
  String? stateName;

  int? companyId;
  String? companyName;

  String? dateOpen;
  String? dateClosed;
  String? deadline;
  String? dayOpen;
  String? dayClose;
  bool? active;

  /// Creates a [LeadFormDataModel] instance from a JSON map
  /// received from Odoo RPC response.
  ///
  /// Handles:
  /// - Safe string parsing
  /// - Safe numeric conversion
  /// - Many2one relational fields
  /// - Many2many tag fields
  factory LeadFormDataModel.fromJson(Map<String, dynamic> json) {
    return LeadFormDataModel()
      ..leadId = _asInt(json['id'])
      ..name = _asString(json['name'])
      ..type = json['type']
      ..phone = _asString(json['phone'])
      ..emailFrom = _asString(json['email_from'])
      ..city = _asString(json['city'])
      ..street = _asString(json['street'])
      ..zip = _asString(json['zip'])
      ..website = _asString(json['website'])
      ..contactName = _asString(json['contact_name'])
      ..jobPosition = _asString(json['function'])
      ..description = _asString(json['description'])
      ..referred = _asString(json['referred'])
      ..expectedRevenue = _asDouble(json['expected_revenue'])
      ..probability = _asDouble(json['probability'])
      ..tagIds = _getIdList(json['tag_ids'])
      ..userId = _getId(json['user_id'])
      ..userName = _getName(json['user_id'])
      ..partnerId = _getId(json['partner_id'])
      ..partnerName = _getName(json['partner_id'])
      ..stageId = _getId(json['stage_id'])
      ..stageName = _getName(json['stage_id'])
      ..teamId = _getId(json['team_id'])
      ..teamName = _getName(json['team_id'])
      ..campaignId = _getId(json['campaign_id'])
      ..campaignName = _getName(json['campaign_id'])
      ..mediumId = _getId(json['medium_id'])
      ..mediumName = _getName(json['medium_id'])
      ..sourceId = _getId(json['source_id'])
      ..sourceName = _getName(json['source_id'])
      ..countryId = _getId(json['country_id'])
      ..countryName = _getName(json['country_id'])
      ..stateId = _getId(json['state_id'])
      ..stateName = _getName(json['state_id'])
      ..companyId = _getId(json['company_id'])
      ..companyName = _getName(json['company_id'])
      ..dateOpen = _asString(json['date_open'])
      ..dateClosed = _asString(json['date_closed'])
      ..deadline = _asString(json['date_deadline'])
      ..dayOpen = _asString(json['day_open'])
      ..dayClose = _asString(json['day_close'])
      ..active = json['active'] == true;
  }

  /// Safely converts a dynamic value to a trimmed String.
  static String? _asString(dynamic val) {
    if (val is String && val.trim().isNotEmpty) return val.trim();
    return null;
  }

  /// Safely converts a dynamic value to int.
  static int? _asInt(dynamic val) {
    if (val is int) return val;
    return null;
  }

  /// Safely converts numeric values to double.
  static double? _asDouble(dynamic val) {
    if (val is num) return val.toDouble();
    return null;
  }

  /// Extracts list of integer IDs from many2many field.
  static List<int> _getIdList(dynamic val) {
    if (val is List) return val.whereType<int>().toList();
    return [];
  }

  /// Extracts ID from many2one field format: [id, name].
  static int? _getId(dynamic val) {
    if (val is List && val.isNotEmpty && val[0] is int) return val[0];
    return null;
  }

  /// Extracts name from many2one field format: [id, name].
  static String? _getName(dynamic val) {
    if (val is List && val.length > 1 && val[1] is String) {
      return val[1].trim();
    }
    return null;
  }
}
