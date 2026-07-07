import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/utils/app_theme.dart';
import 'package:provider/provider.dart';

import '../../core/company/session/company_session_manager.dart';

/// Enum defining available grouping options for lead/opportunity Kanban views.
///
/// Each option maps a user-friendly label to the corresponding Odoo field name.
enum GroupByOption {
  none('None', 'none'),
  stage('Stage', 'stage_id'),
  salesperson('Salesperson', 'user_id'),
  team('Sales Team', 'team_id'),
  priority('Priority', 'priority'),
  partner('Customer', 'partner_id'),
  country('Country', 'country_id'),
  createDate('Creation Date', 'create_date'),
  expectedRevenue('Expected Revenue', 'expected_revenue'),
  probability('Probability', 'probability');

  const GroupByOption(this.label, this.field);

  final String label;
  final String field;
}

/// Enum defining available grouping options for customer/partner lists.
enum CustomerGroupByOption {
  none('None', 'none'),
  companyType('Company Type', 'company_type'),
  country('Country', 'country_id'),
  state('State', 'state_id'),
  category('Category', 'category_id'),
  salesperson('Salesperson', 'user_id'),
  customerRank('Customer Rank', 'customer_rank'),
  supplierRank('Supplier Rank', 'supplier_rank'),
  isCompany('Is Company', 'is_company'),
  active('Active Status', 'active');

  const CustomerGroupByOption(this.label, this.field);

  final String label;
  final String field;
}

/// Compact, styled dropdown for selecting grouping in lead/opportunity Kanban views.
///
/// Features:
///   - Displays icon + label for each option
///   - Disabled state (greyed out, no interaction)
///   - Theme-aware colors and border
///   - Fixed compact height (38px)
class GroupByDropdown extends StatelessWidget {
  final GroupByOption selectedGroupBy;
  final ValueChanged<GroupByOption?> onChanged;
  final bool isEnabled;

  const GroupByDropdown({
    super.key,
    required this.selectedGroupBy,
    required this.onChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors().hintLight),
        color: isEnabled ? Colors.white : Colors.grey[100],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<GroupByOption>(
          value: selectedGroupBy,
          onChanged: isEnabled ? onChanged : null,
          icon: Icon(
            Icons.group_work,
            size: 18,
            color: isEnabled ? Theme.of(context).primaryColor : Colors.grey,
          ),
          style: TextStyle(
            fontSize: 12,
            color: isEnabled ? Colors.black87 : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          items: GroupByOption.values.map((option) {
            return DropdownMenuItem<GroupByOption>(
              value: option,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getIconForOption(option),
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    option.label,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Returns appropriate icon for each grouping option
  IconData _getIconForOption(GroupByOption option) {
    switch (option) {
      case GroupByOption.none:
        return Icons.clear;
      case GroupByOption.stage:
        return Icons.flag;
      case GroupByOption.salesperson:
        return Icons.person;
      case GroupByOption.team:
        return Icons.group;
      case GroupByOption.priority:
        return Icons.priority_high;
      case GroupByOption.partner:
        return Icons.business;
      case GroupByOption.country:
        return Icons.public;
      case GroupByOption.createDate:
        return Icons.calendar_today;
      case GroupByOption.expectedRevenue:
        return Icons.attach_money;
      case GroupByOption.probability:
        return Icons.percent;
    }
  }
}

/// Expandable header for grouped Kanban columns or list sections.
///
/// Displays:
///   - Group name (or 'Undefined' if empty)
///   - Item count badge
///   - Optional total revenue summary (with currency symbol)
///   - Expand/collapse chevron icon
///   - Dynamic icon matching the grouping type
class GroupByHeader extends StatelessWidget {
  final bool isLead;
  final bool isQuotation;
  final String groupName;
  final int itemCount;
  final double? totalRevenue;
  final String? currencySymbol;
  final bool isExpanded;
  final VoidCallback onToggle;
  final GroupByOption groupByOption;
  final bool wrapInContainer;

  const GroupByHeader({
    super.key,
    required this.isLead,
    required this.isQuotation,
    required this.groupName,
    required this.itemCount,
    this.totalRevenue,
    this.currencySymbol,
    required this.isExpanded,
    required this.onToggle,
    required this.groupByOption,
    this.wrapInContainer = true,
  });

  @override
  Widget build(BuildContext context) {
    final headerRow = InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    groupName,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isQuotation
                        ? ('$itemCount quotation${itemCount != 1 ? 's' : ''}')
                        : (isLead
                            ? '$itemCount lead${itemCount != 1 ? 's' : ''}'
                            : '$itemCount pipeline${itemCount != 1 ? 's' : ''}'),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (totalRevenue != null && totalRevenue! > 0) ...[
              const SizedBox(width: 8),
              StatusColors.buildStatusBadge(
                '${currencySymbol ?? '\$'}${_formatRevenue(totalRevenue!)}',
                StatusColors.statusGreen,
              ),
              const SizedBox(width: 20),
            ],
            Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );

    if (!wrapInContainer) return headerRow;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black.withOpacity(0.06),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.08),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(children: [headerRow]),
    );
  }

  /// Formats large revenue numbers with K/M suffixes
  String _formatRevenue(double revenue) {
    if (revenue >= 1000000) {
      return '${(revenue / 1000000).toStringAsFixed(1)}M';
    } else if (revenue >= 1000) {
      return '${(revenue / 1000).toStringAsFixed(1)}K';
    } else {
      return revenue.toStringAsFixed(0);
    }
  }
}

/// Dynamic dropdown for grouping customers/partners with runtime availability check.
///
/// Features:
///   - Fetches real data to determine which options are available
///     (e.g. only shows Salesperson if users exist, Country if countries exist)
///   - Shows loading spinner while fetching
///   - Disabled state support
///   - Consistent compact style matching `GroupByDropdown`
///   - Falls back to safe defaults on error
class CustomerGroupByDropdown extends StatefulWidget {
  final CustomerGroupByOption selectedGroupBy;
  final ValueChanged<CustomerGroupByOption?> onChanged;
  final bool isEnabled;

  const CustomerGroupByDropdown({
    super.key,
    required this.selectedGroupBy,
    required this.onChanged,
    this.isEnabled = true,
  });

  @override
  State<CustomerGroupByDropdown> createState() =>
      _CustomerGroupByDropdownState();
}

class _CustomerGroupByDropdownState extends State<CustomerGroupByDropdown> {
  List<CustomerGroupByOption> _availableOptions = [CustomerGroupByOption.none];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGroupByOptions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchGroupByOptions();
  }

  /// Queries Odoo for available grouping dimensions (users, countries, states, categories)
  Future<void> _fetchGroupByOptions() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final odooClient = Provider.of<OdooClientManager>(context, listen: false);
      final client = odooClient.client;

      if (client == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final currentCompanyId = odooClient.currentsession?.companyId;

      final salespersonResponse =
          await CompanySessionManager.callKwWithCompany({
        'model': 'res.users',
        'method': 'search_read',
        'args': [
          [
            ['active', '=', true],
            if (currentCompanyId != null)
              [
                'company_ids',
                'in',
                [currentCompanyId]
              ],
          ]
        ],
        'kwargs': {
          'fields': ['id', 'name'],
          'order': 'name asc',
        },
      });

      final countryResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'res.country',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name'],
          'order': 'name asc',
        },
      });

