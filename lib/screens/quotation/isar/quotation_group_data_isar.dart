import 'package:isar_community/isar.dart';

part 'quotation_group_data_isar.g.dart';

/// Represents a quotation group stored in the local Isar database.
///
/// This class holds summary data for a group of quotations, including
/// counts, amounts, tax, and currency information.
@collection
class QuotationGroupDataIsar {
  Id id = Isar.autoIncrement;
  String? name;
  int count = 0;

  double currencyRate = 0;
  double prepaymentPercent = 0;
  double amountTax = 0;
  double amountTotal = 0;
  double amountUntaxed = 0;

  QuotationGroupDataIsar();

  /// Creates a [QuotationGroupDataIsar] instance from a map (e.g., JSON or API response).
  ///
  /// Converts numeric values safely to `double` and provides default values
  /// if the map does not contain a valid value.
  ///
  /// Example:
  /// ```dart
  /// final data = QuotationGroupDataIsar.fromMap({
  ///   'name': 'Q1 Group',
  ///   'count': 5,
  ///   'currency_rate': 1.2,
  ///   'prepayment_percent': 10,
  ///   'amount_tax': 50,
  ///   'amount_total': 550,
  ///   'amount_untaxed': 500,
  /// });
  /// ```
  factory QuotationGroupDataIsar.fromMap(Map<String, dynamic> map) {
    return QuotationGroupDataIsar()
      ..name = map['name']
      ..count = map['count'] ?? 0
      ..currencyRate = _asDouble(map['currency_rate']) ?? 0
      ..prepaymentPercent = _asDouble(map['prepayment_percent']) ?? 0
      ..amountTax = _asDouble(map['amount_tax']) ?? 0
      ..amountTotal = _asDouble(map['amount_total']) ?? 0
      ..amountUntaxed = _asDouble(map['amount_untaxed']) ?? 0;
  }

  /// Safely converts a dynamic value to `double`.
  ///
  /// Returns `null` if the value is not a number.
  static double? _asDouble(dynamic val) {
    if (val is num) return val.toDouble();
    return null;
  }
}
