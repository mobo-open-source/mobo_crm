import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:in_app_review/in_app_review.dart';
import 'package:mobo_crm/Rating/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import '../core/navigation/global_keys.dart';

/// A singleton service that manages in-app review requests and
/// user feedback flow.
///
/// This service:
/// - Tracks app opens and significant user events.
/// - Determines when to show a custom rating dialog based on:
///     • Minimum app opens
///     • Minimum significant events
///     • Minimum days since first launch
/// - Prevents repeated prompts within the same app session.
/// - Supports postponing review requests.
/// - Allows users to permanently disable review prompts.
/// - Sends users who rate the app well to its own store page: the App Store
///   on iOS, Google Play on Android.
/// - Sends email feedback for low ratings (1–3 stars).
///
/// Review Flow:
/// 1. App usage is tracked via [trackAppOpen] and [trackSignificantEvent].
/// 2. [checkAndShowRating] evaluates whether conditions are met.
/// 3. If eligible, a [CustomRatingDialog] is displayed.
/// 4. Based on rating:
///     • High rating (≥4): opens the store page (see [openStoreListing]).
///     • Low rating (<4): sends feedback email and postpones review.
///
/// Persistent state is stored using SharedPreferences.
class ReviewService {
  static final ReviewService _instance = ReviewService._internal();
  factory ReviewService() => _instance;
  ReviewService._internal();

  final InAppReview _inAppReview = InAppReview.instance;

  static const String _keyOpenCount = 'review_open_count';
  static const String _keyEventCount = 'review_event_count';
  static const String _keyFirstOpenDate = 'review_first_open_date';
  static const String _keyNextAllowedDate = 'review_next_allowed_date';
  static const String _keyNeverAskAgain = 'review_never_ask_again';

  static const int _thresholdOpens = 5;
  static const int _thresholdEvents = 5;
  static const int _thresholdDays = 5;

  /// App Store id of the iOS app (apps.apple.com/…/id6756002668).
  static const String _appStoreId = '6756002668';

  /// The App Store page of the app, opened on its "write a review" screen.
  ///
  /// The path carries no country code on purpose: the App Store app resolves
  /// it to the user's own storefront, so it works outside India too.
  static final Uri _appStoreReviewUri = Uri.parse(
    'https://apps.apple.com/app/id$_appStoreId?action=write-review',
  );

  /// The Google Play page of the app (package `com.cybrosys.mobo_crm`).
  static final Uri _playStoreUri = Uri.parse(
    'https://play.google.com/store/apps/details?id=com.cybrosys.mobo_crm',
  );

  bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  /// Name of the store the user is sent to on this device.
  String get _storeName => _isIOS ? 'App Store' : 'Google Play';

  bool _wasRequestedThisRun = false;

