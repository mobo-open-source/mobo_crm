import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobo_crm/global_methods/bottom_sheets/filter_design_bottomsheet.dart';
import 'package:mobo_crm/global_methods/views/global_activity_view.dart';
import 'package:mobo_crm/global_methods/views/global_calendar_view.dart';
import 'package:mobo_crm/global_methods/views/global_kanban_view.dart';
import 'package:mobo_crm/global_methods/widgets/custom_charts.dart';
import 'package:mobo_crm/global_methods/widgets/custom_kanban_tile.dart';
import 'package:mobo_crm/global_methods/widgets/custom_list_tile.dart';
import 'package:mobo_crm/global_methods/widgets/shimmer/custom_shimmer.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/lead/new_lead_form.dart';
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';
import 'package:mobo_crm/screens/myActivities/activity/provider/activity_data_provider.dart';

import 'package:provider/provider.dart';

/// A scrollable list view widget that displays all activities in a list format.
///
/// Uses [ActivityDataProvider] to fetch activity data and [LeadFormProvider] to handle lead-specific operations.
/// Handles empty state and loading state with Lottie animations and shimmer effects.
class MyActivityListView extends StatelessWidget {
  final Future<void> Function()? onRefresh;
  const MyActivityListView({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Consumer3<ActivityDataProvider, OdooClientManager, LeadFormProvider>(
        builder: (context, provider, clientprovider, leadformprovider, child) {
      if (provider.isLoading) {
        return ListView(
          children: List.generate(10, (_) => const ListtileShimmer()),
        );
      } else if (provider.activityData.isEmpty && provider.isLoading == false) {
        return _buildEmptyState(context);
      } else {
        Widget content = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: provider.activityData.length,
            itemBuilder: (BuildContext context, int index) {
              final myActivity = provider.activityData[index];
              return CustomOpportunityTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      SlidingPageTransitionRL(
                        page: NewLeadForm(lead: myActivity),
                      ),
                    );
                  },
                  opportunity: myActivity['name'] ?? "UnKnown",
                  contactName: myActivity['contact_name'] ?? "N/A",
                  email: myActivity['email_from'] ?? "N/A",
                  expectedRevenue:
                      myActivity['expected_revenue'].toStringAsFixed(2) ??
                          "0.0",
                  stage: myActivity['stage_id'] is List
                      ? myActivity['stage_id'][1]
                      : "N/A");
            },
          ),
        );

        if (onRefresh != null) {
          return RefreshIndicator(
            onRefresh: onRefresh!,
            color: Theme.of(context).primaryColor,
            child: content,
          );
        }
        return content;
      }
    });
  }

  /// Builds a centered Lottie animation with optional title, subtitle, and button.
  ///
  /// [lottie] : Path to the Lottie animation file.
  /// [title] : Primary text shown above the animation.
  /// [subtitle] : Optional secondary text.
  /// [button] : Optional widget displayed below text (e.g., action button).
  /// [isDark] : Determines color theme based on brightness.
  Widget _buildCenteredLottie({
    required String lottie,
    required String title,
    String? subtitle,
    Widget? button,
    required bool isDark,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(lottie, width: 260),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                  if (button != null) ...[const SizedBox(height: 12), button],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the empty state view with a Lottie animation.
  /// Shown when the provider has no activities.
  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Activities Found',
      isDark: isDark,
    );
  }
}

/// Kanban-style view for activities.
///
/// Displays activities in categorized columns based on their stage.
/// Uses [ActivityDataProvider] and supports empty/loading states.
class ActivityKanbanView extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const ActivityKanbanView({
    super.key,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer3<ActivityDataProvider, OdooClientManager, LeadFormProvider>(
        builder: (context, provider, clientmanager, leadformprovider, child) {
      if (provider.isLoading && provider.activityData.isEmpty) {
        return const KanbanShimmer();
      } else if (provider.activityData.isEmpty && provider.isLoading == false) {
        return _buildEmptyState(context);
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: KanbanBoard<Map<dynamic, dynamic>>(
            label: 'opportunities',
            onRefresh: onRefresh,
            data: provider.activityData,
            getCategory: (myActivity) => myActivity['stage_id'][1],
            itemBuilder: (myActivity) => KanbanTile(
              isAdmin: provider.isAdmin,
              onTap: () {
                Navigator.push(
                  context,
                  SlidingPageTransitionRL(
                    page: NewLeadForm(lead: myActivity),
                  ),
                );
              },
              onDelete: (){
                provider.deleteLead(myActivity['id']);
              },
              tags: clientmanager.crmTagDetails,
              lead: myActivity,
            ),
          ),
        );
      }
    });
  }

  /// Builds a centered Lottie animation with title/subtitle.
  Widget _buildCenteredLottie({
    required String lottie,
    required String title,
    String? subtitle,
    Widget? button,
    required bool isDark,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(lottie, width: 260),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                  if (button != null) ...[const SizedBox(height: 12), button],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Shows empty state when no Kanban data exists.
  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Activities Found',
      isDark: isDark,
    );
  }
}

