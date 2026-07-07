import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mobo_crm/global_methods/widgets/custom_charts.dart';
import 'package:mobo_crm/screens/dashboard/provider/dashboard_provider.dart';
import 'package:mobo_crm/global_methods/widgets/tag_chips.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/global_methods/views/global_pivot_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

/// Main Activities dashboard screen.
///
/// Features:
/// - Initializes activity analytics on load
/// - Provides tab navigation between:
///   • Graph View
///   • Pivot View
///   • List View
/// - Supports advanced filtering using bottom sheet filters
///
/// Integrates with:
/// - [DashboardProvider] for activity data
/// - [OdooClientManager] for API access
///
/// Uses Provider for state management and dynamic UI updates.
class ActivitiesView extends StatefulWidget {
  const ActivitiesView({super.key});

  @override
  State<ActivitiesView> createState() => _ActivitiesViewState();
}

/// State class for [ActivitiesView].
///
/// Responsibilities:
/// - Initializes dashboard activity data
/// - Manages selected tab index
/// - Controls filter state values
/// - Triggers API calls with selected filters
/// - Displays bottom sheet filter modal
class _ActivitiesViewState extends State<ActivitiesView> {
  @override
  void initState() {
    Provider.of<DashboardProvider>(context, listen: false).setFiltertoCount();
    Provider.of<DashboardProvider>(context, listen: false)
        .initActivity(context);
    super.initState();
  }

  int _selectedIndex = 0;
  final List<Widget> widgets = [
    const ActivitiesGraph(),
    const ActivityPivot(),
    const ActivitiesListView()
  ];

  final List<IconData> iconsTabs = [
    Icons.bar_chart,
    Icons.grid_on,
    Icons.list,
  ];

  bool isLead = false;
  bool isOpportunity = false;
  bool trial12Months = true;
  bool isWon = false;
  bool showCompletionDate = false;
  bool currentMonthBool = false;
  bool previousMonthBool = false;
  bool twoMonthsBeforeBool = false;

