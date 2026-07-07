import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobo_crm/screens/discuss/providers/discuss_provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../core/company/session/company_session_manager.dart';
import '../../../global_methods/services/isar_caching_service.dart';
import '../Isar/chat_model_isar.dart';

/// Provider responsible for managing Odoo channel chat state.
///
/// Handles:
/// - Initial message loading
/// - Pagination (load older messages)
/// - Real-time polling for new messages
/// - Sending messages
/// - Offline support with Isar caching
/// - Scroll position management
/// - Read/unread synchronization with DiscussProvider
///
/// Features:
/// - Prevents duplicate message loading
/// - Maintains message ID tracking
/// - Automatically marks channel as read
/// - Supports Odoo 18 compatibility flag
///
/// This provider acts as the business logic layer
/// between UI and Odoo backend.
class OdooChatProvider extends ChangeNotifier {
  final int channelId;
  final OdooClient client;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  bool messageSending = false;
  List<dynamic> _messages = [];
  final int _limit = 10;
  int _offset = 0;
  bool _isLoadingMore = false;
  bool _hasMoreMessages = true;
  bool _initialLoading = true;
  Timer? _pollingTimer;
  OdooClient? _client;
  int? _lastKnownMessageId;
  int? _currentUserId;
  Timer? _debounceTimer;
  DiscussProvider? discussprovider;
  final Set<int> _loadedMessageIds = {};
  final bool isOdoo18;
  bool _isOffline = false;

  OdooChatProvider({
    required this.channelId,
    required this.client,
    required this.discussprovider,
    required this.isOdoo18,
  }) {
    _initializeClient();
    _scrollController.addListener(_scrollListener);
    _checkConnectivity();
  }

  ScrollController get scrollController => _scrollController;

  TextEditingController get textController => _textController;

  List<dynamic> get messages => _messages;

  bool get isLoadingMore => _isLoadingMore;

  bool get hasMoreMessages => _hasMoreMessages;

  bool get initialLoading => _initialLoading;

  int? get currentUserId => _currentUserId;

