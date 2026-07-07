import 'package:flutter/material.dart';

/// A simple, reusable non-dismissible loading dialog with a circular progress
/// indicator and a customizable message.
///
/// Typical usage:
/// ```dart
/// showDialog(
///   context: context,
///   barrierDismissible: false,
///   builder: (context) => GlobalLoadingDialog(message: 'Saving opportunity...'),
/// );
/// ```
///
/// Features:
/// - Centered row layout with spinner + text
/// - White background with rounded corners
/// - Uses app's primary color for the indicator
/// - Flexible text wrapping for longer messages
/// - Compact padding suitable for most loading states
class GlobalLoadingDialog extends StatelessWidget {
  final String message;

  const GlobalLoadingDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 20),
            Flexible(
              child: Text(
                message,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
