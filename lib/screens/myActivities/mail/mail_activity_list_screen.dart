import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobo_crm/global_methods/widgets/activity_icon.dart';
import 'package:mobo_crm/global_methods/widgets/shimmer/custom_shimmer.dart';
import 'package:mobo_crm/models/activity_model/activity_model.dart';
import 'package:mobo_crm/utils/app_theme.dart';

import 'mail_activity_item.dart';
import 'provider/mail_data_provider.dart';

/// Colour for an activity [state] (`overdue`, `today`, `planned`, `done`).
///
/// Shared by the group cards and the activity list so the same state always
/// has the same colour.
Color mailActivityStateColor(String state) {
  switch (state) {
    case 'overdue':
      return StatusColors.statusRed;
    case 'today':
      return StatusColors.statusOrange;
    case 'planned':
      return StatusColors.statusGreen;
    case 'done':
      return StatusColors.statusTeal;
    default:
      return StatusColors.statusGrey;
  }
}

/// Banner telling the user the figures on screen come from the copy saved on
/// the device, not from the server.
class MailCachedDataNotice extends StatelessWidget {
  const MailCachedDataNotice({
    super.key,
    required this.message,
    required this.isDark,
  });

  final String message;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: StatusColors.statusOrange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_rounded,
              size: 18, color: StatusColors.statusOrange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                height: 1.3,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Screen listing the activities that belong to a single [MailActivityGroup].
///
/// Every row is built from the server's own `state` and values, so what is
/// shown here is what the Odoo website shows for the same activity.
class MailActivityListScreen extends StatefulWidget {
  final MailActivityGroup group;

  /// Technical model → display name, used to say what each activity belongs to
  /// when the list mixes several models ("All Activities").
  final Map<String, String> modelNames;

  const MailActivityListScreen({
    super.key,
    required this.group,
    this.modelNames = const {},
  });

  @override
  State<MailActivityListScreen> createState() => _MailActivityListScreenState();
}

class _MailActivityListScreenState extends State<MailActivityListScreen> {
  late Future<MailActivityList> _future;

  @override
  void initState() {
    super.initState();
    _future = MailDataProvider.loadActivities(widget.group);
  }

  /// Reloads the list. Errors surface through the FutureBuilder, so the
  /// returned future never fails (the pull-to-refresh spinner just ends).
  Future<void> _reload() {
    final future = MailDataProvider.loadActivities(widget.group);
    setState(() => _future = future);
    return future.then((_) {}, onError: (_) {});
  }

  /// True when the list can contain several models, so each row says which.
  bool get _isMixedList =>
      widget.group.model.isEmpty || widget.group.isOtherActivities;

  String get _title {
    final group = widget.group;
    if (group.name.isEmpty) return 'All Activities';
    if (group.isOtherActivities) return group.name;
    return '${group.name} Activities';
  }

  String? _modelLabel(MailActivityItem item) {
    final model = item.resModel;
    if (model == null) return null;
    return widget.modelNames[model] ??
        MailDataProvider.readableModelName(model);
  }

  Widget _buildMessage({
    required bool isDark,
    required String title,
    String? subtitle,
    Widget? button,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/empty_ghost.json',
                      width: MediaQuery.of(context).size.width * 0.65,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      textAlign: TextAlign.center,
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
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                    if (button != null) ...[
                      const SizedBox(height: 16),
                      button,
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF181A20) : Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new,
              color: isDark ? Colors.white : Colors.black),
        ),
        forceMaterialTransparency: false,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
        centerTitle: false,
        title: Text(
          _title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: isDark ? const Color(0xFF181A20) : Colors.grey[50],
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: FutureBuilder<MailActivityList>(
        future: _future,
        builder: (context, snapshot) {
          // A reload keeps the previous data, so only show shimmers the first time.
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (_, __) => const ActivityItemShimmer(),
              itemCount: 4,
            );
          }

          if (snapshot.hasError && !snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: _reload,
              child: _buildMessage(
                isDark: isDark,
                title: "Couldn't load activities",
                subtitle:
                    'Check your connection and try again. Nothing has been changed.',
                button: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(
                          color: AppTheme.primaryColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    onPressed: _reload,
                    child: const Text(
                      'Retry',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            );
          }

          final data = snapshot.data ?? const MailActivityList(items: []);
          if (data.items.isEmpty) {
            return RefreshIndicator(
              onRefresh: _reload,
              child: _buildMessage(
                isDark: isDark,
                title: widget.group.name.isEmpty
                    ? 'No activities found'
                    : 'No activities found for ${widget.group.name}',
                subtitle: 'Pull down to refresh.',
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              // One extra row for the summary header.
              itemCount: data.items.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return _buildSummary(data, isDark);
                return _buildActivityItem(
                    context, data.items[index - 1], isDark);
              },
            ),
          );
        },
      ),
    );
  }

