import 'package:isar_community/isar.dart';

part 'leads_model_isar_cache.g.dart';

/// Isar collection used for caching CRM Leads locally.
///
/// This model represents a lightweight cached version of CRM leads
/// fetched from the Odoo backend. It is optimized for:
///
/// - Offline access
/// - Fast listing & searching
/// - Lead dashboard rendering
/// - Filtering & sorting operations
///
/// ### Design Notes:
/// - `id` → Local Isar auto-increment primary key
/// - `serverId` → Actual Odoo lead ID
/// - Many2one fields are split into `Id` and `Name`
/// - Many2many fields are stored as `List<int>`
/// - Date fields are stored as `DateTime`
/// - `searchKey` is indexed for fast local search
@collection
class LeadsModelIsarCache {
  LeadsModelIsarCache();

  Id id = Isar.autoIncrement;

  int? serverId;
  String? name;
  String? phone;
  String? mobile;
  String? emailFrom;
  String? city;

  int? teamId;
  String? teamName;

  int? countryId;
  String? countryName;

  int? userId;
  String? userName;

  double? probability;

  int? partnerId;
  String? partnerName;

  String? priority;
  List<int>? tagIds;
  DateTime? dateOpen;
  DateTime? dateClosed;
  DateTime? activityDateDeadline;
  List<int>? activityIds;

  int? activityTypeId;
  String? activityTypeName;

  String? activityState;

  int? activityUserId;
  String? activityUserName;

  double? expectedRevenue;
  double? proratedRevenue;
  String? description;
  String? contactName;
  bool? active;
  String? type;
  DateTime? createDate;

  int? stageId;
  String? stageName;

  double? dayClose;
  double? recurringRevenueMonthly;
  double? recurringRevenueMonthlyProrated;
  double? recurringRevenueProrated;
  double? recurringRevenue;
  DateTime? dateDeadline;

  @Index(type: IndexType.value)
  String? searchKey;

  /// Creates a [LeadsModelIsarCache] instance from Odoo JSON response.
  ///
  /// Handles:
  /// - Safe parsing of primitives
  /// - Many2one field extraction
  /// - Many2many ID lists
  /// - Date parsing
  /// - Null safety
  factory LeadsModelIsarCache.fromJson(Map<String, dynamic> json) {
    return LeadsModelIsarCache()
      ..serverId = _asInt(json['id'])
      ..name = _asString(json['name'])
      ..phone = _asString(json['phone'])
      ..mobile = _asString(json['mobile'] ?? json['phone'])
      ..emailFrom = _asString(json['email_from'])
      ..city = _asString(json['city'])
      ..countryId = _getId(json['country_id'])
      ..countryName = _getName(json['country_id'])
      ..teamId = _getId(json['team_id'])
      ..teamName = _getName(json['team_id'])
      ..userId = _getId(json['user_id'])
      ..userName = _getName(json['user_id'])
      ..probability = _asDouble(json['probability'])
      ..partnerId = _getId(json['partner_id'])
      ..partnerName = _getName(json['partner_id'])
      ..priority = _asString(json['priority'])
      ..tagIds = _getIdList(json['tag_ids'])
      ..dateOpen = _parseDate(json['date_open'])
      ..dateClosed = _parseDate(json['date_closed'])
      ..activityDateDeadline = _parseDate(json['activity_date_deadline'])
      ..activityIds = _getIdList(json['activity_ids'])
      ..activityTypeId = _getId(json['activity_type_id'])
      ..activityTypeName = _getName(json['activity_type_id'])
      ..activityState = _asString(json['activity_state'])
      ..activityUserId = _getId(json['activity_user_id'])
      ..activityUserName = _getName(json['activity_user_id'])
      ..expectedRevenue = _asDouble(json['expected_revenue'])
      ..proratedRevenue = _asDouble(json['prorated_revenue'])
      ..description = _asString(json['description'])
      ..contactName = _asString(json['contact_name'])
      ..active = json['active'] == true
      ..type = _asString(json['type'])
      ..createDate = _parseDate(json['create_date'])
      ..stageId = _getId(json['stage_id'])
      ..stageName = _getName(json['stage_id'])
      ..dayClose = _asDouble(json['day_close'])
      ..recurringRevenueMonthly = _asDouble(json['recurring_revenue_monthly'])
      ..recurringRevenueMonthlyProrated =
          _asDouble(json['recurring_revenue_monthly_prorated'])
      ..recurringRevenueProrated = _asDouble(json['recurring_revenue_prorated'])
      ..recurringRevenue = _asDouble(json['recurring_revenue'])
      ..dateDeadline = _parseDate(json['date_deadline']);
  }

  /// Safely converts to String.
  static String? _asString(dynamic val) {
    if (val is String && val.isNotEmpty) return val;
    return null;
  }

  /// Safely converts to int.
  static int? _asInt(dynamic val) {
    if (val is int) return val;
    return null;
  }

  /// Safely converts numeric values to double.
  static double? _asDouble(dynamic val) {
    if (val is num) return val.toDouble();
    return null;
  }

  /// Parses ISO date string into [DateTime].
  static DateTime? _parseDate(dynamic val) {
    if (val is String && val.isNotEmpty) {
      return DateTime.tryParse(val);
    }
    return null;
  }

  /// Extracts ID list from many2many fields.
  static List<int> _getIdList(dynamic val) {
    if (val is List) return val.whereType<int>().toList();
    return [];
  }

  /// Extracts ID from many2one field `[id, name]`.
  static int? _getId(dynamic val) {
    if (val is List && val.isNotEmpty && val[0] is int) {
      return val[0];
    }
    return null;
  }

  /// Extracts name from many2one field `[id, name]`.
  static String? _getName(dynamic val) {
    if (val is List && val.length > 1 && val[1] is String) {
      return val[1];
    }
    return null;
  }
}