  Future<void> trackAppOpen() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_keyFirstOpenDate)) {
      await prefs.setInt(_keyFirstOpenDate, DateTime.now().millisecondsSinceEpoch);
    }

    int currentOpens = prefs.getInt(_keyOpenCount) ?? 0;
    currentOpens++;
    await prefs.setInt(_keyOpenCount, currentOpens);
  }

  Future<void> trackSignificantEvent() async {
    final prefs = await SharedPreferences.getInstance();

    int currentEvents = prefs.getInt(_keyEventCount) ?? 0;

    currentEvents++;
    await prefs.setInt(_keyEventCount, currentEvents);
  }

  Future<void> _checkAndRequestReview(SharedPreferences prefs, [BuildContext? context]) async {
    if (_wasRequestedThisRun) return;

    if (prefs.getBool(_keyNeverAskAgain) ?? false) {
      return;
    }

    int? nextAllowedEpoch = prefs.getInt(_keyNextAllowedDate);
    if (nextAllowedEpoch != null) {
      final nextAllowedDate = DateTime.fromMillisecondsSinceEpoch(nextAllowedEpoch);
      if (DateTime.now().isBefore(nextAllowedDate)) {
        return;
      }
    }

    if (await _inAppReview.isAvailable()) {
      bool shouldRequest = false;

      int openCount = prefs.getInt(_keyOpenCount) ?? 0;
      if (openCount >= _thresholdOpens) {
        shouldRequest = true;
      }

      int eventCount = prefs.getInt(_keyEventCount) ?? 0;
      if (eventCount >= _thresholdEvents) {
        shouldRequest = true;
      }

      int? firstOpenEpoch = prefs.getInt(_keyFirstOpenDate);
      if (firstOpenEpoch != null) {
        final firstOpenDate = DateTime.fromMillisecondsSinceEpoch(firstOpenEpoch);
        final diff = DateTime.now().difference(firstOpenDate).inDays;
        if (diff >= _thresholdDays) {
          shouldRequest = true;
        }
      }

      if (shouldRequest) {
        if (context != null && context.mounted) {
          _wasRequestedThisRun = true;

          CustomRatingDialog.show(context);
        } else {
        }
      } else {
      }
    } else {
    }
  }

  /// Postpone the review dialog by a specific duration
  Future<void> postponeReview(Duration duration) async {
    final prefs = await SharedPreferences.getInstance();
    final nextAllowedDate = DateTime.now().add(duration);
    await prefs.setInt(_keyNextAllowedDate, nextAllowedDate.millisecondsSinceEpoch);
  }

  /// Track app open and show dialog if criteria met
  Future<void> checkAndShowRating(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await _checkAndRequestReview(prefs, context);
  }

  /// Takes a user who rated the app well to its store page, to leave a review:
  /// the App Store on iOS, Google Play on Android.
  ///
  /// The store page is opened directly rather than asking the system for an
  /// in-app review sheet. That sheet is rationed by the OS (it is simply not
  /// shown once the quota is used, and never in TestFlight), and a request
  /// that is not shown reports no error, so the user was left with nothing but
  /// a "requesting review" message.
  Future<void> forceRequestReview() async {
    await postponeReview(const Duration(days: 30));
    _wasRequestedThisRun = true;

    final messenger = scaffoldMessengerKey.currentState;
    messenger?.showSnackBar(
      SnackBar(
        content: Text('Opening the $_storeName...'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue[700],
      ),
    );

    final opened = await openStoreListing();
    if (!opened) {
      messenger?.showSnackBar(
        SnackBar(
          content: Text(
            "Couldn't open the $_storeName. "
            'Please search for "Mobo CRM for Odoo" there.',
          ),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  /// Opens this app's page in the store of the current platform: the App Store
  /// (on its "write a review" screen) on iOS, Google Play on Android.
  ///
  /// Returns whether a store page could be opened. Use it for the review flow
  /// or for a "Rate Us" button.
  Future<bool> openStoreListing() async {
    if (_isIOS) {
      if (await _launch(_appStoreReviewUri)) return true;
      try {
        // iOS needs the app's id; without it the plugin refuses to open.
        await _inAppReview.openStoreListing(appStoreId: _appStoreId);
        return true;
      } catch (_) {
        return false;
      }
    }

    try {
      // On Android the plugin finds the app by its own package name.
      await _inAppReview.openStoreListing();
      return true;
    } catch (_) {
      return _launch(_playStoreUri);
    }
  }

  Future<bool> _launch(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  /// Send email feedback for low ratings (1-3 stars)
  Future<void> sendEmailFeedback(double rating, String comment) async {
    try {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'cybroplay@gmail.com',
        query: encodeQueryParameters(<String, String>{
          'subject': 'Feedback for Odoo Mobile Community (${rating.toInt()} Stars)',
          'body': 'Rating: ${rating.toInt()}/5\n\nComment:\n$comment\n\n---\nSent from Odoo Mobile Community'
        }),
      );

      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
      }
    } catch (e) {
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  /// Permanently disable future review requests
  Future<void> neverAskAgain() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNeverAskAgain, true);
  }

  /// Reset all review tracking data (useful for testing)
  Future<void> resetReviewTracking() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyOpenCount);
    await prefs.remove(_keyEventCount);
    await prefs.remove(_keyFirstOpenDate);
    await prefs.remove(_keyNextAllowedDate);
    await prefs.remove(_keyNeverAskAgain);
  }
}
