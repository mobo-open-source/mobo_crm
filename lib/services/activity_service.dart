import 'package:mobo_crm/models/activity_model/activity_model.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import '../core/company/session/company_session_manager.dart';

/// Service class responsible for handling all Activity-related
/// operations with Odoo backend.
///
/// This service interacts with the `mail.activity`,
/// `mail.activity.type`, and `res.users` models using
/// `CompanySessionManager.callKwWithCompany`.
///
/// It provides CRUD operations, activity summaries,
/// and helper methods for fetching activity-related metadata.
class ActivityService {
  final OdooClient client;

  ActivityService({required this.client});

  /// Fetches all activities related to a specific record.
  ///
  /// [resId] - ID of the related record.
  /// [resModel] - Technical model name (e.g., 'crm.lead').
  ///
  /// Returns a list of [ActivityModel] sorted by `date_deadline` ascending.
  ///
  /// Throws an exception if the API call fails.
  Future<List<ActivityModel>> fetchActivities({
    required int resId,
    required String resModel,
  }) async {
    try {
      final result = await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'search_read',
        'args': [
          [
            ['res_id', '=', resId],
            ['res_model', '=', resModel],
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
            'state',
            'create_date',
            'write_date',
            'res_name',
          ],
          'order': 'date_deadline asc',
        },
      });

      final activities = (result as List)
          .map((item) => ActivityModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return activities;
    } catch (e) {
      rethrow;
    }
  }

  /// Creates a new activity in Odoo.
  ///
  /// Validates the model existence before creation.
  ///
  /// Parameters:
  /// - [resId]: ID of the related record.
  /// - [resModel]: Technical model name.
  /// - [activityTypeId]: ID of activity type.
  /// - [summary]: Short summary/title of the activity.
  /// - [note]: Detailed description.
  /// - [userId]: Assigned user ID.
  /// - [dateDeadline]: Deadline date (YYYY-MM-DD format).
  ///
  /// Returns the created activity ID.
  ///
  /// Throws an exception if model validation fails or creation fails.
  Future<int> createActivity({
    required int resId,
    required String resModel,
    required int activityTypeId,
    required String summary,
    required String note,
    required int userId,
    required String dateDeadline,
  }) async {
    try {
      final modelCheck = await CompanySessionManager.callKwWithCompany({
        'model': 'ir.model',
        'method': 'search_read',
        'args': [
          [
            ['model', '=', resModel]
          ]
        ],
        'kwargs': {
          'fields': ['id', 'model'],
          'limit': 1,
        },
      });

      if (modelCheck.isEmpty) {
        throw Exception('Invalid model: $resModel does not exist in Odoo');
      }

      final modelId = (modelCheck[0] as Map<String, dynamic>)['id'] as int;

      final activityData = {
        'res_model': resModel,
        'res_model_id': modelId,
        'res_id': resId,
        'activity_type_id': activityTypeId,
        'summary': summary.isNotEmpty ? summary : 'New Activity',
        'note': note,
        'user_id': userId,
        'date_deadline': dateDeadline,
      };

      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'create',
        'args': [activityData],
        'kwargs': {},
      });

      return response as int;
    } catch (e) {
      rethrow;
    }
  }

  /// Marks an activity as done.
  ///
  /// [activityId] - ID of the activity to complete.
  ///
  /// Throws an exception if the operation fails.
  Future<void> markActivityDone(int activityId) async {
    try {
      await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'action_done',
        'args': [
          [activityId]
        ],
        'kwargs': {},
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Updates an existing activity.
  ///
  /// [activityId] - ID of the activity.
  /// [updates] - Map of fields to update.
  ///
  /// Throws an exception if the update fails.
  Future<void> updateActivity({
    required int activityId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'write',
        'args': [
          [activityId],
          updates
        ],
        'kwargs': {},
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes an activity permanently.
  ///
  /// [activityId] - ID of the activity to delete.
  ///
  /// Throws an exception if deletion fails.
  Future<void> deleteActivity(int activityId) async {
    try {
      await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'unlink',
        'args': [
          [activityId]
        ],
        'kwargs': {},
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches all available activity types.
  ///
  /// Returns a list of maps containing:
  /// - id
  /// - name
  /// - icon
  /// - decoration_type
  /// - category
  ///
  /// Throws an exception if the API call fails.
  Future<List<Map<String, dynamic>>> getActivityTypes() async {
    try {
      final result = await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity.type',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name', 'icon', 'decoration_type', 'category'],
        }
      });
      return (result as List).cast<Map<String, dynamic>>();
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches all users from Odoo.
  ///
  /// Returns a list of maps containing:
  /// - id
  /// - name
  /// - email
  ///
  /// Throws an exception if the API call fails.
  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final result = await CompanySessionManager.callKwWithCompany({
        'model': 'res.users',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name', 'email'],
        }
      });

      return (result as List).cast<Map<String, dynamic>>();
    } catch (e) {
      rethrow;
    }
  }

  /// Returns total activity count for a record.
  ///
  /// [resId] - Related record ID.
  /// [resModel] - Technical model name.
  ///
  /// Returns 0 if an error occurs.
  Future<int> getActivityCount({
    required int resId,
    required String resModel,
  }) async {
    try {
      final result = await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'search_count',
        'args': [
          [
            ['res_id', '=', resId],
            ['res_model', '=', resModel],
          ]
        ],
        'kwargs': {},
      });

      return result as int;
    } catch (e) {
      return 0;
    }
  }

  /// Returns the count of overdue activities.
  ///
  /// An activity is considered overdue if
  /// `date_deadline` is before today's date.
  ///
  /// Returns 0 if an error occurs.
  Future<int> getOverdueActivityCount({
    required int resId,
    required String resModel,
  }) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];

      final result = await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'search_count',
        'args': [
          [
            ['res_id', '=', resId],
            ['res_model', '=', resModel],
            ['date_deadline', '<', today],
          ]
        ],
        'kwargs': {},
      });

      return result as int;
    } catch (e) {
      return 0;
    }
  }

  /// Returns the count of activities due today.
  ///
  /// Returns 0 if an error occurs.
  Future<int> getTodayActivityCount({
    required int resId,
    required String resModel,
  }) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];

      final result = await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'search_count',
        'args': [
          [
            ['res_id', '=', resId],
            ['res_model', '=', resModel],
            ['date_deadline', '=', today],
          ]
        ],
        'kwargs': {},
      });

      return result as int;
    } catch (e) {
      return 0;
    }
  }

  /// Returns a summary of activities grouped by status.
  ///
  /// Categories:
  /// - total: Total number of activities
  /// - overdue: Deadline before today
  /// - today: Deadline is today
  /// - planned: Deadline in the future
  ///
  /// Returns zeroed summary if an error occurs.
  Future<Map<String, int>> getActivitySummary({
    required int resId,
    required String resModel,
  }) async {
    try {
      final activities =
          await fetchActivities(resId: resId, resModel: resModel);
      final now = DateTime.now();

      int overdue = 0;
      int today = 0;
      int planned = 0;

      for (final activity in activities) {
        final deadline = DateTime.parse(activity.dateDeadline);

        if (deadline.isBefore(now)) {
          overdue++;
        } else if (deadline.day == now.day &&
            deadline.month == now.month &&
            deadline.year == now.year) {
          today++;
        } else {
          planned++;
        }
      }

      return {
        'total': activities.length,
        'overdue': overdue,
        'today': today,
        'planned': planned,
      };
    } catch (e) {
      return {
        'total': 0,
        'overdue': 0,
        'today': 0,
        'planned': 0,
      };
    }
  }
}
