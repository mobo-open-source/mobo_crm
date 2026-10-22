import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utils/app_theme.dart';

/// Full-width submit button that closes every create/edit form.
///
/// The disabled foreground is decided together with the disabled background
/// so the label stays readable on the grey fill.
class MoboSubmitButton extends StatelessWidget {
  final String label;
  final String loadingLabel;

  /// A request is in flight: the button stays brand-coloured and ignores taps.
  final bool isLoading;

  /// Whether the form is complete. Drives the look only; [onPressed] still
  /// fires so the form can say which field is missing. Pass null [onPressed]
  /// to make the button fully inert.
  final bool isReady;
  final VoidCallback? onPressed;
  final IconData? icon;

  const MoboSubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loadingLabel = 'Saving...',
    this.isReady = true,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFilled = isLoading || isReady;

    final background = isFilled
        ? AppTheme.primaryColor
        : (isDark ? Colors.grey[700]! : Colors.grey[300]!);
    final foreground = isFilled
        ? Colors.white
        : (isDark ? Colors.grey[400]! : Colors.grey[500]!);

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                LoadingAnimationWidget.staggeredDotsWave(
                    color: foreground, size: 20)
              else
                Icon(icon ?? HugeIcons.strokeRoundedFileAdd,
                    color: foreground, size: 22),
              const SizedBox(width: 10),
              Text(
                isLoading ? loadingLabel : label,
                style: TextStyle(
                  fontSize: 16,
                  color: foreground,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
