import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/company/session/company_session_manager.dart';
import '../../utils/globals.dart';

/// Enum representing different categories of errors that can occur in the app.
enum ErrorType {
  network,
  client,
  socket,
  unknown,
  timeout,
  server,
  module,
  notFound,
  dataFormat,
  api,
  user
}

/// Immutable class representing a structured app error with type, message,
/// and optional original exception for debugging.
class AppError {
  final ErrorType type;
  final String message;
  final dynamic originalError;

  AppError({
    required this.type,
    required this.message,
    this.originalError,
  });

  @override
  String toString() =>
      'AppError(type: $type, message: $message, originalError: $originalError)';
}

/// Full-screen error UI that displays a Lottie animation, title, message,
/// and optional retry button.
///
/// Designed to be pushed as a new route when critical errors occur.
class ErrorScreen extends StatelessWidget {
  final AppError error;
  final VoidCallback? onRetry;
  final bool goBack;
  final bool isSignOut;

  const ErrorScreen({
    super.key,
    required this.error,
    this.onRetry,
    this.goBack = false,
    this.isSignOut = false,
  });

  /// Builds a centered layout with Lottie animation, title, subtitle, and button
  Widget _buildCenteredLottie({
    required BuildContext context,
    required String lottie,
    required String title,
    String? subtitle,
    Widget? button,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(lottie, width: 260),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                  if (button != null) ...[
                    const SizedBox(height: 12),
                    button,
                  ],
                  if (goBack) ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Back to List',
                        style: TextStyle(
                          color: AppStyle.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: _buildCenteredLottie(
          context: context,
          lottie: 'assets/Error_404.json',
          title: _getErrorTitle(),
          subtitle: error.message,
          button: error.type != ErrorType.notFound
              ? OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppStyle.primaryColor,
                    side: BorderSide(color: AppStyle.primaryColor, width: 1.5),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onRetry,
                  child: Text(
                    'Retry',
                    style: TextStyle(
                      color: AppStyle.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  /// Maps error type to a user-friendly title string
  String _getErrorTitle() {
    switch (error.type) {
      case ErrorType.network:
        return 'No Internet Connection';
      case ErrorType.client:
        return 'Something Went Wrong';
      case ErrorType.socket:
        return 'Can\'t Reach Server';
      case ErrorType.unknown:
        return 'Unexpected Error';
      case ErrorType.timeout:
        return 'Request Timed Out';
      case ErrorType.server:
        return 'Server Error';
      case ErrorType.module:
        return 'Missing Modules';
      case ErrorType.notFound:
        return 'Record Not Found';
      case ErrorType.dataFormat:
        return 'Invalid Data Format';
      case ErrorType.api:
        return 'API Error';
      case ErrorType.user:
        return 'User Error';
    }
  }
}

/// Centralized factory & helper class for creating consistent `AppError` instances
/// and classifying exceptions into meaningful error types.
class ErrorHandler {
  /// Creates an error indicating missing Odoo modules.
  static AppError moduleError({required List<String> missingModules}) {
    final moduleList = missingModules.join(', ');
    return AppError(
      type: ErrorType.module,
      message:
          'The following modules are required: $moduleList. Please install them to continue.',
    );
  }

  /// Creates a "record not found" error with custom message.
  static AppError notFoundError({required String message}) {
    return AppError(
      type: ErrorType.notFound,
      message: message,
    );
  }

  Future<bool> isPortalUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final int userId = prefs.getInt('userId') ?? 0;

      if (userId <= 0) return false;

      final result = await CompanySessionManager.callKwWithCompany({
        'model': 'res.users',
        'method': 'has_group',
        'args': ['base.group_portal'],
        'kwargs': {},
      });

      return result == true;
    } catch (e) {
      return false;
    }
  }

  /// Classifies common exception types into `AppError` with appropriate messages.
  ///
  /// Handles:
  ///   - SocketException (connection refused, unreachable, etc.)
  ///   - http.ClientException
  ///   - HttpException
  ///   - TimeoutException
  ///   - OdooException
  ///   - Fallback to unknown
  static Future<AppError> handleException(dynamic error, {String? uri}) async {
    try {
      final isPortal = await ErrorHandler().isPortalUser();

      if (isPortal) {
        return AppError(
          type: ErrorType.user,
          message:
              'No access: This feature is not available for portal users.\n'
              'Please contact your administrator.',
        );
      }
    } catch (_) {}

    if (error is SocketException) {
      String message;
      if (error.osError?.errorCode == 111) {
        message =
            'Cannot connect to the server. Please check if it\'s running.';
      } else if (error.osError?.errorCode == 113) {
        message = 'Network unreachable. Please check your internet connection.';
      } else {
        message = 'Connection Refused. Tap retry after connecting your server.';
      }
      return AppError(
        type: ErrorType.socket,
        message: message,
      );
    }

    if (error is http.ClientException) {
      return AppError(
        type: ErrorType.client,
        message: 'Unable to reach the server. Please verify the server URL.',
      );
    }

    if (error is HttpException) {
      return AppError(
        type: ErrorType.network,
        message: 'Network error occurred. Please try again.',
      );
    }

    if (error is TimeoutException) {
      return AppError(
        type: ErrorType.timeout,
        message: 'Request timed out. Please check your connection.',
      );
    }

    if (error is OdooException) {
      return AppError(
        type: ErrorType.server,
        message: 'Server error occurred. Please try again later.',
      );
    }

    return AppError(
      type: ErrorType.unknown,
      message: 'Something went wrong. Please try again.',
    );
  }

  /// Quick helper to get only the ErrorType from any exception.
  static ErrorType getErrorType(dynamic error) {
    if (error is SocketException) {
      return ErrorType.socket;
    } else if (error is http.ClientException) {
      return ErrorType.client;
    } else if (error is HttpException) {
      return ErrorType.network;
    } else if (error is TimeoutException) {
      return ErrorType.timeout;
    } else if (error is OdooException) {
      return ErrorType.server;
    } else {
      return ErrorType.unknown;
    }
  }
}
