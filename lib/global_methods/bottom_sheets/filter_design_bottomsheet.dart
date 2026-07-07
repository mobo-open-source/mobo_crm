import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:mobo_crm/models/LoginPage/session_model.dart';
import 'package:mobo_crm/utils/date_picker_utils.dart';
import 'package:mobo_crm/utils/globals.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import '../../screens/quotation/provider/quotation_view_provider.dart';
import '../../screens/customers/provider/customer_data_provider.dart';

/// Represents a single filter option (checkbox, chip, dropdown, range, etc.)
class FilterOption {
  final String title;
  bool value;
  final String? type;
  final List<Map<String, dynamic>>? options;
  final Map<String, dynamic>? rangeData;
  dynamic selectedValue;

  FilterOption({
    required this.title,
    required this.value,
    this.type = 'checkbox',
    this.options,
    this.rangeData,
    this.selectedValue,
  });
}

/// Logical grouping of related filter options (e.g. "Status", "Date", "Salesperson")
class FilterGroup {
  final String title;
  final List<FilterOption> options;
  bool isExpanded;

  FilterGroup({
    required this.title,
    required this.options,
    this.isExpanded = false,
  });
}

/// Advanced filter bottom sheet with tabs: Filters + Group By
///
/// Supports:
///   • Predefined filter groups (checkboxes/chips)
///   • Group by options (single selection + "None")
///   • Custom domain-style filters via AddCustomFilterDialog
///   • Active selection chips with remove functionality
///   • Clear All + Apply actions
///
/// Designed mainly for list views (quotations, customers, invoices, etc.)
class PremiumFilterBottomSheet extends StatefulWidget {
  final List<FilterGroup> filterGroups;
  final List<FilterGroup> groupByOptions;
  final List<FilterGroup> customFilterGroups;
  final Function(Map<String, dynamic>) onApply;
  final String title;
  final Color primaryColor;
  final bool clearAll;
  final OdooClient? client;
  final SessionModel? session;
  final String model;

  const PremiumFilterBottomSheet({
    super.key,
    required this.filterGroups,
    this.groupByOptions = const [],
    this.customFilterGroups = const [],
    required this.onApply,
    this.clearAll = true,
    this.title = 'Filters',
    this.primaryColor = AppStyle.primaryColor,
    this.client,
    this.session,
    this.model = 'sale.order',
  });

  /// Convenience method to show the bottom sheet
  static void show({
    required BuildContext context,
    required List<FilterGroup> filterGroups,
    List<FilterGroup> groupByOptions = const [],
    List<FilterGroup> customFilterGroups = const [],
    required Function(Map<String, dynamic>) onApply,
    String title = 'Filters',
    Color primaryColor = AppStyle.primaryColor,
    OdooClient? client,
    SessionModel? session,
    String model = 'sale.order',
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return PremiumFilterBottomSheet(
          filterGroups: filterGroups,
          groupByOptions: groupByOptions,
          customFilterGroups: customFilterGroups,
          onApply: onApply,
          title: title,
          primaryColor: primaryColor,
          client: client,
          session: session,
          model: model,
        );
      },
    );
  }

  @override
  State<PremiumFilterBottomSheet> createState() =>
      _PremiumFilterBottomSheetState();
}