/// Graphical representation of activity metrics.
///
/// Supports line, bar, and pie chart visualizations. Users can toggle chart types
/// and apply filters such as "Count", "Expected Revenue", etc.
class MyActivityGraphWidget extends StatefulWidget {
  const MyActivityGraphWidget({super.key});

  @override
  State<MyActivityGraphWidget> createState() => _MyActivityGraphWidgetState();
}

class _MyActivityGraphWidgetState extends State<MyActivityGraphWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityDataProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      _buildFilterButton(context, provider),
                      const Spacer(),
                      ToggleButtons(
                        isSelected: List.generate(
                            3, (i) => i == provider.selectedIndexActivity),
                        onPressed: (int newIndex) {
                          setState(() {
                            provider.selectedIndexActivity = newIndex;
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
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(child: _buildGraph(provider)),
              ],
            ),
          );
        }
      },
    );
  }

  /// Builds the selected graph based on the provider's `selectedIndexActivity`.
  Widget _buildGraph(ActivityDataProvider provider) {
    switch (provider.selectedIndexActivity) {
      case 0:
        return LineChartWidgetCustom(
            isGrapgnLoading: provider.isLoading,
            label: 'leads',
            selectedFilter: provider.selectedFilter,
            stageData: provider.activityGraphData);
      case 1:
        return BarChartWidget(
            isGrapgnLoading: provider.isLoading,
            label: 'leads',
            selectedFilter: provider.selectedFilter,
            stageData: provider.activityGraphData);
      default:
        return const Center(child: Text('Select a Graph Type'));
    }
  }

  /// Filter button icon displayed above the graph. Opens filter selection bottom sheet.
  Widget _buildFilterButton(
      BuildContext context, ActivityDataProvider provider) {
    return IconButton(
      icon: const Icon(Icons.tune),
      onPressed: () => _showFilterOptions(context, provider),
    );
  }

  /// Displays the filter selection bottom sheet.
  void _showFilterOptions(BuildContext context, ActivityDataProvider provider) {
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

/// Calendar view showing activity events.
///
/// Uses [MyCalendarView] to render activities on a calendar.
/// Handles loading and empty states with Lottie animations.
class MyActivityCalendarView extends StatelessWidget {
  const MyActivityCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityDataProvider>(builder: (context, provider, child) {
      if (provider.isLoading && provider.activityData.isEmpty) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        );
      } else if (provider.isLoading == false && provider.activityData.isEmpty) {
        return _buildEmptyState(context);
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: MyCalendarView(eventsData: provider.activityData),
        );
      }
    });
  }

  Widget _buildCenteredLottie({
    required String lottie,
    required String title,
    String? subtitle,
    Widget? button,
    required bool isDark,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(lottie, width: 260),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                  if (button != null) ...[const SizedBox(height: 12), button],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Activities Found',
      isDark: isDark,
    );
  }
}

/// Schedule view displaying activities in a detailed data grid format.
///
/// Each activity shows assigned user (avatar), stage, expected revenue, and name.
/// Supports tap to open activity details in [NewLeadForm].
class MyActivityScheduleView extends StatelessWidget {
  const MyActivityScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<ActivityDataProvider, LeadFormProvider, OdooClientManager>(
        builder: (context, provider, leadformprovider, clientprovider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: ActivityDataGrid(
            itemBuilder: (myActivity) {
              if (provider.isLoading && provider.activityData.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              } else if (provider.isLoading == false &&
                  provider.activityData.isEmpty) {
                return _buildEmptyState(context);
              } else {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      SlidingPageTransitionRL(
                        page: NewLeadForm(lead: myActivity),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          myActivity['name'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${myActivity['stage'] ?? ''} • ${myActivity['expected_revenue']?.toStringAsFixed(2) ?? '0.00'}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
            label: 'lead',
            data: provider.activityData,
            activityTypes: provider.activityNames,
            activityColors: provider.activityStateColors),
      );
    });
  }

  Widget _buildCenteredLottie({
    required String lottie,
    required String title,
    String? subtitle,
    Widget? button,
    required bool isDark,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(lottie, width: 260),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                  if (button != null) ...[const SizedBox(height: 12), button],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Activities Found',
      isDark: isDark,
    );
  }
}
