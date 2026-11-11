import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/global_methods/widgets/shimmer/custom_shimmer.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';
import 'package:mobo_crm/models/activity_model/activity_model.dart';
import 'package:mobo_crm/screens/myActivities/mail/mail_activity_list_screen.dart';
import 'package:mobo_crm/screens/myActivities/mail/provider/mail_data_provider.dart';
import 'package:mobo_crm/utils/app_theme.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/company/session/company_session_manager.dart';
import '../../../global_methods/services/global_error_handler.dart';

/// Screen displaying the current user's scheduled mail activities.
///
/// One card per model, with the same overdue / today / planned figures the
/// Odoo web client shows in its activity menu. Tap a card to see the
/// activities behind the numbers.
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
      subtitle: 'Pull down to refresh.',
      isDark: isDark,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChangeNotifierProvider(
      create: (_) => MailDataProvider()..fetchMailData(),
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF181A20) : AppColors().backGround,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new,
                color: isDark ? Colors.white : Colors.black),
          ),
          iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
          centerTitle: false,
          title: Text(
            'Mail Activities',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: isDark ? Colors.white : Colors.black,
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
                        // id 0 / empty model = every activity of the user.
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
                        modelNames: ctx.read<MailDataProvider>().modelNames,
                      ),
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(ctx).primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
          backgroundColor: isDark ? const Color(0xFF181A20) : Colors.grey[50],
          automaticallyImplyLeading: false,
        ),
        body: Container(
          color: isDark ? const Color(0xFF181A20) : Colors.grey[50],
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
                  onRetry: () => provider.fetchMailData(isNotify: true),
                );
              }
              if (provider.activityGroups.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () => provider.fetchMailData(silent: true),
                  child: _buildEmptyState(context),
                );
              }

              final groups = provider.activityGroups;
              final hasNotice = provider.isShowingCached;
              return RefreshIndicator(
                onRefresh: () => provider.fetchMailData(silent: true),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: groups.length + (hasNotice ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (hasNotice) {
                      if (index == 0) {
                        return MailCachedDataNotice(
                          isDark: isDark,
                          message:
                              "Can't reach the server. These counts were saved on this device and may be out of date.",
                        );
                      }
                      index -= 1;
                    }
                    return _buildActivityCard(
                      context,
                      groups[index],
                      provider.modelNames,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGroupIcon(MailActivityGroup group) {
    final primaryColor = AppTheme.primaryColor;

    Widget fallback() => Container(
          color: primaryColor.withValues(alpha: 0.1),
          child: const Icon(Icons.work_outline,
              color: AppTheme.primaryColor, size: 18),
        );

    return SizedBox(
      width: 32,
      height: 32,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.compact),
        child: _client != null && group.icon.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: '${_client!.baseURL}${group.icon}',
                httpHeaders: {
                  ...CompanySessionManager.skipSessionRotationHeader,
                  'Cookie': 'session_id=${_client!.sessionId?.id ?? ''}',
                },
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: primaryColor.withValues(alpha: 0.1),
                  highlightColor: primaryColor.withValues(alpha: 0.05),
                  child: Container(color: Colors.white),
                ),
                errorWidget: (context, url, error) => fallback(),
              )
            : fallback(),
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context,
    MailActivityGroup group,
    Map<String, String> modelNames,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: () {
        Navigator.push(
          context,
          SlidingPageTransitionRL(
            page: MailActivityListScreen(group: group, modelNames: modelNames),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.surface(isDark),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppTheme.cardBorder(isDark), width: 0.5),
          boxShadow: const [AppShadows.cardShadow],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildGroupIcon(group),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      group.name.isEmpty ? group.model : group.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.valueColor(isDark),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppTheme.secondaryLabelColor(isDark),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // Total counts every state. Odoo's own total_count leaves
                  // planned activities out, which made "Total" smaller than
                  // the sum of the tiles next to it.
                  _buildStatItem(
                    icon: Icons.assessment,
                    label: 'Total',
                    count: group.allCount,
                    color: AppTheme.primaryColor,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildStatItem(
                    icon: Icons.warning_amber_rounded,
                    label: 'Overdue',
                    count: group.overdueCount,
                    color: mailActivityStateColor('overdue'),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildStatItem(
                    icon: Icons.today,
                    label: 'Today',
                    count: group.todayCount,
                    color: mailActivityStateColor('today'),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildStatItem(
                    icon: Icons.event_available_outlined,
                    label: 'Planned',
                    count: group.plannedCount,
                    color: mailActivityStateColor('planned'),
                    isDark: isDark,
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
    required IconData icon,
    required String label,
    required int count,
    required Color color,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.1),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              count.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppTheme.valueColor(isDark),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppTheme.secondaryLabelColor(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
