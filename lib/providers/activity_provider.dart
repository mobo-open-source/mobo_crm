import 'package:flutter/material.dart';
import 'package:mobo_crm/models/activity_model/activity_model.dart';
import 'package:mobo_crm/services/activity_service.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

/// Provider class responsible for managing Activity state
/// and coordinating between UI and [ActivityService].
///
/// This class:
/// - Handles loading, creating, updating, and deleting activities
/// - Manages activity summary and count caching
/// - Exposes loading and error states for UI
/// - Caches activity types and users for performance optimization
///
/// Designed to be used with Flutter's Provider state management.
class ActivityProvider extends ChangeNotifier {
  final ActivityService _activityService;

  /// Creates an instance of [ActivityProvider].
  ///
  /// Requires an authenticated [OdooClient] to initialize
  /// the underlying [ActivityService].
  ActivityProvider({required OdooClient client})
      : _activityService = ActivityService(client: client);

  bool _isLoading = false;
  bool _isCreating = false;
  bool _isUpdating = false;
  String? _error;

  List<ActivityModel> _activities = [];
  Map<String, int> _activitySummary = {};

  final Map<String, Map<String, int>> _activityCountCache = {};

  bool get isLoading => _isLoading;

  bool get isCreating => _isCreating;

  bool get isUpdating => _isUpdating;

  String? get error => _error;

  List<ActivityModel> get activities => _activities;

  Map<String, int> get activitySummary => _activitySummary;

  /// Clears the current error message
  /// and notifies listeners.
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Returns cached activity count summary for a record,
  /// if available.
  ///
  /// Returns null if no cache exists.
  Map<String, int>? getCachedActivityCount({
    required int resId,
    required String resModel,
  }) {
    final key = '${resModel}_$resId';
    return _activityCountCache[key];
  }

