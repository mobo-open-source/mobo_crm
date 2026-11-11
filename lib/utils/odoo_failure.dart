import 'dart:async';
import 'dart:io';

import 'package:odoo_rpc/odoo_rpc.dart';

import '../core/company/services/connectivity_service.dart';

/// Why a request to Odoo failed, in terms the user can act on.
enum OdooFailureKind {
  /// The user's access rights (groups or record rules) do not allow it.
  accessDenied,

  /// The session is gone; signing in again is needed.
  sessionExpired,

  /// Odoo refused the data (a `ValidationError` / `UserError`).
  validation,

  /// The server could not be reached.
  network,

  /// Anything else.
  other,
}

/// A failed Odoo request, described for display.
class OdooFailure {
  const OdooFailure({
    required this.kind,
    required this.headline,
    this.detail,
  });

  final OdooFailureKind kind;

  /// One short sentence that says what happened. Safe for a toast.
  final String headline;

  /// Odoo's own explanation (for an access error, which groups may do it),
  /// when it has one worth showing. Longer than [headline].
  final String? detail;

  bool get isAccessDenied => kind == OdooFailureKind.accessDenied;
}

/// Turns [error] into an [OdooFailure].
///
/// [action] completes the sentence "You don't have permission to …", for
/// example `schedule an activity on this record`.
///
/// Odoo reports the *kind* of failure (`data.name`) and the readable text
/// (`data.message`) in its error payload. Cutting those two out of the
/// exception is what turns "an error occurred" into "you are not allowed to
/// modify this document" (see [_serverError]).
OdooFailure describeOdooFailure(Object error, {required String action}) {
  if (error is NoInternetException ||
      error is ServerUnreachableException ||
      error is SocketException ||
      error is TimeoutException ||
      error is HandshakeException ||
      error is HttpException) {
    return const OdooFailure(
      kind: OdooFailureKind.network,
      headline: "Couldn't reach the server. Check your connection and try again.",
    );
  }

  if (error is OdooSessionExpiredException) {
    return const OdooFailure(
      kind: OdooFailureKind.sessionExpired,
      headline: 'Your session has expired. Please sign in again.',
    );
  }

  if (error is OdooException) {
    final server = _serverError(error);
    final name = server.name.toLowerCase();
    final message = server.message;

    if (name.contains('accesserror') ||
        name.contains('accessdenied') ||
        _looksLikeAccessDenial(message)) {
      return OdooFailure(
        kind: OdooFailureKind.accessDenied,
        headline: "You don't have permission to $action.",
        detail: message.isEmpty ? null : message,
      );
    }

    if (name.contains('validationerror') ||
        name.contains('usererror') ||
        name.contains('missingerror')) {
      // These are written for the end user, so the message itself is the
      // explanation.
      final lines = message.split('\n').where((l) => l.trim().isNotEmpty);
      final first = lines.isEmpty ? '' : lines.first.trim();
      final rest = lines.skip(1).join('\n').trim();
      return OdooFailure(
        kind: OdooFailureKind.validation,
        headline: first.isEmpty ? "Couldn't $action." : first,
        detail: rest.isEmpty ? null : rest,
      );
    }

    return OdooFailure(
      kind: OdooFailureKind.other,
      headline: "Couldn't $action.",
      detail: message.isEmpty ? null : message,
    );
  }

  return OdooFailure(
    kind: OdooFailureKind.other,
    headline: "Couldn't $action.",
  );
}

/// The exception class name and message Odoo put in its error payload.
///
/// `odoo_rpc` passes the server's error map on as text only: in 0.6 the
/// exception's `message` *is* `map.toString()`, and later releases keep the map
/// too but still expose the same `message`. Reading just `message` therefore
/// works with every version, and the two values are cut out of that text. A
/// dumped error looks like
///
///     {code: 200, message: Odoo Server Error, data: {name: odoo.exceptions.AccessError,
///      debug: Traceback…, message: Sorry, you are not allowed…, arguments: […], context: {}}}
///
/// where the sentence for the user is the last `message:` before `arguments:`.
({String name, String message}) _serverError(OdooException error) {
  final text = error.message;

  final name =
      RegExp(r'\bname:\s*([A-Za-z_][\w.]*)').firstMatch(text)?.group(1) ?? '';

  var message = _messageFrom(text);
  // Odoo's placeholder for "an error happened" says nothing to the user.
  if (message.trim() == 'Odoo Server Error') message = '';
  return (name: name, message: _tidy(message));
}

/// The readable sentence inside a dumped Odoo error map, or '' if there is
/// none. Text that is not a dumped map (such as "Authentication failed") is
/// returned as it is.
String _messageFrom(String text) {
  final dataAt = text.indexOf('data: {');
  if (dataAt < 0) return text;

  final argumentsAt = text.lastIndexOf(', arguments: [');
  final end = argumentsAt >= 0 ? argumentsAt : text.length;
  final start = text.lastIndexOf('message: ', end);
  // Only the outer "message: Odoo Server Error" exists: nothing readable inside.
  if (start < dataAt) return '';

  var out = text.substring(start + 'message: '.length, end);
  // Without an `arguments` entry the dump ends with the closing braces.
  if (argumentsAt < 0) out = out.replaceFirst(RegExp(r'[\s}]+$'), '');
  return out;
}

bool _looksLikeAccessDenial(String message) {
  final lower = message.toLowerCase();
  return lower.contains('not allowed') ||
      lower.contains('access right') ||
      lower.contains('security restriction');
}

/// Normalises whitespace and caps the length, so a long access explanation
/// (which lists every group allowed to do the operation) stays readable.
String _tidy(String text) {
  var out = text
      .replaceAll('\r', '')
      .replaceAll('\t', '  ')
      .replaceAll(RegExp(r'\n{3,}'), '\n\n')
      .trim();
  if (out.length > 700) out = '${out.substring(0, 700).trimRight()}…';
  return out;
}
