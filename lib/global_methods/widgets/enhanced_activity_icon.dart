import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/global_methods/overlays/compact_activity_overlay.dart';
import 'package:mobo_crm/global_methods/utils/activity_utils.dart';
import 'package:mobo_crm/global_methods/widgets/activity_icon.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/providers/activity_provider.dart';
import 'package:provider/provider.dart';

/// Enhanced, interactive activity indicator with badge count, color-coded state,
/// and tap-to-open compact activity overlay.
///
/// Features:
///   - Shows current/next activity icon (or fallback calendar)
///   - Displays total pending activities as badge (red/orange/green based on urgency)
///   - Small red dot for overdue activities
///   - Loading spinner during initial fetch
///   - Tap opens compact overlay for viewing/scheduling activities
///   - Auto-refreshes count after overlay interaction
///
/// Used in Kanban tiles, list views, detail screens, etc. to show activity status.
class EnhancedActivityIcon extends StatefulWidget {
  final int resId;
  final String resModel;
  final String recordName;
  final String? activityType;
  final String? activityState;
  final bool showBadge;
  final double size;
  final double radius;
  final VoidCallback? onActivityChanged;

  const EnhancedActivityIcon({
    super.key,
    required this.resId,
    required this.resModel,
    required this.recordName,
    this.activityType,
    this.activityState,
    this.showBadge = true,
    this.size = 17,
    this.radius = 14,
    this.onActivityChanged,
  });

  @override
  State<EnhancedActivityIcon> createState() => _EnhancedActivityIconState();
}

