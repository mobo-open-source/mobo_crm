import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/global_methods/widgets/image_widget/get_allimage.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/discuss/providers/chat_provider.dart';
import 'package:mobo_crm/screens/discuss/providers/discuss_provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';

/// Chat screen for Odoo Discuss channels.
///
/// Displays real-time conversation messages for a specific
/// Odoo channel (private chat, group, or broadcast channel).
///
/// Features:
/// - Loads messages using [OdooChatProvider]
/// - Supports infinite scroll (pagination)
/// - Displays date headers (Today, Yesterday, formatted date)
/// - Groups messages sent within 1 minute
/// - Shows sender avatar for group/channel chats
/// - Allows sending messages
/// - Shows loading indicators for:
///     • Initial load
///     • Pagination
///     • Message sending
///
/// Parameters:
/// - [channelId]: Odoo mail channel ID
/// - [client]: Active [OdooClient] instance
/// - [avatar]: Avatar widget shown in AppBar
/// - [name]: Channel or user name
/// - [discussprovider]: Parent DiscussProvider instance
/// - [channelType]: Type of channel (e.g., 'chat', 'group', 'channel')
/// - [isOdoo18]: Indicates if running on Odoo v18 (default: false)
///
/// This widget uses [ChangeNotifierProvider] to inject
/// [OdooChatProvider] for state management.
class OdooChatScreen extends StatelessWidget {
  final int channelId;
  final OdooClient client;
  final Widget avatar;
  final String name;
  final DiscussProvider discussprovider;
  final String channelType;
  final bool isOdoo18;

