import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/utils/app_theme.dart';
import 'package:mobo_crm/global_methods/dialog boxes/activity_creation_dialog.dart';
import 'package:mobo_crm/global_methods/widgets/activity_icon.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/activity_model/activity_model.dart';
import 'package:mobo_crm/providers/activity_provider.dart';
import 'package:mobo_crm/utils/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/company/session/company_session_manager.dart';

/// A full-screen modal bottom sheet that displays and manages activities
/// (`mail.activity`) associated with a specific Odoo record (lead, opportunity, partner, etc.).
///
/// Features:
///   - List of existing activities with type icon, summary, assignee, deadline, and note
///   - Visual state indicators (overdue, today, tomorrow, planned)
///   - Pull-to-refresh to reload activities
///   - Floating "+" button to create new activity
///   - Long-press / tap on activity → bottom sheet with actions (Mark Done, Edit, Delete)
///   - Delete confirmation dialog
///   - Callback `onActivityChanged` triggered after create/mark-done/delete
class ActivityOverlay extends StatefulWidget {
  final int resId;
  final String resModel;
  final String recordName;
  final VoidCallback? onActivityChanged;

  const ActivityOverlay({
    super.key,
    required this.resId,
    required this.resModel,
    required this.recordName,
    this.onActivityChanged,
  });

  @override
  State<ActivityOverlay> createState() => _ActivityOverlayState();
}

class _ActivityOverlayState extends State<ActivityOverlay> {
  late ActivityProvider _activityProvider;
  bool isAdmin = false;

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

  /// Fetches the latest list of activities for the given record
  Future<void> _fetchActivities() async {
    await _activityProvider.fetchActivities(
      resId: widget.resId,
      resModel: widget.resModel,
    );
  }

  /// Marks the given activity as done via provider
  Future<void> _markActivityDone(ActivityModel activity) async {
    final success = await _activityProvider.markActivityDone(
      activityId: activity.id,
      resId: widget.resId,
      resModel: widget.resModel,
    );

    if (success) {
      widget.onActivityChanged?.call();
      if (mounted) {
        CustomSnackbar.showSuccess(context, 'Activity marked as done');
      }
    } else if (_activityProvider.error != null) {
      if (mounted) {
        CustomSnackbar.showError(context, _activityProvider.error!);
      }
    }
  }

  /// Deletes the given activity via provider
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

  /// Shows bottom sheet with activity action options (Mark Done, Edit, Delete)
  void _showActivityActions(ActivityModel activity) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors().fillColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Activity Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(
                        HugeIcons.strokeRoundedCheckmarkCircle01,
                        color: Colors.green),
                    title: const Text('Mark as Done'),
                    onTap: () {
                      Navigator.pop(context);
                      _markActivityDone(activity);
                    },
                  ),
                  ListTile(
                    leading: const Icon(HugeIcons.strokeRoundedEdit02,
                        color: Colors.blue),
                    title: const Text('Edit Activity'),
                    onTap: () {
                      Navigator.pop(context);
                      CustomSnackbar.showError(
                          context, 'Edit functionality coming soon');
                    },
                  ),
                  ListTile(
                    leading: const Icon(HugeIcons.strokeRoundedDelete02,
                        color: Colors.red),
                    title: const Text('Delete Activity'),
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteConfirmation(activity);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
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
        title: const Text('Delete Activity'),
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

  /// Determines the semantic state of an activity based on its deadline
  ///
  /// Returns one of: 'overdue', 'today', 'tomorrow', 'planned'
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
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: AppColors().fillColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Activities',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              widget.recordName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (isAdmin) ...[
                        IconButton(
                          onPressed: provider.isCreating
                              ? null
                              : _showCreateActivityDialog,
                          icon: provider.isCreating
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(HugeIcons.strokeRoundedAdd01),
                          style: IconButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(HugeIcons.strokeRoundedCancel01),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                Expanded(
                  child: provider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : provider.activities.isEmpty
                          ? Center(
                              child: isAdmin
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        const SizedBox(height: 8),
                                        Text(
                                          'Create your first activity to get started',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        ElevatedButton.icon(
                                          onPressed: provider.isCreating
                                              ? null
                                              : _showCreateActivityDialog,
                                          icon: const Icon(
                                              HugeIcons.strokeRoundedAdd01),
                                          label: const Text('Create Activity'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                          : RefreshIndicator(
                              onRefresh: _fetchActivities,
                              child: ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: provider.activities.length,
                                itemBuilder: (context, index) {
                                  final activity = provider.activities[index];
                                  final activityState =
                                      _getActivityState(activity);
                                  final activityTypeName =
                                      activity.activityTypeId.isNotEmpty
                                          ? activity.activityTypeId[1]
                                          : 'Activity';
                                  final assigneeName =
                                      activity.userId.isNotEmpty
                                          ? activity.userId[1]
                                          : 'Unassigned';

                                  final hasValidSummary =
                                      activity.summary.isNotEmpty &&
                                          activity.summary != 'false' &&
                                          activity.summary != 'null';
                                  final displaySummary = hasValidSummary
                                      ? activity.summary
                                      : activityTypeName;

                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: InkWell(
                                      onTap: () =>
                                          _showActivityActions(activity),
                                      borderRadius: BorderRadius.circular(12),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                ActivityIcon(
                                                  activityType:
                                                      activityTypeName,
                                                  activityState: activityState,
                                                  filled: true,
                                                  size: 20,
                                                  radius: 16,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        displaySummary,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        assigneeName,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ActivityIcon(
                                                  activityType:
                                                      activityTypeName,
                                                  activityState: activityState,
                                                  isLabel: true,
                                                  size: 14,
                                                ),
                                              ],
                                            ),
                                            if (activity.note.isNotEmpty) ...[
                                              const SizedBox(height: 12),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  activity.note,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ),
                                            ],
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Icon(
                                                  HugeIcons
                                                      .strokeRoundedCalendar03,
                                                  size: 16,
                                                  color: Colors.grey[600],
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  DateFormat('MMM dd, yyyy')
                                                      .format(
                                                    DateTime.parse(
                                                        activity.dateDeadline),
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                const Spacer(),
                                                Icon(
                                                  HugeIcons
                                                      .strokeRoundedMoreVertical,
                                                  size: 16,
                                                  color: Colors.grey[400],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Helper class with static method to easily show the `ActivityOverlay` as a modal bottom sheet
class ActivityOverlayHelper {
  /// Displays the activity overlay bottom sheet for a given record
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ActivityOverlay(
        resId: resId,
        resModel: resModel,
        recordName: recordName,
        onActivityChanged: onActivityChanged,
      ),
    );
  }
}
