import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A centralized service class for handling biometric authentication
/// (fingerprint, Face ID, etc.) using the `local_auth` package.
///
/// Responsibilities:
///   - Check device support and availability of biometrics
///   - Retrieve available biometric types
///   - Manage user preference for enabling/disabling biometric login
///   - Perform authentication with customizable reason message
///   - Provide human-readable names for biometric types
///   - Helper methods to decide when to prompt for biometrics
///
/// All methods are static and safe to call from anywhere in the app.
/// Uses `SharedPreferences` to persist the "biometric enabled" setting.
///
/// Usage examples:
/// ```dart
/// // Check if we should show biometric prompt on login
/// if (await BiometricService.shouldPromptBiometric()) {
///   final authenticated = await BiometricService.authenticateWithBiometrics(
///     reason: 'Authenticate to access your CRM data',
///   );
///   if (authenticated) { /* proceed */ }
/// }
///
/// // Enable biometric after user opts-in
/// await BiometricService.setBiometricEnabled(true);
/// ```
class BiometricService {
  static LocalAuthentication? _localAuth;
  static bool _isInitialized = false;

  /// Ensures the `LocalAuthentication` instance is created (lazy init)
  static Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      _localAuth = LocalAuthentication();
      _isInitialized = true;

      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  /// Checks whether the device supports biometric authentication
  /// and if at least one biometric is enrolled.
  ///
  /// Returns `true` only if both device support and enrolled biometrics exist.
  static Future<bool> isBiometricAvailable() async {
    try {
      await _ensureInitialized();

      if (_localAuth == null) {
        return false;
      }

      final bool isDeviceSupported = await _localAuth!.isDeviceSupported();

      if (!isDeviceSupported) {
        return false;
      }

      final bool canCheckBiometrics = await _localAuth!.canCheckBiometrics;

      return canCheckBiometrics;
    } on PlatformException {
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Returns the list of biometric types available on the device
  /// (e.g. [BiometricType.fingerprint], [BiometricType.face], etc.).
  ///
  /// Returns empty list if unavailable or on error.
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      await _ensureInitialized();
      if (_localAuth == null) return [];

      return await _localAuth!.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Checks user preference for using biometrics (stored in SharedPreferences).
  ///
  /// Returns `true` if the user has explicitly enabled biometric login.
  static Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('biometric_enabled') ?? false;
  }

  /// Saves the user's preference for enabling/disabling biometric login.
  static Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', enabled);
  }

  /// Prompts the user to authenticate using biometrics (or device PIN fallback).
  ///
  /// Returns `true` if authentication succeeds, `false` otherwise.
  ///
  /// [reason] is the localized message shown to the user explaining why
  /// authentication is needed (e.g. "Unlock your secure CRM data").
  static Future<bool> authenticateWithBiometrics({
    String reason = 'Please authenticate to access the app',
  }) async {
    try {
      await _ensureInitialized();
      if (_localAuth == null) {
        return false;
      }

      final bool isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        return false;
      }

      final bool didAuthenticate = await _localAuth!.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      return didAuthenticate;
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'NotAvailable':
          break;
        case 'NotEnrolled':
          break;
        case 'LockedOut':
          break;
        case 'PermanentlyLockedOut':
          break;
        default:
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Converts a `BiometricType` enum value to a user-friendly display name.
  static String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.iris:
        return 'Iris';
      case BiometricType.weak:
        return 'PIN/Pattern';
      case BiometricType.strong:
        return 'Strong Biometric';
      default:
        return 'Biometric';
    }
  }

  /// Returns a list of human-readable names for all available biometric types.
  static Future<List<String>> getAvailableBiometricNames() async {
    final types = await getAvailableBiometrics();
    return types.map((type) => getBiometricTypeName(type)).toList();
  }

  /// Convenience method: checks both user preference and device capability.
  ///
  /// Use this before showing the biometric prompt to avoid unnecessary dialogs.
  static Future<bool> shouldPromptBiometric() async {
    try {
      final isEnabled = await isBiometricEnabled();
      if (!isEnabled) return false;

      final isAvailable = await isBiometricAvailable();
      return isAvailable;
    } catch (e) {
      return false;
    }
  }

  /// One-time initialization (optional) — calls platform to warm up channel.
  ///
  /// Can be called early in app startup (e.g. in main) to reduce first-use latency.
  static Future<void> initialize() async {
    try {
      await _localAuth?.isDeviceSupported();
    } catch (_) {}
  }
}
