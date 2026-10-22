import 'package:flutter/material.dart';

/// Utility class for showing themed Material date and time pickers.
///
/// Wraps Flutter's built-in `showDatePicker` / `showTimePicker` with the
/// mobo primary color (`#C03355`) applied to the header, selected day,
/// today marker, and action buttons.
class DatePickerUtils {
  /// Displays a themed Material date picker.
  static Future<DateTime?> showStandardDatePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? helpText,
    String? cancelText,
    String? confirmText,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2001),
      lastDate: lastDate ?? DateTime(2099),
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: primaryColor,
                  onPrimary: Colors.white,
                  surface: isDark ? Colors.grey[850] : Colors.white,
                  onSurface: isDark ? Colors.white : Colors.black,
                  surfaceVariant:
                      isDark ? Colors.grey[800] : Colors.grey[100],
                  onSurfaceVariant:
                      isDark ? Colors.grey[300] : Colors.grey[700],
                ),
            dialogBackgroundColor: isDark ? Colors.grey[850] : Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: isDark ? Colors.grey[850] : Colors.white,
              headerBackgroundColor: primaryColor,
              headerForegroundColor: Colors.white,
              dayForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return isDark ? Colors.white : Colors.black;
              }),
              dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return primaryColor;
                }
                return Colors.transparent;
              }),
              todayForegroundColor:
                  MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return primaryColor;
              }),
              todayBackgroundColor:
                  MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return primaryColor;
                }
                return Colors.transparent;
              }),
              todayBorder: BorderSide(color: primaryColor, width: 1),
              yearForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return isDark ? Colors.white : Colors.black;
              }),
              yearBackgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return primaryColor;
                }
                return Colors.transparent;
              }),
              rangePickerBackgroundColor:
                  isDark ? Colors.grey[850] : Colors.white,
              rangePickerHeaderBackgroundColor: primaryColor,
              rangePickerHeaderForegroundColor: Colors.white,
              rangeSelectionBackgroundColor: primaryColor.withOpacity(0.1),
              rangeSelectionOverlayColor: MaterialStateProperty.all(
                primaryColor.withOpacity(0.1),
              ),
            ),
          ),
          child: child!,
        );

      },
    );
  }
}
