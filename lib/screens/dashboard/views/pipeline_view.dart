import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:mobo_crm/global_methods/widgets/custom_charts.dart';
import 'package:mobo_crm/screens/dashboard/provider/dashboard_provider.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:mobo_crm/global_methods/views/global_pivot_view.dart';
import 'package:mobo_crm/screens/opportunity/opportunity_views.dart';
import 'package:provider/provider.dart';

/// Main Pipeline dashboard view.
///
/// Features:
/// - Displays opportunity data in three formats:
///   • Graph View
///   • Pivot View
///   • List View
/// - Supports advanced filtering via bottom sheet
/// - Integrates creation date, closing date, expected closing,
///   stage status (Won/Lost/Ongoing), and type filters
///
/// Uses:
/// - [OpportunityDataProvider] for fetching opportunity data
/// - [DashboardProvider] for graph metric filters
/// - [OdooClientManager] for backend communication
///
/// Handles complex filter combinations and updates data dynamically.
class PipelineView extends StatefulWidget {
  const PipelineView({super.key});

  @override
  State<PipelineView> createState() => _PipelineViewState();
}

/// State class for [PipelineView].
///
/// Responsibilities:
/// - Initializes opportunity data
/// - Manages selected tab index
/// - Controls all filter states
/// - Displays and applies bottom sheet filters
/// - Triggers API refresh when filters change
///
/// Maintains:
/// - Lead / Opportunity / Pipeline toggles
/// - Stage filters (Won, Lost, Ongoing)
/// - Creation date filters
/// - Closing date filters
/// - Expected closing filters
class _PipelineViewState extends State<PipelineView> {
  @override
  void initState() {
    Provider.of<OpportunityDataProvider>(context, listen: false)
        .getOpportunities(
            context: context,
            isLead: filterByLead,
            isPipeline: filterByPipeline,
            pipelinefilters: showPipelineFilter,
            isOpportunity: filterByOpportunity);

    Provider.of<DashboardProvider>(context, listen: false).setFiltertoCount();
    super.initState();
  }

  int _selectedIndex = 0;
  final List<Widget> widgets = [
    const PipelineGraphWidget(),
    const PipelinePivot(),
    const OpportunityListView(
      isPipeline: false,
    )
  ];

  final List<IconData> icons = [
    Icons.bar_chart,
    Icons.grid_on,
    Icons.list,
  ];

  bool showPipelineFilter = false;
  bool showStageFilter = false;
  bool filterByPipeline = false;
  bool filterByLead = false;
  bool filterByOpportunity = true;

  bool filterWon = false;
  bool filterLost = false;
  bool filterOngoing = false;

  bool filterCurrentMonth = false;
  bool filterPreviousMonth = false;
  bool filterTwoMonthsAgo = false;
  bool hasCreationDateFilters = false;

  bool filterPreviousMonthClose = false;
  bool filterTwoMonthsAgoClose = false;
  bool hasClosingDateFilters = false;
  bool filterCurrentMonthClose = false;

  bool filterExpectedClosing = false;
  bool filterTwoMonthsAgoExpected = false;
  bool filterPreviousMonthExpected = false;
  bool filterCurrentMonthExpected = false;

