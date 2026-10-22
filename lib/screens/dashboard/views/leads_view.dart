import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/bottom_sheets/filter_design_bottomsheet.dart';
import 'package:mobo_crm/global_methods/widgets/custom_charts.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/dashboard/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

/// A dashboard widget that displays CRM Lead reporting data
/// in multiple graphical formats.
///
/// Features:
/// - Fetches lead CRM report data on initialization
/// - Displays loading indicator while fetching data
/// - Supports three graph types:
///   • Line Chart
///   • Bar Chart
///   • Pie Chart
/// - Allows metric-based filtering via bottom sheet
///
/// Integrates with:
/// - [DashboardProvider] for report data and filtering
/// - [OdooClientManager] for API access
///
/// Uses Provider for reactive state updates.
class LeadReportingGraphWidget extends StatefulWidget {
  const LeadReportingGraphWidget({super.key});

  @override
  State<LeadReportingGraphWidget> createState() =>
      _LeadReportingGraphWidgetState();
}

int _selectedIndexlead = 0;

/// State class for [LeadReportingGraphWidget].
///
/// Responsibilities:
/// - Calls CRM lead reporting API during initialization
/// - Manages selected graph index
/// - Builds graph UI based on selected type
/// - Displays filter bottom sheet
class _LeadReportingGraphWidgetState extends State<LeadReportingGraphWidget> {
  /// Initializes the widget by fetching the lead CRM report.
  ///
  /// Calls:
  /// - [DashboardProvider.getLeadCrmReport]
  ///
  /// Uses:
  /// - Odoo client
  /// - Current user session
  ///
  /// Ensures data is loaded before rendering graphs.
  @override
  void initState() {
    final odooClientManager =
        Provider.of<OdooClientManager>(context, listen: false);

    final dashboardprovider =
        Provider.of<DashboardProvider>(context, listen: false);

    dashboardprovider.getLeadCrmReport(
        odooClientManager.client!, odooClientManager.currentsession!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        if (provider.isloading) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        _buildFilterButton(context, provider),
                        const Spacer(),
                        ToggleButtons(
                          isSelected:
                              List.generate(3, (i) => i == _selectedIndexlead),
                          onPressed: (int newIndex) {
                            setState(() {
                              _selectedIndexlead = newIndex;
                            });
                          },
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(Icons.stacked_line_chart),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(Icons.bar_chart),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(Icons.pie_chart),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(child: _buildGraph(provider)),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  /// Returns the selected graph widget based on toggle index.
  ///
  /// Graph Types:
  /// 0 → Line Chart
  /// 1 → Bar Chart
  /// 2 → Pie Chart
  ///
  /// Displays graph loading state using:
  /// - [provider.isgraphLoading]
  ///
  /// Uses:
  /// - provider.selectedFilter
  /// - provider.stageData
  Widget _buildGraph(DashboardProvider provider) {
    switch (_selectedIndexlead) {
      case 0:
        return LineChartWidgetCustom(
            isGrapgnLoading: provider.isgraphLoading,
            label: 'forecast',
            selectedFilter: provider.selectedFilter,
            stageData: provider.stageData ?? []);
      case 1:
        return BarChartWidget(
            isGrapgnLoading: provider.isgraphLoading,
            label: 'forecast',
            selectedFilter: provider.selectedFilter,
            stageData: provider.stageData ?? []);
      default:
        return const Center(child: Text('Select a Graph Type'));
    }
  }

  /// Builds the filter icon button.
  ///
  /// On press:
  /// - Opens bottom sheet filter options
  ///
  /// Uses:
  /// - [DashboardProvider] to apply selected filter
  Widget _buildFilterButton(BuildContext context, DashboardProvider provider) {
    return IconButton(
      icon: const Icon(Icons.tune),
      onPressed: () => _showFilterOptions(context, provider),
    );
  }

  /// Displays bottom sheet containing available lead report filters.
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
  /// On Apply:
  /// - Calls [DashboardProvider.applyFilter]
  /// - Updates selected graph metric
  void _showFilterOptions(BuildContext context, DashboardProvider provider) {
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

    FilterBottomSheet.show(
      context: context,
      filters: filters,
      onApply: (selectedFilter) {
        provider.applyFilter(selectedFilter);
      },
      selectedFilter: provider.selectedFilter,
      title: 'Select Filter',
      primaryColor: Theme.of(context).primaryColor,
    );
  }
}
