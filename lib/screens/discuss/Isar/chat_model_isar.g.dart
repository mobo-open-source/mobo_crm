// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetChannelIsarCollection on Isar {
  IsarCollection<ChannelIsar> get channelIsars => this.collection();
}

const ChannelIsarSchema = CollectionSchema(
  name: r'ChannelIsar',
  id: -5414208842329099533,
  properties: {
    r'avatarCacheKey': PropertySchema(
      id: 0,
      name: r'avatarCacheKey',
      type: IsarType.string,
    ),
    r'channelMemberIds': PropertySchema(
      id: 1,
      name: r'channelMemberIds',
      type: IsarType.longList,
    ),
    r'channelPartnerIds': PropertySchema(
      id: 2,
      name: r'channelPartnerIds',
      type: IsarType.longList,
    ),
    r'channelType': PropertySchema(
      id: 3,
      name: r'channelType',
      type: IsarType.string,
    ),
    r'companyName': PropertySchema(
      id: 4,
      name: r'companyName',
      type: IsarType.string,
    ),
    r'currentUserName': PropertySchema(
      id: 5,
      name: r'currentUserName',
      type: IsarType.string,
    ),
    r'displayName': PropertySchema(
      id: 6,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'hasMessage': PropertySchema(
      id: 7,
      name: r'hasMessage',
      type: IsarType.bool,
    ),
    r'imageBase64Svg': PropertySchema(
      id: 8,
      name: r'imageBase64Svg',
      type: IsarType.string,
    ),
    r'isMember': PropertySchema(
      id: 9,
      name: r'isMember',
      type: IsarType.bool,
    ),
    r'lastInterestDt': PropertySchema(
      id: 10,
      name: r'lastInterestDt',
      type: IsarType.string,
    ),
    r'memberCount': PropertySchema(
      id: 11,
      name: r'memberCount',
      type: IsarType.long,
    ),
    r'messagePartnerIds': PropertySchema(
      id: 12,
      name: r'messagePartnerIds',
      type: IsarType.longList,
    ),
    r'messageUnreadCounter': PropertySchema(
      id: 13,
      name: r'messageUnreadCounter',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 14,
      name: r'name',
      type: IsarType.string,
    ),
    r'partnerIds': PropertySchema(
      id: 15,
      name: r'partnerIds',
      type: IsarType.longList,
    ),
    r'partnerNames': PropertySchema(
      id: 16,
      name: r'partnerNames',
      type: IsarType.stringList,
    ),
    r'serverId': PropertySchema(
      id: 17,
      name: r'serverId',
      type: IsarType.long,
    ),
    r'websiteMessageIds': PropertySchema(
      id: 18,
      name: r'websiteMessageIds',
      type: IsarType.longList,
    )
  },
  estimateSize: _channelIsarEstimateSize,
  serialize: _channelIsarSerialize,
  deserialize: _channelIsarDeserialize,
  deserializeProp: _channelIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'messages': LinkSchema(
      id: 383194938363939970,
      name: r'messages',
      target: r'ChatMessageIsar',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _channelIsarGetId,
  getLinks: _channelIsarGetLinks,
  attach: _channelIsarAttach,
  version: '3.3.2',
);

int _channelIsarEstimateSize(
  ChannelIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.avatarCacheKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.channelMemberIds;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.channelPartnerIds;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.channelType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.companyName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.currentUserName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.displayName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.imageBase64Svg;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastInterestDt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.messagePartnerIds;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.partnerIds;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final list = object.partnerNames;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.websiteMessageIds;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  return bytesCount;
}

void _channelIsarSerialize(
  ChannelIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.avatarCacheKey);
  writer.writeLongList(offsets[1], object.channelMemberIds);
  writer.writeLongList(offsets[2], object.channelPartnerIds);
  writer.writeString(offsets[3], object.channelType);
  writer.writeString(offsets[4], object.companyName);
  writer.writeString(offsets[5], object.currentUserName);
  writer.writeString(offsets[6], object.displayName);
  writer.writeBool(offsets[7], object.hasMessage);
  writer.writeString(offsets[8], object.imageBase64Svg);
  writer.writeBool(offsets[9], object.isMember);
  writer.writeString(offsets[10], object.lastInterestDt);
  writer.writeLong(offsets[11], object.memberCount);
  writer.writeLongList(offsets[12], object.messagePartnerIds);
  writer.writeLong(offsets[13], object.messageUnreadCounter);
  writer.writeString(offsets[14], object.name);
  writer.writeLongList(offsets[15], object.partnerIds);
  writer.writeStringList(offsets[16], object.partnerNames);
  writer.writeLong(offsets[17], object.serverId);
  writer.writeLongList(offsets[18], object.websiteMessageIds);
}

ChannelIsar _channelIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChannelIsar(
    avatarCacheKey: reader.readStringOrNull(offsets[0]),
    channelMemberIds: reader.readLongList(offsets[1]),
    channelPartnerIds: reader.readLongList(offsets[2]),
    channelType: reader.readStringOrNull(offsets[3]),
    companyName: reader.readStringOrNull(offsets[4]),
    currentUserName: reader.readStringOrNull(offsets[5]),
    displayName: reader.readStringOrNull(offsets[6]),
    hasMessage: reader.readBoolOrNull(offsets[7]),
    imageBase64Svg: reader.readStringOrNull(offsets[8]),
    isMember: reader.readBoolOrNull(offsets[9]),
    lastInterestDt: reader.readStringOrNull(offsets[10]),
    memberCount: reader.readLongOrNull(offsets[11]),
    messagePartnerIds: reader.readLongList(offsets[12]),
    messageUnreadCounter: reader.readLongOrNull(offsets[13]),
    name: reader.readStringOrNull(offsets[14]),
    partnerIds: reader.readLongList(offsets[15]),
    partnerNames: reader.readStringList(offsets[16]),
    serverId: reader.readLongOrNull(offsets[17]),
    websiteMessageIds: reader.readLongList(offsets[18]),
  );
  object.id = id;
  return object;
}

