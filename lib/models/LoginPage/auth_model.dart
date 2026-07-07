/// Represents the possible results of an authentication attempt.
enum AuthenticationResult {
  success,
  failure,
  error,
  unavailable,
}

/// Represents the authentication state of the user.
///
/// Used to manage login status, local authentication preference,
/// and the result of the most recent authentication attempt.
class AuthModel {
  final bool isLoggedIn;
  final bool useLocalAuth;
  final AuthenticationResult? authResult;

  /// Creates an [AuthModel] instance.
  ///
  /// Defaults:
  /// - [isLoggedIn] = false
  /// - [useLocalAuth] = false
  /// - [authResult] = null
  AuthModel({
    this.isLoggedIn = false,
    this.useLocalAuth = false,
    this.authResult,
  });

  /// Returns a copy of this [AuthModel] with updated values.
  ///
  /// Only the provided parameters will be replaced.
  /// Other values will retain their current state.
  AuthModel copyWith({
    bool? isLoggedIn,
    bool? useLocalAuth,
    AuthenticationResult? authResult,
  }) {
    return AuthModel(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      useLocalAuth: useLocalAuth ?? this.useLocalAuth,
      authResult: authResult ?? this.authResult,
    );
  }
}
