import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/chat_models/chat_model.dart';
import 'package:mobo_crm/global_methods/services/isar_caching_service.dart';
import 'package:mobo_crm/screens/discuss/Isar/chat_model_isar.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import '../../../core/company/session/company_session_manager.dart';

/// Provider responsible for managing Odoo Discuss module state.
///
/// Handles:
/// - Fetching user discuss channels
/// - Loading latest messages per channel
/// - Offline caching using Isar
/// - Network connectivity monitoring
/// - Channel unread counters
/// - Marking channels as read
/// - Synchronizing server data with local storage
///
/// Features:
/// - Automatic offline fallback
/// - Auto refresh when connection is restored
/// - Supports Odoo 18 specific APIs
/// - Maintains unread message counters
///
/// Acts as the business logic layer between:
/// UI → Odoo RPC → Local Isar Cache
class DiscussProvider with ChangeNotifier {
  int? userId;
  List<ChatMessage> chats = [];
  String? companyLogo;
  bool isLoading = true;
  bool hasError = false;
  BuildContext? context;
  bool _allowClearCache = false;
  bool _wasOffline = false;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// Initializes connectivity listener to monitor
  /// online/offline state changes.
  DiscussProvider() {
    _initConnectivityListener();
  }

  /// Allows clearing cached chat data.
  ///
  /// This method must be called before invoking [clearAll].
  /// Prevents accidental cache deletion.
  void allowClearCache() {
    _allowClearCache = true;
  }

