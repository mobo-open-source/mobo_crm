import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../utils/snackbar.dart';

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

    final inputDecoration = InputDecoration(
      prefixIcon: widget.isPrefix ? widget.prefixicon : null,
      suffixIcon: suffix,
      hintStyle: TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFC03355), width: 1.5),
      ),
      hintText: widget.hintText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.transparent, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      errorStyle: const TextStyle(height: 0, fontSize: 0),
    );

    final textField = TextFormField(
      cursorColor: const Color(0xFFC03355),
      onTap: () {
        if (!widget.dontShow && widget.showMessage) {
          CustomSnackbar.showWarning(context, widget.message);
        }
        widget.onTap?.call();
      },
      onChanged: widget.onChanged,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      readOnly: !widget.isEditable,
      keyboardType:
          widget.isExpanable ? TextInputType.multiline : widget.inputType,
      minLines: widget.isExpanable ? 1 : null,
      maxLines: widget.isExpanable ? null : 1,
      controller: widget.controller,
      style: const TextStyle(
          color: Colors.black87, fontWeight: FontWeight.w600),
      decoration: inputDecoration,
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
        Text.rich(
          TextSpan(
            text: widget.title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight:
                  widget.isBold ? FontWeight.bold : FontWeight.normal,
            ),
            children: widget.isRequired
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFFF2F4F6),
            border: Border.all(
              color: _errorText != null ? Colors.red : Colors.transparent,
              width: 1,
            ),
          ),
          child: textField,
        ),
        if (errorRow != null) errorRow,
        SizedBox(height: widget.bottomPadding),
      ],
    );
  }
}
