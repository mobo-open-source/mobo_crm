import 'package:isar_community/isar.dart';

part 'lead_model_isar_graph.g.dart';

/// Isar collection model used for storing CRM Lead graph/analytics data locally.
///
/// This model is primarily used for:
/// - Pipeline stage analytics
/// - Revenue aggregation
/// - Graph/chart visualization
/// - Offline reporting support
///
/// Each record represents summarized lead data grouped by stage.
///
/// ### Notes:
/// - `id` is the local Isar auto-increment primary key.
/// - `stageName` is extracted from Odoo many2one field `stage_id`.
/// - All numeric values default to `0` to prevent null-related UI crashes.
/// - Designed specifically for dashboard and reporting features.
@collection
class LeadModelIsarGraph {
  Id id = Isar.autoIncrement;

  String? stageName;

  int count = 0;

  double expectedRevenue = 0;
  double recurringRevenueMonthly = 0;
  double recurringRevenue = 0;
  double probability = 0;
  double dayClose = 0;
  double recurringRevenueMonthlyProrated = 0;
  double recurringRevenueProrated = 0;
  double proratedRevenue = 0;

  LeadModelIsarGraph();

  /// Creates a [LeadModelIsarGraph] instance from JSON
  /// received from Odoo aggregated RPC response.
  ///
  /// Handles:
  /// - Safe numeric conversion
  /// - Many2one stage field extraction
  /// - Null fallback to `0` for numeric safety
  factory LeadModelIsarGraph.fromJson(Map<String, dynamic> json) {
    return LeadModelIsarGraph()
      ..stageName = _getIdName(json['stage_id'])
      ..expectedRevenue = _asDouble(json['expected_revenue']) ?? 0
      ..recurringRevenueMonthly =
          _asDouble(json['recurring_revenue_monthly']) ?? 0
      ..recurringRevenue = _asDouble(json['recurring_revenue']) ?? 0
      ..probability = _asDouble(json['probability']) ?? 0
      ..dayClose = _asDouble(json['day_close']) ?? 0
      ..recurringRevenueMonthlyProrated =
          _asDouble(json['recurring_revenue_monthly_prorated']) ?? 0
      ..recurringRevenueProrated =
          _asDouble(json['recurring_revenue_prorated']) ?? 0
      ..proratedRevenue = _asDouble(json['prorated_revenue']) ?? 0;
  }

  /// Safely converts numeric values to double.
  ///
  /// Returns `null` if the value is not a number.
  static double? _asDouble(dynamic val) {
    if (val is num) return val.toDouble();
    return null;
  }

  /// Extracts stage name from Odoo many2one format: `[id, name]`.
  ///
  /// Example:
  /// ```json
  /// "stage_id": [4, "Qualified"]
  /// ```
  static String? _getIdName(dynamic val) {
    if (val is List && val.length > 1 && val[1] is String) {
      return val[1];
    }
    return null;
  }
}
