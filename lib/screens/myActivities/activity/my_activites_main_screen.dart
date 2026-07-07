import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobo_crm/global_methods/dialog%20boxes/lead_creation_dialog.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/searchfield_widget.dart';

import 'package:mobo_crm/initilisation.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/screens/myActivities/activity/my_activity_view.dart';
import 'package:mobo_crm/screens/myActivities/activity/provider/activity_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

/// Main screen for displaying "My Activities" in different views (list, kanban, graph, calendar, schedule)
///
/// Provides functionality for:
/// - Searching activities
/// - Applying multiple filters (date, stage, activity type, lead type)
/// - Switching between different activity views
/// - Creating a new activity via floating action button
class MyActivitesMainScreen extends StatefulWidget {
  const MyActivitesMainScreen({super.key});

  @override
  State<MyActivitesMainScreen> createState() => _MyActivitesMainScreenState();
}

class _MyActivitesMainScreenState extends State<MyActivitesMainScreen> {
  @override
  void initState() {
    final activtyProvider =
        Provider.of<ActivityDataProvider>(context, listen: false);
    activtyProvider.canManageSkills();
    if (activtyProvider.activityData.isEmpty) {
      activtyProvider.getActivityData(context: context);
    }
    super.initState();
  }

  Future<void> _handleRefresh() async {
    final activityProvider =
        Provider.of<ActivityDataProvider>(context, listen: false);
    await activityProvider.getActivityData(context: context);
  }

  List<Widget> get _viewWidgets => [
        MyActivityListView(onRefresh: _handleRefresh),
        ActivityKanbanView(onRefresh: _handleRefresh),
        MyActivityGraphWidget(),
        MyActivityCalendarView(),
        MyActivityScheduleView(),
      ];

  bool hasClosingDateFilters = false;
  bool hasLeadFilters = false;
  bool hasCreationDateFilters = false;
  bool hasStageFilters = false;
  bool hasActivityCategoryFilters = false;

  bool filterUnassigned = false;
  bool filterPartnerAssigned = false;
  bool filterMyActivities = true;

  bool filterLost = false;

  bool filterCurrentMonth = false;
  bool filterPreviousMonth = false;
  bool filterTwoMonthsAgo = false;

  bool filterPreviousMonthClose = false;
  bool filterTwoMonthsAgoClose = false;
  bool filterCurrentMonthClose = false;

  bool filterLateActivities = false;
  bool filterTodayActivities = false;
  bool filterFutureActivities = false;

  /// Displays the bottom sheet modal for filtering activities
  ///
  /// The bottom sheet provides multiple filters, including:
  /// - Assigned/unassigned activities
  /// - Lead status
  /// - Activity status (late, today, future)
  /// - Creation date and closing date filters
  void showFilterBottomSheet(BuildContext context) {
    bool tempFilterUnassigned = filterUnassigned;
    bool tempFilterPartnerAssigned = filterPartnerAssigned;
    bool tempFilterMyActivities = filterMyActivities;

    DateTime now = DateTime.now();
    bool tempFilterLost = filterLost;

    bool tempFilterCurrentMonth = filterCurrentMonth;
    bool tempFilterPreviousMonth = filterPreviousMonth;
    bool tempFilterTwoMonthsAgo = filterTwoMonthsAgo;

    bool tempFilterPreviousMonthClose = filterPreviousMonthClose;
    bool tempFilterTwoMonthsAgoClose = filterTwoMonthsAgoClose;
    bool tempFilterCurrentMonthClose = filterCurrentMonthClose;

    bool tempFilterLateActivities = filterLateActivities;
    bool tempFilterTodayActivities = filterTodayActivities;
    bool tempFilterFutureActivities = filterFutureActivities;

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
                      title: Text('My Activities',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      value: tempFilterMyActivities,
                      activeColor: Theme.of(context).primaryColor,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setModalState(() {
                          tempFilterMyActivities = value ?? false;
                        });
                      },
                    ),

