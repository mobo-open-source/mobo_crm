import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

/// A dynamic pivot table widget that aggregates and displays Odoo data in a crosstab format.
///
/// Features:
///   - Rows grouped by a dynamic key (e.g. month, stage, creation date)
///   - Columns based on distinct values of another key (e.g. stage, month, quotation name)
///   - Cells show summed values (e.g. expected revenue, prorated revenue, count)
///   - Total row at bottom (except for "activities" mode)
///   - Horizontal scroll support for wide tables
///   - Context-aware formatting via `label` ("forecast", "lead", "activities", "pipeline", "quotation")
///   - Empty state with Odoo-themed "no data" image
///
/// Input data should be a flat list of Odoo record maps containing the relevant keys.
///
/// Example usage:
/// ```dart
/// PivotTable(
///   data: leadsData,
///   rowKey: 'create_date',
///   columnKey: 'stage_id',
///   valueKey: 'expected_revenue',
///   label: 'lead',
///   heading: 'Leads by Stage',
///   subHeading: 'Expected Revenue',
/// )
/// ```
class PivotTable extends StatelessWidget {
  final List<Map<dynamic, dynamic>> data;
  final String rowKey;
  final String columnKey;
  final String valueKey;
  final String label;
  final String heading;
  final String subHeading;

  const PivotTable({
    super.key,
    required this.data,
    required this.rowKey,
    required this.heading,
    this.subHeading = "Expected Revenue",
    required this.columnKey,
    required this.valueKey,
    required this.label,
  });

  /// Default empty state widget
  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No data Found to display',
      isDark: isDark,
    );
  }

  /// Builds centered empty state with Lottie animation
  Widget _buildCenteredLottie({
    required String lottie,
    required String title,
    required bool isDark,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(lottie, width: 260),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(child: _buildEmptyState(context));
    }

    Map<String, Map<String, double>> pivotData = {};
    Map<String, double> totalRow = {};
    double totalOverall = 0.0;
    for (var item in data) {
      String rowValue = _getRowValue(item);
      String columnValue = _getColumnValue(item);
      double value = _getValue(item);

      pivotData.putIfAbsent(rowValue, () => {});
      pivotData[rowValue]!
          .update(columnValue, (v) => v + value, ifAbsent: () => value);
      totalRow.update(columnValue, (v) => v + value, ifAbsent: () => value);

      if (label != "activities") {
        pivotData[rowValue]!
            .update("Total", (v) => v + value, ifAbsent: () => value);
        totalOverall += value;
      }
    }

    if (label != "activities") {
      totalRow["Total"] = totalOverall;
    }

    List<String> columns =
        pivotData.values.expand((row) => row.keys).toSet().toList();
    columns.sort();
    if (columns.contains("Total")) {
      columns.remove("Total");
      columns.add("Total");
    }

    if (data.isEmpty) {
      return Center(child: _buildEmptyState(context));
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Center(
                    child: Text(
                      subHeading,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            DataTable(
              columnSpacing: 20,
              headingRowColor: WidgetStateColor.resolveWith(
                  (states) => Theme.of(context).primaryColor),
              columns: [
                DataColumn(
                    label: Text(heading,
                        style: const TextStyle(color: Colors.white))),
                ...columns.map((col) => DataColumn(
                    label: Text(col,
                        style: const TextStyle(color: Colors.white)))),
              ],
              rows: [
                ...pivotData.entries.map((entry) {
                  return DataRow(
                    cells: [
                      DataCell(Text(entry.key)),
                      ...columns.map((col) => DataCell(Text(
                          entry.value[col]?.toStringAsFixed(2) ?? "0.00"))),
                    ],
                  );
                }),
                if (label != "activities")
                  DataRow(
                    cells: [
                      const DataCell(Text("Total",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                      ...columns.map((col) => DataCell(Text(
                            totalRow[col]?.toStringAsFixed(2) ?? "0.00",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ))),
                    ],
                  ),
              ],
            ),
          ],
        ),
      );
    }
  }

  /// Extracts the row label (group key) based on label mode
  String _getRowValue(Map<dynamic, dynamic> item) {
    switch (label) {
      case "forecast":
        return _formatDate(item['date_deadline']);
      case "lead":
        return _formatDate(item['create_date']);
      case "activities":
        return item['month'] ?? "Unknown";
      case "pipeline":
        return item['stage_id'] is List ? item['stage_id'][1] : "Unknown";
      case "quotation":
        return _formatDate(item[rowKey]);
      default:
        return _formatDate(item[rowKey]);
    }
  }

  /// Extracts the column label based on label mode
  String _getColumnValue(Map<dynamic, dynamic> item) {
    switch (label) {
      case "forecast":
        return item['stage_id'] is List ? item['stage_id'][1] : "Unknown";
      case "lead":
        return item['stage_id'] is List ? item['stage_id'][1] : "Unknown";
      case "activities":
        return 'count';
      case "pipeline":
        return _formatDate(item['create_date']);
      case "quotation":
        return item['name'];
      default:
        return item[columnKey] is List ? item[columnKey][1] : "Unknown";
    }
  }

  /// Extracts the numeric value to aggregate based on label mode
  double _getValue(Map<dynamic, dynamic> item) {
    switch (label) {
      case "forecast":
        return (item['prorated_revenue'] ?? 0).toDouble();
      case "lead":
        return (item['expected_revenue'] ?? 0).toDouble();
      case "activities":
        return (item['count'] ?? 0).toDouble();
      case "pipeline":
        return (item['prorated_revenue'] ?? 0).toDouble();
      case "quotation":
        return (item['amount_total'] ?? 0).toDouble();
      default:
        return (item[valueKey] ?? 0).toDouble();
    }
  }

  /// Formats a date string to "Month Year" (e.g. "February 2025")
  /// Returns "None" for invalid/missing dates
  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return "None";
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat.yMMMM().format(parsedDate);
    } catch (e) {
      return "None";
    }
  }
}
