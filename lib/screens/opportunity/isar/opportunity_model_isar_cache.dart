import 'package:isar_community/isar.dart';

part 'opportunity_model_isar_cache.g.dart';

/// Represents an Opportunity entity stored in the Isar database cache.
///
/// This model is designed for local caching of opportunity data retrieved
/// from a remote server (e.g., an Odoo backend). It includes information
/// about the opportunity itself, the associated partner, user, team, activity,
/// and financial details.
///
/// Fields:
/// - [id]: Auto-incremented local database ID.
/// - [serverId]: ID of the opportunity on the server.
/// - [name]: Name/title of the opportunity.
/// - [phone]: Contact phone number.
/// - [mobile]: Mobile number (defaults to [phone] if not provided).
/// - [emailFrom]: Contact email.
/// - [city]: City associated with the opportunity.
/// - [teamId], [teamName]: ID and name of the sales team.
/// - [countryId], [countryName]: ID and name of the country.
/// - [userId], [userName]: ID and name of the user responsible.
/// - [probability]: Probability of closing the opportunity.
/// - [partnerId], [partnerName]: Associated partner ID and name.
/// - [priority]: Priority level of the opportunity.
/// - [tagIds]: List of tag IDs associated with the opportunity.
/// - [dateOpen], [dateClosed]: Open and closed dates.
/// - [activityDateDeadline]: Deadline for the next activity.
/// - [activityIds]: List of related activity IDs.
/// - [activityTypeId], [activityTypeName]: ID and name of the activity type.
/// - [activityState]: Current state of the activity.
/// - [activityUserId], [activityUserName]: ID and name of the activity owner.
/// - [expectedRevenue]: Expected revenue for the opportunity.
/// - [proratedRevenue]: Prorated revenue amount.
/// - [description]: Description of the opportunity.
/// - [contactName]: Name of the main contact.
/// - [active]: Indicates if the opportunity is active.
/// - [type]: Type/category of the opportunity.
/// - [createDate]: Date when the opportunity was created.
/// - [stageId], [stageName]: ID and name of the current stage.
/// - [dayClose]: Number of days to close the opportunity.
/// - [recurringRevenueMonthly], [recurringRevenueMonthlyProrated],
///   [recurringRevenueProrated], [recurringRevenue]: Various revenue metrics.
/// - [dateDeadline]: Deadline date for the opportunity.
/// - [searchKey]: Indexed field to facilitate quick searches.
///
/// Methods:
/// - [fromJson]: Factory constructor to create an instance from a JSON map.
///
/// Helper methods:
/// - [_asString], [_asInt], [_asDouble], [_parseDate]: Safe type conversion helpers.
/// - [_getId], [_getName], [_getIdList]: Extract IDs and names from server response.
@collection
class OpportunityModelIsarCache {
  OpportunityModelIsarCache();

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

  /// Creates an [OpportunityModelIsarCache] instance from a JSON map.
  ///
  /// This factory constructor maps server-side JSON fields to local fields,
  /// converting types safely and handling optional/nullable values. It also
  /// extracts IDs and names from relational fields provided as `[id, name]` lists.
  ///
  /// Example JSON:
  /// ```json
  /// {
  ///   "id": 1,
  ///   "name": "Big Deal",
  ///   "phone": "1234567890",
  ///   "country_id": [100, "India"],
  ///   "team_id": [10, "Sales Team A"]
  /// }
  /// ```
  factory OpportunityModelIsarCache.fromJson(Map<String, dynamic> json) {
    return OpportunityModelIsarCache()
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

  static String? _asString(dynamic val) {
    if (val is String && val.isNotEmpty) return val;
    return null;
  }

  static int? _asInt(dynamic val) {
    if (val is int) return val;
    return null;
  }

  static double? _asDouble(dynamic val) {
    if (val is num) return val.toDouble();
    return null;
  }

  static DateTime? _parseDate(dynamic val) {
    if (val is String && val.isNotEmpty) {
      return DateTime.tryParse(val);
    }
    return null;
  }

  static List<int> _getIdList(dynamic val) {
    if (val is List) return val.whereType<int>().toList();
    return [];
  }

  static int? _getId(dynamic val) {
    if (val is List && val.isNotEmpty && val[0] is int) {
      return val[0];
    }
    return null;
  }

  static String? _getName(dynamic val) {
    if (val is List && val.length > 1 && val[1] is String) {
      return val[1];
    }
    return null;
  }
}
