import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:mobo_crm/global_methods/dialog%20boxes/activity_creation_dialog.dart';
import 'package:mobo_crm/utils/app_theme.dart';
import 'package:mobo_crm/global_methods/widgets/activity_icon.dart';
import 'package:mobo_crm/global_methods/widgets/buttons/custom_button.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/activity_model/activity_model.dart';
import 'package:mobo_crm/providers/activity_provider.dart';
import 'package:mobo_crm/utils/globals.dart';
import 'package:mobo_crm/utils/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/company/session/company_session_manager.dart';

/// A compact, dialog-style overlay that displays and manages activities
/// (`mail.activity`) for a specific Odoo record (lead, opportunity, partner, etc.).
///
/// Designed as a lighter, more focused alternative to the full bottom-sheet `ActivityOverlay`.
/// Features:
///   - Compact card-based list of activities
///   - Inline "Mark Done" and "Delete" buttons per activity
///   - Quick-create "+" button in header
///   - Loading / empty states with clean UI
///   - Small footprint (max ~70% screen height, constrained width)
///   - Closes on action success (mark done / delete)
class CompactActivityOverlay extends StatefulWidget {
  final int resId;
  final String resModel;
  final String recordName;
  final VoidCallback? onActivityChanged;

  const CompactActivityOverlay({
    super.key,
    required this.resId,
    required this.resModel,
    required this.recordName,
    this.onActivityChanged,
  });

  @override
  State<CompactActivityOverlay> createState() => _CompactActivityOverlayState();
}

class _CompactActivityOverlayState extends State<CompactActivityOverlay> {
  late ActivityProvider _activityProvider;
  bool isAdmin = false;
  final Set<int> _markingDoneIds = {};

  @override
  void initState() {
    super.initState();
    final client =
        Provider.of<OdooClientManager>(context, listen: false).client;
    if (client != null) {
      _activityProvider = ActivityProvider(client: client);
      _fetchActivities();
      canManageSkills();
    }
  }

  /// Parses the major version number from a server version string.
  int parseMajorVersion(String serverVersion) {
    final match = RegExp(r'\d+').firstMatch(serverVersion);
    if (match != null) {
      return int.tryParse(match.group(0)!) ?? 0;
    }
    return 0;
  }

  /// Checks whether the current user has admin permissions.
  Future<void> canManageSkills() async {
    final prefs = await SharedPreferences.getInstance();
    final String version = prefs.getString('serverVersion') ?? '0';
    final int userId = prefs.getInt('userId') ?? 0;
    final int majorVersion = parseMajorVersion(version);

    Future<bool> hasGroup(String groupExtId) async {
      if (majorVersion >= 18) {
        return await CompanySessionManager.callKwWithCompany({
              'model': 'res.users',
              'method': 'has_group',
              'args': [userId, groupExtId],
              'kwargs': {},
            }) ==
            true;
      } else {
        return await CompanySessionManager.callKwWithCompany({
              'model': 'res.users',
              'method': 'has_group',
              'args': [groupExtId],
              'kwargs': {},
            }) ==
            true;
      }
    }

    final admin = await hasGroup('base.group_system');

    setState(() {
      isAdmin = admin;
    });
  }

  /// Loads the list of activities for the current record
  Future<void> _fetchActivities() async {
    await _activityProvider.fetchActivities(
      resId: widget.resId,
      resModel: widget.resModel,
    );
  }

  /// Marks the specified activity as completed
  Future<void> _markActivityDone(ActivityModel activity) async {
    if (_markingDoneIds.contains(activity.id)) return;
    setState(() => _markingDoneIds.add(activity.id));

    try {
      final success = await _activityProvider.markActivityDone(
        activityId: activity.id,
        resId: widget.resId,
        resModel: widget.resModel,
      );

      if (success) {
        widget.onActivityChanged?.call();
        if (mounted) {
          CustomSnackbar.showSuccess(context, 'Activity marked as done');
          Navigator.of(context).pop();
        }
      } else if (_activityProvider.error != null) {
        if (mounted) {
          CustomSnackbar.showError(context, _activityProvider.error!);
        }
      }
    } finally {
      if (mounted) setState(() => _markingDoneIds.remove(activity.id));
    }
  }

  /// Deletes the specified activity after confirmation
  Future<void> _deleteActivity(ActivityModel activity) async {
    final success = await _activityProvider.deleteActivity(
      activityId: activity.id,
      resId: widget.resId,
      resModel: widget.resModel,
    );

    if (success) {
      widget.onActivityChanged?.call();

      if (mounted) {
        CustomSnackbar.showSuccess(context, 'Activity deleted');

        Navigator.of(context).pop();
      }
    } else if (_activityProvider.error != null) {
      if (mounted) {
        CustomSnackbar.showError(context, _activityProvider.error!);
      }
    }
  }

  /// Opens the activity creation dialog
  void _showCreateActivityDialog() {
    showDialog(
      context: context,
      builder: (context) => AddActivityDialog(
        resId: widget.resId,
        model: widget.resModel,
        onSuccess: () {
          _fetchActivities();
          widget.onActivityChanged?.call();
        },
      ),
    );
  }

