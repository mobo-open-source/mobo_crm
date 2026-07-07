import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';

/// Represents an Odoo mail channel (chat, group, or channel).
///
/// Contains channel metadata, members, unread counters,
/// and avatar-related information.
class Channel {
  final int id;
  final String name;
  final String channelType;
  final int memberCount;
  final List<int> channelMemberIds;
  final MemoryImage? image;
  final bool isMember;
  final String displayName;
  final String cacheKey;
  final String? imageBase64Svg;
  final int messageUnreadCounter;
  final List<int> partnerIds;

  /// Creates a [Channel] instance.
  Channel({
    required this.id,
    required this.cacheKey,
    required this.name,
    required this.channelType,
    required this.memberCount,
    required this.channelMemberIds,
    this.image,
    required this.isMember,
    required this.displayName,
    required this.messageUnreadCounter,
    required this.imageBase64Svg,
    required this.partnerIds,
  });

  /// Creates a [Channel] from JSON.
  ///
  /// Computes the channel name depending on the channel type:
  /// - `channel` → Uses display name
  /// - `chat` → Removes current user name from display name
  /// - `group` → Uses partner names if display name is missing
  factory Channel.fromJson(
    Map<String, dynamic> json, {
    required String currentUserName,
    required String companyName,
    required List<String> partnerNames,
  }) {
    String? svgBase64;
    if (json['image_128'] != false &&
        json['image_128'] is String &&
        json['image_128'].isNotEmpty) {
      svgBase64 = json['image_128'];
    }

    final String channelType = json['channel_type'];
    final dynamic displayNameRaw = json['display_name'];
    final bool hasDisplayName = displayNameRaw != false;

    String computedName = 'Unnamed Channel';

    if (channelType == 'channel') {
      computedName = hasDisplayName ? displayNameRaw : 'Unnamed Channel';
    } else if (channelType == 'chat') {
      if (hasDisplayName && displayNameRaw is String) {
        final others = displayNameRaw
            .split(',')
            .map((e) => e.trim())
            .where((name) => name != currentUserName)
            .toList();
        computedName = others.join(', ');
      }
    } else if (channelType == 'group') {
      if (!hasDisplayName) {
        computedName = partnerNames.join(', ');
      } else {
        computedName = displayNameRaw;
      }
    }

    return Channel(
      cacheKey: json.containsKey('avatar_cache_key') &&
              json['avatar_cache_key'] != false
          ? json['avatar_cache_key']
          : '',
      id: json['id'],
      name: computedName,
      channelType: channelType,
      memberCount: json['member_count'],
      channelMemberIds: List<int>.from(json['channel_member_ids']),
      imageBase64Svg: svgBase64,
      isMember: json['is_member'],
      displayName: hasDisplayName ? displayNameRaw : 'Unnamed Channel',
      messageUnreadCounter: json['message_unread_counter'],
      partnerIds: json['partner_ids'] is List
          ? List<int>.from(json['partner_ids'])
          : [],
    );
  }
}

/// Represents a message inside a specific channel.
class ChatMessage {
  final int id;
  final String body;
  final String date;
  final int channelId;
  final String recordTitle;
  final MemoryImage? recordImage;
  final String lastMessage;
  final bool isSeen;
  final bool isFetched;
  final int messageUnreadCounter;
  final Channel channel;
  final String lastUpdate;

  /// Creates a [ChatMessage] instance.
  ChatMessage({
    required this.id,
    required this.body,
    required this.date,
    required this.channelId,
    required this.recordTitle,
    required this.channel,
    this.recordImage,
    required this.lastMessage,
    required this.isSeen,
    required this.lastUpdate,
    required this.isFetched,
    required this.messageUnreadCounter,
  });

