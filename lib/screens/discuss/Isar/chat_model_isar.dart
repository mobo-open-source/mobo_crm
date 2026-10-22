import 'package:isar_community/isar.dart';

part 'chat_model_isar.g.dart';

/// Local Isar database model representing an Odoo mail channel.
///
/// Stores channel metadata and maintains a relationship
/// with its associated [ChatMessageIsar] messages.
///
/// Features:
/// - Auto-incremented local [id] (Isar primary key)
/// - Stores server-side channel ID ([serverId])
/// - Maintains message links via [IsarLinks]
/// - Tracks unread message counter
/// - Stores avatar and partner metadata
/// - Supports offline caching
///
/// This model mirrors Odoo Discuss channel structure
/// and is used for local persistence and offline support.
@collection
class ChannelIsar {
  Id id = Isar.autoIncrement;
  final messages = IsarLinks<ChatMessageIsar>();
  int? serverId;
  String? name;
  String? channelType;
  int? memberCount;
  List<int>? channelMemberIds;
  bool? isMember;
  String? displayName;
  bool? hasMessage;
  List<int>? websiteMessageIds;
  List<int>? channelPartnerIds;
  String? imageBase64Svg;
  List<int>? messagePartnerIds;
  String? avatarCacheKey;
  String? lastInterestDt;
  int? messageUnreadCounter;
  List<int>? partnerIds;
  String? companyName;
  String? currentUserName;
  List<String>? partnerNames;

  ChannelIsar({
    this.serverId,
    this.name,
    this.channelType,
    this.memberCount,
    this.channelMemberIds,
    this.isMember,
    this.displayName,
    this.hasMessage,
    this.websiteMessageIds,
    this.channelPartnerIds,
    this.imageBase64Svg,
    this.messagePartnerIds,
    this.avatarCacheKey,
    this.lastInterestDt,
    this.messageUnreadCounter,
    this.partnerIds,
    this.companyName,
    this.currentUserName,
    this.partnerNames,
  });

  /// Creates a [ChannelIsar] instance from Odoo JSON response.
  ///
  /// Handles:
  /// - Safe type checking
  /// - Null fallback values
  /// - Image fallback (`image_128` → `avatar_128`)
  /// - Default unread counter to 0 if null
  ///
  /// Optional Parameters:
  /// - [partnerNames]: Preprocessed partner display names
  /// - [companyName]: Current company name
  /// - [currentUserName]: Logged-in user name
  factory ChannelIsar.fromJson(Map<String, dynamic> json,
      {List<String>? partnerNames,
      String? companyName,
      String? currentUserName}) {
    return ChannelIsar(
      serverId: json['id'] is int ? json['id'] : null,
      name: json['name'] is String ? json['name'] : null,
      channelType: json['channel_type'] is String ? json['channel_type'] : null,
      memberCount: json['member_count'] is int ? json['member_count'] : null,
      channelMemberIds: json['channel_member_ids'] is List
          ? List<int>.from(json['channel_member_ids'])
          : null,
      isMember: json['is_member'] is bool ? json['is_member'] : null,
      displayName: json['display_name'] is String ? json['display_name'] : null,
      hasMessage: json['has_message'] is bool ? json['has_message'] : null,
      websiteMessageIds: json['website_message_ids'] is List
          ? List<int>.from(json['website_message_ids'])
          : null,
      channelPartnerIds: json['channel_partner_ids'] is List
          ? List<int>.from(json['channel_partner_ids'])
          : null,
      imageBase64Svg: json['image_128'] is String
          ? json['image_128']
          : json['avatar_128'] is String
              ? json['avatar_128']
              : null,
      messagePartnerIds: json['message_partner_ids'] is List
          ? List<int>.from(json['message_partner_ids'])
          : null,
      avatarCacheKey:
          json['avatar_cache_key'] is String ? json['avatar_cache_key'] : null,
      lastInterestDt:
          json['last_interest_dt'] is String ? json['last_interest_dt'] : null,
      messageUnreadCounter: json['message_unread_counter'] is int
          ? json['message_unread_counter']
          : 0,
      partnerIds: json['partner_ids'] is List
          ? List<int>.from(json['partner_ids'])
          : null,
      companyName: companyName,
      currentUserName: currentUserName,
      partnerNames: partnerNames,
    );
  }