P _channelIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongList(offset)) as P;
    case 2:
      return (reader.readLongList(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readBoolOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readLongList(offset)) as P;
    case 13:
      return (reader.readLongOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readLongList(offset)) as P;
    case 16:
      return (reader.readStringList(offset)) as P;
    case 17:
      return (reader.readLongOrNull(offset)) as P;
    case 18:
      return (reader.readLongList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _channelIsarGetId(ChannelIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _channelIsarGetLinks(ChannelIsar object) {
  return [object.messages];
}

void _channelIsarAttach(
    IsarCollection<dynamic> col, Id id, ChannelIsar object) {
  object.id = id;
  object.messages
      .attach(col, col.isar.collection<ChatMessageIsar>(), r'messages', id);
}

extension ChannelIsarQueryWhereSort
    on QueryBuilder<ChannelIsar, ChannelIsar, QWhere> {
  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ChannelIsarQueryWhere
    on QueryBuilder<ChannelIsar, ChannelIsar, QWhereClause> {
  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChannelIsarQueryFilter
    on QueryBuilder<ChannelIsar, ChannelIsar, QFilterCondition> {
  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      avatarCacheKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'avatarCacheKey',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      avatarCacheKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'avatarCacheKey',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      avatarCacheKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avatarCacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      avatarCacheKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avatarCacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      avatarCacheKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avatarCacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      avatarCacheKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avatarCacheKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      avatarCacheKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'avatarCacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      avatarCacheKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'avatarCacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      avatarCacheKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'avatarCacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      avatarCacheKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'avatarCacheKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      avatarCacheKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avatarCacheKey',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      avatarCacheKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'avatarCacheKey',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelMemberIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'channelMemberIds',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelMemberIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'channelMemberIds',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelMemberIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channelMemberIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelMemberIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'channelMemberIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelMemberIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'channelMemberIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelMemberIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'channelMemberIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelMemberIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'channelMemberIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelMemberIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'channelMemberIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelMemberIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'channelMemberIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelMemberIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'channelMemberIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelMemberIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'channelMemberIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelMemberIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'channelMemberIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelPartnerIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'channelPartnerIds',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelPartnerIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'channelPartnerIds',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelPartnerIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channelPartnerIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelPartnerIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'channelPartnerIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelPartnerIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'channelPartnerIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelPartnerIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'channelPartnerIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelPartnerIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'channelPartnerIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelPartnerIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'channelPartnerIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelPartnerIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'channelPartnerIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelPartnerIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'channelPartnerIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelPartnerIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'channelPartnerIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelPartnerIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'channelPartnerIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'channelType',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'channelType',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'channelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'channelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'channelType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'channelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'channelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'channelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'channelType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channelType',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'channelType',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      companyNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'companyName',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      companyNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'companyName',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      companyNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'companyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      companyNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'companyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      companyNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'companyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      companyNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'companyName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      companyNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'companyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      companyNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'companyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      companyNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'companyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      companyNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'companyName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      companyNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'companyName',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      companyNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'companyName',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      currentUserNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currentUserName',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      currentUserNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currentUserName',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      currentUserNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentUserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      currentUserNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentUserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      currentUserNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentUserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      currentUserNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentUserName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      currentUserNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currentUserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      currentUserNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currentUserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      currentUserNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currentUserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      currentUserNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currentUserName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      currentUserNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentUserName',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      currentUserNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currentUserName',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      displayNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'displayName',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      displayNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'displayName',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      displayNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      displayNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      displayNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      displayNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      displayNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      displayNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      hasMessageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hasMessage',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      hasMessageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hasMessage',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      hasMessageEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasMessage',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      imageBase64SvgIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imageBase64Svg',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      imageBase64SvgIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imageBase64Svg',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      imageBase64SvgEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageBase64Svg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      imageBase64SvgGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageBase64Svg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      imageBase64SvgLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageBase64Svg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      imageBase64SvgBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageBase64Svg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      imageBase64SvgStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageBase64Svg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      imageBase64SvgEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageBase64Svg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      imageBase64SvgContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageBase64Svg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      imageBase64SvgMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageBase64Svg',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      imageBase64SvgIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageBase64Svg',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      imageBase64SvgIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageBase64Svg',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      isMemberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isMember',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      isMemberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isMember',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> isMemberEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isMember',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastInterestDtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastInterestDt',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastInterestDtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastInterestDt',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastInterestDtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastInterestDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastInterestDtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastInterestDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastInterestDtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastInterestDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastInterestDtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastInterestDt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastInterestDtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastInterestDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastInterestDtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastInterestDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastInterestDtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastInterestDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastInterestDtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastInterestDt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastInterestDtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastInterestDt',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastInterestDtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastInterestDt',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      memberCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'memberCount',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      memberCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'memberCount',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      memberCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'memberCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      memberCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'memberCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      memberCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'memberCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      memberCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'memberCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messagePartnerIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'messagePartnerIds',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messagePartnerIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'messagePartnerIds',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messagePartnerIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'messagePartnerIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messagePartnerIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'messagePartnerIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messagePartnerIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'messagePartnerIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messagePartnerIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'messagePartnerIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messagePartnerIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'messagePartnerIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messagePartnerIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'messagePartnerIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messagePartnerIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'messagePartnerIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messagePartnerIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'messagePartnerIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messagePartnerIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'messagePartnerIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messagePartnerIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'messagePartnerIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messageUnreadCounterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'messageUnreadCounter',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messageUnreadCounterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'messageUnreadCounter',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messageUnreadCounterEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'messageUnreadCounter',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messageUnreadCounterGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'messageUnreadCounter',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messageUnreadCounterLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'messageUnreadCounter',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messageUnreadCounterBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'messageUnreadCounter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'partnerIds',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'partnerIds',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partnerIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partnerIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partnerIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partnerIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'partnerIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'partnerIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'partnerIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'partnerIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'partnerIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'partnerIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerNamesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'partnerNames',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerNamesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'partnerNames',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerNamesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partnerNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerNamesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partnerNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerNamesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partnerNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerNamesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partnerNames',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerNamesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'partnerNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerNamesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'partnerNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerNamesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'partnerNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerNamesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'partnerNames',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerNamesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partnerNames',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerNamesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'partnerNames',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerNamesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'partnerNames',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerNamesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'partnerNames',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerNamesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'partnerNames',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerNamesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'partnerNames',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerNamesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'partnerNames',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      partnerNamesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'partnerNames',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      serverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> serverIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      serverIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      serverIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> serverIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serverId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      websiteMessageIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'websiteMessageIds',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      websiteMessageIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'websiteMessageIds',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      websiteMessageIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'websiteMessageIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      websiteMessageIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'websiteMessageIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      websiteMessageIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'websiteMessageIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      websiteMessageIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'websiteMessageIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      websiteMessageIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'websiteMessageIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      websiteMessageIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'websiteMessageIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      websiteMessageIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'websiteMessageIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      websiteMessageIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'websiteMessageIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      websiteMessageIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'websiteMessageIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      websiteMessageIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'websiteMessageIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ChannelIsarQueryObject
    on QueryBuilder<ChannelIsar, ChannelIsar, QFilterCondition> {}

extension ChannelIsarQueryLinks
    on QueryBuilder<ChannelIsar, ChannelIsar, QFilterCondition> {
  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> messages(
      FilterQuery<ChatMessageIsar> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'messages');
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messagesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'messages', length, true, length, true);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messagesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'messages', 0, true, 0, true);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messagesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'messages', 0, false, 999999, true);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messagesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'messages', 0, true, length, include);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messagesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'messages', length, include, 999999, true);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      messagesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'messages', lower, includeLower, upper, includeUpper);
    });
  }
}

