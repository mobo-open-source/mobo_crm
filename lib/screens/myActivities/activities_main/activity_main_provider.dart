import 'package:flutter/material.dart';
import 'package:mobo_crm/screens/myActivities/activity_details_screen.dart';
import 'package:mobo_crm/global_methods/services/global_error_handler.dart';
import 'package:mobo_crm/global_methods/services/isar_caching_service.dart';
import 'package:mobo_crm/global_methods/services/mobile_field_compatibility_service.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/company/services/company_session_service.dart';
import '../../../core/company/session/company_session_manager.dart';
import '../../../utils/globals.dart';
import '../../../utils/snackbar.dart';
import 'activity_edit_dialog.dart';
import 'isar/activity_model_isar.dart';

/// Provides state management and business logic for activities.
///
/// Handles fetching, categorization, marking as done, deletion, caching,
/// and displaying activity details. Supports categorization into overdue,
/// today, and upcoming activities.
class ActivitiesMainProvider with ChangeNotifier {
  final CompanySessionService sessionService;

  ActivitiesMainProvider({required this.sessionService});

  List<dynamic> allActivities = [];
  List<dynamic> overdue = [];
  List<dynamic> today = [];
  List<dynamic> upcoming = [];
  bool isLoading = true;
  String? errorMessage;
  AppError? activityError;
  bool hasError = false;

  /// Handles an action performed on an activity such as marking done or canceling.
  ///
  /// [activity] – the activity object to act upon.
  /// [action] – the action to perform: 'mark_done' or 'Cancel'.
  /// [client] – the Odoo client instance for API calls.
  /// [context] – the current BuildContext for showing UI messages.
  void handleActivityAction(Map<String, dynamic> activity, String action,
      OdooClient client, BuildContext context) async {
    try {
      switch (action) {
        case 'edit':
          showEditActivityDialog(context, activity, client);
          break;
        case 'mark_done':
          await markActivityDone(client, activity);
          CustomSnackbar.showSuccess(context, 'Activity marked as done');

          break;
        case 'Cancel':
          showDeleteConfirmation(activity, client, context);
          break;
      }
    } catch (e) {
      CustomSnackbar.showError(context, 'Error: $e');
    }
  }

  void showEditActivityDialog(
      BuildContext context, Map<String, dynamic> activity, OdooClient client,
      {Function(Map<String, dynamic>)? onSaved}) {
    showDialog(
      context: context,
      builder: (context) {
        return ActivityEditDialog(
          activity: activity,
          onSave: (data) async {
            await sessionService.callKwWithCompanyUpdate({
              'model': 'mail.activity',
              'method': 'write',
              'args': [
                [activity['id']],
                {
                  'activity_type_id': data['activity_type_id'],
                  'user_id': data['user_id'],
                  'summary': data['summary'],
                  'note': data['note'],
                  'date_deadline': data['date_deadline'],
                }
              ],
              'kwargs': {},
            });

            onSaved?.call(data);

            if (context.mounted) {
              CustomSnackbar.showSuccess(context, "Activity updated");
            }

            await fetchActivities();
          },
        );
      },
    );
  }

