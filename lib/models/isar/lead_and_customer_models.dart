import 'package:isar_community/isar.dart';

part 'lead_and_customer_models.g.dart';

/// Represents a Lead item stored locally using Isar.
///
/// This model is used for caching CRM lead data
/// retrieved from the server.
@collection
class LeadItemModel {
  LeadItemModel();

  Id id = Isar.autoIncrement;

  int? serverId;
  String? name;
  String? email;
  String? createdOn;
  String? stage;
  String? salesperson;
  String? contactName;

  /// Creates a [LeadItemModel] from JSON data.
  ///
  /// Safely extracts:
  /// - Primitive values
  /// - many2one fields (like stage, user, partner)
  /// - Handles `false` values from Odoo
  factory LeadItemModel.fromJson(Map<String, dynamic> json) {
    return LeadItemModel()
      ..serverId = _asInt(json['id'])
      ..name = _asString(json['name']) ?? "Unknown"
      ..email = _asString(json['email_from'])
      ..createdOn = _asString(json['create_date']) ?? "Unknown"
      ..stage = _getName(json['stage_id']) ?? "Unknown"
      ..salesperson = _getName(json['user_id'])
      ..contactName = _getName(json['partner_id']);
  }
}

/// Represents a Customer (Partner) item stored locally using Isar.
///
/// Used for offline caching of customer data.
@collection
class CustomerItemModel {
  CustomerItemModel();

  Id id = Isar.autoIncrement;
  int? serverId;
  String? name;
  String? email;
  String? vat;
  String? fullName;

  /// Creates a [CustomerItemModel] from JSON data.
  ///
  /// Handles fallback logic for:
  /// - complete_name
  /// - name
  /// - default values
  factory CustomerItemModel.fromJson(Map<String, dynamic> json) {
    return CustomerItemModel()
      ..serverId = _asInt(json['id'])
      ..name = _asString(json['name']) ?? "Unknown"
      ..email = _asString(json['email']) ?? "N/A"
      ..vat = _asString(json['vat']) ?? "N/A"
      ..fullName = _asString(json['complete_name']) ??
          _asString(json['name']) ??
          "Unknown";
  }
}

/// Safely converts a dynamic value to a trimmed String.
///
/// Returns null if:
/// - Value is `false`
/// - Value is null
/// - Value is an empty string
String? _asString(dynamic val) {
  if (val == false) return null;
  if (val is String && val.trim().isNotEmpty) return val.trim();
  return null;
}

/// Safely converts a dynamic value to an int.
///
/// Returns null if:
/// - Value is `false`
/// - Value is not an integer
int? _asInt(dynamic val) {
  if (val == false) return null;
  if (val is int) return val;
  return null;
}

/// Extracts the display name from Odoo many2one fields.
///
/// Odoo many2one format:
/// `[id, name]`
///
/// Returns null if:
/// - Value is `false`
/// - Value is not a valid many2one list
String? _getName(dynamic val) {
  if (val == false) return null;
  if (val is List && val.length > 1 && val[1] is String) {
    return (val[1] as String).trim();
  }
  return null;
}

/// Represents an Account Payment Term.
///
/// Used for dropdown selections such as
/// "Immediate Payment", "30 Days", etc.
class AccountPaymentTerm {
  final int id;
  final String name;

  AccountPaymentTerm({required this.id, required this.name});

  /// Creates an [AccountPaymentTerm] from JSON.
  factory AccountPaymentTerm.fromJson(Map<String, dynamic> json) =>
      AccountPaymentTerm(
        id: json['id'],
        name: json['name'] ?? '',
      );
}

/// Represents an Industry model.
///
/// Used for assigning industry types to leads or customers.
class IndustryModel {
  final int id;
  final String name;

  IndustryModel({required this.id, required this.name});

  /// Creates an [IndustryModel] from JSON.
  factory IndustryModel.fromJson(Map<String, dynamic> json) => IndustryModel(
        id: json['id'],
        name: json['name'] ?? '',
      );
}

/// Represents an Account Payment Method.
///
/// Used for specifying payment methods like
/// Cash, Bank Transfer, Credit Card, etc.
class AccountPaymentMethod {
  final int id;
  final String name;

  AccountPaymentMethod({required this.id, required this.name});

  /// Creates an [AccountPaymentMethod] from JSON.
  factory AccountPaymentMethod.fromJson(Map<String, dynamic> json) =>
      AccountPaymentMethod(
        id: json['id'],
        name: json['name'] ?? '',
      );
}
