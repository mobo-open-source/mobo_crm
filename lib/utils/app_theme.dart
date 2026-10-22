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

  static const Color dark = Color(0xFF101010);
  static const Color white = Color(0xFFFFFFFF);
  static const Color inputFillLight = Color(0xFFF2F4F6);
  static final Color inputFillDark = Colors.grey[850]!;
  static const Color popupSearchFillLight = Color(0xFFF3F4F6);
  static const Color primaryTint = Color(0xFFFCE7EE);

  static Color surface(bool isDark) => isDark ? Colors.grey[850]! : white;
  static Color inputFill(bool isDark) =>
      isDark ? inputFillDark : inputFillLight;
  static Color cardBorder(bool isDark) =>
      isDark ? Colors.grey[850]! : Colors.grey[200]!;
  static Color secondaryLabelColor(bool isDark) =>
      isDark ? Colors.grey[400]! : Colors.grey[600]!;
  static Color hintColor(bool isDark) =>
      isDark ? Colors.grey[400]! : Colors.grey[600]!;
  static Color valueColor(bool isDark) => isDark ? Colors.white : dark;
  static Color fieldIconColor(bool isDark) =>
      isDark ? Colors.white : Colors.grey[700]!;

  /// Hint and value share one size so a field doesn't appear to resize once
  /// it's filled in; only the weight changes (w400 → w600).
  static TextStyle fieldValueStyle(bool isDark) => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : dark,
      );

  static TextStyle fieldHintStyle(bool isDark) => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: isDark ? Colors.white54 : Colors.grey[600],
      );

  /// The grey label that sits above a field.
  static TextStyle fieldLabelStyle(bool isDark) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white70 : const Color(0xFF7F7F7F),
      );

  static const EdgeInsets fieldContentPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 14);

  /// Filled, borderless form field with the 2px primary focus ring.
  static InputDecoration fieldDecoration(
    bool isDark, {
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool hasError = false,
  }) {
    final idle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: hasError
          ? const BorderSide(color: StatusColors.statusRed, width: 1)
          : BorderSide.none,
    );
    return InputDecoration(
      isDense: true,
      contentPadding: fieldContentPadding,
      hintText: hintText,
      hintStyle: fieldHintStyle(isDark),
      prefixIcon: prefixIcon,
      prefixIconConstraints: const BoxConstraints(minWidth: 22, minHeight: 22),
      suffixIcon: suffixIcon,
      suffixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      filled: true,
      fillColor: inputFill(isDark),
      border: idle,
      enabledBorder: idle,
      disabledBorder: idle,
      errorBorder: idle,
      focusedErrorBorder: idle,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorStyle: const TextStyle(height: 0, fontSize: 0),
    );
  }

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

/// Radius scale shared by every Mobo app.
class AppRadius {
  const AppRadius._();

  static const double xs = 4;
  static const double compact = 5;
  static const double segment = 6;
  static const double sm = 8;
  static const double numeric = 10;

  /// Default radius — cards, list tiles, buttons, text fields.
  static const double md = 12;
  static const double lg = 16;
  static const double badge = 18;
  static const double pill = 20;
  static const double sheetTall = 28;
}

/// Shadow tokens. Depth comes only from these, never from Material elevation.
class AppShadows {
  const AppShadows._();

  /// Standard "flat card" shadow — list items, list-style cards, form cards.
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x0D000000),
    offset: Offset(0, 6),
    blurRadius: 16,
    spreadRadius: 2,
  );

  /// Bigger surfaces like chart containers or dropdown panels.
  static BoxShadow panelShadow(bool isDark) => BoxShadow(
        color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.08),
        blurRadius: 12,
        offset: const Offset(0, 4),
      );

  /// Soft shadow for the list search bar and its filter button only.
  static const BoxShadow searchShadow = BoxShadow(
    color: Color(0x0A000000),
    offset: Offset(3, 11),
    blurRadius: 8.5,
    spreadRadius: -3,
  );

  static const List<BoxShadow> card = <BoxShadow>[cardShadow];
  static const List<BoxShadow> search = <BoxShadow>[searchShadow];
  static List<BoxShadow> panel(bool isDark) => <BoxShadow>[panelShadow(isDark)];
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
