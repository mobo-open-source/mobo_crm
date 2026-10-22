// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opportunity_model_isar_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOpportunityModelIsarCacheCollection on Isar {
  IsarCollection<OpportunityModelIsarCache> get opportunityModelIsarCaches =>
      this.collection();
}

const OpportunityModelIsarCacheSchema = CollectionSchema(
  name: r'OpportunityModelIsarCache',
  id: -8410075755840505373,
  properties: {
    r'active': PropertySchema(
      id: 0,
      name: r'active',
      type: IsarType.bool,
    ),
    r'activityDateDeadline': PropertySchema(
      id: 1,
      name: r'activityDateDeadline',
      type: IsarType.dateTime,
    ),
    r'activityIds': PropertySchema(
      id: 2,
      name: r'activityIds',
      type: IsarType.longList,
    ),
    r'activityState': PropertySchema(
      id: 3,
      name: r'activityState',
      type: IsarType.string,
    ),
    r'activityTypeId': PropertySchema(
      id: 4,
      name: r'activityTypeId',
      type: IsarType.long,
    ),
    r'activityTypeName': PropertySchema(
      id: 5,
      name: r'activityTypeName',
      type: IsarType.string,
    ),
    r'activityUserId': PropertySchema(
      id: 6,
      name: r'activityUserId',
      type: IsarType.long,
    ),
    r'activityUserName': PropertySchema(
      id: 7,
      name: r'activityUserName',
      type: IsarType.string,
    ),
    r'city': PropertySchema(
      id: 8,
      name: r'city',
      type: IsarType.string,
    ),
    r'contactName': PropertySchema(
      id: 9,
      name: r'contactName',
      type: IsarType.string,
    ),
    r'countryId': PropertySchema(
      id: 10,
      name: r'countryId',
      type: IsarType.long,
    ),
    r'countryName': PropertySchema(
      id: 11,
      name: r'countryName',
      type: IsarType.string,
    ),
    r'createDate': PropertySchema(
      id: 12,
      name: r'createDate',
      type: IsarType.dateTime,
    ),
    r'dateClosed': PropertySchema(
      id: 13,
      name: r'dateClosed',
      type: IsarType.dateTime,
    ),
    r'dateDeadline': PropertySchema(
      id: 14,
      name: r'dateDeadline',
      type: IsarType.dateTime,
    ),
    r'dateOpen': PropertySchema(
      id: 15,
      name: r'dateOpen',
      type: IsarType.dateTime,
    ),
    r'dayClose': PropertySchema(
      id: 16,
      name: r'dayClose',
      type: IsarType.double,
    ),
    r'description': PropertySchema(
      id: 17,
      name: r'description',
      type: IsarType.string,
    ),
    r'emailFrom': PropertySchema(
      id: 18,
      name: r'emailFrom',
      type: IsarType.string,
    ),
    r'expectedRevenue': PropertySchema(
      id: 19,
      name: r'expectedRevenue',
      type: IsarType.double,
    ),
    r'mobile': PropertySchema(
      id: 20,
      name: r'mobile',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 21,
      name: r'name',
      type: IsarType.string,
    ),
    r'partnerId': PropertySchema(
      id: 22,
      name: r'partnerId',
      type: IsarType.long,
    ),
    r'partnerName': PropertySchema(
      id: 23,
      name: r'partnerName',
      type: IsarType.string,
    ),
    r'phone': PropertySchema(
      id: 24,
      name: r'phone',
      type: IsarType.string,
    ),
    r'priority': PropertySchema(
      id: 25,
      name: r'priority',
      type: IsarType.string,
    ),
    r'probability': PropertySchema(
      id: 26,
      name: r'probability',
      type: IsarType.double,
    ),
    r'proratedRevenue': PropertySchema(
      id: 27,
      name: r'proratedRevenue',
      type: IsarType.double,
    ),
    r'recurringRevenue': PropertySchema(
      id: 28,
      name: r'recurringRevenue',
      type: IsarType.double,
    ),
    r'recurringRevenueMonthly': PropertySchema(
      id: 29,
      name: r'recurringRevenueMonthly',
      type: IsarType.double,
    ),
    r'recurringRevenueMonthlyProrated': PropertySchema(
      id: 30,
      name: r'recurringRevenueMonthlyProrated',
      type: IsarType.double,
    ),
    r'recurringRevenueProrated': PropertySchema(
      id: 31,
      name: r'recurringRevenueProrated',
      type: IsarType.double,
    ),
    r'searchKey': PropertySchema(
      id: 32,
      name: r'searchKey',
      type: IsarType.string,
    ),
    r'serverId': PropertySchema(
      id: 33,
      name: r'serverId',
      type: IsarType.long,
    ),
    r'stageId': PropertySchema(
      id: 34,
      name: r'stageId',
      type: IsarType.long,
    ),
    r'stageName': PropertySchema(
      id: 35,
      name: r'stageName',
      type: IsarType.string,
    ),
    r'tagIds': PropertySchema(
      id: 36,
      name: r'tagIds',
      type: IsarType.longList,
    ),
    r'teamId': PropertySchema(
      id: 37,
      name: r'teamId',
      type: IsarType.long,
    ),
    r'teamName': PropertySchema(
      id: 38,
      name: r'teamName',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 39,
      name: r'type',
      type: IsarType.string,
    ),
    r'userId': PropertySchema(
      id: 40,
      name: r'userId',
      type: IsarType.long,
    ),
    r'userName': PropertySchema(
      id: 41,
      name: r'userName',
      type: IsarType.string,
    )
  },
  estimateSize: _opportunityModelIsarCacheEstimateSize,
  serialize: _opportunityModelIsarCacheSerialize,
  deserialize: _opportunityModelIsarCacheDeserialize,
  deserializeProp: _opportunityModelIsarCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'searchKey': IndexSchema(
      id: -1673253136872295656,
      name: r'searchKey',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'searchKey',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _opportunityModelIsarCacheGetId,
  getLinks: _opportunityModelIsarCacheGetLinks,
  attach: _opportunityModelIsarCacheAttach,
  version: '3.3.2',
);

int _opportunityModelIsarCacheEstimateSize(
  OpportunityModelIsarCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.activityIds;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.activityState;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.activityTypeName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.activityUserName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.city;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.contactName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.countryName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.emailFrom;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.mobile;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.partnerName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.phone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.priority;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.searchKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.stageName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.tagIds;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.teamName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.type;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.userName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _opportunityModelIsarCacheSerialize(
  OpportunityModelIsarCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.active);
  writer.writeDateTime(offsets[1], object.activityDateDeadline);
  writer.writeLongList(offsets[2], object.activityIds);
  writer.writeString(offsets[3], object.activityState);
  writer.writeLong(offsets[4], object.activityTypeId);
  writer.writeString(offsets[5], object.activityTypeName);
  writer.writeLong(offsets[6], object.activityUserId);
  writer.writeString(offsets[7], object.activityUserName);
  writer.writeString(offsets[8], object.city);
  writer.writeString(offsets[9], object.contactName);
  writer.writeLong(offsets[10], object.countryId);
  writer.writeString(offsets[11], object.countryName);
  writer.writeDateTime(offsets[12], object.createDate);
  writer.writeDateTime(offsets[13], object.dateClosed);
  writer.writeDateTime(offsets[14], object.dateDeadline);
  writer.writeDateTime(offsets[15], object.dateOpen);
  writer.writeDouble(offsets[16], object.dayClose);
  writer.writeString(offsets[17], object.description);
  writer.writeString(offsets[18], object.emailFrom);
  writer.writeDouble(offsets[19], object.expectedRevenue);
  writer.writeString(offsets[20], object.mobile);
  writer.writeString(offsets[21], object.name);
  writer.writeLong(offsets[22], object.partnerId);
  writer.writeString(offsets[23], object.partnerName);
  writer.writeString(offsets[24], object.phone);
  writer.writeString(offsets[25], object.priority);
  writer.writeDouble(offsets[26], object.probability);
  writer.writeDouble(offsets[27], object.proratedRevenue);
  writer.writeDouble(offsets[28], object.recurringRevenue);
  writer.writeDouble(offsets[29], object.recurringRevenueMonthly);
  writer.writeDouble(offsets[30], object.recurringRevenueMonthlyProrated);
  writer.writeDouble(offsets[31], object.recurringRevenueProrated);
  writer.writeString(offsets[32], object.searchKey);
  writer.writeLong(offsets[33], object.serverId);
  writer.writeLong(offsets[34], object.stageId);
  writer.writeString(offsets[35], object.stageName);
  writer.writeLongList(offsets[36], object.tagIds);
  writer.writeLong(offsets[37], object.teamId);
  writer.writeString(offsets[38], object.teamName);
  writer.writeString(offsets[39], object.type);
  writer.writeLong(offsets[40], object.userId);
  writer.writeString(offsets[41], object.userName);
}

OpportunityModelIsarCache _opportunityModelIsarCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OpportunityModelIsarCache();
  object.active = reader.readBoolOrNull(offsets[0]);
  object.activityDateDeadline = reader.readDateTimeOrNull(offsets[1]);
  object.activityIds = reader.readLongList(offsets[2]);
  object.activityState = reader.readStringOrNull(offsets[3]);
  object.activityTypeId = reader.readLongOrNull(offsets[4]);
  object.activityTypeName = reader.readStringOrNull(offsets[5]);
  object.activityUserId = reader.readLongOrNull(offsets[6]);
  object.activityUserName = reader.readStringOrNull(offsets[7]);
  object.city = reader.readStringOrNull(offsets[8]);
  object.contactName = reader.readStringOrNull(offsets[9]);
  object.countryId = reader.readLongOrNull(offsets[10]);
  object.countryName = reader.readStringOrNull(offsets[11]);
  object.createDate = reader.readDateTimeOrNull(offsets[12]);
  object.dateClosed = reader.readDateTimeOrNull(offsets[13]);
  object.dateDeadline = reader.readDateTimeOrNull(offsets[14]);
  object.dateOpen = reader.readDateTimeOrNull(offsets[15]);
  object.dayClose = reader.readDoubleOrNull(offsets[16]);
  object.description = reader.readStringOrNull(offsets[17]);
  object.emailFrom = reader.readStringOrNull(offsets[18]);
  object.expectedRevenue = reader.readDoubleOrNull(offsets[19]);
  object.id = id;
  object.mobile = reader.readStringOrNull(offsets[20]);
  object.name = reader.readStringOrNull(offsets[21]);
  object.partnerId = reader.readLongOrNull(offsets[22]);
  object.partnerName = reader.readStringOrNull(offsets[23]);
  object.phone = reader.readStringOrNull(offsets[24]);
  object.priority = reader.readStringOrNull(offsets[25]);
  object.probability = reader.readDoubleOrNull(offsets[26]);
  object.proratedRevenue = reader.readDoubleOrNull(offsets[27]);
  object.recurringRevenue = reader.readDoubleOrNull(offsets[28]);
  object.recurringRevenueMonthly = reader.readDoubleOrNull(offsets[29]);
  object.recurringRevenueMonthlyProrated = reader.readDoubleOrNull(offsets[30]);
  object.recurringRevenueProrated = reader.readDoubleOrNull(offsets[31]);
  object.searchKey = reader.readStringOrNull(offsets[32]);
  object.serverId = reader.readLongOrNull(offsets[33]);
  object.stageId = reader.readLongOrNull(offsets[34]);
  object.stageName = reader.readStringOrNull(offsets[35]);
  object.tagIds = reader.readLongList(offsets[36]);
  object.teamId = reader.readLongOrNull(offsets[37]);
  object.teamName = reader.readStringOrNull(offsets[38]);
  object.type = reader.readStringOrNull(offsets[39]);
  object.userId = reader.readLongOrNull(offsets[40]);
  object.userName = reader.readStringOrNull(offsets[41]);
  return object;
}

