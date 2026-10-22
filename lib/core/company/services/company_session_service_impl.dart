import '../../../models/LoginPage/session_model.dart';
import '../session/company_session_manager.dart';
import 'company_session_service.dart';

/// Default implementation of [CompanySessionService].
///
/// Delegates session operations to CompanySessionManager.
class CompanySessionServiceImpl implements CompanySessionService {
  /// Authenticates the user and stores the session using the session manager.
  ///
  /// Returns `true` if login and session persistence succeed.
  @override
  Future<bool> loginAndSaveSession({
    required String serverUrl,
    required String database,
    required String userLogin,
    required String password,
  }) {
    return CompanySessionManager.loginAndSaveSession(
      serverUrl: serverUrl,
      database: database,
      userLogin: userLogin,
      password: password,
    );
  }

  /// Executes an Odoo `call_kw` RPC call with the current company context.
  ///
  /// Returns the integer result (commonly used for record IDs or counts).
  @override
  Future<int> callKwWithCompany(Map<String, dynamic> payload) async {
    return await CompanySessionManager.callKwWithCompany(payload);
  }

  /// Executes an Odoo `call_kw` RPC call (typically for write/unlink operations)
  /// with the current company context.
  ///
  /// Returns `true` if the operation was successful.
  @override
  Future<bool> callKwWithCompanyUpdate(Map<String, dynamic> payload) async {
    return await CompanySessionManager.callKwWithCompany(payload);
  }

  /// Executes an Odoo `call_kw` RPC call and returns the full result.
  ///
  /// Useful when the return type is not known in advance (lists, maps, etc.).
  @override
  Future<dynamic> callKwWithCompanyDynamic(Map<String, dynamic> payload) async {
    return await CompanySessionManager.callKwWithCompany(payload);
  }

  /// Retrieves the currently stored session, if any.
  ///
  /// Returns the saved session or `null` if no valid session exists.
  @override
  Future<SessionModel?> getCurrentSession() {
    return CompanySessionManager.getCurrentSession();
  }
}