  /// Shows confirmation dialog before deleting an activity
  void _showDeleteConfirmation(ActivityModel activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              HugeIcons.strokeRoundedDelete02,
              color: AppTheme.primaryColor,
              size: 22,
            ),
            const SizedBox(width: 8),
            const Text(
              'Delete Activity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'You\'re about to permanently delete this activity. Once deleted, it cannot be recovered.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteActivity(activity);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Classifies activity based on deadline relative to current time
  ///
  /// Returns: 'overdue', 'today', 'tomorrow', or 'planned'
  String _getActivityState(ActivityModel activity) {
    final now = DateTime.now();
    final deadline = DateTime.parse(activity.dateDeadline);

    if (deadline.isBefore(now)) {
      return 'overdue';
    } else if (deadline.day == now.day &&
        deadline.month == now.month &&
        deadline.year == now.year) {
      return 'today';
    } else if (deadline.difference(now).inDays == 1) {
      return 'tomorrow';
    } else {
      return 'planned';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ActivityProvider>.value(
      value: _activityProvider,
      child: Consumer<ActivityProvider>(
        builder: (context, provider, child) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(16),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
                maxWidth: 400,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppStyle.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            HugeIcons.strokeRoundedCalendar03,
                            color: AppStyle.primaryColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Activities',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.recordName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600]!,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            HugeIcons.strokeRoundedCancel01,
                            size: 18,
                          ),
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.black54,
                            padding: const EdgeInsets.all(6),
                            minimumSize: const Size(32, 32),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                    child: provider.isLoading
                        ? Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 16),
                                Text(
                                  'Loading activities...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : provider.activities.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(24),
                                child: isAdmin
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            HugeIcons.strokeRoundedCalendar03,
                                            size: 48,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'No activities found',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          SizedBox(
                                            width: double.infinity,
                                            height: 45,
                                            child: CustomButton(
                                              text: 'Create Activity',
                                              onPressed: provider.isCreating
                                                  ? () {}
                                                  : _showCreateActivityDialog,
                                              isLoading: provider.isCreating,
                                              fontSize: 16,
                                              height: 44,
                                              borderRadius: 8,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            HugeIcons.strokeRoundedCalendar03,
                                            size: 64,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No activities found',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(12),
                                itemCount: provider.activities.length,
                                itemBuilder: (context, index) {
                                  final activity = provider.activities[index];
                                  final activityState =
                                      _getActivityState(activity);
                                  final activityTypeName =
                                      activity.activityTypeId.isNotEmpty
                                          ? (activity.activityTypeId[1]
                                                  ?.toString() ??
                                              'Activity')
                                          : 'Activity';
                                  final assigneeName =
                                      activity.userId.isNotEmpty
                                          ? (activity.userId[1]?.toString() ??
                                              'Unassigned')
                                          : 'Unassigned';

                                  final hasValidSummary =
                                      activity.summary.isNotEmpty &&
                                          activity.summary != 'false' &&
                                          activity.summary != 'null';
                                  final displaySummary = hasValidSummary
                                      ? activity.summary
                                      : activityTypeName;

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            displaySummary,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                            maxLines: 4,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        ActivityIcon(
                                                          activityType:
                                                              activityTypeName,
                                                          activityState:
                                                              activityState,
                                                          isLabel: true,
                                                          size: 13,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      assigneeName,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (activity.note.isNotEmpty) ...[
                                            const SizedBox(height: 8),
                                            Text(
                                              "Note: ${activity.note?.replaceAll(RegExp(r'<[^>]*>'), '') ?? ''}",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[700],
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                HugeIcons
                                                    .strokeRoundedCalendar03,
                                                size: 13,
                                                color: Colors.grey[500],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                DateFormat('MMM dd, yyyy')
                                                    .format(
                                                  DateTime.parse(
                                                      activity.dateDeadline),
                                                ),
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  height: 45,
                                                  child: OutlinedButton(
                                                    onPressed: () =>
                                                        _showDeleteConfirmation(
                                                            activity),
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      foregroundColor:AppStyle.primaryColor,
                                                      side: BorderSide(
                                                        color:AppStyle.primaryColor,
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        color: AppStyle.primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: SizedBox(
                                                  height: 45,
                                                  child: ElevatedButton(
                                                    onPressed: _markingDoneIds.contains(activity.id)
                                                        ? null
                                                        : () => _markActivityDone(activity),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: AppStyle.primaryColor,
                                                      disabledBackgroundColor: AppStyle.primaryColor.withOpacity(0.6),
                                                      foregroundColor: Colors.white,
                                                      disabledForegroundColor: Colors.white,
                                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      elevation: 0,
                                                      shadowColor: Colors.transparent,
                                                    ),
                                                    child: _markingDoneIds.contains(activity.id)
                                                        ? const SizedBox(
                                                            width: 18,
                                                            height: 18,
                                                            child: CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              color: Colors.white,
                                                            ),
                                                          )
                                                        : const Text(
                                                            'Mark as Done',
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Helper class with static method to show `CompactActivityOverlay` as a dialog
class CompactActivityOverlayHelper {
  /// Opens the compact activity overlay dialog for the specified record
  ///
  /// Parameters:
  ///   - [context]             BuildContext
  ///   - [resId]               Record ID
  ///   - [resModel]            Odoo model name
  ///   - [recordName]          Display name of the record
  ///   - [onActivityChanged]   Optional callback after activity changes
  static void showActivityOverlay({
    required BuildContext context,
    required int resId,
    required String resModel,
    required String recordName,
    VoidCallback? onActivityChanged,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CompactActivityOverlay(
        resId: resId,
        resModel: resModel,
        recordName: recordName,
        onActivityChanged: onActivityChanged,
      ),
    );
  }
}