  /// Creates a copy of the current [ChatMessage]
  /// with optional updated values.
  ChatMessage copyWith({
    int? id,
    String? body,
    String? date,
    int? channelId,
    String? recordTitle,
    MemoryImage? recordImage,
    String? lastMessage,
    bool? isSeen,
    bool? isFetched,
    int? messageUnreadCounter,
    Channel? channel,
    String? lastUpdate,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      body: body ?? this.body,
      date: date ?? this.date,
      channelId: channelId ?? this.channelId,
      recordTitle: recordTitle ?? this.recordTitle,
      recordImage: recordImage ?? this.recordImage,
      lastMessage: lastMessage ?? this.lastMessage,
      isSeen: isSeen ?? this.isSeen,
      isFetched: isFetched ?? this.isFetched,
      messageUnreadCounter: messageUnreadCounter ?? this.messageUnreadCounter,
      channel: channel ?? this.channel,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  /// Creates an empty placeholder message for a channel.
  factory ChatMessage.empty(
    Channel channel, {
    int? seenMessageId,
    int? fetchedMessageId,
  }) {
    return ChatMessage(
      id: -1,
      body: '',
      date: '',
      channelId: channel.id,
      recordTitle: channel.displayName,
      recordImage: channel.image,
      lastMessage: '',
      isSeen: seenMessageId != null,
      isFetched: fetchedMessageId != null,
      messageUnreadCounter: channel.messageUnreadCounter,
      channel: channel,
      lastUpdate: '',
    );
  }

  /// Creates a [ChatMessage] from JSON data.
  ///
  /// Parses:
  /// - HTML body into plain text
  /// - create_date into local DateTime
  /// - Formats time as `h:mm a`
  factory ChatMessage.fromJson(Map<String, dynamic> json, Channel channel,
      {int? seenMessageId, int? fetchedMessageId}) {
    String createDateString =
        json['create_date'] ?? DateTime.now().toIso8601String();
    DateTime createDate;
    try {
      if (!createDateString.contains('Z') && !createDateString.contains('+')) {
        createDateString = '${createDateString}Z';
      }
      createDate = DateTime.parse(createDateString).toLocal();
    } catch (e) {
      createDate = DateTime.now().toLocal();
    }

    final formattedTime = DateFormat('h:mm a').format(createDate);

    final parsedMessage = json['body'] != ''
        ? _parseHtmlString(json['body'] is String ? json['body'] : 'No Body')
        : 'No Message';

    return ChatMessage(
      lastUpdate: formattedTime,
      channel: channel,
      id: json['id'],
      body: json['body'],
      date: json['date'],
      channelId: json['res_id'],
      recordTitle: channel.displayName,
      recordImage: channel.image,
      lastMessage: parsedMessage,
      isSeen: seenMessageId != null && json['id'] <= seenMessageId,
      isFetched: fetchedMessageId != null && json['id'] <= fetchedMessageId,
      messageUnreadCounter: channel.messageUnreadCounter,
    );
  }

  /// Converts HTML content into plain text.
  static String _parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }
}

/// Represents chat list preview model used for
/// conversation overview screens.
class ChatModel {
  final String name;
  final String message;
  final String time;
  final String date;
  final int latMessageId;
  final String? avatarBase64Svg;
  final String channelType;
  final int channelId;
  final int recipientId;
  final int unreadCount;
  final bool isOnline;
  final bool isSeen;
  final bool isFetched;
  String cacheKey;
  final int id;

  /// Creates a [ChatModel] instance.
  ChatModel({
    required this.name,
    required this.message,
    required this.time,
    required this.date,
    this.avatarBase64Svg,
    required this.latMessageId,
    required this.cacheKey,
    required this.channelType,
    required this.channelId,
    required this.recipientId,
    required this.unreadCount,
    required this.isOnline,
    required this.isSeen,
    required this.isFetched,
    required this.id,
  });
}

/// Represents a detailed mail message from Odoo.
class Message {
  final int createId;
  final String author;
  final String avatarUrl;
  final DateTime date;
  final String time;
  final String content;
  final String company;
  final String messageType;
  final bool isBot;
  final int id;
  final String subType;
  final List<TrackingValue> trackingValues;

