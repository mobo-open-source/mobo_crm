import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/chat_models/chat_model.dart';
import 'package:mobo_crm/screens/discuss/providers/discuss_provider.dart';
import 'package:mobo_crm/screens/settings/screens/profile/provider/provider_profile.dart';
import 'package:provider/provider.dart';
import '../widgets/chat_tile.dart';

/// Main Discuss (Chat List) screen.
///
/// Displays all user chat channels grouped into three tabs:
/// - All
/// - Unread
/// - Read
///
/// Features:
/// - Initializes chat data via [DiscussProvider]
/// - Uses [TabController] for tab navigation
/// - Converts raw provider data into [ChatModel]
/// - Filters chats based on unread status
/// - Sorts chats by latest message date
///
/// Dependencies:
/// - [DiscussProvider]
/// - [OdooClientManager]
/// - [ProfileConfigurationProvider]
///
/// This screen serves as the entry point for Odoo chat conversations.
class Discuss extends StatefulWidget {
  const Discuss({super.key});

  @override
  State<Discuss> createState() => _DiscussState();
}

/// State class for [Discuss].
///
/// Responsibilities:
/// - Manages [TabController]
/// - Triggers initial chat data loading
/// - Builds tab-based chat layout
/// - Categorizes chats into All / Unread / Read
class _DiscussState extends State<Discuss> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3,
        vsync: this,
        animationDuration: const Duration(milliseconds: 300));
    _tabController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DiscussProvider>(context, listen: false);
      provider.initializeData(context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer3<DiscussProvider, OdooClientManager,
        ProfileConfigurationProvider>(
      builder: (context, provider, clientProvider, profileProvider, child) {
        List<ChatModel> allChats = provider.chats.map((chat) {
          return ChatModel(
            date: chat.lastUpdate.isNotEmpty
                ? chat.lastUpdate
                : '1970-01-01 12:00 AM',
            latMessageId: chat.id,
            cacheKey: chat.channel.cacheKey,
            name: chat.channel.name ?? 'Unnamed Channel',
            message: chat.lastMessage,
            time: chat.lastUpdate.isNotEmpty ? chat.lastUpdate : chat.date,
            avatarBase64Svg: chat.channel.imageBase64Svg,
            channelType: chat.channel.channelType,
            channelId: chat.channelId,
            recipientId: chat.channel.partnerIds.isNotEmpty
                ? chat.channel.partnerIds.firstWhere(
                    (v) => v != clientProvider.currentsession?.partnerId,
                    orElse: () => -1,
                  )
                : -1,
            unreadCount: chat.messageUnreadCounter,
            isOnline: false,
            isSeen: chat.isSeen,
            isFetched: chat.isFetched,
            id: chat.channelId,
          );
        }).toList();

        List<ChatModel> unreadChats =
            allChats.where((chat) => chat.unreadCount > 0).toList();
        List<ChatModel> readChats =
            allChats.where((chat) => chat.unreadCount == 0).toList();

        return Scaffold(
          backgroundColor: isDark
              ? Theme.of(context).scaffoldBackgroundColor
              : const Color(0xFFFAFAFA),
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
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
            title: Text(
              'Chats',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            backgroundColor: isDark ? Colors.grey[900] : const Color(0xFFFAFAFA),
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              Container(
                color: isDark ? Colors.grey[900] : const Color(0xFFFAFAFA),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: TabBar(
                  controller: _tabController,
                  padding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.transparent,
                  unselectedLabelColor: Colors.transparent,
                  labelStyle: const TextStyle(fontSize: 0),
                  unselectedLabelStyle: const TextStyle(fontSize: 0),
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  tabs: [
                    _buildTab('All ${allChats.length}', 0, isDark),
                    _buildTab('Unread ${unreadChats.length}', 1, isDark),
                    _buildTab('Read ${readChats.length}', 2, isDark),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    ChatListView(chats: allChats),
                    ChatListView(chats: unreadChats),
                    ChatListView(chats: readChats),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds a styled tab item.
  Widget _buildTab(String text, int index, bool isDark) {
    bool isSelected = _tabController.index == index;
    return Container(
      width: double.infinity,
      height: 40,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF000000)
            : (isDark ? Colors.grey[800] : const Color(0xFFFFFFFF)),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF000000)
              : (isDark ? Colors.grey[600]! : const Color(0xFFEDEDEB)),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Tab(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            height: 1.0,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.grey[400] : Colors.grey[700]),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Displays a list of chats.
///
/// Handles:
/// - Loading state
/// - Empty state (Lottie animation)
/// - Sorting chats by most recent message
/// - Rendering individual [ChatTile] widgets
///
/// Parameter:
/// - [chats]: List of chat models to display
class ChatListView extends StatelessWidget {
  final List<ChatModel> chats;

  const ChatListView({
    super.key,
    required this.chats,
  });

  /// Builds a centered animated empty state using Lottie.
  ///
  /// Parameters:
  /// - [lottie]: Asset path for animation
  /// - [title]: Main title text
  /// - [subtitle]: Optional subtitle text
  /// - [button]: Optional action button
  /// - [isDark]: Adjusts text color based on theme
  ///
  /// Used for empty chat states.
  Widget _buildCenteredLottie({
    required String lottie,
    required String title,
    String? subtitle,
    Widget? button,
    required bool isDark,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
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
                  if (button != null) ...[const SizedBox(height: 12), button],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the default empty state for chat list.
  ///
  /// Displays:
  /// - Ghost Lottie animation
  /// - "No Chats Found" message
  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No Chats Found',
      isDark: isDark,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? Theme.of(context).scaffoldBackgroundColor : const Color(0xFFFAFAFA),
      child: Consumer<DiscussProvider>(builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        } else if (chats.isEmpty) {
          return Center(child: _buildEmptyState(context));
        } else {
          final sortedChats = chats.toList()
            ..sort((a, b) {
              DateTime? parseDateTime(ChatModel chat) {
                try {
                  return DateTime.parse(chat.date).toLocal();
                } catch (e) {
                  return null;
                }
              }

              final dateTimeA = parseDateTime(a);
              final dateTimeB = parseDateTime(b);

              if (dateTimeA == null && dateTimeB == null) return 0;
              if (dateTimeA == null) return 1;
              if (dateTimeB == null) return -1;

              return dateTimeB.compareTo(dateTimeA);
            });

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: sortedChats.length,
              itemBuilder: (context, index) {
                final chat = sortedChats[index];
                return ChatTile(chat: chat);
              },
            ),
          );
        }
      }),
    );
  }
}
