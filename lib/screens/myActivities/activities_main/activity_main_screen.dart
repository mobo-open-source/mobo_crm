import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/global_methods/dialog%20boxes/activity_creation_dialog.dart';
import 'package:mobo_crm/global_methods/services/global_error_handler.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/myActivities/activities_main/activity_main_provider.dart';
import 'package:mobo_crm/screens/myActivities/activities_main/components/activity_screen_components.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/company/infrastructure/company_refresh_bus.dart';
import '../../../core/company/providers/company_provider.dart';
import '../../../core/company/widgets/company_selector_widget.dart';
import '../../../services/storage_service.dart';
import '../../../utils/snackbar.dart';
import '../../others/configuration_screen.dart';

/// Main screen that displays user activities.
///
/// Features:
/// - Tabbed view: All, Overdue, Today, Upcoming.
/// - Fetches activities from Odoo server or local cache.
/// - Displays user avatar and allows configuration navigation.
/// - Supports company switching via [CompanySelectorWidget].
class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final StreamSubscription _companySub;
  final ScrollController _pillScrollController = ScrollController();
  final List<GlobalKey> _pillTabKeys = List.generate(4, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    final activityprovider =
        Provider.of<ActivitiesMainProvider>(context, listen: false);

    activityprovider.fetchActivities(isNotify: false);

    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _scrollPillToVisible(_tabController.index);
      }
    });

    _companySub = CompanyRefreshBus.stream.listen((_) async {
      if (!mounted) return;
      await context.read<CompanyProvider>().initialize();
      if (!mounted) return;
      final activityprovider =
          Provider.of<ActivitiesMainProvider>(context, listen: false);

      activityprovider.fetchActivities(isNotify: false);
    });
  }

  void _scrollPillToVisible(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || index >= _pillTabKeys.length) return;
      final key = _pillTabKeys[index];
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.5,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pillScrollController.dispose();
    _companySub.cancel();
    super.dispose();
  }

  /// Retrieves the current user's profile image in Base64 format from local storage.
  ///
  /// Returns null if no image is found.
  Future<String?> getCurrentUserImage() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    final storage = StorageService();
    final accounts = await storage.getAccounts();

    final currentUserId = userId;

    if (currentUserId == null) return null;

    final currentAccount = accounts.firstWhere(
      (acc) => acc['userId'] == currentUserId,
      orElse: () => {},
    );

    return currentAccount['image'];
  }
  bool isSvgBytes(String base64String) {
    final bytes = base64Decode(base64String);
    final content = String.fromCharCodes(bytes);
    return content.contains('<svg');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<OdooClientManager, ActivitiesMainProvider>(
      builder: (context, odooProvider, activitiesProvider, child) {
        if (activitiesProvider.errorMessage != null &&
            activitiesProvider.activityError != null) {
          return ErrorScreen(
            error: activitiesProvider.activityError!,
            onRetry: () {
              activitiesProvider.fetchActivities(isNotify: true);
            },
          );
        } else {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => const AddActivityDialog(
                    resId: 0,
                    model: 'crm.lead',
                  ),
                );
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 28,
              ),
            ),
            backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF181A20) : const Color(0xFFFAFAFA),
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              centerTitle: false,
              title: Text(
                'Activities',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF181A20) : const Color(0xFFFAFAFA),
              automaticallyImplyLeading: false,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(45),
                child: Container(
                  height: 38,
                  margin: const EdgeInsets.only(left: 16, top: 8, bottom: 2),
                  child: AnimatedBuilder(
                    animation: _tabController,
                    builder: (context, child) {
                      final tabs = [
                        { "label": "All", "count": activitiesProvider.allActivities.length },
                        { "label": "Overdue", "count": activitiesProvider.overdue.length },
                        { "label": "Today", "count": activitiesProvider.today.length },
                        { "label": "Upcoming", "count": activitiesProvider.upcoming.length },
                      ];

                      return ListView.separated(
                        controller: _pillScrollController,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(right: 16),
                        itemCount: tabs.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final tab = tabs[index];
                          final count = tab['count'] as int;
                          final label = "${tab['label']} ${count > 99 ? '99+' : count}";
                          return AnimatedBuilder(
                            animation: _tabController.animation!,
                            builder: (context, _) {
                              final activeIndex = _tabController.animation!.value.round();
                              return _buildPillTab(
                                key: _pillTabKeys[index],
                                context: context,
                                label: label,
                                isSelected: activeIndex == index,
                                onTap: () {
                                  _tabController.animateTo(index);
                                  _scrollPillToVisible(index);
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              actions: [
                CompanySelectorWidget(
                  onCompanyChanged: () async {
                    if (!mounted) return;
                    final provider = context.read<CompanyProvider>();
                    final companyName =
                        provider.selectedCompany?['name']?.toString() ??
                            'company';
                    CompanyRefreshBus.notify();

                    CustomSnackbar.showSuccess(
                        context, 'Switched to $companyName');
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Consumer<OdooClientManager>(
                  builder: (context, provider, child) {
                    final imageBase64 = provider.currentUserImage;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ConfigurationScreen(),
                          ),
                        ).then((_) async {
                          if (mounted) {
                            await Provider.of<OdooClientManager>(context, listen: false).updateUserImage();
                            setState(() {});
                          }
                        });
                      },
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: (imageBase64 != null && !isSvgBytes(imageBase64))
                            ? MemoryImage(base64Decode(imageBase64))
                            : null,
                        child: imageBase64 == null
                            ? const Icon(
                          HugeIcons.strokeRoundedUserCircle,
                          size: 20,
                          color: Colors.black,
                        )
                            : isSvgBytes(imageBase64)
                            ? ClipOval(
                          child: SvgPicture.memory(
                            base64Decode(imageBase64),
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                          ),
                        )
                            : null,
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 12,
                ),
              ],
            ),
            body: activitiesProvider.isLoading
                ? const ShimmerActivityList()
                : TabBarView(
                    controller: _tabController,
                    children: [
                      ActivityListView(
                          activities: activitiesProvider.allActivities),
                      ActivityListView(activities: activitiesProvider.overdue),
                      ActivityListView(activities: activitiesProvider.today),
                      ActivityListView(activities: activitiesProvider.upcoming),
                    ],
                  ),
          );
        }
      },
    );
  }

  /// Builds a single pill-style tab button.
  Widget _buildPillTab({
    Key? key,
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.black
              : (isDark ? Colors.grey[800] : Colors.white),
          border: Border.all(
            color: isSelected
                ? Colors.black
                : (isDark ? Colors.grey[600]! : Colors.grey[300]!),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey[400] : Colors.grey[700]),
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