  /// Creates a [Message] instance.
  Message({
    required this.createId,
    required this.author,
    required this.avatarUrl,
    required this.date,
    required this.subType,
    required this.time,
    required this.content,
    required this.company,
    required this.id,
    required this.messageType,
    required this.isBot,
    required this.trackingValues,
  });

  /// Creates a [Message] from JSON.
  ///
  /// - Extracts author information
  /// - Parses HTML body
  /// - Converts timestamps
  /// - Maps tracking values
  factory Message.fromJson(
    Map<String, dynamic> json, {
    Map<int, TrackingValue>? trackingMap,
  }) {
    final authorData =
        json['create_uid'] is List && json['create_uid'].length >= 2
            ? json['create_uid'][1]
            : 'Unknown';
    final authorId = json['author_id'] is List && json['author_id'].length >= 2
        ? json['author_id'][0]
        : 0;
    final sub = json['subtype_id'] is List && json['subtype_id'].length >= 2
        ? json['subtype_id'][1]
        : null;
    final company =
        json['email_from']?.split('@')?.last.split('.')[0] ?? 'Unknown';
    final rawBody = json['body'] ?? '';
    final parsedBody = html_parser.parse(rawBody).body?.text.trim() ?? '';
    final id = json['res_id'];
    String createDateString =
        json['create_date'] ?? DateTime.now().toIso8601String();
    DateTime createDate;
    try {
      if (!createDateString.contains('Z') && !createDateString.contains('+')) {
        createDateString = '${createDateString}Z';
      }
      createDate = DateTime.parse(createDateString).toLocal();
    } catch (e) {
      createDate = DateTime.now().toLocal();
    }

    final formattedTime = DateFormat('h:mm a').format(createDate);

    final trackingIds = List<int>.from(json['tracking_value_ids'] ?? []);
    List<TrackingValue> trackingValues = trackingMap != null
        ? trackingIds
            .map((id) => trackingMap[id])
            .whereType<TrackingValue>()
            .toList()
        : [];

    return Message(
      id: id,
      createId: authorId,
      author: authorData,
      avatarUrl: '',
      date: createDate,
      time: formattedTime,
      subType: sub,
      content: parsedBody,
      company: company,
      messageType: json['message_type'] ?? '',
      isBot: authorData.toLowerCase().contains('odoo'),
      trackingValues: trackingValues,
    );
  }
}

/// Represents a field tracking change in Odoo.
///
/// Used for showing old and new values when
/// a record is updated.
class TrackingValue {
  final int id;
  final String oldValue;
  final String newValue;
  final String fieldId;

  /// Creates a [TrackingValue] instance.
  TrackingValue({
    required this.id,
    required this.oldValue,
    required this.newValue,
    required this.fieldId,
  });

  /// Creates a [TrackingValue] from JSON.
  ///
  /// Extracts:
  /// - Field name (cleaned from metadata)
  /// - Old value (char or float)
  /// - New value (char or float)
  factory TrackingValue.fromJson(Map<String, dynamic> json) {
    String rawField = json['field_id'][1];
    String cleanField =
        rawField.contains('(') ? rawField.split('(')[0].trim() : rawField;
    final oldChar = json['old_value_char'];
    final newChar = json['new_value_char'];
    final oldFloat = json['old_value_float'];
    final newFloat = json['new_value_float'];

    final oldValue = (oldChar != null && oldChar != false)
        ? oldChar
        : (oldFloat != null && oldFloat != false)
            ? oldFloat.toString()
            : 'None';

    final newValue = (newChar != null && newChar != false)
        ? newChar
        : (newFloat != null && newFloat != false)
            ? newFloat.toString()
            : 'None';
    return TrackingValue(
      id: json['id'],
      oldValue: oldValue,
      newValue: newValue,
      fieldId: cleanField,
    );
  }
}
