import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/global_methods/views/global_activity_view.dart';
import 'package:mobo_crm/global_methods/widgets/group_by_dropdown.dart';
import 'package:mobo_crm/global_methods/widgets/shimmer/custom_shimmer.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/customers/new_customer_form_screen.dart';
import 'package:mobo_crm/screens/customers/provider/customer_form_provider.dart';
import 'package:mobo_crm/screens/customers/customers_main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../global_methods/services/global_error_handler.dart';
import '../../utils/app_theme.dart';
import '../../utils/globals.dart';
import 'provider/customer_data_provider.dart';

/// Displays customers in a paginated list or grouped view.
///
/// Features:
/// - Infinite scroll with manual pagination
/// - Pull-to-refresh support
/// - Group-by functionality (country, state, category, etc.)
/// - Filter indicators and clear filter option
/// - Loading shimmer placeholders
/// - Error state handling
/// - Empty state with Lottie animation
/// - Customer avatar loading via Odoo session
///
/// Depends on:
/// - CustomerDataProvider (data + filters + pagination)
/// - OdooClientManager (session + image loading)
/// - CustomerFormProvider (form reset before navigation)
///
/// Acts as the main grid/list view for customers.
class CustomerGridScreen extends StatefulWidget {
  const CustomerGridScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomerGridScreenState createState() => _CustomerGridScreenState();
}

/// Manages UI state for CustomerGridScreen.
///
/// Responsibilities:
/// - Scroll controller lifecycle
/// - Rendering grouped or ungrouped layouts
/// - Handling pagination controls
/// - Rendering customer cards
/// - Handling navigation to customer form
class _CustomerGridScreenState extends State<CustomerGridScreen> {
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

