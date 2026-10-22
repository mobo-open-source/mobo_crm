import 'package:shared_preferences/shared_preferences.dart';

import 'secure_storage_service.dart';

/// Wipes any session data that could otherwise survive an app uninstall.
///
/// SharedPreferences data is normally deleted by the OS on uninstall, but can
/// come back via a backup/restore (Android auto backup, iOS device restore).
/// Secure-storage entries (Android Keystore / iOS Keychain) are never removed
/// by uninstalling the app at all. This runs once per fresh install/reinstall
/// — detected by the absence of the install marker, which is itself wiped by
/// a real uninstall — and clears both stores before anything reads them.
///
/// The marker is kept in secure storage rather than SharedPreferences: the
/// app blanket-clears SharedPreferences elsewhere (logout, failed module
/// checks), which would otherwise remove the marker too and make this guard
/// misfire on the very next ordinary relaunch, wiping an otherwise valid
/// session.
Future<void> clearStaleSessionOnFreshInstall() async {
  final secureStorage = SecureStorageService();
  if (await secureStorage.hasInstallMarker()) return;

  await secureStorage.deleteAllPasswords();
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  await secureStorage.setInstallMarker();
}