P _opportunityModelIsarCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLongList(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 13:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 14:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 15:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 16:
      return (reader.readDoubleOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readDoubleOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readLongOrNull(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
      return (reader.readDoubleOrNull(offset)) as P;
    case 27:
      return (reader.readDoubleOrNull(offset)) as P;
    case 28:
      return (reader.readDoubleOrNull(offset)) as P;
    case 29:
      return (reader.readDoubleOrNull(offset)) as P;
    case 30:
      return (reader.readDoubleOrNull(offset)) as P;
    case 31:
      return (reader.readDoubleOrNull(offset)) as P;
    case 32:
      return (reader.readStringOrNull(offset)) as P;
    case 33:
      return (reader.readLongOrNull(offset)) as P;
    case 34:
      return (reader.readLongOrNull(offset)) as P;
    case 35:
      return (reader.readStringOrNull(offset)) as P;
    case 36:
      return (reader.readLongList(offset)) as P;
    case 37:
      return (reader.readLongOrNull(offset)) as P;
    case 38:
      return (reader.readStringOrNull(offset)) as P;
    case 39:
      return (reader.readStringOrNull(offset)) as P;
    case 40:
      return (reader.readLongOrNull(offset)) as P;
    case 41:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _opportunityModelIsarCacheGetId(OpportunityModelIsarCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _opportunityModelIsarCacheGetLinks(
    OpportunityModelIsarCache object) {
  return [];
}

void _opportunityModelIsarCacheAttach(
    IsarCollection<dynamic> col, Id id, OpportunityModelIsarCache object) {
  object.id = id;
}

extension OpportunityModelIsarCacheQueryWhereSort on QueryBuilder<
    OpportunityModelIsarCache, OpportunityModelIsarCache, QWhere> {
  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterWhere> anySearchKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'searchKey'),
      );
    });
  }
}

