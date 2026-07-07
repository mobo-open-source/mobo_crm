import 'package:mobo_crm/services/storage_service.dart';

import '../core/company/services/company_session_service.dart';
import 'app_install_check.dart';

/// Represents possible login outcomes.
enum LoginStatus {
  success,
  invalidCredentials,
  moduleMissing,
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

      final isInstalled = await appInstallCheck.checkRequiredModules();
      if (!isInstalled) {
        return LoginResult(LoginStatus.moduleMissing);
      }

      return LoginResult(LoginStatus.success);
    } catch (e) {
      final error = e.toString().toLowerCase();

      if (error.contains('two factor') ||
          error.contains('2fa') ||
          error.contains('null')) {
        return LoginResult(LoginStatus.totpRequired);
      }

      return LoginResult(LoginStatus.serverError, error: e);
    }
  }
}
