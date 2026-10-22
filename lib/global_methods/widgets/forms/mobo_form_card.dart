import 'package:flutter/material.dart';

import '../../../utils/app_theme.dart';

/// Titled section card that groups related form fields: title, hairline
/// divider, then the fields with 10px gaps between them.
class MoboFormCard extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  /// Optional widget shown at the right end of the title row.
  final Widget? trailing;

  /// Gap inserted between [children]; set to 0 when children space themselves.
  final double spacing;

  const MoboFormCard({
    super.key,
    this.title,
    required this.children,
    this.trailing,
    this.spacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0 && spacing > 0) spaced.add(SizedBox(height: spacing));
      spaced.add(children[i]);
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface(isDark),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppTheme.cardBorder(isDark), width: 0.5),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.valueColor(isDark),
                      ),
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
            Divider(
              height: 1,
              color: isDark ? Colors.grey[700] : Colors.grey.shade200,
              indent: 10,
              endIndent: 10,
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: spaced,
            ),
          ),
        ],
      ),
    );
  }
}
