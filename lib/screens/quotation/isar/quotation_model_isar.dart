import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';

part 'quotation_model_isar.g.dart';

/// Represents a quotation stored in the Isar database.
///
/// Contains all key details of a quotation, including amounts, partner info,
/// activity info, and currency.
@collection
class QuotationModelIsar {
  Id id = Isar.autoIncrement;
  int? serverId;
  String? name;
  String? state;

  int? partnerId;
  String? partnerName;

  double? amountTotal;
  double? amountTax;
  double? amountUntaxed;
  double? currencyRate;
  double? prepaymentPercent;

  String? dateOrder;
  String? invoiceStatus;

  int? userId;
  String? userName;

  int? activityTypeId;
  String? activityTypeName;

  String? activityState;
  int? activityUserId;
  String? activityUserName;
  String? activitySummary;
  String? activityDateDeadline;

  int? currencyId;
  String? currencyname;

  QuotationModelIsar();

  /// Creates an instance from a JSON map (from API or local server).
  factory QuotationModelIsar.fromJson(Map<String, dynamic> json) {
    return QuotationModelIsar()
      ..serverId = _asInt(json['id'])
      ..name = _asString(json['name'])
      ..state = _asString(json['state'])
      ..partnerId = _getId(json['partner_id'])
      ..partnerName = _getName(json['partner_id'])
      ..amountTotal = _asDouble(json['amount_total'])
      ..amountTax = _asDouble(json['amount_tax'])
      ..amountUntaxed = _asDouble(json['amount_untaxed'])
      ..currencyRate = _asDouble(json['currency_rate'])
      ..prepaymentPercent = _asDouble(json['prepayment_percent'])
      ..dateOrder = _parseDate(json['date_order'])
      ..invoiceStatus = _asString(json['invoice_status'])
      ..userId = _getId(json['user_id'])
      ..userName = _getName(json['user_id'])
      ..activityTypeId = _getId(json['activity_type_id'])
      ..activityTypeName = _getName(json['activity_type_id'])
      ..activityState = _asString(json['activity_state'])
      ..activityUserId = _getId(json['activity_user_id'])
      ..activityUserName = _getName(json['activity_user_id'])
      ..activitySummary = _asString(json['activity_summary'])
      ..activityDateDeadline = _parseDate(json['activity_date_deadline'])
      ..currencyId = _getId(json['currency_id'])
      ..currencyname = _getName(json['currency_id']);
  }

  /// Safely converts a dynamic value to int.
  static int? _asInt(dynamic val) => val is int ? val : null;

  /// Safely converts a dynamic value to non-empty String.
  static String? _asString(dynamic val) =>
      (val is String && val.isNotEmpty) ? val : null;

  /// Safely converts a dynamic value to double.
  static double? _asDouble(dynamic val) => val is num ? val.toDouble() : null;

  /// Parses a date string and formats it as 'yyyy-MM-dd'.
  static String? _parseDate(dynamic val) {
    if (val is String && val.isNotEmpty) {
      final parsed = DateTime.tryParse(val);
      if (parsed != null) {
        return DateFormat('yyyy-MM-dd').format(parsed);
      }
    }
    return null;
  }

  /// Extracts the ID from an Odoo-style [id, name] list.
  static int? _getId(dynamic val) =>
      val is List && val.isNotEmpty && val[0] is int ? val[0] : null;

  /// Extracts the name from an Odoo-style [id, name] list.
  static String? _getName(dynamic val) =>
      val is List && val.length > 1 && val[1] is String ? val[1] : null;
}

/// Represents a currency symbol stored in Isar.
@collection
class CurrencySymbolIsar {
  Id id = Isar.autoIncrement;

  int? currencyId;
  String? symbol;
  String? name;

  CurrencySymbolIsar();

  /// Creates an instance from JSON map.
  factory CurrencySymbolIsar.fromJson(Map<String, dynamic> json) {
    return CurrencySymbolIsar()
      ..currencyId = json['id'] as int?
      ..symbol = json['symbol'] as String?
      ..name = json['name'] as String?;
  }

  /// Converts the object to a Map (for serialization or storage).
  Map<String, dynamic> toMap() => {
        'id': currencyId,
        'symbol': symbol,
        'name': name,
      };
}
