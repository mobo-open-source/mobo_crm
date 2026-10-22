/// Raised when a sign-in reaches a database that has expired.
///
/// Odoo Enterprise tells a signed-in client when the database lapses, but its
/// own web client only warns. The app refuses the sign-in instead, so a user
/// isn't let into a database that is no longer covered.
class DatabaseExpiredException implements Exception {
  /// When the database expired, in UTC.
  final DateTime expiredOn;

  /// Odoo's `expiration_reason`: `trial`, `demo`, `renewal` or `upsell`.
  final String? reason;

  const DatabaseExpiredException({required this.expiredOn, this.reason});

  String get title => 'Database expired';

  /// What to tell the user, worded for why the database lapsed.
  ///
  /// Kept free of words such as "null" or "code": other sign-in screens read
  /// an exception's text to tell a two-factor prompt from a failure.
  String get message {
    final date = _formatDate(expiredOn.toLocal());
    // Odoo treats a database with no reason as unregistered, like a trial.
    final unregistered =
        reason == null || reason == 'trial' || reason == 'demo';
    if (unregistered) {
      return 'The trial of this database ended on $date, so signing in is '
          'blocked. Register or buy a subscription, or contact your '
          'administrator.';
    }
    return 'This database expired on $date, so signing in is blocked. Ask '
        'your administrator to renew its subscription, then sign in again.';
  }

  @override
  String toString() => 'DatabaseExpiredException: $message';
}

/// The expiry Odoo reports in its session info, as UTC, or null when the
/// database has none (Community, or no date set) or the value is unreadable.
///
/// Odoo writes it as `YYYY-MM-DD HH:MM:SS` in UTC; a bare date is read as
/// midnight UTC.
DateTime? parseDatabaseExpiration(dynamic raw) {
  if (raw is! String) return null;
  var text = raw.trim();
  if (text.isEmpty) return null;
  if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(text)) text = '$text 00:00:00';
  text = text.replaceFirst(' ', 'T');
  final hasZone = text.endsWith('Z') || RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(text);
  if (!hasZone) text = '${text}Z';
  return DateTime.tryParse(text)?.toUtc();
}

/// The exception to raise for a database whose expiry has been reached, or
/// null when it is still valid or reports no expiry at all.
///
/// [sessionInfo] is Odoo's session info (`/web/session/get_session_info`).
/// Enterprise adds `expiration_date` to it for internal users, and the date is
/// the same one its web client counts down to, so the app blocks exactly when
/// that client would say "This database has expired".
DatabaseExpiredException? databaseExpiredFrom(
  Map<String, dynamic> sessionInfo, {
  DateTime? now,
}) {
  final expiresOn = parseDatabaseExpiration(sessionInfo['expiration_date']);
  if (expiresOn == null) return null;
  if (expiresOn.isAfter((now ?? DateTime.now()).toUtc())) return null;
  final reason = sessionInfo['expiration_reason'];
  return DatabaseExpiredException(
    expiredOn: expiresOn,
    reason: reason is String && reason.isNotEmpty ? reason : null,
  );
}

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String _formatDate(DateTime date) =>
    '${date.day} ${_months[date.month - 1]} ${date.year}';
