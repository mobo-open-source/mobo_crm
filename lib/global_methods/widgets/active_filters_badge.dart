import 'package:flutter/material.dart';

import '../../utils/app_theme.dart';

/// "N Active" pill on the filter bar above a list/kanban view: solid black
/// with white text, matching the group-by chip that often sits beside it.
class ActiveFiltersBadge extends StatelessWidget {
  final int count;

  const ActiveFiltersBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        // Keeps the black pill visible against the dark scaffold.
        border: isDark ? Border.all(color: Colors.grey[700]!) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 5),
          const Text(
            'Active',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
