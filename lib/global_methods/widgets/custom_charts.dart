import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobo_crm/screens/dashboard/provider/dashboard_provider.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/globals.dart';

/// A responsive bar chart widget displaying CRM data grouped by stage/month/quotation.
///
/// Features:
///   - Shows loading spinner during data fetch
///   - Displays animated empty state (ghost Lottie) when no data
///   - Supports multiple filters (count, revenue, MRR, probability, etc.)
///   - Rounded-top bars with data labels
///   - Category X-axis and numeric Y-axis
///   - Single solid color bars (primary theme color)
class BarChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> stageData;
  final String selectedFilter;
  final String label;
  final bool isGrapgnLoading;

  const BarChartWidget({
    super.key,
    required this.isGrapgnLoading,
    required this.stageData,
    required this.selectedFilter,
    required this.label,
  });

  /// Builds centered empty state with Lottie animation
  Widget _buildCenteredLottie({
    required String lottie,
    required String title,
    String? subtitle,
    Widget? button,
    required bool isDark,
  }) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
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
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
            if (button != null) ...[const SizedBox(height: 12), button],
          ],
        ),
      ),
    );
  }

  /// Default empty state widget
  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Leads Found',
      isDark: isDark,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DashboardProvider, OpportunityDataProvider>(
      builder: (context, provider, dataprovider, child) {
        if (isGrapgnLoading && stageData.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        } else if (stageData.isEmpty && !isGrapgnLoading) {
          return _buildEmptyState(context);
        } else if (_areAllValuesZero()) {
          return Center(child: _buildEmptyState(context));
        }

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 28, top: 40, bottom: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: BarChart(
                  _buildBarChartData(isDark),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  BarChartData _buildBarChartData(bool isDark) {
    final barDataList = _getBarChartData();

    if (barDataList.isEmpty) {
      return BarChartData();
    }

    final double maxY =
        barDataList.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.1;
    final double minY = 0;

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      minY: minY,
      maxY: maxY,
      barGroups: List.generate(barDataList.length, (index) {
        final item = barDataList[index];
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: item.value,
              width: 30,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(6),
                bottom: Radius.zero,
              ),
              color: isDark ? Colors.white : AppStyle.primaryColor,
            ),
          ],
        );
      }),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 56,
            getTitlesWidget: (value, meta) {
              if (value % 1 != 0) return const SizedBox.shrink();
              final index = value.toInt();
              if (index < 0 || index >= barDataList.length) {
                return const SizedBox.shrink();
              }
              final full = barDataList[index].stage;
              final name = full.length > 6 ? "${full.substring(0, 6)}…" : full;
              return SideTitleWidget(
                meta: meta,
                angle: -0.785,
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.right,
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            interval: (maxY - minY) / 5,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: false,
        horizontalInterval: (maxY - minY) / 5,
        getDrawingHorizontalLine: (value) => FlLine(
          color: isDark
              ? Colors.grey.shade700.withOpacity(0.5)
              : Colors.grey.shade400.withOpacity(0.7),
          strokeWidth: 1.0,
          dashArray: [7, 5],
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          left: BorderSide(
            color: isDark ? Colors.grey[600]! : Colors.grey[400]!,
            width: 1,
          ),
          bottom: BorderSide(
            color: isDark ? Colors.grey[600]! : Colors.grey[400]!,
            width: 1,
          ),
          top: BorderSide.none,
          right: BorderSide.none,
        ),
      ),
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final item = barDataList[group.x];
            final val = item.value.toInt();
            return BarTooltipItem(
              '${item.stage}\n$val',
              const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
      ),
    );
  }

  bool _areAllValuesZero() {
    String dataKey = _getDataKey(selectedFilter);
    List<dynamic> values = stageData.map((data) {
      return (data[dataKey] ?? 0).toDouble();
    }).toList();
    return values.every((value) => value == 0.0);
  }

  List<BarData> _getBarChartData() {
    String dataKey = _getDataKey(selectedFilter);
    return stageData.map((data) {
      String value;
      switch (label) {
        case "forecast":
          value = data['month'] ?? "Unknown";
          break;
        case "activities":
          value = data['month'] ?? "Unknown";
          break;
        case "quotation":
          value = data['name'] ?? "Unknown";
          break;
        default:
          value = data['stage'] ?? "Unknown";
      }
      return BarData(
        id: 0,
        stage: value,
        value: (data[dataKey] ?? 0).toDouble(),
        color: _getGradientColor(stageData.indexOf(data)),
      );
    }).toList()
      ..sort((a, b) => a.stage.compareTo(b.stage));
  }

  String _getDataKey(String filter) {
    Map<String, String> filterKeyMap = {
      "Days to Close": "total_day_close",
      "count": "Count",
      "Expected Revenue": "total_expected_revenue",
      "Expected MRR": "recurring_revenue_monthly",
      "Probability": "probability",
      "Prorated MRR": "recurring_revenue_monthly_prorated",
      "Prorated Recurring Revenue": "recurring_revenue_prorated",
      "Prorated Revenue": "prorated_revenue",
      "Recurring Revenue": "recurring_revenue",
      "Currency Rate": "currency_rate",
      "Prepayment Percent": "prepayment_percent",
      "Amount Tax": "amount_tax",
      "Amount Total": "amount_total",
      "Amount Untaxed": "amount_untaxed",
    };
    return filterKeyMap[filter] ?? "count";
  }

  Color _getGradientColor(int index) {
    List<Color> gradientColors = [
      Colors.blue.shade400,
      Colors.purple.shade400,
      Colors.orange.shade400,
      Colors.green.shade400,
      Colors.red.shade400,
      Colors.teal.shade400,
      Colors.indigo.shade400,
    ];
    return gradientColors[index % gradientColors.length];
  }
}