extension OpportunityModelIsarCacheQueryWhere on QueryBuilder<
    OpportunityModelIsarCache, OpportunityModelIsarCache, QWhereClause> {
  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterWhereClause> idBetween(
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

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterWhereClause> searchKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'searchKey',
        value: [null],
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterWhereClause> searchKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'searchKey',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterWhereClause> searchKeyEqualTo(String? searchKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'searchKey',
        value: [searchKey],
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterWhereClause> searchKeyNotEqualTo(String? searchKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchKey',
              lower: [],
              upper: [searchKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchKey',
              lower: [searchKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchKey',
              lower: [searchKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchKey',
              lower: [],
              upper: [searchKey],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterWhereClause> searchKeyGreaterThan(
    String? searchKey, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'searchKey',
        lower: [searchKey],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterWhereClause> searchKeyLessThan(
    String? searchKey, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'searchKey',
        lower: [],
        upper: [searchKey],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterWhereClause> searchKeyBetween(
    String? lowerSearchKey,
    String? upperSearchKey, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'searchKey',
        lower: [lowerSearchKey],
        includeLower: includeLower,
        upper: [upperSearchKey],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterWhereClause> searchKeyStartsWith(String SearchKeyPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'searchKey',
        lower: [SearchKeyPrefix],
        upper: ['$SearchKeyPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterWhereClause> searchKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'searchKey',
        value: [''],
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterWhereClause> searchKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'searchKey',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'searchKey',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'searchKey',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'searchKey',
              upper: [''],
            ));
      }
    });
  }
}

extension OpportunityModelIsarCacheQueryFilter on QueryBuilder<
    OpportunityModelIsarCache, OpportunityModelIsarCache, QFilterCondition> {
  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'active',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'active',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activeEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'active',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityDateDeadlineIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityDateDeadline',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityDateDeadlineIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityDateDeadline',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityDateDeadlineEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityDateDeadline',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityDateDeadlineGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityDateDeadline',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityDateDeadlineLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityDateDeadline',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityDateDeadlineBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityDateDeadline',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityIds',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityIds',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityIds',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityIds',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityIds',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activityIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activityIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activityIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activityIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activityIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activityIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityStateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityState',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityStateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityState',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityStateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityStateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityStateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityStateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityState',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityStateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activityState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityStateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activityState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      activityStateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activityState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      activityStateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activityState',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityStateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityState',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityStateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityState',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityTypeIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityTypeId',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityTypeIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityTypeId',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityTypeIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityTypeId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityTypeIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityTypeId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityTypeIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityTypeId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityTypeIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityTypeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityTypeNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityTypeName',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityTypeNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityTypeName',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityTypeNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityTypeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityTypeNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityTypeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityTypeNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityTypeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityTypeNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityTypeName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityTypeNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activityTypeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityTypeNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activityTypeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      activityTypeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activityTypeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      activityTypeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activityTypeName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityTypeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityTypeName',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityTypeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityTypeName',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityUserIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityUserId',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityUserIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityUserId',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityUserIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityUserId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityUserIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityUserId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityUserIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityUserId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityUserIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityUserId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityUserNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityUserName',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityUserNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityUserName',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityUserNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityUserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityUserNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityUserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityUserNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityUserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityUserNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityUserName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityUserNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activityUserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityUserNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activityUserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      activityUserNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activityUserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      activityUserNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activityUserName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityUserNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityUserName',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> activityUserNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityUserName',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> cityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'city',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> cityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'city',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> cityEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> cityGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> cityLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> cityBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'city',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> cityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> cityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      cityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      cityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'city',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> cityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> cityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> contactNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'contactName',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> contactNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'contactName',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> contactNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contactName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> contactNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contactName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> contactNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contactName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> contactNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contactName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> contactNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contactName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> contactNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contactName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      contactNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contactName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      contactNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contactName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> contactNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contactName',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> contactNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contactName',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> countryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'countryId',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> countryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'countryId',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> countryIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'countryId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> countryIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'countryId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> countryIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'countryId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> countryIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'countryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> countryNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'countryName',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> countryNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'countryName',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> countryNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'countryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> countryNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'countryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> countryNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'countryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> countryNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'countryName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> countryNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'countryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> countryNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'countryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      countryNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'countryName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      countryNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'countryName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> countryNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'countryName',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> countryNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'countryName',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> createDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createDate',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> createDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createDate',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> createDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createDate',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> createDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createDate',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> createDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createDate',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> createDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dateClosedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateClosed',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dateClosedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateClosed',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dateClosedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateClosed',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dateClosedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateClosed',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dateClosedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateClosed',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dateClosedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateClosed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dateDeadlineIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateDeadline',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dateDeadlineIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateDeadline',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dateDeadlineEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateDeadline',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dateDeadlineGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateDeadline',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dateDeadlineLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateDeadline',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dateDeadlineBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateDeadline',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dateOpenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateOpen',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dateOpenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateOpen',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dateOpenEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateOpen',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dateOpenGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateOpen',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dateOpenLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateOpen',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dateOpenBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateOpen',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dayCloseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dayClose',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dayCloseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dayClose',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dayCloseEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayClose',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dayCloseGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayClose',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dayCloseLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayClose',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> dayCloseBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayClose',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> emailFromIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'emailFrom',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> emailFromIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'emailFrom',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> emailFromEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emailFrom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> emailFromGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'emailFrom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> emailFromLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'emailFrom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> emailFromBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'emailFrom',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> emailFromStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'emailFrom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> emailFromEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'emailFrom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      emailFromContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'emailFrom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      emailFromMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'emailFrom',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> emailFromIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emailFrom',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> emailFromIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'emailFrom',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> expectedRevenueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expectedRevenue',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> expectedRevenueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expectedRevenue',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> expectedRevenueEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expectedRevenue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> expectedRevenueGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expectedRevenue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> expectedRevenueLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expectedRevenue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> expectedRevenueBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expectedRevenue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> mobileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mobile',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> mobileIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mobile',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> mobileEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mobile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> mobileGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mobile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> mobileLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mobile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> mobileBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mobile',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> mobileStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mobile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> mobileEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mobile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      mobileContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mobile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      mobileMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mobile',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> mobileIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mobile',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> mobileIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mobile',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> nameBetween(
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

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> partnerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'partnerId',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> partnerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'partnerId',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> partnerIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partnerId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> partnerIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partnerId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> partnerIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partnerId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> partnerIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partnerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> partnerNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'partnerName',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> partnerNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'partnerName',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> partnerNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> partnerNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> partnerNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> partnerNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partnerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> partnerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'partnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> partnerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'partnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      partnerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'partnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      partnerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'partnerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> partnerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partnerName',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> partnerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'partnerName',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> phoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phone',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> phoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phone',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> phoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> phoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> phoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> phoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> phoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> phoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      phoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      phoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> priorityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'priority',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> priorityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'priority',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> priorityEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> priorityGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> priorityLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> priorityBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> priorityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> priorityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      priorityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'priority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      priorityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'priority',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> priorityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> priorityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'priority',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> probabilityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'probability',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> probabilityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'probability',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> probabilityEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'probability',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> probabilityGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'probability',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> probabilityLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'probability',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> probabilityBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'probability',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> proratedRevenueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'proratedRevenue',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> proratedRevenueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'proratedRevenue',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> proratedRevenueEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proratedRevenue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> proratedRevenueGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'proratedRevenue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> proratedRevenueLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'proratedRevenue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> proratedRevenueBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'proratedRevenue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurringRevenue',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurringRevenue',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurringRevenue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurringRevenue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurringRevenue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurringRevenue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueMonthlyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurringRevenueMonthly',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueMonthlyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurringRevenueMonthly',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueMonthlyEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurringRevenueMonthly',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueMonthlyGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurringRevenueMonthly',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueMonthlyLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurringRevenueMonthly',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueMonthlyBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurringRevenueMonthly',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueMonthlyProratedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurringRevenueMonthlyProrated',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueMonthlyProratedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurringRevenueMonthlyProrated',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueMonthlyProratedEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurringRevenueMonthlyProrated',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueMonthlyProratedGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurringRevenueMonthlyProrated',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueMonthlyProratedLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurringRevenueMonthlyProrated',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueMonthlyProratedBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurringRevenueMonthlyProrated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueProratedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurringRevenueProrated',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueProratedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurringRevenueProrated',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueProratedEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurringRevenueProrated',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueProratedGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurringRevenueProrated',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueProratedLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurringRevenueProrated',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> recurringRevenueProratedBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurringRevenueProrated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> searchKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'searchKey',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> searchKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'searchKey',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> searchKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'searchKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> searchKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'searchKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> searchKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'searchKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> searchKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'searchKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> searchKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'searchKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> searchKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'searchKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      searchKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'searchKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      searchKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'searchKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> searchKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'searchKey',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> searchKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'searchKey',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> serverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> serverIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> serverIdGreaterThan(
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

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> serverIdLessThan(
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

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> serverIdBetween(
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

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> stageIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stageId',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> stageIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stageId',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> stageIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stageId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> stageIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stageId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> stageIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stageId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> stageIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stageId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> stageNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stageName',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> stageNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stageName',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> stageNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> stageNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> stageNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> stageNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stageName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> stageNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'stageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> stageNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'stageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      stageNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      stageNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stageName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> stageNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stageName',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> stageNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stageName',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> tagIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tagIds',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> tagIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tagIds',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> tagIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tagIds',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> tagIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tagIds',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> tagIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tagIds',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> tagIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tagIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> tagIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tagIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> tagIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tagIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> tagIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tagIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> tagIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tagIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> tagIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tagIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> tagIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tagIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> teamIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'teamId',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> teamIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'teamId',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> teamIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teamId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> teamIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'teamId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> teamIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'teamId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> teamIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'teamId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> teamNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'teamName',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> teamNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'teamName',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> teamNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teamName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> teamNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'teamName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> teamNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'teamName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> teamNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'teamName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> teamNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'teamName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> teamNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'teamName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      teamNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'teamName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      teamNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'teamName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> teamNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teamName',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> teamNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'teamName',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> typeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> typeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> typeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> typeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> userIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> userIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> userIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> userIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> userNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userName',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> userNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userName',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> userNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> userNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> userNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> userNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> userNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> userNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      userNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
          QAfterFilterCondition>
      userNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> userNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userName',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterFilterCondition> userNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userName',
        value: '',
      ));
    });
  }
}

extension OpportunityModelIsarCacheQueryObject on QueryBuilder<
    OpportunityModelIsarCache, OpportunityModelIsarCache, QFilterCondition> {}

extension OpportunityModelIsarCacheQueryLinks on QueryBuilder<
    OpportunityModelIsarCache, OpportunityModelIsarCache, QFilterCondition> {}

extension OpportunityModelIsarCacheQuerySortBy on QueryBuilder<
    OpportunityModelIsarCache, OpportunityModelIsarCache, QSortBy> {
  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByActivityDateDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityDateDeadline', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByActivityDateDeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityDateDeadline', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByActivityState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityState', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByActivityStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityState', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByActivityTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeId', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByActivityTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeId', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByActivityTypeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeName', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByActivityTypeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeName', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByActivityUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserId', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByActivityUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserId', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByActivityUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserName', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByActivityUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserName', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByContactName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactName', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByContactNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactName', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByCountryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByCountryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByCountryName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryName', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByCountryNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryName', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByCreateDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createDate', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByCreateDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createDate', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByDateClosed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateClosed', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByDateClosedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateClosed', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByDateDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDeadline', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByDateDeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDeadline', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByDateOpen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOpen', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByDateOpenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOpen', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByDayClose() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayClose', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByDayCloseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayClose', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByEmailFrom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emailFrom', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByEmailFromDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emailFrom', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByExpectedRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedRevenue', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByExpectedRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedRevenue', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByMobile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobile', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByMobileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobile', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByPartnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerId', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByPartnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerId', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByPartnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByPartnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByProbability() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probability', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByProbabilityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probability', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByProratedRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proratedRevenue', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByProratedRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proratedRevenue', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByRecurringRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenue', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByRecurringRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenue', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByRecurringRevenueMonthly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthly', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByRecurringRevenueMonthlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthly', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByRecurringRevenueMonthlyProrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthlyProrated', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByRecurringRevenueMonthlyProratedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthlyProrated', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByRecurringRevenueProrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueProrated', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByRecurringRevenueProratedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueProrated', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortBySearchKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchKey', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortBySearchKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchKey', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByStageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageId', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByStageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageId', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByStageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageName', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByStageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageName', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByTeamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamId', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByTeamIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamId', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByTeamName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamName', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByTeamNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamName', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> sortByUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.desc);
    });
  }
}

