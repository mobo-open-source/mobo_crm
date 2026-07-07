import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:mobo_crm/global_methods/widgets/group_by_dropdown.dart';
import 'package:mobo_crm/global_methods/widgets/shimmer/custom_shimmer.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_view_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_form_provider.dart';
import 'package:mobo_crm/screens/quotation/new_quotation_form.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:provider/provider.dart';

import '../../utils/globals.dart';
import '../../utils/app_theme.dart';

/// Displays a grouped list of quotations with pagination, filters, and expandable group headers.
///
/// Features:
/// - Shimmer loading while data is fetching
/// - Pagination controls for large groups
/// - Filter chips for group by and custom filters
/// - Expand/collapse per group
/// - Tappable quotation cards opening detailed view
class GroupedQuotationListView extends StatefulWidget {
  final Future<void> Function()? onRefresh;

  const GroupedQuotationListView({super.key, this.onRefresh});

  @override
  State<GroupedQuotationListView> createState() =>
      _GroupedQuotationListViewState();
}

class _GroupedQuotationListViewState extends State<GroupedQuotationListView> {

  List<Map<String, dynamic>> items = [
    {'icon': Icons.menu, 'label': 'List', 'assetUrl': 'assets/list.svg'},
    {
      'icon': Icons.view_kanban,
      'label': 'Kanban',
    },
    {
      'icon': Icons.calendar_month,
      'label': 'Calendar',
    },
    {
      'icon': Icons.bar_chart,
      'label': 'Graph',
    },
    {
      'icon': Icons.access_time,
      'label': 'Activity',
    },
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer2<QuotationViewProvider, OdooClientManager>(
      builder: (context, provider, odooInitProvider, child) {
        Widget content;

        if (provider.isLoading) {
          content = _buildShimmerList();
        } else if (provider.groupedQuotations.isEmpty) {
          content = SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: const Center(
                child: Text(
                  'No quotations found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          );
        } else {
          final allGroupKeys = provider.groupedQuotations.keys.toList();
          final startIndex = provider.currentPage * provider.limit;
          final endIndex =
              (startIndex + provider.limit).clamp(0, allGroupKeys.length);
          final paginatedGroupKeys = allGroupKeys.sublist(
            startIndex.clamp(0, allGroupKeys.length),
            endIndex,
          );

          content = Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  itemCount: paginatedGroupKeys.length,
                  itemBuilder: (context, index) {
                    final groupKey = paginatedGroupKeys[index];
                    final groupQuotations =
                        provider.groupedQuotations[groupKey]!;
                    final isExpanded =
                        provider.groupExpansionState[groupKey] ?? true;
                    final groupRevenue =
                        provider.getGroupRevenue(groupQuotations);

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
                              isLead: false,
                              isQuotation: true,
                              groupName: groupKey,
                              itemCount: groupQuotations.length,
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
                                  children: groupQuotations
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final quotationIndex = entry.key;
                                    final quotation = entry.value;
                                    return Column(
                                      children: [
                                        _buildQuotationCard(
                                            context, quotation, provider),
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

  /// Builds shimmer loading placeholders for quotations
  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemBuilder: (context, index) => const QuotationListTileShimmer(),
    );
  }

  /// Builds filter chips for active group by and custom filters
  Widget _buildActiveFiltersChips(QuotationViewProvider provider) {
    final hasGroupBy = provider.currentGroupBy != GroupByOption.none;
    final hasCustomFilters = provider.hasCustomFilters;

    if (!hasGroupBy && !hasCustomFilters) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          if (hasGroupBy)
            _buildFilterChip(
              label:
                  'Group by: ${_getGroupByDisplayName(provider.currentGroupBy)}',
              icon: Icons.group_work,
              color: Colors.blue,
              onClose: () {
                provider.setGroupBy(GroupByOption.none);
                final clientProvider =
                    Provider.of<OdooClientManager>(context, listen: false);
                provider.getQuotationsAndReport(
                  context: context,
                  session: clientProvider.currentsession,
                  loading: true,
                );
              },
            ),
          if (hasCustomFilters)
            _buildFilterChip(
              label: 'Custom Filters',
              icon: Icons.tune,
              color: Colors.orange,
              onClose: () {
                provider.clearCustomFilters();
                final clientProvider =
                    Provider.of<OdooClientManager>(context, listen: false);
                provider.getQuotationsAndReport(
                  context: context,
                  session: clientProvider.currentsession,
                  loading: true,
                );
              },
            ),
        ],
      ),
    );
  }

  /// Builds an individual filter chip with an icon and close button
  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onClose,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onClose,
            child: Icon(
              Icons.close,
              size: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Maps GroupByOption enum to readable string
  String _getGroupByDisplayName(GroupByOption option) {
    switch (option) {
      case GroupByOption.none:
        return 'None';
      case GroupByOption.stage:
        return 'Stage';
      case GroupByOption.salesperson:
        return 'Salesperson';
      case GroupByOption.partner:
        return 'Customer';
      case GroupByOption.team:
        return 'Sales Team';
      case GroupByOption.priority:
        return 'Priority';
      case GroupByOption.country:
        return 'Country';
      case GroupByOption.createDate:
        return 'Creation Date';
      case GroupByOption.expectedRevenue:
        return 'Expected Revenue';
      case GroupByOption.probability:
        return 'Probability';
      default:
        return option.label;
    }
  }

  Widget _buildViewSelector(QuotationViewProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedItem = items[_selectedIndex];

    return Container(
      constraints: const BoxConstraints(minHeight: 35),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<int>(
          value: _selectedIndex,

          /// ✅ THIS replaces buttonStyleData
          customButton: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selectedItem['icon'],
                size: 17,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  selectedItem['label'],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: isDark ? Colors.white : Colors.black,
              ),
            ],
          ),

          onChanged: (index) {
            if (index != null) {
              setState(() {
                _selectedIndex = index;
              });
            }
          },

          /// ✅ Dropdown styling
          dropdownStyleData: DropdownStyleData(
            maxHeight: 250,
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
              color: isDark ? Colors.grey[900] : Colors.white,
            ),
          ),

          /// ✅ Items
          items: items.asMap().entries.map((entry) {
            final isSelected = _selectedIndex == entry.key;

            return DropdownMenuItem<int>(
              value: entry.key,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.grey.withValues(alpha: 0.15))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      entry.value['icon'],
                      size: 20,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      entry.value['label'],
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Builds individual quotation card
  Widget _buildQuotationCard(BuildContext context,
      Map<dynamic, dynamic> quotation, QuotationViewProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        final formProvider =
            Provider.of<QuotationFormProvider>(context, listen: false);
        final clientProvider =
            Provider.of<OdooClientManager>(context, listen: false);

        formProvider.fetchAndReplaceOrderLines(
          loading: true,
          isQuoteBuilder: false,
          quotation['id'],
          clientProvider.client!,
          clientProvider.currentsession!,
          formProvider.productlinedata,
          context,
          currentCountryId: clientProvider.countryId,
        );

        Navigator.push(
          context,
          SlidingPageTransitionRL(
            page: NewQuotationForm(
              leadid: quotation['opportunity_id'] == false
                  ? null
                  : quotation['opportunity_id'],
              ordersaleid: quotation['id'],
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            width: 0.5,
          ),
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
                          quotation['name']?.toString() ?? 'Unnamed Quotation',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppStyle.primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (quotation['partner_id'] is List &&
                            quotation['partner_id'].length > 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              quotation['partner_id'][1],
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
                  _buildStatusBadge(quotation, isDark),
                ],
              ),
              if (quotation['date_order'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      Text(
                        _formatDate(quotation['date_order']),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      if (quotation['validity_date'] != null) ...[
                        Flexible(
                          child: Text(
                            _formatDate(quotation['validity_date']),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    _formatCurrency(quotation['amount_total'],
                        quotation['currency_id'], provider),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
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

  Widget _buildStatusBadge(Map<dynamic, dynamic> quotation, bool isDark) {
    final statusColor = StatusColors.getStatusColor(quotation['state']?.toString());
    return StatusColors.buildStatusBadge(
      _getStateLabel(quotation['state']),
      statusColor,
      isDark: isDark,
    );
  }

  String _getStateLabel(dynamic state) {
    switch (state?.toString()) {
      case 'draft':
        return 'Draft';
      case 'sent':
        return 'Quotation Sent';
      case 'sale':
        return 'Sales Order';
      case 'done':
        return 'Locked';
      case 'cancel':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  String _formatCurrency(
      dynamic amount, dynamic currencyId, QuotationViewProvider provider) {
    if (amount == null) return '\$0.00';

    String symbol = '\$';
    if (currencyId is List && currencyId.isNotEmpty) {
      final currencyIdInt = currencyId[0] as int?;
      if (currencyIdInt != null &&
          provider.currencySymbolMap.containsKey(currencyIdInt)) {
        symbol = provider.currencySymbolMap[currencyIdInt]!;
      }
    }

    return '$symbol${NumberFormat('#,##0.00').format(amount)}';
  }

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
