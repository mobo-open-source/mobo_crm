import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../utils/app_theme.dart';
import '../../../utils/snackbar.dart';
import '../forms/field_label.dart';

/// The kind of quick action a field can trigger (call, email, open website, or map).
enum FieldActionType { phone, email, website, location }

/// A labelled, editable text field with an optional prefix/suffix and a quick
/// action (call, email, open website, or map) selected via [FieldActionType].
class CustomEditingFields extends StatefulWidget {
  final String title;
  final double? lat;
  final double? long;
  final TextEditingController controller;
  final bool isEditable;
  final String? Function(String?)? validator;
  final String hintText;
  final TextInputType inputType;
  final bool textfieldOnly;
  final bool isPrefix;
  final void Function(String)? onChanged;
  final Widget? prefixicon;
  final bool isSuffix;
  final Widget? suffixicon;
  final double bottomPadding;
  final bool isBold;
  final bool dontShow;
  final bool isExpanable;
  final String message;
  final bool showMessage;
  final FieldActionType? actionType;
  final bool isRequired;
  final VoidCallback? onTap;

  /// When [validator] runs on its own; by default only when the enclosing
  /// `Form` is validated.
  final AutovalidateMode? autovalidateMode;

  const CustomEditingFields({
    super.key,
    this.lat = 0,
    this.long = 0,
    this.isExpanable = false,
    this.onChanged,
    this.dontShow = false,
    this.validator,
    required this.title,
    this.bottomPadding = 20,
    required this.controller,
    required this.hintText,
    this.prefixicon,
    this.showMessage = false,
    this.message = 'Please enable edit mode',
    this.actionType,
    required this.isEditable,
    this.textfieldOnly = false,
    this.isPrefix = false,
    this.isSuffix = false,
    this.isBold = false,
    this.suffixicon,
    this.isRequired = false,
    this.onTap,
    this.autovalidateMode,
    this.inputType = TextInputType.name,
  });

  @override
  State<CustomEditingFields> createState() => _CustomEditingFieldsState();
}

class _CustomEditingFieldsState extends State<CustomEditingFields> {
  String? _errorText;

  void _handleAction(BuildContext context) async {
    final value = widget.controller.text.trim();
    if (value.isEmpty) {
      CustomSnackbar.showError(context, 'Field is empty');
      return;
    }
    switch (widget.actionType) {
      case FieldActionType.phone:
        await launchUrlString('tel:$value');
        break;
      case FieldActionType.email:
        final emailUrl = Uri(
          scheme: 'mailto',
          path: value,
          query: Uri.encodeFull(
              'subject=Following Up on Our Last Conversation&body=Hi,\n\nI hope you\'re doing well. I just wanted to follow up regarding our recent discussion. Please let me know if you have any questions or need further assistance.\n\nLooking forward to your response.\n\nBest regards,\n[Your Name]'),
        ).toString();
        await launchUrlString(emailUrl);
        break;
      case FieldActionType.website:
        final websiteUrl =
            value.startsWith("http") ? value : "https://$value";
        await launchUrlString(websiteUrl);
        break;
      case FieldActionType.location:
        if (widget.lat != null &&
            widget.long != null &&
            widget.lat != 0 &&
            widget.long != 0) {
          await launchUrlString(
              'https://www.google.com/maps/search/?api=1&query=${widget.lat},${widget.long}');
        } else {
          CustomSnackbar.showError(context, 'Location coordinates not available.');
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Icon? actionIcon;
    if (widget.actionType != null) {
      switch (widget.actionType!) {
        case FieldActionType.phone:
          actionIcon = Icon(HugeIcons.strokeRoundedCall,
              color: Theme.of(context).primaryColor);
          break;
        case FieldActionType.email:
          actionIcon = Icon(HugeIcons.strokeRoundedMail02,
              color: Theme.of(context).primaryColor);
          break;
        case FieldActionType.website:
          actionIcon = Icon(HugeIcons.strokeRoundedGlobe02,
              color: Theme.of(context).primaryColor);
          break;
        case FieldActionType.location:
          actionIcon = Icon(HugeIcons.strokeRoundedLocation05,
              color: Theme.of(context).primaryColor);
          break;
      }
    }

    final Widget? suffix = widget.actionType != null
        ? IconButton(
            icon: actionIcon!,
            onPressed: () => _handleAction(context),
          )
        : (widget.isSuffix ? widget.suffixicon : null);

    final inputDecoration = AppTheme.fieldDecoration(
      isDark,
      hintText: widget.hintText,
      prefixIcon: widget.isPrefix ? widget.prefixicon : null,
      suffixIcon: suffix,
      hasError: _errorText != null,
    );

    final textField = TextFormField(
      cursorColor: AppTheme.primaryColor,
      onTap: () {
        if (!widget.dontShow && widget.showMessage) {
          CustomSnackbar.showWarning(context, widget.message);
        }
        widget.onTap?.call();
      },
      onChanged: widget.onChanged,
      // Unfocus the field itself, not the page's FocusScope: unfocusing the
      // scope leaves this field as the page's remembered focus, so closing
      // any dropdown, date picker or dialog put the cursor back in it.
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      readOnly: !widget.isEditable,
      keyboardType:
          widget.isExpanable ? TextInputType.multiline : widget.inputType,
      minLines: widget.isExpanable ? 1 : null,
      maxLines: widget.isExpanable ? null : 1,
      controller: widget.controller,
      style: AppTheme.fieldValueStyle(isDark),
      decoration: inputDecoration,
      autovalidateMode: widget.autovalidateMode,
      validator: (value) {
        final error = widget.validator?.call(value);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _errorText != error) {
            setState(() => _errorText = error);
          }
        });
        return error;
      },
    );

    final errorRow = _errorText != null
        ? Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              _errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          )
        : null;

    if (widget.textfieldOnly && !widget.isExpanable) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textField,
          if (errorRow != null) errorRow,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(widget.title, isRequired: widget.isRequired),
        const SizedBox(height: 10),
        textField,
        if (errorRow != null) errorRow,
        SizedBox(height: widget.bottomPadding),
      ],
    );
  }
}
