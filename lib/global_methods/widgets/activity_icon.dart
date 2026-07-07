import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

/// A circular or labeled badge icon representing a CRM activity type and its state.
///
/// Displays different icons based on activity type (email, call, meeting, to-do, etc.)
/// and colors based on state (planned/green, today/orange, overdue/red).
///
/// Two display modes:
///   1. **Icon-only** (`isLabel: false`): Small circular avatar (default)
///   2. **Labeled badge** (`isLabel: true`): Pill-shaped tag with icon + state text
///
/// Supports `filled` mode (solid background) and custom size/radius.
///
/// Typical use: next activity indicator in leads/opportunities, timeline items,
/// Kanban cards, or activity badges in lists.
class ActivityIcon extends StatelessWidget {
  final String? activityType;
  final String? activityState;
  final bool filled;
  final bool isLabel;
  final double radius;
  final double size;
  final Color? overrideColor;

  const ActivityIcon({
    super.key,
    this.activityType,
    this.activityState,
    this.filled = false,
    this.isLabel = false,
    this.size = 17,
    this.radius = 14,
    this.overrideColor,
  });

  /// Returns a type-based color for the given activity type name.
  static Color getTypeColor(String? activityType) {
    final lower = activityType?.toLowerCase() ?? '';
    if (lower.contains('call') || lower.contains('phone')) return Colors.blue;
    if (lower.contains('whatsapp')) return Colors.green;
    if (lower.contains('email') || lower.contains('mail')) return Colors.red;
    if (lower.contains('sms') || lower.contains('message')) return Colors.orange;
    if (lower.contains('meeting') || lower.contains('calendar') ||
        lower.contains('appointment')) return Colors.purple;
    if (lower.contains('todo') || lower.contains('to-do') ||
        lower.contains('task')) return const Color(0xFF43B75D);
    return const Color(0xFF43B75D);
  }

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.access_time;

    final activityTypeLower = activityType?.toLowerCase() ?? '';

    if (activityTypeLower.contains('email') ||
        activityTypeLower.contains('mail')) {
      icon = HugeIcons.strokeRoundedMail01;
    } else if (activityTypeLower.contains('call') ||
        activityTypeLower.contains('phone')) {
      icon = Icons.phone_outlined;
    } else if (activityTypeLower.contains('meeting') ||
        activityTypeLower.contains('appointment')) {
      icon = HugeIcons.strokeRoundedCalendar02;
    } else if (activityTypeLower.contains('to-do') ||
        activityTypeLower.contains('todo') ||
        activityTypeLower.contains('task')) {
      icon = HugeIcons.strokeRoundedCheckList;
    } else if (activityTypeLower.contains('upload')) {
      icon = HugeIcons.strokeRoundedFileUpload;
    } else if (activityTypeLower.contains('document')) {
      icon = Icons.article_outlined;
    } else if (activityTypeLower.contains('exception') ||
        activityTypeLower.contains('error')) {
      icon = HugeIcons.strokeRoundedAlertDiamond;
    } else if (activityTypeLower.contains('follow') ||
        activityTypeLower.contains('quote')) {
      icon = Icons.refresh_outlined;
    } else if (activityTypeLower.contains('demo')) {
      icon = HugeIcons.strokeRoundedVideo01;
    } else if (activityTypeLower.contains('upsell') ||
        activityTypeLower.contains('order')) {
      icon = Icons.bar_chart_outlined;
    } else {
      switch (activityType) {
        case 'Email':
          icon = HugeIcons.strokeRoundedMail01;
          break;
        case 'Call':
          icon = Icons.phone_outlined;
          break;
        case 'Meeting':
          icon = HugeIcons.strokeRoundedCalendar02;
          break;
        case 'To-Do':
          icon = HugeIcons.strokeRoundedCheckList;
          break;
        case 'Upload Document':
          icon = HugeIcons.strokeRoundedFileUpload;
          break;
        case 'Document':
          icon = Icons.article_outlined;
          break;
        case 'Exception':
          icon = HugeIcons.strokeRoundedAlertDiamond;
          break;
        case 'Follow-up Quote':
          icon = Icons.refresh_outlined;
          break;
        case 'Make Quote':
          icon = Icons.description_outlined;
          break;
        case 'Call for Demo':
          icon = HugeIcons.strokeRoundedVideo01;
          break;
        case 'Email: Welcome Demo':
          icon = HugeIcons.strokeRoundedStarFace;
          break;
        case 'Order Upsell':
          icon = Icons.bar_chart_outlined;
          break;
      }
    }

    Color color = Colors.grey;
    String stateText = '';
    if (activityState == 'planned' || activityState == 'tomorrow') {
      color = Colors.green;
      stateText = 'Planned';
    } else if (activityState == 'overdue') {
      color = Colors.red;
      stateText = 'Overdue';
    } else if (activityState == 'today') {
      color = Colors.orange;
      stateText = 'Today';
    }

    if (!isLabel) {
      return activityType != null
          ? Icon(icon, color: overrideColor ?? color, size: size)
          : Icon(Icons.access_time, color: overrideColor ?? Colors.grey, size: 20);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: size, color: color),
          const SizedBox(width: 6),
          Text(
            stateText,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
