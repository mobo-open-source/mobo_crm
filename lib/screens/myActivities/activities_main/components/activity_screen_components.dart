import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:mobo_crm/global_methods/widgets/activity_icon.dart';
import 'package:mobo_crm/global_methods/widgets/shimmer/custom_shimmer.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/myActivities/activities_main/activity_main_provider.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:url_launcher/url_launcher_string.dart';

import '../../../../utils/globals.dart';
import '../../../../utils/snackbar.dart';

/// A card widget that displays a single activity with its details.
///
/// Features:
/// - Shows activity summary or type if summary is 'N/A'.
/// - Displays related record name if available.
/// - Shows deadline, assigned user, and activity type.
/// - Indicates activity state (overdue, today, planned) with a badge.
/// - Provides quick action buttons for Call, SMS, WhatsApp, and Email.
/// - Supports popup menu for marking activity as done or cancelling.
/// - Adapts UI for dark and light themes.
///
/// Parameters:
/// - [activity]: A map containing activity details such as:
///   - 'summary', 'activity_type_id', 'date_deadline', 'res_name',
///     'user_id', 'contact_name', 'contact_phone', 'contact_mobile',
///     'contact_email'
class ActivityMainCard extends StatelessWidget {
  final Map<String, dynamic> activity;

  const ActivityMainCard({super.key, required this.activity});

  /// Returns a color representing the state of the activity.
  /// - 'overdue' → red
  /// - 'today' → orange
  /// - 'planned' → green
  /// - default → grey
  Color getActivityStateColor(String activityState) {
    switch (activityState) {
      case 'overdue':
        return Colors.red;
      case 'today':
        return Colors.orange;
      case 'planned':
        return const Color(0xFF43B75D);
      default:
        return Colors.grey;
    }
  }

  /// Returns a string label representing the state of the activity.
  /// - 'overdue' → "Overdue"
  /// - 'today' → "Today"
  /// - 'planned' → "Planned"
  /// - default → "Unknown"
  String getActivityStateValue(String activityState) {
    switch (activityState) {
      case 'overdue':
        return "Overdue";
      case 'today':
        return "Today";
      case 'planned':
        return "Planned";
      default:
        return "Unknown";
    }
  }