                    CheckboxListTile(
                      title: Text('Unassigned',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      value: tempFilterUnassigned,
                      activeColor: Theme.of(context).primaryColor,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setModalState(() {
                          tempFilterUnassigned = value ?? false;
                        });
                      },
                    ),

                    CheckboxListTile(
                      title: Text('Partner Assigned',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      value: tempFilterPartnerAssigned,
                      activeColor: Theme.of(context).primaryColor,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setModalState(() {
                          tempFilterPartnerAssigned = value ?? false;
                        });
                      },
                    ),

                    CheckboxListTile(
                      title: Text('Lost',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      value: tempFilterLost,
                      activeColor: Theme.of(context).primaryColor,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setModalState(() {
                          tempFilterLost = value ?? false;
                        });
                      },
                    ),

                    CheckboxListTile(
                      title: Text('Late Activities',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      value: tempFilterLateActivities,
                      activeColor: Theme.of(context).primaryColor,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setModalState(() {
                          tempFilterLateActivities = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Today Activities',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      value: tempFilterTodayActivities,
                      activeColor: Theme.of(context).primaryColor,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setModalState(() {
                          tempFilterTodayActivities = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Future Activities',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      value: tempFilterFutureActivities,
                      activeColor: Theme.of(context).primaryColor,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setModalState(() {
                          tempFilterFutureActivities = value ?? false;
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
                      iconColor: Theme.of(context).primaryColor,
                      children: [
                        CheckboxListTile(
                          title: Text(currentMonth,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                          value: tempFilterCurrentMonth,
                          activeColor: Theme.of(context).primaryColor,
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setModalState(() {
                              tempFilterCurrentMonth = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(previousMonth,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                          value: tempFilterPreviousMonth,
                          activeColor: Theme.of(context).primaryColor,
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setModalState(() {
                              tempFilterPreviousMonth = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(twoMonthsAgo,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                          value: tempFilterTwoMonthsAgo,
                          activeColor: Theme.of(context).primaryColor,
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
                      iconColor: Theme.of(context).primaryColor,
                      children: [
                        CheckboxListTile(
                          title: Text(currentMonth,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                          value: tempFilterCurrentMonthClose,
                          activeColor: Theme.of(context).primaryColor,
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setModalState(() {
                              tempFilterCurrentMonthClose = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(previousMonth,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                          value: tempFilterPreviousMonthClose,
                          activeColor: Theme.of(context).primaryColor,
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            setModalState(() {
                              tempFilterPreviousMonthClose = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(twoMonthsAgo,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                          value: tempFilterTwoMonthsAgoClose,
                          activeColor: Theme.of(context).primaryColor,
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
                              filterCurrentMonthClose =
                                  tempFilterCurrentMonthClose;
                              filterPreviousMonthClose =
                                  tempFilterPreviousMonthClose;
                              filterTwoMonthsAgoClose =
                                  tempFilterTwoMonthsAgoClose;

                              filterTodayActivities = tempFilterTodayActivities;
                              filterLateActivities = tempFilterLateActivities;
                              filterFutureActivities =
                                  tempFilterFutureActivities;

                              filterLost = tempFilterLost;

                              filterUnassigned = tempFilterUnassigned;
                              filterPartnerAssigned = tempFilterPartnerAssigned;
                              filterMyActivities = tempFilterMyActivities;

                              filterCurrentMonth = tempFilterCurrentMonth;
                              filterPreviousMonth = tempFilterPreviousMonth;
                              filterTwoMonthsAgo = tempFilterTwoMonthsAgo;

                              if (tempFilterUnassigned == true ||
                                  tempFilterPartnerAssigned == true ||
                                  tempFilterMyActivities == true) {
                                hasLeadFilters = true;
                              } else {
                                hasLeadFilters = false;
                              }

                              if (tempFilterLost == true) {
                                hasStageFilters = true;
                              } else {
                                hasStageFilters = false;
                              }

                              if (tempFilterTodayActivities ||
                                  tempFilterLateActivities ||
                                  tempFilterFutureActivities) {
                                hasActivityCategoryFilters = true;
                              } else {
                                hasActivityCategoryFilters = false;
                              }

                              if (tempFilterCurrentMonthClose == true ||
                                  tempFilterPreviousMonthClose == true ||
                                  tempFilterTwoMonthsAgoClose == true) {
                                hasClosingDateFilters = true;
                              } else {
                                hasClosingDateFilters = false;
                              }

                              if (tempFilterCurrentMonth == true ||
                                  tempFilterTwoMonthsAgo == true ||
                                  tempFilterPreviousMonth == true) {
                                hasCreationDateFilters = true;
                              } else {
                                hasCreationDateFilters = false;
                              }
                            });
                            final activityProvider =
                                Provider.of<ActivityDataProvider>(context,
                                    listen: false);

                            activityProvider.getActivityData(
                              searchText:
                                  activityProvider.searchController.text,
                              myActivities: filterMyActivities,
                              monthNowClose: filterCurrentMonthClose,
                              beforeMonthClose: filterPreviousMonthClose,
                              beforeTwoMonthClose: filterTwoMonthsAgoClose,
                              monthNow: filterCurrentMonth,
                              beforeMonth: filterPreviousMonth,
                              beforeTwoMonth: filterTwoMonthsAgo,
                              context: context,
                              dateFilters: hasCreationDateFilters,
                              dateFiltersClose: hasClosingDateFilters,
                              lateActivity: filterLateActivities,
                              todayActivity: filterTodayActivities,
                              futureActivity: filterFutureActivities,
                              unAssigned: filterUnassigned,
                              partnerAssigned: filterPartnerAssigned,
                              stageFilters: hasStageFilters,
                              lost: filterLost,
                              activityCategoryFilter:
                                  hasActivityCategoryFilters,
                            );

                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Apply',style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
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
    return Consumer2<ActivityDataProvider, OdooClientManager>(
        builder: (context, provider, clientprovider, child) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          highlightElevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          disabledElevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onPressed: () async {
            showDialog(
              context: context,
              builder: (context) => OpportunityLeadDialog(
                label: "activity",
                stageId: 1,
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 28,
          ),
        ),
        backgroundColor: const Color(0xFFF3F4F6),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: 16,
          elevation: 0,
          title: const Text(
            'My Activities',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color(0xFFF3F4F6),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: CustomSearchTextField(
                      readOnly: provider.isLoading,
                      controller: provider.searchController,
                      hintText: 'Search by activity name',
                      onFilterTap: () => showFilterBottomSheet(context),
                      onChanged: (query) {
                        provider.getActivityData(
                          searchText: query,
                          myActivities: filterMyActivities,
                          monthNowClose: filterCurrentMonthClose,
                          beforeMonthClose: filterPreviousMonthClose,
                          beforeTwoMonthClose: filterTwoMonthsAgoClose,
                          monthNow: filterCurrentMonth,
                          beforeMonth: filterPreviousMonth,
                          beforeTwoMonth: filterTwoMonthsAgo,
                          context: context,
                          dateFilters: hasCreationDateFilters,
                          dateFiltersClose: hasClosingDateFilters,
                          lateActivity: filterLateActivities,
                          todayActivity: filterTodayActivities,
                          futureActivity: filterFutureActivities,
                          unAssigned: filterUnassigned,
                          partnerAssigned: filterPartnerAssigned,
                          stageFilters: hasStageFilters,
                          lost: filterLost,
                          activityCategoryFilter: hasActivityCategoryFilters,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildMyActivityViewSelector(context, provider),
                ],
              ),
            ),
            _buildTopPaginationBar(provider),
            Expanded(
              child: provider.isLoading && provider.activityData.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _viewWidgets[provider.selectedViewIndex],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMyActivityViewSelector(
      BuildContext context, ActivityDataProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentView = provider.viewItems[provider.selectedViewIndex];

    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<int>(
          value: provider.selectedViewIndex,
          customButton: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                currentView['icon'],
                size: 18,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
          items: provider.viewItems.asMap().entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Row(
                children: [
                  Icon(entry.value['icon'],
                      size: 20,
                      color: provider.selectedViewIndex == entry.key
                          ? Theme.of(context).primaryColor
                          : Colors.grey[600]),
                  const SizedBox(width: 12),
                  Text(
                    entry.value['label'],
                    style: TextStyle(
                      color: provider.selectedViewIndex == entry.key
                          ? Theme.of(context).primaryColor
                          : Colors.black87,
                      fontSize: 13,
                      fontWeight: provider.selectedViewIndex == entry.key
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          dropdownStyleData: DropdownStyleData(
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isDark ? Colors.grey[900] : Colors.white,
            ),
            elevation: 8,
          ),
          onChanged: (index) {
            if (index != null) {
              provider.updateViewIndex(index);
            }
          },
        ),
      ),
    );
  }

  /// Builds top pagination bar for activity list
  Widget _buildTopPaginationBar(ActivityDataProvider provider) {
    if (!provider.isLoading &&
        provider.activityData.isEmpty &&
        provider.totalCount == 0) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "No filters applied",
              style: TextStyle(
                fontSize: 12.5,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      width: 1),
                ),
                child: Text(
                  "${provider.startRecord}-${provider.endRecord} / ${provider.totalCount}",
                  style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white70 : Colors.black87),
                ),
              ),
              if (provider.totalPages > 1) ...[
                InkWell(
                  onTap: provider.hasPreviousPage
                      ? () => _goToPreviousPage(provider)
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    child: Icon(
                      HugeIcons.strokeRoundedArrowLeft01,
                      size: 20,
                      color: provider.hasPreviousPage
                          ? (isDark ? Colors.white70 : Colors.grey[700])
                          : (isDark ? Colors.grey[800] : Colors.grey[400]),
                    ),
                  ),
                ),
                InkWell(
                  onTap: provider.hasNextPage
                      ? () => _goToNextPage(provider)
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    child: Icon(
                      HugeIcons.strokeRoundedArrowRight01,
                      size: 20,
                      color: provider.hasNextPage
                          ? (isDark ? Colors.white70 : Colors.grey[700])
                          : (isDark ? Colors.grey[800] : Colors.grey[400]),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// Go to next pagination page
  Future<void> _goToNextPage(ActivityDataProvider provider) async {
    await provider.goToNextPage(
      context: context,
      myActivities: filterMyActivities,
      monthNowClose: filterCurrentMonthClose,
      beforeMonthClose: filterPreviousMonthClose,
      beforeTwoMonthClose: filterTwoMonthsAgoClose,
      monthNow: filterCurrentMonth,
      beforeMonth: filterPreviousMonth,
      beforeTwoMonth: filterTwoMonthsAgo,
      dateFilters: hasCreationDateFilters,
      dateFiltersClose: hasClosingDateFilters,
      lateActivity: filterLateActivities,
      todayActivity: filterTodayActivities,
      futureActivity: filterFutureActivities,
      unAssigned: filterUnassigned,
      partnerAssigned: filterPartnerAssigned,
      stageFilters: hasStageFilters,
      lost: filterLost,
      activityCategoryFilter: hasActivityCategoryFilters,
    );
  }

  /// Go to previous pagination page
  Future<void> _goToPreviousPage(ActivityDataProvider provider) async {
    await provider.goToPreviousPage(
      context: context,
      myActivities: filterMyActivities,
      monthNowClose: filterCurrentMonthClose,
      beforeMonthClose: filterPreviousMonthClose,
      beforeTwoMonthClose: filterTwoMonthsAgoClose,
      monthNow: filterCurrentMonth,
      beforeMonth: filterPreviousMonth,
      beforeTwoMonth: filterTwoMonthsAgo,
      dateFilters: hasCreationDateFilters,
      dateFiltersClose: hasClosingDateFilters,
      lateActivity: filterLateActivities,
      todayActivity: filterTodayActivities,
      futureActivity: filterFutureActivities,
      unAssigned: filterUnassigned,
      partnerAssigned: filterPartnerAssigned,
      stageFilters: hasStageFilters,
      lost: filterLost,
      activityCategoryFilter: hasActivityCategoryFilters,
    );
  }
}