      final stateResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'res.country.state',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name', 'country_id'],
          'order': 'name asc',
        },
      });

      final categoryResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'res.partner.category',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name'],
          'order': 'name asc',
        },
      });

      List<CustomerGroupByOption> options = [CustomerGroupByOption.none];

      if (salespersonResponse is List && salespersonResponse.isNotEmpty) {
        options.add(CustomerGroupByOption.salesperson);
      }

      options.addAll([
        CustomerGroupByOption.companyType,
        CustomerGroupByOption.isCompany,
        CustomerGroupByOption.active,
        CustomerGroupByOption.customerRank,
        CustomerGroupByOption.supplierRank,
      ]);

      if (countryResponse is List && countryResponse.isNotEmpty) {
        options.add(CustomerGroupByOption.country);
      }

      if (stateResponse is List && stateResponse.isNotEmpty) {
        options.add(CustomerGroupByOption.state);
      }

      if (categoryResponse is List && categoryResponse.isNotEmpty) {
        options.add(CustomerGroupByOption.category);
      }

      if (mounted) {
        setState(() {
          _availableOptions = options;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _availableOptions = [
            CustomerGroupByOption.none,
            CustomerGroupByOption.companyType,
            CustomerGroupByOption.salesperson,
            CustomerGroupByOption.isCompany,
            CustomerGroupByOption.active,
          ];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors().hintLight),
        color: widget.isEnabled ? Colors.white : Colors.grey[100],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CustomerGroupByOption>(
          value: _availableOptions.contains(widget.selectedGroupBy)
              ? widget.selectedGroupBy
              : CustomerGroupByOption.none,
          onChanged: widget.isEnabled ? widget.onChanged : null,
          icon: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  Icons.group_work,
                  size: 18,
                  color: widget.isEnabled
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
          style: TextStyle(
            fontSize: 12,
            color: widget.isEnabled ? Colors.black87 : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          items: _availableOptions.map((option) {
            return DropdownMenuItem<CustomerGroupByOption>(
              value: option,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getIconForCustomerOption(option),
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    option.label,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Returns appropriate icon for each customer grouping option
  IconData _getIconForCustomerOption(CustomerGroupByOption option) {
    switch (option) {
      case CustomerGroupByOption.none:
        return Icons.clear;
      case CustomerGroupByOption.companyType:
        return Icons.business;
      case CustomerGroupByOption.country:
        return Icons.public;
      case CustomerGroupByOption.state:
        return Icons.location_on;
      case CustomerGroupByOption.category:
        return Icons.category;
      case CustomerGroupByOption.salesperson:
        return Icons.person;
      case CustomerGroupByOption.customerRank:
        return Icons.star;
      case CustomerGroupByOption.supplierRank:
        return Icons.local_shipping;
      case CustomerGroupByOption.isCompany:
        return Icons.corporate_fare;
      case CustomerGroupByOption.active:
        return Icons.toggle_on;
    }
  }
}
