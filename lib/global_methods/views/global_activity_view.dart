import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mobo_crm/core/colors/app_colors.dart';

/// A table-style activity data grid with horizontal scroll.
///
/// Displays CRM activities in a bordered card table with:
/// - Fixed-width name column
/// - Fixed-width activity type columns with date pill badges
/// - Horizontal scrolling for overflow
/// - Divider rows between items
class ActivityDataGrid extends StatelessWidget {
  final List<Map<dynamic, dynamic>> data;
  final List<String> activityTypes;
  final Map<String, Color> activityColors;
  final String label;
  final Widget Function(Map<String, dynamic>) itemBuilder;

  static const double _nameColWidth = 140.0;
  static const double _activityColWidth = 100.0;
  static const double _rowHeight = 72.0;

  const ActivityDataGrid({
    super.key,
    required this.data,
    required this.activityTypes,
    required this.activityColors,
    required this.label,
    required this.itemBuilder,
  });

  Widget _buildCenteredLottie({
    required String lottie,
    required String title,
    String? subtitle,
    Widget? button,
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredData = data.where((item) {
      final deadline = item['activity_date_deadline'];
      return deadline != false &&
          deadline != null &&
          deadline.toString().isNotEmpty;
    }).toList();

    if (filteredData.isEmpty) {
      return _buildCenteredLottie(
        lottie: 'assets/empty_ghost.json',
        title: 'No activities scheduled',
        isDark: isDark,
      );
    }

    final totalWidth =
        _nameColWidth + (activityTypes.length * _activityColWidth) + 2;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Align(
      alignment: Alignment.topCenter,
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: totalWidth,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : const Color(0xFFE0E0E0),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeaderRow(isDark),
                ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredData.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark
                        ? Colors.grey[700]
                        : const Color(0xFFEEEEEE),
                  ),
                  itemBuilder: (context, index) {
                    return _buildDataRow(
                        context, filteredData[index], index + 1, isDark);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    ),
    );
  }

  Widget _buildHeaderRow(bool isDark) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF8F8F8),
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[700]! : const Color(0xFFE0E0E0),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: _nameColWidth,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              label == 'quotation' ? 'Product' : 'Name',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: isDark ? Colors.grey[200] : Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ...activityTypes.map(
            (activity) => Container(
              width: _activityColWidth,
              alignment: Alignment.center,
              child: Text(
                activity,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: isDark ? Colors.grey[200] : Colors.black,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(
    BuildContext context,
    Map<dynamic, dynamic> item,
    int rowNumber,
    bool isDark,
  ) {
    String stage = "Unknown";
    double expectedRevenue = 0.0;
    String name = "Unknown";
    String partnerName = "";

    if (label == "lead") {
      stage = item['stage_id'] is List
          ? item['stage_id'][1] ?? 'Unknown'
          : 'Unknown';
      expectedRevenue = (item['expected_revenue'] ?? 0.0).toDouble();
      name = item['name'] ?? 'Unknown';
    } else if (label == "quotation") {
      stage = item['state'] ?? 'Unknown';
      expectedRevenue = (item['amount_total'] ?? 0.0).toDouble();
      partnerName = item['partner_id'] is List
          ? item['partner_id'][1] ?? 'Unknown'
          : 'Unknown';
      name = partnerName;
    }

    final nameCellValue = {
      'partner': partnerName,
      'id': item['id'],
      'name': name,
      'user_id': item['user_id'] is List ? item['user_id'][0] : null,
      'stage': stage,
      'expected_revenue': expectedRevenue,
    };

    Map<String, dynamic>? activityData;
    String? matchedType;
    if (item['activity_type_id'] is List) {
      final actType = item['activity_type_id'][1] as String?;
      if (actType != null && activityTypes.contains(actType)) {
        matchedType = actType;
        activityData = {
          'date': item['activity_date_deadline'] ?? 'No Date',
          'state': item['activity_state'] ?? 'unknown',
          'user': item['activity_user_id'] is List
              ? item['activity_user_id'][0]
              : null,
        };
      }
    }

    return SizedBox(
      height: _rowHeight,
      child: Row(
        children: [
          SizedBox(
            width: _nameColWidth,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$rowNumber. ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  Expanded(child: itemBuilder(nameCellValue)),
                ],
              ),
            ),
          ),
          ...activityTypes.map((activity) {
            final hasActivity = matchedType == activity && activityData != null;

            return SizedBox(
              width: _activityColWidth,
              child: Center(
                child: hasActivity
                    ? _buildActivityBadge(
                        activityData['date'].toString(),
                      )
                    : Text(
                        '–',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey[600] : Colors.grey[400],
                        ),
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActivityBadge(String date) {
    final formattedDate = _formatDate(date);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        formattedDate,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd/MM/yy').format(parsed);
    } catch (_) {
      return 'Invalid';
    }
  }
}