  /// Checks network connectivity using connectivity_plus.
  ///
  /// - Loads cached messages if offline
  /// - Reloads initial messages when internet is restored
  /// - Listens for connectivity changes
  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    _isOffline = connectivityResult.contains(ConnectivityResult.none);
    if (_isOffline) {
      await _loadCachedMessages();
    }
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _isOffline = results.contains(ConnectivityResult.none);
      if (!_isOffline && _initialLoading) {
        _loadInitialMessages();
      }
      notifyListeners();
    });
  }

  void _scrollListener() {
    if (_debounceTimer?.isActive ?? false) return;

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients &&
          _scrollController.position.pixels <=
              _scrollController.position.minScrollExtent + 50 &&
          !_isLoadingMore &&
          _hasMoreMessages) {
        _loadMoreMessages();
      }
    });
  }

  /// Initializes Odoo client session and retrieves current user ID.
  ///
  /// - Fetches logged-in user from server
  /// - Loads initial messages if online
  /// - Loads cached messages if offline
  /// - Starts polling for new messages
  void _initializeClient() async {
    _client = client;
    try {
      final user = await CompanySessionManager.callKwWithCompany({
        'model': 'res.users',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['id', '=', _client!.sessionId!.userId]
          ],
          'fields': ['id'],
        },
      });
      _currentUserId = user[0]['id'];
    } catch (_) {}
    if (!_isOffline) {
      await _loadInitialMessages();
      _startPolling();
    } else {
      await _loadCachedMessages();
    }
  }

  /// Starts periodic polling every 10 seconds
  /// to fetch latest messages when online.
  ///
  /// Stops automatically in dispose().
  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!_isOffline) {
        _fetchLatestMessages(false, userMessageBody: '');
      }
    });
  }

  /// Loads cached messages from local Isar database.
  ///
  /// - Filters by current channel
  /// - Sorts messages by date (descending)
  /// - Updates in-memory message list
  /// - Scrolls to bottom after loading
  Future<void> _loadCachedMessages() async {
    _initialLoading = true;
    notifyListeners();

    try {
      final cachedMessages = await IsarService.getCachedChatMessages();
      final channelMessages = cachedMessages
          .where((msg) => msg.channelId == channelId)
          .toList()
        ..sort((a, b) => (b.date ?? '').compareTo(a.date ?? ''));

      _messages = channelMessages
          .map((msg) => {
                'id': msg.messageId,
                'body': msg.body,
                'author_id': [msg.messageId, 'Cached User'],
                'date': msg.date,
                'create_uid': [msg.messageId, 'Cached User'],
                'subtype_id': [1, 'mt_comment'],
              })
          .toList();

      _loadedMessageIds
          .addAll(channelMessages.map((msg) => msg.messageId ?? 0));
      _offset = _messages.length;
      _hasMoreMessages = false;
      _initialLoading = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    } catch (_) {
    } finally {
      _initialLoading = false;
      notifyListeners();
    }
  }

  /// Loads the initial batch of messages from Odoo.
  ///
  /// - Fetches recent messages
  /// - Stores them in local cache
  /// - Determines if more messages exist
  /// - Scrolls to bottom after loading
  /// - Optionally triggers full history loading
  Future<void> _loadInitialMessages() async {
    if (_client == null) {
      return;
    }

    _offset = 0;
    _loadedMessageIds.clear();

    final data = await _fetchMessages(
        limit: _limit * 2, offset: _offset, isCheck: false);

    if (data.isNotEmpty) {
      for (var msg in data) {
        _loadedMessageIds.add(msg['id']);
      }

      _messages = data.reversed.toList();
      _offset = data.length;

      final checkForMore =
          await _fetchMessages(limit: 1, offset: _offset, isCheck: true);
      _hasMoreMessages = checkForMore.isNotEmpty;

      final channel = await IsarService.getCachedChannel(channelId) ??
          ChannelIsar(serverId: channelId);
      final chatMessages =
          data.map((msg) => ChatMessageIsar.fromJson(msg, channel)).toList();
      await IsarService.saveChatMessages(chatMessages);
    }

    _initialLoading = false;
    notifyListeners();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });

    if (data.length < _limit) {
      await Future.delayed(const Duration(milliseconds: 300));
      _loadAllMessages();
    }
  }

  /// Loads all remaining historical messages.
  ///
  /// Continues fetching while:
  /// - More messages are available
  /// - Not offline
  ///
  /// Prevents duplicate messages using ID tracking.
  Future<void> _loadAllMessages() async {
    if (_client == null || !_hasMoreMessages || _isOffline) {
      return;
    }

    while (_hasMoreMessages) {
      _isLoadingMore = true;
      notifyListeners();

      try {
        final newMessages = await _fetchMessages(
            limit: _limit, offset: _offset, isCheck: false);

        final uniqueMessages = newMessages
            .where((msg) => !_loadedMessageIds.contains(msg['id']))
            .toList();

        for (var msg in uniqueMessages) {
          _loadedMessageIds.add(msg['id']);
        }

        if (uniqueMessages.isNotEmpty) {
          _messages = [...uniqueMessages.reversed, ..._messages];
          _offset += uniqueMessages.length;

          final channel = await IsarService.getCachedChannel(channelId) ??
              ChannelIsar(serverId: channelId);
          final chatMessages = uniqueMessages
              .map((msg) => ChatMessageIsar.fromJson(msg, channel))
              .toList();
          await IsarService.saveChatMessages(chatMessages);

          notifyListeners();
        }

        _hasMoreMessages = newMessages.length == _limit;
        await Future.delayed(const Duration(milliseconds: 300));
      } catch (e) {
        break;
      } finally {
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }

  /// Loads older messages when user scrolls to top.
  ///
  /// - Preserves scroll position
  /// - Prevents duplicate message insertion
  /// - Updates local cache
  Future<void> _loadMoreMessages() async {
    if (_isLoadingMore || !_hasMoreMessages || _client == null || _isOffline) {
      return;
    }
    _isLoadingMore = true;
    notifyListeners();

    try {
      final scrollPositionBefore = _scrollController.position.pixels;
      final scrollExtentBefore = _scrollController.position.maxScrollExtent;

      final newMessages =
          await _fetchMessages(limit: _limit, offset: _offset, isCheck: false);

      final uniqueMessages = newMessages
          .where((msg) => !_loadedMessageIds.contains(msg['id']))
          .toList();

      for (var msg in uniqueMessages) {
        _loadedMessageIds.add(msg['id']);
      }

      if (uniqueMessages.isNotEmpty) {
        _messages = [...uniqueMessages.reversed, ..._messages];
        _offset += uniqueMessages.length;

        final channel = await IsarService.getCachedChannel(channelId) ??
            ChannelIsar(serverId: channelId);
        final chatMessages = uniqueMessages
            .map((msg) => ChatMessageIsar.fromJson(msg, channel))
            .toList();
        await IsarService.saveChatMessages(chatMessages);
      }

      _hasMoreMessages = newMessages.length == _limit;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          final scrollExtentAfter = _scrollController.position.maxScrollExtent;
          final scrollDifference = scrollExtentAfter - scrollExtentBefore;
          _scrollController.jumpTo(scrollPositionBefore + scrollDifference);
        }
      });
    } catch (_) {
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Fetches latest messages to detect new updates.
  ///
  /// - Avoids re-fetch if message ID unchanged
  /// - Merges new messages into list
  /// - Updates local cache
  /// - Auto-scrolls if user is at bottom
  /// - Replaces temporary user message if needed
  Future<void> _fetchLatestMessages(bool scrollToBottom,
      {String? userMessageBody}) async {
    if (_client == null || _isOffline) {
      return;
    }

    try {
      final latest = await _fetchMessages(limit: 1, offset: 0, isCheck: true);
      if (latest.isEmpty) {
        return;
      }

      final latestMessageId = latest.first['id'];
      if (_lastKnownMessageId == latestMessageId) {
        return;
      }
      _lastKnownMessageId = latestMessageId;

      final fullLatest =
          await _fetchMessages(limit: _limit, offset: 0, isCheck: false);

      final newMessages = fullLatest
          .where((msg) => !_loadedMessageIds.contains(msg['id']))
          .toList();

      if (newMessages.isEmpty) {
        return;
      }

      for (var msg in newMessages) {
        _loadedMessageIds.add(msg['id']);
      }

      if (userMessageBody != null) {
        final userMessage = newMessages.firstWhere(
          (msg) => parseHtmlBody(msg['body']) == userMessageBody,
          orElse: () => null,
        );

        if (userMessage != null) {
          _messages.removeWhere((msg) => msg['id'] == -1);
          _loadedMessageIds.remove(-1);
          final otherNewMessages = newMessages
              .where((msg) => msg['id'] != userMessage['id'])
              .toList();
          _messages.add(userMessage);
          _messages.addAll(otherNewMessages.reversed);
        } else {
          _messages.addAll(newMessages.reversed);
        }
      } else {
        _messages.addAll(newMessages.reversed);
      }

      final channel = await IsarService.getCachedChannel(channelId) ??
          ChannelIsar(serverId: channelId);
      final chatMessages = newMessages
          .map((msg) => ChatMessageIsar.fromJson(msg, channel))
          .toList();
      await IsarService.saveChatMessages(chatMessages);

      notifyListeners();

      if (_scrollController.hasClients) {
        final isAtBottom = _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 20;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            if (isAtBottom || scrollToBottom) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          }
        });
      }
    } catch (_) {}
  }

  /// Fetches latest messages to detect new updates.
  ///
  /// - Avoids re-fetch if message ID unchanged
  /// - Merges new messages into list
  /// - Updates local cache
  /// - Auto-scrolls if user is at bottom
  /// - Replaces temporary user message if needed
  Future<List<dynamic>> _fetchMessages({
    required int limit,
    required int offset,
    required bool isCheck,
  }) async {
    try {
      final result = await CompanySessionManager.callKwWithCompany({
        'model': 'mail.message',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['res_id', '=', channelId],
            ['message_type', '=', 'comment'],
            ['model', '=', 'discuss.channel'],
            ['body', '!=', '<span class="o-mail-Message-edited"></span>']
          ],
          'fields': isCheck
              ? ['id']
              : ['id', 'body', 'author_id', 'date', 'create_uid', 'subtype_id'],
          'order': 'id desc',
          'limit': limit,
          'offset': offset,
        },
      });

      if (discussprovider != null && result.isNotEmpty && isCheck == false) {
        final lastMessage = result.first;
        final lastMessageId = lastMessage['id'];
        final lastMessageBody = parseHtmlBody(lastMessage['body']);

        await discussprovider!.markChannelAsRead(
          isOdoo18: isOdoo18,
          client: client,
          ctx: discussprovider!.context!,
          odooServerUrl: client.baseURL,
          sessionId: client.sessionId!.id,
          channelId: channelId,
          lastMessageId: lastMessageId,
        );

        final index = discussprovider!.chats
            .indexWhere((chat) => chat.channelId == channelId);
        if (index != -1) {
          final updatedChat = discussprovider!.chats[index].copyWith(
            lastMessage: lastMessageBody,
            messageUnreadCounter: 0,
            isSeen: true,
          );
          discussprovider!.chats[index] = updatedChat;
          discussprovider!.notifyListeners();
        }
      }

      return result;
    } catch (e) {
      return [];
    }
  }

  /// Sends a message to the Odoo channel.
  ///
  /// - Performs HTTP JSON-RPC request
  /// - Clears input field on success
  /// - Fetches latest messages after sending
  /// - Prevents sending when offline
  ///
  /// Returns:
  /// - Server response map on success
  /// - Empty map on failure
  Future<Map<String, dynamic>> sendChannelMessage({
    required OdooClient client,
    required BuildContext ctx,
    required String odooServerUrl,
    required String sessionId,
    required int channelId,
    required String messageBody,
    List<int>? attachmentIds,
    List<int>? partnerIds,
    int subtypeId = 1,
  }) async {
    if (_isOffline) {
      return {};
    }

    messageSending = true;
    notifyListeners();

    final url = Uri.parse('$odooServerUrl/mail/message/post');
    final headers = {
      'Content-Type': 'application/json',
      'Cookie': 'session_id=$sessionId',
    };

    final body = jsonEncode({
      'jsonrpc': '2.0',
      'method': 'call',
      'params': {
        'thread_model': 'discuss.channel',
        'thread_id': channelId,
        'post_data': {
          'body': messageBody,
          'email_add_signature': true,
          'message_type': 'comment',
          'subtype_xmlid': 'mail.mt_comment',
          'attachment_ids': attachmentIds ?? [],
          'partner_ids': partnerIds ?? [],
        },
        'context': {
          'mail_create_nosubscribe': false,
          'mail_post_autofollow': true,
        },
      },
      'id': null,
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseBody['error'] != null) {
          final error = responseBody['error'];
          throw Exception('Failed to send message: ${error['message']}');
        } else {
          if (ctx.mounted) {
            await _fetchLatestMessages(true, userMessageBody: messageBody);
          }
          textController.clear();
          return responseBody['result'] as Map<String, dynamic>;
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      return {};
    } finally {
      messageSending = false;
      notifyListeners();
    }
  }

  /// Converts HTML message body to plain text.
  ///
  /// - Removes HTML tags
  /// - Returns trimmed text
  /// - Falls back to raw HTML if parsing fails
  String parseHtmlBody(String html) {
    try {
      final document = parse(html);
      final result = document.body?.text.trim() ?? '';
      return result;
    } catch (e) {
      return html;
    }
  }

  /// Formats message date into readable time format.
  ///
  /// Output example:
  /// - "2:45 PM"
  ///
  /// Handles:
  /// - UTC conversion
  /// - Missing timezone indicator
  String formatDate(String? createDateString) {
    try {
      if (createDateString == null) {
        return '';
      }
      if (!createDateString.contains('Z') && !createDateString.contains('+')) {
        createDateString = '${createDateString}Z';
      }
      final parsed = DateTime.parse(createDateString).toLocal();
      final formatted = DateFormat('h:mm a', 'en_US').format(parsed);
      return formatted;
    } catch (e) {
      return '';
    }
  }

  /// Returns month name from numeric month value.
  ///
  /// Example:
  /// - 1 → January
  /// - 12 → December
  String monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final result = months[month - 1];
    return result;
  }

  /// Cleans up resources.
  ///
  /// - Cancels timers
  /// - Removes scroll listener
  /// - Disposes controllers
  @override
  void dispose() {
    _debounceTimer?.cancel();
    _pollingTimer?.cancel();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }
}