extension ChannelIsarQuerySortBy
    on QueryBuilder<ChannelIsar, ChannelIsar, QSortBy> {
  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByAvatarCacheKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarCacheKey', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      sortByAvatarCacheKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarCacheKey', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByChannelType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelType', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByChannelTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelType', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByCompanyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyName', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByCompanyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyName', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByCurrentUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentUserName', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      sortByCurrentUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentUserName', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByHasMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasMessage', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByHasMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasMessage', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByImageBase64Svg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageBase64Svg', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      sortByImageBase64SvgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageBase64Svg', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByIsMember() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMember', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByIsMemberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMember', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByLastInterestDt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastInterestDt', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      sortByLastInterestDtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastInterestDt', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByMemberCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memberCount', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByMemberCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memberCount', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      sortByMessageUnreadCounter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageUnreadCounter', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      sortByMessageUnreadCounterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageUnreadCounter', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }
}

extension ChannelIsarQuerySortThenBy
    on QueryBuilder<ChannelIsar, ChannelIsar, QSortThenBy> {
  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByAvatarCacheKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarCacheKey', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      thenByAvatarCacheKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarCacheKey', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByChannelType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelType', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByChannelTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelType', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByCompanyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyName', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByCompanyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyName', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByCurrentUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentUserName', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      thenByCurrentUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentUserName', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByHasMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasMessage', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByHasMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasMessage', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByImageBase64Svg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageBase64Svg', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      thenByImageBase64SvgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageBase64Svg', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByIsMember() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMember', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByIsMemberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMember', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByLastInterestDt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastInterestDt', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      thenByLastInterestDtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastInterestDt', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByMemberCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memberCount', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByMemberCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memberCount', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      thenByMessageUnreadCounter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageUnreadCounter', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      thenByMessageUnreadCounterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageUnreadCounter', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }
}