  /// Displays a modal bottom sheet for filtering activities.
  ///
  /// Filters include:
  /// - Lead
  /// - Opportunity
  /// - 12 months Trialing
  /// - Won status
  /// - Completion date (Current month, Previous month, Two months ago)
  ///
  /// On apply:
  /// - Updates local filter state
  /// - Calls [DashboardProvider.getActivityReport]
  /// - Refreshes activity analytics
  void showFilterBottomSheet(BuildContext context) {
    DateTime now = DateTime.now();
    String currentMonth = DateFormat('MMMM yyyy').format(now);
    String previousMonth =
        DateFormat('MMMM yyyy').format(DateTime(now.year, now.month - 1, 1));
    String twoMonthsAgo =
        DateFormat('MMMM yyyy').format(DateTime(now.year, now.month - 2, 1));

    bool tempIsLead = isLead;
    bool tempIsOpportunity = isOpportunity;
    bool tempIsWon = isWon;
    bool tempTrialing12Months = trial12Months;
    bool tempcurrentMonth = currentMonthBool;
    bool tempPrevoius = previousMonthBool;
    bool tempTwoMonthsBefore = twoMonthsBeforeBool;

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
                      title: Text('Lead',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      value: tempIsLead,
                      activeColor: Theme.of(context).primaryColor,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setModalState(() {
                          tempIsLead = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Opportunity',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      value: tempIsOpportunity,
                      activeColor: Theme.of(context).primaryColor,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setModalState(() {
                          tempIsOpportunity = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('12 months Trialing',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      value: tempTrialing12Months,
                      activeColor: Theme.of(context).primaryColor,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setModalState(() {
                          tempTrialing12Months = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Won',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      value: tempIsWon,
                      activeColor: Theme.of(context).primaryColor,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setModalState(() {
                          tempIsWon = value ?? false;
                        });
                      },
                    ),
                    ExpansionTile(
                      initiallyExpanded: showCompletionDate,
                      title: Text("Completion Date",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      collapsedBackgroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Theme.of(context).primaryColor,
                      iconColor: Theme.of(context).primaryColor,
                      children: [
                        CheckboxListTile(
                          title: Text(currentMonth,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                          value: tempcurrentMonth,
                          activeColor: Theme.of(context).primaryColor,
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setModalState(() {
                              tempcurrentMonth = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(previousMonth,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                          value: tempPrevoius,
                          activeColor: Theme.of(context).primaryColor,
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setModalState(() {
                              tempPrevoius = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(twoMonthsAgo,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                          value: tempTwoMonthsBefore,
                          activeColor: Theme.of(context).primaryColor,
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setModalState(() {
                              tempTwoMonthsBefore = value ?? false;
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
                            foregroundColor: Theme.of(context).primaryColor,
                          ),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLead = tempIsLead;
                              isOpportunity = tempIsOpportunity;
                              trial12Months = tempTrialing12Months;
                              isWon = tempIsWon;
                              currentMonthBool = tempcurrentMonth;
                              previousMonthBool = tempPrevoius;
                              twoMonthsBeforeBool = tempTwoMonthsBefore;
                              if (tempcurrentMonth ||
                                  tempPrevoius ||
                                  tempTwoMonthsBefore) {
                                showCompletionDate = true;
                              } else {
                                showCompletionDate = false;
                              }
                              final client = Provider.of<OdooClientManager>(
                                      context,
                                      listen: false)
                                  .client;
                              Provider.of<DashboardProvider>(context,
                                      listen: false)
                                  .getActivityReport(
                                      currentMonth: currentMonthBool,
                                      previousMonth: previousMonthBool,
                                      twoMonthsbefore: twoMonthsBeforeBool,
                                      isWon: isWon,
                                      client: client!,
                                      isLead: isLead,
                                      isOpportunity: isOpportunity,
                                      trial12Months: trial12Months);
                              Navigator.pop(context);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
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
    return Consumer<OdooClientManager>(
        builder: (context, clientprovider, child) {
      return Column(
        children: [
          Row(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(iconsTabs.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
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
                          iconsTabs[index],
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
                onPressed: () => showFilterBottomSheet(context),
              ),
              Spacer()
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

/// Displays graphical analytics for activities.
///
/// Supports multiple chart types:
/// - Line chart
/// - Bar chart
/// - Pie chart
///
/// Uses activity data from [DashboardProvider].
class ActivitiesGraph extends StatefulWidget {
  const ActivitiesGraph({
    super.key,
  });

  @override
  State<ActivitiesGraph> createState() => _ActivitiesGraphState();
}

/// State class for [ActivitiesGraph].
///
/// Manages:
/// - Selected graph type
/// - Chart rendering logic
/// - Filter selection for graph metrics
class _ActivitiesGraphState extends State<ActivitiesGraph> {
  int selectedIndexActivity = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
        builder: (context, dashbordprovider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  buildFilterAndToggle(dashbordprovider),
                  const Spacer(),
                  ToggleButtons(
                    isSelected:
                        List.generate(3, (i) => i == selectedIndexActivity),
                    onPressed: (int newIndex) {
                      setState(() {
                        selectedIndexActivity = newIndex;
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
            Expanded(
              child: _buildGraph(
                dashbordprovider,
              ),
            ),
          ],
        ),
      );
    });
  }

  /// Builds and returns the selected chart widget.
  ///
  /// Graph types:
  /// 0 → Line chart
  /// 1 → Bar chart
  /// 2 → Pie chart
  ///
  /// Displays loading state when graph data is being fetched.
  Widget _buildGraph(DashboardProvider provider) {
    switch (selectedIndexActivity) {
      case 0:
        return LineChartWidgetCustom(
            isGrapgnLoading: provider.isgraphLoading,
            label: 'activities',
            selectedFilter: provider.selectedFilter,
            stageData: provider.activityData!);
      case 1:
        return BarChartWidget(
            isGrapgnLoading: provider.isgraphLoading,
            label: 'activities',
            selectedFilter: provider.selectedFilter,
            stageData: provider.activityData!);
      default:
        return const Center(child: Text('Select a Graph Type'));
    }
  }

  /// Builds the filter icon and toggle controls
  /// for switching between graph types.
  Widget buildFilterAndToggle(DashboardProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.tune),
          onPressed: () => showFilterOptions(context, provider),
        ),
      ],
    );
  }

  /// Displays bottom sheet for selecting activity metric filters.
  ///
  /// Currently supports:
  /// - Count
  ///
  /// Applies selected filter using [DashboardProvider.applyFilter].
  void showFilterOptions(BuildContext context, DashboardProvider provider) {
    final filters = [
      "Count",
    ];

    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: filters
                .map((filter) => ListTile(
                      trailing: provider.selectedFilter == filter
                          ? Icon(
                              Icons.check,
                              color: Theme.of(context).primaryColor,
                            )
                          : SizedBox(),
                      leading: const Icon(Icons.filter_list),
                      title: Text(filter),
                      onTap: () {
                        Navigator.pop(context);
                        provider.applyFilter(filter);
                      },
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

/// Displays activity data in pivot table format.
///
/// Uses:
/// - [PivotTable] widget
/// - Activity data from [DashboardProvider]
///
/// Shows:
/// - Date as row and column key
/// - Count as value key
class ActivityPivot extends StatelessWidget {
  const ActivityPivot({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: PivotTable(
          subHeading: 'Count',
          label: 'activities',
          heading: 'Date',
          data: provider.activityData!,
          rowKey: "date",
          columnKey: "date",
          valueKey: 'count',
        ),
      );
    });
  }
}

/// Displays activities in list format.
///
/// Handles:
/// - Loading state
/// - Empty state animation
/// - Rendering individual activity cards
///
/// Uses:
/// - [DashboardProvider.activityReport]
/// - [OdooClientManager] for tag details and profile images
class ActivitiesListView extends StatelessWidget {
  const ActivitiesListView({super.key});

  /// Builds a centered animated Lottie state.
  ///
  /// Used for:
  /// - Empty state
  /// - Informational placeholders
  ///
  /// Parameters:
  /// - [lottie] Animation asset path
  /// - [title] Main message
  /// - [subtitle] Optional secondary message
  /// - [button] Optional action button
  /// - [isDark] Theme mode flag
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

  /// Builds empty state UI when no activities are found.
  ///
  /// Displays:
  /// - Ghost animation
  /// - Informational message
  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Activities Found',
      isDark: isDark,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DashboardProvider, OdooClientManager>(
      builder: (context, provider, clientprovider, child) {
        final activities = provider.activityReport;

        if (activities.isEmpty && provider.isloading == false) {
          return Center(child: _buildEmptyState(context));
        }

        if (activities.isEmpty && provider.isloading == true) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        } else {
          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];

              return ActivityCard(
                authorId: activity['author_id'],
                activityType: activity['mail_activity_type_id'],
                company: activity['company_id'],
                tags: activity['tag_ids'],
                date: activity['date'],
                clientProvider: clientprovider,
              );
            },
          );
        }
      },
    );
  }
}

/// Displays individual activity information inside a styled card.
///
/// Shows:
/// - Author name
/// - Activity type
/// - Company name
/// - Activity date
/// - Associated CRM tags
/// - Author profile image
///
/// Fetches avatar using:
/// `${baseUrl}/web/image/res.partner/{id}/avatar_128`
///
/// Handles:
/// - Null safety
/// - Shimmer loading state
/// - Image fallback on error
class ActivityCard extends StatelessWidget {
  final List<dynamic>? authorId;
  final List<dynamic>? activityType;
  final List<dynamic>? company;
  final List<dynamic>? tags;
  final String? date;
  final OdooClientManager clientProvider;

  const ActivityCard({
    super.key,
    required this.authorId,
    required this.activityType,
    required this.company,
    required this.tags,
    required this.date,
    required this.clientProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileImage(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authorId?[1] ?? 'Unknown Author',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Type: ${activityType != null && activityType!.length > 1 ? activityType![1] : 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    'Company: ${company != null && company!.length > 1 ? company![1] : 'N/A'}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatDate(date),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                TagChips(
                  tags: clientProvider.crmTagDetails,
                  tagIds: tags!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds circular profile image for activity author.
  ///
  /// Uses:
  /// - [CachedNetworkImage] for network loading
  /// - Shimmer effect while loading
  /// - Default asset fallback if author is null
  Widget _buildProfileImage() {
    return ClipOval(
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: authorId == null || authorId!.isEmpty
            ? Image.asset(
                "assets/profile.jpg",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 50, color: Colors.grey);
                },
              )
            : CachedNetworkImage(
                imageUrl:
                    "${clientProvider.url}/web/image/res.partner/${authorId![0]}/avatar_128",
                httpHeaders: {
                  "Cookie":
                      "session_id=${clientProvider.currentsession!.sessionId}",
                },
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey,
                  child: Container(color: Colors.white),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.person, size: 50, color: Colors.grey),
              ),
      ),
    );
  }

  /// Formats activity date string into `MMM d, yyyy`.
  ///
  /// Returns:
  /// - Formatted date string
  /// - "No Date" if null or empty
  /// - "Invalid Date" if parsing fails
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "No Date";
    try {
      DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat('MMM d, yyyy').format(parsedDate);
    } catch (e) {
      return "Invalid Date";
    }
  }
}
