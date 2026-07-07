import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../utils/snackbar.dart';

/// A singleton notifier that monitors the device's network connectivity status
/// in real-time and shows user-friendly SnackBars when the connection changes.
///
/// Features:
///   - Uses `connectivity_plus` to detect network changes (Wi-Fi/mobile/off)
///   - Uses `internet_connection_checker` to verify actual internet reachability
///   - Shows success/error SnackBars when going online/offline
///   - Safe handling of context (checks `mounted` before showing SnackBars)
///   - Singleton pattern — only one instance exists in the app
///
/// Usage:
///   - Call `initialize(context)` once early in the app lifecycle (e.g. after login
///     or in a top-level widget's `initState`)
///   - Call `dispose()` when the monitoring is no longer needed (e.g. on logout)
///
/// Important:
///   - `initialize` must receive a valid `BuildContext` with a `ScaffoldMessenger` ancestor
///   - The checker runs every ~3 seconds (configurable via `checkInterval`)
class NetworkStatusNotifier {
  static final NetworkStatusNotifier _instance =
      NetworkStatusNotifier._internal();

  factory NetworkStatusNotifier() => _instance;

  NetworkStatusNotifier._internal();

  late StreamSubscription _subscription;
  bool _isConnected = true;

  /// Starts listening to connectivity changes and shows SnackBars on status updates.
  ///
  /// Must be called with a `BuildContext` that has access to `ScaffoldMessenger`.
  /// Safe to call multiple times (idempotent after first initialization).
  ///
  /// Parameters:
  ///   - [context]   BuildContext used to show SnackBars
  void initialize(BuildContext context) {
    final internetChecker = InternetConnectionChecker.createInstance(
      checkInterval: const Duration(seconds: 3),
    );

    _subscription = Connectivity().onConnectivityChanged.listen((_) async {
      final hasConnection = await internetChecker.hasConnection;

      if (hasConnection != _isConnected) {
        _isConnected = hasConnection;

        if (context.mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          if (context.mounted) {
            _isConnected
                ? CustomSnackbar.showSuccess(context, 'You are back online.')
                : CustomSnackbar.showError(context, 'No Internet Connection.');
          }
        }
      }
    });
  }

  /// Stops listening to connectivity changes.
  ///
  /// Should be called when the notifier is no longer needed (e.g. on logout,
  /// app close, or when switching to a screen that doesn't need monitoring).
  void dispose() {
    _subscription.cancel();
  }
}
