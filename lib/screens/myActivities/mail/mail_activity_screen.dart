import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/global_methods/widgets/shimmer/custom_shimmer.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';
import 'package:mobo_crm/models/activity_model/activity_model.dart';
import 'package:mobo_crm/screens/myActivities/mail/mail_activity_list_screen.dart';
import 'package:mobo_crm/screens/myActivities/mail/provider/mail_data_provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/company/session/company_session_manager.dart';
import '../../../global_methods/services/global_error_handler.dart';

/// Screen displaying the current user's scheduled mail activities.
class MailDataScreen extends StatefulWidget {
  const MailDataScreen({super.key});

  @override
  State<MailDataScreen> createState() => _MailDataScreenState();
}

class _MailDataScreenState extends State<MailDataScreen> {
  OdooClient? _client;

  @override
  void initState() {
    super.initState();
    _loadClient();
  }

  Future<void> _loadClient() async {
    final client = await CompanySessionManager.getClientEnsured();
    if (!mounted) return;
    setState(() => _client = client);
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
        final sw = MediaQuery.of(context).size.width;
        final scale = (sw / 375).clamp(0.8, 1.2);
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(lottie, width: sw * 0.65),
                  SizedBox(height: 8 * scale),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: (18 * scale).clamp(14, 22),
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 6 * scale),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: (14 * scale).clamp(11, 17),
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                  if (button != null) ...[SizedBox(height: 12 * scale), button],
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
      title: 'No Mail Activities Found',
      isDark: isDark,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sw = MediaQuery.of(context).size.width;
    final scale = (sw / 375).clamp(0.8, 1.2);

    return ChangeNotifierProvider(
      create: (_) => MailDataProvider()..fetchMailData(),
      child: Scaffold(
        backgroundColor: AppColors().backGround,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: false,
          title: Text(
            'Mail Activities',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: (20 * scale).clamp(16, 24),
              color: Colors.black,
            ),
          ),
          actions: [
            Builder(
              builder: (ctx) => TextButton(
                onPressed: () {
                  Navigator.push(
                    ctx,
                    SlidingPageTransitionRL(
                      page: MailActivityListScreen(
                        group: MailActivityGroup(
                          id: 0,
                          name: '',
                          model: '',
                          icon: '',
                          totalCount: 0,
                          todayCount: 0,
                          overdueCount: 0,
                          plannedCount: 0,
                        ),
                      ),
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: (14 * scale).clamp(11, 17),
                    fontWeight: FontWeight.w600,
                    color: Theme.of(ctx).primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(width: 4 * scale),
          ],
          backgroundColor: Colors.grey[50],
          automaticallyImplyLeading: false,
        ),
        body: Container(
          color: Colors.grey[50],
          child: Consumer<MailDataProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return ListView.builder(
                  itemBuilder: (_, __) => const ActivityCardShimmer(),
                  itemCount: 4,
                );
              }
              if (provider.hasError && provider.activityGroups.isEmpty) {
                return ErrorScreen(
                  error: provider.errorMessage!,
                  onRetry: () => provider.fetchMailData(),
                );
              }
              if (provider.activityGroups.isEmpty) {
                return Center(child: _buildEmptyState(context));
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(
                  vertical: (6 * scale).clamp(4, 10),
                ),
                itemCount: provider.activityGroups.length,
                itemBuilder: (context, index) {
                  final group = provider.activityGroups[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: (16 * scale).clamp(10, 24),
                    ),
                    child: _buildActivityCard(context, group, colorScheme),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context,
    dynamic group,
    ColorScheme colorScheme,
  ) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final scale = (sw / 375).clamp(0.8, 1.2);

    final cardPad = (16 * scale).clamp(12.0, 20.0);
    final iconSize = (28 * scale).clamp(22.0, 34.0);
    final headerFontSize = (18 * scale).clamp(14.0, 22.0);
    final statGap = (8 * scale).clamp(4.0, 12.0);

    return Container(
      margin: EdgeInsets.only(bottom: (18 * scale).clamp(12.0, 24.0)),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular((16 * scale).clamp(12.0, 20.0)),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.18)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular((12 * scale).clamp(8.0, 16.0)),
        onTap: () {
          Navigator.push(
            context,
            SlidingPageTransitionRL(
              page: MailActivityListScreen(group: group),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(cardPad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular((5 * scale).clamp(3.0, 7.0)),
                      child: _client != null && group.icon.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: '${_client!.baseURL}${group.icon}',
                              httpHeaders: {
                                'Cookie':
                                    'session_id=${_client!.sessionId?.id ?? ''}',
                              },
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor:
                                    primaryColor.withValues(alpha: 0.1),
                                highlightColor:
                                    primaryColor.withValues(alpha: 0.05),
                                child: Container(color: Colors.white),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: primaryColor.withValues(alpha: 0.1),
                                child: Icon(
                                  Icons.work_outline,
                                  color: primaryColor,
                                  size: (16 * scale).clamp(12.0, 20.0),
                                ),
                              ),
                            )
                          : Container(
                              color: primaryColor.withValues(alpha: 0.1),
                              child: Icon(
                                Icons.work_outline,
                                color: primaryColor,
                                size: (16 * scale).clamp(12.0, 20.0),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: (10 * scale).clamp(6.0, 14.0)),
                  Expanded(
                    child: Text(
                      group.name,
                      style: TextStyle(
                        fontSize: headerFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: (16 * scale).clamp(12.0, 18.0),
                    color: Colors.black54,
                  ),
                ],
              ),
              SizedBox(height: (14 * scale).clamp(10.0, 18.0)),
              Row(
                children: [
                  _buildStatItem(
                    context: context,
                    icon: Icons.assessment,
                    label: "Total",
                    count: group.totalCount ?? 0,
                    color: primaryColor,
                    isDark: isDark,
                    scale: scale,
                  ),
                  SizedBox(width: statGap),
                  _buildStatItem(
                    context: context,
                    icon: Icons.today,
                    label: "Today",
                    count: group.todayCount ?? 0,
                    color: Colors.orange[700]!,
                    isDark: isDark,
                    scale: scale,
                  ),
                  SizedBox(width: statGap),
                  _buildStatItem(
                    context: context,
                    icon: Icons.warning_amber_rounded,
                    label: "Overdue",
                    count: group.overdueCount ?? 0,
                    color: Colors.red[700]!,
                    isDark: isDark,
                    scale: scale,
                  ),
                  SizedBox(width: statGap),
                  _buildStatItem(
                    context: context,
                    icon: Icons.check_circle_outline,
                    label: "Planned",
                    count: group.plannedCount ?? 0,
                    color: Colors.green[700]!,
                    isDark: isDark,
                    scale: scale,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int count,
    required Color color,
    required bool isDark,
    required double scale,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: (10 * scale).clamp(7.0, 13.0)),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          borderRadius:
              BorderRadius.circular((10 * scale).clamp(7.0, 13.0)),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: (22 * scale).clamp(16.0, 26.0), color: color),
            SizedBox(height: (5 * scale).clamp(3.0, 7.0)),
            Text(
              count.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: (17 * scale).clamp(13.0, 20.0),
                color: Colors.black87,
              ),
            ),
            SizedBox(height: (2 * scale).clamp(1.0, 4.0)),
            Text(
              label,
              style: TextStyle(
                fontSize: (11 * scale).clamp(9.0, 13.0),
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