extension OpportunityModelIsarCacheQuerySortThenBy on QueryBuilder<
    OpportunityModelIsarCache, OpportunityModelIsarCache, QSortThenBy> {
  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByActivityDateDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityDateDeadline', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByActivityDateDeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityDateDeadline', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByActivityState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityState', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByActivityStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityState', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByActivityTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeId', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByActivityTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeId', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByActivityTypeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeName', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByActivityTypeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeName', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByActivityUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserId', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByActivityUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserId', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByActivityUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserName', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByActivityUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserName', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByContactName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactName', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByContactNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactName', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByCountryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByCountryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByCountryName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryName', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByCountryNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryName', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByCreateDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createDate', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByCreateDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createDate', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByDateClosed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateClosed', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByDateClosedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateClosed', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByDateDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDeadline', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByDateDeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDeadline', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByDateOpen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOpen', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByDateOpenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOpen', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByDayClose() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayClose', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByDayCloseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayClose', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByEmailFrom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emailFrom', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByEmailFromDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emailFrom', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByExpectedRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedRevenue', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByExpectedRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedRevenue', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByMobile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobile', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByMobileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobile', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByPartnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerId', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByPartnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerId', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByPartnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByPartnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByProbability() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probability', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByProbabilityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probability', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByProratedRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proratedRevenue', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByProratedRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proratedRevenue', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByRecurringRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenue', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByRecurringRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenue', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByRecurringRevenueMonthly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthly', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByRecurringRevenueMonthlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthly', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByRecurringRevenueMonthlyProrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthlyProrated', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByRecurringRevenueMonthlyProratedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthlyProrated', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByRecurringRevenueProrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueProrated', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByRecurringRevenueProratedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueProrated', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenBySearchKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchKey', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenBySearchKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchKey', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByStageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageId', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByStageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageId', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByStageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageName', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByStageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageName', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByTeamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamId', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByTeamIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamId', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByTeamName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamName', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByTeamNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamName', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache,
      QAfterSortBy> thenByUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.desc);
    });
  }
}

