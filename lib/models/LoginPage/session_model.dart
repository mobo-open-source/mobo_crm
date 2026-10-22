/// Represents an authenticated user session.
///
/// Contains user details, company information,
/// server metadata, and session configuration.
class SessionModel {
  final String? userName;
  final String? userLogin;
  final int? userId;
  final String sessionId;
  final String? serverVersion;
  final String? userLang;
  final int? partnerId;
  final String? userTimezone;
  final int? companyId;
  final String? companyName;
  final bool isSystem;
  final int? version;
  final List<int> allowedCompanyIds;

  /// Creates a [SessionModel] instance.
  ///
  /// The [sessionId] is required as it represents
  /// the active authenticated session.
  SessionModel({
    required this.sessionId,
    this.userName,
    this.userLogin,
    this.userId,
    this.serverVersion,
    this.userLang,
    this.partnerId,
    this.userTimezone,
    this.companyId,
    this.companyName,
    this.isSystem = false,
    this.version,
    this.allowedCompanyIds = const [],
  });

  /// The same session under a new id, e.g. after the server rotated it.
  SessionModel withSessionId(String newSessionId) => SessionModel(
        sessionId: newSessionId,
        userName: userName,
        userLogin: userLogin,
        userId: userId,
        serverVersion: serverVersion,
        userLang: userLang,
        partnerId: partnerId,
        userTimezone: userTimezone,
        companyId: companyId,
        companyName: companyName,
        isSystem: isSystem,
        version: version,
        allowedCompanyIds: allowedCompanyIds,
      );
}
