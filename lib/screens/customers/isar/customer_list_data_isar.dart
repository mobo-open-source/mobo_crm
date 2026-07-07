import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';

part 'customer_list_data_isar.g.dart';

/// Local Isar collection model for caching customer list data.
///
/// This model represents a lightweight version of the
/// Odoo `res.partner` record used specifically for:
/// - Customer listing screens
/// - Fast offline access
/// - Reduced server calls
/// - Improved UI performance
///
/// It includes:
/// - Basic contact details
/// - Company and relationship information
/// - Activity tracking metadata
/// - Category labels for filtering/grouping
///
/// Designed for read-optimized list rendering.
@collection
class CustomerListDataIsar {
  /// Creates an empty instance of [CustomerListDataIsar].
  ///
  /// Typically used when mapping JSON data
  /// retrieved from the backend server.
  CustomerListDataIsar();

  Id id = Isar.autoIncrement;
  int? serverId;
  String? name;
  String? email;
  String? phone;
  String? city;

  int? stateId;
  String? stateName;

  int? countryId;
  String? countryName;

  String? companyType;
  String? companyName;

  int? meetingCount;
  int? opportunityCount;
  int? saleOrderCount;

  int? companyId;
  String? companyDisplayName;

  int? commercialPartnerId;
  String? commercialPartnerName;
  String? function;

  bool? isCompany;
  int? customerRank;
  int? supplierRank;

  bool? isActive;

  String? activityDateDeadline;
  int? activityTypeId;
  String? activityTypeName;
  int? activityUserId;
  String? activityUserName;
  String? activityState;
  String? activitySummary;
  String? activityTypeIcon;

  List<String>? categoryValues;

  /// Creates a [CustomerListDataIsar] object from
  /// a JSON response returned by the Odoo backend.
  ///
  /// Handles:
  /// - Null safety checks
  /// - Boolean-to-null normalization
  /// - Many2one field extraction ([id, name])
  /// - Date parsing and formatting
  /// - Safe list conversion for category values
  ///
  /// Ensures stable mapping to prevent runtime type issues.
  factory CustomerListDataIsar.fromJson(Map<String, dynamic> json) {
    return CustomerListDataIsar()
      ..serverId = _asInt(json['id'])
      ..name = _asString(json['name'])
      ..email = _asString(json['email'])
      ..phone = _asString(json['phone'])
      ..city = _asString(json['city'])
      ..stateId = _getId(json['state_id'])
      ..stateName = _getName(json['state_id'])
      ..countryId = _getId(json['country_id'])
      ..countryName = _getName(json['country_id'])
      ..companyType = _asString(json['company_type'])
      ..companyName = _asString(json['company_name'])
      ..meetingCount = _asInt(json['meeting_count'])
      ..opportunityCount = _asInt(json['opportunity_count'])
      ..saleOrderCount = _asInt(json['sale_order_count'])
      ..companyId = _getId(json['company_id'])
      ..companyDisplayName = _getName(json['company_id'])
      ..commercialPartnerId = _getId(json['commercial_partner_id'])
      ..commercialPartnerName = _getName(json['commercial_partner_id'])
      ..function = _asString(json['function'])
      ..isCompany = json['is_company'] == true
      ..customerRank = _asInt(json['customer_rank'])
      ..supplierRank = _asInt(json['supplier_rank'])
      ..isActive = json['active'] != false
      ..activityDateDeadline = _parseDate(json['activity_date_deadline'])
      ..activityTypeId = _getId(json['activity_type_id'])
      ..activityTypeName = _getName(json['activity_type_id'])
      ..activityUserId = _getId(json['activity_user_id'])
      ..activityUserName = _getName(json['activity_user_id'])
      ..activityState = _asString(json['activity_state'])
      ..activitySummary = _asString(json['activity_summary'])
      ..activityTypeIcon = _asString(json['activity_type_icon'])
      ..categoryValues = json['category_values'] is List
          ? (json['category_values'] as List).whereType<String>().toList()
          : null;
  }
}

/// Safely converts a dynamic value to a trimmed [String].
///
/// Returns null if:
/// - Value is `false`
/// - Value is not a string
/// - String is empty after trimming
String? _asString(dynamic val) {
  if (val == false) return null;
  if (val is String && val.trim().isNotEmpty) return val.trim();
  return null;
}

/// Safely converts a dynamic value to [int].
///
/// Returns null if:
/// - Value is `false`
/// - Value is not an integer
int? _asInt(dynamic val) {
  if (val == false) return null;
  if (val is int) return val;
  return null;
}

/// Parses and formats a date string into `yyyy-MM-dd`.
///
/// Uses [DateFormat] from the `intl` package.
/// Returns null if:
/// - Value is not a valid date string
/// - Parsing fails
String? _parseDate(dynamic val) {
  if (val is String && val.isNotEmpty) {
    final parsed = DateTime.tryParse(val);
    if (parsed != null) {
      return DateFormat('yyyy-MM-dd').format(parsed);
    }
  }
  return null;
}

/// Extracts the ID from a many2one relational field.
///
/// Expected structure:
/// `[id, display_name]`
///
/// Returns null if the structure is invalid.
int? _getId(dynamic val) {
  return (val is List && val.isNotEmpty && val[0] is int) ? val[0] : null;
}

/// Extracts the display name from a many2one relational field.
///
/// Expected structure:
/// `[id, display_name]`
///
/// Returns a trimmed string or null if invalid.
String? _getName(dynamic val) {
  return (val is List && val.length > 1 && val[1] is String)
      ? (val[1] as String).trim()
      : null;
}
