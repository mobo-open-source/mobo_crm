import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';
import 'package:mobo_crm/screens/lead/new_lead_form.dart';
import 'package:mobo_crm/screens/lead/providers/lead_data_provider.dart';
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';
import 'package:provider/provider.dart';
import '../../global_methods/widgets/group_by_dropdown.dart';
import '../../initilisation.dart';
import '../../utils/globals.dart';

/// Displays a grouped list view of Leads with expandable sections.
///
/// Features:
/// - Groups leads based on the current group-by option selected
/// - Shows expandable/collapsible group headers with total count & revenue
/// - Supports pull-to-refresh when [onRefresh] is provided
/// - Handles loading and empty states
/// - Navigates to the Lead form on item tap
///
/// Uses [LeadDataProvider] for:
/// - Grouped leads data
/// - Loading state
/// - Group expansion state
///
/// Params:
/// - [onRefresh]: Optional callback to refresh the lead list (pull-to-refresh)
class GroupedLeadListView extends StatefulWidget {
  final Future<void> Function()? onRefresh;

  const GroupedLeadListView({super.key, this.onRefresh});

  @override
  State<GroupedLeadListView> createState() => _GroupedLeadListViewState();
}

class _GroupedLeadListViewState extends State<GroupedLeadListView> {
  /// Builds the top bar showing:
  /// - Active filters count
  /// - Current group-by selection
  /// - Loading indicator
  Widget _buildTopPaginationBar(
      LeadDataProvider provider, OdooClientManager odooInitProvider) {
    if (provider.isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Loading...',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                final groupBy = provider.currentGroupBy;
                final filters = provider.selectedFilters;

                final hasActiveFilters = filters.isNotEmpty;
                final hasGrouping = groupBy != GroupByOption.none;

                if (!hasActiveFilters && !hasGrouping) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 6),
                    child: Text(
                      "No filters applied",
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                List<Widget> chips = [];

                if (hasActiveFilters) {
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;
                  chips.add(
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: isDark ? Colors.grey[400]! : Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            filters.length.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (hasGrouping) {
                  String groupName = groupBy.toString().split('.').last;
                  groupName =
                      groupName[0].toUpperCase() + groupName.substring(1);

                  final displayNames = {
                    'stage': 'Stage',
                    'salesperson': 'Salesperson',
                    'team': 'Team',
                    'priority': 'Priority',
                    'partner': 'Customer',
                    'country': 'Country',
                    'createDate': 'Creation Date',
                    'expectedRevenue': 'Expected Revenue',
                    'probability': 'Probability',
                  };

                  groupName =
                      displayNames[groupName.toLowerCase()] ?? groupName;

                  chips.add(
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedLayer,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 50),
                            child: Text(
                              groupName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: chips
                        .expand((c) => [c, const SizedBox(width: 8)])
                        .toList()
                      ..removeLast(),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Text(
                  "${provider.startRecord}-${provider.endRecord} / ${provider.groupedLeads.keys.length}",
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
              InkWell(
                onTap: provider.hasPreviousPage
                    ? () => _goToPreviousPage(provider, odooInitProvider)
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  child: Icon(
                    HugeIcons.strokeRoundedArrowLeft01,
                    size: 20,
                    color: provider.hasPreviousPage
                        ? Colors.grey[700]
                        : Colors.grey[400],
                  ),
                ),
              ),
              InkWell(
                onTap: provider.hasNextPage
                    ? () => _goToNextPage(provider, odooInitProvider)
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  child: Icon(
                    HugeIcons.strokeRoundedArrowRight01,
                    size: 20,
                    color: provider.hasNextPage
                        ? Colors.grey[700]
                        : Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Navigates to the previous page of leads.
  void _goToPreviousPage(
      LeadDataProvider provider, OdooClientManager odooInitProvider) {
    provider.goToPreviousPage(
      context: context,
      searchText: provider.searchController.text,
    );
  }

  /// Navigates to the next page of leads.
  void _goToNextPage(
      LeadDataProvider provider, OdooClientManager odooInitProvider) {
    provider.goToNextPage(
      context: context,
      searchText: provider.searchController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LeadDataProvider, OdooClientManager>(
      builder: (context, provider, odooInitProvider, child) {
        Widget content;

        if (provider.isLoading) {
          content = const Center(child: CircularProgressIndicator());
        } else if (provider.groupedLeads.isEmpty) {
          content = SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: const Center(
                child: Text(
                  'No leads found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          );
        } else {
          content = Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  itemCount: provider.groupedLeads.length,
                  itemBuilder: (context, index) {
                    final groupKey =
                        provider.groupedLeads.keys.elementAt(index);
                    final groupLeads = provider.groupedLeads[groupKey]!;
                    final isExpanded =
                        provider.groupExpansionState[groupKey] ?? true;
                    final groupRevenue = provider.getGroupRevenue(groupLeads);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 16,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                            color: Colors.black.withOpacity(0.08),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          children: [
                            GroupByHeader(
                              isLead: true,
                              isQuotation: false,
                              groupName: groupKey,
                              itemCount: groupLeads.length,
                              totalRevenue: groupRevenue,
                              currencySymbol: '\$',
                              isExpanded: isExpanded,
                              onToggle: () =>
                                  provider.toggleGroupExpansion(groupKey),
                              groupByOption: provider.currentGroupBy,
                              wrapInContainer: false,
                            ),
                            if (isExpanded) ...[
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.grey[200],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: groupLeads.asMap().entries
                                      .map((entry) {
                                    final leadIndex = entry.key;
                                    final lead = entry.value;

                                    return Column(
                                      children: [
                                        _buildLeadTile(context, lead),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        if (widget.onRefresh != null) {
          return RefreshIndicator(
            color: Theme.of(context).primaryColor,
            backgroundColor: Colors.white,
            onRefresh: widget.onRefresh!,
            child: content,
          );
        }

        return content;
      },
    );
  }

  /// Builds a single lead list tile inside a grouped section.
  ///
  /// Displays:
  /// - Priority avatar with lead initials
  /// - Lead name
  /// - Contact details (partner, email, phone)
  /// - Stage badge
  /// - Expected revenue (if available)
  /// - Probability and created date
  ///
  /// On tap:
  /// - Clears existing form state
  /// - Navigates to the Lead edit screen
  Widget _buildLeadTile(BuildContext context, Map<dynamic, dynamic> lead) {
    return InkWell(
      onTap: () {
        final leadFormProvider =
            Provider.of<LeadFormProvider>(context, listen: false);
        leadFormProvider.clearAll('lead');
        Navigator.push(
          context,
          SlidingPageTransitionRL(
            page: NewLeadForm(
              lead: lead,
              type: 'lead',
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[200]!, width: 0.5),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 14, top: 14, bottom: 14, right: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lead['name']?.toString() ?? 'Unnamed Lead',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppStyle.primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (lead['partner_name'] != null) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              lead['partner_name'],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        if (lead['email_from'] != null) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    lead['email_from'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (lead['phone'] != null) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    lead['phone'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (lead['expected_revenue'] != null &&
                            lead['expected_revenue'] > 0) ...[
                          const SizedBox(height: 4),
                          Text(
                            '\$${NumberFormat('#,##0.00').format(lead['expected_revenue'])}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                        if (lead['probability'] != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Probability',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                '${lead['probability']}%',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (lead['create_date'] != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Created Date',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                _formatDate(lead['create_date']),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns initials for the lead name to display inside the avatar.
  ///
  /// Examples:
  /// - "John Doe" → "JD"
  /// - "Acme" → "A"
  /// - Empty name → "?"
  String _getLeadInitials(Map<dynamic, dynamic> lead) {
    final name = lead['name']?.toString() ?? '';
    if (name.isEmpty) return '?';

    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  /// Maps lead priority to a color used for the avatar background.
  ///
  /// Priority mapping:
  /// - 0 → Grey (low)
  /// - 1 → Blue (normal)
  /// - 2 → Orange (high)
  /// - 3 → Red (urgent)
  Color _getPriorityColor(dynamic priority) {
    switch (priority?.toString()) {
      case '0':
        return Colors.grey;
      case '1':
        return Colors.blue;
      case '2':
        return Colors.orange;
      case '3':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Formats a backend date string into a readable UI format.
  ///
  /// Converts:
  /// - ISO string → `MMM dd, yyyy`
  ///
  /// Returns empty string if parsing fails or value is null.
  String _formatDate(dynamic dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString.toString());
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return '';
    }
  }
}
