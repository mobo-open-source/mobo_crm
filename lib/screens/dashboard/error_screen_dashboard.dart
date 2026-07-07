import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// A wrapper widget that monitors internet connectivity
/// and handles error states with automatic retry support.
///
/// Features:
/// - Periodically checks real internet connectivity
/// - Displays a "No Internet" screen when offline
/// - Displays a generic error screen on reload failure
/// - Automatically retries reload when internet is restored
/// - Provides manual "Try Again" option
///
/// Parameters:
/// - [reloadFunction]: Async function to retry failed operations.
///   Should return `true` on success and `false` on failure.
/// - [child]: The main widget to display when no errors exist.
///
/// Useful for wrapping entire screens that depend on API data.
class InternetAndErrorChecker extends StatefulWidget {
  final Future<bool> Function() reloadFunction;
  final Widget child;

  const InternetAndErrorChecker({
    super.key,
    required this.reloadFunction,
    required this.child,
  });

  @override
  // ignore: library_private_types_in_public_api
  _InternetAndErrorCheckerState createState() =>
      _InternetAndErrorCheckerState();
}

/// State class for [InternetAndErrorChecker].
///
/// Responsibilities:
/// - Monitors internet status every 10 seconds
/// - Detects real connectivity using HTTP request
/// - Manages error and loading states
/// - Triggers automatic reload when internet is restored
class _InternetAndErrorCheckerState extends State<InternetAndErrorChecker> {
  bool hasError = false;
  bool hasInternet = true;
  bool isLoading = false;
  bool wasInternetOff = false;
  Timer? periodicTimer;

  @override
  void initState() {
    super.initState();
    _checkInternet();

    periodicTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _checkInternet();
    });
  }

  /// Checks for actual internet connectivity by making
  /// a test HTTP request.
  ///
  /// Returns:
  /// - `true` if status code is 200
  /// - `false` if request fails or times out
  ///
  /// Timeout duration: 5 seconds
  Future<bool> hasRealInternet() async {
    try {
      final result = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return result.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Performs periodic internet check.
  ///
  /// Updates:
  /// - [hasInternet]
  /// - [wasInternetOff]
  ///
  /// If internet was previously off and is now restored,
  /// automatically triggers [_reload].
  Future<void> _checkInternet() async {
    bool realInternet = await hasRealInternet();
    if (!mounted) return;
    setState(() {
      wasInternetOff = !realInternet && hasInternet;
      hasInternet = realInternet;
    });

    if (!hasError && wasInternetOff && hasInternet) {
      _reload();
    }
  }

  /// Attempts to reload data using [widget.reloadFunction].
  ///
  /// Updates:
  /// - [isLoading]
  /// - [hasError]
  ///
  /// Sets error state if reload fails or throws exception.
  Future<void> _reload() async {
    setState(() {
      hasError = false;
      isLoading = true;
    });

    try {
      bool success = await widget.reloadFunction();
      setState(() {
        hasError = !success;
      });
    } catch (_) {
      setState(() {
        hasError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    periodicTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!hasInternet) {
      return _errorPage("No Internet Connection", Icons.wifi_off);
    }
    if (hasError) {
      return _errorPage("Something Went Wrong", Icons.error_outline);
    }
    return widget.child;
  }

  /// Builds error UI screen.
  ///
  /// Parameters:
  /// - [message]: Main error message
  /// - [icon]: Icon representing the error type
  ///
  /// Displays:
  /// - Error icon
  /// - Error message
  /// - Retry button
  /// - Loading indicator during retry
  Widget _errorPage(String message, IconData icon) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 64, color: Colors.grey.shade700),
              const SizedBox(height: 24),
              Text(
                message,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Please check your internet or try again.",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: isLoading ? null : _reload,
                icon: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    : const Icon(Icons.refresh),
                label: Text(isLoading ? "Loading..." : "Try Again"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
