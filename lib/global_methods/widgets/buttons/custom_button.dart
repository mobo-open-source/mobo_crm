import 'package:flutter/material.dart';
import 'package:mobo_crm/utils/globals.dart';

/// A customizable, elevated button with optional loading state.
///
/// Features:
///   - Solid background (default) or outlined style (when `isBorder: true`)
///   - Built-in loading indicator (circular spinner) when `isLoading: true`
///   - Fixed accent color (#C03355) for consistency across the app
///   - Shadow and elevation for modern card-like appearance
///   - Disabled state when loading
///
/// Usage:
/// ```dart
/// CustomButton(
///   text: 'Save Changes',
///   onPressed: _save,
///   isLoading: _isSaving,
///   isBorder: true,
///   fontSize: 15,
/// )
/// ```
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double fontSize;
  final double borderRadius;
  final double height;
  final bool isBackground;
  final bool isBorder;
  final bool isLoading;

  const CustomButton({
    super.key,
    this.isBackground = true,
    this.isBorder = false,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blueAccent,
    this.fontSize = 16,
    this.borderRadius = 4.0,
    this.height = 48,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: AppStyle.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: TextStyle(
                color: isBorder ? Theme.of(context).primaryColor : Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}

/// Compact, rounded action chip/button with icon and label.
///
/// Features:
///   - Minimal padding and rounded shape
///   - Customizable background, icon, and text colors
///   - InkWell splash/highlight effect on tap
///   - Ideal for filters, tags, quick actions, or secondary CTAs
///
/// Usage:
/// ```dart
/// ActionChipButton(
///   label: 'Add Tag',
///   icon: Icons.add_circle_outline,
///   onTap: _addTag,
///   backgroundColor: Colors.blue.shade50,
///   iconColor: Colors.blue,
/// )
/// ```
class ActionChipButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;

  const ActionChipButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Colors.grey.shade200;
    final iconClr = iconColor ?? Colors.black54;
    final txtClr = textColor ?? Colors.black87;

    return InkWell(
      splashColor: Colors.black.withValues(alpha: 0.4),
      highlightColor: Colors.black.withValues(alpha: 0.4),
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: txtClr,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              icon,
              size: 18,
              color: iconClr,
            ),
          ],
        ),
      ),
    );
  }
}
