import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:lottie/lottie.dart';
import 'package:mobo_crm/global_methods/widgets/activity_icon.dart';
import 'package:mobo_crm/global_methods/widgets/shimmer/custom_shimmer.dart';
import 'package:mobo_crm/models/activity_model/activity_model.dart';
import 'package:mobo_crm/global_methods/services/isar_caching_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/company/session/company_session_manager.dart';
import 'Isar/mail_activity_model_isar.dart';

/// Screen listing the activities that belong to a single [MailActivityGroup].
class MailActivityListScreen extends StatelessWidget {
  final MailActivityGroup group;

  const MailActivityListScreen({
    super.key,
    required this.group,
  });

  Future<List<Map<String, dynamic>>> _fetchActivities() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    try {
      final result = await CompanySessionManager.callActivity(
        model: 'mail.activity',
        method: 'search_read',
        args: [
          [
            if (group.model.isNotEmpty) ['res_model', '=', group.model],
            ['user_id', '=', userId],
          ],
          [
            'summary',
            'note',
            'date_deadline',
            'activity_type_id',
            'res_name',
            'user_id',
            'res_model',
            'res_id',
          ],
        ],
        kwargs: {
          'context': {'lang': 'en_US', 'tz': 'Asia/Calcutta', 'uid': userId},
        },
      );

      if (result is List) {
        final activities = result.cast<Map<String, dynamic>>();
        final activityCacheObjects = activities
            .map((e) => MailActivityIsar.fromJson({...e, 'group_id': group.id}))
            .toList();
        await IsarService.saveMailActivities(group.id, activityCacheObjects);
        return activities;
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      final cachedActivities =
          await IsarService.getCachedMailActivities(group.id);
      if (cachedActivities.isNotEmpty) {
        return cachedActivities.map((a) => a.toJson()).toList();
      }
      throw Exception('Error fetching activities: $e');
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Activities Found',
      isDark: isDark,
    );
  }

  Widget _buildCenteredLottie({
    required String lottie,
    required String title,
    required bool isDark,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sw = MediaQuery.of(context).size.width;
        final scale = (sw / 375).clamp(0.8, 1.2);
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(lottie, width: sw * 0.65),
                  SizedBox(height: 8 * scale),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: (18 * scale).clamp(14, 22),
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF1A1A1A),
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
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = Theme.of(context).primaryColor;
    final sw = MediaQuery.of(context).size.width;
    final scale = (sw / 375).clamp(0.8, 1.2);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        forceMaterialTransparency: false,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: false,
        title: Text(
          group.name != '' ? '${group.name} Activities' : 'All Activities',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: (20 * scale).clamp(16, 24),
          ),
        ),
        backgroundColor: Colors.grey[50],
        automaticallyImplyLeading: false,
        elevation: 2,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemBuilder: (_, __) => const ActivityItemShimmer(),
              itemCount: 4,
            );
          }
          if (snapshot.hasError) {
            return Center(child: _buildEmptyState(context));
          }
          final activities = snapshot.data ?? [];
          if (activities.isEmpty) {
            return Center(
              child: Text(
                'No activities found for ${group.name}',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: (16 * scale).clamp(13, 19),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.only(
              bottom: (16 * scale).clamp(10, 24),
            ),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _buildActivityItem(
                  context, activity, colorScheme, primaryColor);
            },
          );
        },
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    Map<String, dynamic> activity,
    ColorScheme colorScheme,
    Color primaryColor,
  ) {
    String s(dynamic v, [String fallback = '']) =>
        (v == null || v == false) ? fallback : v.toString();

    final userName = activity['user_id'] is List
        ? s(activity['user_id'][1], 'Unknown')
        : 'Unknown';
    final summary = s(activity['summary']);
    final note = s(activity['note']);
    final dateDeadline = s(activity['date_deadline'], 'No deadline');
    final dateDeadlineStr = activity['date_deadline'] == false
        ? null
        : activity['date_deadline'] as String?;
    final activityType = activity['activity_type_id'] is List
        ? s(activity['activity_type_id'][1], 'Unknown')
        : 'Unknown';
    final resName = s(activity['res_name'], 'No name');

    String activityState = 'planned';
    if (dateDeadlineStr != null) {
      try {
        final deadline = DateTime.parse(dateDeadlineStr).toLocal();
        final today = DateTime.now();
        if (deadline.year == today.year &&
            deadline.month == today.month &&
            deadline.day == today.day) {
          activityState = 'today';
        } else if (deadline.isBefore(today)) {
          activityState = 'overdue';
        }
      } catch (_) {
        activityState = 'Invalid date';
      }
    } else {
      activityState = 'No deadline';
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final scale = (sw / 375).clamp(0.8, 1.2);

    final hPad = (16 * scale).clamp(10.0, 24.0);
    final cardPad = (16 * scale).clamp(12.0, 20.0);
    final titleFontSize = (16 * scale).clamp(13.0, 20.0);
    final bodyFontSize = (14 * scale).clamp(11.0, 17.0);
    final labelFontSize = (14 * scale).clamp(11.0, 17.0);
    final fieldGap = (8 * scale).clamp(5.0, 12.0);
    final sectionGap = (16 * scale).clamp(10.0, 20.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Container(
        margin: EdgeInsets.only(top: (18 * scale).clamp(10.0, 24.0)),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius:
              BorderRadius.circular((16 * scale).clamp(12.0, 20.0)),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.18)
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(cardPad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      resName,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(width: (12 * scale).clamp(8.0, 16.0)),
                  ActivityIcon(
                    isLabel: true,
                    activityState: activityState,
                    activityType: activityType,
                  ),
                ],
              ),
              SizedBox(height: sectionGap),
              Divider(
                color: Colors.grey.shade200,
                thickness: 1,
                height: 1,
              ),
              SizedBox(height: sectionGap),
              _detailRow(
                label: 'Assigned to',
                value: userName,
                labelSize: labelFontSize,
                valueSize: bodyFontSize,
                scale: scale,
              ),
              SizedBox(height: fieldGap),
              _detailRow(
                label: 'Deadline',
                value: dateDeadline,
                labelSize: labelFontSize,
                valueSize: bodyFontSize,
                scale: scale,
              ),
              if (summary.isNotEmpty) ...[
                SizedBox(height: fieldGap),
                _detailRow(
                  label: 'Summary',
                  value: summary,
                  labelSize: labelFontSize,
                  valueSize: bodyFontSize,
                  scale: scale,
                ),
              ],
              if (note.isNotEmpty) ...[
                SizedBox(height: fieldGap),
                _detailRow(
                  label: 'Note',
                  value: parseHtmlString(note),
                  labelSize: labelFontSize,
                  valueSize: bodyFontSize,
                  scale: scale,
                ),
              ],
              SizedBox(height: (10 * scale).clamp(6.0, 14.0)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow({
    required String label,
    required String value,
    required double labelSize,
    required double valueSize,
    required double scale,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: (90 * scale).clamp(72.0, 110.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
              fontSize: labelSize,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: valueSize,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    return document.body?.text ?? '';
  }
}