  /// Fetches activities for a specific record.
  ///
  /// Updates:
  /// - [_activities]
  /// - [_activitySummary]
  /// - Loading and error states
  ///
  /// Notifies listeners on state changes.
  Future<void> fetchActivities({
    required int resId,
    required String resModel,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _activities = await _activityService.fetchActivities(
        resId: resId,
        resModel: resModel,
      );

      await _updateActivitySummary(resId: resId, resModel: resModel);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load activities: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a new activity.
  ///
  /// After successful creation:
  /// - Refreshes activities list
  /// - Clears cached summary for the record
  ///
  /// Returns true if successful, otherwise false.
  Future<bool> createActivity({
    required int resId,
    required String resModel,
    required int activityTypeId,
    required String summary,
    required String note,
    required int userId,
    required String dateDeadline,
  }) async {
    try {
      _isCreating = true;
      _error = null;
      notifyListeners();

      await _activityService.createActivity(
        resId: resId,
        resModel: resModel,
        activityTypeId: activityTypeId,
        summary: summary,
        note: note,
        userId: userId,
        dateDeadline: dateDeadline,
      );

      await fetchActivities(resId: resId, resModel: resModel);

      _clearCacheForRecord(resId: resId, resModel: resModel);

      _isCreating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to create activity: ${e.toString()}';
      _isCreating = false;
      notifyListeners();
      return false;
    }
  }

  /// Marks an activity as completed.
  ///
  /// After successful update:
  /// - Clears cache
  /// - Refreshes activities list
  ///
  /// Returns true if successful.
  Future<bool> markActivityDone({
    required int activityId,
    required int resId,
    required String resModel,
  }) async {
    try {
      _isUpdating = true;
      _error = null;
      notifyListeners();
      await _activityService.markActivityDone(activityId);
      _clearCacheForRecord(resId: resId, resModel: resModel);
      await fetchActivities(resId: resId, resModel: resModel);

      _isUpdating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to mark activity as done: ${e.toString()}';
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  /// Updates an existing activity with given fields.
  ///
  /// After successful update:
  /// - Refreshes activities
  /// - Clears cached summary
  ///
  /// Returns true if successful.
  Future<bool> updateActivity({
    required int activityId,
    required Map<String, dynamic> updates,
    required int resId,
    required String resModel,
  }) async {
    try {
      _isUpdating = true;
      _error = null;
      notifyListeners();

      await _activityService.updateActivity(
        activityId: activityId,
        updates: updates,
      );
      await fetchActivities(resId: resId, resModel: resModel);
      _clearCacheForRecord(resId: resId, resModel: resModel);

      _isUpdating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update activity: ${e.toString()}';
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  /// Deletes an activity permanently.
  ///
  /// After successful deletion:
  /// - Refreshes activities
  /// - Clears cached summary
  ///
  /// Returns true if successful.
  Future<bool> deleteActivity({
    required int activityId,
    required int resId,
    required String resModel,
  }) async {
    try {
      _isUpdating = true;
      _error = null;
      notifyListeners();

      await _activityService.deleteActivity(activityId);
      _clearCacheForRecord(resId: resId, resModel: resModel);
      await fetchActivities(resId: resId, resModel: resModel);

      _isUpdating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete activity: ${e.toString()}';
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  /// Returns activity summary for a record.
  ///
  /// Uses cached value unless [forceRefresh] is true.
  ///
  /// Returns a summary map containing:
  /// - total
  /// - overdue
  /// - today
  /// - planned
  Future<Map<String, int>> getActivityCount({
    required int resId,
    required String resModel,
    bool forceRefresh = false,
  }) async {
    final key = '${resModel}_$resId';

    if (!forceRefresh && _activityCountCache.containsKey(key)) {
      return _activityCountCache[key]!;
    }

    try {
      final summary = await _activityService.getActivitySummary(
        resId: resId,
        resModel: resModel,
      );

      _activityCountCache[key] = summary;

      return summary;
    } catch (e) {
      return {
        'total': 0,
        'overdue': 0,
        'today': 0,
        'planned': 0,
      };
    }
  }

  /// Updates internal activity summary and cache.
  ///
  /// Called internally after fetching activities.
  Future<void> _updateActivitySummary({
    required int resId,
    required String resModel,
  }) async {
    try {
      _activitySummary = await _activityService.getActivitySummary(
        resId: resId,
        resModel: resModel,
      );

      final key = '${resModel}_$resId';
      _activityCountCache[key] = _activitySummary;
    } catch (_) {}
  }

  /// Clears cached summary for a specific record.
  void _clearCacheForRecord({
    required int resId,
    required String resModel,
  }) {
    final key = '${resModel}_$resId';
    _activityCountCache.remove(key);
  }

  /// Clears all cached activity summaries.
  void clearCache() {
    _activityCountCache.clear();
    notifyListeners();
  }

  List<Map<String, dynamic>>? _activityTypes;

  /// Fetches available activity types.
  ///
  /// Uses cached value if already loaded.
  ///
  /// Returns empty list if request fails.
  Future<List<Map<String, dynamic>>> getActivityTypes() async {
    if (_activityTypes != null) {
      return _activityTypes!;
    }

    try {
      _activityTypes = await _activityService.getActivityTypes();
      return _activityTypes!;
    } catch (e) {
      return [];
    }
  }

  List<Map<String, dynamic>>? _users;

  /// Fetches all users.
  ///
  /// Uses cached value if already loaded.
  ///
  /// Returns empty list if request fails.
  Future<List<Map<String, dynamic>>> getUsers() async {
    if (_users != null) {
      return _users!;
    }

    try {
      _users = await _activityService.getUsers();
      return _users!;
    } catch (e) {
      return [];
    }
  }

  /// Resets the provider to initial state.
  ///
  /// Clears:
  /// - Activities
  /// - Summary
  /// - Cache
  /// - Activity types
  /// - Users
  /// - Loading and error states
  void reset() {
    _activities = [];
    _activitySummary = {};
    _activityCountCache.clear();
    _activityTypes = null;
    _users = null;
    _isLoading = false;
    _isCreating = false;
    _isUpdating = false;
    _error = null;
    notifyListeners();
  }

  /// Disposes the provider and clears all in-memory data.
  @override
  void dispose() {
    _activities.clear();
    _activitySummary.clear();
    _activityCountCache.clear();
    super.dispose();
  }
}