  /// Header above the cards: how many activities, split by state, plus a
  /// notice when the numbers come from the saved copy.
  Widget _buildSummary(MailActivityList data, bool isDark) {
    final total = data.items.length;
    final overdue = data.countWhere('overdue');
    final today = data.countWhere('today');
    final planned = data.countWhere('planned');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.fromCache)
            MailCachedDataNotice(
              isDark: isDark,
              message:
                  "Can't reach the server. Showing the activities saved on this device, which may be out of date.",
            ),
          Text(
            '$total ${total == 1 ? 'activity' : 'activities'}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.valueColor(isDark),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (overdue > 0)
                StatusColors.buildStatusBadge(
                    '$overdue Overdue', mailActivityStateColor('overdue'),
                    isDark: isDark),
              if (today > 0)
                StatusColors.buildStatusBadge(
                    '$today Today', mailActivityStateColor('today'),
                    isDark: isDark),
              if (planned > 0)
                StatusColors.buildStatusBadge(
                    '$planned Planned', mailActivityStateColor('planned'),
                    isDark: isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    MailActivityItem item,
    bool isDark,
  ) {
    final stateColor = mailActivityStateColor(item.state);
    // A mixed list says what each activity belongs to. One with no document at
    // all (the "Other activities" kind, blank under "Linked to" on the website)
    // says so, rather than leaving the line empty.
    final modelLabel = _isMixedList
        ? (_modelLabel(item) ??
              (item.documentName == null ? 'Not linked to a record' : null))
        : null;
    final relative = item.relativeDueText();

    return Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      if (modelLabel != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          modelLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.secondaryLabelColor(isDark),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                StatusColors.buildStatusBadge(item.stateLabel, stateColor,
                    isDark: isDark),
              ],
            ),
            const SizedBox(height: 12),
            Divider(
              color: isDark ? Colors.grey[800] : Colors.grey.shade200,
              thickness: 1,
              height: 1,
            ),
            const SizedBox(height: 12),
            _detailRow(
              isDark: isDark,
              label: 'Activity',
              value: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ActivityIcon(
                    activityType: item.typeName,
                    activityState: item.state,
                    overrideColor: stateColor,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Flexible(child: _valueText(item.typeName, isDark)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _detailRow(
              isDark: isDark,
              label: 'Due date',
              value: Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.valueColor(isDark),
                  ),
                  children: [
                    TextSpan(text: item.deadlineText),
                    if (relative.isNotEmpty)
                      TextSpan(
                        text: '  ·  $relative',
                        style: TextStyle(color: stateColor),
                      ),
                  ],
                ),
                textAlign: TextAlign.end,
              ),
            ),
            const SizedBox(height: 8),
            _detailRow(
              isDark: isDark,
              label: 'Assigned to',
              value: _valueText(item.assignedTo, isDark),
            ),
            if (item.summary != null) ...[
              const SizedBox(height: 8),
              _detailRow(
                isDark: isDark,
                label: 'Summary',
                value: _valueText(item.summary!, isDark),
              ),
            ],
            if (item.note != null) ...[
              const SizedBox(height: 8),
              _detailRow(
                isDark: isDark,
                label: 'Note',
                value: _valueText(item.note!, isDark, maxLines: 4),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _valueText(String text, bool isDark, {int? maxLines}) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      textAlign: TextAlign.end,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.valueColor(isDark),
      ),
    );
  }

  Widget _detailRow({
    required bool isDark,
    required String label,
    required Widget value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
          child: Text(
            label,
            style: TextStyle(
              color: AppTheme.secondaryLabelColor(isDark),
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Align(alignment: Alignment.centerRight, child: value),
        ),
      ],
    );
  }
}
