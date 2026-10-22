import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/global_methods/dialog%20boxes/activity_creation_dialog.dart';
import 'package:mobo_crm/global_methods/widgets/image_widget/get_allimage.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/mentionble_textfield.dart';
import 'package:mobo_crm/screens/customers/provider/customer_data_provider.dart';
import 'package:mobo_crm/screens/lead/providers/activity_create_provider.dart';
import 'package:mobo_crm/global_methods/widgets/shimmer/custom_shimmer.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/lead/providers/lead_data_provider.dart';
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_view_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_view_provider.dart';

import 'package:mention_tag_text_field/mention_tag_text_field.dart';
import 'package:provider/provider.dart';

import '../../../core/company/session/company_session_manager.dart';
import 'package:mobo_crm/utils/globals.dart';
import '../../../utils/snackbar.dart';

/// A widget that displays a list of planned activities for a given record.
///
/// Fetches activities from the Odoo backend and allows marking them as done
/// or cancelling them. Shows deadlines and states like 'overdue', 'today',
/// 'tomorrow', or 'planned'.
class ActivityWidget extends StatefulWidget {
  final int resId;
  final String model;
  final String leadType;
  final VoidCallback? onAddActivity;
  final bool hideHeader;

  const ActivityWidget({
      super.key,
      required this.resId,
      required this.model,
      required this.leadType,
      this.onAddActivity,
      this.hideHeader = false,
  });

