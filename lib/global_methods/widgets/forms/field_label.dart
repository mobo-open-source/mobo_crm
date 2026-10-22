import 'package:flutter/material.dart';

import '../../../utils/app_theme.dart';

/// The required-field marker: a red bold `" *"` appended to the label. Only
/// colour and weight are set so it inherits the label's size and family.
const TextSpan kRequiredMarker = TextSpan(
  text: ' *',
  style: TextStyle(
    color: StatusColors.statusRed,
    fontWeight: FontWeight.bold,
  ),
);

/// Builds a field label, appending [kRequiredMarker] when [isRequired].
Text buildFieldLabel(
  String text, {
  required TextStyle style,
  bool isRequired = false,
}) {
  if (!isRequired) return Text(text, style: style);
  return Text.rich(
    TextSpan(
      text: text,
      style: style,
      children: const <InlineSpan>[kRequiredMarker],
    ),
  );
}

/// The grey 14/w500 label that sits above every form field.
class FieldLabel extends StatelessWidget {
  final String text;
  final bool isRequired;

  const FieldLabel(this.text, {super.key, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return buildFieldLabel(
      text,
      isRequired: isRequired,
      style: AppTheme.fieldLabelStyle(isDark),
    );
  }
}

/// A [FieldLabel] above [child], separated by the standard 10px gap.
class LabeledField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final Widget child;

  const LabeledField({
    super.key,
    required this.label,
    required this.child,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label, isRequired: isRequired),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}
