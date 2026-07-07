import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    _selectedDate = widget.initialValue;

    if (_selectedDate != null) {
      final date = DateTime.tryParse(_selectedDate!);
      if (date != null) {
        _controller.text = widget.isFormattable
            ? DateFormat('MMM dd, yyyy').format(date)
            : _selectedDate!;
      } else {
        _controller.text = _selectedDate!;
      }
    }
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
    return GestureDetector(
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
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFF2F4F6),
          border: Border.all(color: Colors.transparent, width: 1),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: IgnorePointer(
              child: TextField(
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                controller: _controller,
                enabled: false,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  hintText: (_selectedDate == null || _selectedDate!.isEmpty)
                      ? widget.hintText
                      : null,
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  suffixIcon: widget.isSuffix && widget.suffixIcon != null
                      ? Icon(widget.suffixIcon, color: Colors.grey)
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
