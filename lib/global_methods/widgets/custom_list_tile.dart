import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/globals.dart';

/// A compact, tappable card displaying essential opportunity information.
///
/// Features:
///   - Opportunity name (bold title)
///   - Contact name & email
///   - Expected revenue with currency symbol (from session/provider)
///   - Stage badge with dynamic color (won/green, proposition/blue, lost/red, etc.)
///   - Selected state visual feedback (blue border & background tint)
///   - Tap gesture support (usually opens detail/form view)
///
/// Designed for use in opportunity lists, Kanban cards, or selection dialogs.
class CustomOpportunityTile extends StatelessWidget {
  final String opportunity;
  final String contactName;
  final String email;
  final String expectedRevenue;
  final String stage;

  final bool isSelected;
  final void Function()? onTap;

  const CustomOpportunityTile({
    super.key,
    required this.onTap,
    required this.opportunity,
    required this.contactName,
    required this.email,
    required this.expectedRevenue,
    required this.stage,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                isSelected ? Colors.blue.shade50 : Colors.white,
                Colors.grey.shade50,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opportunity,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contactName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Consumer<OdooClientManager>(
                        builder: (context, provider, child) {
                      return Text(
                        "${provider.currencySymbol} $expectedRevenue",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF00A63E),
                        ),
                      );
                    }),
                    const SizedBox(height: 4),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStageColor(stage).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStageColor(stage),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        stage,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getStageColor(stage),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns color based on stage name (won → green, proposition → blue, lost → red, etc.)
  Color _getStageColor(String stage) {
    switch (stage.toLowerCase()) {
      case 'proposition':
        return Colors.blueAccent;
      case 'won':
      case 'qualified':
        return const Color(0xFF00A63E);
      case 'lost':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

/// A simple key-value row used in detail views/forms to display label + value.
class CustomRow extends StatelessWidget {
  final String label;
  final String value;

  const CustomRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Text(
                  value == 'false' ? 'None' : value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          if (value != 'false')
            label == 'Address:'
                ? Container(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: TextField(
                        controller: TextEditingController(text: value),
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'Enter address',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  )
                : Container(),
        ],
      ),
    );
  }
}

/// A row widget for displaying tag-related labels (currently placeholder).
///
/// Currently only shows the label; can be extended to display actual tags.
class CustomTagRow extends StatelessWidget {
  final String label;
  final String value;

  const CustomTagRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Consumer<LeadFormProvider>(builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        );
      }),
    );
  }
}

/// A tappable list tile displaying essential lead information with dynamic stage badge.
///
/// Features:
///   - Lead name (highlighted with primary color)
///   - Contact name (if available)
///   - Email address with icon
///   - Creation date
///   - Colored stage badge (won/green, new/orange, proposition/purple, etc.)
///   - Dark mode support
///   - Subtle shadow & rounded card style
///
/// Designed for lead list views, search results, or filtered lists.
class LeadListTile extends StatelessWidget {
  final Map lead;
  final bool isAdmin;
  final VoidCallback onTap;
  final void Function()? onDelete;

  const LeadListTile({
    super.key,
    required this.lead,
    this.isAdmin = false,
    required this.onTap,
    this.onDelete,
  });

  /// Returns color based on stage name (won → green, new → orange, etc.)
  Color getStateColor() {
    final stageIdField = lead['stage_id'];
    final stageName = (stageIdField is List && stageIdField.length > 1)
        ? stageIdField[1]?.toLowerCase()
        : null;
    final stageId = (stageIdField is List && stageIdField.isNotEmpty)
        ? stageIdField[0]?.toString()
        : null;

    switch (stageName) {
      case 'won':
        return const Color(0xFF00A63E);
      case 'new':
        return Colors.orange;
      case 'proposition':
        return const Color(0xff7c2ed2);
      case 'qualified':
        return const Color(0xFF00A63E);
      default:
        if (stageId != null) {
          final hash = stageId.hashCode;
          final hue = (hash % 360).toDouble();
          return HSLColor.fromAHSL(1.0, hue, 0.9, 0.5).toColor();
        }
        return Colors.grey;
    }
  }

  /// Returns human-readable stage name with fallback
  String getStateValue() {
    final stageName = lead['stage_id']?[1];
    switch (stageName?.toLowerCase()) {
      case 'won':
        return 'Won';
      case 'new':
        return 'New';
      case 'proposition':
        return 'Proposition';
      case 'qualified':
        return 'Qualified';
      default:
        return stageName ?? 'No Stage';
    }
  }

  LinearGradient getStateGradient() {
    final baseColor = getStateColor();
    return LinearGradient(
      colors: [baseColor, baseColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[850]! : Colors.grey[200]!,
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.05),
              offset: const Offset(0, 6),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 14, top: 14, bottom: 14, right: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      lead['name'] ?? 'Unnamed Lead',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppStyle.primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildStatusBadge(isDark),
                        if (isAdmin) ...[
                          SizedBox(width: 4),
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: PopupMenuButton<String>(
                              offset: const Offset(0, 36),
                              color: Colors.white,
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.more_vert, size: 20),
                              onSelected: (value) {
                                if (value == 'delete') {
                                  onDelete?.call();
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        HugeIcons.strokeRoundedDelete02,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (lead['contact_name'] != null && lead['contact_name'] != '')
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    lead['contact_name'],
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (lead['email_from'] != null &&
                  lead['email_from'].toString().trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          lead['email_from'],
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Created Date',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  Text(
                    lead['create_date']?.toString().split(' ')[0] ?? '--/--/--',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white60 : Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds colored badge showing current stage name
  Widget _buildStatusBadge(bool isDark) {
    final statusColor = getStateColor();
    final textColor = isDark ? Colors.white : statusColor;
    final backgroundColor =
        isDark ? Colors.white.withOpacity(0.15) : statusColor.withOpacity(0.10);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        getStateValue(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: isDark ? FontWeight.bold : FontWeight.w600,
          color: textColor,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
