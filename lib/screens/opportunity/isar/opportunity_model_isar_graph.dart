import 'package:isar_community/isar.dart';

part 'opportunity_model_isar_graph.g.dart';

/// Represents aggregated opportunity data for graphing or reporting purposes
/// in the Isar database cache.
///
/// This model is designed to store summarized information about opportunities,
/// typically grouped by stage or other criteria, to support charts, dashboards,
/// or analytics. It includes metrics such as expected revenue, recurring revenue,
/// probability, and average days to close.
///
/// Fields:
/// - [id]: Auto-incremented local database ID.
/// - [stageName]: Name of the opportunity stage (e.g., "Qualified", "Won").
/// - [count]: Number of opportunities in this stage.
/// - [expectedRevenue]: Total expected revenue for the opportunities in this stage.
/// - [recurringRevenueMonthly]: Total recurring revenue per month.
/// - [recurringRevenue]: Total recurring revenue.
/// - [probability]: Average probability of closing opportunities in this stage.
/// - [dayClose]: Average number of days to close opportunities.
/// - [recurringRevenueMonthlyProrated]: Total prorated monthly recurring revenue.
/// - [recurringRevenueProrated]: Total prorated recurring revenue.
/// - [proratedRevenue]: Total prorated revenue.
///
/// Methods:
/// - [fromJson]: Factory constructor to create an instance from a JSON map.
///
/// Helper methods:
/// - [_asDouble]: Safely converts a dynamic value to double.
/// - [_getIdName]: Extracts the name from a `[id, name]` list used in server responses.
///
/// Example JSON input:
/// ```json
/// {
///   "stage_id": [5, "Negotiation"],
///   "expected_revenue": 10000,
///   "recurring_revenue_monthly": 2000,
///   "probability": 80
/// }
/// ```
@collection
class OpportunityModelIsarGraph {
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

  OpportunityModelIsarGraph();

  /// Creates an [OpportunityModelIsarGraph] instance from a JSON map.
  ///
  /// Safely converts numeric fields to double and extracts the stage name
  /// from the `[id, name]` list structure used in server responses.
  factory OpportunityModelIsarGraph.fromJson(Map<String, dynamic> json) {
    return OpportunityModelIsarGraph()
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

  /// Safely converts a dynamic value to [double].
  static double? _asDouble(dynamic val) {
    if (val is num) return val.toDouble();
    return null;
  }

  /// Extracts the name from a `[id, name]` list used in server responses.
  ///
  /// Returns null if the input is not a valid list with a string name at index 1.
  static String? _getIdName(dynamic val) {
    if (val is List && val.length > 1 && val[1] is String) {
      return val[1];
    }
    return null;
  }
}
