import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:mobo_crm/global_methods/widgets/custom_charts.dart';
import 'package:mobo_crm/global_methods/widgets/custom_kanban_tile.dart';
import 'package:mobo_crm/global_methods/views/global_calendar_view.dart';
import 'package:mobo_crm/global_methods/views/global_kanban_view.dart';
import 'package:mobo_crm/global_methods/views/global_pivot_view.dart';
import 'package:mobo_crm/global_methods/widgets/custom_list_tile.dart';
import 'package:mobo_crm/global_methods/widgets/shimmer/custom_shimmer.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';
import 'package:mobo_crm/screens/lead/new_lead_form.dart';
import 'package:mobo_crm/screens/lead/providers/lead_data_provider.dart';
import 'package:mobo_crm/global_methods/views/global_activity_view.dart';
import 'package:provider/provider.dart';

import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';

import '../../global_methods/services/global_error_handler.dart';
import '../../utils/globals.dart';
import 'lead_main_screen.dart';

/// Displays the Leads in an activity-based grid view.
///
/// Shows:
/// - Lead name and assigned user avatar
/// - Current stage and expected revenue
/// - Activity state indicators (late/today/future)
///
/// Features:
/// - Pull-to-refresh support via [onRefresh]
/// - Tapping a lead opens the lead form in view/edit mode
/// - Handles session-based avatar loading from Odoo server
///
/// Params:
/// - [onRefresh]: Optional refresh callback for pull-to-refresh
class LeadActivity extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const LeadActivity({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Consumer3<LeadDataProvider, LeadFormProvider, OdooClientManager>(
        builder: (context, provider, leadformprovider, clientprovider, child) {
      Widget content = Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ActivityDataGrid(
            itemBuilder: (lead) {
              return InkWell(
                onTap: () {
                  leadformprovider.clearAll('lead');
                  Navigator.push(
                    context,
                    SlidingPageTransitionRL(
                        page: NewLeadForm(
                      lead: lead,
                      type: 'lead',
                    )),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lead['name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${lead['stage'] ?? ''} • ${lead['expected_revenue']?.toStringAsFixed(2) ?? '0.00'}',
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
            },
            label: 'lead',
            data: provider.leads,
            activityTypes: provider.activityNames,
            activityColors: provider.activityStateColors),
      );

      if (onRefresh != null) {
        return RefreshIndicator(
          color: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          onRefresh: onRefresh!,
          child: content,
        );
      }

      return content;
    });
  }
}

/// Displays analytics for Leads using charts (Line, Bar, Pie).
///
/// Allows switching between:
/// - Line chart
/// - Bar chart
/// - Pie chart
///
/// Supports filtering metrics:
/// - Count
/// - Expected Revenue
/// - Probability
/// - Recurring Revenue
///
/// Features:
/// - Pull-to-refresh support via [onRefresh]
/// - Metric selection via dropdown
/// - Chart type toggle buttons
class LeadGraphWidget extends StatefulWidget {
  final Future<void> Function()? onRefresh;

  const LeadGraphWidget({super.key, this.onRefresh});

  @override
  State<LeadGraphWidget> createState() => _LeadGraphWidgetState();
}

class _LeadGraphWidgetState extends State<LeadGraphWidget> {

  @override
  Widget build(BuildContext context) {
    return Consumer<LeadDataProvider>(
      builder: (context, provider, child) {
        Widget content;

        if (provider.isLoading) {
          content = Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        } else {
          content = Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    height: 500,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _buildGraph(provider),
                  ),
                ],
              ),
            ),
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

  /// Builds the chart widget based on the selected graph type.
  ///
  /// 0 → Line Chart
  /// 1 → Bar Chart
  /// 2 → Pie Chart
  Widget _buildGraph(LeadDataProvider provider) {
    switch (provider.graphViewIndex) {
      case 0:
        return LineChartWidgetCustom(
            isGrapgnLoading: provider.isLoading,
            label: 'leads',
            selectedFilter: provider.selectedFilterLead,
            stageData: provider.stageData ?? []);
      case 1:
        return BarChartWidget(
            isGrapgnLoading: provider.isLoading,
            label: 'leads',
            selectedFilter: provider.selectedFilterLead,
            stageData: provider.stageData ?? []);
      default:
        return const Center(child: Text('Select a Graph Type'));
    }
  }

  /// Builds the dropdown used to select the metric for graphs.
  ///
  /// Example metrics:
  /// - Count
  /// - Expected Revenue
  /// - Probability
  /// - Recurring Revenue
}

/// Displays leads in a Kanban board grouped by stage.
///
/// Features:
/// - Kanban columns by stage
/// - Drag & drop style layout
/// - Empty state with Lottie animation
/// - Error state with retry
/// - Pull-to-refresh support via [onRefresh]
///
/// Tapping a card opens the lead form screen.
class LeadKanbanScreen extends StatefulWidget {
  final Future<void> Function()? onRefresh;

  const LeadKanbanScreen({super.key, this.onRefresh});

  @override
  State<LeadKanbanScreen> createState() => _LeadKanbanScreenState();
}

class _LeadKanbanScreenState extends State<LeadKanbanScreen> {
  Widget _buildTopLottie({
    required String lottie,
    required String title,
    String? subtitle,
    Widget? button,
    required bool isDark,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = MediaQuery.of(context).size.height;
        final isSmall = screenHeight < 700;
        final topPad = isSmall ? 16.0 : 32.0;
        final lottieWidth = isSmall ? 180.0 : 240.0;
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(top: topPad),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(lottie, width: lottieWidth),
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
                if (button != null) ...[const SizedBox(height: 16), button],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds the empty state UI when no leads are available.
  ///
  /// Shows:
  /// - Lottie animation
  /// - "Clear All Filters" action when filters are active
  Widget _buildEmptyState(BuildContext context, LeadDataProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filters = provider.selectedFilters;

    final hasActiveFilters = filters.isNotEmpty;

    return _buildTopLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Leads Found',
      subtitle: hasActiveFilters ? 'Try adjusting your filter' : null,
      isDark: isDark,
      button: hasActiveFilters
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : AppStyle.primaryColor,
                side: BorderSide(
                  color: isDark
                      ? Colors.grey[600]!
                      : AppStyle.primaryColor, width: 1.5
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final provider =
                    Provider.of<LeadDataProvider>(context, listen: false);
                provider.clearFilters(reload: true, context: context);
                final mainState =
                    context.findAncestorStateOfType<State<LeadMainScreen>>();
                if (mainState is LeadMainScreenState) {
                  mainState.resetLocalFilterFlags();
                }
              },
              child: Text(
                'Clear All Filters',
                style: TextStyle(
                  color: isDark ? Colors.white : AppStyle.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            )
          : null,
    );
  }

  /// Builds the top bar showing:
  /// - Active filters count
  /// - Current group-by selection
  /// - Loading indicator

  @override
  Widget build(BuildContext context) {
    return Consumer3<LeadDataProvider, OdooClientManager, LeadFormProvider>(
        builder: (context, provider, clientmanager, leadformprovider, child) {
      Widget content = Column(
        children: [
          Expanded(
            child: provider.isLoading && provider.leads.isEmpty
                ? KanbanShimmer()
                : provider.leadError != null
                    ? ErrorScreen(
                        error: provider.leadError!,
                        onRetry: () {
                          provider.getLeads(context: context, loading: true);
                        },
                      )
                    : (provider.isLoading == false && provider.leads.isEmpty)
                        ? _buildEmptyState(context, provider)
                        : KanbanBoard<Map<dynamic, dynamic>>(
                            label: 'leads',
                            onRefresh: widget.onRefresh,
                            data: provider.leads,
                            getCategory: (lead) => lead['stage_id'] != null
                                ? lead['stage_id'][1]
                                : 'None',
                            itemBuilder: (lead) => KanbanTile(
                              isAdmin: provider.isAdmin,
                              onTap: () {
                                leadformprovider.clearAll('lead');
                                Navigator.push(
                                  context,
                                  SlidingPageTransitionRL(
                                      page: NewLeadForm(
                                    lead: lead,
                                    type: 'lead',
                                  )),
                                );
                              },
                              onDelete: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    backgroundColor: Colors.white,
                                    title: const Text('Delete Lead',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    content: Text(
                                      'Are you sure you want to delete this lead?',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                          height: 1.4),
                                    ),
                                    actions: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              height: 48,
                                              child: OutlinedButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx),
                                                style:
                                                    OutlinedButton.styleFrom(
                                                  foregroundColor:
                                                      AppStyle.primaryColor,
                                                  side: BorderSide(
                                                      color: AppStyle
                                                          .primaryColor,
                                                      width: 1.5),
                                                  shape:
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                ),
                                                child: Text('Cancel',
                                                    style: TextStyle(
                                                        color: AppStyle
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16)),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: SizedBox(
                                              height: 48,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(ctx);
                                                  provider.deleteLead(
                                                      lead['id']);
                                                },
                                                style:
                                                    ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppStyle.primaryColor,
                                                  foregroundColor:
                                                      Colors.white,
                                                  elevation: 0,
                                                  shape:
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                ),
                                                child: const Text('Delete',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onPriorityChanged: (starIndex) async{
                                await provider.updatePriority(
                                  leadId: lead['id'],
                                  newPriority: starIndex,
                                );
                              },
                              tags: clientmanager.crmTagDetails,
                              lead: lead,
                            ),
                          ),
          ),
        ],
      );

      return content;
    });
  }
}

/// Pivot (cross-tab) view summarising leads by stage.
class LeadsPivot extends StatelessWidget {
  const LeadsPivot({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<LeadDataProvider>(builder: (context, provider, child) {
        if (provider.isLoading && provider.leads.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        } else {
          return PivotTable(
            heading: 'Date',
            label: 'lead',
            data: provider.leads,
            rowKey: "create_date",
            columnKey: "stage_id",
            valueKey: "expected_revenue",
          );
        }
      }),
    );
  }
}

/// Displays leads on a calendar view based on their dates.
///
/// Useful for:
/// - Tracking lead creation or closing dates
/// - Visual timeline overview
///
/// Features:
/// - Pull-to-refresh support via [onRefresh]
class LeadsCalendar extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const LeadsCalendar({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Consumer<LeadDataProvider>(builder: (context, provider, child) {
      Widget content = Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: MyCalendarView(eventsData: provider.leads),
      );

      if (onRefresh != null) {
        return RefreshIndicator(
          color: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          onRefresh: onRefresh!,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: content,
            ),
          ),
        );
      }

      return content;
    });
  }
}

/// Displays leads in a scrollable list view.
///
/// Features:
/// - Pagination controls
/// - Pull-to-refresh support via [onRefresh]
/// - Shimmer loading state
/// - Error handling with retry
/// - Empty state with filter reset
/// - Search filtering by lead name or customer
class LeadListView extends StatefulWidget {
  final Future<void> Function()? onRefresh;

  const LeadListView({super.key, this.onRefresh});

  @override
  State<LeadListView> createState() => _LeadListViewState();
}

class _LeadListViewState extends State<LeadListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Filters leads locally based on search text.
  ///
  /// Matches against:
  /// - Lead name
  /// - Customer/partner name
  List<Map<dynamic, dynamic>> _getFilteredLeads(
      List<Map<dynamic, dynamic>> leads) {
    final provider = Provider.of<LeadDataProvider>(context, listen: false);
    final searchText = provider.searchController.text.trim().toLowerCase();

    if (searchText.isEmpty) return leads;

    return leads.where((lead) {
      final name = lead['name']?.toString().toLowerCase() ?? '';
      final partner = lead['partner_name']?.toString().toLowerCase() ?? '';

      return name.contains(searchText) || partner.contains(searchText);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.grey[900] : Colors.grey[50];

    return Container(
      color: backgroundColor,
      child: Consumer3<LeadDataProvider, LeadFormProvider, OdooClientManager>(
        builder:
            (context, provider, leadformprovider, odooclientprovider, child) {
          Widget content = Column(
            children: [
              Expanded(
                child: provider.isLoading && provider.leads.isEmpty
                    ? _buildShimmerList()
                    : provider.leadError != null
                        ? ErrorScreen(
                            error: provider.leadError!,
                            onRetry: () {
                              provider.getLeads(
                                  context: context, loading: true);
                            },
                          )
                        : provider.isLoading == false && provider.leads.isEmpty
                            ? _buildEmptyState(context, provider)
                            : () {
                                final filteredLeads =
                                    _getFilteredLeads(provider.leads);
                                final searchText =
                                    provider.searchController.text.trim();

                                if (filteredLeads.isEmpty &&
                                    searchText.isNotEmpty) {
                                  return _buildNoSearchResults(isDark);
                                }

                                return _buildLeadsList(
                                    filteredLeads, leadformprovider, provider);
                              }(),
              ),
            ],
          );

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
      ),
    );
  }

  /// Builds shimmer loading list while leads are being fetched.
  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) => const QuotationListTileShimmer(),
    );
  }

  Widget _buildTopLottie({
    required String lottie,
    required String title,
    String? subtitle,
    Widget? button,
    required bool isDark,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = MediaQuery.of(context).size.height;
        final isSmall = screenHeight < 700;
        final topPad = isSmall ? 16.0 : 32.0;
        final lottieWidth = isSmall ? 180.0 : 240.0;
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(top: topPad),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(lottie, width: lottieWidth),
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
                if (button != null) ...[const SizedBox(height: 16), button],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Displays a friendly empty state when no leads are found.
  ///
  /// If filters are active, shows a "Clear All Filters" button.
  Widget _buildEmptyState(BuildContext context, LeadDataProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filters = provider.selectedFilters;

    final hasActiveFilters = filters.isNotEmpty;

    return _buildTopLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Leads Found',
      subtitle: hasActiveFilters ? 'Try adjusting your filter' : null,
      isDark: isDark,
      button: hasActiveFilters
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : AppStyle.primaryColor,
                side: BorderSide(
                  color: isDark
                      ? Colors.grey[600]!
                      : AppStyle.primaryColor, width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final provider =
                    Provider.of<LeadDataProvider>(context, listen: false);
                provider.clearFilters(reload: true, context: context);
                final mainState =
                    context.findAncestorStateOfType<State<LeadMainScreen>>();
                if (mainState is LeadMainScreenState) {
                  mainState.resetLocalFilterFlags();
                }
              },
              child: Text(
                'Clear All Filters',
                style: TextStyle(
                  color: isDark ? Colors.white : AppStyle.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            )
          : null,
    );
  }

  /// Displays UI when search returns no matching leads.
  Widget _buildNoSearchResults(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'No matching leads',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.grey[800],
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search terms',
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadsList(List<Map<dynamic, dynamic>> leads,
      LeadFormProvider leadformprovider, LeadDataProvider leadProvider) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: leads.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final lead = leads[index];
        return LeadListTile(
          lead: lead,
          isAdmin: leadProvider.isAdmin,
          onTap: () {
            leadformprovider.clearAll('lead');
            Navigator.push(
              context,
              SlidingPageTransitionRL(
                page: NewLeadForm(
                  lead: lead,
                  type: 'lead',
                ),
              ),
            ).then((result) {
              if (result == true) {
                widget.onRefresh?.call();
              }
            });
          },
          onDelete: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                backgroundColor: Colors.white,
                title: const Text('Delete Lead',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                content: Text(
                  'Are you sure you want to delete this lead?',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.4),
                ),
                actions: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppStyle.primaryColor,
                              side: BorderSide(
                                  color: AppStyle.primaryColor,
                                  width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                            ),
                            child: Text('Cancel',
                                style: TextStyle(
                                    color: AppStyle.primaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              leadProvider.deleteLead(lead['id']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyle.primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                            ),
                            child: const Text('Delete',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
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
}