extension ChannelIsarQueryWhereDistinct
    on QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> {
  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByAvatarCacheKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avatarCacheKey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct>
      distinctByChannelMemberIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'channelMemberIds');
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct>
      distinctByChannelPartnerIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'channelPartnerIds');
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByChannelType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'channelType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByCompanyName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'companyName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByCurrentUserName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentUserName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByDisplayName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByHasMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasMessage');
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByImageBase64Svg(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageBase64Svg',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByIsMember() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMember');
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByLastInterestDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastInterestDt',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByMemberCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'memberCount');
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct>
      distinctByMessagePartnerIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'messagePartnerIds');
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct>
      distinctByMessageUnreadCounter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'messageUnreadCounter');
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByPartnerIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partnerIds');
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByPartnerNames() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partnerNames');
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId');
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct>
      distinctByWebsiteMessageIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'websiteMessageIds');
    });
  }
}

extension ChannelIsarQueryProperty
    on QueryBuilder<ChannelIsar, ChannelIsar, QQueryProperty> {
  QueryBuilder<ChannelIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ChannelIsar, String?, QQueryOperations>
      avatarCacheKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avatarCacheKey');
    });
  }

  QueryBuilder<ChannelIsar, List<int>?, QQueryOperations>
      channelMemberIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'channelMemberIds');
    });
  }

  QueryBuilder<ChannelIsar, List<int>?, QQueryOperations>
      channelPartnerIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'channelPartnerIds');
    });
  }

  QueryBuilder<ChannelIsar, String?, QQueryOperations> channelTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'channelType');
    });
  }

  QueryBuilder<ChannelIsar, String?, QQueryOperations> companyNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'companyName');
    });
  }

  QueryBuilder<ChannelIsar, String?, QQueryOperations>
      currentUserNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentUserName');
    });
  }

  QueryBuilder<ChannelIsar, String?, QQueryOperations> displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<ChannelIsar, bool?, QQueryOperations> hasMessageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasMessage');
    });
  }

  QueryBuilder<ChannelIsar, String?, QQueryOperations>
      imageBase64SvgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageBase64Svg');
    });
  }

  QueryBuilder<ChannelIsar, bool?, QQueryOperations> isMemberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMember');
    });
  }

  QueryBuilder<ChannelIsar, String?, QQueryOperations>
      lastInterestDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastInterestDt');
    });
  }

  QueryBuilder<ChannelIsar, int?, QQueryOperations> memberCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'memberCount');
    });
  }

  QueryBuilder<ChannelIsar, List<int>?, QQueryOperations>
      messagePartnerIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'messagePartnerIds');
    });
  }

  QueryBuilder<ChannelIsar, int?, QQueryOperations>
      messageUnreadCounterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'messageUnreadCounter');
    });
  }

  QueryBuilder<ChannelIsar, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<ChannelIsar, List<int>?, QQueryOperations> partnerIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partnerIds');
    });
  }

  QueryBuilder<ChannelIsar, List<String>?, QQueryOperations>
      partnerNamesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partnerNames');
    });
  }

  QueryBuilder<ChannelIsar, int?, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<ChannelIsar, List<int>?, QQueryOperations>
      websiteMessageIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'websiteMessageIds');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetChatMessageIsarCollection on Isar {
  IsarCollection<ChatMessageIsar> get chatMessageIsars => this.collection();
}

