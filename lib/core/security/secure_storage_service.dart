import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Provides secure storage operations for saving and retrieving user passwords.
///
/// Uses platform secure storage:
/// - Android: EncryptedSharedPreferences
/// - iOS: Keychain (first unlock of device)
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  );

  /// Generates a unique key for storing password based on
  /// server URL, database name, and username.
  static String _passwordKey(String url, String database, String username) {
    return 'odoo_pass_${url}_$database}_${username}';
  }

  /// Saves password securely for given server, database and user.
  Future<void> savePassword({
    required String url,
    required String database,
    required String username,
    required String password,
  }) async {
    final key = _passwordKey(url, database, username);
    await _storage.write(key: key, value: password);
  }

  /// Retrieves stored password if available, otherwise returns null.
  Future<String?> getPassword({
    required String url,
    required String database,
    required String username,
  }) async {
    final key = _passwordKey(url, database, username);
    return await _storage.read(key: key);
  }

  /// Deletes stored password for specific server, database and user.
  Future<void> deletePassword({
    required String url,
    required String database,
    required String username,
  }) async {
    final key = _passwordKey(url, database, username);
    await _storage.delete(key: key);
  }

  /// Deletes all stored passwords from secure storage.
  Future<void> deleteAllPasswords() async {
    await _storage.deleteAll();
  }

  static const _installMarkerKey = 'app_install_marker';

  /// Whether the fresh-install guard has already run on this install.
  ///
  /// Lives in secure storage rather than SharedPreferences so it can't be
  /// wiped by an in-app `SharedPreferences.clear()` (e.g. logout), only by
  /// an actual app uninstall.
  Future<bool> hasInstallMarker() async {
    return await _storage.read(key: _installMarkerKey) == 'true';
  }

  /// Marks the fresh-install guard as having run on this install.
  Future<void> setInstallMarker() async {
    await _storage.write(key: _installMarkerKey, value: 'true');
  }
}