  /// Builds empty state UI when:
  /// - No customers exist
  /// - Filters return zero results
  ///
  /// Shows:
  /// - Lottie animation
  /// - Context-aware subtitle
  /// - Clear filter button (if filters active)
  Widget _buildEmptyState(BuildContext context, CustomerDataProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filters = CustomerFilterState.getActiveFilters();

    final hasActiveFilters = filters.isNotEmpty;

    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Customers Found',
      subtitle: hasActiveFilters ? 'Try adjusting your filter' : null,
      isDark: isDark,
      button: hasActiveFilters
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : AppStyle.primaryColor,
                side: BorderSide(
                    color: isDark
                        ? Colors.grey[600]!
                        : AppStyle.primaryColor.withValues(alpha: 0.3),
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
                final provider =
                    Provider.of<CustomerDataProvider>(context, listen: false);
                provider.clearFilters(reload: true, context: context);
                final mainState = context
                    .findAncestorStateOfType<State<CustomersMainScreen>>();
                if (mainState is CustomersMainScreenState) {
                  mainState.resetLocalFilterFlags();
                }
              },
              child: Text(
                'Clear All Filters',
                style: TextStyle(
                  color: isDark ? Colors.white : AppStyle.primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          : null,
    );
  }

  /// Reusable centered Lottie layout.
  ///
  /// Parameters:
  /// - [lottie] : Asset path
  /// - [title] : Main heading
  /// - [subtitle] : Optional description
  /// - [button] : Optional action button
  /// - [isDark] : Theme brightness flag
  ///
  /// Ensures vertical centering with scroll fallback.
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

  @override
  Widget build(BuildContext context) {
    return Consumer3<CustomerDataProvider, OdooClientManager,
        CustomerFormProvider>(
      builder: (context, provider, odooInitProvider, formprovider, child) {
        if (provider.isLoading && provider.customers.isEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return const CustomerCardShimmer();
            },
          );
        }
        if (provider.currentGroupBy != CustomerGroupByOption.none) {
          return _buildGroupedView(provider, odooInitProvider, formprovider);
        }

        return Column(
          children: [
            _buildTopPaginationBar(provider, odooInitProvider),
            Expanded(
              child: (provider.hasError && provider.customerError != null)
                  ? ErrorScreen(
                      error: provider.customerError!,
                      onRetry: () {
                        provider.fetchCustomerData(
                          loading: true,
                          context: context,
                        );
                      },
                    )
                  : (provider.isLoading == false && provider.customers.isEmpty)
                      ? _buildEmptyState(context, provider)
                      : RefreshIndicator(
                          onRefresh: () async {
                            await provider.fetchCustomerData(
                              loading: false,
                              context: context,
                              searchText: provider.searchcontroller.text,
                            );
                          },
                          color: Theme.of(context).primaryColor,
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            itemCount: provider.customers.length,
                            itemBuilder: (context, index) {
                              final customer = provider.customers[index];
                              return buildCustomerCard(context, customer,
                                  odooInitProvider, formprovider);
                            },
                          ),
                        ),
            ),
          ],
        );
      },
    );
  }

  /// Builds top bar containing:
  /// - Active filter indicator
  /// - Current group-by label
  /// - Pagination info (start-end / total)
  /// - Previous/Next page controls
  ///
  /// Shows loading indicator when data is fetching.
  Widget _buildTopPaginationBar(
      CustomerDataProvider provider, OdooClientManager odooInitProvider) {
    if (provider.isLoading) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    final activeFilters = CustomerFilterState.getActiveFilters();
    final hasGroupBy = provider.currentGroupBy != CustomerGroupByOption.none;
    final hasActiveFilters = activeFilters.isNotEmpty;

    final paginationControls = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Text(
            "${provider.startRecord}-${provider.endRecord} / ${provider.totalCount}",
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        if (provider.totalPages > 1) ...[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InkWell(
              onTap: provider.hasPreviousPage
                  ? () => _goToPreviousPage(provider, odooInitProvider)
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                child: Icon(
                  HugeIcons.strokeRoundedArrowLeft01,
                  size: 20,
                  color: provider.hasPreviousPage ? Colors.grey[700] : Colors.grey[400],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InkWell(
              onTap: provider.hasNextPage
                  ? () => _goToNextPage(provider, odooInitProvider)
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                child: Icon(
                  HugeIcons.strokeRoundedArrowRight01,
                  size: 20,
                  color: provider.hasNextPage ? Colors.grey[700] : Colors.grey[400],
                ),
              ),
            ),
          ),
        ],
      ],
    );

    Widget leftContent;
    if (!hasActiveFilters && !hasGroupBy) {
      leftContent = Text(
        "No filters applied",
        style: TextStyle(
          fontSize: 12.5,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      );
    } else {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final List<Widget> chips = [];

      if (hasActiveFilters) {
        chips.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: isDark ? Colors.grey[400]! : Colors.black,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  activeFilters.length.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      if (hasGroupBy) {
        String groupName = provider.currentGroupBy.toString().split('.').last;
        groupName = groupName[0].toUpperCase() + groupName.substring(1);
        const displayNames = {
          'stage': 'Stage',
          'salesperson': 'Salesperson',
          'team': 'Team',
          'priority': 'Priority',
          'partner': 'Customer',
          'country': 'Country',
          'createDate': 'Creation Date',
          'expectedRevenue': 'Expected Revenue',
          'probability': 'Probability',
        };
        groupName = displayNames[groupName.toLowerCase()] ?? groupName;
        chips.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedLayer,
                  size: 14,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 50),
                  child: Text(
                    groupName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      leftContent = Wrap(spacing: 10, runSpacing: 8, children: chips);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: leftContent,
            ),
          ),
          paginationControls,
        ],
      ),
    );
  }

  /// Returns only the groups for the current page
  /// when in grouped view mode.
  Map<String, List<Map<dynamic, dynamic>>> _getPagedGroups(
      CustomerDataProvider provider) {
    final allGroups = provider.groupedCustomers;
    final groupKeys = allGroups.keys.toList();

    final startIndex = provider.currentPage * provider.limit;
    final endIndex = (startIndex + provider.limit).clamp(0, groupKeys.length);

    final pagedGroupKeys = groupKeys.sublist(startIndex, endIndex);

    Map<String, List<Map<dynamic, dynamic>>> pagedGroups = {};
    for (String key in pagedGroupKeys) {
      pagedGroups[key] = allGroups[key]!;
    }

    return pagedGroups;
  }

  /// Returns number of groups shown on the current page.
  int _getPagedGroupCount(CustomerDataProvider provider) {
    final allGroupCount = provider.groupedCustomers.keys.length;
    final startIndex = provider.currentPage * provider.limit;
    final endIndex = (startIndex + provider.limit).clamp(0, allGroupCount);

    return endIndex - startIndex;
  }

  /// Navigates to previous page and refreshes data.
  void _goToPreviousPage(
      CustomerDataProvider provider, OdooClientManager odooInitProvider) {
    provider.goToPreviousPage(
      context: context,
      client: odooInitProvider.client!,
    );
  }

  /// Navigates to next page and refreshes data.
  void _goToNextPage(
      CustomerDataProvider provider, OdooClientManager odooInitProvider) {
    provider.goToNextPage(
      context: context,
      client: odooInitProvider.client!,
    );
  }

  /// Builds grouped customer list view.
  ///
  /// Each group:
  /// - Has collapsible header
  /// - Displays group icon
  /// - Shows count badge
  /// - Expands to show customer cards
  ///
  /// Supports pagination at group level.
  Widget _buildGroupedView(CustomerDataProvider provider,
      OdooClientManager odooInitProvider, CustomerFormProvider formprovider) {
    Widget content = Column(
      children: [
        _buildTopPaginationBar(provider, odooInitProvider),
        Expanded(
          child: (provider.hasError && provider.customerError != null)
              ? ErrorScreen(
                  error: provider.customerError!,
                  onRetry: () {
                    provider.fetchCustomerData(
                      loading: true,
                      context: context,
                    );
                  },
                )
              : (provider.isLoading == false && provider.customers.isEmpty)
                  ? _buildEmptyState(context, provider)
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 4, bottom: 16),
                      itemCount: _getPagedGroupCount(provider),
                      itemBuilder: (context, index) {
                        final pagedGroups = _getPagedGroups(provider);
                        final groupKey = pagedGroups.keys.elementAt(index);
                        final groupCustomers = pagedGroups[groupKey]!;
                        final isExpanded =
                            provider.groupExpansionState[groupKey] ?? true;

                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
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
                                  InkWell(
                                    onTap: () =>
                                        provider.toggleGroupExpansion(groupKey),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  groupKey.isEmpty
                                                      ? 'Undefined'
                                                      : groupKey,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${groupCustomers.length} customer${groupCustomers.length != 1 ? 's' : ''}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            isExpanded
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                            color: Colors.black87,
                                          ),
                                        ],
                                      ),
                                    ),
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
                                        children: groupCustomers
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          final customerIndex = entry.key;
                                          final customer = entry.value;
                                          return Column(
                                            children: [
                                              buildCustomerCard(
                                                context,
                                                customer,
                                                odooInitProvider,
                                                formprovider,
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
                          ),
                        );
                      },
                    ),
        ),
      ],
    );

    return RefreshIndicator(
      onRefresh: () async {
        await provider.fetchCustomerData(
          loading: false,
          context: context,
          searchText: provider.searchcontroller.text,
        );
      },
      color: Theme.of(context).primaryColor,
      child: content,
    );
  }

  /// Builds customer avatar.
  ///
  /// Logic:
  /// - Loads image from Odoo `/web/image` endpoint
  /// - Sends session cookie header
  /// - Shows shimmer while loading
  /// - Falls back to colored initial avatar on error
  ///
  /// Parameters:
  /// - [customer] : Customer map data
  /// - [odooInitProvider] : Session manager
  /// - [size] : Avatar size
  Widget _buildCustomerAvatar(
      Map<dynamic, dynamic> customer, OdooClientManager odooInitProvider,
      {double size = 50}) {
    final name = customer['name'] ?? '';
    final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : "?";
    final userId = customer['id'] ?? 0;
    final bgColor = avatarColors[userId % avatarColors.length];

    final fallbackAvatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        firstLetter,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: size * 0.36,
          color: Colors.white,
        ),
      ),
    );

    if (odooInitProvider.currentsession?.sessionId == null ||
        (odooInitProvider.url?.isEmpty ?? true) ||
        customer['id'] == null) {
      return fallbackAvatar;
    }

    return CachedNetworkImage(
      imageUrl:
          "${odooInitProvider.url}/web/image/res.partner/${customer['id']}/image_128",
      httpHeaders: {
        "Cookie": "session_id=${odooInitProvider.currentsession!.sessionId}",
      },
      width: size,
      height: size,
      fit: BoxFit.cover,
      imageBuilder: (context, imageProvider) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
        ),
      ),
      errorWidget: (context, url, error) => fallbackAvatar,
    );
  }

  Widget buildStatItem(IconData icon, String value, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors().subHeading),
        const SizedBox(width: 2),
        Text(
          "($value)",
          style: TextStyle(fontSize: 13, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  /// Builds individual customer card.
  ///
  /// Displays:
  /// - Avatar
  /// - Name
  /// - Phone
  /// - Location (city, country)
  /// - Type badge (Company / Customer)
  ///
  /// On tap:
  /// - Clears form provider state
  /// - Navigates to NewCustomerFormScreen
  Widget buildCustomerCard(BuildContext context, Map customer,
      OdooClientManager odooInitProvider, CustomerFormProvider formprovider,
      {bool isGrouped = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final city = customer['city'];
    final country =
        customer['country_id'] != null ? customer['country_id'][1] : null;

    final locationText = [
      if (city != null && city.toString().trim().isNotEmpty) city.toString(),
      if (country != null && country.toString().trim().isNotEmpty)
        country.toString(),
    ].join(', ');

    final isCompany = customer['is_company'] == true;
    final customerType = isCompany ? 'Company' : 'Customer';
    final badgeColor = isCompany ? StatusColors.statusBlue : StatusColors.statusGreen;

    final hasPhone = customer['phone'] != null &&
        customer['phone'].toString().isNotEmpty &&
        customer['phone'].toString() != 'false';

    return Container(
      margin: isGrouped
          ? const EdgeInsets.only(bottom: 8)
          : const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[850]! : Colors.grey[200]!,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            offset: const Offset(0, 6),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            formprovider.clearAll();
            Navigator.push(
                context,
                SlidingPageTransitionRL(
                    page: NewCustomerFormScreen(
                  customerData: customer,
                )));
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: AppStyle.primaryColor.withOpacity(0.08),
          highlightColor: AppStyle.primaryColor.withOpacity(0.04),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildCustomerAvatar(customer, odooInitProvider),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer['name'] ?? 'No Name',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : AppStyle.primaryColor,
                          letterSpacing: -0.1,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        hasPhone
                            ? customer['phone'].toString()
                            : 'No phone number',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey[300] : Colors.grey[600],
                          fontStyle: hasPhone
                              ? FontStyle.normal
                              : FontStyle.italic,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        locationText.isNotEmpty
                            ? locationText
                            : 'No address available',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey[300] : Colors.grey[600],
                          fontStyle: locationText.isNotEmpty
                              ? FontStyle.normal
                              : FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                StatusColors.buildStatusBadge(
                  customerType,
                  badgeColor,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns a short 2-letter country code abbreviation for display.
  String _countryCode(String country) {
    if (country.length <= 3) return country.toUpperCase();
    const map = {
      'United States': 'US',
      'United Kingdom': 'UK',
      'India': 'IN',
      'Germany': 'DE',
      'France': 'FR',
      'Canada': 'CA',
      'Australia': 'AU',
      'China': 'CN',
      'Japan': 'JP',
      'Brazil': 'BR',
    };
    return map[country] ?? country.substring(0, 2).toUpperCase();
  }
}

/// Displays customer activities in a data grid layout.
///
/// Features:
/// - Loading state indicator
/// - Empty state handling
/// - Avatar image loading via Odoo
/// - Activity color and state mapping
///
/// Used inside activity tab for customers.
class CustomerActivity extends StatelessWidget {
  const CustomerActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CustomerDataProvider, OdooClientManager>(
        builder: (context, provider, clientprovider, child) {
      if (provider.isLoading && provider.customers.isEmpty) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        );
      } else if (provider.isLoading == false && provider.customers.isEmpty) {
        return _buildEmptyState(context, provider);
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ActivityDataGrid(
              itemBuilder: (customer) {
                return InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      customer['name'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                );
              },
              label: 'lead',
              data: provider.customers,
              activityTypes: provider.activityNames,
              activityColors: provider.activityStateColors),
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

  /// Builds empty state for activity view.
  /// Reuses same Lottie-centered layout logic.
  Widget _buildEmptyState(BuildContext context, CustomerDataProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filters = CustomerFilterState.getActiveFilters();

    final hasActiveFilters = filters.isNotEmpty;

    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Customers Found',
      subtitle: hasActiveFilters ? 'Try adjusting your filter' : null,
      isDark: isDark,
      button: hasActiveFilters
          ? OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : AppStyle.primaryColor,
                side: BorderSide(
                    color: isDark
                        ? Colors.grey[600]!
                        : AppStyle.primaryColor,
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
                final provider =
                    Provider.of<CustomerDataProvider>(context, listen: false);
                provider.clearFilters(reload: true, context: context);
                final mainState = context
                    .findAncestorStateOfType<State<CustomersMainScreen>>();
                if (mainState is CustomersMainScreenState) {
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