const ChatMessageIsarSchema = CollectionSchema(
  name: r'ChatMessageIsar',
  id: -6708210023723838043,
  properties: {
    r'body': PropertySchema(
      id: 0,
      name: r'body',
      type: IsarType.string,
    ),
    r'channelId': PropertySchema(
      id: 1,
      name: r'channelId',
      type: IsarType.long,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.string,
    ),
    r'fetchedMessageId': PropertySchema(
      id: 3,
      name: r'fetchedMessageId',
      type: IsarType.long,
    ),
    r'isFetched': PropertySchema(
      id: 4,
      name: r'isFetched',
      type: IsarType.bool,
    ),
    r'isSeen': PropertySchema(
      id: 5,
      name: r'isSeen',
      type: IsarType.bool,
    ),
    r'messageId': PropertySchema(
      id: 6,
      name: r'messageId',
      type: IsarType.long,
    ),
    r'messageUnreadCounter': PropertySchema(
      id: 7,
      name: r'messageUnreadCounter',
      type: IsarType.long,
    ),
    r'seenMessageId': PropertySchema(
      id: 8,
      name: r'seenMessageId',
      type: IsarType.long,
    )
  },
  estimateSize: _chatMessageIsarEstimateSize,
  serialize: _chatMessageIsarSerialize,
  deserialize: _chatMessageIsarDeserialize,
  deserializeProp: _chatMessageIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'channel': LinkSchema(
      id: 2849349777544265138,
      name: r'channel',
      target: r'ChannelIsar',
      single: true,
      linkName: r'messages',
    )
  },
  embeddedSchemas: {},
  getId: _chatMessageIsarGetId,
  getLinks: _chatMessageIsarGetLinks,
  attach: _chatMessageIsarAttach,
  version: '3.3.2',
);

