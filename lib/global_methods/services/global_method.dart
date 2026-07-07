import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

/// Utility class containing static methods for showing consistent error dialogs
/// across the app.
class GlobalMethod {
  /// Displays a centered, styled error dialog with a red warning icon,
  /// custom error message, and a "Close" button.
  ///
  /// The dialog uses a transparent background with a shadowed white card
  /// for a modern, elevated appearance.
  ///
  /// Parameters:
  ///   - [error]  The error message to display
  ///   - [ctx]    BuildContext used to show the dialog
  static void showErrorDialog(
      {required String error, required BuildContext ctx}) {
    showDialog(
      context: ctx,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context, error),
        );
      },
    );
  }

  /// Internal widget builder for the error dialog content.
  ///
  /// Returns a stacked card layout with:
  ///   - Red warning icon + "Invalid Operation" title
  ///   - Scrollable error message
  ///   - Blue "Close" button at bottom-right
  static Widget contentBox(BuildContext context, String error) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 56, 28),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.report_problem_outlined,
                    color: Colors.red,
                    size: 28,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Invalid Operation",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                error,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 18,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Centralized error handling utility that classifies exceptions,
/// extracts meaningful messages (especially from Odoo), and shows
/// user-friendly dialogs via `GlobalMethod.showErrorDialog`.
class ErrorHandlerCustom {
  /// Handles any error/exception and displays an appropriate dialog
  /// if a valid [context] is provided.
  ///
  /// Supported error types with custom messages:
  ///   - OdooException          → smart message extraction
  ///   - SocketException        → network/connection issues
  ///   - TimeoutException       → timeout feedback
  ///   - HttpException          → generic HTTP error
  ///   - HandshakeException     → SSL/TLS issues
  ///   - Fallback               → generic unexpected error
  ///
  /// If [context] is null, the error is silently ignored (useful in background tasks).
  static void handleError(BuildContext? context, dynamic error) {
    String errorMessage;

    if (error is OdooException) {
      errorMessage = _extractOdooErrorMessage(error.toString());
    } else if (error is SocketException) {
      errorMessage =
          "Network error. Please check your internet connection and try again.";
    } else if (error is TimeoutException) {
      errorMessage = "Request timed out. Please try again.";
    } else if (error is HttpException) {
      errorMessage = "HTTP error occurred. Please try again later.";
    } else if (error is HandshakeException) {
      errorMessage = "SSL Handshake failed. Please check your connection.";
    } else {
      errorMessage = "An unexpected error occurred: $error";
    }

    if (context != null) {
      GlobalMethod.showErrorDialog(error: errorMessage, ctx: context);
    }
  }

  /// Extracts a clean, user-friendly message from an OdooException string.
  ///
  /// Special handling for common cases:
  ///   - "Cannot create an invoice..." → detailed, actionable explanation
  ///
  /// General fallback:
  ///   - Strips Odoo class names and stack traces
  ///   - Removes brackets, newlines, redundant words
  ///   - Returns trimmed meaningful text
  static String _extractOdooErrorMessage(String fullError) {
    if (fullError.contains(
        "Cannot create an invoice. No items are available to invoice.")) {
      return '''
Cannot create an invoice. No items are available to invoice.

To resolve this issue, please ensure that:
• The products have been delivered before attempting to invoice them.
• The invoicing policy of the product is configured correctly.

If you want to invoice based on ordered quantities instead:
• For consumable or storable products, open the product, go to the 'General Information' tab and change the 'Invoicing Policy' from 'Delivered Quantities' to 'Ordered Quantities'.
• For services (and other products), change the 'Invoicing Policy' to 'Prepaid/Fixed Price'.
''';
    }

    RegExp exceptionTypeRegex =
        RegExp(r"odoo\.exceptions\.\w+:\s*(.*)", multiLine: true);
    Match? exceptionMatch = exceptionTypeRegex.firstMatch(fullError);
    if (exceptionMatch != null) {
      return exceptionMatch.group(1)?.trim() ?? "An error occurred.";
    }

    return fullError
        .replaceAll(RegExp(r'OdooException|Exception|Service'), '')
        .replaceAll(RegExp(r'[\[\]\n]+'), ' ')
        .trim();
  }
}