  @override
  State<ActivityWidget> createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<ActivityWidget> {
  @override
  void initState() {
    super.initState();
    Provider.of<ActivityCreateProvider>(context, listen: false)
        .fetchActivities(context, widget.resId, widget.model);
  }

  /// Calculates the number of days left until the given [dateStr].
  ///
  /// Returns negative value if the deadline has passed.
  int daysLeft(String dateStr) {
    final deadline = DateTime.tryParse(dateStr);
    if (deadline == null) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(deadline.year, deadline.month, deadline.day);

    return targetDate.difference(today).inDays;
  }

  /// Returns a human-readable text for the deadline, e.g., "Today:", "Tomorrow:",
  /// or "3 days remaining:".
  String getDeadlineText(String dateStr) {
    final days = daysLeft(dateStr);

    if (days < 0) {
      return '${-days} days overdue: ';
    } else if (days == 0) {
      return 'Today: ';
    } else if (days == 1) {
      return 'Tomorrow: ';
    } else {
      return '$days days remaining: ';
    }
  }

  /// Returns the state of the activity based on the deadline.
  ///
  /// Possible return values: 'overdue', 'today', 'tomorrow', 'planned'.
  String getState(String dateStr) {
    final days = daysLeft(dateStr);

    if (days < 0) {
      return 'overdue';
    } else if (days == 0) {
      return 'today';
    } else if (days == 1) {
      return 'tomorrow';
    } else {
      return 'planned';
    }
  }

  /// Returns a color corresponding to the activity deadline.
  Color getDeadlineColor(int days) {
    if (days < 0) {
      return Colors.red;
    } else if (days == 0) {
      return Colors.orange;
    } else if (days == 1) {
      return const Color(0xFF43B75D);
    } else {
      return const Color(0xFF43B75D);
    }
  }

  IconData _getActivityIcon(String type) {
    final lower = type.toLowerCase();
    if (lower.contains('call') || lower.contains('phone')) {
      return HugeIcons.strokeRoundedCall;
    }
    if (lower.contains('whatsapp')) return HugeIcons.strokeRoundedWhatsapp;
    if (lower.contains('email') || lower.contains('mail')) {
      return HugeIcons.strokeRoundedMail02;
    }
    if (lower.contains('sms') || lower.contains('message')) {
      return HugeIcons.strokeRoundedMessage01;
    }
    if (lower.contains('meeting') || lower.contains('calendar')) {
      return HugeIcons.strokeRoundedCalendar02;
    }
    if (lower.contains('todo') ||
        lower.contains('to-do') ||
        lower.contains('task')) {
      return HugeIcons.strokeRoundedCheckList;
    }
    if (lower.contains('document')) {
      return Icons.article_outlined;
    }
    return HugeIcons.strokeRoundedNotification01;
  }

  Color _getActivityColor(String type) {
    final lower = type.toLowerCase();
    if (lower.contains('call') || lower.contains('phone')) return Colors.blue;
    if (lower.contains('whatsapp')) return Colors.green;
    if (lower.contains('email')) return Colors.red;
    if (lower.contains('sms') || lower.contains('message')) return Colors.orange;
    if (lower.contains('meeting') || lower.contains('calendar')) return Colors.purple;
    if (lower.contains('todo') || lower.contains('to-do') || lower.contains('task')) {
      return const Color(0xFF43B75D);
    }
    if (lower.contains('document')) return Colors.teal;
    return const Color(0xFF43B75D);
  }

  String _formatDate(String dateStr) {
    final date = DateTime.tryParse(dateStr);
    if (date == null) return dateStr;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _buildStatusBadge(int days, bool isDark) {
    final Color bgColor;
    final Color textColor;
    final String text;
    if (days < 0) {
      bgColor = const Color(0xFFFFEBEB);
      textColor = const Color(0xFFDC2626);
      text = '${-days} days overdue';
    } else if (days == 0) {
      bgColor = const Color(0xFFFFF3CD);
      textColor = const Color(0xFFD97706);
      text = 'Today';
    } else {
      bgColor = const Color(0xFFFFFBEB);
      textColor = const Color(0xFFD97706);
      text = '$days days left';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  /// Marks an activity as done and refreshes the relevant providers.
  ///
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> markDone(
      int activityId,
      OpportunityDataProvider oppodata,
      LeadDataProvider leaddata,
      CustomerDataProvider customerdata,
      QuotationViewProvider saledata,
      BuildContext ctx) async {
    try {
      await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'action_done',
        'args': [activityId],
        'kwargs': {},
      });
      if (ctx.mounted) {
        CustomSnackbar.showSuccess(context, "Activity Marked Done");
      }
      if (ctx.mounted) {
        await Provider.of<ActivityCreateProvider>(ctx, listen: false)
            .fetchActivities(ctx, widget.resId, widget.model);
      }
      if (widget.leadType == 'opportunity') {
        if (ctx.mounted) {
          await oppodata.getOpportunities(
              context: ctx, isOpportunity: true, isLead: false);
        }
      } else if (widget.leadType == 'lead') {
        if (ctx.mounted) {
          leaddata.getLeads(context: ctx);
        }
      } else if (widget.leadType == 'customer') {
        if (ctx.mounted) {
          customerdata.fetchCustomerData(context: ctx);
        }
      } else {
        final session = await CompanySessionManager.getCurrentSession();
        if (ctx.mounted) {
          saledata.getQuotationsAndReport(context: ctx, session: session);
        }
      }
      return true;
    } catch (e) {
      if (ctx.mounted) {
        CustomSnackbar.showError(context, "Failed To Mark Done");
      }
      return false;
    }
  }

  /// Cancels an activity and refreshes the relevant providers.
  Future<void> cancelActivity(
      int activityId,
      OpportunityDataProvider oppodata,
      LeadDataProvider leaddata,
      QuotationViewProvider saledata,
      CustomerDataProvider customerdata,
      BuildContext ctx) async {
    try {
      await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'unlink',
        'args': [activityId],
        'kwargs': {},
      });
      if (ctx.mounted) {
        CustomSnackbar.showSuccess(context, "Activity Cancelled Successfully");
      }
      if (ctx.mounted) {
        Provider.of<ActivityCreateProvider>(ctx, listen: false)
            .fetchActivities(ctx, widget.resId, widget.model);
      }
      if (widget.leadType == 'opportunity') {
        if (ctx.mounted) {
          await oppodata.getOpportunities(
              context: ctx, isOpportunity: true, isLead: false);
        } else if (widget.leadType == 'customer') {
          if (ctx.mounted) {
            customerdata.fetchCustomerData(context: ctx);
          }
        }
      } else if (widget.leadType == 'lead') {
        if (ctx.mounted) {
          leaddata.getLeads(context: ctx);
        }
      } else {
        final session = await CompanySessionManager.getCurrentSession();
        if (ctx.mounted) {
          saledata.getQuotationsAndReport(context: ctx, session: session);
        }
      }
    } catch (e) {
      if (ctx.mounted) {
        CustomSnackbar.showError(context, "Failed To Cancel");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<ActivityCreateProvider>(
        builder: (context, activtyprovider, child) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
        child: Column(
          children: [
            if (!widget.hideHeader)
              GestureDetector(
                onTap: () => setState(
                    () => activtyprovider.expanded = !activtyprovider.expanded),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Divider()),
                      Icon(activtyprovider.expanded
                          ? Icons.expand_more
                          : Icons.expand_less_sharp),
                      const SizedBox(width: 8),
                      if (!activtyprovider.loading &&
                          activtyprovider.activities.isNotEmpty) ...[
                        Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${activtyprovider.activities.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        'Planned Activities',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Divider()),
                    ],
                  ),
                ),
              ),
            if (widget.hideHeader || activtyprovider.expanded)
              activtyprovider.loading
                  ? ActivityShimmerWidget()
                  : activtyprovider.activities.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color:
                                isDark ? Colors.grey[850] : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? Colors.grey[700]!
                                  : Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'No activities found.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : Column(
                          children: activtyprovider.activities
                              .map((activity) {
                            final int days = daysLeft(activity.deadline);
                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 14),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.grey[800]
                                      : Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.grey[700]!
                                        : Colors.grey[200]!,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.06),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Builder(builder: (context) {
                                          final actColor = _getActivityColor(activity.type);
                                          return Container(
                                            width: 46,
                                            height: 46,
                                            decoration: BoxDecoration(
                                              color: actColor.withOpacity(0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              _getActivityIcon(activity.type),
                                              color: actColor,
                                              size: 22,
                                            ),
                                          );
                                        }),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                            children: [
                                              Text(
                                                activity.type,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.w600,
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.person_outline,
                                                    size: 13,
                                                    color:
                                                        Colors.grey[500],
                                                  ),
                                                  const SizedBox(
                                                      width: 4),
                                                  Text(
                                                    activity.user,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors
                                                          .grey[500],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        _buildStatusBadge(days, isDark),
                                      ],
                                    ),
                                    if (activity.summary.isNotEmpty) ...[
                                      const SizedBox(height: 14),
                                      Container(
                                        width: double.infinity,
                                        padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 14,
                                                vertical: 12),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? Colors.grey[850]
                                              : const Color(0xFFF5F5F5),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          activity.summary,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: isDark
                                                ? Colors.grey[300]
                                                : Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 14),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time_rounded,
                                          size: 14,
                                          color: Colors.grey[500],
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Due',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatDate(activity.deadline),
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Consumer6<
                                        OdooClientManager,
                                        LeadDataProvider,
                                        LeadFormProvider,
                                        OpportunityDataProvider,
                                        QuotationViewProvider,
                                        CustomerDataProvider>(
                                      builder: (context,
                                          clientprovider,
                                          leaddataprovider,
                                          leadformprovider,
                                          opportunitydataprovider,
                                          quotationviewprovider,
                                          customerdataprovider,
                                          child) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () =>
                                                    cancelActivity(
                                                  activity.id,
                                                  opportunitydataprovider,
                                                  leaddataprovider,
                                                  quotationviewprovider,
                                                  customerdataprovider,
                                                  context,
                                                ),
                                                child: Container(
                                                  height: 46,
                                                    decoration:
                                                        BoxDecoration(
                                                      color: isDark
                                                          ? Colors.grey[700]
                                                          : Colors.white,
                                                      border: Border.all(
                                                        color: isDark
                                                            ? Colors.grey[600]!
                                                            : AppStyle.primaryColor,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(8),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.close,
                                                          size: 16,
                                                          color: isDark
                                                              ? Colors.grey[300]
                                                              : AppStyle.primaryColor,
                                                        ),
                                                        const SizedBox(
                                                            width: 6),
                                                        Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                            color: isDark
                                                                ? Colors.grey[300]
                                                                : AppStyle.primaryColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () async {
                                                  final success =
                                                      await markDone(
                                                    activity.id,
                                                    opportunitydataprovider,
                                                    leaddataprovider,
                                                    customerdataprovider,
                                                    quotationviewprovider,
                                                    context,
                                                  );
                                                  if (success) {
                                                    leadformprovider
                                                        .fetchMessages(
                                                      clientprovider
                                                          .client!,
                                                      widget.model,
                                                      widget.resId,
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  height: 46,
                                                  decoration:
                                                      BoxDecoration(
                                                    color: isDark
                                                        ? Colors.grey[900]
                                                        : AppStyle.primaryColor,
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(8),
                                                  ),
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .check_circle_outline,
                                                        size: 16,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 6),
                                                      Text(
                                                        'Mark as Done',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                          color:
                                                              Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
          ],
        ),
      );
    });
  }
}

/// A widget that provides Chatter actions for a record: sending messages, logging notes, or adding activities.
class ChatterActions extends StatefulWidget {
  final String model;
  final int resId;
  final String type;
  final Function(int) onActionChanged;

  /// The action selected on arrival: 0 Send Message, 1 Log Note, 2 Activity.
  final int initialAction;

  const ChatterActions({
    super.key,
    required this.type,
    required this.model,
    required this.resId,
    required this.onActionChanged,
    this.initialAction = 0,
  });

  @override
  State<ChatterActions> createState() => _ChatterActionsState();
}

/// Handles the state and UI of the chatter actions, including animations
/// for message input, log notes, and activity creation dialog.
class _ChatterActionsState extends State<ChatterActions>
    with SingleTickerProviderStateMixin {
  bool showSendField = true;
  bool showLogField = false;
  bool showActivityDialog = false;
  bool isSubmitting = false;
  bool firstValue = false;
  List mentionedCustomer = [];
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _selectedButtonIndex = 0;

  // The mention field's own controllers. Reading the text straight off them
  // removes the mirror that `onTextChanged` used to keep: a single missed
  // callback left the mirror empty, and an empty mirror disabled the send
  // button, so a typed message could not be sent at all.
  final MentionTagTextEditingController sendController =
      MentionTagTextEditingController();
  final MentionTagTextEditingController logController =
      MentionTagTextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedButtonIndex = widget.initialAction;
    showSendField = widget.initialAction == 0;
    showLogField = widget.initialAction == 1;
    showActivityDialog = widget.initialAction == 2;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: showActivityDialog ? 0.0 : 1.0,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    sendController.dispose();
    logController.dispose();
    super.dispose();
  }

  void _toggleInputField(
      int index,
      LeadDataProvider leaddataprovider,
      OpportunityDataProvider opportunitydataprovider,
      QuotationViewProvider qouteprovider,
      OdooClientManager clientprovider,
      CustomerDataProvider customerdataprovider,
      String type,
      BuildContext currentCont) {
    setState(() {
      if (index == _selectedButtonIndex &&
          (showSendField || showLogField || showActivityDialog)) {
        showSendField = false;
        showLogField = false;
        showActivityDialog = false;
        _animationController.reverse();
      } else {
        _selectedButtonIndex = index;
        widget.onActionChanged(index);
        if (index == 0) {
          showSendField = true;
          showLogField = false;
          showActivityDialog = false;
          _animationController.forward();
        } else if (index == 1) {
          showSendField = false;
          showLogField = true;
          showActivityDialog = false;
          _animationController.forward();
        } else if (index == 2) {
          showSendField = false;
          showLogField = false;
          showActivityDialog = true;
          _animationController.reverse();
        }
        firstValue = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActionButtons(theme),
          if (showSendField || showLogField)
            SizeTransition(
              sizeFactor: _animation,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 22.0),
                child: Column(
                  children: [
                    if (showSendField)
                      _buildMessageInput(
                        sendController,
                        'comment',
                        'Type your message here...',
                        theme,
                        HugeIcons.strokeRoundedMessageMultiple01,
                      ),
                    if (showLogField)
                      _buildMessageInput(
                        logController,
                        'note',
                        'Enter a log note...',
                        theme,
                        Icons.note_outlined,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        _buildActionButton(0, 'Message'),
        const SizedBox(width: 8),
        _buildActionButton(1, 'Log Note'),
        const SizedBox(width: 8),
        _buildActionButton(2, 'Activity'),
      ],
    );
  }

  Widget _buildActionButton(int index, String label) {
    final isSelected = _selectedButtonIndex == index &&
        (showSendField || showLogField || showActivityDialog);

    return Consumer5<LeadDataProvider, OpportunityDataProvider,
            QuotationViewProvider, OdooClientManager, CustomerDataProvider>(
        builder: (context, leaddataprovider, opportunityprovider, quoteprovider,
            clientprovider, customerdataprovider, child) {
      return Expanded(
        child: _buildPillTab(
          context: context,
          label: label,
          isSelected: isSelected,
          onTap: () => _toggleInputField(
            index,
            leaddataprovider,
            opportunityprovider,
            quoteprovider,
            clientprovider,
            customerdataprovider,
            widget.type,
            context,
          ),
        ),
      );
    });
  }

  Widget _buildPillTab({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
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

  Widget _buildMessageInput(
    MentionTagTextEditingController controller,
    String buttontype,
    String hint,
    ThemeData theme,
    IconData prefixIcon,
  ) {
    return Consumer2<OdooClientManager, LeadFormProvider>(
      builder: (context, clientProvider, leadFormProvider, child) {
        return MentionTagTextFieldExample(
          // Message and Log Note sit in the same slot. Without a key the
          // field's state, which binds its controller once, was carried over
          // when switching: Log Note typed into the Message controller, so
          // its send button saw an empty box and never sent.
          key: ValueKey(buttontype),
          hintText: hint,
          client: clientProvider.client!,
          prefixIcon: Icon(
            prefixIcon,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.grey[600],
            size: 18,
          ),
          controller: controller,
          // The return key sends instead of adding a newline.
          onSubmitted: (_) => _handleSubmit(
            controller,
            clientProvider,
            leadFormProvider,
            buttontype,
            context,
          ),
          // An unwrapped IconButton: a Row here claimed its own width inside
          // the decoration's suffix box and pushed the button past the field's
          // clipped edge, where taps no longer reached it.
          suffixIcon: _buildSendButton(
              controller, clientProvider, leadFormProvider, buttontype, theme),
          onTextChanged: (value, text) {
            // Only the mentions and the button's enabled look need this; the
            // text itself lives in the controller above.
            setState(() => mentionedCustomer = value);
          },
          onMentionTapped: (value, text) {
            setState(() => mentionedCustomer = value);
          },
        );
      },
    );
  }

  Widget _buildSendButton(
    MentionTagTextEditingController controller,
    OdooClientManager clientProvider,
    LeadFormProvider leadFormProvider,
    String type,
    ThemeData theme,
  ) {
    final bool hasText = controller.text.trim().isNotEmpty;

    return IconButton(
      // Sized to the suffix box the decoration allots, so the whole tap target
      // stays inside the field instead of spilling over its clipped edge.
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      visualDensity: VisualDensity.compact,
      tooltip: type == 'comment' ? 'Send message' : 'Log note',
      icon: isSubmitting
          ? SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).primaryColor,
              ),
            )
          : Icon(
              Icons.send,
              size: 20,
              color: hasText
                  ? Theme.of(context).primaryColor
                  : (Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[600]
                      : Colors.grey[400]),
            ),
      // Only a request in flight blocks the tap. An empty box is answered in
      // _handleSubmit rather than left as a dead button with no explanation.
      onPressed: isSubmitting
          ? null
          : () => _handleSubmit(
              controller, clientProvider, leadFormProvider, type, context),
    );
  }

  Future<void> _handleSubmit(
      MentionTagTextEditingController controller,
      OdooClientManager clientProvider,
      LeadFormProvider leadFormProvider,
      String type,
      BuildContext ctx) async {
    if (isSubmitting) return;

    final isNote = type != 'comment';

    // getText expands the mention placeholders back into their labels, which
    // is what convertMentionsToHtml matches on below.
    final message = controller.getText.trim();
    if (message.isEmpty) {
      CustomSnackbar.showWarning(
        ctx,
        isNote ? 'Write a note first' : 'Write a message first',
      );
      return;
    }

    setState(() => isSubmitting = true);
    var posted = false;

    try {
      // The controller can still remember mentions from an earlier message,
      // so only the ones this text actually carries are notified.
      final mentions = mentionedCustomer
          .where((customer) => message.contains('@${customer.name}'))
          .toList();
      final body = convertMentionsToHtml(message, mentions);
      // Only partners that got a link are notified: "@Marc Demo" also
      // contains "@Marc", but doesn't mention Marc.
      final partnerIds = getPartnerIds(mentions
          .where((customer) => body.contains('data-oe-id="${customer.id}"'))
          .toList());

      // Posted through the record's own message_post rather than by creating
      // a mail.message row directly. Creating the row needed create rights on
      // mail.message, which only administrators have, and it pinned the
      // subtype to the literal ids 1 and 2 — those are not mail.mt_comment
      // and mail.mt_note on every database, which is why log notes in
      // particular never turned up in the chatter. message_post resolves the
      // subtype by XML id, stamps the author, fills the record name and
      // notifies followers and mentioned partners exactly like Odoo's own
      // chatter does.
      // The session service comes from the provider: it is injected into
      // providers, never registered as a Provider of its own, so looking it
      // up from the context threw before anything was sent.
      await leadFormProvider.sessionService.callKwWithCompanyDynamic({
        'model': widget.model,
        'method': 'message_post',
        'args': [
          [widget.resId]
        ],
        'kwargs': {
          'body': body,
          // message_post escapes a plain-string body (only a server-side
          // Markup is kept as HTML), so without this the mention links were
          // stored as literal "<a href=…>" text in the chatter. Odoo provides
          // the flag for exactly this RPC case; the body is built as safe
          // HTML below.
          'body_is_html': true,
          'message_type': 'comment',
          'subtype_xmlid': isNote ? 'mail.mt_note' : 'mail.mt_comment',
          if (partnerIds.isNotEmpty) 'partner_ids': partnerIds,
        },
      });

      // A failed post raises, so returning at all means the message exists.
      // Its return value is no proof either way: only up to 18 is it the
      // bare message id, so insisting on one reported a delivered message
      // as failed on newer servers (and invited a duplicate retry).
      posted = true;

      await leadFormProvider.fetchMessages(
          clientProvider.client!, widget.model, widget.resId);

      if (ctx.mounted) {
        CustomSnackbar.showSuccess(
          ctx,
          isNote ? 'Note logged successfully' : 'Message sent successfully',
        );
      }
    } catch (e) {
      if (ctx.mounted) {
        CustomSnackbar.showError(
          ctx,
          isNote ? 'Failed to log note: $e' : 'Failed to send message: $e',
        );
      }
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }

    // A failed post leaves the composer open with the text still in it, so
    // nothing has to be typed again.
    if (!posted || !mounted) return;

    // The controller belongs to this state now, so clearing it empties the
    // visible field; it no longer depends on the field being disposed.
    controller.clear();
    mentionedCustomer = [];
    _animationController.reverse();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          showSendField = false;
          showLogField = false;
        });
      }
    });
  }

  /// The typed [message] as an HTML body, with each mention turned into the
  /// partner link Odoo's own chatter uses.
  ///
  /// The text itself is escaped, so a typed "<" or "&" shows as typed rather
  /// than being read as markup, and line breaks are kept.
  String convertMentionsToHtml(String message, List mentionedCustomer) {
    const escape = HtmlEscape(HtmlEscapeMode.element);
    String result = escape.convert(message);

    // Links go in through placeholders, so a later, shorter name ("@Marc")
    // can't match inside a link already made for a longer one ("@Marc Demo").
    final links = <String>[];
    final byLongestName = [...mentionedCustomer]
      ..sort((a, b) => (b.name as String).length - (a.name as String).length);
    for (var customer in byLongestName) {
      final int id = customer.id;
      final label = '@${escape.convert(customer.name)}';
      if (!result.contains(label)) continue;

      result = result.replaceFirst(label, '\u0000${links.length}\u0000');
      links.add('<a href="/odoo/res.partner/$id" '
          'class="o_mail_redirect" data-oe-id="$id" data-oe-model="res.partner" target="_blank">'
          '$label</a>');
    }

    result = result.replaceAll('\n', '<br>');
    for (var i = 0; i < links.length; i++) {
      result = result.replaceFirst('\u0000$i\u0000', links[i]);
    }
    return result;
  }

  List<int> getPartnerIds(List mentionedCustomer) {
    return mentionedCustomer.map<int>((customer) => customer.id).toList();
  }
}
