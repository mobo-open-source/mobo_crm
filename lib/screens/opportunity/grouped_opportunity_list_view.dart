import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/widgets/group_by_dropdown.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:mobo_crm/screens/opportunity/opportunity_views.dart';
import 'package:mobo_crm/screens/lead/new_lead_form.dart';
import 'package:mobo_crm/utils/globals.dart';
import 'package:provider/provider.dart';

import '../../initilisation.dart';
import '../../utils/app_theme.dart';

/// A widget that displays opportunities grouped by a selected criteria.
///
/// This widget listens to [OpportunityDataProvider] using [Consumer] and
/// dynamically renders the opportunities either as a grouped list or a
/// flat list depending on the current `GroupByOption`.
///
/// Features:
/// - Supports pull-to-refresh via [onRefresh].
/// - Handles empty state with a placeholder message.
/// - Shows a loading indicator while fetching data.
/// - Displays grouped opportunities with expandable/collapsible headers.
/// - Calculates total revenue for each group.
/// - Formats revenue and probability visually.
///
/// Example usage:
/// ```dart
/// GroupedOpportunityListView(
///   isPipeline: true,
///   onRefresh: () async {
///     await provider.getOpportunities(
///       isPipeline: true,
///       pipelinefilters: true,
///       context: context,
///       isOpportunity: true,
///       isLead: false,
///     );
///   },
/// );
/// ```
class GroupedOpportunityListView extends StatefulWidget {
  final bool isPipeline;
  final Future<void> Function()? onRefresh;

  const GroupedOpportunityListView({
    super.key,
    this.isPipeline = true,
    this.onRefresh,
  });

  @override
  State<GroupedOpportunityListView> createState() =>
      _GroupedOpportunityListViewState();
}