  void showActivityDetailsDialog(BuildContext context,
      Map<String, dynamic> activity, String activityType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityDetailsScreen(
          activity: activity,
          activityType: activityType,
        ),
      ),
    );
  }

  /// Formats a [DateTime] into a human-readable string relative to today.
  ///
  /// Examples:
  /// - 'Today'
  /// - 'Tomorrow'
  /// - '3 days overdue'
  /// - '26/2/2026' (default date format)
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    final difference = targetDate.difference(today).inDays;

    if (difference < 0) {
      return '${difference.abs()} days overdue';
    } else if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Shows a confirmation dialog before deleting an activity.
  ///
  /// If confirmed, calls [deleteActivity] and displays success/error snackbar.
  void showDeleteConfirmation(
    Map<String, dynamic> activity,
    OdooClient client,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        title: const Text(
          'Delete Activity',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this activity?',
          style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.4),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      foregroundColor: AppStyle.primaryColor,
                      side: BorderSide(color: AppStyle.primaryColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppStyle.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      try {
                        final success = await deleteActivity(client, activity);
                        if (context.mounted && success) {
                          CustomSnackbar.showSuccess(
                              context, 'Activity cancelled');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          CustomSnackbar.showError(
                              context, 'Error deleting activity: $e');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyle.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Fetches activities from Odoo and enriches them with contact details.
  ///
  /// If [isNotify] is true, notifies listeners while loading.
  /// Saves activities to Isar cache after enrichment.
  Future<void> fetchActivities({bool isNotify = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    final url = prefs.getString('url') ?? '';
    try {
      isLoading = true;
      errorMessage = null;
      if (isNotify) {
        notifyListeners();
      }

      await MobileFieldCompatibilityService.initialize();

      final rawActivities = await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'search_read',
        'args': [
          [
            [
              'res_model',
              'in',
              ['sale.order', 'crm.lead', 'res.partner']
            ],
            ['user_id', '=', userId],
          ]
        ],
        'kwargs': {
          'fields': [
            'id',
            'activity_type_id',
            'summary',
            'note',
            'date_deadline',
            'user_id',
            'res_model',
            'res_name',
            'state',
            'create_date',
            'res_id',
          ],
        },
      });

      final List<Map<String, dynamic>> enrichedActivities = [];

      for (final activity in rawActivities) {
        final sanitized = _sanitizeActivityData(activity);
        final String? model = sanitized['res_model'];
        final int? resId =
            sanitized['res_id'] is int ? sanitized['res_id'] : null;

        if (model != null && resId != null) {
          try {
            if (model == 'crm.lead') {
              final record =
                  await MobileFieldCompatibilityService.safeSearchRead(
                'crm.lead',
                [
                  ['id', '=', resId]
                ],
                ['phone', 'mobile', 'email_from', 'partner_id'],
              );

              if (record.isNotEmpty) {
                final data = record[0];
                sanitized['contact_phone'] = data['phone'] ?? '';
                sanitized['contact_mobile'] =
                    data['mobile'] ?? data['phone'] ?? '';
                sanitized['contact_email'] = data['email_from'] ?? '';
                sanitized['contact_name'] =
                    data['partner_id'] != false && data['partner_id'] is List
                        ? data['partner_id'][1]
                        : 'N/A';
              } else {
                sanitized['contact_phone'] = '';
                sanitized['contact_mobile'] = '';
                sanitized['contact_email'] = '';
                sanitized['contact_name'] = '';
              }
            } else if (model == 'sale.order') {
              final record = await CompanySessionManager.callKwWithCompany({
                'model': 'sale.order',
                'method': 'read',
                'args': [
                  [resId]
                ],
                'kwargs': {
                  'fields': ['partner_id'],
                },
              });

              if (record.isNotEmpty && record[0]['partner_id'] != null) {
                final partner = record[0]['partner_id'];
                final partnerId = partner is List ? partner[0] : partner;

                final partnerRecord =
                    await MobileFieldCompatibilityService.safeSearchRead(
                  'res.partner',
                  [
                    ['id', '=', partnerId]
                  ],
                  ['phone', 'mobile', 'email', 'name'],
                );

                if (partnerRecord.isNotEmpty) {
                  final data = partnerRecord[0];
                  sanitized['contact_phone'] = data['phone'] ?? '';
                  sanitized['contact_mobile'] =
                      data['mobile'] ?? data['phone'] ?? '';
                  sanitized['contact_email'] = data['email'] ?? '';
                  sanitized['contact_name'] = data['name'] ?? 'N/A';
                } else {
                  sanitized['contact_phone'] = '';
                  sanitized['contact_mobile'] = '';
                  sanitized['contact_email'] = '';
                  sanitized['contact_name'] = '';
                }
              } else {
                sanitized['contact_phone'] = '';
                sanitized['contact_mobile'] = '';
                sanitized['contact_email'] = '';
                sanitized['contact_name'] = '';
              }
            } else if (model == 'res.partner') {
              final partnerRecord =
                  await MobileFieldCompatibilityService.safeSearchRead(
                'res.partner',
                [
                  ['id', '=', resId]
                ],
                ['phone', 'mobile', 'email', 'name'],
              );

              if (partnerRecord.isNotEmpty) {
                final data = partnerRecord[0];
                sanitized['contact_phone'] = data['phone'] ?? '';
                sanitized['contact_mobile'] =
                    data['mobile'] ?? data['phone'] ?? '';
                sanitized['contact_email'] = data['email'] ?? '';
                sanitized['contact_name'] = data['name'] ?? 'N/A';
              } else {
                sanitized['contact_phone'] = '';
                sanitized['contact_mobile'] = '';
                sanitized['contact_email'] = '';
                sanitized['contact_name'] = '';
              }
            } else {
              sanitized['contact_phone'] = '';
              sanitized['contact_mobile'] = '';
              sanitized['contact_email'] = '';
              sanitized['contact_name'] = '';
            }
          } catch (e) {
            sanitized['contact_phone'] = '';
            sanitized['contact_mobile'] = '';
            sanitized['contact_email'] = '';
            sanitized['contact_name'] = '';
          }
        } else {
          sanitized['contact_phone'] = '';
          sanitized['contact_mobile'] = '';
          sanitized['contact_email'] = '';
          sanitized['contact_name'] = '';
        }

        enrichedActivities.add(sanitized);
      }

      final activityCacheObjects = enrichedActivities
          .map((e) => ActivityModelIsar.fromJson(e))
          .toList()
          .cast<ActivityModelIsar>();
      await IsarService.saveActivities(activityCacheObjects);

      allActivities = enrichedActivities;
      _categorizeActivities();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      bool success = false;
      if (allActivities.isEmpty) {
        success = await getActivitiesFromIsar();
      }

      if (allActivities.isEmpty) {
        errorMessage = 'Failed to fetch activities: $e';
        activityError = await ErrorHandler.handleException(e, uri: url);
        Future.delayed(const Duration(seconds: 2), () {
          hasError = true;
          notifyListeners();
        });
      }
      isLoading = false;
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Marks an activity as done via Odoo API and refreshes activity list.
  Future<void> markActivityDone(
      OdooClient client, Map<String, dynamic> activity) async {
    try {
      allActivities.removeWhere((a) => a['id'] == activity['id']);
      _categorizeActivities();
      notifyListeners();

      await sessionService.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'action_done',
        'args': [activity['id']],
        'kwargs': {},
      });
      fetchActivities();
    } catch (e) {
      await fetchActivities();
      throw Exception('Error marking activity as done: $e');
    }
  }

  /// Deletes an activity via Odoo API and refreshes activity list.
  ///
  /// Returns `true` if deletion was successful, `false` otherwise.
  Future<bool> deleteActivity(
      OdooClient client, Map<String, dynamic> activity) async {
    try {
      allActivities.removeWhere((a) => a['id'] == activity['id']);
      _categorizeActivities();
      notifyListeners();

      await sessionService.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'unlink',
        'args': [activity['id']],
        'kwargs': {},
      });

      fetchActivities();
      return true;
    } catch (e) {
      await fetchActivities();
      return false;
    }
  }

  /// Sanitizes activity data by replacing null or false values with `"N/A"`.
  Map<String, dynamic> _sanitizeActivityData(Map<String, dynamic> activity) {
    return activity.map((key, value) {
      if (value == false || value == null) {
        return MapEntry(key, "N/A");
      }
      if (value is List && value.isEmpty) {
        return MapEntry(key, "N/A");
      }
      return MapEntry(key, value);
    });
  }

  /// Categorizes [allActivities] into [overdue], [today], and [upcoming] lists.
  void _categorizeActivities() {
    overdue = [];
    today = [];
    upcoming = [];

    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);

    for (final activity in allActivities) {
      final deadlineRaw = activity['date_deadline'];

      if (deadlineRaw == null || deadlineRaw == 'N/A') {
        continue;
      }

      DateTime deadline;
      try {
        deadline = DateTime.parse(deadlineRaw).toLocal();
      } catch (_) {
        continue;
      }

      final deadlineDate =
          DateTime(deadline.year, deadline.month, deadline.day);

      if (deadlineDate.isBefore(todayDate)) {
        overdue.add(activity);
      } else if (deadlineDate.isAtSameMomentAs(todayDate)) {
        today.add(activity);
      } else if (deadlineDate.isAfter(todayDate)) {
        upcoming.add(activity);
      }
    }
  }

  /// Fetches activities from Isar cache if server fetch fails.
  ///
  /// Returns `true` if cached activities were found, `false` otherwise.
  Future<bool> getActivitiesFromIsar() async {
    try {
      final cachedItems = await IsarService.getCachedActivities();

      allActivities = cachedItems.map((item) {
        return {
          'id': item.activityId,
          'activity_type_id': item.activityTypeId != null
              ? [item.activityTypeId, item.activityTypeName]
              : 'N/A',
          'summary': item.summary ?? 'N/A',
          'note': item.note ?? 'N/A',
          'date_deadline': item.dateDeadline ?? 'N/A',
          'user_id': item.userId != null ? [item.userId, item.userName] : 'N/A',
          'res_model': item.resModel ?? 'N/A',
          'res_name': item.resName ?? 'N/A',
          'state': item.state ?? 'N/A',
          'create_date': item.createDate ?? 'N/A',
          'res_id': item.resId ?? 'N/A',
          'contact_phone': item.contactPhone ?? '',
          'contact_mobile': item.contactMobile ?? '',
          'contact_email': item.contactEmail ?? '',
          'contact_name': item.contactName ?? '',
        };
      }).toList();

      _categorizeActivities();

      notifyListeners();
      if (allActivities.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (cacheError) {
      return false;
    }
  }
}