  /// Listens to connectivity changes.
  ///
  /// When internet connection is restored:
  /// - Automatically reloads discuss data
  /// - Syncs with server if previously offline
  void _initConnectivityListener() {
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) async {
      final isOnline =
          results.any((result) => result != ConnectivityResult.none);

      if (isOnline && _wasOffline && context != null) {
        final client =
            Provider.of<OdooClientManager>(context!, listen: false).client;
        if (client != null) {
          await discussData(context!);
        }
      }
      _wasOffline = !isOnline;
    });
  }

  /// Initializes Discuss data.
  ///
  /// Steps:
  /// 1. Loads current company session
  /// 2. Checks network availability
  /// 3. Loads cached chats if offline
  /// 4. Fetches partner ID of logged-in user
  /// 5. Calls [discussData] to fetch server data
  ///
  /// Handles loading and error states appropriately.
  Future<void> initializeData(BuildContext ctx) async {
    context = ctx;
    final session = await CompanySessionManager.getCurrentSession();

    chats = [];
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      if (session == null) {
        await _loadCachedChats();
        isLoading = false;
        notifyListeners();
        return;
      }

      bool isOnline = await _checkNetworkAvailability();
      _wasOffline = !isOnline;

      if (!isOnline) {
        await _loadCachedChats();
        isLoading = false;
        notifyListeners();
        return;
      }

      try {
        final userResponse = await CompanySessionManager.callKwWithCompany({
          'model': 'res.users',
          'method': 'search_read',
          'args': [],
          'kwargs': {
            'domain': [
              ['id', '=', session.userId]
            ],
            'fields': ['partner_id'],
          },
        });
        if (userResponse is List && userResponse.isNotEmpty) {
          userId = userResponse[0]['partner_id'][0];
        }
      } catch (_) {}

      if (ctx.mounted) {
        await discussData(ctx);
      }
    } catch (e) {
      hasError = true;
      await _loadCachedChats();
      isLoading = false;
      notifyListeners();
    }
  }

  /// Checks whether network connection is available.
  ///
  /// Returns:
  /// - `true` if connected
  /// - `false` if offline or error occurs
  Future<bool> _checkNetworkAvailability() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.any((r) => r != ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  /// Loads cached chat messages from Isar database.
  ///
  /// - Reconstructs [ChatMessage] objects
  /// - Restores unread counters
  /// - Attempts partner name refresh if online
  /// - Updates provider state
  Future<void> _loadCachedChats() async {
    final cachedMessages = await IsarService.getCachedChatMessages();
    final validChatMessages = <ChatMessage>[];
    for (final chatMessageIsar in cachedMessages) {
      final channel = chatMessageIsar.channel.value;
      if (channel == null) {
        continue;
      }

      List<String> partnerNames =
          channel.partnerNames ?? [channel.displayName ?? 'Unnamed Channel'];
      final client =
          Provider.of<OdooClientManager>(context!, listen: false).client;
      if (client != null && await _checkNetworkAvailability()) {
        try {
          partnerNames = await getPartnerNames(channel.channelMemberIds ?? []);
        } catch (_) {}
      }

      validChatMessages.add(ChatMessage(
        id: chatMessageIsar.messageId ?? -1,
        body: chatMessageIsar.body ?? '',
        date: chatMessageIsar.date ?? '',
        channelId: chatMessageIsar.channelId ?? -1,
        recordTitle: channel.displayName ?? 'Unnamed Channel',
        recordImage: null,
        lastMessage: chatMessageIsar.body != null
            ? _parseHtmlString(chatMessageIsar.body!)
            : '',
        isSeen: chatMessageIsar.isSeen ?? true,
        isFetched: chatMessageIsar.isFetched ?? true,
        messageUnreadCounter: chatMessageIsar.messageUnreadCounter ?? 0,
        channel: Channel(
          id: channel.serverId ?? -1,
          cacheKey: channel.avatarCacheKey ?? '',
          name: channel.name ?? 'Unnamed Channel',
          channelType: channel.channelType ?? '',
          memberCount: channel.memberCount ?? 0,
          channelMemberIds: channel.channelMemberIds ?? [],
          image: null,
          isMember: channel.isMember ?? false,
          displayName: channel.displayName ?? 'Unnamed Channel',
          messageUnreadCounter: channel.messageUnreadCounter ?? 0,
          imageBase64Svg: channel.imageBase64Svg,
          partnerIds: channel.partnerIds ?? [],
        ),
        lastUpdate: chatMessageIsar.date ?? '',
      ));
    }

    chats = validChatMessages;
    notifyListeners();
  }

  /// Clears all chats and cached data.
  ///
  /// Only executes if [allowClearCache] was called.
  /// Resets loading and error state.
  void clearAll() {
    if (!_allowClearCache) {
      return;
    }
    chats.clear();
    isLoading = true;
    hasError = false;
    notifyListeners();
    IsarService.clearChatMessages();
    _allowClearCache = false;
  }

  /// Fetches Discuss channels and latest messages from Odoo server.
  ///
  /// Steps:
  /// - Retrieves Odoo version
  /// - Fetches active channels
  /// - Fetches channel membership details
  /// - Computes unread counters
  /// - Fetches latest message per channel
  /// - Stores data in Isar cache
  /// - Updates provider state
  ///
  /// Falls back to cached data on error.
  Future<void> discussData(BuildContext context) async {
    try {
      final client = await CompanySessionManager.getClientEnsured();
      final versionInfo = await CompanySessionManager.callVersion();
      final serverVersion = versionInfo['server_version']?.toString() ?? '';
      final isOdoo18 = serverVersion.startsWith('18.0');

      final fields = [
        'id',
        'name',
        'channel_type',
        'member_count',
        'channel_member_ids',
        'is_member',
        'display_name',
        'has_message',
        'website_message_ids',
        'channel_partner_ids',
        'image_128',
        'message_partner_ids',
        'avatar_128',
        if (isOdoo18) ...['last_interest_dt', 'avatar_cache_key'],
      ];

      final channelResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'discuss.channel',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['active', '=', true],
            ['is_member', '=', true],
            [
              'channel_type',
              'in',
              ['group', 'channel', 'chat']
            ],
          ],
          'fields': fields,
        },
      });

      if (channelResponse != null && channelResponse is List) {
        final memberResponse = await CompanySessionManager.callKwWithCompany({
          'model': 'discuss.channel.member',
          'method': 'search_read',
          'args': [],
          'kwargs': {
            'domain': [
              [
                'channel_id',
                'in',
                channelResponse.map((c) => c['id']).toList()
              ],
              ['partner_id', '=', userId ?? 0],
            ],
            'fields': [
              'channel_id',
              'partner_id',
              'seen_message_id',
              'fetched_message_id',
              'message_unread_counter',
            ],
          },
        });

        final memberMap = <String, Map<String, int?>>{};
        if (memberResponse is List) {
          for (var member in memberResponse) {
            final channelIdRaw = member['channel_id'];
            final channelId = channelIdRaw is List
                ? channelIdRaw.first.toString()
                : channelIdRaw.toString();
            memberMap[channelId] = {
              'seen_message_id': member['seen_message_id'] is int
                  ? member['seen_message_id']
                  : null,
              'fetched_message_id': member['fetched_message_id'] is int
                  ? member['fetched_message_id']
                  : null,
              'message_unread_counter': member['message_unread_counter'] is int
                  ? member['message_unread_counter']
                  : 0,
            };
          }
        }

        final channels = <Channel>[];
        final channelIsarList = <ChannelIsar>[];
        for (var json in channelResponse) {
          final channelId = json['id'].toString();
          final unreadCounter =
              memberMap[channelId]?['message_unread_counter'] ?? 0;
          final channelMemberIds = List<int>.from(json['channel_member_ids']);
          final partnerIds = await getPartnerIds(channelMemberIds);
          final partnerNames = await getPartnerNames(channelMemberIds);

          final channel = Channel.fromJson(
            {
              ...json,
              'message_unread_counter': unreadCounter,
              'partner_ids': partnerIds,
            },
            partnerNames: partnerNames,
            currentUserName: client.sessionId!.userName,
            companyName: client.sessionId!.allowedCompanies
                .firstWhere(
                  (company) => company.id == client.sessionId!.companyId,
                  orElse: () => Company(id: 0, name: 'Unknown'),
                )
                .name,
          );
          channels.add(channel);
          channelIsarList.add(ChannelIsar.fromJson(
            {
              ...json,
              'message_unread_counter': unreadCounter,
              'partner_ids': partnerIds,
              'partner_names': partnerNames,
            },
            partnerNames: partnerNames,
            companyName: client.sessionId!.allowedCompanies
                .firstWhere(
                  (company) => company.id == client.sessionId!.companyId,
                  orElse: () => Company(id: 0, name: 'Unknown'),
                )
                .name,
            currentUserName: client.sessionId!.userName,
          ));
        }

        final channelMap = {
          for (var channel in channels) channel.id.toString(): channel
        };
        await IsarService.saveChannels(channelIsarList);

        final messageResponse = await CompanySessionManager.callKwWithCompany({
          'model': 'mail.message',
          'method': 'search_read',
          'args': [
            [
              ['model', '=', 'discuss.channel']
            ],
          ],
          'kwargs': {
            'fields': ['id', 'body', 'date', 'res_id', 'create_date'],
            'order': 'date desc',
          },
        });

        if (messageResponse != null && messageResponse is List) {
          final messageMap = <String, Map<String, dynamic>>{};
          for (var message in messageResponse) {
            final resId = message['res_id'].toString();
            messageMap[resId] ??= message;
          }

          final chatMessageIsarList = <ChatMessageIsar>[];
          chats = channelMap.entries.map((entry) {
            final resId = entry.key;
            final channel = entry.value;
            final message = messageMap[resId];
            final channelIsar = channelIsarList.firstWhere(
                (c) => c.serverId.toString() == resId,
                orElse: () => ChannelIsar());

            if (message != null) {
              final chatMessage = ChatMessage.fromJson(
                message,
                channel,
                seenMessageId: memberMap[resId]?['seen_message_id'],
                fetchedMessageId: memberMap[resId]?['fetched_message_id'],
              );
              final chatMessageIsar = ChatMessageIsar.fromJson(
                message,
                channelIsar,
                seenMessageId: memberMap[resId]?['seen_message_id'],
                fetchedMessageId: memberMap[resId]?['fetched_message_id'],
              );
              chatMessageIsarList.add(chatMessageIsar);
              return chatMessage;
            } else {
              final chatMessage = ChatMessage.empty(
                channel,
                seenMessageId: memberMap[resId]?['seen_message_id'],
                fetchedMessageId: memberMap[resId]?['fetched_message_id'],
              );
              final chatMessageIsar = ChatMessageIsar.empty(
                channelIsar,
                seenMessageId: memberMap[resId]?['seen_message_id'],
                fetchedMessageId: memberMap[resId]?['fetched_message_id'],
              );
              chatMessageIsarList.add(chatMessageIsar);
              return chatMessage;
            }
          }).toList();

          await IsarService.saveChatMessages(chatMessageIsarList);
        }
      }

      isLoading = false;
      hasError = false;
      notifyListeners();
    } catch (e) {
      hasError = true;
      await _loadCachedChats();
      isLoading = false;
      notifyListeners();
    }
  }

  /// Marks a channel as read on the Odoo server.
  ///
  /// Supports:
  /// - Odoo 18 REST endpoint
  /// - Legacy RPC fallback
  ///
  /// Updates:
  /// - Local unread counter
  /// - Isar cached message state
  ///
  /// Parameters:
  /// - [channelId]: Channel ID
  /// - [lastMessageId]: ID of last read message
  /// - [sync]: Whether to sync across devices
  Future<void> markChannelAsRead({
    required OdooClient client,
    required BuildContext ctx,
    required String odooServerUrl,
    required String sessionId,
    required int channelId,
    required int lastMessageId,
    bool sync = false,
    bool isOdoo18 = true,
  }) async {
    try {
      if (isOdoo18) {
        final url = Uri.parse('$odooServerUrl/discuss/channel/mark_as_read');
        final headers = {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=$sessionId',
        };
        final body = jsonEncode({
          'jsonrpc': '2.0',
          'method': 'call',
          'params': {
            'channel_id': channelId,
            'last_message_id': lastMessageId,
            'sync': sync,
          },
          'id': null,
        });

        final response = await http.post(url, headers: headers, body: body);
        final responseBody = jsonDecode(response.body);

        if (response.statusCode == 200) {
          if (responseBody['error'] != null) {
            final error = responseBody['error'];
            throw Exception(
                'Failed to mark channel as read: ${error['message']}');
          }
        } else {
          throw Exception('HTTP Error: ${response.statusCode}');
        }
      } else {
        final response = await CompanySessionManager.callLastSeenMessage(
          channelId: channelId,
          lastMessageId: lastMessageId,
          sync: sync,
        );
        if (response is Map<String, dynamic> && response.containsKey('error')) {
          final error = response['error'];
          throw Exception(
              'Failed to mark channel as read: ${error['message']}');
        }
      }

      if (ctx.mounted) {
        final index = chats.indexWhere((chat) => chat.channelId == channelId);
        if (index != -1) {
          final updatedChat =
              chats[index].copyWith(isSeen: true, messageUnreadCounter: 0);
          chats[index] = updatedChat;
          final chatMessageIsar =
              await IsarService.getCachedChatMessage(channelId);
          if (chatMessageIsar != null) {
            chatMessageIsar.isSeen = true;
            chatMessageIsar.messageUnreadCounter = 0;
            await IsarService.saveChatMessages([chatMessageIsar]);
          }
          notifyListeners();
        }
      }
    } catch (_) {}
  }

  /// Fetches messages for a specific channel.
  ///
  /// Supports:
  /// - Pagination using [before] and [after]
  /// - Searching via [searchTerm]
  /// - Around-message loading
  ///
  /// Also:
  /// - Caches messages locally in Isar
  ///
  /// Returns:
  /// - Server response result map
  Future<Map<String, dynamic>> fetchChannelMessages({
    required OdooClient client,
    required BuildContext ctx,
    required String odooServerUrl,
    required String sessionId,
    required int channelId,
    String? searchTerm,
    int? before,
    int? after,
    int limit = 40,
    int? around,
  }) async {
    final url = Uri.parse('$odooServerUrl/discuss/channel/messages');
    final headers = {
      'Content-Type': 'application/json',
      'Cookie': 'session_id=$sessionId',
    };
    final body = jsonEncode({
      'jsonrpc': '2.0',
      'method': 'call',
      'params': {
        'channel_id': channelId,
        'search_term': searchTerm,
        'before': before,
        'after': after,
        'limit': limit,
        'around': around,
      },
      'id': null,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseBody['error'] != null) {
          final error = responseBody['error'];
          throw Exception(
              'Failed to fetch channel messages: ${error['message']}');
        } else {
          final messages = responseBody['result']['messages'] as List<dynamic>;
          final channelIsar = await IsarService.getCachedChannel(channelId);
          if (channelIsar != null) {
            final chatMessageIsarList = messages.map((message) {
              return ChatMessageIsar.fromJson(
                message,
                channelIsar,
                seenMessageId: message['seen_message_id'],
                fetchedMessageId: message['fetched_message_id'],
              );
            }).toList();
            await IsarService.saveChatMessages(chatMessageIsarList);
          }
          return responseBody['result'] as Map<String, dynamic>;
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Converts HTML message body to plain text.
  ///
  /// Removes HTML tags and returns readable text.
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    return document.body?.text ?? '';
  }

  /// Fetches partner IDs for given channel member IDs.
  ///
  /// Returns:
  /// - List of partner IDs
  /// - Empty list on failure
  Future<List<int>> getPartnerIds(List<int> channelMemberIds) async {
    try {
      final memberResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'discuss.channel.member',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['id', 'in', channelMemberIds]
          ],
          'fields': ['partner_id'],
        },
      });

      final partnerIds = <int>[];
      if (memberResponse is List) {
        for (var member in memberResponse) {
          final partnerId = member['partner_id'];
          if (partnerId is int) {
            partnerIds.add(partnerId);
          } else if (partnerId is List &&
              partnerId.isNotEmpty &&
              partnerId[0] is int) {
            partnerIds.add(partnerId[0]);
          }
        }
      }
      return partnerIds;
    } catch (e) {
      return [];
    }
  }

  /// Fetches partner display names for given channel member IDs.
  ///
  /// Returns:
  /// - List of partner names
  /// - Empty list on failure
  Future<List<String>> getPartnerNames(List<int> channelMemberIds) async {
    try {
      final memberResponse = await CompanySessionManager.callKwWithCompany({
        'model': 'discuss.channel.member',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['id', 'in', channelMemberIds]
          ],
          'fields': ['partner_id'],
        },
      });

      final partnerNames = <String>[];
      if (memberResponse is List) {
        for (var member in memberResponse) {
          final partnerId = member['partner_id'];
          if (partnerId is List &&
              partnerId.length >= 2 &&
              partnerId[1] is String) {
            partnerNames.add(partnerId[1]);
          }
        }
      }
      return partnerNames;
    } catch (e) {
      return [];
    }
  }

  /// Disposes provider resources.
  ///
  /// Cancels connectivity subscription
  /// to prevent memory leaks.
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