int _chatMessageIsarEstimateSize(
  ChatMessageIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.body;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.date;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _chatMessageIsarSerialize(
  ChatMessageIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.body);
  writer.writeLong(offsets[1], object.channelId);
  writer.writeString(offsets[2], object.date);
  writer.writeLong(offsets[3], object.fetchedMessageId);
  writer.writeBool(offsets[4], object.isFetched);
  writer.writeBool(offsets[5], object.isSeen);
  writer.writeLong(offsets[6], object.messageId);
  writer.writeLong(offsets[7], object.messageUnreadCounter);
  writer.writeLong(offsets[8], object.seenMessageId);
}

ChatMessageIsar _chatMessageIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChatMessageIsar(
    body: reader.readStringOrNull(offsets[0]),
    channelId: reader.readLongOrNull(offsets[1]),
    date: reader.readStringOrNull(offsets[2]),
    fetchedMessageId: reader.readLongOrNull(offsets[3]),
    isFetched: reader.readBoolOrNull(offsets[4]),
    isSeen: reader.readBoolOrNull(offsets[5]),
    messageId: reader.readLongOrNull(offsets[6]),
    messageUnreadCounter: reader.readLongOrNull(offsets[7]),
    seenMessageId: reader.readLongOrNull(offsets[8]),
  );
  object.id = id;
  return object;
}

P _chatMessageIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset)) as P;
    case 5:
      return (reader.readBoolOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _chatMessageIsarGetId(ChatMessageIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _chatMessageIsarGetLinks(ChatMessageIsar object) {
  return [object.channel];
}

void _chatMessageIsarAttach(
    IsarCollection<dynamic> col, Id id, ChatMessageIsar object) {
  object.id = id;
  object.channel
      .attach(col, col.isar.collection<ChannelIsar>(), r'channel', id);
}

extension ChatMessageIsarQueryWhereSort
    on QueryBuilder<ChatMessageIsar, ChatMessageIsar, QWhere> {
  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ChatMessageIsarQueryWhere
    on QueryBuilder<ChatMessageIsar, ChatMessageIsar, QWhereClause> {
  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChatMessageIsarQueryFilter
    on QueryBuilder<ChatMessageIsar, ChatMessageIsar, QFilterCondition> {
  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      bodyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'body',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      bodyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'body',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      bodyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      bodyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      bodyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      bodyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'body',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      bodyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      bodyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      bodyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'body',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      bodyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'body',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      bodyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'body',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      bodyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'body',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      channelIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'channelId',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      channelIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'channelId',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      channelIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channelId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      channelIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'channelId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      channelIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'channelId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      channelIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'channelId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      dateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      dateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      dateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      dateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      dateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      dateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'date',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      fetchedMessageIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fetchedMessageId',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      fetchedMessageIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fetchedMessageId',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      fetchedMessageIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fetchedMessageId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      fetchedMessageIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fetchedMessageId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      fetchedMessageIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fetchedMessageId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      fetchedMessageIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fetchedMessageId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      isFetchedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isFetched',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      isFetchedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isFetched',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      isFetchedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFetched',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      isSeenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isSeen',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      isSeenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isSeen',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      isSeenEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSeen',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      messageIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'messageId',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      messageIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'messageId',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      messageIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'messageId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      messageIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'messageId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      messageIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'messageId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      messageIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'messageId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      messageUnreadCounterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'messageUnreadCounter',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      messageUnreadCounterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'messageUnreadCounter',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      messageUnreadCounterEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'messageUnreadCounter',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      messageUnreadCounterGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'messageUnreadCounter',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      messageUnreadCounterLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'messageUnreadCounter',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      messageUnreadCounterBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'messageUnreadCounter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      seenMessageIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'seenMessageId',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      seenMessageIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'seenMessageId',
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      seenMessageIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seenMessageId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      seenMessageIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seenMessageId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      seenMessageIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seenMessageId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      seenMessageIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seenMessageId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChatMessageIsarQueryObject
    on QueryBuilder<ChatMessageIsar, ChatMessageIsar, QFilterCondition> {}

extension ChatMessageIsarQueryLinks
    on QueryBuilder<ChatMessageIsar, ChatMessageIsar, QFilterCondition> {
  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition> channel(
      FilterQuery<ChannelIsar> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'channel');
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterFilterCondition>
      channelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'channel', 0, true, 0, true);
    });
  }
}

extension ChatMessageIsarQuerySortBy
    on QueryBuilder<ChatMessageIsar, ChatMessageIsar, QSortBy> {
  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy> sortByBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      sortByBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.desc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      sortByChannelId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelId', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      sortByChannelIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelId', Sort.desc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      sortByFetchedMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedMessageId', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      sortByFetchedMessageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedMessageId', Sort.desc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      sortByIsFetched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFetched', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      sortByIsFetchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFetched', Sort.desc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy> sortByIsSeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSeen', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      sortByIsSeenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSeen', Sort.desc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      sortByMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageId', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      sortByMessageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageId', Sort.desc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      sortByMessageUnreadCounter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageUnreadCounter', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      sortByMessageUnreadCounterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageUnreadCounter', Sort.desc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      sortBySeenMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seenMessageId', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      sortBySeenMessageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seenMessageId', Sort.desc);
    });
  }
}

