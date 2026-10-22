import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/screens/lead/widgets/custom_activity_widget.dart';
import 'package:mobo_crm/global_methods/widgets/image_widget/get_allimage.dart';
import 'package:mobo_crm/global_methods/widgets/shimmer/custom_shimmer.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobo_crm/utils/globals.dart';
import 'package:mobo_crm/global_methods/dialog%20boxes/activity_creation_dialog.dart';
import 'package:mobo_crm/core/company/session/company_session_manager.dart';
import 'package:mobo_crm/screens/lead/providers/activity_create_provider.dart';
import 'package:mobo_crm/screens/lead/providers/lead_data_provider.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:mobo_crm/screens/customers/provider/customer_data_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_view_provider.dart';

/// Displays the chatter/messages screen for a Lead or Opportunity.
///
/// This screen shows:
/// - Chatter actions (send message, log note, schedule activity)
/// - Activity timeline
/// - Message list grouped by date
/// - Author avatar, name, time, content, and tracking changes
///
/// It reacts to loading state from [LeadFormProvider]:
/// - Shows shimmer UI while messages are loading
/// - Displays message list once data is ready
///
/// Params:
/// - [leadData]: Current lead/opportunity record data
/// - [model]: Odoo model name (e.g. "crm.lead")
/// - [id]: Record ID used to fetch chatter messages
/// - [initialAction]: The chatter action open on arrival — 0 Send Message,
///   1 Log Note, 2 Activity
class MessagesScreen extends StatefulWidget {
  final dynamic leadData;
  final String model;
  final int id;
  final int initialAction;

  const MessagesScreen(
      {super.key,
      required this.leadData,
      required this.id,
      required this.model,
      this.initialAction = 0});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late int selectedActionIndex = widget.initialAction;

