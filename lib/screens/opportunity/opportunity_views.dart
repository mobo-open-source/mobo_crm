import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:lottie/lottie.dart';
import 'package:mobo_crm/global_methods/widgets/custom_kanban_tile.dart';
import 'package:mobo_crm/global_methods/views/global_activity_view.dart';
import 'package:mobo_crm/global_methods/views/global_calendar_view.dart';
import 'package:mobo_crm/global_methods/views/global_kanban_view.dart';
import 'package:mobo_crm/global_methods/views/global_pivot_view.dart';
import 'package:mobo_crm/global_methods/widgets/custom_list_tile.dart';
import 'package:mobo_crm/global_methods/widgets/shimmer/custom_shimmer.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/lead/new_lead_form.dart';
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:provider/provider.dart';

import 'package:shimmer/shimmer.dart';

import '../../global_methods/services/global_error_handler.dart';
import '../../utils/globals.dart';
import 'opportunity_main_screen.dart';

/// ## OpportunityKanbanView
///
/// Displays the opportunities in a **Kanban board view**.
/// Supports filtering, grouping, empty states, and error handling.
/// Can also support pull-to-refresh via `onRefresh`.
class OpportunityKanbanView extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const OpportunityKanbanView({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Consumer3<OpportunityDataProvider, OdooClientManager,
        LeadFormProvider>(
      builder: (context, provider, clientmanager, formprovider, child) {
        Widget content = Column(
          children: [
            /// Kanban Board display
            Expanded(
              child: provider.isLoading && provider.opportunities.isEmpty
                  ? const KanbanShimmer()
                  : provider.catchError != null
                      ? ErrorScreen(
                          error: provider.catchError!,
                          onRetry: () {
                            provider.getOpportunities(
                                context: context,
                                isOpportunity: true,
                                isLead: false,
                                loading: true);
                          },
                        )
                      : (provider.isLoading == false &&
                              provider.opportunities.isEmpty)
                          ? Center(child: _buildEmptyState(context, provider))
                          : KanbanBoard<Map<dynamic, dynamic>>(
                              label: 'opportunities',
                              onRefresh: onRefresh,
                              data: provider.opportunities,
                              getCategory: (oppo) => oppo['stage_id'][1],
                              itemBuilder: (oppo) => KanbanTile(
                                isAdmin: provider.isAdmin,
                                onTap: () {
                                  formprovider.clearAll('opportunity');
                                  formprovider.init(oppo, context, false);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewLeadForm(lead: oppo),
                                    ),
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
                                      title: const Text('Delete Opportunity',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      content: Text(
                                        'Are you sure you want to delete this opportunity?',
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
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12)),
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
                                                    provider.deleteOpportunity(
                                                        oppo['id']);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppStyle.primaryColor,
                                                    foregroundColor:
                                                        Colors.white,
                                                    elevation: 0,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12)),
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
                                onPriorityChanged: (starIndex) async {
                                  final provider =
                                      Provider.of<OpportunityDataProvider>(
                                          context,
                                          listen: false);

                                  await provider.updatePriority(
                                    leadId: oppo['id'],
                                    newPriority: starIndex,
                                  );
                                },
                                tags: clientmanager.crmTagDetails,
                                lead: oppo,
                              ),
                            ),
            ),
          ],
        );

        return content;
      },
    );
  }

  /// Builds a centered Lottie animation for empty states or notifications.
  ///
  /// [lottie] : Path to Lottie asset
  /// [title] : Title text
  /// [subtitle] : Optional subtitle
  /// [button] : Optional button widget
  /// [isDark] : Dark mode indicator
  Widget _buildCenteredLottie({
    required String lottie,
    required String title,
    String? subtitle,
    Widget? button,
    required bool isDark,
  }) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            if (button != null) ...[const SizedBox(height: 16), button],
          ],
        ),
      ),
    );
  }

  /// Builds the empty state UI when there are no opportunities.
  ///
  /// Displays a Lottie animation and a "Clear All Filters" button if filters exist.
  Widget _buildEmptyState(
      BuildContext context, OpportunityDataProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filters = provider.selectedFilters;

    final hasActiveFilters = filters.isNotEmpty;

    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Opportunities Found',
      subtitle: hasActiveFilters ? 'Try adjusting your filter' : null,
      isDark: isDark,
      button: hasActiveFilters
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : AppStyle.primaryColor,
                side: BorderSide(
                    color: isDark ? Colors.grey[600]! : AppStyle.primaryColor,
                    width: 1.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final provider = Provider.of<OpportunityDataProvider>(context,
                    listen: false);

                provider.clearFilters(reload: true, context: context);

                final mainState = context
                    .findAncestorStateOfType<State<OpportunityMainScreen>>();
                if (mainState is OpportunityMainScreenState) {
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
}

/// ## OpportunityPivot
///
/// Displays opportunities in a **Pivot table view**.
/// Supports row/column/value mapping for analytical reporting.
/// Handles loading, errors, and empty states.
class OpportunityPivot extends StatelessWidget {
  const OpportunityPivot({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OpportunityDataProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "My Pipeline",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              buildViewSelector(context, provider),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<OpportunityDataProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.opportunities.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                } else if (provider.catchError != null) {
                  return ErrorScreen(
                    error: provider.catchError!,
                    onRetry: () {
                      provider.getOpportunities(
                          context: context,
                          isOpportunity: true,
                          isLead: false,
                          loading: true);
                    },
                  );
                } else if (provider.isLoading == false &&
                    provider.opportunities.isEmpty) {
                  return _buildEmptyState(context, provider);
                } else {
                  return PivotTable(
                    heading: 'Date',
                    label: 'lead',
                    data: provider.opportunities,
                    rowKey: "create_date",
                    columnKey: "stage_id",
                    valueKey: "expected_revenue",
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCenteredLottie({
    required String lottie,
    required String title,
    String? subtitle,
    Widget? button,
    required bool isDark,
  }) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            if (button != null) ...[const SizedBox(height: 16), button],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, OpportunityDataProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filters = provider.selectedFilters;

    final hasActiveFilters = filters.isNotEmpty;

    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Opportunities Found',
      subtitle: hasActiveFilters ? 'Try adjusting your filter' : null,
      isDark: isDark,
      button: hasActiveFilters
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : AppStyle.primaryColor,
                side: BorderSide(
                  color: isDark ? Colors.grey[600]! : AppStyle.primaryColor,
                  width: 1.5,
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
                final provider = Provider.of<OpportunityDataProvider>(context,
                    listen: false);

                provider.clearFilters(reload: true, context: context);

                final mainState = context
                    .findAncestorStateOfType<State<OpportunityMainScreen>>();
                if (mainState is OpportunityMainScreenState) {
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
}

/// ## OpportunityCalendar
///
/// Displays opportunities in a **calendar view**.
/// Pull-to-refresh supported.
class OpportunityCalendar extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const OpportunityCalendar({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Consumer<OpportunityDataProvider>(
      builder: (context, provider, child) {
        Widget calendarContent = Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: MyCalendarView(eventsData: provider.opportunities),
        );

        if (onRefresh != null) {
          return RefreshIndicator(
            color: Theme.of(context).primaryColor,
            backgroundColor: Colors.white,
            onRefresh: onRefresh!,
            child: calendarContent,
          );
        }

        return calendarContent;
      },
    );
  }
}

/// ## OpportunityActivity
///
/// Displays opportunities as an **activity feed**.
/// Each activity shows assigned user avatar, stage, revenue, and clickable for details.
/// Supports grouping, filters, errors, empty state, and pull-to-refresh.
class OpportunityActivity extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const OpportunityActivity({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Consumer3<OpportunityDataProvider, LeadFormProvider,
        OdooClientManager>(
      builder:
          (context, provider, opportunityformprovider, clientprovider, child) {
        Widget content = Column(
          children: [
            Expanded(
              child: provider.isLoading && provider.opportunities.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : provider.catchError != null
                      ? ErrorScreen(
                          error: provider.catchError!,
                          onRetry: () {
                            provider.getOpportunities(
                                context: context,
                                isOpportunity: true,
                                isLead: false,
                                loading: true);
                          },
                        )
                      : (provider.isLoading == false &&
                              provider.opportunities.isEmpty)
                          ? Center(child: _buildEmptyState(context, provider))
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: ActivityDataGrid(
                                itemBuilder: (opportunity) {
                                  return InkWell(
                                    onTap: () {
                                      opportunityformprovider
                                          .clearAll('opportunity');
                                      opportunityformprovider.init(
                                          opportunity, context, false);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NewLeadForm(lead: opportunity),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            opportunity['name'] ?? 'Unknown',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${opportunity['stage'] ?? ''} • ${opportunity['expected_revenue']?.toStringAsFixed(2) ?? '0.00'}',
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
                                data: provider.opportunities,
                                activityTypes: provider.activityNames,
                                activityColors: provider.activityStateColors,
                              ),
                            ),
            ),
          ],
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
      },
    );
  }

  Widget _buildCenteredLottie({
    required String lottie,
    required String title,
    String? subtitle,
    Widget? button,
    required bool isDark,
  }) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            if (button != null) ...[const SizedBox(height: 16), button],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, OpportunityDataProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filters = provider.selectedFilters;

    final hasActiveFilters = filters.isNotEmpty;

    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Opportunities Found',
      subtitle: hasActiveFilters ? 'Try adjusting your filter' : null,
      isDark: isDark,
      button: hasActiveFilters
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : AppStyle.primaryColor,
                side: BorderSide(
                  color: isDark ? Colors.grey[600]! : AppStyle.primaryColor,
                  width: 1.5,
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
                final provider = Provider.of<OpportunityDataProvider>(context,
                    listen: false);
                provider.clearFilters(reload: true, context: context);
                final mainState = context
                    .findAncestorStateOfType<State<OpportunityMainScreen>>();
                if (mainState is OpportunityMainScreenState) {
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
}

/// ## OpportunityListView
///
/// Displays opportunities in a **list view**.
/// Supports pagination, filters, grouping, errors, empty state, and pull-to-refresh.
class OpportunityListView extends StatefulWidget {
  final bool isPipeline;
  final Future<void> Function()? onRefresh;

  const OpportunityListView(
      {super.key, required this.isPipeline, this.onRefresh});

  @override
  State<OpportunityListView> createState() => _OpportunityListViewState();
}

class _OpportunityListViewState extends State<OpportunityListView> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<OpportunityDataProvider, LeadFormProvider,
        OdooClientManager>(
      builder: (context, provider, leadformprovider, odooinitprovider, child) {
        Widget content = Column(
          children: [
            Expanded(
              child: provider.isLoading && provider.opportunities.isEmpty
                  ? ListView.builder(
                      itemCount: 10,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (BuildContext context, int index) {
                        return const QuotationListTileShimmer();
                      },
                    )
                  : provider.catchError != null
                      ? ErrorScreen(
                          error: provider.catchError!,
                          onRetry: () {
                            provider.getOpportunities(
                                context: context,
                                isOpportunity: true,
                                isLead: false,
                                loading: true);
                          },
                        )
                      : provider.opportunities.isEmpty
                          ? Center(child: _buildEmptyState(context, provider))
                          : ListView.builder(
                              itemCount: provider.opportunities.length,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemBuilder: (context, index) {
                                final opportunity =
                                    provider.opportunities[index];
                                return LeadListTile(
                                  isAdmin: provider.isAdmin,
                                  lead: opportunity,
                                  onTap: () {
                                    leadformprovider.clearAll('opportunity');
                                    leadformprovider.init(
                                        opportunity, context, false);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewLeadForm(lead: opportunity),
                                      ),
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
                                        title: const Text(
                                            'Delete Opportunity',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        content: Text(
                                          'Are you sure you want to delete this opportunity?',
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
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      foregroundColor: AppStyle
                                                          .primaryColor,
                                                      side: BorderSide(
                                                          color: AppStyle
                                                              .primaryColor,
                                                          width: 1.5),
                                                      shape: RoundedRectangleBorder(
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
                                                      provider
                                                          .deleteOpportunity(
                                                              opportunity[
                                                                  'id']);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: AppStyle
                                                          .primaryColor,
                                                      foregroundColor:
                                                          Colors.white,
                                                      elevation: 0,
                                                      shape: RoundedRectangleBorder(
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
                                );
                              },
                            ),
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
    );
  }

  Widget _buildCenteredLottie({
    required String lottie,
    required String title,
    String? subtitle,
    Widget? button,
    required bool isDark,
  }) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            if (button != null) ...[const SizedBox(height: 16), button],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, OpportunityDataProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filters = provider.selectedFilters;

    final hasActiveFilters = filters.isNotEmpty;

    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Opportunities Found',
      subtitle: hasActiveFilters ? 'Try adjusting your filter' : null,
      isDark: isDark,
      button: hasActiveFilters
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : AppStyle.primaryColor,
                side: BorderSide(
                  color: isDark ? Colors.grey[600]! : AppStyle.primaryColor,
                  width: 1.5,
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
                final provider = Provider.of<OpportunityDataProvider>(context,
                    listen: false);
                provider.clearFilters(reload: true, context: context);
                final mainState = context
                    .findAncestorStateOfType<State<OpportunityMainScreen>>();
                if (mainState is OpportunityMainScreenState) {
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
}

/// ## ListtileShimmer
///
/// Shimmer animation placeholder for list tiles while data is loading.
class ListtileShimmer extends StatelessWidget {
  const ListtileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          color: Colors.white,
        ),
        title: Container(
          width: double.infinity,
          height: 16,
          color: Colors.white,
        ),
        subtitle: Container(
          width: double.infinity,
          height: 12,
          color: Colors.white,
        ),
      ),
    );
  }
}

Widget buildViewSelector(
    BuildContext context, OpportunityDataProvider provider) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final currentView = provider.viewItems[provider.selectedViewIndex];
  final screenWidth = MediaQuery.of(context).size.width;
  final isSmall = screenWidth < 400;

  final maxButtonWidth = screenWidth * (isSmall ? 0.28 : 0.32);

  return Container(
      constraints: BoxConstraints(minHeight: 35, maxWidth: maxButtonWidth),
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 8 : 12, vertical: 6),
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
          value: provider.selectedViewIndex,
          customButton: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                currentView['icon'],
                size: isSmall ? 16 : 18,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  currentView['label'],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmall ? 11 : 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                Icons.keyboard_arrow_down,
                size: isSmall ? 14 : 16,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ],
          ),
          items: provider.viewItems.asMap().entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Row(
                children: [
                  Icon(
                    entry.value['icon'],
                    size: 20,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    entry.value['label'],
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 300,
            width: 160,
            elevation: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                width: 1,
              ),
              color: isDark ? Colors.grey[900] : Colors.white,
            ),
          ),
          onChanged: (index) async {
            if (index != null && provider.selectedViewIndex != index) {
              provider.updateViewIndex(index);
              provider.resetPagination();

              final mainState =
                  context.findAncestorStateOfType<OpportunityMainScreenState>();
              if (mainState != null) {
                await provider.getOpportunities(
                  isOpportunity: true,
                  searchText: provider.searchController.text,
                  beforeMonthclose: mainState.filterPreviousMonthClose,
                  beforetwoMonthclose: mainState.filterTwoMonthsAgoClose,
                  monthNowclose: mainState.filterCurrentMonthClose,
                  unAssigned: mainState.filterUnassigned,
                  monthNow: mainState.filterCurrentMonth,
                  beforeMonth: mainState.filterPreviousMonth,
                  beforetwoMonth: mainState.filterTwoMonthsAgo,
                  lost: mainState.filterLost,
                  datefilters: mainState.hasCreationDateFilters,
                  ongoing: mainState.filterOngoing,
                  opeopportunity: mainState.filterOpenOpportunities,
                  partnerassigned: mainState.filterPartnerAssigned,
                  context: context,
                  isPipeline: mainState.filterByPipeline,
                  pipelinefilters: true,
                  stagefilters: mainState.hasStageFilters,
                  datefilterclose: mainState.hasClosingDateFilters,
                  won: mainState.filterWon,
                  customFilter: mainState.hasCustomFilters
                      ? mainState.customFilters
                      : null,
                  disablePagination: index == 0,
                  loading: true,
                );
              }
            }
          },
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
  );
}