/// Manages state and UI for the premium filter bottom sheet
class _PremiumFilterBottomSheetState extends State<PremiumFilterBottomSheet>
    with TickerProviderStateMixin {
  late List<FilterGroup> _tempFilterGroups;
  late List<FilterGroup> _tempGroupByOptions;
  List<FilterGroup> _tempCustomFilterGroups = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    _tempFilterGroups = widget.filterGroups.map((group) {
      return FilterGroup(
        title: group.title,
        isExpanded: group.isExpanded,
        options: group.options.map((option) {
          return FilterOption(
            title: option.title,
            value: option.value,
          );
        }).toList(),
      );
    }).toList();

    _tempGroupByOptions = widget.groupByOptions.map((group) {
      return FilterGroup(
        title: group.title,
        isExpanded: group.isExpanded,
        options: group.options.map((option) {
          return FilterOption(
            title: option.title,
            value: option.value,
          );
        }).toList(),
      );
    }).toList();

    if (widget.customFilterGroups.isNotEmpty) {
      _tempCustomFilterGroups = widget.customFilterGroups.map((group) {
        return FilterGroup(
          title: group.title,
          isExpanded: group.isExpanded,
          options: group.options.map((option) {
            return FilterOption(
              title: option.title,
              value: option.value,
              type: option.type,
              options: option.options,
              rangeData: option.rangeData,
              selectedValue: option.selectedValue,
            );
          }).toList(),
        );
      }).toList();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Collects all current filter & group-by selections into a flat key-value map
  /// Keys are usually `group_title_option_title` pattern
  Map<String, dynamic> _collectValues() {
    Map<String, dynamic> result = {};

    for (var group in _tempFilterGroups) {
      String groupPrefix = '${group.title.toLowerCase().replaceAll(' ', '_')}_';
      for (var option in group.options) {
        String key = option.title.toLowerCase().replaceAll(' ', '_');
        result['$groupPrefix$key'] = option.value;
      }
    }

    for (var group in _tempGroupByOptions) {
      String groupPrefix = '${group.title.toLowerCase().replaceAll(' ', '_')}_';
      for (var option in group.options) {
        String key = option.title.toLowerCase().replaceAll(' ', '_');
        result['$groupPrefix$key'] = option.value;
      }
    }

    for (var group in _tempCustomFilterGroups) {
      String groupPrefix = '${group.title.toLowerCase().replaceAll(' ', '_')}_';
      for (var option in group.options) {
        String key = option.title.toLowerCase().replaceAll(' ', '_');
        if (option.type == 'multi_select' ||
            option.type == 'range' ||
            option.type == 'date_range') {
          if (option.selectedValue != null) {
            result['${groupPrefix}${key}_selected'] = option.selectedValue;
          }
        } else {
          result['$groupPrefix$key'] = option.value;
        }
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 12, bottom: 8),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFiltersTab(),
                _buildGroupByTab(),
              ],
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Filter & Group By',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              color: Colors.black54,
            ),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSelections() {
    Map<String, int> filterCounts = {};
    List<Widget> activeChips = [];

    for (var group in _tempFilterGroups) {
      int count = 0;

      for (var option in group.options) {
        if (option.value == true) {
          count++;
        }
      }

      if (count > 0) {
        filterCounts[group.title] = count;
      }
    }

    filterCounts.forEach((title, count) {
      activeChips.add(
        _buildActiveChip(
          label: '$title ($count)',
          type: 'filter',
          onRemove: () {
            setState(() {
              for (var group in _tempFilterGroups) {
                if (group.title == title) {
                  for (var opt in group.options) {
                    opt.value = false;
                  }
                }
              }
            });
          },
        ),
      );
    });

    try {
      final quotationProvider =
          Provider.of<QuotationViewProvider>(context, listen: false);
      if (quotationProvider.hasCustomFilters) {
        activeChips.add(_buildActiveChip(
          label: 'Custom Filters',
          type: 'custom',
          onRemove: () {
            quotationProvider.clearCustomFilters();
          },
        ));
      }
    } catch (_) {}

    try {
      final customerProvider =
          Provider.of<CustomerDataProvider>(context, listen: false);
      if (customerProvider.hasCustomFilters) {
        activeChips.add(_buildActiveChip(
          label: 'Custom Filters',
          type: 'custom',
          onRemove: () {
            customerProvider.clearCustomFilters();
          },
        ));
      }
    } catch (_) {}

    if (activeChips.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Filters',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppStyle.primaryColor,
            ),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: activeChips,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveChip({
    required String label,
    required String type,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppStyle.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x4DC03355)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppStyle.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: widget.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorPadding: const EdgeInsets.all(4),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabs: const [
          Tab(height: 48, text: 'Filter'),
          Tab(height: 48, text: 'Group By'),
        ],
        onTap: (index) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildFiltersTab() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActiveSelections(),

          ...List.generate(_tempFilterGroups.length, (groupIndex) {
            return _buildFilterGroup(groupIndex);
          }),
        ],
      ),
    );
  }

  Widget _buildGroupByTab() {
    return Material(
      color: Colors.grey[50],
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Group quotations by',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 20),
            _buildNoneGroupByOption(),
            SizedBox(height: 10),
            Divider(color: Colors.grey[300],thickness: 1,height: 1),
            SizedBox(height: 10),
            ...List.generate(_tempGroupByOptions.length, (groupIndex) {
              return _buildGroupByGroup(groupIndex);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNoneGroupByOption() {
    bool isNoneSelected = true;
    for (var group in _tempGroupByOptions) {
      for (var option in group.options) {
        if (option.value == true) {
          isNoneSelected = false;
          break;
        }
      }
      if (!isNoneSelected) break;
    }

    return Material(
      color: Colors.transparent,
      child: RadioListTile<bool>(
        title: Text(
          'None',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          'Display as a simple list',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        value: true,
        groupValue: isNoneSelected,
        onChanged: (value) {
          setState(() {
            for (var group in _tempGroupByOptions) {
              for (var option in group.options) {
                option.value = false;
              }
            }
          });
        },
        activeColor: widget.primaryColor,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildFilterGroup(int groupIndex) {
    final group = _tempFilterGroups[groupIndex];
    final isDateField = group.title.toLowerCase().contains('date');

    return isDateField
        ? _buildDateRangeGroup(group, groupIndex)
        : _buildNonExpandableGroup(group, groupIndex);
  }

  Widget _buildDateRangeGroup(FilterGroup group, int groupIndex) {
    final startOption = group.options.firstWhere(
      (opt) => opt.title.toLowerCase().contains('start') || opt.title.toLowerCase().contains('from'),
      orElse: () => group.options[0],
    );
    final endOption = group.options.firstWhere(
      (opt) => opt.title.toLowerCase().contains('end') || opt.title.toLowerCase().contains('to'),
      orElse: () => group.options.length > 1 ? group.options[1] : group.options[0],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            group.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildDateInput(
                label: 'From',
                value: startOption.selectedValue,
                onTap: () async {
                  final date = await DatePickerUtils.showStandardDatePicker(
                    context: context,
                    initialDate: startOption.selectedValue ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      startOption.selectedValue = date;
                      startOption.value = true;
                    });
                  }
                },
                onClear: () {
                  setState(() {
                    startOption.selectedValue = null;
                    startOption.value = false;
                  });
                },
              ),
              const SizedBox(height: 8),
              _buildDateInput(
                label: 'To',
                value: endOption.selectedValue,
                onTap: () async {
                  final date = await DatePickerUtils.showStandardDatePicker(
                    context: context,
                    initialDate: endOption.selectedValue ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      endOption.selectedValue = date;
                      endOption.value = true;
                    });
                  }
                },
                onClear: () {
                  setState(() {
                    endOption.selectedValue = null;
                    endOption.value = false;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateInput({
    required String label,
    required dynamic value,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    final displayValue = value is DateTime
        ? DateFormat('MMM dd, yyyy').format(value)
        : value?.toString() ?? 'Select $label date';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(
              HugeIcons.strokeRoundedCalendar03,
              size: 18,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                displayValue,
                style: TextStyle(
                  color: value != null ? Colors.black87 : Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ),
            if (value != null)
              GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNonExpandableGroup(FilterGroup group, int groupIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            group.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: group.options.asMap().entries.map((entry) {
              final optionIndex = entry.key;
              return _buildChipOption(groupIndex, optionIndex);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChipOption(int groupIndex, int optionIndex) {
    final option = _tempFilterGroups[groupIndex].options[optionIndex];

    return ChoiceChip(
      label: Text(
        option.title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: option.value ? FontWeight.w600 : FontWeight.w400,
          color: option.value ? Colors.white : Colors.black87,
        ),
      ),
      selected: option.value,
      selectedColor: widget.primaryColor,
      backgroundColor: widget.primaryColor.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: option.value ? widget.primaryColor : Colors.grey[300]!,
        ),
      ),
      onSelected: (val) {
        setState(() {
          option.value = val;
        });
      },
      showCheckmark: false,
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20 + MediaQuery.of(context).padding.bottom,
        top: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      for (var group in _tempFilterGroups) {
                        for (var option in group.options) {
                          option.value = false;
                          if (option.type == 'range' ||
                              option.type == 'date_range' ||
                              option.title.toLowerCase().contains('date')) {
                            option.selectedValue = null;
                          }
                        }
                      }
                      for (var group in _tempGroupByOptions) {
                        for (var option in group.options) {
                          option.value = false;
                        }
                      }
                    });
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: widget.primaryColor,
                  side: BorderSide(color: widget.primaryColor, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Clear All',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> filterValues = _collectValues();
                  widget.onApply(filterValues);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupByGroup(int groupIndex) {
    final group = _tempGroupByOptions[groupIndex];

    return Column(
      children: List.generate(group.options.length, (optionIndex) {
        return _buildGroupByOption(groupIndex, optionIndex);
      }),
    );
  }

  Widget _buildGroupByOption(int groupIndex, int optionIndex) {
    final group = _tempGroupByOptions[groupIndex];
    final option = group.options[optionIndex];
    if (option.title.toLowerCase() == 'none') {
      return const SizedBox.shrink();
    }

    String getDescription(String title) {
      switch (title.toLowerCase()) {
        case 'none':
          return 'Display as a simple list';
        case 'status':
          return 'Group by quotation status (Draft, Sent, Confirmed, etc.)';
        case 'customer':
          return 'Group by customer name';
        case 'salesperson':
          return 'Group by assigned salesperson';
        case 'order date':
          return 'Group by order creation date';
        case 'validity date':
          return 'Group by quotation expiry date';
        default:
          return 'Group by ${title.toLowerCase()}';
      }
    }

    return Material(
      color: Colors.transparent,
      child: RadioListTile<bool>(
        title: Text(
          option.title,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          getDescription(option.title),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        value: true,
        groupValue: option.value,
        onChanged: (value) {
          if (mounted) {
            setState(() {
              for (var grp in _tempGroupByOptions) {
                for (var opt in grp.options) {
                  opt.value = false;
                }
              }
              option.value = true;
            });
          }
        },
        activeColor: widget.primaryColor,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

/// Simple single-selection bottom sheet (used for graph period/filter selection)
///
/// Example usage: select "This Month", "Last Quarter", "Custom Range", etc.
class FilterBottomSheet extends StatefulWidget {
  final List<String> filters;
  final Function(String) onApply;
  final String selectedFilter;
  final String title;
  final Color primaryColor;

  const FilterBottomSheet({
    Key? key,
    required this.filters,
    required this.onApply,
    required this.selectedFilter,
    this.title = 'Select Filter',
    this.primaryColor = AppStyle.primaryColor,
  }) : super(key: key);

  /// Static convenience method to display the sheet
  static void show({
    required BuildContext context,
    required List<String> filters,
    required Function(String) onApply,
    required String selectedFilter,
    String title = 'Select Filter',
    Color primaryColor = AppStyle.primaryColor,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return FilterBottomSheet(
          filters: filters,
          onApply: onApply,
          selectedFilter: selectedFilter,
          title: title,
          primaryColor: primaryColor,
        );
      },
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

/// Internal model for simple filter options (used only in FilterBottomSheet)
class GraphFilterOption {
  final String title;
  bool isSelected;

  GraphFilterOption({
    required this.title,
    this.isSelected = false,
  });
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late List<GraphFilterOption> _tempFilters;

  @override
  void initState() {
    super.initState();
    _tempFilters = widget.filters.map((filter) {
      return GraphFilterOption(
        title: filter,
        isSelected: filter == widget.selectedFilter,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: Offset(0, -5),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: Center(
              child: Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: widget.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          _buildHeader(),
          Flexible(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(_tempFilters.length, (index) {
                  return _buildOptionTile(index);
                }),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(int index) {
    final option = _tempFilters[index];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: option.isSelected
            ? widget.primaryColor.withOpacity(0.08)
            : Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              for (var i = 0; i < _tempFilters.length; i++) {
                _tempFilters[i].isSelected = (i == index);
              }
            });
            widget.onApply(option.title);
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: option.isSelected
                        ? widget.primaryColor
                        : Colors.transparent,
                    border: Border.all(
                      color: option.isSelected
                          ? widget.primaryColor
                          : widget.primaryColor.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: option.isSelected
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    option.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          option.isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: option.isSelected
                          ? Colors.black.withOpacity(0.9)
                          : Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
