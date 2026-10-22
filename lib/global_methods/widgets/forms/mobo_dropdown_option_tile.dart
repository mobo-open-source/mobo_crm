import 'package:flutter/material.dart';

import '../../../utils/app_theme.dart';

/// One option row inside a dropdown or search list. The selected option reads
/// in the brand colour with a faint primary wash and a trailing check.
class MoboDropdownOptionTile extends StatelessWidget {
  final String title;
  final String? subtitle;

  /// Leading avatar/thumbnail, e.g. a product image.
  final Widget? leading;

  /// Right-hand content that belongs to the option (price, stock, …); the
  /// selected check is shown after it.
  final Widget? trailing;

  final bool isSelected;
  final VoidCallback? onTap;

  const MoboDropdownOptionTile({
    super.key,
    required this.title,
    this.onTap,
    this.subtitle,
    this.leading,
    this.trailing,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final row = Container(
      color: isSelected
          ? AppTheme.primaryColor.withValues(alpha: 0.06)
          : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 12)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.valueColor(isDark),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.secondaryLabelColor(isDark),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
          if (isSelected) ...[
            const SizedBox(width: 8),
            const Icon(Icons.check, size: 18, color: AppTheme.primaryColor),
          ],
        ],
      ),
    );

    return onTap == null ? row : InkWell(onTap: onTap, child: row);
  }
}