extension OpportunityModelIsarCacheQueryWhereDistinct on QueryBuilder<
    OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct> {
  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'active');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByActivityDateDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityDateDeadline');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByActivityIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityIds');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByActivityState({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityState',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByActivityTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityTypeId');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByActivityTypeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityTypeName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByActivityUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityUserId');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByActivityUserName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityUserName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByCity({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'city', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByContactName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contactName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByCountryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'countryId');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByCountryName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'countryName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByCreateDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createDate');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByDateClosed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateClosed');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByDateDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateDeadline');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByDateOpen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateOpen');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByDayClose() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayClose');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByEmailFrom({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emailFrom', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByExpectedRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expectedRevenue');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByMobile({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mobile', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByPartnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partnerId');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByPartnerName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partnerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByPriority({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priority', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByProbability() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'probability');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByProratedRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proratedRevenue');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByRecurringRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurringRevenue');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByRecurringRevenueMonthly() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurringRevenueMonthly');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByRecurringRevenueMonthlyProrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurringRevenueMonthlyProrated');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByRecurringRevenueProrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurringRevenueProrated');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctBySearchKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'searchKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByStageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stageId');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByStageName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stageName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByTagIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tagIds');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByTeamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'teamId');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByTeamName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'teamName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, OpportunityModelIsarCache, QDistinct>
      distinctByUserName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userName', caseSensitive: caseSensitive);
    });
  }
}