  /// Builds the status badge widget for the activity state.
  Widget _buildStatusBadge(String activityState, bool isDark) {
    final color = getActivityStateColor(activityState);
    final text = getActivityStateValue(activityState);

    final textColor = isDark ? Colors.white : color;
    final backgroundColor =
        isDark ? Colors.white.withOpacity(0.15) : color.withOpacity(0.10);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isDark ? FontWeight.bold : FontWeight.w600,
          color: textColor,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activityTypeRaw = activity['activity_type_id'] ?? [0, 'Unknown'];
    final activityType = activityTypeRaw[1] ?? 'Unknown';
    final deadline =
        DateTime.tryParse(activity['date_deadline'] ?? '')?.toLocal();

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    String activityState = 'planned';
    if (deadline != null) {
      final deadlineDate =
          DateTime(deadline.year, deadline.month, deadline.day);
      if (deadlineDate.isBefore(todayDate)) {
        activityState = 'overdue';
      } else if (deadlineDate.isAtSameMomentAs(todayDate)) {
        activityState = 'today';
      }
    }

    return Consumer2<OdooClientManager, ActivitiesMainProvider>(
        builder: (context, odooProvider, activitiesProvider, child) {
      return InkWell(
        onTap: () {
          activitiesProvider.showActivityDetailsDialog(context, activity, activityType);
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: AppStyle.primaryColor.withOpacity(0.08),
        highlightColor: AppStyle.primaryColor.withOpacity(0.04),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 14, right: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ActivityIcon(
                      activityType: activityType,
                      activityState: activityState,
                      filled: false,
                      radius: 16,
                      size: 15,
                      overrideColor: ActivityIcon.getTypeColor(activityType),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        activity['summary'] == 'N/A'
                            ? activityType
                            : activity['summary'] ?? 'No Summary',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusBadge(activityState, isDark),
                    const SizedBox(width: 6),
                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      splashRadius: 14,
                      color: isDark ? Colors.grey[900] : Colors.white,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: Center(
                          child: Icon(
                            Icons.more_vert,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            size: 20,
                          ),
                        ),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(
                                HugeIcons.strokeRoundedPencilEdit02,
                                color: Colors.blue,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'mark_done',
                          child: Row(
                            children: [
                              const Icon(
                                HugeIcons.strokeRoundedCheckmarkCircle01,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Mark as Done',
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Cancel',
                          child: Row(
                            children: [
                              const Icon(
                                HugeIcons.strokeRoundedCancelCircle,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Cancel',
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) =>
                          activitiesProvider.handleActivityAction(
                              activity, value, odooProvider.client!, context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (activity['res_name'] != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Related to',
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              activity['res_name'],
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    if (activity['date_deadline'] != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Deadline',
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              activity['date_deadline'] ?? '--/--/--',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    if (activity['user_id'] != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Assigned to',
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              activity['user_id'][1],
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Activity Type',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            activityType,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildActionButtons(context, activity, activityType),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// Builds the row of action buttons (Call, SMS, WhatsApp, Email).
  Widget _buildActionButtons(BuildContext context,
      Map<String, dynamic> activity, String activityType) {
    final contactName = activity['contact_name'] ?? "Mr [name]";
    final contactPhone = activity['contact_phone'];
    final contactMobile = activity['contact_mobile'];
    final contactEmail = activity['contact_email'];

    String? phoneNumber;
    if (contactMobile != null && contactMobile.toString().trim().isNotEmpty) {
      phoneNumber = contactMobile.toString();
    } else if (contactPhone != null &&
        contactPhone.toString().trim().isNotEmpty) {
      phoneNumber = contactPhone.toString();
    }
    final message =
        "Hello $contactName , this is ${activity['user_id'][1]}  I’m following up on your interest in our services. Let me know a convenient time to discuss your requirements further. Looking forward to assisting you!";
    List<Widget> buttons = [];
    final subject =
        "Regarding your recent inquiry about ${activity['res_name']}";

    final body =
        "Hello,\n\nI hope this message finds you well. I am reaching out to follow up on your recent inquiry. Please let me know how we can assist you further.\n\nBest regards,\n${activity["user_id"][1]}";

    buttons.add(
      Expanded(
        child: _buildActionButton(
          icon: HugeIcons.strokeRoundedCall,
          label: 'Call',
          color: Colors.blue,
          onTap: () => _makePhoneCall(context, phoneNumber),
        ),
      ),
    );

    if (buttons.isNotEmpty) buttons.add(const SizedBox(width: 8));
    buttons.add(
      Expanded(
        child: _buildActionButton(
          icon: HugeIcons.strokeRoundedMessage01,
          label: 'SMS',
          color: Colors.orange,
          onTap: () => _sendSMS(context, phoneNumber!, message),
        ),
      ),
    );

    if (buttons.isNotEmpty) buttons.add(const SizedBox(width: 8));
    buttons.add(
      Expanded(
        child: _buildActionButton(
          icon: HugeIcons.strokeRoundedWhatsapp,
          label: 'WhatsApp',
          color: Colors.green,
          onTap: () => _openWhatsAppChat(context, phoneNumber!, message),
        ),
      ),
    );

    if (contactEmail != null &&
        contactEmail != false &&
        contactEmail.toString().isNotEmpty) {
      if (buttons.isNotEmpty) buttons.add(const SizedBox(width: 8));
      buttons.add(
        Expanded(
          child: _buildActionButton(
            icon: HugeIcons.strokeRoundedMail02,
            label: 'Email',
            color: Colors.red,
            onTap: () => _sendEmail(
              body: body,
              subject: subject,
              context,
              contactEmail.toString(),
            ),
          ),
        ),
      );
    }

    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(children: buttons);
  }

  /// Builds an individual action button with an icon, label, and color.
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        radius: 10,
        splashColor: color.withOpacity(0.2),
        highlightColor: color.withOpacity(0.1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// Shows a snackbar message.
  void _showSnackbar(BuildContext context, String message) {
    CustomSnackbar.showWarning(context, message);
  }

  /// Initiates a phone call using the device dialer.
  Future<void> _makePhoneCall(BuildContext context, String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.trim().isEmpty) {
      _showSnackbar(context, 'No phone number found');
      return;
    }

    final phoneUrl = 'tel:$phoneNumber';

    await launchUrlString(phoneUrl);
  }

  /// Sends an SMS message to the provided phone number.
  Future<void> _sendSMS(
      BuildContext context, String? phoneNumber, String message) async {
    if (phoneNumber == null || phoneNumber.trim().isEmpty) {
      _showSnackbar(context, 'No phone number found');
      return;
    }

    final smsUrl = Uri.encodeFull('sms:$phoneNumber?body=$message');
    await launchUrlString(smsUrl);
  }

  /// Opens a WhatsApp chat with the provided number and message.
  Future<void> _openWhatsAppChat(
      BuildContext context, String? phoneNumber, String message) async {
    if (phoneNumber == null || phoneNumber.trim().isEmpty) {
      _showSnackbar(context, 'No WhatsApp number found');
      return;
    }

    final whatsappUrl =
        Uri.encodeFull('https://wa.me/$phoneNumber?text=$message');
    await launchUrlString(whatsappUrl);
  }

  /// Sends an email using the device email client.
  Future<void> _sendEmail(
    BuildContext context,
    String? email, {
    String subject = "Regarding your recent inquiry",
    String body =
        "Hello,\n\nI hope this message finds you well. I am reaching out to follow up on your recent inquiry. Please let me know how we can assist you further.\n\nBest regards,\n[Your Name]",
  }) async {
    if (email == null || email.trim().isEmpty) {
      _showSnackbar(context, 'No email found');
      return;
    }

    final String encodedSubject = Uri.encodeComponent(subject);
    final String encodedBody = Uri.encodeComponent(body);

    final Uri emailUri =
        Uri.parse("mailto:$email?subject=$encodedSubject&body=$encodedBody");

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      _showSnackbar(context, 'Could not launch Email');
    }
  }
}

/// A list view widget that displays multiple activities using [ActivityMainCard].
///
/// If the activities list is empty, shows a friendly empty state with an icon
/// and message encouraging the user to create a new activity.
///
/// Parameters:
/// - [activities]: A list of activity maps to display.
class ActivityListView extends StatefulWidget {
  final List<dynamic> activities;

  const ActivityListView({super.key, required this.activities});

  @override
  State<ActivityListView> createState() => _ActivityListViewState();
}

class _ActivityListViewState extends State<ActivityListView> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    if (widget.activities.isEmpty) {
      return _buildEmptyState(context);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Divider(color: isDark ? Colors.grey[700] : Colors.grey[300])),
                Icon(
                  _expanded ? Icons.expand_more : Icons.expand_less_sharp,
                  color: isDark ? Colors.grey[400] : Colors.black54,
                ),
                const SizedBox(width: 8),
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${widget.activities.length > 99 ? '99+' : widget.activities.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Planned Activities',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                ),
                const SizedBox(width: 8),
                Expanded(child: Divider(color: isDark ? Colors.grey[700] : Colors.grey[300])),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),
        if (_expanded)
          ...widget.activities.map((activity) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ActivityMainCard(activity: activity),
              )),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Align(
              alignment: const Alignment(0, -0.4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset('assets/empty_ghost.json', width: 260),
                  const SizedBox(height: 8),
                  Text(
                    'No Activities Found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Create your first activity to get started',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A shimmer loading placeholder for the activity list.
///
/// Used while fetching activities from the server to indicate
/// that data is loading.
class ShimmerActivityList extends StatelessWidget {
  const ShimmerActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) => const ShimmerActivityCard(),
    );
  }
}
