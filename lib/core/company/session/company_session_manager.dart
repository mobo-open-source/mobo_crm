import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/LoginPage/session_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/storage_service.dart';
import '../../security/secure_storage_service.dart';
import '../../security/self_signed.dart';
import '../services/connectivity_service.dart';
import 'odoo_compat.dart';

/// Central manager for Odoo session lifecycle, authentication,
/// company context handling, and RPC calls with automatic session refresh.
///
/// This is a **static-only** utility class that:
/// - Manages cached session & OdooClient
/// - Persists/restores session via SharedPreferences + secure storage
/// - Handles company switching
/// - Wraps RPC calls with automatic auth retry on 401/403-like errors
class CompanySessionManager {
  static OdooClient? _client;
  static SessionModel? _cachedSession;
  static Future<bool>? _refreshInFlight;
  static DateTime? _lastAuthTime;
  static const Duration _sessionCacheValidDuration = Duration(minutes: 5);
  static Function(SessionModel)? _onSessionUpdated;

  /// Add to every request that sends the session cookie outside the RPC
  /// client (image loads, raw HTTP). Those responses are never read for a
  /// rotated cookie, so they must not be the request that triggers Odoo 19's
  /// periodic session rotation — or the new id is lost and the old one dies.
  static const Map<String, String> skipSessionRotationHeader = {
    'X-Odoo-Skip-Session-Rotation-Interval': '1',
  };

  /// Register a callback that is called whenever the active session changes
  static void registerSessionListener(Function(SessionModel) callback) {
    _onSessionUpdated = callback;
  }

  /// Odoo 19+ rotates the session id every few hours and deletes the old one
  /// two minutes later; the new id only arrives as a Set-Cookie on an
  /// ordinary response. odoo_rpc adopts it in memory, but anything built
  /// from the stored id afterwards — the next client, cookie headers — kept
  /// sending the dead one, and Odoo answers that with an HTML page
  /// ("FormatException: <!DOCTYPE html>") instead of JSON.
  static OdooClient _trackSessionRotation(OdooClient client) {
    client.sessionStream.listen((session) {
      _persistRotatedSessionId(session.id);
    });
    return client;
  }