extension OpportunityModelIsarCacheQueryProperty on QueryBuilder<
    OpportunityModelIsarCache, OpportunityModelIsarCache, QQueryProperty> {
  QueryBuilder<OpportunityModelIsarCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, bool?, QQueryOperations>
      activeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'active');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, DateTime?, QQueryOperations>
      activityDateDeadlineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityDateDeadline');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, List<int>?, QQueryOperations>
      activityIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityIds');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, String?, QQueryOperations>
      activityStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityState');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, int?, QQueryOperations>
      activityTypeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityTypeId');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, String?, QQueryOperations>
      activityTypeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityTypeName');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, int?, QQueryOperations>
      activityUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityUserId');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, String?, QQueryOperations>
      activityUserNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityUserName');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, String?, QQueryOperations>
      cityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'city');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, String?, QQueryOperations>
      contactNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contactName');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, int?, QQueryOperations>
      countryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'countryId');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, String?, QQueryOperations>
      countryNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'countryName');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, DateTime?, QQueryOperations>
      createDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createDate');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, DateTime?, QQueryOperations>
      dateClosedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateClosed');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, DateTime?, QQueryOperations>
      dateDeadlineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateDeadline');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, DateTime?, QQueryOperations>
      dateOpenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateOpen');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, double?, QQueryOperations>
      dayCloseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayClose');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, String?, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, String?, QQueryOperations>
      emailFromProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emailFrom');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, double?, QQueryOperations>
      expectedRevenueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expectedRevenue');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, String?, QQueryOperations>
      mobileProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mobile');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, String?, QQueryOperations>
      nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, int?, QQueryOperations>
      partnerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partnerId');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, String?, QQueryOperations>
      partnerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partnerName');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, String?, QQueryOperations>
      phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, String?, QQueryOperations>
      priorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priority');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, double?, QQueryOperations>
      probabilityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'probability');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, double?, QQueryOperations>
      proratedRevenueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proratedRevenue');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, double?, QQueryOperations>
      recurringRevenueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurringRevenue');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, double?, QQueryOperations>
      recurringRevenueMonthlyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurringRevenueMonthly');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, double?, QQueryOperations>
      recurringRevenueMonthlyProratedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurringRevenueMonthlyProrated');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, double?, QQueryOperations>
      recurringRevenueProratedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurringRevenueProrated');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, String?, QQueryOperations>
      searchKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'searchKey');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, int?, QQueryOperations>
      serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, int?, QQueryOperations>
      stageIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stageId');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, String?, QQueryOperations>
      stageNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stageName');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, List<int>?, QQueryOperations>
      tagIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tagIds');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, int?, QQueryOperations>
      teamIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'teamId');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, String?, QQueryOperations>
      teamNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'teamName');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, String?, QQueryOperations>
      typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, int?, QQueryOperations>
      userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<OpportunityModelIsarCache, String?, QQueryOperations>
      userNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userName');
    });
  }
}