  @override
  Widget build(BuildContext context) {
    return Consumer<LeadFormProvider>(builder: (context, provider, child) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      // Messages with no text and no tracking are not drawn, so a chatter of
      // only those must still get the empty state.
      final hasVisibleMessages = provider.messageList.any((m) =>
          m.trackingValues.isNotEmpty || m.content.trim().isNotEmpty);
      if (provider.isMessageLoading) {
        return ShimmerMessagesScreen();
      } else {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF181A20) : Colors.grey[50],
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            title: Text('Messages',
                style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600)),
          ),
          backgroundColor: isDark ? const Color(0xFF181A20) : Colors.grey[50],
          floatingActionButton: selectedActionIndex == 2
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: FloatingActionButton(
                    backgroundColor: AppStyle.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onPressed: () async {
                      final session =
                          await CompanySessionManager.getCurrentSession();
                      if (mounted) {
                        showDialog(
                          context: context,
                          builder: (context) => AddActivityDialog(
                            resId: widget.id,
                            model: widget.model,
                            onSuccess: () {
                              Provider.of<ActivityCreateProvider>(context,
                                      listen: false)
                                  .fetchActivities(
                                      context, widget.id, widget.model);

                              final leaddataprovider =
                                  context.read<LeadDataProvider>();
                              final opportunitydataprovider =
                                  context.read<OpportunityDataProvider>();
                              final customerdataprovider =
                                  context.read<CustomerDataProvider>();
                              final qouteprovider =
                                  context.read<QuotationViewProvider>();

                              if (widget.leadData['type'] == 'lead') {
                                leaddataprovider.getLeads(context: context);
                              } else if (widget.leadData['type'] ==
                                  'opportunity') {
                                opportunitydataprovider.getOpportunities(
                                    context: context,
                                    isOpportunity: true,
                                    loading: false);
                              } else if (widget.leadData['type'] ==
                                  'customer') {
                                customerdataprovider.fetchCustomerData(
                                    context: context, loading: false);
                              } else {
                                qouteprovider.getQuotationsAndReport(
                                    session: session, context: context);
                              }
                            },
                          ),
                        );
                      }
                    },
                    child: const Icon(Icons.add, color: Colors.white, size: 28),
                  ),
                )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: ListView.builder(
            itemCount: selectedActionIndex == 0
                ? (hasVisibleMessages ? provider.messageList.length + 1 : 2)
                : selectedActionIndex == 2
                    ? 2
                    : provider.messageList.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Consumer<OdooClientManager>(
                    builder: (context, clientprovider, child) {
                  return ChatterActions(
                    type: widget.leadData['type'],
                    model: widget.model,
                    resId: widget.id,
                    initialAction: widget.initialAction,
                    onActionChanged: (index) {
                      setState(() {
                        selectedActionIndex = index;
                      });
                      if (index == 2) {
                        Provider.of<ActivityCreateProvider>(context,
                                listen: false)
                            .expanded = true;
                      }
                    },
                  );
                });
              }

              // Nothing to show for this record yet: distinguish "failed to
              // load" (retryable) from a genuinely empty chatter, instead of
              // leaving a blank area that looks identical to both — and, on
              // a real failure, looks identical to messages simply existing
              // but never having made it onto the screen.
              if (selectedActionIndex == 0 &&
                  index == 1 &&
                  !hasVisibleMessages) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                  child: Column(
                    children: [
                      Icon(
                        provider.messageError != null
                            ? Icons.error_outline
                            : Icons.chat_bubble_outline,
                        size: 36,
                        color: isDark ? Colors.grey[500] : Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        provider.messageError ?? 'No messages yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      if (provider.messageError != null) ...[
                        const SizedBox(height: 12),
                        Consumer<OdooClientManager>(
                            builder: (context, clientprovider, child) {
                          return TextButton(
                            onPressed: clientprovider.client == null
                                ? null
                                : () => provider.fetchMessages(
                                    clientprovider.client!,
                                    widget.model,
                                    widget.id,
                                    loading: true),
                            child: const Text('Retry'),
                          );
                        }),
                      ],
                    ],
                  ),
                );
              }

              if (selectedActionIndex == 2 && index == 1) {
                return ActivityWidget(
                  resId: widget.id,
                  model: widget.model,
                  leadType: widget.leadData['type'],
                );
              }

              if (selectedActionIndex == 1 && index == 1) {
                return ActivityWidget(
                  resId: widget.id,
                  model: widget.model,
                  leadType: widget.leadData['type'],
                );
              }

              final messageOffset = selectedActionIndex == 0 ? 1 : 2;
              final realIndex = index - messageOffset;
              final message = provider.messageList[realIndex];
              final showDateHeader = realIndex == 0 ||
                  !isSameDay(message.date,
                      provider.messageList[realIndex - 1].date);
              final hasContent = message.trackingValues.isNotEmpty ||
                  message.content.trim().isNotEmpty;

              if (!hasContent) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDateHeader)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[800] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              getDateLabel(message.date),
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.grey[300] : Colors.grey[800],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: OdooByteImage(
                              model: 'res.partner',
                              recordId: message.createId,
                              useNetworkImage: true,
                              size: 40,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.grey[850]
                                        : (message.subType == 'Discussions'
                                            ? AppColors().emailMessageColor
                                            : AppColors().fillColor),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              message.author,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.grey[900],
                                              ),
                                            ),
                                          ),
                                          Text(
                                            message.time,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isDark
                                                  ? Colors.grey[400]
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      if (message.trackingValues.isNotEmpty) ...[
                                        if (message.subType != 'Note') ...[
                                          Text(
                                            message.subType,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: message.trackingValues
                                              .map((t) {
                                            final String oldVal = t
                                                        .oldValue.isEmpty ||
                                                    t.oldValue == '0.0'
                                                ? 'None'
                                                : t.oldValue;
                                            final String newval = t
                                                        .newValue.isEmpty ||
                                                    t.newValue == '0.0'
                                                ? 'None'
                                                : t.newValue;

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4.0),
                                              child: RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: isDark
                                                        ? Colors.grey[300]
                                                        : Colors.grey[800],
                                                  ),
                                                  children: [
                                                    TextSpan(text: oldVal),
                                                    TextSpan(
                                                        text: '→',
                                                        style: TextStyle(
                                                            fontSize: 25)),
                                                    TextSpan(
                                                        text: newval,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor)),
                                                    TextSpan(
                                                      text: '  (${t.fieldId})',
                                                      style: TextStyle(
                                                          color: isDark
                                                              ? Colors.grey[300]
                                                              : Colors.grey[800]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ] else
                                        Text(
                                          parseHtmlString(message.content),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.grey[900],
                                            height: 1.4,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }
    });
  }

  /// Parses and sanitizes HTML content from Odoo chatter messages.
  ///
  /// Converts HTML-formatted message content into plain readable text
  /// by stripping tags and extracting visible body text.
  ///
  /// Params:
  /// - [htmlString]: Raw HTML string from Odoo message body
  ///
  /// Returns:
  /// - Cleaned plain text string
  String parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text.trim() ?? '';
  }

  /// Checks whether two [DateTime] objects fall on the same calendar day.
  ///
  /// Used to group messages under a single date header in the UI.
  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Returns a user-friendly date label for message grouping.
  ///
  /// Logic:
  /// - Returns `"Today"` if the given date is the current date
  /// - Otherwise formats the date as `MMM d, yyyy` (e.g. "Feb 26, 2026")
  ///
  /// Params:
  /// - [date]: Message timestamp
  ///
  /// Returns:
  /// - Formatted label string for date headers
  String getDateLabel(DateTime date) {
    final now = DateTime.now();
    if (isSameDay(date, now)) return "Today";
    return DateFormat('MMM d, yyyy').format(date);
  }
}
