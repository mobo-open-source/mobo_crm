import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:mobo_crm/core/colors/app_colors.dart';
import 'package:mobo_crm/screens/myActivities/activities_main/activity_main_provider.dart';
import 'package:mobo_crm/utils/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../core/company/session/company_session_manager.dart';

/// A full-screen page that reflects the exact structural layout of the
/// Sales OS Sales Order form view for displaying activity details.
class ActivityDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> activity;
  final String activityType;

  const ActivityDetailsScreen(
      {super.key, required this.activity, required this.activityType});

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  late Map<String, dynamic> _activity;

  @override
  void initState() {
    super.initState();
    _activity = Map<String, dynamic>.from(widget.activity);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.animation!.addListener(_onTabAnimation);
  }

  void _onTabAnimation() {
    if (!mounted) return;
    final newIndex = _tabController.animation!.value.round();
    if (newIndex != _selectedTabIndex) {
      setState(() => _selectedTabIndex = newIndex);
    }
  }

  @override
  void dispose() {
    _tabController.animation!.removeListener(_onTabAnimation);
    _tabController.dispose();
    super.dispose();
  }

  String _getDisplaySummary() {
    final summary = _activity['summary'];
    if (summary == null ||
        summary == false ||
        summary.toString().isEmpty ||
        summary.toString() == 'false' ||
        summary.toString() == 'null' ||
        summary.toString() == 'N/A') {
      if (_activity['activity_type_id'] is List &&
          (_activity['activity_type_id'] as List).length > 1) {
        return _activity['activity_type_id'][1].toString();
      }
      return 'Activity';
    }
    return summary.toString();
  }

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

  String getActivityStateValue(String activityState) {
    switch (activityState) {
      case 'overdue':
        return "Overdue";
      case 'today':
        return "Today";
      case 'planned':
        return "Planned";
      default:
        return "Planned";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final deadlineStr = _activity['date_deadline'];
    DateTime? deadline;
    if (deadlineStr != null && deadlineStr != false) {
      deadline = DateTime.tryParse(deadlineStr.toString());
    }

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

    final scaffoldBg = isDark ? Colors.grey[900] : Colors.grey[50];
    final activity = _activity;
    final contactPhone = activity['contact_phone']?.toString();
    final contactEmail = activity['contact_email']?.toString();

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(HugeIcons.strokeRoundedArrowLeft01,
              color: isDark ? Colors.white : Colors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Activity Details',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              HugeIcons.strokeRoundedPencilEdit02,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              size: 22,
            ),
            onPressed: () async {
              final provider =
                  Provider.of<ActivitiesMainProvider>(context, listen: false);
              final client = await CompanySessionManager.getClientEnsured();
              if (mounted) {
                provider.showEditActivityDialog(
                  context, _activity, client,
                  onSaved: (data) {
                    if (!mounted) return;
                    setState(() {
                      if (data['note'] != null) {
                        _activity['note'] = data['note'];
                      }
                      if (data['summary'] != null) {
                        _activity['summary'] = data['summary'];
                      }
                      if (data['date_deadline'] != null) {
                        _activity['date_deadline'] = data['date_deadline'];
                      }
                      if (data['activity_type_id'] != null &&
                          data['activity_type_name'] != null) {
                        _activity['activity_type_id'] = [
                          data['activity_type_id'],
                          data['activity_type_name'],
                        ];
                      }
                      if (data['user_id'] != null &&
                          data['user_name'] != null) {
                        _activity['user_id'] = [
                          data['user_id'],
                          data['user_name'],
                        ];
                      }
                    });
                  },
                );
              }
            },
          ),
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
                value: 'cancel',
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
            onSelected: (value) async {
              final provider =
                  Provider.of<ActivitiesMainProvider>(context, listen: false);
              final client = await CompanySessionManager.getClientEnsured();

              if (value == 'mark_done') {
                try {
                  await provider.markActivityDone(client, _activity);
                  if (mounted) {
                    CustomSnackbar.showSuccess(
                        context, 'Activity marked as done');
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (mounted) {
                    CustomSnackbar.showError(context, 'Failed to mark done');
                  }
                }
              } else if (value == 'cancel') {
                if (mounted) {
                  provider.showDeleteConfirmation(
                      _activity, client, context);
                }
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  _getDisplaySummary(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: getActivityStateColor(activityState)
                                      .withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  getActivityStateValue(activityState),
                                  style: TextStyle(
                                    color: getActivityStateColor(activityState),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          Text(
                            _activity['res_name']?.toString() ??
                                'No Related Record',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),

                          if (_activity['user_id'] != null &&
                              _activity['user_id'] != false) ...[
                            const SizedBox(height: 8),
                            Text(
                              _activity['user_id'][1].toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),

                          Text(
                            deadlineStr?.toString() ?? 'No Deadline',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF0095FF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildCommunicationButton(
                                icon: HugeIcons.strokeRoundedCall,
                                color: Colors.blue,
                                onTap: () => _makePhoneCall(contactPhone),
                              ),
                              _buildCommunicationButton(
                                icon: HugeIcons.strokeRoundedMessage01,
                                color: Colors.orange,
                                onTap: () => _sendSMS(contactPhone, "Hello"),
                              ),
                              _buildCommunicationButton(
                                icon: HugeIcons.strokeRoundedWhatsapp,
                                color: Colors.green,
                                onTap: () =>
                                    _openWhatsAppChat(contactPhone, "Hello"),
                              ),
                              _buildCommunicationButton(
                                icon: HugeIcons.strokeRoundedMail02,
                                color: Colors.red,
                                onTap: () => _sendEmail(contactEmail),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: Row(
                        children: [
                          Expanded(child: _buildTabItem('Details', 0, isDark)),
                          const SizedBox(width: 8),
                          Expanded(child: _buildTabItem('Notes', 1, isDark)),
                          const SizedBox(width: 8),
                          Expanded(child: _buildTabItem('Contact', 2, isDark)),
                        ],
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[850] : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black26
                                : Colors.black.withOpacity(0.05),
                            blurRadius: 16,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: 380.0,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildDetailsTab(isDark),
                            _buildNotesTab(isDark),
                            _buildContactTab(isDark),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String text, int index, bool isDark) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        if (_tabController.index != index) {
          _tabController.index = index;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey[400] : Colors.grey[700]),
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenteredLottie({
    required String lottie,
    required String title,
    String? subtitle,
    required bool isDark,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Align(
              alignment: const Alignment(0, -0.7),
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
      title: 'No notes available',
      isDark: isDark,
    );
  }

  Widget _buildDetailsTab(bool isDark) {
    final borderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
    final headerBg =
        isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF8F9FA);
    final headerTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white : Colors.grey[800],
    );
    final cellTextStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: isDark ? Colors.grey[300] : Colors.grey[700],
    );

    final details = [
      {
        'label': 'Reference ID',
        'value': _activity['id']?.toString() ?? 'N/A'
      },
      {
        'label': 'Related Model',
        'value': _activity['res_model']?.toString() ?? 'N/A'
      },
      {
        'label': 'Creation Date',
        'value': _activity['create_date']?.toString() ?? 'N/A'
      },
      {'label': 'Activity Type', 'value': widget.activityType},
    ];

    return SingleChildScrollView(
      child: Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder(
                horizontalInside: BorderSide(color: borderColor, width: 1),
              ),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: headerBg,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Text('Field', style: headerTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Text('Value', style: headerTextStyle),
                    ),
                  ],
                ),
                ...details.map((detail) => TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Text(
                            detail['label']!,
                            style: cellTextStyle.copyWith(
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Text(detail['value']!, style: cellTextStyle),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotesTab(bool isDark) {
    final note = _activity['note'];

    return _buildProfessionalCard(
      isDark: isDark,
      children: [
        (note != null && note != false && note != 'N/A' && note.toString().trim().isNotEmpty)
            ? Text(
                parseHtmlString(note.toString()),
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                  height: 1.6,
                ),
              )
            : Expanded(child: _buildEmptyState(context))
      ],
    );
  }

  Widget _buildContactTab(bool isDark) {
    final activity = _activity;
    final contactName = activity['contact_name']?.toString();
    final contactPhone = activity['contact_phone']?.toString();
    final contactEmail = activity['contact_email']?.toString();

    final borderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
    final headerBg =
        isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF8F9FA);
    final headerTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white : Colors.grey[800],
    );
    final cellTextStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: isDark ? Colors.grey[300] : Colors.grey[700],
    );

    final contacts = <Map<String, String>>[];
    if (contactName != null && contactName != 'false' && contactName != 'N/A') {
      contacts.add({'label': 'Name', 'value': contactName});
    }
    if (contactPhone != null &&
        contactPhone != 'false' &&
        contactPhone != 'N/A') {
      contacts.add({'label': 'Phone', 'value': contactPhone});
    }
    if (contactEmail != null &&
        contactEmail != 'false' &&
        contactEmail != 'N/A') {
      contacts.add({'label': 'Email', 'value': contactEmail});
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(color: borderColor, width: 1),
              ),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: headerBg,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Text('Field', style: headerTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Text('Value', style: headerTextStyle),
                    ),
                  ],
                ),
                ...contacts.map((contact) => TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Text(contact['label']!,
                              style: cellTextStyle.copyWith(
                                  fontWeight: FontWeight.w600)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Text(contact['value']!, style: cellTextStyle),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommunicationButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  Widget _buildProfessionalCard({
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String parseHtmlString(String htmlString) {
    try {
      final document = parse(htmlString);
      return document.body?.text ?? '';
    } catch (_) {
      return htmlString;
    }
  }

  Future<void> _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) return;
    await launchUrlString('tel:$phoneNumber');
  }

  Future<void> _sendSMS(String? phoneNumber, String message) async {
    if (phoneNumber == null || phoneNumber.isEmpty) return;
    await launchUrlString('sms:$phoneNumber?body=$message');
  }

  Future<void> _openWhatsAppChat(String? phoneNumber, String message) async {
    if (phoneNumber == null || phoneNumber.isEmpty) return;
    await launchUrlString('https://wa.me/$phoneNumber?text=$message');
  }

  Future<void> _sendEmail(String? email) async {
    if (email == null || email.isEmpty) return;
    await launchUrl(Uri.parse("mailto:$email"));
  }
}

/// Convenience helper for building an [ElevatedButton] from a [ButtonStyle].
extension ElevatedButtonExtension on ButtonStyle {
  Widget contentBuilder(
      {required Widget child, required VoidCallback? onPressed}) {
    return ElevatedButton(
      style: this,
      onPressed: onPressed,
      child: child,
    );
  }
}
