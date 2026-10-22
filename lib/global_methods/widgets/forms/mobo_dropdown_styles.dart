import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../utils/app_theme.dart';

/// Shared `dropdown_search` styling so every searchable dropdown looks like
/// the plain form text fields next to it.
class MoboDropdownStyles {
  const MoboDropdownStyles._();

  static DropDownDecoratorProps decorator(bool isDark, {String? hintText}) =>
      DropDownDecoratorProps(
        dropdownSearchDecoration:
            AppTheme.fieldDecoration(isDark, hintText: hintText),
      );

  static DropdownButtonProps button(bool isDark, {bool enabled = true}) =>
      DropdownButtonProps(
        icon: Icon(
          HugeIcons.strokeRoundedArrowDown01,
          size: 22,
          color: enabled
              ? AppTheme.fieldIconColor(isDark)
              : AppTheme.hintColor(isDark),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      );

  /// The (x) that empties a picked value; only shown once something is picked.
  static ClearButtonProps clearButton(bool isDark, {bool visible = true}) =>
      ClearButtonProps(
        isVisible: visible,
        tooltip: 'Clear',
        icon: Icon(
          Icons.clear_rounded,
          size: 18,
          color: AppTheme.fieldIconColor(isDark),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      );

  static MenuProps menu(bool isDark) => MenuProps(
        backgroundColor: AppTheme.surface(isDark),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      );

  static const BoxConstraints popupConstraints =
      BoxConstraints(maxHeight: 320);

  static InputDecoration searchDecoration(bool isDark) => InputDecoration(
        isDense: true,
        hintText: 'Search...',
        hintStyle: TextStyle(fontSize: 14, color: AppTheme.hintColor(isDark)),
        filled: true,
        fillColor: isDark ? Colors.grey[850] : AppTheme.popupSearchFillLight,
        prefixIcon: const Icon(Icons.search, size: 20),
        prefixIconColor: Colors.grey,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.numeric),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.numeric),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide:
              const BorderSide(color: AppTheme.primaryColor, width: 1.5),
        ),
      );

  static TextFieldProps searchField(bool isDark,
          {TextEditingController? controller}) =>
      TextFieldProps(
        controller: controller,
        cursorColor: AppTheme.primaryColor,
        style: TextStyle(fontSize: 14, color: AppTheme.valueColor(isDark)),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        decoration: searchDecoration(isDark),
      );

  /// Text shown in the closed field before a value is picked.
  static Widget hint(String text, bool isDark) =>
      Text(text, style: AppTheme.fieldHintStyle(isDark));

  /// Text shown in the closed field once a value is picked.
  static Widget value(String text, bool isDark, {bool enabled = true}) => Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: AppTheme.fieldValueStyle(isDark).copyWith(
          color: enabled ? null : AppTheme.hintColor(isDark),
        ),
      );

  static Widget loading() => const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(
              strokeWidth: 2, color: AppTheme.primaryColor),
        ),
      );

  static Widget empty(bool isDark, [String text = 'No data found']) => Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            text,
            style: TextStyle(
                fontSize: 14, color: AppTheme.secondaryLabelColor(isDark)),
          ),
        ),
      );
}
