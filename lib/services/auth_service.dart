import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import '../../core/security/self_signed.dart';
import '../models/LoginPage/auth_model.dart';
import '../models/LoginPage/session_model.dart';
import 'database_expiry.dart';

/// Handles all authentication-related operations:
/// - Biometric authentication (Local device security)
/// - Odoo session authentication (Server-side login)
/// - Session-based RPC calls
/// - Session metadata extraction (company, permissions, version info)
class AuthService {
  /// Local device biometric authentication handler
  final LocalAuthentication _auth = LocalAuthentication();

  /// Performs biometric authentication using device security.
  ///
  /// Flow:
  /// 1. Check if biometrics hardware is available
  /// 2. Check if biometric credentials are enrolled
  /// 3. Prompt user authentication
  ///
  /// Returns:
  /// - success → Authenticated
  /// - failure → User cancelled / failed authentication
  /// - unavailable → Biometrics not available on device
  /// - error → Unexpected runtime error
  Future<AuthenticationResult> authenticateWithBiometrics() async {
    try {
      bool canCheckBiometrics = await _auth.canCheckBiometrics;
      List<BiometricType> availableBiometrics =
          await _auth.getAvailableBiometrics();

      if (canCheckBiometrics && availableBiometrics.isNotEmpty) {
        try {
          final bool authenticate = await _auth.authenticate(
            localizedReason: 'Authenticate to access the app',
            options: const AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: true,
            ),
          );
          return authenticate
              ? AuthenticationResult.success
              : AuthenticationResult.failure;
        } catch (_) {
          return AuthenticationResult.error;
        }
      } else {
        return AuthenticationResult.unavailable;
      }
    } catch (_) {
      return AuthenticationResult.error;
    } finally {
      await _auth.stopAuthentication();
    }
  }

  /// Extracts major version number from Odoo server version string.
  ///
  /// Example:
  /// - "17.0+e" → 17
  /// - "16.3" → 16
  int parseMajorVersion(String serverVersion) {
    final match = RegExp(r'\d+').firstMatch(serverVersion);
    if (match != null) {
      return int.tryParse(match.group(0)!) ?? 0;
    }
    return 0;
  }

  /// Retrieves session info directly using existing session cookie.
  ///
  /// Used for:
  /// - Restoring existing session
  /// - Validating session without re-login
  Future<Map<String, dynamic>> getSessionInfo(
      String url, String sessionId) async {
    final response = await ioClient.post(
      Uri.parse('$url/web/session/get_session_info'),
      headers: {
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'Origin': url,
        'Cookie': 'session_id=$sessionId',
      },
      body: jsonEncode({
        "jsonrpc": "2.0",
        "method": "call",
        "params": {},
        "id": 1,
      }),
    );

    final data = jsonDecode(response.body);
    return Map<String, dynamic>.from(data['result']);
  }

  /// Refuses a session whose database has expired.
  ///
  /// Reads the session info Odoo Enterprise adds the expiry to, and throws
  /// [DatabaseExpiredException] once that date has been reached. Does nothing
  /// for a database that reports none (Community), and also when the info
  /// can't be read: an unreachable server fails the sign-in on its own, and a
  /// check that couldn't be made shouldn't lock out a database that may be
  /// perfectly valid.
  Future<void> ensureDatabaseNotExpired(String url, String sessionId) async {
    Map<String, dynamic> info;
    try {
      info = await getSessionInfo(url, sessionId);
    } catch (e) {
      debugPrint('[AuthService] expiry check skipped, session info: $e');
      return;
    }
    final expired = databaseExpiredFrom(info);
    if (expired != null) throw expired;
  }

  /// Generic RPC call using existing session cookie.
  ///
  /// Allows calling any Odoo model method using raw JSON-RPC.
  Future<dynamic> callKwWithSession({
    required String url,
    required String sessionId,
    required Map<String, dynamic> payload,
  }) async {
    final res = await ioClient.post(
      Uri.parse('$url/web/dataset/call_kw'),
      headers: {
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'Cookie': 'session_id=$sessionId',
      },
      body: jsonEncode(payload),
    );

    final data = jsonDecode(res.body);
    if (data['error'] != null) throw data['error'];
    return data['result'];
  }

  /// Parses company field from Odoo responses.
  ///
  /// Handles both formats:
  /// - [id, name]
  /// - { id, name/display_name }
  Map<String, dynamic>? _parseCompany(dynamic value) {
    if (value == null) return null;

    if (value is List && value.length >= 2) {
      return {'id': value[0], 'name': value[1]};
    }

    if (value is Map) {
      return {
        'id': value['id'],
        'name': value['display_name'] ?? value['name'],
      };
    }
    return null;
  }

  /// Main Odoo authentication method.
  ///
  /// Supports two flows:
  /// 1. Session-based authentication (Existing session cookie)
  /// 2. Username/password authentication
  ///
  /// Returns SessionModel containing:
  /// - User details
  /// - Company info
  /// - Permissions (System user check)
  /// - Allowed companies
  /// - Server version metadata
  Future<SessionModel?> authenticateOdoo(
      {required String url,
      required String database,
      required String username,
      required String password,
      sessionId}) async {
    try {
      final client = OdooClient(url, httpClient: ioClient);
      OdooSession session;
      int userId = 0;

      /// -------------------------
      /// SESSION COOKIE LOGIN FLOW
      /// -------------------------
      if (sessionId != null) {
        final sessionInfo = await getSessionInfo(url, sessionId);

        final int userId = sessionInfo['uid'];
        final String serverVersion = sessionInfo['server_version'];
        final int majorVersion = parseMajorVersion(serverVersion);

        /// Fetch company info
        final userData = await callKwWithSession(
          url: url,
          sessionId: sessionId,
          payload: {
            "jsonrpc": "2.0",
            "method": "call",
            "params": {
              "model": "res.users",
              "method": "read",
              "args": [
                [userId],
                ["company_id"]
              ],
              "kwargs": {}
            },
            "id": 1
          },
        );

        final company = _parseCompany(userData[0]['company_id']);

        // has_group(self, group_ext_id)'s call signature differs by Odoo
        // major version (confirmed against real servers): on 17 it takes
        // just the group's external id — the dispatcher forwards it onto an
        // *unbrowsed* `res.users` recordset, where it falls back to the
        // session's own uid — and passing a user id too overflows it
        // ("takes 2 positional arguments but 3 were given"). On 18+ the
        // dispatcher instead treats args[0] as the id to browse before
        // calling the method, so the user id must be included or the call
        // is short an argument ("missing 1 required positional argument").
        // Either mismatch throws server-side right after a correct
        // password check, surfaced to the user as "Server error occurred".
        final bool isSystem = await callKwWithSession(
              url: url,
              sessionId: sessionId,
              payload: {
                "jsonrpc": "2.0",
                "method": "call",
                "params": {
                  "model": "res.users",
                  "method": "has_group",
                  "args": majorVersion >= 18
                      ? [userId, "base.group_system"]
                      : ["base.group_system"],
                  "kwargs": {}
                },
                "id": 1
              },
            ) ==
            true;

        final List<int> allowedCompanyIds =
            _enabledCompaniesAtLogin(majorVersion, company?['id']);

        return SessionModel(
          sessionId: sessionId,
          userId: userId,
          userLogin: sessionInfo['username'],
          userName: sessionInfo['name'],
          serverVersion: serverVersion,
          version: majorVersion,
          userLang: sessionInfo['lang'],
          userTimezone: sessionInfo['tz'],
          partnerId: sessionInfo['partner_id'],
          companyId: company?['id'],
          companyName: company?['name'],
          isSystem: isSystem,
          allowedCompanyIds: allowedCompanyIds,
        );
      } else {
        /// -------------------------
        /// USERNAME PASSWORD LOGIN
        /// -------------------------
        try {
          session = await client.authenticate(database, username, password);
        } catch (e) {
          if (e.toString().contains(
            "type 'Null' is not a subtype of type 'Map<String, dynamic>'",
          )) {
            // odoo_rpc's OdooSession parser crashes on the partial response
            // Odoo sends when the password is correct but TOTP is still
            // required. Re-issue the same RPC call manually and read the
            // raw JSON to tell that apart from a genuine login failure.
            session = await _authenticateViaRawSessionCall(
              url: url,
              database: database,
              username: username,
              password: password,
            );
          } else {
            rethrow;
          }
        }
        userId = session.userId;

        if (session != null) {
          final userData = await client.callKw({
            'model': 'res.users',
            'method': 'read',
            'args': [
              [userId],
              ['company_id'],
            ],
            'kwargs': {},
          });
          final int majorVersion = parseMajorVersion(session.serverVersion);

          // See the has_group note above: 18+ needs the user id leading the
          // args, 17 and earlier don't.
          final bool isSystem = await client.callKw({
            'model': 'res.users',
            'method': 'has_group',
            'args': majorVersion >= 18
                ? [session.userId, 'base.group_system']
                : ['base.group_system'],
            'kwargs': {},
          });

          final int? defaultCompanyId =
              userData.isNotEmpty ? userData[0]['company_id'][0] : null;
          final List<int> allowedCompanyIds =
              _enabledCompaniesAtLogin(majorVersion, defaultCompanyId);
          return SessionModel(
            sessionId: session.id,
            userName: session.userName,
            userLogin: session.userLogin?.toString(),
            userId: session.userId,
            serverVersion: session.serverVersion,
            userLang: session.userLang,
            partnerId: session.partnerId,
            userTimezone: session.userTz,
            companyId: defaultCompanyId,
            companyName:
                userData.isNotEmpty ? userData[0]['company_id'][1] : null,
            isSystem: isSystem,
            version: majorVersion,
            allowedCompanyIds: allowedCompanyIds,
          );
        }
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Odoo's web client enables only the user's default company right after
  /// login; the rest of `company_ids` stay available but unticked.
  List<int> _enabledCompaniesAtLogin(int majorVersion, int? defaultCompanyId) {
    if (majorVersion < 13 || defaultCompanyId == null) return [];
    return [defaultCompanyId];
  }

  /// Manually re-issues `/web/session/authenticate` and reads the raw JSON,
  /// bypassing odoo_rpc's [OdooClient.authenticate] entirely.
  ///
  /// Odoo returns `uid: false` (password correct, TOTP still pending) with
  /// a partial `session_id` already set, which some odoo_rpc versions fail
  /// to parse into an [OdooSession]. Throws `'two factor authentication
  /// required'` in that case so the caller can route to the TOTP screen.
  Future<OdooSession> _authenticateViaRawSessionCall({
    required String url,
    required String database,
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('$url/web/session/authenticate');
    final response = await ioClient.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {'db': database, 'login': username, 'password': password},
        'id': DateTime.now().millisecondsSinceEpoch,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Authentication error');
    }

    final authBody = jsonDecode(response.body);
    final result = authBody['result'];
    final error = authBody['error'];

    if (error != null) {
      throw Exception(error['message'] ?? 'Authentication error');
    }

    if (result == null) {
      throw Exception('Authentication returned null result');
    }

    var uid = result['uid'];
    if (uid is bool) uid = null;

    String? sessionId = result['session_id']?.toString();
    if (sessionId == null || sessionId.isEmpty) {
      final cookieHeader = response.headers['set-cookie'];
      if (cookieHeader != null) {
        final sessionMatch = RegExp(
          r'session_id=([^;]+)',
        ).firstMatch(cookieHeader);
        sessionId = sessionMatch?.group(1);
      }
    }

    if (sessionId == null || sessionId.isEmpty) {
      throw Exception('No session_id found in auth response');
    }

    if (uid == null) {
      throw Exception('two factor authentication required');
    }

    return OdooSession(
      id: sessionId,
      userId: uid,
      partnerId: result['partner_id'] ?? 0,
      userLogin: result['username'] ?? username,
      userName: result['name'] ?? '',
      userLang: result['user_context']?['lang'] ?? 'en_US',
      userTz: result['user_context']?['tz'] ?? 'UTC',
      isSystem: result['is_system'] ?? false,
      dbName: result['db'] ?? database,
      serverVersion: result['server_version'] ?? '',
      companyId: result['company_id'] ?? 0,
      allowedCompanies: const [],
    );
  }
}