class _GroupedOpportunityListViewState
    extends State<GroupedOpportunityListView> {
  /// Builds the top bar showing:
  /// - Active filters count
  /// - Current group-by selection
  /// - Loading indicator

  void _goToPreviousPage(
      OpportunityDataProvider provider, OdooClientManager odooInitProvider) {
    provider.goToPreviousPage(
      context: context,
      isOpportunity: true,
      isLead: false,
      searchText: provider.searchController.text,
    );
  }

  void _goToNextPage(
      OpportunityDataProvider provider, OdooClientManager odooInitProvider) {
    provider.goToNextPage(
      context: context,
      isOpportunity: true,
      isLead: false,
      searchText: provider.searchController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<OpportunityDataProvider, OdooClientManager>(
      builder: (context, provider, odooInitProvider, child) {
        if (provider.currentGroupBy == GroupByOption.none) {
          return OpportunityListView(
              isPipeline: widget.isPipeline, onRefresh: widget.onRefresh);
        }

        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }

        if (provider.groupedOpportunities.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No opportunities found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        final sortedGroupKeys = provider.getSortedGroupKeys();

        return RefreshIndicator(
          color: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          onRefresh: widget.onRefresh ??
              () async {
                await provider.getOpportunities(
                  isPipeline: widget.isPipeline,
                  pipelinefilters: true,
                  context: context,
                  isOpportunity: true,
                  isLead: false,
                );
              },
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  itemCount: sortedGroupKeys.length,
                  itemBuilder: (context, index) {
                    final groupKey = sortedGroupKeys[index];
                    final groupOpportunities =
                        provider.groupedOpportunities[groupKey]!;
                    final isExpanded =
                        provider.groupExpansionState[groupKey] ?? true;
                    final totalRevenue =
                        provider.getGroupTotalRevenue(groupOpportunities);

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
                              isQuotation: false,
                              isLead: false,
                              groupName: groupKey,
                              itemCount: groupOpportunities.length,
                              totalRevenue: totalRevenue > 0 ? totalRevenue : null,
                              currencySymbol: _getCurrencySymbol(
                                  provider, groupOpportunities),
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
                                  children: groupOpportunities
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final opportunityIndex = entry.key;
                                    final opportunity = entry.value;

                                    return Column(
                                      children: [
                                        OpportunityListItem(
                                          opportunity: opportunity,
                                          index: opportunityIndex,
                                          provider: provider,
                                          isGrouped: true,
                                        ),
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
          ),
        );
      },
    );
  }

  /// Returns the currency symbol for the group based on partner mapping.
  ///
  /// Defaults to `$` if no symbol is found.
  String? _getCurrencySymbol(OpportunityDataProvider provider,
      List<Map<dynamic, dynamic>> opportunities) {
    for (var opportunity in opportunities) {
      if (opportunity['partner_id'] != null &&
          opportunity['partner_id'] is List) {
        final partnerId = opportunity['partner_id'][0] as int;
        final symbol = provider.partnerSymbolMap[partnerId];
        if (symbol != null && symbol.isNotEmpty) {
          return symbol;
        }
      }
    }
    return '\$';
  }
}

/// A single opportunity item inside a grouped opportunity list.
///
/// Shows opportunity details including:
/// - Name, partner, salesperson
/// - Stage badge with color coding
/// - Probability indicator
/// - Expected revenue formatted with K/M suffix
///
/// Tapping the item navigates to [NewLeadForm] in edit mode.
class OpportunityListItem extends StatelessWidget {
  final Map<dynamic, dynamic> opportunity;
  final int index;
  final OpportunityDataProvider provider;
  final bool isGrouped;

  const OpportunityListItem({
    super.key,
    required this.opportunity,
    required this.index,
    required this.provider,
    this.isGrouped = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stageName =
        opportunity['stage_id'] != null && opportunity['stage_id'] is List
            ? opportunity['stage_id'][1]?.toString() ?? 'No Stage'
            : 'No Stage';

    final salesperson =
        opportunity['user_id'] != null && opportunity['user_id'] is List
            ? opportunity['user_id'][1]?.toString() ?? 'Unassigned'
            : 'Unassigned';

    final expectedRevenue = opportunity['expected_revenue'] ?? 0.0;
    final probability = opportunity['probability'] ?? 0.0;

    final partnerId =
        opportunity['partner_id'] != null && opportunity['partner_id'] is List
            ? opportunity['partner_id'][0] as int
            : null;

    final currencySymbol =
        partnerId != null ? provider.partnerSymbolMap[partnerId] ?? '\$' : '\$';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewLeadForm(
              lead: opportunity,
              isNew: false,
              type: 'opportunity',
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: isGrouped
            ? const EdgeInsets.only(bottom: 8)
            : const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            width: 0.5,
          ),
          boxShadow: isGrouped
              ? null
              : [
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opportunity['name']?.toString() ??
                              'Unnamed Opportunity',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : AppStyle.primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (opportunity['partner_id'] is List &&
                            opportunity['partner_id'].length > 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              opportunity['partner_id'][1],
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
                  _buildStageBadge(stageName, isDark),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      salesperson,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (probability > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color:
                            _getProbabilityColor(probability).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${probability.toInt()}%',
                        style: TextStyle(
                          color: _getProbabilityColor(probability),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Expected Revenue',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  Text(
                    expectedRevenue > 0
                        ? '$currencySymbol${_formatRevenue(expectedRevenue)}'
                        : '$currencySymbol 0.00',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? Colors.white60
                          : Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
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

  Widget _buildStageBadge(String stageName, bool isDark) {
    final stageColor = StatusColors.getStageColor(stageName);
    return StatusColors.buildStatusBadge(stageName, stageColor, isDark: isDark);
  }

  String _formatRevenue(double revenue) {
    if (revenue >= 1000000) {
      return '${(revenue / 1000000).toStringAsFixed(1)}M';
    } else if (revenue >= 1000) {
      return '${(revenue / 1000).toStringAsFixed(1)}K';
    } else {
      return revenue.toStringAsFixed(0);
    }
  }

  Color _getProbabilityColor(double probability) {
    if (probability >= 75) return const Color(0xFF00A63E);
    if (probability >= 50) return Colors.orange;
    if (probability >= 25) return Colors.red;
    return Colors.grey;
  }
}