  const OdooChatScreen(
      {super.key,
      required this.avatar,
      required this.channelId,
      required this.client,
      required this.discussprovider,
      required this.channelType,
      this.isOdoo18 = false,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OdooChatProvider(
          isOdoo18: isOdoo18,
          channelId: channelId,
          client: client,
          discussprovider: discussprovider),
      child: Consumer2<OdooChatProvider, OdooClientManager>(
        builder: (context, provider, odooclientprovider, child) {
          if (provider.initialLoading) {
            return Scaffold(
              body: Center(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )),
            );
          }

          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Scaffold(
            backgroundColor: isDark
                ? Theme.of(context).scaffoldBackgroundColor
                : Colors.grey[50],
            appBar: AppBar(
              elevation: 0,
              titleSpacing: 0,
              leading: IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  HugeIcons.strokeRoundedArrowLeft01,
                  color: isDark ? Colors.white : Colors.black,
                  size: 28,
                ),
              ),
              centerTitle: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  avatar,
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
              backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
              automaticallyImplyLeading: false,
            ),
            body: Column(
              children: [
                Expanded(
                  child: provider.messages.isEmpty
                      ? Center(
                          child: Text(
                            "No messages in this channel",
                            style: TextStyle(
                              fontSize: 15,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: provider.scrollController,
                          itemCount: provider.messages.length +
                              (provider.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (provider.isLoadingMore && index == 0) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                ),
                              );
                            }

                            final messageIndex =
                                provider.isLoadingMore ? index - 1 : index;
                            final message = provider.messages[messageIndex];
                            final rawBody = message['body'] ?? '';
                            final cleanBody = provider.parseHtmlBody(rawBody);
                            final authorId = message['author_id'];
                            final isOwnMessage = (authorId is List &&
                                    authorId.isNotEmpty)
                                ? authorId[0] ==
                                    provider.client.sessionId!.partnerId
                                : false;
                            final currentDateTime =
                                DateTime.tryParse(message['date'] ?? '') ??
                                    DateTime.now();

                            bool showTimeBelow = true;
                            if (messageIndex < provider.messages.length - 1) {
                              final next = provider.messages[messageIndex + 1];
                              final nextCreateUid = next['create_uid'];
                              final nextSenderId = (nextCreateUid is List &&
                                      nextCreateUid.isNotEmpty)
                                  ? nextCreateUid[0]
                                  : null;
                              final nextDateTime =
                                  DateTime.tryParse(next['date'] ?? '');
                              final currentCreateUid = message['create_uid'];
                              final currentSenderId =
                                  (currentCreateUid is List &&
                                          currentCreateUid.isNotEmpty)
                                      ? currentCreateUid[0]
                                      : null;
                              if (nextSenderId == currentSenderId &&
                                  nextDateTime != null &&
                                  nextDateTime
                                          .difference(currentDateTime)
                                          .inMinutes <
                                      1) {
                                showTimeBelow = false;
                              }
                            }

                            bool showDateHeader = messageIndex == 0;
                            if (!showDateHeader && messageIndex > 0) {
                              final prev = provider.messages[messageIndex - 1];
                              final prevDate =
                                  DateTime.tryParse(prev['date'] ?? '');
                              if (prevDate != null &&
                                  (prevDate.year != currentDateTime.year ||
                                      prevDate.month != currentDateTime.month ||
                                      prevDate.day != currentDateTime.day)) {
                                showDateHeader = true;
                              }
                            }

                            String formatDateHeader(DateTime date) {
                              final now = DateTime.now();
                              final today =
                                  DateTime(now.year, now.month, now.day);
                              final msgDay =
                                  DateTime(date.year, date.month, date.day);
                              final diff = today.difference(msgDay).inDays;

                              if (diff == 0) return 'Today';
                              if (diff == 1) return 'Yesterday';

                              return "${provider.monthName(date.month)} ${date.day}, ${date.year}";
                            }

                            return Column(
                              children: [
                                if (showDateHeader)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: Text(
                                      formatDateHeader(currentDateTime),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white60
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  child: Column(
                                    crossAxisAlignment: isOwnMessage
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: isOwnMessage
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (!isOwnMessage &&
                                              (channelType == 'group' ||
                                                  channelType == 'channel') &&
                                              message['author_id'] is List &&
                                              (message['author_id'] as List)
                                                  .isNotEmpty) ...[
                                            OdooByteImage(
                                              useNetworkImage: true,
                                              model: 'res.partner',
                                              recordId: (message['author_id']
                                                  as List)[0] as int,
                                              size: 25,
                                            ),
                                            const SizedBox(width: 5),
                                          ],
                                          Flexible(
                                            child: Align(
                                              alignment: isOwnMessage
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.65,
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 14,
                                                          vertical: 10),
                                                  decoration: BoxDecoration(
                                                    color: isOwnMessage
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : (isDark
                                                            ? Colors.grey[850]
                                                            : Colors.white),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          const Radius.circular(
                                                              16),
                                                      topRight:
                                                          const Radius.circular(
                                                              16),
                                                      bottomRight:
                                                          Radius.circular(
                                                              isOwnMessage
                                                                  ? 4
                                                                  : 16),
                                                      bottomLeft:
                                                          Radius.circular(
                                                              isOwnMessage
                                                                  ? 16
                                                                  : 4),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withValues(alpha: 0.05),
                                                        blurRadius: 6,
                                                        offset: const Offset(
                                                            0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text(
                                                    cleanBody,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: isOwnMessage
                                                          ? Colors.white
                                                          : (isDark
                                                              ? Colors.white
                                                              : Colors
                                                                  .black87),
                                                      height: 1.4,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (showTimeBelow) ...[
                                        const SizedBox(height: 3),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: (!isOwnMessage &&
                                                    (channelType == 'group' ||
                                                        channelType ==
                                                            'channel') &&
                                                    message['author_id']
                                                        is List &&
                                                    (message['author_id']
                                                            as List)
                                                        .isNotEmpty)
                                                ? 30
                                                : 0,
                                          ),
                                          child: Text(
                                            provider
                                                .formatDate(message['date']),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isDark
                                                  ? Colors.white60
                                                  : Colors.black54,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Colors.grey[50],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: TextField(
                    onSubmitted: (value) {
                      if (value.isNotEmpty &&
                          provider.messageSending == false) {
                        provider.sendChannelMessage(
                            messageBody: value,
                            client: odooclientprovider.client!,
                            ctx: context,
                            odooServerUrl:
                                odooclientprovider.client!.baseURL,
                            sessionId: odooclientprovider
                                .currentsession!.sessionId,
                            channelId: channelId);
                      }
                    },
                    controller: provider.textController,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        HugeIcons.strokeRoundedMessageMultiple01,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        size: 18,
                      ),
                      suffixIcon: IntrinsicWidth(
                          child: Row(
                        children: [
                          provider.messageSending
                              ? Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                )
                              : IconButton(
                                  icon: Icon(Icons.send_rounded,
                                      color:
                                          Theme.of(context).primaryColor),
                                  onPressed: () {
                                    if (provider.textController.text
                                        .trim()
                                        .isNotEmpty) {
                                      provider.sendChannelMessage(
                                          messageBody: provider
                                              .textController.text,
                                          client:
                                              odooclientprovider.client!,
                                          ctx: context,
                                          odooServerUrl:
                                              odooclientprovider
                                                  .client!.baseURL,
                                          sessionId: odooclientprovider
                                              .currentsession!.sessionId,
                                          channelId: channelId);
                                    }
                                  },
                                ),
                        ],
                      )),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      filled: true,
                      fillColor: isDark ? Colors.grey[850] : Colors.white,
                      hintText: 'Type your message here...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white38 : Colors.grey[500],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