  /// Converts the channel object into JSON format.
  ///
  /// Used for:
  /// - Local caching
  /// - Debugging
  /// - Syncing back to remote if required
  ///
  /// Ensures no null values are returned.
  Map<String, dynamic> toJson() {
    return {
      'id': serverId,
      'name': name ?? '',
      'channel_type': channelType ?? '',
      'member_count': memberCount ?? 0,
      'channel_member_ids': channelMemberIds ?? [],
      'is_member': isMember ?? false,
      'display_name': displayName ?? '',
      'has_message': hasMessage ?? false,
      'website_message_ids': websiteMessageIds ?? [],
      'channel_partner_ids': channelPartnerIds ?? [],
      'image_128': imageBase64Svg ?? '',
      'avatar_128': imageBase64Svg ?? '',
      'message_partner_ids': messagePartnerIds ?? [],
      'avatar_cache_key': avatarCacheKey ?? '',
      'last_interest_dt': lastInterestDt ?? '',
      'message_unread_counter': messageUnreadCounter ?? 0,
      'partner_ids': partnerIds ?? [],
      'company_name': companyName ?? '',
      'current_user_name': currentUserName ?? '',
      'partner_names': partnerNames ?? [],
    };
  }
}

/// Local Isar database model representing a single chat message.
///
/// Stores:
/// - Odoo message ID ([messageId])
/// - Message body
/// - Message date
/// - Channel association
/// - Seen/fetched tracking state
///
/// Relationships:
/// - Linked to [ChannelIsar] via backlink
///
/// Supports:
/// - Offline storage
/// - Read/unread tracking
/// - Incremental message fetching
@collection
class ChatMessageIsar {
  Id id = Isar.autoIncrement;

  int? messageId;
  String? body;
  String? date;
  int? channelId;
  int? seenMessageId;
  int? fetchedMessageId;
  int? messageUnreadCounter;
  bool? isSeen;
  bool? isFetched;

  @Backlink(to: 'messages')
  final channel = IsarLink<ChannelIsar>();

  ChatMessageIsar({
    this.messageId,
    this.body,
    this.date,
    this.channelId,
    this.seenMessageId,
    this.fetchedMessageId,
    this.messageUnreadCounter,
    this.isSeen,
    this.isFetched,
  });

  /// Creates a [ChatMessageIsar] instance from Odoo JSON response.
  ///
  /// Features:
  /// - Supports both `date` and `create_date`
  /// - Computes [isSeen] based on [seenMessageId]
  /// - Computes [isFetched] based on [fetchedMessageId]
  /// - Automatically links message to given [ChannelIsar]
  ///
  /// Parameters:
  /// - [channelIsar]: Associated local channel object
  /// - [seenMessageId]: Last seen message ID
  /// - [fetchedMessageId]: Last fetched message ID
  factory ChatMessageIsar.fromJson(
      Map<String, dynamic> json, ChannelIsar channelIsar,
      {int? seenMessageId, int? fetchedMessageId}) {
    return ChatMessageIsar(
      messageId: json['id'] is int ? json['id'] : null,
      body: json['body'] is String ? json['body'] : null,
      date: json['date'] is String
          ? json['date']
          : json['create_date'] is String
              ? json['create_date']
              : null,
      channelId: json['res_id'] is int ? json['res_id'] : null,
      seenMessageId: seenMessageId,
      fetchedMessageId: fetchedMessageId,
      messageUnreadCounter: json['message_unread_counter'] is int
          ? json['message_unread_counter']
          : 0,
      isSeen: seenMessageId != null &&
          json['id'] != null &&
          json['id'] <= seenMessageId,
      isFetched: fetchedMessageId != null &&
          json['id'] != null &&
          json['id'] <= fetchedMessageId,
    )..channel.value = channelIsar;
  }

  /// Creates an empty placeholder message.
  ///
  /// Used for:
  /// - Initializing channel state
  /// - Avoiding null message lists
  /// - Maintaining consistent linking structure
  ///
  /// Marks message as seen and fetched by default.
  factory ChatMessageIsar.empty(ChannelIsar channelIsar,
      {int? seenMessageId, int? fetchedMessageId}) {
    return ChatMessageIsar(
      messageId: null,
      body: '',
      date: '',
      channelId: channelIsar.serverId,
      seenMessageId: seenMessageId,
      fetchedMessageId: fetchedMessageId,
      messageUnreadCounter: 0,
      isSeen: true,
      isFetched: true,
    )..channel.value = channelIsar;
  }

  /// Converts the message object into JSON format.
  ///
  /// Includes:
  /// - Message ID
  /// - Body
  /// - Date
  /// - Seen/fetched flags
  /// - Channel reference ID
  ///
  /// Ensures safe default values for null fields.
  Map<String, dynamic> toJson() {
    return {
      'id': messageId ?? 0,
      'body': body ?? '',
      'date': date ?? '',
      'res_id': channelId ?? 0,
      'message_unread_counter': messageUnreadCounter ?? 0,
      'seen_message_id': seenMessageId,
      'fetched_message_id': fetchedMessageId,
      'is_seen': isSeen ?? true,
      'is_fetched': isFetched ?? true,
    };
  }
}
