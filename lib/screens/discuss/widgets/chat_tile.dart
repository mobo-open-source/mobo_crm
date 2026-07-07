import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobo_crm/global_methods/widgets/image_widget/get_allimage.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/chat_models/chat_model.dart';
import 'package:mobo_crm/screens/discuss/chat/chat_main_screen.dart';
import 'package:mobo_crm/screens/discuss/providers/discuss_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';

/// A chat list tile widget representing a single Discuss conversation.
///
/// Displays:
/// - Channel avatar (SVG / network / default icon)
/// - Channel name
/// - Last message preview
/// - Message timestamp
/// - Unread message counter
/// - Online status indicator (for private chats)
///
/// On tap:
/// - Navigates to [OdooChatScreen]
/// - Marks the channel as read via [DiscussProvider]
///
/// This widget listens to:
/// - [OdooClientManager]
/// - [DiscussProvider]
///
/// Used inside the Discuss chat list screen.
class ChatTile extends StatefulWidget {
  final ChatModel chat;

  /// Creates a chat tile for a given [ChatModel].
  ///
  /// [chat] contains all necessary display information
  /// such as name, avatar, unread count, and last message.
  const ChatTile({
    super.key,
    required this.chat,
  });

  @override
  State<ChatTile> createState() => _ChatTileState();
}

/// State class for [ChatTile].
///
/// Ensures:
/// - Odoo client is initialized
/// - UI rebuilds when providers update
class _ChatTileState extends State<ChatTile> {
  /// Ensures Odoo client is initialized after first frame.
  ///
  /// Uses post-frame callback to avoid context issues
  /// during widget initialization.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<OdooClientManager>().ensureClient();
    });
  }

  /// Builds the chat list tile UI.
  ///
  /// Structure:
  /// - Leading: Avatar with optional online indicator
  /// - Title: Channel name + message time
  /// - Subtitle: Last message preview + unread counter
  ///
  /// Listens to:
  /// - [OdooClientManager]
  /// - [DiscussProvider]
  ///
  /// On tap:
  /// - Navigates to chat screen
  /// - Marks channel as read
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
            color: const Color(0xFF000000).withOpacity(0.03),
            offset: const Offset(0, 6),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Consumer2<OdooClientManager, DiscussProvider>(
          builder: (context, provider, discussprovider, child) {
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          leading: Stack(
            children: [
              buildAvatar(
                  widget.chat.avatarBase64Svg,
                  widget.chat.channelType,
                  widget.chat.recipientId,
                  widget.chat.channelId,
                  widget.chat.cacheKey),
              if (widget.chat.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Colors.grey[850]! : Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.chat.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Text(
                  widget.chat.time,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.grey[500],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.chat.message,
                  style: TextStyle(
                    color: widget.chat.unreadCount > 0
                        ? (isDark ? Colors.white : Colors.black87)
                        : (isDark ? Colors.white60 : Colors.black54),
                    fontWeight: widget.chat.unreadCount > 0
                        ? FontWeight.w600
                        : FontWeight.w400,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              if (widget.chat.unreadCount > 0)
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      widget.chat.unreadCount > 99
                          ? '99+'
                          : widget.chat.unreadCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.chat.unreadCount > 9 ? 9 : 11,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          onTap: () async {
            Navigator.push(
                context,
                SlidingPageTransitionRL(
                    page: OdooChatScreen(
                        isOdoo18: provider.isOdoo18,
                        channelType: widget.chat.channelType,
                        discussprovider: discussprovider,
                        name: widget.chat.name,
                        avatar: buildAvatar(
                            widget.chat.avatarBase64Svg,
                            widget.chat.channelType,
                            widget.chat.recipientId,
                            widget.chat.channelId,
                            widget.chat.cacheKey),
                        channelId: widget.chat.channelId,
                        client: provider.client!)));
            await discussprovider.markChannelAsRead(
                isOdoo18: provider.isOdoo18,
                client: provider.client!,
                ctx: context,
                odooServerUrl: provider.client!.baseURL,
                sessionId: provider.client!.sessionId!.id,
                channelId: widget.chat.channelId,
                lastMessageId: widget.chat.latMessageId);
          },
        ),
        );
      }),
    );
  }

  /// Builds the avatar widget based on channel type.
  ///
  /// Logic:
  /// - If SVG avatar exists for channel → renders SVG
  /// - If private chat → loads partner image
  /// - Otherwise → displays default channel/group icon
  ///
  /// Parameters:
  /// - [base64Svg]: Encoded SVG image
  /// - [channelType]: 'channel', 'group', or 'chat'
  /// - [recipientId]: Partner ID for private chats
  /// - [channelId]: Channel ID (used for color tagging)
  /// - [cacheKey]: Avatar cache key
  /// - [isOdoo18]: Version flag for compatibility
  ///
  /// Returns:
  /// - Circular avatar widget
  Widget buildAvatar(String? base64Svg, String? channelType, int recipientId,
      int channelId, String cacheKey,
      {bool isOdoo18 = true}) {
    Color getTagColor(int id) {
      if (id == -1) return Colors.grey[400]!;
      double hue = (id * 137.5) % 360;
      return HSVColor.fromAHSV(1.0, hue, 0.6, 0.6).toColor();
    }

    if (base64Svg != null && channelType == 'channel') {
      final svgBytes = base64Decode(base64Svg);
      if (isOdoo18) {
        return ClipOval(
          clipBehavior: Clip.hardEdge,
          child: SvgPicture.memory(svgBytes,
              width: 43,
              height: 43,
              fit: BoxFit.scaleDown,
              placeholderBuilder: (context) => CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  )),
        );
      } else {
        return ClipOval(
          clipBehavior: Clip.hardEdge,
          child: SvgPicture.memory(svgBytes,
              width: 43,
              height: 43,
              fit: BoxFit.scaleDown,
              placeholderBuilder: (context) => CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  )),
        );
      }
    } else if (channelType == 'chat') {
      return OdooByteImage(
        size: 43,
        model: 'res.partner',
        recordId: recipientId,
        useNetworkImage: true,
      );
    } else {
      return ClipOval(
        child: SvgPicture.asset(
          color: getTagColor(channelId),
          channelType == 'channel'
              ? 'assets/channel.svg'
              : 'assets/group_avatar.svg',
          width: 43,
          height: 43,
          fit: BoxFit.scaleDown,
        ),
      );
    }
  }
}
