import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/LoginPage/session_model.dart';

/// Service class responsible for handling local storage operations
/// using SharedPreferences.
///
/// This includes:
/// - Saving and retrieving user session details
/// - Managing login state (logged in status, database, URL)
/// - Storing and retrieving multiple logged-in account details
/// - Managing saved locale preferences
///
/// All data is persisted locally on the device.
class StorageService {
  static const _accountsKey = 'loggedInAccounts';

  /// Saves the current user session details to local storage.
  ///
  /// Stores user-related information such as:
  /// - Username and login
  /// - User ID and session ID
  /// - Server version and language
  /// - Partner ID and company details
  /// - Timezone and system flags
  /// - Allowed company IDs list
  ///
  /// [session] - SessionModel object containing session data.
  Future<void> saveSession(SessionModel session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', session.userName ?? '');
    await prefs.setString('userLogin', session.userLogin ?? '');
    await prefs.setInt('userId', session.userId ?? 0);
    await prefs.setString('sessionId', session.sessionId);
    await prefs.setString('serverVersion', session.serverVersion ?? '');
    await prefs.setString('userLang', session.userLang ?? '');
    await prefs.setInt('partnerId', session.partnerId ?? 0);
    await prefs.setString('userTimezone', session.userTimezone ?? '');
    await prefs.setInt('companyId', session.companyId ?? 1);
    await prefs.setString('company_name', session.companyName ?? '');
    await prefs.setBool('isSystem', session.isSystem);
    await prefs.setInt('version', session.version??0);
    if (session.allowedCompanyIds != null && session.allowedCompanyIds!.isNotEmpty) {
      await prefs.setStringList(
        'allowed_company_ids',
        session.allowedCompanyIds!.map((id) => id.toString()).toList(),
      );
    } else {
      await prefs.remove('allowed_company_ids');
    }
  }

  Future<List<Map<String, dynamic>>> getAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final accountsJson = prefs.getString(_accountsKey);
    if (accountsJson == null) return [];
    final decoded = jsonDecode(accountsJson) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> saveAccount(Map<String, dynamic> account) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = await getAccounts();

    accounts.removeWhere((a) =>
    a['userLogin'] == account['userLogin'] &&
        a['url'] == account['url'] &&
        a['database'] == account['database']);

    if (!account.containsKey('image')) {
      account['image'] = '';
    }

    if (account['allowed_company_ids'] == null) {
      account['allowed_company_ids'] = <int>[];
    }
    if (account['allowed_companies'] == null) {
      account['allowed_companies'] = <Map<String, dynamic>>[];
    }

    accounts.add(account);

    await prefs.setString(_accountsKey, jsonEncode(accounts));
  }

  /// Saves login state information to local storage.
  ///
  /// Stores:
  /// - Whether user is logged in
  /// - Selected database name
  /// - Server URL
  ///
  /// [isLoggedIn] - Indicates login status.
  /// [database] - Selected database name.
  /// [url] - Server URL.
  Future<void> saveLoginState({
    required bool isLoggedIn,
    required String database,
    required String url,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setString('selectedDatabase', database);
    await prefs.setString('url', url);
  }

  /// Retrieves login state information from local storage.
  ///
  /// Returns a map containing:
  /// - isLoggedIn → bool
  /// - useLocalAuth → bool
  /// - database → String
  /// - url → String
  ///
  /// Provides default values if nothing is stored.
  Future<Map<String, dynamic>> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'isLoggedIn': prefs.getBool('isLoggedIn') ?? false,
      'useLocalAuth': prefs.getBool('useLocalAuth') ?? false,
      'selectedDatabase': prefs.getString('selectedDatabase') ?? '',
      'url': prefs.getString('url') ?? '',
      'password': prefs.getString('pass') ?? '',
    };
  }

  Future<List<int>> getAllowedCompanyIdsForAccount(String userLogin) async {
    final accounts = await getAccounts();
    final account = accounts.firstWhere(
          (a) => a['userLogin'] == userLogin,
      orElse: () => <String, dynamic>{},
    );

    if (account.isEmpty) return [];

    final rawIds = account['allowed_company_ids'] as List<dynamic>? ?? [];
    return rawIds.map((e) => int.tryParse(e.toString()) ?? 0).where((id) => id > 0).toList();
  }

  Future<void> clearAllSessionData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('userName');
    await prefs.remove('userLogin');
    await prefs.remove('userId');
    await prefs.remove('sessionId');
    await prefs.remove('serverVersion');
    await prefs.remove('userLang');
    await prefs.remove('partnerId');
    await prefs.remove('userTimezone');
    await prefs.remove('companyId');
    await prefs.remove('company_name');
    await prefs.remove('isSystem');
    await prefs.remove('version');
    await prefs.remove('allowed_company_ids');

    await prefs.remove('isLoggedIn');
    await prefs.remove('selectedDatabase');
    await prefs.remove('url');
    await prefs.remove('pass');

    await prefs.remove('loggedInAccounts');
  }

  Future<void> removeAccount({
    required String userLogin,
    required String userName,
    required int userId,
    required String url,
    required String database,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final accounts = await getAccounts();

    accounts.removeWhere((a) =>
    a['userLogin'] == userLogin &&
        a['userName'] == userName &&
        a['userId'] == userId &&
        a['url'] == url &&
        a['database'] == database);

    await prefs.setString(_accountsKey, jsonEncode(accounts));
  }
}
