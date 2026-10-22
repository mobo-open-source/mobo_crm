import 'package:isar_community/isar.dart';

part 'customer_form_isar_cache.g.dart';

/// Local Isar database cache model for storing customer form data.
///
/// This collection mirrors the Odoo `res.partner` model structure
/// and is used for:
/// - Offline access
/// - Faster local reads
/// - Reduced API calls
/// - Search optimization
///
/// The model supports:
/// - Basic contact information
/// - Address details
/// - Company & relationship data
/// - Activity tracking metadata
/// - Geolocation coordinates
///
/// Indexed fields:
/// - [searchServerId] for efficient lookup by server ID.
@collection
class CustomerFormIsarCache {
  /// Creates an empty [CustomerFormIsarCache] instance.
  ///
  /// Typically used internally when mapping JSON
  /// response data from the server.
  CustomerFormIsarCache();

  Id id = Isar.autoIncrement;
  int? serverId;
  String? name;
  String? email;
  String? phone;
  String? mobile;
  String? website;
  String? lang;

  String? street;
  String? street2;
  String? zip;
  String? city;

  int? stateId;
  String? stateName;

  int? countryId;
  String? countryName;

  List<int>? categoryIds;

  String? companyType;
  String? companyName;

  int? meetingCount;
  int? opportunityCount;
  int? saleOrderCount;

  int? companyId;
  String? companyNameFromId;

  int? commercialPartnerId;
  String? commercialPartnerName;

  String? jobPosition;
  bool? isCompany;

  int? customerRank;
  int? supplierRank;

  bool? active;

  String? activityDateDeadline;
  List<int>? activityIds;

  int? activityTypeId;
  String? activityTypeName;

  int? activityUserId;
  String? activityUserName;

  String? activityState;
  String? activitySummary;
  String? activityTypeIcon;

  int? parentId;
  String? parentName;

  int? userId;
  String? userName;

  String? type;
  String? ref;
  String? companyRegistry;

  int? industryId;
  String? industryName;

  double? partnerLatitude;
  double? partnerLongitude;

  String? comment;

  /// Indexed copy of [serverId] used for fast search queries.
  ///
  /// This improves lookup performance when syncing
  /// with the backend server.
  @Index(type: IndexType.value)
  int? searchServerId;

  /// Creates a [CustomerFormIsarCache] instance from
  /// a JSON response returned by the Odoo backend.
  ///
  /// Handles:
  /// - Null safety
  /// - Type conversions
  /// - Many2one field extraction (ID + Name)
  /// - Many2many ID list parsing
  ///
  /// Ensures safe mapping to prevent runtime type errors.
  factory CustomerFormIsarCache.fromJson(Map<String, dynamic> json) {
    return CustomerFormIsarCache()
      ..serverId = _asInt(json['id'])
      ..name = _asString(json['name'])
      ..email = _asString(json['email'])
      ..phone = _asString(json['phone'])
      ..mobile = _asString(json['mobile'])
      ..website = _asString(json['website'])
      ..lang = _asString(json['lang'])
      ..street = _asString(json['street'])
      ..street2 = _asString(json['street2'])
      ..zip = _asString(json['zip'])
      ..city = _asString(json['city'])
      ..stateId = _getId(json['state_id'])
      ..stateName = _getName(json['state_id'])
      ..countryId = _getId(json['country_id'])
      ..countryName = _getName(json['country_id'])
      ..categoryIds = _getIdList(json['category_id'])
      ..companyType = _asString(json['company_type'])
      ..companyName = _asString(json['company_name'])
      ..meetingCount = _asInt(json['meeting_count'])
      ..opportunityCount = _asInt(json['opportunity_count'])
      ..saleOrderCount = _asInt(json['sale_order_count'])
      ..companyId = _getId(json['company_id'])
      ..companyNameFromId = _getName(json['company_id'])
      ..commercialPartnerId = _getId(json['commercial_partner_id'])
      ..commercialPartnerName = _getName(json['commercial_partner_id'])
      ..jobPosition = _asString(json['function'])
      ..isCompany = json['is_company'] == true
      ..customerRank = _asInt(json['customer_rank'])
      ..supplierRank = _asInt(json['supplier_rank'])
      ..active = json['active'] == true
      ..activityDateDeadline = _asString(json['activity_date_deadline'])
      ..activityIds = _getIdList(json['activity_ids'])
      ..activityTypeId = _getId(json['activity_type_id'])
      ..activityTypeName = _getName(json['activity_type_id'])
      ..activityUserId = _getId(json['activity_user_id'])
      ..activityUserName = _getName(json['activity_user_id'])
      ..activityState = _asString(json['activity_state'])
      ..activitySummary = _asString(json['activity_summary'])
      ..activityTypeIcon = _asString(json['activity_type_icon'])
      ..parentId = _getId(json['parent_id'])
      ..parentName = _getName(json['parent_id'])
      ..userId = _getId(json['user_id'])
      ..userName = _getName(json['user_id'])
      ..type = _asString(json['type'])
      ..ref = _asString(json['ref'])
      ..companyRegistry = _asString(json['company_registry'])
      ..industryId = _getId(json['industry_id'])
      ..industryName = _getName(json['industry_id'])
      ..partnerLatitude = _asDouble(json['partner_latitude'])
      ..partnerLongitude = _asDouble(json['partner_longitude'])
      ..comment = _asString(json['comment'])
      ..searchServerId = _asInt(json['id']);
  }

  /// Safely converts a dynamic value to a non-empty [String].
  ///
  /// Returns null if:
  /// - Value is not a string
  /// - String is empty
  static String? _asString(dynamic val) {
    if (val is String && val.isNotEmpty) return val;
    return null;
  }

  /// Safely converts a dynamic value to [int].
  ///
  /// Returns null if the value is not an integer.
  static int? _asInt(dynamic val) {
    if (val is int) return val;
    return null;
  }

  /// Safely converts a dynamic value to [double].
  ///
  /// Supports:
  /// - Double values
  /// - Integer values (converted to double)
  ///
  /// Returns null if conversion fails.
  static double? _asDouble(dynamic val) {
    if (val is double) return val;
    if (val is int) return val.toDouble();
    return null;
  }

  /// Extracts a list of integer IDs from a dynamic value.
  ///
  /// Used for many2many relational fields.
  ///
  /// Returns an empty list if the value is not a valid list.
  static List<int> _getIdList(dynamic val) {
    if (val is List) return val.whereType<int>().toList();
    return [];
  }

  /// Extracts the ID from a many2one relational field.
  ///
  /// Expected format:
  /// `[id, name]`
  ///
  /// Returns null if structure is invalid.
  static int? _getId(dynamic val) {
    if (val is List && val.isNotEmpty && val[0] is int) {
      return val[0];
    }
    return null;
  }

  /// Extracts the display name from a many2one relational field.
  ///
  /// Expected format:
  /// `[id, name]`
  ///
  /// Returns null if structure is invalid.
  static String? _getName(dynamic val) {
    if (val is List && val.length > 1 && val[1] is String) {
      return val[1];
    }
    return null;
  }
}
