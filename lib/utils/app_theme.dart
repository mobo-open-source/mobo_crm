import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Extension to adjust color brightness using HSL color space.
///
/// Allows increasing or decreasing lightness of a color safely
/// while keeping hue and saturation unchanged.
extension ColorBrightness on Color {
  /// Returns a new color with adjusted brightness.
  ///
  /// [brightnessDelta] → Positive = lighter, Negative = darker
  /// Value is clamped between 0.0 and 1.0.
  Color withBrightness(double brightnessDelta) {
    final hsl = HSLColor.fromColor(this);

    final newLightness = (hsl.lightness + brightnessDelta).clamp(0.0, 1.0);
    return hsl.withLightness(newLightness).toColor();
  }
}

/// Centralized application theme configuration.
///
/// Contains:
/// • Primary & secondary brand colors
/// • Light theme configuration
/// • Dark theme configuration
/// • Common component theming (AppBar, Buttons, Inputs)
class AppTheme {

  /// Main brand color used across the app.
  static const Color primaryColor = Color(0xFFC03355);

  /// Secondary supporting color (usually backgrounds / contrast).
  static const Color secondaryColor = Color(0xFFffffff);

  /// Light mode theme configuration.
  ///
  /// Includes:
  /// • Manrope font
  /// • Seed-based color scheme
  /// • Light scaffold background
  /// • Styled AppBar, Buttons and Inputs
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    fontFamily: GoogleFonts.manrope().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Colors.white,
      surfaceTint: Colors.transparent,
    ),
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      disabledElevation: 0,
    ),
    dialogTheme: DialogThemeData(
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide.none,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionColor: primaryColor.withValues(alpha: 0.25),
      selectionHandleColor: primaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 4,
    ),
  );

  /// Dark mode theme configuration.
  ///
  /// Optimized for low-light UI with:
  /// • Dark scaffold background
  /// • Same brand color identity
  /// • Consistent component styling
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    fontFamily: GoogleFonts.manrope().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    scaffoldBackgroundColor: const Color(0xFF181A20),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      disabledElevation: 0,
    ),
    dialogTheme: DialogThemeData(
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide.none,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionColor: primaryColor.withValues(alpha: 0.25),
      selectionHandleColor: primaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Color(0xFF2C2C2E),
      surfaceTintColor: Colors.transparent,
      elevation: 4,
    ),
  );
}

/// Centralized status badge color system matching the Mobo Figma design.
///
/// Figma spec:
/// - Color: #22C55E (green) at 12% opacity background
/// - Radius: 18px
/// - Padding: 10px horizontal, 4px vertical
/// - Text: same color as background base color, weight w600, size 11
class StatusColors {
  /// Figma green — used for: approved, sale, posted, won, planned
  static const Color statusGreen = Color(0xFF00A63E);

  /// Blue — used for: sent, qualified, proposal
  static const Color statusBlue = Color(0xFF3B82F6);

  /// Orange — used for: draft, in-progress
  static const Color statusOrange = Color(0xFFF97316);

  /// Red — used for: cancel, lost
  static const Color statusRed = Color(0xFFEF4444);

  /// Teal — used for: locked/done
  static const Color statusTeal = Color(0xFF14B8A6);

  /// Grey — used for: unknown/default
  static const Color statusGrey = Color(0xFF6B7280);

  /// Returns the semantic [Color] for a quotation/invoice [state] string.
  static Color getStatusColor(String? state) {
    switch (state?.toString().toLowerCase()) {
      case 'sale':
      case 'posted':
      case 'paid':
      case 'won':
      case 'planned':
        return statusGreen;
      case 'sent':
      case 'qualified':
      case 'proposition':
        return statusBlue;
      case 'draft':
        return statusOrange;
      case 'done':
      case 'locked':
        return statusTeal;
      case 'cancel':
      case 'lost':
        return statusRed;
      default:
        return statusGrey;
    }
  }

  /// Returns the semantic [Color] for an opportunity stage name.
  static Color getStageColor(String stageName) {
    final lower = stageName.toLowerCase();
    if (lower.contains('won') || lower.contains('closed')) return statusGreen;

    if (lower.contains('new') ||
        lower.contains('qualified') ||
        lower.contains('proposal')) {
      return statusBlue;
    }

    if (lower.contains('lost') || lower.contains('cancel')) return statusRed;
    if (lower.contains('draft')) return statusOrange;

    return statusOrange;
  }

  /// Builds a Mobo-style status badge matching the Figma design.
  ///
  /// - Radius: 18px
  /// - Padding: 10px horizontal, 4px vertical
  /// - Background: [color] at 12% opacity
  /// - Text: [color] (light) or white (dark)
  static Widget buildStatusBadge(
    String label,
    Color color, {
    bool isDark = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.15)
            : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : color,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