/// Data point for a bar chart: a pipeline [stage] with its [value], [color] and record [id].
class BarData {
  final String stage;
  final double value;
  final Color color;
  final int id;

  BarData({
    required this.stage,
    required this.value,
    required this.color,
    required this.id,
  });
}

/// A line/spline chart widget displaying CRM trends over time/stages.
///
/// Features:
///   - Shows loading spinner during data fetch
///   - Displays animated empty state when no data
///   - Supports multiple filters (count, revenue, MRR, probability, etc.)
///   - Smooth spline curve with outside data labels
///   - Category X-axis and numeric Y-axis
///   - Color from theme primaries (cycling)
class LineChartWidgetCustom extends StatelessWidget {
  final List<Map<String, dynamic>> stageData;
  final String selectedFilter;
  final String label;
  final bool isGrapgnLoading;

  const LineChartWidgetCustom({
    super.key,
    required this.isGrapgnLoading,
    required this.stageData,
    required this.selectedFilter,
    required this.label,
  });

  /// Builds centered empty state with Lottie animation
  Widget _buildCenteredLottie({
    required String lottie,
    required String title,
    String? subtitle,
    Widget? button,
    required bool isDark,
  }) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
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
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
            if (button != null) ...[const SizedBox(height: 12), button],
          ],
        ),
      ),
    );
  }

  /// Default empty state widget
  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Leads Found',
      isDark: isDark,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DashboardProvider, OpportunityDataProvider>(
      builder: (context, provider, dataprovider, child) {
        if (isGrapgnLoading && stageData.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (stageData.isEmpty && !isGrapgnLoading) {
          return _buildEmptyState(context);
        }

        final barData = _getLineChartData();

        if (_areAllValuesZero() || barData.isEmpty) {
          return Center(child: _buildEmptyState(context));
        }

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 28, top: 40, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: LineChart(
                  _buildLineChartData(isDark, barData),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  LineChartData _buildLineChartData(bool isDark, List<LineData> lineData) {
    if (lineData.isEmpty) return LineChartData();

    final double maxValue =
        lineData.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final double minY = 0;
    final double maxY = maxValue * 1.15.clamp(1.0, double.infinity);

    final List<FlSpot> spots = List.generate(lineData.length, (i) {
      return FlSpot(i.toDouble(), lineData[i].value);
    });

    final lineBar = LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.35,
      color: isDark
          ? Colors.white.withOpacity(0.7)
          : AppStyle.primaryColor.withOpacity(0.7),
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
          radius: 5,
          color: isDark ? Colors.white : AppStyle.primaryColor,
          strokeWidth: 2,
          strokeColor: isDark ? Colors.grey.shade900 : Colors.white,
        ),
      ),
    );

    return LineChartData(
      minX: -0.5,
      maxX: spots.length - 0.5,
      minY: minY,
      maxY: maxY,
      lineBarsData: [lineBar],
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: false,
        horizontalInterval: (maxY - minY) / 5,
        getDrawingHorizontalLine: (value) => FlLine(
          color: isDark
              ? Colors.grey.shade700.withOpacity(0.5)
              : Colors.grey.shade400.withOpacity(0.7),
          strokeWidth: 1.0,
          dashArray: [7, 5],
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          left: BorderSide(
            color: isDark ? Colors.grey[600]! : Colors.grey[400]!,
            width: 1,
          ),
          bottom: BorderSide(
            color: isDark ? Colors.grey[600]! : Colors.grey[400]!,
            width: 1,
          ),
          top: BorderSide.none,
          right: BorderSide.none,
        ),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 56,
            getTitlesWidget: (value, meta) {
              if (value % 1 != 0) return const SizedBox.shrink();
              final index = value.toInt();
              if (index < 0 || index >= lineData.length) {
                return const SizedBox.shrink();
              }
              final full = lineData[index].stage;
              final name = full.length > 6 ? "${full.substring(0, 6)}…" : full;
              return SideTitleWidget(
                meta: meta,
                angle: -0.785,
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.right,
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            interval: (maxY - minY) / 5,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
      ),
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots
                .map((spot) {
                  final index = spot.x.toInt();
                  if (index < 0 || index >= lineData.length) return null;
                  final item = lineData[index];
                  final val = item.value.toInt();
                  return LineTooltipItem(
                    '${item.stage}\n$val',
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                })
                .whereType<LineTooltipItem>()
                .toList();
          },
        ),
      ),
    );
  }

  bool _areAllValuesZero() {
    final dataKey = _getDataKey(selectedFilter);
    final values =
        stageData.map((data) => (data[dataKey] ?? 0).toDouble()).toList();
    return values.every((v) => v == 0.0);
  }

  List<LineData> _getLineChartData() {
    final dataKey = _getDataKey(selectedFilter);
    final list = stageData.map((data) {
      String stage;
      switch (label) {
        case "forecast":
        case "activities":
          stage = data['month'] ?? "Unknown";
          break;
        case "quotation":
          stage = data['name'] ?? "Unknown";
          break;
        default:
          stage = data['stage'] ?? "Unknown";
      }
      return LineData(
        stage: stage,
        value: (data[dataKey] ?? 0).toDouble(),
        color:
            Colors.primaries[stageData.indexOf(data) % Colors.primaries.length],
      );
    }).toList();

    list.sort((a, b) => a.stage.compareTo(b.stage));
    return list;
  }

  String _getDataKey(String filter) {
    const filterKeyMap = {
      "Days to Close": "total_day_close",
      "count": "Count",
      "Expected Revenue": "total_expected_revenue",
      "Expected MRR": "recurring_revenue_monthly",
      "Probability": "probability",
      "Prorated MRR": "recurring_revenue_monthly_prorated",
      "Prorated Recurring Revenue": "recurring_revenue_prorated",
      "Prorated Revenue": "prorated_revenue",
      "Recurring Revenue": "recurring_revenue",
      "Currency Rate": "currency_rate",
      "Prepayment Percent": "prepayment_percent",
      "Amount Tax": "amount_tax",
      "Amount Total": "amount_total",
      "Amount Untaxed": "amount_untaxed",
    };
    return filterKeyMap[filter] ?? "count";
  }
}

/// Data point for a line chart: a pipeline [stage] with its [value] and [color].
class LineData {
  final String stage;
  final double value;
  final Color color;

  LineData({
    required this.stage,
    required this.value,
    required this.color,
  });
}
