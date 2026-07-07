import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:mobo_crm/global_methods/widgets/custom_charts.dart';
import 'package:mobo_crm/global_methods/views/global_activity_view.dart';
import 'package:mobo_crm/global_methods/views/global_calendar_view.dart';
import 'package:mobo_crm/global_methods/views/global_kanban_view.dart';
import 'package:mobo_crm/global_methods/views/global_pivot_view.dart';
import 'package:mobo_crm/global_methods/widgets/shimmer/custom_shimmer.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/quotation/quotation_main_screen.dart';
import 'package:mobo_crm/screens/quotation/widgets/components/custom_components.dart';
import 'package:mobo_crm/screens/quotation/new_quotation_form.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_form_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_view_provider.dart';

import 'package:provider/provider.dart';

import '../../global_methods/services/global_error_handler.dart';
import '../../global_methods/widgets/group_by_dropdown.dart';
import '../../utils/globals.dart';

/// Displays quotations in an activity / timeline style view (similar to chatter/activity stream).
///
/// Shows a list of quotations with their current stage, expected revenue, customer,
/// and associated activity indicators. Supports tapping to open the quotation detail/form.
///
/// Uses [ActivityDataGrid] for rendering items with activity badges.
class QuotationActivityView extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const QuotationActivityView({super.key, this.onRefresh});

  /// Builds a centered illustration + message (used for empty, error, module missing states)
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

  /// Builds the empty state UI with "No Quotations Found" message
  /// and optional "Clear All Filters" button when filters are active.
  Widget _buildEmptyState(
      BuildContext context, QuotationViewProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filters = provider.selectedFilters;
    final hasActiveFilters = filters.isNotEmpty;

    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Quotations Found',
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
                final quotationProvider =
                    Provider.of<QuotationViewProvider>(context, listen: false);
                final mainState =
                    context.findAncestorStateOfType<QuotationMainScreenState>();
                final clientProvider =
                    Provider.of<OdooClientManager>(context, listen: false);
                mainState?.resetLocalFilterFlags();

                quotationProvider.setGroupBy(GroupByOption.none);
                quotationProvider.selectedFilters = [];
                quotationProvider.clearCustomFilters();
                await quotationProvider.getQuotationsAndReport(
                  context: context,
                  loading: true,
                  session: clientProvider.currentsession,
                  searchText: quotationProvider.searchController.text,
                  isQuotation: false,
                  isSale: false,
                  isPipeline: true,
                  showCreationDate: false,
                  currentMonth: false,
                  previousMonth: false,
                  twoMonthsBefore: false,
                  customFilterRules: null,
                );
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

  @override
  Widget build(BuildContext context) {
    return Consumer3<QuotationViewProvider, QuotationFormProvider,
            OdooClientManager>(
        builder: (context, provider, formprovider, clientprovider, child) {
      Widget content;

      if (provider.isLoading) {
        content = ListView.builder(
          itemCount: 10,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemBuilder: (context, index) => const QuotationListTileShimmer(),
        );
      } else if (!formprovider.isSaleInstalled) {
        content = _buildCenteredLottie(
          lottie: 'assets/Error_404.json',
          title: 'Sale module is not installed',
          subtitle: 'Pull to refresh or tap retry after enable it',
          isDark: false,
          button: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppStyle.primaryColor,
              side: BorderSide(
                color: AppStyle.primaryColor,
                width: 1.5,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              provider.checkSaleModuleInstallation(clientprovider.client!);
              provider.getQuotationsAndReport(
                  loading: true,
                  context: context,
                  session: clientprovider.currentsession!);
            },
            child: Text(
              'Retry',
              style: TextStyle(
                color: AppStyle.primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        );
      } else if (provider.quoteError != null) {
        content = ErrorScreen(
          error: provider.quoteError!,
          onRetry: () {
            provider.getQuotationsAndReport(
                loading: true,
                context: context,
                session: clientprovider.currentsession!);
          },
        );
      } else if (provider.allQuotation.isEmpty) {
        content = _buildEmptyState(context, provider);
      } else {
        content = Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ActivityDataGrid(
              itemBuilder: (quote) {
                return InkWell(
                  onTap: () async {
                    final quotationId = quote['id'] as int;
                    bool shouldProceed = true;
                    try {
                      final exists = await formprovider.validateQuotationExists(
                          quotationId, clientprovider.client!);

                      if (!exists) {
                        shouldProceed = false;
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Quotation #$quotationId not found. It may have been deleted.'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 8,
                              action: SnackBarAction(
                                label: 'Refresh',
                                textColor: Colors.white,
                                onPressed: () {
                                  provider.getQuotationsAndReport(
                                    context: context,
                                    session: clientprovider.currentsession,
                                    isQuotation: true,
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      shouldProceed = true;
                    }

                    if (shouldProceed && context.mounted) {
                      formprovider.fetchAndReplaceOrderLines(
                          loading: true,
                          quotationId,
                          clientprovider.client!,
                          clientprovider.currentsession!,
                          formprovider.productlinedata,
                          context,
                          currentCountryId: clientprovider.countryId);

                      Navigator.push(
                          context,
                          SlidingPageTransitionRL(
                              page: NewQuotationForm(
                            leadid: quote['opportunity_id'] == false
                                ? null
                                : quote['opportunity_id'],
                            ordersaleid: quotationId,
                          )));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quote['name'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${quote['stage'] ?? ''} • ${quote['expected_revenue']?.toStringAsFixed(2) ?? '0.00'}',
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
              label: 'quotation',
              data: provider.allQuotation,
              activityTypes: provider.activityNames,
              activityColors: provider.activityStateColors),
        );
      }

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

/// Pivot table view for quotations (aggregates data by date_order)
class QuotationPivotView extends StatelessWidget {
  const QuotationPivotView({super.key});

  /// Default empty state widget
  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Quotations Found',
      isDark: isDark,
    );
  }

  /// Builds centered empty state with Lottie animation
  Widget _buildCenteredLottie({
    required String lottie,
    required String title,
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuotationViewProvider>(builder: (context, provider, child) {
      if (provider.isLoading && provider.allQuotation.isEmpty) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        );
      } else if (provider.isLoading == false && provider.allQuotation.isEmpty) {
        return Center(child: _buildEmptyState(context));
      } else {
        return PivotTable(
            subHeading: 'Total',
            data: provider.allQuotation,
            rowKey: 'date_order',
            heading: 'Date',
            columnKey: 'Total',
            valueKey: 'amount',
            label: 'quotation');
      }
    });
  }
}

/// Classic list view of quotations with search filtering, shimmer loading,
/// empty state, module-not-installed warning, and error screen.
class QuotationListView extends StatefulWidget {
  final Future<void> Function()? onRefresh;

  const QuotationListView({super.key, this.onRefresh});

  @override
  State<QuotationListView> createState() => _QuotationListViewState();
}

class _QuotationListViewState extends State<QuotationListView> {
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

  /// Filters the quotation list based on the current search text in provider
  List<Map<dynamic, dynamic>> _getFilteredQuotations(
      List<Map<dynamic, dynamic>> quotations) {
    final provider = Provider.of<QuotationViewProvider>(context, listen: false);
    final searchText = provider.searchController.text.trim().toLowerCase();

    if (searchText.isEmpty) return quotations;

    return quotations.where((quotation) {
      final name = quotation['name']?.toString().toLowerCase() ?? '';
      final partner =
          quotation['partner_id'] is List && quotation['partner_id'].length > 1
              ? quotation['partner_id'][1].toString().toLowerCase()
              : '';

      return name.contains(searchText) || partner.contains(searchText);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.grey[900] : Colors.grey[50];

    return Container(
      color: backgroundColor,
      child: Consumer<QuotationViewProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildShimmerList();
          }

          final filteredQuotations =
              _getFilteredQuotations(provider.allQuotation);

          return _buildQuotationsList(filteredQuotations);
        },
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) => const QuotationListTileShimmer(),
    );
  }

  /// Reusable centered lottie + message widget (empty, module missing, etc.)
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

  /// Empty state with "Clear Filters" button when filters are active
  Widget _buildEmptyState(
      BuildContext context, QuotationViewProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filters = provider.selectedFilters;
    final hasActiveFilters = filters.isNotEmpty;

    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Quotations Found',
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
                final quotationProvider =
                    Provider.of<QuotationViewProvider>(context, listen: false);
                final mainState =
                    context.findAncestorStateOfType<QuotationMainScreenState>();
                final clientProvider =
                    Provider.of<OdooClientManager>(context, listen: false);
                mainState?.resetLocalFilterFlags();
                quotationProvider.setGroupBy(GroupByOption.none);
                quotationProvider.selectedFilters = [];
                quotationProvider.clearCustomFilters();
                await quotationProvider.getQuotationsAndReport(
                  context: context,
                  loading: true,
                  session: clientProvider.currentsession,
                  searchText: quotationProvider.searchController.text,
                  isQuotation: false,
                  isSale: false,
                  isPipeline: true,
                  showCreationDate: false,
                  currentMonth: false,
                  previousMonth: false,
                  twoMonthsBefore: false,
                  customFilterRules: null,
                );
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

  /// Main content: top chips bar + list of [QuotationListTile]
  Widget _buildQuotationsList(List<Map<dynamic, dynamic>> quotations) {
    return Consumer3<QuotationFormProvider, QuotationViewProvider,
        OdooClientManager>(
      builder: (context, formprovider, viewprovider, clientprovider, child) {
        Widget content = Column(
          children: [
            Expanded(
              child: (!formprovider.isSaleInstalled)
                  ? _buildCenteredLottie(
                      lottie: 'assets/Error_404.json',
                      title: 'Sale module is not installed',
                      subtitle: 'Pull to refresh or tap retry after enable it',
                      isDark: false,
                      button: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppStyle.primaryColor,
                          side: BorderSide(
                            color: AppStyle.primaryColor,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          viewprovider.checkSaleModuleInstallation(
                              clientprovider.client!);
                          viewprovider.getQuotationsAndReport(
                              loading: true,
                              context: context,
                              session: clientprovider.currentsession!);
                        },
                        child: Text(
                          'Retry',
                          style: TextStyle(
                            color: AppStyle.primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  : (viewprovider.hasError && viewprovider.quoteError != null)
                      ? ErrorScreen(
                          error: viewprovider.quoteError!,
                          onRetry: () {
                            viewprovider.getQuotationsAndReport(
                                loading: true,
                                context: context,
                                session: clientprovider.currentsession!);
                          },
                        )
                      : (viewprovider.allQuotation.isEmpty)
                          ? _buildEmptyState(context, viewprovider)
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _scrollController,
                              itemCount: quotations.length,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemBuilder: (context, index) {
                                final quotation = quotations[index];
                                final activityType =
                                    quotation['activity_type_id'] != null &&
                                            quotation['activity_type_id']
                                                is List
                                        ? quotation['activity_type_id'][1]
                                        : null;

                                final activityState =
                                    quotation['activity_state'] ?? 'unknown';

                                return QuotationListTile(
                                  quotation: quotation,
                                  activityType: activityType,
                                  activityState: activityState,
                                  onTap: () async {
                                    final quotationId = quotation['id'] as int;
                                    bool shouldProceed = true;
                                    try {
                                      final exists = await formprovider
                                          .validateQuotationExists(quotationId,
                                              clientprovider.client!);

                                      if (!exists) {
                                        shouldProceed = false;
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Quotation #$quotationId not found. It may have been deleted.'),
                                              backgroundColor: Colors.red,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              elevation: 8,
                                              action: SnackBarAction(
                                                label: 'Refresh',
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  viewprovider
                                                      .getQuotationsAndReport(
                                                    context: context,
                                                    session: clientprovider
                                                        .currentsession,
                                                    isQuotation: true,
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    } catch (e) {
                                      shouldProceed = true;
                                    }

                                    if (shouldProceed && context.mounted) {
                                      formprovider.fetchAndReplaceOrderLines(
                                        loading: true,
                                        isQuoteBuilder: false,
                                        quotationId,
                                        clientprovider.client!,
                                        clientprovider.currentsession!,
                                        formprovider.productlinedata,
                                        context,
                                        currentCountryId:
                                            clientprovider.countryId,
                                      );

                                      Navigator.push(
                                        context,
                                        SlidingPageTransitionRL(
                                          page: NewQuotationForm(
                                            leadid: quotation[
                                                        'opportunity_id'] ==
                                                    false
                                                ? null
                                                : quotation['opportunity_id'],
                                            ordersaleid: quotationId,
                                          ),
                                        ),
                                      ).then((result) {
                                        if (result == true) {
                                          viewprovider.getQuotationsAndReport(
                                              loading: true,
                                              context: context,
                                              session: clientprovider
                                                  .currentsession!);
                                        }
                                      });
                                    }
                                  },
                                );
                              },
                            ),
            ),
          ],
        );

        if (widget.onRefresh != null) {
          return RefreshIndicator(
            onRefresh: widget.onRefresh!,
            color: Theme.of(context).primaryColor,
            child: content,
          );
        }
        return content;
      },
    );
  }

  /// Navigates to previous page and refreshes data.
  void _goToPreviousPage(
      QuotationViewProvider provider, OdooClientManager odooInitProvider) {
    provider.goToPreviousPage(
      context: context,
      client: odooInitProvider.client!,
      session: odooInitProvider.currentsession!,
    );
  }

  /// Navigates to next page and refreshes data.
  void _goToNextPage(
      QuotationViewProvider provider, OdooClientManager odooInitProvider) {
    provider.goToNextPage(
      context: context,
      client: odooInitProvider.client!,
      session: odooInitProvider.currentsession!,
    );
  }

  /// Shows number of active filters + current group-by dimension (if any)
}

/// Kanban board view organized by quotation state (draft, sent, cancelled, etc.)
class QuotationKanbanView extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const QuotationKanbanView({super.key, this.onRefresh});

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
      BuildContext context, QuotationViewProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filters = provider.selectedFilters;
    final hasActiveFilters = filters.isNotEmpty;

    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Quotations Found',
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
                final quotationProvider =
                    Provider.of<QuotationViewProvider>(context, listen: false);
                final mainState =
                    context.findAncestorStateOfType<QuotationMainScreenState>();
                final clientProvider =
                    Provider.of<OdooClientManager>(context, listen: false);
                mainState?.resetLocalFilterFlags();
                quotationProvider.setGroupBy(GroupByOption.none);
                quotationProvider.selectedFilters = [];
                quotationProvider.clearCustomFilters();
                await quotationProvider.getQuotationsAndReport(
                  context: context,
                  loading: true,
                  session: clientProvider.currentsession,
                  searchText: quotationProvider.searchController.text,
                  isQuotation: false,
                  isSale: false,
                  isPipeline: true,
                  showCreationDate: false,
                  currentMonth: false,
                  previousMonth: false,
                  twoMonthsBefore: false,
                  customFilterRules: null,
                );
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

  @override
  Widget build(BuildContext context) {
    return Consumer3<QuotationViewProvider, QuotationFormProvider,
            OdooClientManager>(
        builder: (context, provider, quoteprovider, clientprovider, child) {
      Widget content;
      if (provider.isLoading) {
        content = KanbanShimmer();
      } else if (!quoteprovider.isSaleInstalled) {
        content = _buildCenteredLottie(
          lottie: 'assets/Error_404.json',
          title: 'Sale module is not installed',
          subtitle: 'Pull to refresh or tap retry after enable it',
          isDark: false,
          button: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppStyle.primaryColor,
              side: BorderSide(
                color: AppStyle.primaryColor,
                width: 1.5,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              provider.checkSaleModuleInstallation(clientprovider.client!);
              provider.getQuotationsAndReport(
                  loading: true,
                  context: context,
                  session: clientprovider.currentsession!);
            },
            child: Text(
              'Retry',
              style: TextStyle(
                color: AppStyle.primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        );
      } else if (provider.quoteError != null) {
        content = ErrorScreen(
          error: provider.quoteError!,
          onRetry: () {
            provider.getQuotationsAndReport(
                loading: true,
                context: context,
                session: clientprovider.currentsession!);
          },
        );
      } else if (provider.allQuotation.isEmpty) {
        content = _buildEmptyState(context, provider);
      } else {
        content = KanbanBoard(
            data: provider.allQuotation,
            onRefresh: onRefresh,
            label: "quotation",
            getCategory: (qoute) => qoute['state'],
            itemBuilder: (qoute) => QuotationKanbanTile(
                  quotation: qoute,
                  onTap: () async {
                    final quotationId = qoute['id'] as int;
                    bool shouldProceed = true;
                    try {
                      final exists =
                          await quoteprovider.validateQuotationExists(
                              quotationId, clientprovider.client!);

                      if (!exists) {
                        shouldProceed = false;
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Quotation #$quotationId not found. It may have been deleted.'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 8,
                              action: SnackBarAction(
                                label: 'Refresh',
                                textColor: Colors.white,
                                onPressed: () {
                                  provider.getQuotationsAndReport(
                                    context: context,
                                    session: clientprovider.currentsession,
                                    isQuotation: true,
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      shouldProceed = true;
                    }

                    if (shouldProceed && context.mounted) {
                      quoteprovider.fetchAndReplaceOrderLines(
                          loading: true,
                          quotationId,
                          clientprovider.client!,
                          clientprovider.currentsession!,
                          quoteprovider.productlinedata,
                          context,
                          currentCountryId: clientprovider.countryId);

                      Navigator.push(
                          context,
                          SlidingPageTransitionRL(
                              page: NewQuotationForm(
                            leadid: qoute['opportunity_id'] == false
                                ? null
                                : qoute['opportunity_id'],
                            ordersaleid: quotationId,
                          )));
                    }
                  },
                ));
      }

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

/// Calendar view showing quotations (likely based on date_order or validity date)
class QuotationCalendarView extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const QuotationCalendarView({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuotationViewProvider>(builder: (context, provider, child) {
      Widget content = Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: MyCalendarView(eventsData: provider.allQuotation),
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

/// Graph/analytics view for quotations — supports line, bar and pie charts
class QuotationGraphView extends StatefulWidget {
  final Future<void> Function()? onRefresh;

  const QuotationGraphView({
    super.key,
    this.onRefresh,
  });

  @override
  State<QuotationGraphView> createState() => _QuotationGraphViewState();
}

class _QuotationGraphViewState extends State<QuotationGraphView> {
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
      BuildContext context, QuotationViewProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filters = provider.selectedFilters;
    final hasActiveFilters = filters.isNotEmpty;

    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Quotations Found',
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
                final quotationProvider =
                    Provider.of<QuotationViewProvider>(context, listen: false);
                final mainState =
                    context.findAncestorStateOfType<QuotationMainScreenState>();
                final clientProvider =
                    Provider.of<OdooClientManager>(context, listen: false);
                mainState?.resetLocalFilterFlags();
                quotationProvider.setGroupBy(GroupByOption.none);
                quotationProvider.selectedFilters = [];
                quotationProvider.clearCustomFilters();
                await quotationProvider.getQuotationsAndReport(
                  context: context,
                  loading: true,
                  session: clientProvider.currentsession,
                  searchText: quotationProvider.searchController.text,
                  isQuotation: false,
                  isSale: false,
                  isPipeline: true,
                  showCreationDate: false,
                  currentMonth: false,
                  previousMonth: false,
                  twoMonthsBefore: false,
                  customFilterRules: null,
                );
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

  @override
  Widget build(BuildContext context) {
    return Consumer2<QuotationViewProvider, OdooClientManager>(
        builder: (context, provider, clientprovider, child) {
      Widget content;

      if (provider.isLoading) {
        content = Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        );
      } else if (!provider.isSaleInstalled) {
        content = _buildCenteredLottie(
          lottie: 'assets/Error_404.json',
          title: 'Sale module is not installed',
          subtitle: 'Pull to refresh or tap retry after enable it',
          isDark: false,
          button: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppStyle.primaryColor,
              side: BorderSide(
                color: AppStyle.primaryColor.withValues(alpha: 0.3),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              provider.checkSaleModuleInstallation(clientprovider.client!);
              provider.getQuotationsAndReport(
                  loading: true,
                  context: context,
                  session: clientprovider.currentsession!);
            },
            child: Text(
              'Retry',
              style: TextStyle(
                color: AppStyle.primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        );
      } else if (provider.quoteError != null) {
        content = ErrorScreen(
          error: provider.quoteError!,
          onRetry: () {
            provider.getQuotationsAndReport(
                loading: true,
                context: context,
                session: clientprovider.currentsession!);
          },
        );
      } else if (provider.allQuotation.isEmpty) {
        content = _buildEmptyState(context, provider);
      } else {
        content = Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 550,
                  child: Container(
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
                    child: _buildGraph(
                      provider,
                    ),
                  ),
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
    });
  }

  /// Returns the correct chart widget based on specific index
  Widget _buildGraph(QuotationViewProvider provider) {
    switch (provider.graphViewIndex) {
      case 0:
        return LineChartWidgetCustom(
            isGrapgnLoading: provider.isLoading,
            label: 'quotation',
            selectedFilter: provider.selectedFilterQuotation,
            stageData: provider.quoteData ?? []);
      case 1:
        return BarChartWidget(
            isGrapgnLoading: provider.isLoading,
            label: 'quotation',
            selectedFilter: provider.selectedFilterQuotation,
            stageData: provider.quoteData ?? []);
      default:
        return const Center(child: Text('Select a Graph Type'));
    }
  }
}
