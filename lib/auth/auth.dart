import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/services/biometric_service.dart';
import 'package:mobo_crm/screens/auth/biometric_auth_screen.dart';
import 'package:mobo_crm/screens/login/totp_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/security/secure_storage_service.dart';

/// Root-level authentication flow decision widget.
///
/// This widget runs at app startup and decides where to send the user based on:
/// 1. Whether they've seen the onboarding/get-started screen
/// 2. Whether they're logged in (via SharedPreferences flag)
/// 3. Whether biometric authentication should be prompted
///
/// Navigation flow:
/// - First launch           → /get_started
/// - Seen onboarding, not logged in → /server_setup
/// - Logged in              → biometric prompt (if enabled) → /init
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  /// Reads current authentication/onboarding state from SharedPreferences.
  ///
  /// Returns a map with three boolean flags:
  /// - `isLoggedIn`: user has completed login
  /// - `hasSeenGetStarted`: onboarding has been shown at least once
  /// - `hasCredentials`: appears to have stored server/user credentials
  Future<Map<String, dynamic>> checkUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final hasSeenGetStarted = prefs.getBool('hasSeenGetStarted') ?? false;
    final hasCredentials = _hasStoredCredentials(prefs);

    final is2FAUser = prefs.getBool('is2FAUser') ?? false;
    final totpServerUrl = prefs.getString('totp_server_url') ?? '';
    final totpDatabase = prefs.getString('totp_database') ?? '';
    final totpUsername = prefs.getString('totp_username') ?? '';
    final totpProtocol = prefs.getString('totp_protocol') ?? 'https://';

    String totpPassword = '';
    if (is2FAUser && totpServerUrl.isNotEmpty) {
      totpPassword = await SecureStorageService().getPassword(
            url: totpServerUrl,
            database: totpDatabase,
            username: totpUsername,
          ) ??
          '';
    }

    return {
      'isLoggedIn': isLoggedIn,
      'hasSeenGetStarted': hasSeenGetStarted,
      'hasCredentials': hasCredentials,
      'is2FAUser': is2FAUser,
      'totpServerUrl': totpServerUrl,
      'totpDatabase': totpDatabase,
      'totpUsername': totpUsername,
      'totpProtocol': totpProtocol,
      'totpPassword': totpPassword,
    };
  }

  bool _hasStoredCredentials(SharedPreferences prefs) {
    final savedUrl = prefs.getString('url');
    final savedDatabase = prefs.getString('selectedDatabase');
    final savedUsername = prefs.getString('userName');

    return savedUrl != null && savedUrl.isNotEmpty &&
           savedDatabase != null && savedDatabase.isNotEmpty &&
           savedUsername != null && savedUsername.isNotEmpty;
  }

  /// Decides whether to show biometric prompt and navigates accordingly.
  ///
  /// - If biometrics are available & should be prompted → show BiometricAuthScreen
  /// - Otherwise → go directly to main screen (/init)
  Future<void> _checkBiometricAuth(BuildContext context) async {
    try {
      final shouldPrompt = await BiometricService.shouldPromptBiometric();
      if (!context.mounted) return;
      if (shouldPrompt) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BiometricAuthScreen(
              onSuccess: () {
                Navigator.pushReplacementNamed(context, '/init');
              },
              onSkip: () {
                Navigator.pushReplacementNamed(context, '/init');
              },
              allowSkip: false,
            ),
          ),
        );
      } else {
        Navigator.pushReplacementNamed(context, '/init');
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/init');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: checkUserStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: const SizedBox.shrink(),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          Future.microtask(() {
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/get_started');
            }
          });
        } else {
          final isLoggedIn = snapshot.data!['isLoggedIn']!;
          final hasSeenGetStarted = snapshot.data!['hasSeenGetStarted']!;

          final is2FAUser = snapshot.data!['is2FAUser'] as bool;
          final totpServerUrl = snapshot.data!['totpServerUrl'] as String;
          final totpDatabase = snapshot.data!['totpDatabase'] as String;
          final totpUsername = snapshot.data!['totpUsername'] as String;
          final totpProtocol = snapshot.data!['totpProtocol'] as String;
          final totpPassword = snapshot.data!['totpPassword'] as String;

          Future.microtask(() {
            if (!hasSeenGetStarted) {
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/get_started');
              }
            } else if (!isLoggedIn) {
              if (context.mounted) {
                if (is2FAUser &&
                    totpServerUrl.isNotEmpty &&
                    totpPassword.isNotEmpty) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TotpPage(
                        serverUrl: totpServerUrl,
                        database: totpDatabase,
                        username: totpUsername,
                        password: totpPassword,
                        protocol: totpProtocol,
                      ),
                    ),
                  );
                } else {
                  Navigator.pushReplacementNamed(context, '/server_setup');
                }
              }
            } else {
              if (context.mounted) {
                _checkBiometricAuth(context);
              }
            }
          });
        }

        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: const SizedBox.shrink(),
        );
      },
    );
  }
}
