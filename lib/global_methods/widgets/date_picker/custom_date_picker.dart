import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:mobo_crm/utils/app_theme.dart';
import 'package:mobo_crm/utils/date_picker_utils.dart';
import 'package:mobo_crm/utils/snackbar.dart';

/// A customizable, gesture-activated date picker field with a calendar dialog.
///
/// Features:
///   - Tapping opens a modern calendar dialog (using `table_calendar`)
///   - Supports both raw 'yyyy-MM-dd' and formatted display ('MMM dd, yyyy')
///   - Editable / non-editable mode with warning message when disabled
///   - Optional suffix icon
///   - Fixed background and border styling matching app theme
///   - Callback `onDateChanged` returns raw 'yyyy-MM-dd' string
///
/// Typical use: form fields for deadlines, birth dates, activity dates, etc.
class CustomDatePickerField extends StatefulWidget {
  final void Function(String?) onDateChanged;
  final String hintText;
  final String? initialValue;
  final bool isEditable;
  final bool isSuffix;
  final IconData? suffixIcon;
  final bool isFormattable;
  final String message;
  final bool showMessage;

  /// Draws the red error border; the caller shows the message itself.
  final bool hasError;

  /// Shows a clear (x) once a date is picked and the field is editable;
  /// pressing it reports `null` through [onDateChanged].
  final bool allowClear;
  const CustomDatePickerField({
    super.key,
    required this.onDateChanged,
    required this.hintText,
    this.initialValue,
    this.showMessage = false,
    this.message = 'Please enable edit mode',
    this.isEditable = false,
    this.isSuffix = false,
    this.suffixIcon,
    this.isFormattable = false,
    this.hasError = false,
    this.allowClear = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomDatePickerFieldState createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  final TextEditingController _controller = TextEditingController();
  String? _selectedDate;

  @override
  void initState() {
    super.initState();
    _showValue(widget.initialValue);
  }

  /// Follows the parent's value when it changes after the first build — a
  /// form reset or defaults that arrive later. Without this the field kept
  /// showing the old date while the form's own value was empty, so saving
  /// failed with "date can't be empty" next to a filled-in date.
  @override
  void didUpdateWidget(CustomDatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _selectedDate) {
      _showValue(widget.initialValue);
    }
  }

  void _showValue(String? value) {
    _selectedDate = value;
    if (value == null || value.isEmpty) {
      _controller.clear();
      return;
    }
    final date = DateTime.tryParse(value);
    _controller.text = date != null && widget.isFormattable
        ? DateFormat('MMM dd, yyyy').format(date)
        : value;
  }

  void _clear() {
    setState(() => _showValue(null));
    widget.onDateChanged(null);
  }

  /// Shows the themed Material date picker (mobo/billing style).
  Future<void> _showCalendarDialog() async {
    DateTime initial = _selectedDate != null
        ? DateTime.tryParse(_selectedDate!) ?? DateTime.now()
        : DateTime.now();

    final selected = await DatePickerUtils.showStandardDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2001),
      lastDate: DateTime(2099),
    );

    if (selected != null) {
      final rawDate = DateFormat('yyyy-MM-dd').format(selected);
      final displayDate = widget.isFormattable
          ? DateFormat('MMM dd, yyyy').format(selected)
          : rawDate;

      setState(() {
        _selectedDate = rawDate;
        _controller.text = displayDate;
        widget.onDateChanged(rawDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final showClear = widget.allowClear &&
        widget.isEditable &&
        _selectedDate != null &&
        _selectedDate!.isNotEmpty;
    final field = GestureDetector(
      // The child TextField is wrapped in IgnorePointer, which excludes it
      // (and, with the default `deferToChild` behavior, this GestureDetector
      // too) from hit-testing entirely. `opaque` makes this GestureDetector
      // hit-test on its own bounds instead, so taps actually reach onTap.
      behavior: HitTestBehavior.opaque,
      onTap: widget.isEditable
          ? _showCalendarDialog
          : () {
              if (widget.showMessage) {
                CustomSnackbar.showWarning(context, 'Please enable edit mode');

              } else {
                CustomSnackbar.showWarning(context, widget.message);

              }
              return;
            },
      child: SizedBox(
        width: double.infinity,
        child: IgnorePointer(
          child: TextField(
            style: AppTheme.fieldValueStyle(isDark),
            controller: _controller,
            enabled: false,
            decoration: AppTheme.fieldDecoration(
              isDark,
              hasError: widget.hasError,
              hintText: (_selectedDate == null || _selectedDate!.isEmpty)
                  ? widget.hintText
                  : null,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  HugeIcons.strokeRoundedCalendar03,
                  size: 22,
                  color: AppTheme.fieldIconColor(isDark),
                ),
              ),
              // The clear button is laid over the field below (the field
              // ignores pointers); this keeps the text clear of it.
              suffixIcon: showClear
                  ? const SizedBox(width: 40)
                  : widget.isSuffix && widget.suffixIcon != null
                      ? Icon(widget.suffixIcon,
                          color: AppTheme.fieldIconColor(isDark))
                      : null,
            ),
          ),
        ),
      ),
    );
    if (!showClear) return field;
    return Stack(
      children: [
        field,
        Positioned(
          right: 4,
          top: 0,
          bottom: 0,
          child: Center(
            child: IconButton(
              tooltip: 'Clear',
              onPressed: _clear,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              icon: Icon(
                Icons.clear_rounded,
                size: 18,
                color: AppTheme.fieldIconColor(isDark),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
