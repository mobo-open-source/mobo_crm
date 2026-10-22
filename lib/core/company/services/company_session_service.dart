
import '../../../models/LoginPage/session_model.dart';

/// Contract for handling company session authentication and session retrieval.
///
/// Implementations should handle:
/// - Login and session persistence
/// - Returning current active session

abstract class CompanySessionService {

  /// Authenticates the user with the given credentials and
  /// saves the session locally if successful.
  ///
  /// Returns `true` if login and session storage succeed, `false` otherwise.
  Future<bool> loginAndSaveSession({
    required String serverUrl,
    required String database,
    required String userLogin,
    required String password,
  });

  /// Retrieves the currently stored session.
  ///
  /// Returns the saved `SessionModel` or `null` if no valid session exists.
  Future<SessionModel?> getCurrentSession();

  /// Executes an Odoo `call_kw` RPC call using the current company session.
  Future<int> callKwWithCompany(Map<String, dynamic> payload);

  /// Executes an Odoo `call_kw` RPC call (update style) using the current company session.
  Future<bool> callKwWithCompanyUpdate(Map<String, dynamic> payload);

  /// Executes an Odoo `call_kw` RPC call and returns the full dynamic result.
  Future<dynamic> callKwWithCompanyDynamic(Map<String, dynamic> payload);
}
