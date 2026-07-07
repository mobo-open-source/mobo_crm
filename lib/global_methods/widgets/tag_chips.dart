import 'package:flutter/material.dart';
import 'package:mobo_crm/models/models.dart';

/// A horizontal wrap of tag chips using the app's primary brand color.
///
/// Typical use: inside Kanban tiles, list items, detail views, or filter chips
/// to visually represent lead/opportunity tags/categories.
class TagChips extends StatelessWidget {
  final List<LeadTag> tags;
  final List<dynamic> tagIds;

  const TagChips({super.key, required this.tags, required this.tagIds});

  static const Color _tagBg = Color(0xFFFCE7EE);
  static const Color _tagColor = Color(0xFFC03355);

  @override
  Widget build(BuildContext context) {
    List<LeadTag> tagDetails =
        tags.where((tag) => tagIds.contains(tag.id)).toList();

    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: tagDetails.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _tagBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _tagColor.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: Text(
            tag.name,
            style: const TextStyle(
              fontSize: 12,
              color: _tagColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}