  /// Displays a modal bottom sheet to filter opportunities.
  ///
  /// Filter Categories:
  /// - Type: Lead, Opportunity, Pipeline
  /// - Stage: Won, Lost, Ongoing
  /// - Creation Date (Current, Previous, Two months ago)
  /// - Closing Date (Current, Previous, Two months ago)
  /// - Expected Closing (Current, Previous, Two months ago)
  ///
  /// On Apply:
  /// - Updates internal filter states
  /// - Determines active filter groups
  /// - Calls [OpportunityDataProvider.getOpportunities]
  /// - Refreshes UI
  void showFilterBottomSheet(BuildContext context) {
    bool tempFilterPipeline = filterByPipeline;
    bool tempFilterWon = filterWon;
    bool tempFilterLost = filterLost;
    bool tempShowPipelineFilter = showPipelineFilter;
    bool tempFilterOngoing = filterOngoing;
    bool tempFilterLead = filterByLead;
    bool tempFilterOpportunity = filterByOpportunity;

    DateTime now = DateTime.now();
    bool tempFilterCurrentMonth = filterCurrentMonth;
    bool tempFilterPreviousMonth = filterPreviousMonth;
    bool tempFilterTwoMonthsAgo = filterTwoMonthsAgo;
    bool tempFilterPreviousMonthClose = filterPreviousMonthClose;
    bool tempFilterTwoMonthsAgoClose = filterTwoMonthsAgoClose;
    bool tempFilterCurrentMonthClose = filterCurrentMonthClose;

    bool tempFilterCurrentMonthExpected = filterCurrentMonthExpected;
    bool tempFilterPreviousMonthExpected = filterPreviousMonthExpected;
    bool tempFilterTwoMonthsAgoExpected = filterTwoMonthsAgoExpected;

    String currentMonth = DateFormat('MMMM yyyy').format(now);
    String previousMonth =
        DateFormat('MMMM yyyy').format(DateTime(now.year, now.month - 1, 1));
    String twoMonthsAgo =
        DateFormat('MMMM yyyy').format(DateTime(now.year, now.month - 2, 1));

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter Opportunities',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title:
                          Text('Lead', style: TextStyle(color: Colors.white)),
                      value: tempFilterLead,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setModalState(() {
                          tempFilterLead = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Opportunity',
                          style: TextStyle(color: Colors.white)),
                      value: tempFilterOpportunity,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setModalState(() {
                          tempFilterOpportunity = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Pipeline',
                          style: TextStyle(color: Colors.white)),
                      value: tempFilterPipeline,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setModalState(() {
                          tempFilterPipeline = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Won', style: TextStyle(color: Colors.white)),
                      value: tempFilterWon,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setModalState(() {
                          tempFilterWon = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title:
                          Text('Lost', style: TextStyle(color: Colors.white)),
                      value: tempFilterLost,
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setModalState(() {
                          tempFilterLost = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ExpansionTile(
                      initiallyExpanded: hasCreationDateFilters,
                      title: Text("Creation Date",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      collapsedBackgroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Theme.of(context).primaryColor,
                      iconColor: Colors.green,
                      children: [
                        CheckboxListTile(
                          title: Text(currentMonth,
                              style: TextStyle(color: Colors.white)),
                          value: tempFilterCurrentMonth,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setModalState(() {
                              tempFilterCurrentMonth = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(previousMonth,
                              style: TextStyle(color: Colors.white)),
                          value: tempFilterPreviousMonth,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setModalState(() {
                              tempFilterPreviousMonth = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(twoMonthsAgo,
                              style: TextStyle(color: Colors.white)),
                          value: tempFilterTwoMonthsAgo,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setModalState(() {
                              tempFilterTwoMonthsAgo = value ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ExpansionTile(
                      initiallyExpanded: hasClosingDateFilters,
                      title: Text("Closing Date",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      collapsedBackgroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Theme.of(context).primaryColor,
                      iconColor: Colors.green,
                      children: [
                        CheckboxListTile(
                          title: Text(currentMonth,
                              style: TextStyle(color: Colors.white)),
                          value: tempFilterCurrentMonthClose,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setModalState(() {
                              tempFilterCurrentMonthClose = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(previousMonth,
                              style: TextStyle(color: Colors.white)),
                          value: tempFilterPreviousMonthClose,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setModalState(() {
                              tempFilterPreviousMonthClose = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(twoMonthsAgo,
                              style: TextStyle(color: Colors.white)),
                          value: tempFilterTwoMonthsAgoClose,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setModalState(() {
                              tempFilterTwoMonthsAgoClose = value ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ExpansionTile(
                      initiallyExpanded: filterExpectedClosing,
                      title: Text("Expected Closing",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      collapsedBackgroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Theme.of(context).primaryColor,
                      iconColor: Colors.green,
                      children: [
                        CheckboxListTile(
                          title: Text(currentMonth,
                              style: TextStyle(color: Colors.white)),
                          value: tempFilterCurrentMonthExpected,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setModalState(() {
                              tempFilterCurrentMonthExpected = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(previousMonth,
                              style: TextStyle(color: Colors.white)),
                          value: tempFilterPreviousMonthExpected,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setModalState(() {
                              tempFilterPreviousMonthExpected = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(twoMonthsAgo,
                              style: TextStyle(color: Colors.white)),
                          value: tempFilterTwoMonthsAgoExpected,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setModalState(() {
                              tempFilterTwoMonthsAgoExpected = value ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green,
                          ),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              filterCurrentMonthExpected =
                                  tempFilterCurrentMonthExpected;
                              filterPreviousMonthExpected =
                                  tempFilterPreviousMonthExpected;
                              filterTwoMonthsAgoExpected =
                                  tempFilterTwoMonthsAgoExpected;
                              filterByLead = tempFilterLead;
                              filterByOpportunity = tempFilterOpportunity;
                              filterByPipeline = tempFilterPipeline;
                              filterCurrentMonthClose =
                                  tempFilterCurrentMonthClose;
                              filterPreviousMonthClose =
                                  tempFilterPreviousMonthClose;
                              filterTwoMonthsAgoClose =
                                  tempFilterTwoMonthsAgoClose;
                              filterLost = tempFilterLost;
                              filterWon = tempFilterWon;
                              filterOngoing = tempFilterOngoing;

                              filterCurrentMonth = tempFilterCurrentMonth;
                              filterPreviousMonth = tempFilterPreviousMonth;
                              filterTwoMonthsAgo = tempFilterTwoMonthsAgo;

                              if (tempFilterPipeline == true) {
                                tempShowPipelineFilter = true;
                                showPipelineFilter = tempShowPipelineFilter;
                              } else {
                                tempShowPipelineFilter = false;
                                showPipelineFilter = tempShowPipelineFilter;
                              }

                              if (tempFilterCurrentMonthClose == true ||
                                  tempFilterPreviousMonthClose == true ||
                                  tempFilterTwoMonthsAgoClose == true) {
                                hasClosingDateFilters = true;
                              } else {
                                hasClosingDateFilters = false;
                              }
                              if (tempFilterCurrentMonthExpected == true ||
                                  tempFilterPreviousMonthExpected == true ||
                                  tempFilterTwoMonthsAgoExpected == true) {
                                filterExpectedClosing = true;
                              } else {
                                filterExpectedClosing = false;
                              }

                              if (tempFilterLost == true ||
                                  tempFilterWon == true ||
                                  tempFilterOngoing) {
                                showStageFilter = true;
                              } else {
                                showStageFilter = false;
                              }

                              if (tempFilterCurrentMonth == true ||
                                  tempFilterTwoMonthsAgo == true ||
                                  tempFilterPreviousMonth == true) {
                                hasCreationDateFilters = true;
                              } else {
                                hasCreationDateFilters = false;
                              }
                            });

                            Provider.of<OpportunityDataProvider>(context,
                                    listen: false)
                                .getOpportunities(
                                    showExpectedDate: filterExpectedClosing,
                                    monthbeforeExpected:
                                        filterPreviousMonthExpected,
                                    monthbeforetwoExpected:
                                        filterTwoMonthsAgoExpected,
                                    currentmonthExpected:
                                        filterCurrentMonthExpected,
                                    stagefilters: showStageFilter,
                                    won: filterWon,
                                    lost: filterLost,
                                    datefilterclose: hasClosingDateFilters,
                                    datefilters: hasCreationDateFilters,
                                    monthNow: filterCurrentMonth,
                                    monthNowclose: filterCurrentMonthClose,
                                    beforeMonth: filterPreviousMonth,
                                    beforeMonthclose: filterPreviousMonthClose,
                                    beforetwoMonth: filterTwoMonthsAgo,
                                    beforetwoMonthclose:
                                        filterTwoMonthsAgoClose,
                                    context: context,
                                    isLead: filterByLead,
                                    isPipeline: filterByPipeline,
                                    pipelinefilters: showPipelineFilter,
                                    isOpportunity: filterByOpportunity);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<OdooClientManager, OpportunityDataProvider>(
        builder: (context, clientprovider, opportunityprovider, child) {
      return Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(icons.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          opportunityprovider.getOpportunities(
                              showExpectedDate: filterExpectedClosing,
                              monthbeforeExpected: filterPreviousMonthExpected,
                              monthbeforetwoExpected:
                                  filterTwoMonthsAgoExpected,
                              currentmonthExpected: filterCurrentMonthExpected,
                              stagefilters: showStageFilter,
                              won: filterWon,
                              lost: filterLost,
                              datefilterclose: hasClosingDateFilters,
                              datefilters: hasCreationDateFilters,
                              monthNow: filterCurrentMonth,
                              monthNowclose: filterCurrentMonthClose,
                              beforeMonth: filterPreviousMonth,
                              beforeMonthclose: filterPreviousMonthClose,
                              beforetwoMonth: filterTwoMonthsAgo,
                              beforetwoMonthclose: filterTwoMonthsAgoClose,
                              context: context,
                              isLead: filterByLead,
                              isPipeline: filterByPipeline,
                              pipelinefilters: showPipelineFilter,
                              isOpportunity: filterByOpportunity);

                          _selectedIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? Colors.grey[300]
                              : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Icon(
                          icons[index],
                          color: _selectedIndex == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () => showFilterBottomSheet(
                  context,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Spacer(),
            ],
          ),
          Expanded(
            child: widgets[_selectedIndex],
          ),
        ],
      );
    });
  }
}

/// Displays pipeline opportunity data in graphical format.
///
/// Supports:
/// - Line Chart
/// - Bar Chart
/// - Pie Chart
///
/// Uses:
/// - [OpportunityDataProvider.stageOpportunityData]
/// - [DashboardProvider.selectedFilter]
///
/// Allows dynamic switching between graph types.
class PipelineGraphWidget extends StatefulWidget {
  const PipelineGraphWidget({super.key});

  @override
  State<PipelineGraphWidget> createState() => _PipelineGraphWidgetState();
}

/// State class for [PipelineGraphWidget].
///
/// Responsibilities:
/// - Controls selected graph type
/// - Builds chart UI based on selected index
/// - Applies metric filters using dropdown
class _PipelineGraphWidgetState extends State<PipelineGraphWidget> {
  /// Builds a selectable view icon for graph type switching.
  ///
  /// Parameters:
  /// - [icon]: Icon to display
  /// - [selected]: Whether this view is currently selected
  /// - [onTap]: Callback when icon is tapped
  ///
  /// Adjusts styling automatically for dark/light mode.
  Widget _viewIcon({
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selected
              ? (isDark ? Colors.white : Colors.black)
              : isDark
                  ? Colors.grey[850]
                  : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected
                ? (isDark ? Colors.white : Colors.black)
                : (isDark ? Colors.grey[500]! : Colors.grey[300]!),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: selected
              ? (isDark ? Colors.black : Colors.white)
              : (isDark ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DashboardProvider, OpportunityDataProvider>(
      builder: (context, provider, dataprovider, child) {
        if (provider.isloading) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildFilterDropdown(context, provider),
                    const Spacer(),
                    _viewIcon(
                      icon: HugeIcons.strokeRoundedChartLineData03,
                      selected: dataprovider.selectedindexpipeline == 0,
                      onTap: () {
                        setState(() {
                          dataprovider.selectedindexpipeline = 0;
                        });
                      },
                    ),
                    const SizedBox(width: 6),
                    _viewIcon(
                      icon: Icons.bar_chart,
                      selected: dataprovider.selectedindexpipeline == 1,
                      onTap: () {
                        setState(() {
                          dataprovider.selectedindexpipeline = 1;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _buildGraph(dataprovider, provider),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        }
      },
    );
  }

  /// Returns selected graph widget based on pipeline index.
  ///
  /// Graph Types:
  /// 0 → Line Chart
  /// 1 → Bar Chart
  /// 2 → Pie Chart
  ///
  /// Displays loading indicator while data is being fetched.
  Widget _buildGraph(
      OpportunityDataProvider dataprovider, DashboardProvider provider) {
    switch (dataprovider.selectedindexpipeline) {
      case 0:
        return LineChartWidgetCustom(
            isGrapgnLoading: dataprovider.isLoading,
            label: 'pipeline',
            selectedFilter: provider.selectedFilter,
            stageData: dataprovider.stageOpportunityData ?? []);
      case 1:
        return BarChartWidget(
            isGrapgnLoading: dataprovider.isLoading,
            label: 'pipeline',
            selectedFilter: provider.selectedFilter,
            stageData: dataprovider.stageOpportunityData ?? []);
      default:
        return const Center(child: Text('Select a Graph Type'));
    }
  }

  /// Builds dropdown for selecting pipeline metric filter.
  ///
  /// Available Filters:
  /// - Count
  /// - Days to Close
  /// - Expected Revenue
  /// - Expected MRR
  /// - Probability
  /// - Prorated MRR
  /// - Prorated Recurring Revenue
  /// - Prorated Revenue
  /// - Recurring Revenue
  ///
  /// On selection:
  /// - Calls [DashboardProvider.applyFilter]
  Widget _buildFilterDropdown(
      BuildContext context, DashboardProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filters = [
      "Count",
      "Days to Close",
      "Expected Revenue",
      "Expected MRR",
      "Probability",
      "Prorated MRR",
      "Prorated Recurring Revenue",
      "Prorated Revenue",
      "Recurring Revenue"
    ];

    final dropdownWidth = (MediaQuery.of(context).size.width * 0.45).clamp(140.0, 220.0);
    final buttonBg = isDark ? Colors.grey[800] : Colors.grey[100];
    final buttonFg = isDark ? Colors.white70 : Colors.black87;

    return Container(
      width: dropdownWidth,
      height: 40,
      decoration: BoxDecoration(
        color: buttonBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          iconStyleData: IconStyleData(
            icon: Icon(Icons.keyboard_arrow_down, color: buttonFg, size: 20),
          ),
          hint: Text(
            provider.selectedFilter,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(fontSize: 14, color: buttonFg),
          ),
          items: filters
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ))
              .toList(),
          value: provider.selectedFilter,
          onChanged: (String? value) {
            if (value != null) {
              provider.applyFilter(value);
            }
          },
          buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 40,
            width: dropdownWidth,
          ),
          menuItemStyleData: const MenuItemStyleData(height: 40),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? Colors.grey[500]! : Colors.grey[300]!,
                width: 1,
              ),
              color: isDark ? Colors.grey[900] : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

}

/// Displays pipeline data in pivot table format.
///
/// Configuration:
/// - Rows grouped by `create_date`
/// - Columns grouped by `stage_id`
/// - Values aggregated by `expected_revenue`
///
/// Uses:
/// - [PivotTable] widget
/// - [OpportunityDataProvider.opportunities]
class PipelinePivot extends StatelessWidget {
  const PipelinePivot({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OpportunityDataProvider>(
        builder: (context, provider, child) {
      if (provider.isLoading) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        );
      } else {
        return PivotTable(
          subHeading: 'Prorated Revenue',
          heading: 'Date',
          label: 'pipeline',
          data: provider.opportunities,
          rowKey: "create_date",
          columnKey: "stage_id",
          valueKey: "expected_revenue",
        );
      }
    });
  }
}