extension ChatMessageIsarQuerySortThenBy
    on QueryBuilder<ChatMessageIsar, ChatMessageIsar, QSortThenBy> {
  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy> thenByBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      thenByBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'body', Sort.desc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      thenByChannelId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelId', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      thenByChannelIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelId', Sort.desc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      thenByFetchedMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedMessageId', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      thenByFetchedMessageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedMessageId', Sort.desc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      thenByIsFetched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFetched', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      thenByIsFetchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFetched', Sort.desc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy> thenByIsSeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSeen', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      thenByIsSeenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSeen', Sort.desc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      thenByMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageId', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      thenByMessageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageId', Sort.desc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      thenByMessageUnreadCounter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageUnreadCounter', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      thenByMessageUnreadCounterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageUnreadCounter', Sort.desc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      thenBySeenMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seenMessageId', Sort.asc);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QAfterSortBy>
      thenBySeenMessageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seenMessageId', Sort.desc);
    });
  }
}

extension ChatMessageIsarQueryWhereDistinct
    on QueryBuilder<ChatMessageIsar, ChatMessageIsar, QDistinct> {
  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QDistinct> distinctByBody(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'body', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QDistinct>
      distinctByChannelId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'channelId');
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QDistinct> distinctByDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QDistinct>
      distinctByFetchedMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fetchedMessageId');
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QDistinct>
      distinctByIsFetched() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFetched');
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QDistinct> distinctByIsSeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSeen');
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QDistinct>
      distinctByMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'messageId');
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QDistinct>
      distinctByMessageUnreadCounter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'messageUnreadCounter');
    });
  }

  QueryBuilder<ChatMessageIsar, ChatMessageIsar, QDistinct>
      distinctBySeenMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seenMessageId');
    });
  }
}

extension ChatMessageIsarQueryProperty
    on QueryBuilder<ChatMessageIsar, ChatMessageIsar, QQueryProperty> {
  QueryBuilder<ChatMessageIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ChatMessageIsar, String?, QQueryOperations> bodyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'body');
    });
  }

  QueryBuilder<ChatMessageIsar, int?, QQueryOperations> channelIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'channelId');
    });
  }

  QueryBuilder<ChatMessageIsar, String?, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<ChatMessageIsar, int?, QQueryOperations>
      fetchedMessageIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fetchedMessageId');
    });
  }

  QueryBuilder<ChatMessageIsar, bool?, QQueryOperations> isFetchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFetched');
    });
  }

  QueryBuilder<ChatMessageIsar, bool?, QQueryOperations> isSeenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSeen');
    });
  }

  QueryBuilder<ChatMessageIsar, int?, QQueryOperations> messageIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'messageId');
    });
  }

  QueryBuilder<ChatMessageIsar, int?, QQueryOperations>
      messageUnreadCounterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'messageUnreadCounter');
    });
  }

  QueryBuilder<ChatMessageIsar, int?, QQueryOperations>
      seenMessageIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seenMessageId');
    });
  }
}