  static Future<void> _persistRotatedSessionId(String newSessionId) async {
    // Empty means the server ended the session; refreshSession() handles it.
    if (newSessionId.isEmpty) return;
    // In memory first, so a client lookup racing the write below already
    // sees the new id.
    final current = _cachedSession;
    if (current != null && current.sessionId != newSessionId) {
      _cachedSession = current.withSessionId(newSessionId);
      _onSessionUpdated?.call(_cachedSession!);
    }
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('sessionId') != newSessionId) {
      await prefs.setString('sessionId', newSessionId);
    }
  }

  static bool _isAuthError(Object e) {
    final errorStr = e.toString().toLowerCase();
    return errorStr.contains('401') ||
        errorStr.contains('unauthorized') ||
        errorStr.contains('access denied') ||
        errorStr.contains('invalid session') ||
        errorStr.contains('session expired') ||
        errorStr.contains('authentication') ||
        errorStr.contains('forbidden') ||
        errorStr.contains('403') ||
        // Once the session is gone Odoo can answer a JSON-RPC call with its
        // HTML login/db-selector page, which surfaces as a FormatException.
        errorStr.contains('<!doctype html') ||
        errorStr.contains('<html');
  }

  /// Force reload session data from SharedPreferences
  static Future<void> forceRefreshFromPrefs() async {
    _cachedSession = null;
    await getCurrentSession();
  }

  /// Returns currently active session (from cache or preferences)
  static Future<SessionModel?> getCurrentSession() async {
    if (_cachedSession != null) return _cachedSession;

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (!isLoggedIn) return null;

    final String? sessionId = prefs.getString('sessionId');
    final int? userId = prefs.getInt('userId');
    final String? url = prefs.getString('url');

    if (sessionId == null ||
        sessionId.isEmpty ||
        userId == null ||
        url == null ||
        url.isEmpty) {
      return null;
    }

    final List<String> allowedRaw =
        prefs.getStringList('allowed_company_ids') ?? [];
    final List<int> allowedCompanyIds = allowedRaw
        .map((e) => int.tryParse(e) ?? 0)
        .where((e) => e > 0)
        .toList();

    final session = SessionModel(
      sessionId: sessionId,
      userName: prefs.getString('userName'),
      userLogin: prefs.getString('userLogin'),
      userId: userId,
      serverVersion: prefs.getString('serverVersion'),
      userLang: prefs.getString('userLang'),
      partnerId: prefs.getInt('partnerId'),
      userTimezone: prefs.getString('userTimezone'),
      companyId: prefs.getInt('companyId'),
      companyName: prefs.getString('company_name'),
      isSystem: prefs.getBool('isSystem') ?? false,
      version: prefs.getInt('version'),
      allowedCompanyIds: allowedCompanyIds,
    );

    _cachedSession = session;
    ConnectivityService.instance.setCurrentServerUrl(url);
    return session;
  }

  /// Quick check if any login state is stored
  static Future<bool> isSessionValid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> notifySessionCreated() async {
    await forceRefreshFromPrefs();
    final session = await getCurrentSession();
    if (session != null) {
      _onSessionUpdated?.call(session);
    }
  }

  /// Initialize session from browser/cookie-based login (webview / SSO case)
  static Future<void> loginFromBrowserSession({
    required String sessionId,
    required String url,
    required String database,
    required Map<String, dynamic> sessionInfo,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('url', url);
    await prefs.setString('database', database);
    await prefs.setString('sessionId', sessionId);

    await prefs.setInt('userId', sessionInfo['uid']);
    await prefs.setString('userName', sessionInfo['name']);
    await prefs.setString('userLogin', sessionInfo['login']);
    await prefs.setString(
      'serverVersion',
      sessionInfo['server_version'].toString(),
    );
    await prefs.setString(
      'userLang',
      sessionInfo['user_context']['lang'] ?? 'en_US',
    );
    await prefs.setString(
      'userTimezone',
      sessionInfo['user_context']['tz'] ?? 'UTC',
    );
    await prefs.setInt('partnerId', sessionInfo['partner_id']);
    await prefs.setInt('companyId', sessionInfo['company_id']);
    await prefs.setString('company_name', sessionInfo['company_name']);
    await prefs.setBool('isSystem', sessionInfo['is_system'] ?? false);

    final odooSession = OdooSession(
      id: sessionId,
      dbName: database,
      userId: sessionInfo['uid'],
      partnerId: sessionInfo['partner_id'],
      userLogin: sessionInfo['login'],
      userName: sessionInfo['name'],
      userLang: sessionInfo['user_context']['lang'] ?? 'en_US',
      userTz: sessionInfo['user_context']['tz'] ?? 'UTC',
      isSystem: sessionInfo['is_system'] ?? false,
      serverVersion: sessionInfo['server_version'].toString(),
      companyId: sessionInfo['company_id'],
      allowedCompanies: [],
    );

    /// Do NOT call `_client?.close()` here — see clearSessionCache() for why
    /// closing an OdooClient that wraps the shared `ioClient` is unsafe.
    _client = _trackSessionRotation(
        OdooClient(url, sessionId: odooSession, httpClient: ioClient));

    _cachedSession = SessionModel(
      sessionId: sessionId,
      userId: sessionInfo['uid'],
      userName: sessionInfo['name'],
      userLogin: sessionInfo['login'],
      serverVersion: odooSession.serverVersion,
      userLang: odooSession.userLang,
      partnerId: odooSession.partnerId,
      userTimezone: odooSession.userTz,
      companyId: odooSession.companyId,
      companyName: sessionInfo['company_name'],
      isSystem: odooSession.isSystem,
    );

    _lastAuthTime = DateTime.now();
    _onSessionUpdated?.call(_cachedSession!);
  }

  /// Standard login flow: authenticate → save session → create OdooClient
  static Future<bool> loginAndSaveSession({
    required String serverUrl,
    required String database,
    required String userLogin,
    required String password,
    dynamic existingSessionId,
    bool autoLoadCompanies = true,
  }) async {
    String normalizedUrl = serverUrl.trim();
    if (!normalizedUrl.startsWith('http://') &&
        !normalizedUrl.startsWith('https://')) {
      normalizedUrl = 'https://$normalizedUrl';
    }

    try {
      await ConnectivityService.instance.ensureInternetOrThrow();
      await ConnectivityService.instance.ensureServerReachable(normalizedUrl);
    } catch (e) {
      rethrow;
    }

    final authService = AuthService();
    final SessionModel? sessionModel = await authService.authenticateOdoo(
      url: normalizedUrl,
      database: database,
      username: userLogin,
      password: password,
      sessionId: existingSessionId,
    );

    if (sessionModel == null) return false;

    // Before anything is saved, and in the one routine every sign-in goes
    // through (password, two-factor, switching account, and the automatic
    // re-login), so an expired database is refused whichever way it is
    // reached. Throws DatabaseExpiredException.
    await authService.ensureDatabaseNotExpired(
        normalizedUrl, sessionModel.sessionId);

    final storage = StorageService();
    await storage.saveSession(sessionModel);
    await storage.saveLoginState(
      isLoggedIn: true,
      database: database,
      url: normalizedUrl,
    );

    final prefs = await SharedPreferences.getInstance();
    final db = prefs.getString('database') ?? '';
    final sessionId = prefs.getString('sessionId') ?? '';
    final serverVersion = prefs.getString('serverVersion') ?? '';
    final userLang = prefs.getString('userLang') ?? '';
    final allowedIdStrings =
        prefs.getStringList('allowed_company_ids') ?? [];
    final allowedCompanies = allowedIdStrings
        .map((idStr) {
          final id = int.tryParse(idStr);
          return id != null && id > 0 ? Company(id: id, name: '') : null;
        })
        .whereType<Company>()
        .toList();
    final session = OdooSession(
      id: sessionId,
      userId: prefs.getInt('userId') ?? 0,
      partnerId: prefs.getInt('partnerId') ?? 0,
      userLogin: prefs.getString('userLogin') ?? '',
      userName: prefs.getString('userName') ?? '',
      userLang: userLang,
      userTz: '',
      isSystem: prefs.getBool('isSystem') ?? false,
      dbName: db,
      serverVersion: serverVersion,
      companyId: prefs.getInt('companyId') ?? 1,
      allowedCompanies: allowedCompanies,
    );
    /// Do NOT call `_client?.close()` here: every OdooClient in this app
    /// shares the single app-wide `ioClient` (see self_signed.dart). Closing
    /// one instance closes that shared HttpClient for good — every
    /// subsequent request anywhere in the app then fails with
    /// "Client is already closed" until the app is restarted. Just drop
    /// the reference; a fresh OdooClient below reuses the still-open client.
    _client = null;

    _client = _trackSessionRotation(
        OdooClient(normalizedUrl, sessionId: session, httpClient: ioClient));
    _cachedSession = sessionModel;
    _lastAuthTime = DateTime.now();

    ConnectivityService.instance.setCurrentServerUrl(normalizedUrl);
    _onSessionUpdated?.call(sessionModel);

    return true;
  }

  /// Clear in-memory session & client (does **not** clear persistent storage)
  static Future<void> clearSessionCache() async {
    _cachedSession = null;
    /// Do NOT call `_client?.close()` here: every OdooClient in this app
    /// shares the single app-wide `ioClient` (see self_signed.dart). Closing
    /// one instance closes that shared HttpClient for good — every
    /// subsequent request anywhere in the app then fails with
    /// "Client is already closed" until the app is restarted. Just drop
    /// the reference; a fresh OdooClient below reuses the still-open client.
    _client = null;
    _lastAuthTime = null;
    _refreshInFlight = null;
  }

  /// Change active company and update stored session
  static Future<bool> restoreSession({required int companyId}) async {
    if (companyId <= 0) return false;

    final session = await getCurrentSession();
    if (session == null) return false;

    final url = (await SharedPreferences.getInstance()).getString('url') ?? '';
    if (url.isEmpty) return false;

    try {
      await ConnectivityService.instance.ensureInternetOrThrow();
      await ConnectivityService.instance.ensureServerReachable(url);

      final updatedSession = SessionModel(
        sessionId: session.sessionId,
        userName: session.userName,
        userLogin: session.userLogin,
        userId: session.userId,
        serverVersion: session.serverVersion,
        userLang: session.userLang,
        partnerId: session.partnerId,
        userTimezone: session.userTimezone,
        companyId: companyId,
        companyName: session.companyName,
        isSystem: session.isSystem,
        version: session.version,
      );

      final prefs = await SharedPreferences.getInstance();
      final db = prefs.getString('database') ?? '';
      final sessionId = prefs.getString('sessionId') ?? '';
      final serverVersion = prefs.getString('serverVersion') ?? '';
      final userLang = prefs.getString('userLang') ?? '';
      final allowedIdStrings =
          prefs.getStringList('allowed_company_ids') ?? [];
      final allowedCompanies = allowedIdStrings
          .map((idStr) {
            final id = int.tryParse(idStr);
            return id != null && id > 0 ? Company(id: id, name: '') : null;
          })
          .whereType<Company>()
          .toList();
      final odooSession = OdooSession(
        id: sessionId,
        userId: prefs.getInt('userId') ?? 0,
        partnerId: prefs.getInt('partnerId') ?? 0,
        userLogin: prefs.getString('userLogin') ?? '',
        userName: prefs.getString('userName') ?? '',
        userLang: userLang,
        userTz: '',
        isSystem: prefs.getBool('isSystem') ?? false,
        dbName: db,
        serverVersion: serverVersion,
        companyId: prefs.getInt('companyId') ?? 1,
        allowedCompanies: allowedCompanies,
      );

      final OdooClient client = _trackSessionRotation(
          OdooClient(url, sessionId: odooSession, httpClient: ioClient));
      await StorageService().saveSession(updatedSession);

      _client = client;
      _cachedSession = updatedSession;
      _lastAuthTime = DateTime.now();
      ConnectivityService.instance.setCurrentServerUrl(url);
      _onSessionUpdated?.call(updatedSession);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update only the selected company in the cached session
  static Future<void> updateCompanySelection({
    required int companyId,
    required List<int> allowedCompanyIds,
  }) async {
    final session = await getCurrentSession();
    if (session == null) return;

    final updated = SessionModel(
      sessionId: session.sessionId,
      userName: session.userName,
      userLogin: session.userLogin,
      userId: session.userId,
      serverVersion: session.serverVersion,
      userLang: session.userLang,
      partnerId: session.partnerId,
      userTimezone: session.userTimezone,
      companyId: companyId,
      companyName: session.companyName,
      isSystem: session.isSystem,
      version: session.version,
    );

    await StorageService().saveSession(updated);
    _cachedSession = updated;
    _onSessionUpdated?.call(updated);
  }

  /// Fetch list of allowed companies for current user
  static Future<List<Map<String, dynamic>>> getAllowedCompaniesList() async {
    final client = await getClientEnsured();
    final session = await getCurrentSession();
    if (session == null || session.userId == null) return [];

    try {
      final result = await client.callKw({
        'model': 'res.users',
        'method': 'read',
        'args': [
          [session.userId],
          ['company_ids'],
        ],
        'kwargs': {},
      });

      if (result is List && result.isNotEmpty) {
        final companyIds =
            (result[0]['company_ids'] as List?)?.cast<int>() ?? [];
        if (companyIds.isEmpty) return [];

        final companies = await client.callKw({
          'model': 'res.company',
          'method': 'search_read',
          'args': [
            [
              ['id', 'in', companyIds],
            ],
          ],
          'kwargs': {
            'fields': ['id', 'name'],
          },
        });

        if (companies is List) {
          return companies.cast<Map<String, dynamic>>();
        }
      }
    } catch (_) {}

    return [];
  }

  static Future<int?> getSelectedCompanyId() async {
    final session = await getCurrentSession();
    if (session?.companyId != null) {
      return session!.companyId;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('selected_company_id');
    } catch (_) {
      return null;
    }
  }

  static Future<List<int>> getSelectedAllowedCompanyIds() async {
    final session = await getCurrentSession();
    if (session != null && session.allowedCompanyIds.isNotEmpty) {
      return session.allowedCompanyIds;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList('selected_allowed_company_ids') ?? [];
      return raw.map((e) => int.tryParse(e) ?? -1).where((e) => e > 0).toList();
    } catch (_) {
      return [];
    }
  }

  /// Main RPC entry point — injects company_id & allowed_company_ids into context
  static Future<dynamic> callKwWithCompany(
    Map<String, dynamic> payload, {
    int? companyId,
    List<int>? allowedCompanyIds,
  }) async {
    final map = Map<String, dynamic>.from(payload);

    Map<String, dynamic> kwargs = {};
    final rawKwargs = map['kwargs'];
    if (rawKwargs is Map) {
      kwargs = rawKwargs.map((key, value) => MapEntry(key.toString(), value));
    }

    Map<String, dynamic> ctx = {};
    final rawCtx = kwargs['context'];
    if (rawCtx is Map) {
      ctx = rawCtx.map((key, value) => MapEntry(key.toString(), value));
    }
    int? selectedCompany = companyId;
    List<int>? allowed = allowedCompanyIds;

    if (selectedCompany == null || allowed == null) {
      final session = await getCurrentSession();
      selectedCompany ??= session?.companyId ?? await getSelectedCompanyId();
      allowed ??= session?.allowedCompanyIds.isNotEmpty == true
          ? session!.allowedCompanyIds
          : await getSelectedAllowedCompanyIds();
    }

    if (selectedCompany != null) {
      ctx['company_id'] = selectedCompany;

      // Odoo derives env.company from allowed_company_ids[0] (the
      // 'company_id' context key is ignored), so the selected company must
      // come first or new records get stamped with another company.
      ctx['allowed_company_ids'] = <int>{selectedCompany, ...allowed}.toList();
    }

    kwargs['context'] = ctx;
    map['kwargs'] = kwargs;

    return callWithSession((client) => _callKwCompat(client, map));
  }

  /// Runs `call_kw` after adapting the payload to this server's schema.
  static Future<dynamic> _callKwCompat(
      OdooClient client, Map<String, dynamic> payload) async {
    final (adapted, mapResult) = await OdooCompat.adapt(client, payload);
    return mapResult(await client.callKw(adapted));
  }

  static Future<dynamic> callVersion() async {
    return callWithSession((client) async {
      return await client.callRPC(
        '/web/webclient/version_info',
        'call',
        {},
      );
    });
  }

  static Future<dynamic> callLastSeenMessage({
    required int channelId,
    required int lastMessageId,
    bool sync = false,
  }) async {
    return callWithSession((client) async {
      return await client.callRPC(
        '/discuss/channel/set_last_seen_message',
        'call',
        {
          'channel_id': channelId,
          'last_message_id': lastMessageId,
          'sync': sync,
        },
      );
    });
  }

  static Future<dynamic> callActivity({
    required String model,
    required String method,
    List<dynamic> args = const [],
    Map<String, dynamic> kwargs = const {},
  }) async {
    return callWithSession((client) async {
      return await client.callRPC(
        '/web/dataset/call_kw',
        'call',
        {
          'model': model,
          'method': method,
          'args': args,
          'kwargs': kwargs,
        },
      );
    });
  }

  static Future<dynamic> callMailData({
    Map<String, dynamic>? context,
    bool systrayGetActivities = true,
    List<String>? fetchParams,
  }) async {
    return callWithSession((client) async {
      final Map<String, dynamic> body = fetchParams != null
          ? {'fetch_params': fetchParams}
          : {
              'systray_get_activities': systrayGetActivities,
              'context': context ?? {},
            };
      return await client.callRPC('/mail/data', 'call', body);
    });
  }

  static Future<dynamic> callSystrayActivity({
    required Map<String, dynamic> context,
  }) async {
    return callWithSession((client) async {
      return await client.callRPC(
        '/web/dataset/call_kw',
        'call',
        {
          'model': 'res.users',
          'method': 'systray_get_activities',
          'args': [],
          'kwargs': {
            'context': context,
          },
        },
      );
    });
  }

  static Future<dynamic> callSaleOnchange({int? defaultTemplateId}) async {
    return callWithSession((client) async {
      return await client.callRPC(
        '/web/dataset/call_kw/sale.order/onchange',
        'call',
        {
          'model': 'sale.order',
          'method': 'onchange',
          'args': [
            [],
            {},
            [],
            {
              'partner_id': {
                'fields': {'display_name': {}},
                'context': {
                  'res_partner_search_mode': 'customer',
                  'show_address': 1,
                  'show_vat': true,
                },
              },
              'sale_order_template_id': {
                'fields': {'display_name': {}}
              },
              'payment_term_id': {
                'fields': {'display_name': {}}
              },
              'validity_date': {},
              'date_order': {},
              'currency_id': {
                'fields': {'display_name': {}}
              },
              'tax_country_id': {
                'fields': {'display_name': {}}
              },
              'company_id': {
                'fields': {'display_name': {}}
              },
              'pricelist_id': {
                'fields': {'display_name': {}}
              },
            },
          ],
          'kwargs': {
            'context': {
              'lang': 'en_US',
              'uid': client.sessionId?.userId ?? 2,
              'allowed_company_ids': client.sessionId?.companyId != null
                  ? [client.sessionId!.companyId]
                  : [1],
              if (defaultTemplateId != null)
                'default_sale_order_template_id': defaultTemplateId,
              'params': {
                'action': 'sales',
                'view_type': 'form',
                'model': 'sale.order',
              },
            },
          },
        },
      );
    });
  }

  /// Re-authenticate using stored credentials (used on auth errors). Calls
  /// that fail together at session expiry all await this one re-login instead
  /// of retrying against the stale client before it finishes.
  static Future<bool> refreshSession() {
    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight;
    final refresh = _performRefresh().whenComplete(() {
      _refreshInFlight = null;
    });
    _refreshInFlight = refresh;
    return refresh;
  }

  static Future<bool> _performRefresh() async {
    final current = await getCurrentSession();
    if (current == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final database = prefs.getString('database') ?? '';
    final url = prefs.getString('url') ?? '';
    final userLogin = current.userLogin ?? '';

    final password = await SecureStorageService().getPassword(
      url: url,
      database: database,
      username: userLogin,
    );
    if (password == null || password.isEmpty) return false;

    return await loginAndSaveSession(
      serverUrl: url,
      database: database,
      userLogin: userLogin,
      password: password,
    );
  }

  /// Try to restore browser-style raw session cookie
  static Future<void> initializeFromBrowserSession() async {
    final prefs = await SharedPreferences.getInstance();

    final String? rawSessionId = prefs.getString('odoo_session_id_raw');
    final String? url = prefs.getString('url');
    final String? database = prefs.getString('database');

    if (rawSessionId == null || rawSessionId.isEmpty) {
      return;
    }
    if (url == null || url.isEmpty) {
      return;
    }
    if (database == null || database.isEmpty) {
      return;
    }

    String cleanSessionId = rawSessionId.trim();
    if (cleanSessionId.contains(';')) {
      cleanSessionId = cleanSessionId.split(';').first.trim();
    }
    if (cleanSessionId.contains('=')) {
      cleanSessionId = cleanSessionId.split('=').last.trim();
    }

    final odooSession = OdooSession(
      id: cleanSessionId,
      dbName: database,
      userId: prefs.getInt('userId') ?? 0,
      partnerId: prefs.getInt('partnerId') ?? 0,
      userLogin: prefs.getString('userLogin') ?? '',
      userName: prefs.getString('userName') ?? '',
      userLang: prefs.getString('userLang') ?? 'en_US',
      userTz: prefs.getString('userTimezone') ?? 'UTC',
      isSystem: prefs.getBool('isSystem') ?? false,
      serverVersion: prefs.getString('serverVersion') ?? '',
      companyId: prefs.getInt('companyId') ?? 1,
      allowedCompanies: [],
    );

    /// Do NOT call `_client?.close()` here: every OdooClient in this app
    /// shares the single app-wide `ioClient` (see self_signed.dart). Closing
    /// one instance closes that shared HttpClient for good — every
    /// subsequent request anywhere in the app then fails with
    /// "Client is already closed" until the app is restarted. Just drop
    /// the reference; a fresh OdooClient below reuses the still-open client.
    _client = null;

    try {
      _client = _trackSessionRotation(
        OdooClient(url, sessionId: odooSession, httpClient: ioClient));

      _cachedSession = SessionModel(
        sessionId: cleanSessionId,
        userId: odooSession.userId,
        userName: odooSession.userName,
        userLogin: odooSession.userLogin,
        serverVersion: odooSession.serverVersion,
        userLang: odooSession.userLang,
        partnerId: odooSession.partnerId,
        userTimezone: odooSession.userTz,
        companyId: odooSession.companyId,
        companyName: prefs.getString('company_name') ?? 'Company',
        isSystem: odooSession.isSystem,
      );

      _lastAuthTime = DateTime.now();

      ConnectivityService.instance.setCurrentServerUrl(url);
      _onSessionUpdated?.call(_cachedSession!);
    } catch (e) {
      _client = null;
      _cachedSession = null;
    }
  }

  /// Get or (re)create OdooClient — main entry point for most RPC logic
  static Future<OdooClient> getClientEnsured() async {
    final session = await getCurrentSession();
    if (session == null) throw StateError('No session. Login required.');

    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('url') ?? '';
    if (prefs.containsKey('odoo_session_id_raw')) {
      await initializeFromBrowserSession();
      if (_client != null) return _client!;
    }
    if (_client != null &&
        _cachedSession != null &&
        _lastAuthTime != null &&
        DateTime.now().difference(_lastAuthTime!) <
            _sessionCacheValidDuration) {
      return _client!;
    }

    try {
      await ConnectivityService.instance.ensureInternetOrThrow();
      await ConnectivityService.instance.ensureServerReachable(url);

      final prefs = await SharedPreferences.getInstance();
      final db = prefs.getString('database') ?? '';
      final sessionId = prefs.getString('sessionId') ?? '';

      // Keep the live client while it still carries the stored session:
      // screens hold on to it, and only that instance hears a rotation.
      final live = _client;
      final liveId = live?.sessionId?.id;
      if (live != null &&
          live.baseURL == url &&
          liveId != null &&
          liveId.isNotEmpty &&
          (liveId == sessionId || liveId == _cachedSession?.sessionId)) {
        _lastAuthTime = DateTime.now();
        return live;
      }

      final serverVersion = prefs.getString('serverVersion') ?? '';
      final userLang = prefs.getString('userLang') ?? '';
      final allowedIdStrings =
          prefs.getStringList('allowed_company_ids') ?? [];
      final allowedCompanies = allowedIdStrings
          .map((idStr) {
            final id = int.tryParse(idStr);
            return id != null && id > 0 ? Company(id: id, name: '') : null;
          })
          .whereType<Company>()
          .toList();
      final session = OdooSession(
        id: sessionId,
        userId: prefs.getInt('userId') ?? 0,
        partnerId: prefs.getInt('partnerId') ?? 0,
        userLogin: prefs.getString('userLogin') ?? '',
        userName: prefs.getString('userName') ?? '',
        userLang: userLang,
        userTz: '',
        isSystem: prefs.getBool('isSystem') ?? false,
        dbName: db,
        serverVersion: serverVersion,
        companyId: prefs.getInt('companyId') ?? 1,
        allowedCompanies: allowedCompanies,
      );

      final client = _trackSessionRotation(
          OdooClient(url, sessionId: session, httpClient: ioClient));

      _client = client;
      _lastAuthTime = DateTime.now();
      return client;
    } on NoInternetException {
      if (_client != null) return _client!;
      rethrow;
    } on ServerUnreachableException {
      if (_client != null) return _client!;
      rethrow;
    }
  }

  /// Generic wrapper that ensures client + handles auth refresh on 401/403-like errors
  static Future<T> callWithSession<T>(
    Future<T> Function(OdooClient client) action,
  ) async {
    final client = await getClientEnsured();
    try {
      return await action(client);
    } catch (e) {
      if (e is NoInternetException || e is ServerUnreachableException) rethrow;
      if (_isAuthError(e)) {
        bool refreshed;
        try {
          refreshed = await refreshSession();
        } catch (_) {
          refreshed = false;
        }
        if (refreshed) {
          final newClient = await getClientEnsured();
          return await action(newClient);
        }
      }
      rethrow;
    }
  }

  /// Alias → callKwWithCompany (most common usage)
  static Future<dynamic> safeCallKw(Map<String, dynamic> payload) {
    return callKwWithCompany(payload);
  }

  /// Low-level call without automatic company context injection
  static Future<dynamic> safeCallKwWithoutCompany(
    Map<String, dynamic> payload,
  ) {
    return callWithSession((client) => _callKwCompat(client, payload));
  }
}