class _EnhancedActivityIconState extends State<EnhancedActivityIcon> {
  /// Map of activity counts: {'total': int, 'overdue': int, 'today': int, ...}
  Map<String, int>? _activityCount;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.showBadge) {
      _loadActivityCount();
    }
  }

  /// Fetches activity counts from Odoo via ActivityProvider
  Future<void> _loadActivityCount() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final client =
          Provider.of<OdooClientManager>(context, listen: false).client;
      if (client != null) {
        final activityProvider = ActivityProvider(client: client);
        final count = await activityProvider.getActivityCount(
          resId: widget.resId,
          resModel: widget.resModel,
        );

        if (mounted) {
          setState(() {
            _activityCount = count;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Opens the compact activity overlay and refreshes count on close
  void _showActivityOverlay() {
    CompactActivityOverlayHelper.showActivityOverlay(
      context: context,
      resId: widget.resId,
      resModel: widget.resModel,
      recordName: widget.recordName,
      onActivityChanged: () {
        widget.onActivityChanged?.call();
        if (widget.showBadge) {
          _loadActivityCount();
        }
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  /// Determines badge background color based on urgency
  Color _getBadgeColor() {
    if (_activityCount == null) return Colors.grey;

    final overdue = _activityCount!['overdue'] ?? 0;
    final today = _activityCount!['today'] ?? 0;

    if (overdue > 0) return Colors.red;
    if (today > 0) return Colors.orange;
    return Colors.green;
  }

  /// Formats badge text (capped at '99+')
  String _getBadgeText() {
    if (_activityCount == null) return '';

    final total = _activityCount!['total'] ?? 0;
    if (total > 99) return '99+';
    return total.toString();
  }

  /// Builds the main activity icon (with fallback logic)
  Widget _buildActivityIcon() {
    if (widget.activityType != null && widget.activityState != null) {
      return ActivityIcon(
        activityType: widget.activityType,
        activityState: widget.activityState,
        size: widget.size,
        radius: widget.radius,
      );
    }

    Color iconColor = Colors.grey;
    IconData iconData = HugeIcons.strokeRoundedCalendar03;

    if (_activityCount != null) {
      final overdue = _activityCount!['overdue'] ?? 0;
      final today = _activityCount!['today'] ?? 0;
      final total = _activityCount!['total'] ?? 0;

      if (total == 0) {
        iconColor = Colors.grey[400]!;
        iconData = HugeIcons.strokeRoundedCalendar03;
      } else if (overdue > 0) {
        iconColor = Colors.red;
        iconData = HugeIcons.strokeRoundedAlarmClock;
      } else if (today > 0) {
        iconColor = Colors.orange;
        iconData = HugeIcons.strokeRoundedCalendar03;
      } else {
        iconColor = Colors.green;
        iconData = HugeIcons.strokeRoundedCalendar03;
      }
    }

    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: Colors.transparent,
      child: Icon(
        iconData,
        color: iconColor,
        size: widget.size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showActivityOverlay,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _isLoading
              ? SizedBox(
                  width: widget.radius * 2,
                  height: widget.radius * 2,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : _buildActivityIcon(),

          if (widget.showBadge &&
              _activityCount != null &&
              (_activityCount!['total'] ?? 0) > 0 &&
              !_isLoading)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _getBadgeColor(),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  _getBadgeText(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          if (widget.showBadge &&
              _activityCount != null &&
              (_activityCount!['overdue'] ?? 0) > 0 &&
              !_isLoading)
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Wrapper around `EnhancedActivityIcon` that extracts activity info from a record map.
///
/// Automatically determines `resId`, `resModel`, `recordName`, `activityType`, and `activityState`
/// using `ActivityUtils` helpers.
///
/// Used in Kanban tiles, list views, or any place where you have a raw record map.
class KanbanActivityIcon extends StatelessWidget {
  final Map<dynamic, dynamic> record;
  final VoidCallback? onActivityChanged;

  const KanbanActivityIcon({
    super.key,
    required this.record,
    this.onActivityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final activityInfo = ActivityUtils.extractActivityInfo(record);
    final recordId = ActivityUtils.getRecordId(record);
    final recordName = ActivityUtils.getRecordName(record);
    final recordModel = ActivityUtils.getRecordModel(record);
    String? activityState = activityInfo['state'];
    if (activityState == null && activityInfo['deadline'] != null) {
      activityState =
          ActivityUtils.determineActivityState(activityInfo['deadline']);
    }

    return EnhancedActivityIcon(
      resId: recordId,
      resModel: recordModel,
      recordName: recordName,
      activityType: activityInfo['type'],
      activityState: activityState,
      showBadge: false,
      onActivityChanged: onActivityChanged,
    );
  }
}

/// Small counter widget showing total pending activities for a record.
///
/// Features:
///   - Shows calendar icon + number (or just number)
///   - Color-coded based on urgency (red = overdue, orange = today, grey = none)
///   - Loading spinner during fetch
///   - Hidden when count is zero
///
/// Used in list tiles, detail views, or next to record names.
class ActivityCounter extends StatefulWidget {
  final int resId;
  final String resModel;
  final TextStyle? textStyle;
  final bool showIcon;

  const ActivityCounter({
    super.key,
    required this.resId,
    required this.resModel,
    this.textStyle,
    this.showIcon = true,
  });

  @override
  State<ActivityCounter> createState() => _ActivityCounterState();
}

class _ActivityCounterState extends State<ActivityCounter> {
  Map<String, int>? _activityCount;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActivityCount();
  }

  /// Fetches activity counts from Odoo
  Future<void> _loadActivityCount() async {
    if (!mounted) return;

    try {
      final client =
          Provider.of<OdooClientManager>(context, listen: false).client;
      if (client != null) {
        final activityProvider = ActivityProvider(client: client);
        final count = await activityProvider.getActivityCount(
          resId: widget.resId,
          resModel: widget.resModel,
        );

        if (mounted) {
          setState(() {
            _activityCount = count;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (_activityCount == null || (_activityCount!['total'] ?? 0) == 0) {
      return const SizedBox.shrink();
    }

    final total = _activityCount!['total'] ?? 0;
    final overdue = _activityCount!['overdue'] ?? 0;
    final today = _activityCount!['today'] ?? 0;

    Color textColor = Colors.grey[600]!;
    if (overdue > 0) {
      textColor = Colors.red;
    } else if (today > 0) {
      textColor = Colors.orange;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showIcon) ...[
          Icon(
            HugeIcons.strokeRoundedCalendar03,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: 4),
        ],
        Text(
          total.toString(),
          style: widget.textStyle?.copyWith(color: textColor) ??
              TextStyle(
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
