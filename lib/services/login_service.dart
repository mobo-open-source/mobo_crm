import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobo_crm/services/storage_service.dart';

import '../core/company/services/company_session_service.dart';
import '../core/company/session/company_session_manager.dart';
import '../global_methods/services/global_error_handler.dart';
import 'app_install_check.dart';
import 'database_expiry.dart';

/// Represents possible login outcomes.
enum LoginStatus {
  success,
  invalidCredentials,
  moduleMissing,
  accessDenied,
  databaseExpired,
  totpRequired,
  serverError,
}

/// Encapsulates the result of a login attempt.
class LoginResult {
  final LoginStatus status;
  final dynamic error;

  /// Creates a [LoginResult].
  LoginResult(this.status, {this.error});
}

/// Handles user authentication and session persistence.
///
/// Responsibilities:
/// - Authenticates user credentials
/// - Stores session and login state locally
/// - Validates required modules
/// - Handles 2FA detection
class LoginService {
  final StorageService storageService;
  final AppInstallCheck appInstallCheck;
  final CompanySessionService sessionService;

  /// Creates a [LoginService] instance.
  LoginService({
    required this.storageService,
    required this.appInstallCheck,
    required this.sessionService,
  });

  /// Attempts to log in using the provided credentials.
  ///
  /// Steps:
  /// 1. Authenticate against the server
  /// 2. Retrieve and store session information
  /// 3. Persist login state and account data
  /// 4. Validate required modules
  ///
  /// Returns a [LoginResult] indicating the outcome.
  Future<LoginResult> login({
    required String serverUrl,
    required String database,
    required String username,
    required String password,
  }) async {
    try {
      final success = await sessionService.loginAndSaveSession(
        serverUrl: serverUrl,
        database: database,
        userLogin: username,
        password: password,
      );

      if (!success) {
        return LoginResult(LoginStatus.invalidCredentials);
      }

      final session = await sessionService.getCurrentSession();
      if (session == null) {
        return LoginResult(LoginStatus.serverError);
      }

      await storageService.saveSession(session);

      /// Portal users have no access to internal models (e.g. crm.lead),
      /// which would otherwise be misread as a missing-module error below.
      /// Reject them here with the correct access-denied outcome.
      final isPortal = await ErrorHandler().isPortalUser();
      debugPrint('[LoginService] isPortalUser => $isPortal');
      if (isPortal) {
        await storageService.clearAllSessionData();
        await CompanySessionManager.clearSessionCache();
        return LoginResult(LoginStatus.accessDenied);
      }

      await storageService.saveLoginState(
        isLoggedIn: true,
        database: database,
        url: serverUrl,
      );
      await storageService.saveAccount({
        'userName': session.userName,
        'userLogin': session.userLogin,
        'userId': session.userId,
        'sessionId': session.sessionId,
        'serverVersion': session.serverVersion,
        'userLang': session.userLang,
        'partnerId': session.partnerId,
        'userTimezone': session.userTimezone,
        'companyId': session.companyId,
        'companyName': session.companyName,
        'isSystem': session.isSystem,
        'url': serverUrl,
        'database': database,
        'password': password,
        'image': '',
      });

      final moduleBlock = await appInstallCheck.requiredModulesBlock();
      if (moduleBlock != null) {
        /// The account was persisted above so the module check could run
        /// against a saved session; roll that back here so a login without
        /// usable CRM/Sales doesn't linger in the switch-accounts list, and
        /// isn't signed into automatically on the next app launch.
        await storageService.removeAccount(
          userLogin: session.userLogin ?? '',
          userName: session.userName ?? '',
          userId: session.userId ?? 0,
          url: serverUrl,
          database: database,
        );
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('isLoggedIn');
        await prefs.remove('sessionId');
        await CompanySessionManager.clearSessionCache();
        return LoginResult(LoginStatus.moduleMissing, error: moduleBlock);
      }

      return LoginResult(LoginStatus.success);
    } catch (e) {
      debugPrint('[LoginService] login() caught: $e');
      // Tested by type before the text checks below, which would otherwise
      // read some wording of the message as a two-factor prompt.
      if (e is DatabaseExpiredException) {
        return LoginResult(LoginStatus.databaseExpired, error: e);
      }
      if (e is ModuleAccessDeniedException) {
        debugPrint('[LoginService] routing to accessDenied via ModuleAccessDeniedException');
        await storageService.clearAllSessionData();
        await CompanySessionManager.clearSessionCache();
        return LoginResult(LoginStatus.accessDenied);
      }

      final error = e.toString().toLowerCase();

      if (error.contains('two factor') ||
          error.contains('two-factor') ||
          error.contains('mfa') ||
          error.contains('2fa') ||
          error.contains('totp') ||
          error.contains('verification code required') ||
          error.contains('null')) {
        return LoginResult(LoginStatus.totpRequired);
      }

      return LoginResult(LoginStatus.serverError, error: e);
    }
  }
}
