// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_order_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSaleOrderIsarCacheCollection on Isar {
  IsarCollection<SaleOrderIsarCache> get saleOrderIsarCaches =>
      this.collection();
}

const SaleOrderIsarCacheSchema = CollectionSchema(
  name: r'SaleOrderIsarCache',
  id: -7896808900310324240,
  properties: {
    r'amountTax': PropertySchema(
      id: 0,
      name: r'amountTax',
      type: IsarType.double,
    ),
    r'amountTotal': PropertySchema(
      id: 1,
      name: r'amountTotal',
      type: IsarType.double,
    ),
    r'amountUntaxed': PropertySchema(
      id: 2,
      name: r'amountUntaxed',
      type: IsarType.double,
    ),
    r'campaignId': PropertySchema(
      id: 3,
      name: r'campaignId',
      type: IsarType.long,
    ),
    r'campaignName': PropertySchema(
      id: 4,
      name: r'campaignName',
      type: IsarType.string,
    ),
    r'clientOrderRef': PropertySchema(
      id: 5,
      name: r'clientOrderRef',
      type: IsarType.string,
    ),
    r'commitmentDate': PropertySchema(
      id: 6,
      name: r'commitmentDate',
      type: IsarType.string,
    ),
    r'companyId': PropertySchema(
      id: 7,
      name: r'companyId',
      type: IsarType.long,
    ),
    r'companyName': PropertySchema(
      id: 8,
      name: r'companyName',
      type: IsarType.string,
    ),
    r'currencyId': PropertySchema(
      id: 9,
      name: r'currencyId',
      type: IsarType.long,
    ),
    r'currencySymbol': PropertySchema(
      id: 10,
      name: r'currencySymbol',
      type: IsarType.string,
    ),
    r'customerAddress': PropertySchema(
      id: 11,
      name: r'customerAddress',
      type: IsarType.string,
    ),
    r'dateOrder': PropertySchema(
      id: 12,
      name: r'dateOrder',
      type: IsarType.string,
    ),
    r'fiscalPositionId': PropertySchema(
      id: 13,
      name: r'fiscalPositionId',
      type: IsarType.long,
    ),
    r'fiscalPositionName': PropertySchema(
      id: 14,
      name: r'fiscalPositionName',
      type: IsarType.string,
    ),
    r'invoiceIds': PropertySchema(
      id: 15,
      name: r'invoiceIds',
      type: IsarType.longList,
    ),
    r'invoiceStatus': PropertySchema(
      id: 16,
      name: r'invoiceStatus',
      type: IsarType.string,
    ),
    r'journalId': PropertySchema(
      id: 17,
      name: r'journalId',
      type: IsarType.long,
    ),
    r'journalName': PropertySchema(
      id: 18,
      name: r'journalName',
      type: IsarType.string,
    ),
    r'mediumId': PropertySchema(
      id: 19,
      name: r'mediumId',
      type: IsarType.long,
    ),
    r'mediumName': PropertySchema(
      id: 20,
      name: r'mediumName',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 21,
      name: r'name',
      type: IsarType.string,
    ),
    r'opportunityId': PropertySchema(
      id: 22,
      name: r'opportunityId',
      type: IsarType.long,
    ),
    r'origin': PropertySchema(
      id: 23,
      name: r'origin',
      type: IsarType.string,
    ),
    r'partnerId': PropertySchema(
      id: 24,
      name: r'partnerId',
      type: IsarType.long,
    ),
    r'partnerName': PropertySchema(
      id: 25,
      name: r'partnerName',
      type: IsarType.string,
    ),
    r'paymentTermId': PropertySchema(
      id: 26,
      name: r'paymentTermId',
      type: IsarType.long,
    ),
    r'paymentTermName': PropertySchema(
      id: 27,
      name: r'paymentTermName',
      type: IsarType.string,
    ),
    r'requirePayment': PropertySchema(
      id: 28,
      name: r'requirePayment',
      type: IsarType.bool,
    ),
    r'requireSignature': PropertySchema(
      id: 29,
      name: r'requireSignature',
      type: IsarType.bool,
    ),
    r'saleOrderTemplateId': PropertySchema(
      id: 30,
      name: r'saleOrderTemplateId',
      type: IsarType.long,
    ),
    r'saleOrderTemplateName': PropertySchema(
      id: 31,
      name: r'saleOrderTemplateName',
      type: IsarType.string,
    ),
    r'searchServerId': PropertySchema(
      id: 32,
      name: r'searchServerId',
      type: IsarType.long,
    ),
    r'serverId': PropertySchema(
      id: 33,
      name: r'serverId',
      type: IsarType.long,
    ),
    r'signature': PropertySchema(
      id: 34,
      name: r'signature',
      type: IsarType.string,
    ),
    r'signedBy': PropertySchema(
      id: 35,
      name: r'signedBy',
      type: IsarType.string,
    ),
    r'signedOn': PropertySchema(
      id: 36,
      name: r'signedOn',
      type: IsarType.string,
    ),
    r'sourceId': PropertySchema(
      id: 37,
      name: r'sourceId',
      type: IsarType.long,
    ),
    r'sourceName': PropertySchema(
      id: 38,
      name: r'sourceName',
      type: IsarType.string,
    ),
    r'state': PropertySchema(
      id: 39,
      name: r'state',
      type: IsarType.string,
    ),
    r'tagIds': PropertySchema(
      id: 40,
      name: r'tagIds',
      type: IsarType.longList,
    ),
    r'teamId': PropertySchema(
      id: 41,
      name: r'teamId',
      type: IsarType.long,
    ),
    r'userId': PropertySchema(
      id: 42,
      name: r'userId',
      type: IsarType.long,
    ),
    r'userName': PropertySchema(
      id: 43,
      name: r'userName',
      type: IsarType.string,
    ),
    r'validityDate': PropertySchema(
      id: 44,
      name: r'validityDate',
      type: IsarType.string,
    )
  },
  estimateSize: _saleOrderIsarCacheEstimateSize,
  serialize: _saleOrderIsarCacheSerialize,
  deserialize: _saleOrderIsarCacheDeserialize,
  deserializeProp: _saleOrderIsarCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'searchServerId': IndexSchema(
      id: 2848286709443419921,
      name: r'searchServerId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'searchServerId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _saleOrderIsarCacheGetId,
  getLinks: _saleOrderIsarCacheGetLinks,
  attach: _saleOrderIsarCacheAttach,
  version: '3.3.2',
);

int _saleOrderIsarCacheEstimateSize(
  SaleOrderIsarCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.campaignName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.clientOrderRef;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.commitmentDate;
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
    final value = object.currencySymbol;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.customerAddress;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.dateOrder;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.fiscalPositionName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.invoiceIds;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.invoiceStatus;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.journalName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.mediumName;
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
    final value = object.origin;
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
    final value = object.paymentTermName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.saleOrderTemplateName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.signature;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.signedBy;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.signedOn;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.sourceName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.state;
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
    final value = object.userName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.validityDate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _saleOrderIsarCacheSerialize(
  SaleOrderIsarCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amountTax);
  writer.writeDouble(offsets[1], object.amountTotal);
  writer.writeDouble(offsets[2], object.amountUntaxed);
  writer.writeLong(offsets[3], object.campaignId);
  writer.writeString(offsets[4], object.campaignName);
  writer.writeString(offsets[5], object.clientOrderRef);
  writer.writeString(offsets[6], object.commitmentDate);
  writer.writeLong(offsets[7], object.companyId);
  writer.writeString(offsets[8], object.companyName);
  writer.writeLong(offsets[9], object.currencyId);
  writer.writeString(offsets[10], object.currencySymbol);
  writer.writeString(offsets[11], object.customerAddress);
  writer.writeString(offsets[12], object.dateOrder);
  writer.writeLong(offsets[13], object.fiscalPositionId);
  writer.writeString(offsets[14], object.fiscalPositionName);
  writer.writeLongList(offsets[15], object.invoiceIds);
  writer.writeString(offsets[16], object.invoiceStatus);
  writer.writeLong(offsets[17], object.journalId);
  writer.writeString(offsets[18], object.journalName);
  writer.writeLong(offsets[19], object.mediumId);
  writer.writeString(offsets[20], object.mediumName);
  writer.writeString(offsets[21], object.name);
  writer.writeLong(offsets[22], object.opportunityId);
  writer.writeString(offsets[23], object.origin);
  writer.writeLong(offsets[24], object.partnerId);
  writer.writeString(offsets[25], object.partnerName);
  writer.writeLong(offsets[26], object.paymentTermId);
  writer.writeString(offsets[27], object.paymentTermName);
  writer.writeBool(offsets[28], object.requirePayment);
  writer.writeBool(offsets[29], object.requireSignature);
  writer.writeLong(offsets[30], object.saleOrderTemplateId);
  writer.writeString(offsets[31], object.saleOrderTemplateName);
  writer.writeLong(offsets[32], object.searchServerId);
  writer.writeLong(offsets[33], object.serverId);
  writer.writeString(offsets[34], object.signature);
  writer.writeString(offsets[35], object.signedBy);
  writer.writeString(offsets[36], object.signedOn);
  writer.writeLong(offsets[37], object.sourceId);
  writer.writeString(offsets[38], object.sourceName);
  writer.writeString(offsets[39], object.state);
  writer.writeLongList(offsets[40], object.tagIds);
  writer.writeLong(offsets[41], object.teamId);
  writer.writeLong(offsets[42], object.userId);
  writer.writeString(offsets[43], object.userName);
  writer.writeString(offsets[44], object.validityDate);
}

SaleOrderIsarCache _saleOrderIsarCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SaleOrderIsarCache();
  object.amountTax = reader.readDoubleOrNull(offsets[0]);
  object.amountTotal = reader.readDoubleOrNull(offsets[1]);
  object.amountUntaxed = reader.readDoubleOrNull(offsets[2]);
  object.campaignId = reader.readLongOrNull(offsets[3]);
  object.campaignName = reader.readStringOrNull(offsets[4]);
  object.clientOrderRef = reader.readStringOrNull(offsets[5]);
  object.commitmentDate = reader.readStringOrNull(offsets[6]);
  object.companyId = reader.readLongOrNull(offsets[7]);
  object.companyName = reader.readStringOrNull(offsets[8]);
  object.currencyId = reader.readLongOrNull(offsets[9]);
  object.currencySymbol = reader.readStringOrNull(offsets[10]);
  object.customerAddress = reader.readStringOrNull(offsets[11]);
  object.dateOrder = reader.readStringOrNull(offsets[12]);
  object.fiscalPositionId = reader.readLongOrNull(offsets[13]);
  object.fiscalPositionName = reader.readStringOrNull(offsets[14]);
  object.id = id;
  object.invoiceIds = reader.readLongList(offsets[15]);
  object.invoiceStatus = reader.readStringOrNull(offsets[16]);
  object.journalId = reader.readLongOrNull(offsets[17]);
  object.journalName = reader.readStringOrNull(offsets[18]);
  object.mediumId = reader.readLongOrNull(offsets[19]);
  object.mediumName = reader.readStringOrNull(offsets[20]);
  object.name = reader.readStringOrNull(offsets[21]);
  object.opportunityId = reader.readLongOrNull(offsets[22]);
  object.origin = reader.readStringOrNull(offsets[23]);
  object.partnerId = reader.readLongOrNull(offsets[24]);
  object.partnerName = reader.readStringOrNull(offsets[25]);
  object.paymentTermId = reader.readLongOrNull(offsets[26]);
  object.paymentTermName = reader.readStringOrNull(offsets[27]);
  object.requirePayment = reader.readBoolOrNull(offsets[28]);
  object.requireSignature = reader.readBoolOrNull(offsets[29]);
  object.saleOrderTemplateId = reader.readLongOrNull(offsets[30]);
  object.saleOrderTemplateName = reader.readStringOrNull(offsets[31]);
  object.searchServerId = reader.readLongOrNull(offsets[32]);
  object.serverId = reader.readLongOrNull(offsets[33]);
  object.signature = reader.readStringOrNull(offsets[34]);
  object.signedBy = reader.readStringOrNull(offsets[35]);
  object.signedOn = reader.readStringOrNull(offsets[36]);
  object.sourceId = reader.readLongOrNull(offsets[37]);
  object.sourceName = reader.readStringOrNull(offsets[38]);
  object.state = reader.readStringOrNull(offsets[39]);
  object.tagIds = reader.readLongList(offsets[40]);
  object.teamId = reader.readLongOrNull(offsets[41]);
  object.userId = reader.readLongOrNull(offsets[42]);
  object.userName = reader.readStringOrNull(offsets[43]);
  object.validityDate = reader.readStringOrNull(offsets[44]);
  return object;
}

P _saleOrderIsarCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readLongOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readLongList(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readLongOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readLongOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readLongOrNull(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readLongOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
      return (reader.readLongOrNull(offset)) as P;
    case 27:
      return (reader.readStringOrNull(offset)) as P;
    case 28:
      return (reader.readBoolOrNull(offset)) as P;
    case 29:
      return (reader.readBoolOrNull(offset)) as P;
    case 30:
      return (reader.readLongOrNull(offset)) as P;
    case 31:
      return (reader.readStringOrNull(offset)) as P;
    case 32:
      return (reader.readLongOrNull(offset)) as P;
    case 33:
      return (reader.readLongOrNull(offset)) as P;
    case 34:
      return (reader.readStringOrNull(offset)) as P;
    case 35:
      return (reader.readStringOrNull(offset)) as P;
    case 36:
      return (reader.readStringOrNull(offset)) as P;
    case 37:
      return (reader.readLongOrNull(offset)) as P;
    case 38:
      return (reader.readStringOrNull(offset)) as P;
    case 39:
      return (reader.readStringOrNull(offset)) as P;
    case 40:
      return (reader.readLongList(offset)) as P;
    case 41:
      return (reader.readLongOrNull(offset)) as P;
    case 42:
      return (reader.readLongOrNull(offset)) as P;
    case 43:
      return (reader.readStringOrNull(offset)) as P;
    case 44:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _saleOrderIsarCacheGetId(SaleOrderIsarCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _saleOrderIsarCacheGetLinks(
    SaleOrderIsarCache object) {
  return [];
}

void _saleOrderIsarCacheAttach(
    IsarCollection<dynamic> col, Id id, SaleOrderIsarCache object) {
  object.id = id;
}

extension SaleOrderIsarCacheQueryWhereSort
    on QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QWhere> {
  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterWhere>
      anySearchServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'searchServerId'),
      );
    });
  }
}

extension SaleOrderIsarCacheQueryWhere
    on QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QWhereClause> {
  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterWhereClause>
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterWhereClause>
      searchServerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'searchServerId',
        value: [null],
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterWhereClause>
      searchServerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'searchServerId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterWhereClause>
      searchServerIdEqualTo(int? searchServerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'searchServerId',
        value: [searchServerId],
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterWhereClause>
      searchServerIdNotEqualTo(int? searchServerId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchServerId',
              lower: [],
              upper: [searchServerId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchServerId',
              lower: [searchServerId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchServerId',
              lower: [searchServerId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchServerId',
              lower: [],
              upper: [searchServerId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterWhereClause>
      searchServerIdGreaterThan(
    int? searchServerId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'searchServerId',
        lower: [searchServerId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterWhereClause>
      searchServerIdLessThan(
    int? searchServerId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'searchServerId',
        lower: [],
        upper: [searchServerId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterWhereClause>
      searchServerIdBetween(
    int? lowerSearchServerId,
    int? upperSearchServerId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'searchServerId',
        lower: [lowerSearchServerId],
        includeLower: includeLower,
        upper: [upperSearchServerId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SaleOrderIsarCacheQueryFilter
    on QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QFilterCondition> {
  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      amountTaxIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'amountTax',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      amountTaxIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'amountTax',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      amountTaxEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amountTax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      amountTaxGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amountTax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      amountTaxLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amountTax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      amountTaxBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amountTax',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      amountTotalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'amountTotal',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      amountTotalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'amountTotal',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      amountTotalEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amountTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      amountTotalGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amountTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      amountTotalLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amountTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      amountTotalBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amountTotal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      amountUntaxedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'amountUntaxed',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      amountUntaxedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'amountUntaxed',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      amountUntaxedEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amountUntaxed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      amountUntaxedGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amountUntaxed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      amountUntaxedLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amountUntaxed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      amountUntaxedBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amountUntaxed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      campaignIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'campaignId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      campaignIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'campaignId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      campaignIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'campaignId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      campaignIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'campaignId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      campaignIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'campaignId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      campaignIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'campaignId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      campaignNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'campaignName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      campaignNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'campaignName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      campaignNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'campaignName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      campaignNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'campaignName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      campaignNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'campaignName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      campaignNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'campaignName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      campaignNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'campaignName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      campaignNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'campaignName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      campaignNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'campaignName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      campaignNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'campaignName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      campaignNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'campaignName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      campaignNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'campaignName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      clientOrderRefIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'clientOrderRef',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      clientOrderRefIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'clientOrderRef',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      clientOrderRefEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientOrderRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      clientOrderRefGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clientOrderRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      clientOrderRefLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clientOrderRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      clientOrderRefBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clientOrderRef',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      clientOrderRefStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'clientOrderRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      clientOrderRefEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'clientOrderRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      clientOrderRefContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'clientOrderRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      clientOrderRefMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'clientOrderRef',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      clientOrderRefIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientOrderRef',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      clientOrderRefIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'clientOrderRef',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      commitmentDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'commitmentDate',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      commitmentDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'commitmentDate',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      commitmentDateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commitmentDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      commitmentDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'commitmentDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      commitmentDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'commitmentDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      commitmentDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'commitmentDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      commitmentDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'commitmentDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      commitmentDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'commitmentDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      commitmentDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'commitmentDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      commitmentDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'commitmentDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      commitmentDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commitmentDate',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      commitmentDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'commitmentDate',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      companyIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'companyId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      companyIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'companyId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      companyIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'companyId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      companyIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'companyId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      companyIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'companyId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      companyIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'companyId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      companyNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'companyName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      companyNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'companyName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      companyNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'companyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      companyNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'companyName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      companyNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'companyName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      companyNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'companyName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      currencyIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currencyId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      currencyIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currencyId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      currencyIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currencyId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      currencyIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currencyId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      currencyIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currencyId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      currencyIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currencyId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      currencySymbolIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currencySymbol',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      currencySymbolIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currencySymbol',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      currencySymbolEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currencySymbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      currencySymbolGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currencySymbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      currencySymbolLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currencySymbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      currencySymbolBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currencySymbol',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      currencySymbolStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currencySymbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      currencySymbolEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currencySymbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      currencySymbolContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currencySymbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      currencySymbolMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currencySymbol',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      currencySymbolIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currencySymbol',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      currencySymbolIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currencySymbol',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      customerAddressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customerAddress',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      customerAddressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customerAddress',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      customerAddressEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      customerAddressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      customerAddressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      customerAddressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerAddress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      customerAddressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customerAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      customerAddressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customerAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      customerAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customerAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      customerAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customerAddress',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      customerAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      customerAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customerAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      dateOrderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateOrder',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      dateOrderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateOrder',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      dateOrderEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateOrder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      dateOrderGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateOrder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      dateOrderLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateOrder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      dateOrderBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateOrder',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      dateOrderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dateOrder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      dateOrderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dateOrder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      dateOrderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dateOrder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      dateOrderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dateOrder',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      dateOrderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateOrder',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      dateOrderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dateOrder',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      fiscalPositionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fiscalPositionId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      fiscalPositionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fiscalPositionId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      fiscalPositionIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fiscalPositionId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      fiscalPositionIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fiscalPositionId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      fiscalPositionIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fiscalPositionId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      fiscalPositionIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fiscalPositionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      fiscalPositionNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fiscalPositionName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      fiscalPositionNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fiscalPositionName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      fiscalPositionNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fiscalPositionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      fiscalPositionNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fiscalPositionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      fiscalPositionNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fiscalPositionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      fiscalPositionNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fiscalPositionName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      fiscalPositionNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fiscalPositionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      fiscalPositionNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fiscalPositionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      fiscalPositionNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fiscalPositionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      fiscalPositionNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fiscalPositionName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      fiscalPositionNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fiscalPositionName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      fiscalPositionNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fiscalPositionName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'invoiceIds',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'invoiceIds',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invoiceIds',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'invoiceIds',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'invoiceIds',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'invoiceIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'invoiceIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'invoiceIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'invoiceIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'invoiceIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'invoiceIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'invoiceIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceStatusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'invoiceStatus',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceStatusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'invoiceStatus',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceStatusEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invoiceStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceStatusGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'invoiceStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceStatusLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'invoiceStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceStatusBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'invoiceStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'invoiceStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'invoiceStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'invoiceStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'invoiceStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invoiceStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      invoiceStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'invoiceStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      journalIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'journalId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      journalIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'journalId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      journalIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'journalId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      journalIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'journalId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      journalIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'journalId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      journalIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'journalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      journalNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'journalName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      journalNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'journalName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      journalNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'journalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      journalNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'journalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      journalNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'journalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      journalNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'journalName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      journalNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'journalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      journalNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'journalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      journalNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'journalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      journalNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'journalName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      journalNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'journalName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      journalNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'journalName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      mediumIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mediumId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      mediumIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mediumId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      mediumIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediumId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      mediumIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mediumId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      mediumIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mediumId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      mediumIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mediumId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      mediumNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mediumName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      mediumNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mediumName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      mediumNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediumName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      mediumNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mediumName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      mediumNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mediumName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      mediumNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mediumName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      mediumNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mediumName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      mediumNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mediumName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      mediumNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mediumName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      mediumNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mediumName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      mediumNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediumName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      mediumNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mediumName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      nameEqualTo(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      nameGreaterThan(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      nameLessThan(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      nameBetween(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      nameStartsWith(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      opportunityIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'opportunityId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      opportunityIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'opportunityId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      opportunityIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'opportunityId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      opportunityIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'opportunityId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      opportunityIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'opportunityId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      opportunityIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'opportunityId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      originIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'origin',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      originIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'origin',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      originEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'origin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      originGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'origin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      originLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'origin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      originBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'origin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      originStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'origin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      originEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'origin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      originContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'origin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      originMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'origin',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      originIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'origin',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      originIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'origin',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      partnerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'partnerId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      partnerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'partnerId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      partnerIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partnerId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      partnerIdGreaterThan(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      partnerIdLessThan(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      partnerIdBetween(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      partnerNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'partnerName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      partnerNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'partnerName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      partnerNameEqualTo(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      partnerNameGreaterThan(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      partnerNameLessThan(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      partnerNameBetween(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      partnerNameStartsWith(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      partnerNameEndsWith(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      partnerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'partnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      partnerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'partnerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      partnerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partnerName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      partnerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'partnerName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      paymentTermIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'paymentTermId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      paymentTermIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'paymentTermId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      paymentTermIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentTermId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      paymentTermIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentTermId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      paymentTermIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentTermId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      paymentTermIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentTermId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      paymentTermNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'paymentTermName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      paymentTermNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'paymentTermName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      paymentTermNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentTermName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      paymentTermNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentTermName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      paymentTermNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentTermName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      paymentTermNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentTermName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      paymentTermNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'paymentTermName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      paymentTermNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'paymentTermName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      paymentTermNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'paymentTermName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      paymentTermNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'paymentTermName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      paymentTermNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentTermName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      paymentTermNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'paymentTermName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      requirePaymentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'requirePayment',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      requirePaymentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'requirePayment',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      requirePaymentEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'requirePayment',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      requireSignatureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'requireSignature',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      requireSignatureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'requireSignature',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      requireSignatureEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'requireSignature',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      saleOrderTemplateIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'saleOrderTemplateId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      saleOrderTemplateIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'saleOrderTemplateId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      saleOrderTemplateIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saleOrderTemplateId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      saleOrderTemplateIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'saleOrderTemplateId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      saleOrderTemplateIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'saleOrderTemplateId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      saleOrderTemplateIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'saleOrderTemplateId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      saleOrderTemplateNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'saleOrderTemplateName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      saleOrderTemplateNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'saleOrderTemplateName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      saleOrderTemplateNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saleOrderTemplateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      saleOrderTemplateNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'saleOrderTemplateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      saleOrderTemplateNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'saleOrderTemplateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      saleOrderTemplateNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'saleOrderTemplateName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      saleOrderTemplateNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'saleOrderTemplateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      saleOrderTemplateNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'saleOrderTemplateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      saleOrderTemplateNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'saleOrderTemplateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      saleOrderTemplateNameMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'saleOrderTemplateName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      saleOrderTemplateNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saleOrderTemplateName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      saleOrderTemplateNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'saleOrderTemplateName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      searchServerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'searchServerId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      searchServerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'searchServerId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      searchServerIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'searchServerId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      searchServerIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'searchServerId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      searchServerIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'searchServerId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      searchServerIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'searchServerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      serverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      serverIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      serverIdBetween(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signatureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'signature',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signatureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'signature',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signatureEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signatureGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signatureLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signatureBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'signature',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signatureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signatureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signatureContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'signature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signatureMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'signature',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signatureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signature',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signatureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'signature',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'signedBy',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedByIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'signedBy',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedByEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedByGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'signedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedByLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'signedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedByBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'signedBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'signedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'signedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'signedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'signedBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signedBy',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'signedBy',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedOnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'signedOn',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedOnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'signedOn',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedOnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signedOn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedOnGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'signedOn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedOnLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'signedOn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedOnBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'signedOn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedOnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'signedOn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedOnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'signedOn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedOnContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'signedOn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedOnMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'signedOn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedOnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signedOn',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      signedOnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'signedOn',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      sourceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sourceId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      sourceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sourceId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      sourceIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      sourceIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      sourceIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      sourceIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      sourceNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sourceName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      sourceNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sourceName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      sourceNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      sourceNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      sourceNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      sourceNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      sourceNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      sourceNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      sourceNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      sourceNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      sourceNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      sourceNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      stateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'state',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      stateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'state',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      stateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      stateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      stateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      stateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'state',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      stateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      stateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      stateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      stateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'state',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      stateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      stateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'state',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      tagIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tagIds',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      tagIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tagIds',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      tagIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tagIds',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      tagIdsElementGreaterThan(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      tagIdsElementLessThan(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      tagIdsElementBetween(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      tagIdsLengthEqualTo(int length) {
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      tagIdsIsEmpty() {
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      tagIdsIsNotEmpty() {
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      tagIdsLengthLessThan(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      tagIdsLengthGreaterThan(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      tagIdsLengthBetween(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      teamIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'teamId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      teamIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'teamId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      teamIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teamId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      teamIdGreaterThan(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      teamIdLessThan(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      teamIdBetween(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      userIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      userIdGreaterThan(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      userIdLessThan(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      userIdBetween(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      userNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      userNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userName',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      userNameEqualTo(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      userNameGreaterThan(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      userNameLessThan(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      userNameBetween(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      userNameStartsWith(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      userNameEndsWith(
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

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      userNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      userNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      userNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      userNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      validityDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'validityDate',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      validityDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'validityDate',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      validityDateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'validityDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      validityDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'validityDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      validityDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'validityDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      validityDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'validityDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      validityDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'validityDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      validityDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'validityDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      validityDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'validityDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      validityDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'validityDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      validityDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'validityDate',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterFilterCondition>
      validityDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'validityDate',
        value: '',
      ));
    });
  }
}

extension SaleOrderIsarCacheQueryObject
    on QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QFilterCondition> {}

extension SaleOrderIsarCacheQueryLinks
    on QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QFilterCondition> {}

extension SaleOrderIsarCacheQuerySortBy
    on QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QSortBy> {
  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByAmountTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTax', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByAmountTaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTax', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByAmountTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTotal', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByAmountTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTotal', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByAmountUntaxed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountUntaxed', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByAmountUntaxedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountUntaxed', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByCampaignId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'campaignId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByCampaignIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'campaignId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByCampaignName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'campaignName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByCampaignNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'campaignName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByClientOrderRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientOrderRef', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByClientOrderRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientOrderRef', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByCommitmentDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commitmentDate', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByCommitmentDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commitmentDate', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByCompanyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByCompanyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByCurrencyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByCurrencyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByCurrencySymbol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencySymbol', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByCurrencySymbolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencySymbol', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByCustomerAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerAddress', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByCustomerAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerAddress', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByDateOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOrder', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByDateOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOrder', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByFiscalPositionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiscalPositionId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByFiscalPositionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiscalPositionId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByFiscalPositionName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiscalPositionName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByFiscalPositionNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiscalPositionName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByInvoiceStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceStatus', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByInvoiceStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceStatus', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByJournalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByJournalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByJournalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByJournalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByMediumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediumId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByMediumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediumId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByMediumName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediumName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByMediumNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediumName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByOpportunityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opportunityId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByOpportunityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opportunityId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByOrigin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'origin', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByOriginDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'origin', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByPartnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByPartnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByPartnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByPartnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByPaymentTermId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentTermId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByPaymentTermIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentTermId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByPaymentTermName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentTermName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByPaymentTermNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentTermName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByRequirePayment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requirePayment', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByRequirePaymentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requirePayment', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByRequireSignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requireSignature', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByRequireSignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requireSignature', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortBySaleOrderTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderTemplateId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortBySaleOrderTemplateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderTemplateId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortBySaleOrderTemplateName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderTemplateName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortBySaleOrderTemplateNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderTemplateName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortBySearchServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchServerId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortBySearchServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchServerId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortBySignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortBySignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortBySignedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedBy', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortBySignedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedBy', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortBySignedOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedOn', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortBySignedOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedOn', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortBySourceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortBySourceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByTeamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByTeamIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByValidityDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'validityDate', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      sortByValidityDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'validityDate', Sort.desc);
    });
  }
}

extension SaleOrderIsarCacheQuerySortThenBy
    on QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QSortThenBy> {
  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByAmountTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTax', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByAmountTaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTax', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByAmountTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTotal', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByAmountTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTotal', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByAmountUntaxed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountUntaxed', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByAmountUntaxedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountUntaxed', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByCampaignId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'campaignId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByCampaignIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'campaignId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByCampaignName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'campaignName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByCampaignNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'campaignName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByClientOrderRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientOrderRef', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByClientOrderRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientOrderRef', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByCommitmentDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commitmentDate', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByCommitmentDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commitmentDate', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByCompanyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByCompanyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByCurrencyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByCurrencyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByCurrencySymbol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencySymbol', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByCurrencySymbolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencySymbol', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByCustomerAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerAddress', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByCustomerAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerAddress', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByDateOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOrder', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByDateOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOrder', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByFiscalPositionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiscalPositionId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByFiscalPositionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiscalPositionId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByFiscalPositionName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiscalPositionName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByFiscalPositionNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiscalPositionName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByInvoiceStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceStatus', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByInvoiceStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceStatus', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByJournalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByJournalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByJournalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByJournalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByMediumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediumId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByMediumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediumId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByMediumName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediumName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByMediumNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediumName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByOpportunityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opportunityId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByOpportunityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opportunityId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByOrigin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'origin', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByOriginDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'origin', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByPartnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByPartnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByPartnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByPartnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByPaymentTermId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentTermId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByPaymentTermIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentTermId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByPaymentTermName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentTermName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByPaymentTermNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentTermName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByRequirePayment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requirePayment', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByRequirePaymentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requirePayment', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByRequireSignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requireSignature', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByRequireSignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requireSignature', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenBySaleOrderTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderTemplateId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenBySaleOrderTemplateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderTemplateId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenBySaleOrderTemplateName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderTemplateName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenBySaleOrderTemplateNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderTemplateName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenBySearchServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchServerId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenBySearchServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchServerId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenBySignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenBySignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signature', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenBySignedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedBy', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenBySignedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedBy', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenBySignedOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedOn', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenBySignedOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signedOn', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenBySourceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenBySourceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByTeamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByTeamIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByValidityDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'validityDate', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QAfterSortBy>
      thenByValidityDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'validityDate', Sort.desc);
    });
  }
}

extension SaleOrderIsarCacheQueryWhereDistinct
    on QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct> {
  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByAmountTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountTax');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByAmountTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountTotal');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByAmountUntaxed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountUntaxed');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByCampaignId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'campaignId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByCampaignName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'campaignName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByClientOrderRef({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientOrderRef',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByCommitmentDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commitmentDate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'companyId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByCompanyName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'companyName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByCurrencyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currencyId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByCurrencySymbol({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currencySymbol',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByCustomerAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerAddress',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByDateOrder({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateOrder', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByFiscalPositionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fiscalPositionId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByFiscalPositionName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fiscalPositionName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByInvoiceIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'invoiceIds');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByInvoiceStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'invoiceStatus',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByJournalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'journalId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByJournalName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'journalName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByMediumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediumId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByMediumName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediumName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByOpportunityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'opportunityId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByOrigin({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'origin', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByPartnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partnerId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByPartnerName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partnerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByPaymentTermId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentTermId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByPaymentTermName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentTermName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByRequirePayment() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'requirePayment');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByRequireSignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'requireSignature');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctBySaleOrderTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saleOrderTemplateId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctBySaleOrderTemplateName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saleOrderTemplateName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctBySearchServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'searchServerId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctBySignature({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signature', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctBySignedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signedBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctBySignedOn({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signedOn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctBySourceName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByState({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'state', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByTagIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tagIds');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByTeamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'teamId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByUserName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QDistinct>
      distinctByValidityDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'validityDate', caseSensitive: caseSensitive);
    });
  }
}

extension SaleOrderIsarCacheQueryProperty
    on QueryBuilder<SaleOrderIsarCache, SaleOrderIsarCache, QQueryProperty> {
  QueryBuilder<SaleOrderIsarCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SaleOrderIsarCache, double?, QQueryOperations>
      amountTaxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountTax');
    });
  }

  QueryBuilder<SaleOrderIsarCache, double?, QQueryOperations>
      amountTotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountTotal');
    });
  }

  QueryBuilder<SaleOrderIsarCache, double?, QQueryOperations>
      amountUntaxedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountUntaxed');
    });
  }

  QueryBuilder<SaleOrderIsarCache, int?, QQueryOperations>
      campaignIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'campaignId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      campaignNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'campaignName');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      clientOrderRefProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientOrderRef');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      commitmentDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commitmentDate');
    });
  }

  QueryBuilder<SaleOrderIsarCache, int?, QQueryOperations> companyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'companyId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      companyNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'companyName');
    });
  }

  QueryBuilder<SaleOrderIsarCache, int?, QQueryOperations>
      currencyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currencyId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      currencySymbolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currencySymbol');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      customerAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerAddress');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      dateOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateOrder');
    });
  }

  QueryBuilder<SaleOrderIsarCache, int?, QQueryOperations>
      fiscalPositionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fiscalPositionId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      fiscalPositionNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fiscalPositionName');
    });
  }

  QueryBuilder<SaleOrderIsarCache, List<int>?, QQueryOperations>
      invoiceIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'invoiceIds');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      invoiceStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'invoiceStatus');
    });
  }

  QueryBuilder<SaleOrderIsarCache, int?, QQueryOperations> journalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'journalId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      journalNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'journalName');
    });
  }

  QueryBuilder<SaleOrderIsarCache, int?, QQueryOperations> mediumIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediumId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      mediumNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediumName');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<SaleOrderIsarCache, int?, QQueryOperations>
      opportunityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'opportunityId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations> originProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'origin');
    });
  }

  QueryBuilder<SaleOrderIsarCache, int?, QQueryOperations> partnerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partnerId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      partnerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partnerName');
    });
  }

  QueryBuilder<SaleOrderIsarCache, int?, QQueryOperations>
      paymentTermIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentTermId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      paymentTermNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentTermName');
    });
  }

  QueryBuilder<SaleOrderIsarCache, bool?, QQueryOperations>
      requirePaymentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'requirePayment');
    });
  }

  QueryBuilder<SaleOrderIsarCache, bool?, QQueryOperations>
      requireSignatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'requireSignature');
    });
  }

  QueryBuilder<SaleOrderIsarCache, int?, QQueryOperations>
      saleOrderTemplateIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saleOrderTemplateId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      saleOrderTemplateNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saleOrderTemplateName');
    });
  }

  QueryBuilder<SaleOrderIsarCache, int?, QQueryOperations>
      searchServerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'searchServerId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, int?, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      signatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signature');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      signedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signedBy');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      signedOnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signedOn');
    });
  }

  QueryBuilder<SaleOrderIsarCache, int?, QQueryOperations> sourceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      sourceNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceName');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations> stateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'state');
    });
  }

  QueryBuilder<SaleOrderIsarCache, List<int>?, QQueryOperations>
      tagIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tagIds');
    });
  }

  QueryBuilder<SaleOrderIsarCache, int?, QQueryOperations> teamIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'teamId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, int?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      userNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userName');
    });
  }

  QueryBuilder<SaleOrderIsarCache, String?, QQueryOperations>
      validityDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'validityDate');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSaleOrderLineIsarCacheCollection on Isar {
  IsarCollection<SaleOrderLineIsarCache> get saleOrderLineIsarCaches =>
      this.collection();
}

const SaleOrderLineIsarCacheSchema = CollectionSchema(
  name: r'SaleOrderLineIsarCache',
  id: 6762699353988920210,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    ),
    r'discount': PropertySchema(
      id: 1,
      name: r'discount',
      type: IsarType.double,
    ),
    r'displayType': PropertySchema(
      id: 2,
      name: r'displayType',
      type: IsarType.string,
    ),
    r'isDownPayment': PropertySchema(
      id: 3,
      name: r'isDownPayment',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'orderLineId': PropertySchema(
      id: 5,
      name: r'orderLineId',
      type: IsarType.long,
    ),
    r'priceUnit': PropertySchema(
      id: 6,
      name: r'priceUnit',
      type: IsarType.double,
    ),
    r'productId': PropertySchema(
      id: 7,
      name: r'productId',
      type: IsarType.long,
    ),
    r'productName': PropertySchema(
      id: 8,
      name: r'productName',
      type: IsarType.string,
    ),
    r'productUomQty': PropertySchema(
      id: 9,
      name: r'productUomQty',
      type: IsarType.double,
    ),
    r'saleOrderId': PropertySchema(
      id: 10,
      name: r'saleOrderId',
      type: IsarType.long,
    ),
    r'searchSaleOrderId': PropertySchema(
      id: 11,
      name: r'searchSaleOrderId',
      type: IsarType.long,
    ),
    r'taxIds': PropertySchema(
      id: 12,
      name: r'taxIds',
      type: IsarType.longList,
    )
  },
  estimateSize: _saleOrderLineIsarCacheEstimateSize,
  serialize: _saleOrderLineIsarCacheSerialize,
  deserialize: _saleOrderLineIsarCacheDeserialize,
  deserializeProp: _saleOrderLineIsarCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'searchSaleOrderId': IndexSchema(
      id: 6606235200181214139,
      name: r'searchSaleOrderId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'searchSaleOrderId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _saleOrderLineIsarCacheGetId,
  getLinks: _saleOrderLineIsarCacheGetLinks,
  attach: _saleOrderLineIsarCacheAttach,
  version: '3.3.2',
);

int _saleOrderLineIsarCacheEstimateSize(
  SaleOrderLineIsarCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.displayType;
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
    final value = object.productName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.taxIds;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  return bytesCount;
}

void _saleOrderLineIsarCacheSerialize(
  SaleOrderLineIsarCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeDouble(offsets[1], object.discount);
  writer.writeString(offsets[2], object.displayType);
  writer.writeBool(offsets[3], object.isDownPayment);
  writer.writeString(offsets[4], object.name);
  writer.writeLong(offsets[5], object.orderLineId);
  writer.writeDouble(offsets[6], object.priceUnit);
  writer.writeLong(offsets[7], object.productId);
  writer.writeString(offsets[8], object.productName);
  writer.writeDouble(offsets[9], object.productUomQty);
  writer.writeLong(offsets[10], object.saleOrderId);
  writer.writeLong(offsets[11], object.searchSaleOrderId);
  writer.writeLongList(offsets[12], object.taxIds);
}

SaleOrderLineIsarCache _saleOrderLineIsarCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SaleOrderLineIsarCache();
  object.amount = reader.readDoubleOrNull(offsets[0]);
  object.discount = reader.readDoubleOrNull(offsets[1]);
  object.displayType = reader.readStringOrNull(offsets[2]);
  object.id = id;
  object.isDownPayment = reader.readBoolOrNull(offsets[3]);
  object.name = reader.readStringOrNull(offsets[4]);
  object.orderLineId = reader.readLongOrNull(offsets[5]);
  object.priceUnit = reader.readDoubleOrNull(offsets[6]);
  object.productId = reader.readLongOrNull(offsets[7]);
  object.productName = reader.readStringOrNull(offsets[8]);
  object.productUomQty = reader.readDoubleOrNull(offsets[9]);
  object.saleOrderId = reader.readLongOrNull(offsets[10]);
  object.searchSaleOrderId = reader.readLongOrNull(offsets[11]);
  object.taxIds = reader.readLongList(offsets[12]);
  return object;
}

P _saleOrderLineIsarCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readLongList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _saleOrderLineIsarCacheGetId(SaleOrderLineIsarCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _saleOrderLineIsarCacheGetLinks(
    SaleOrderLineIsarCache object) {
  return [];
}

void _saleOrderLineIsarCacheAttach(
    IsarCollection<dynamic> col, Id id, SaleOrderLineIsarCache object) {
  object.id = id;
}

extension SaleOrderLineIsarCacheQueryWhereSort
    on QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QWhere> {
  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterWhere>
      anySearchSaleOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'searchSaleOrderId'),
      );
    });
  }
}

extension SaleOrderLineIsarCacheQueryWhere on QueryBuilder<
    SaleOrderLineIsarCache, SaleOrderLineIsarCache, QWhereClause> {
  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
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

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
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

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterWhereClause> searchSaleOrderIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'searchSaleOrderId',
        value: [null],
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterWhereClause> searchSaleOrderIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'searchSaleOrderId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterWhereClause> searchSaleOrderIdEqualTo(int? searchSaleOrderId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'searchSaleOrderId',
        value: [searchSaleOrderId],
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterWhereClause> searchSaleOrderIdNotEqualTo(int? searchSaleOrderId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchSaleOrderId',
              lower: [],
              upper: [searchSaleOrderId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchSaleOrderId',
              lower: [searchSaleOrderId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchSaleOrderId',
              lower: [searchSaleOrderId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchSaleOrderId',
              lower: [],
              upper: [searchSaleOrderId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterWhereClause> searchSaleOrderIdGreaterThan(
    int? searchSaleOrderId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'searchSaleOrderId',
        lower: [searchSaleOrderId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterWhereClause> searchSaleOrderIdLessThan(
    int? searchSaleOrderId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'searchSaleOrderId',
        lower: [],
        upper: [searchSaleOrderId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterWhereClause> searchSaleOrderIdBetween(
    int? lowerSearchSaleOrderId,
    int? upperSearchSaleOrderId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'searchSaleOrderId',
        lower: [lowerSearchSaleOrderId],
        includeLower: includeLower,
        upper: [upperSearchSaleOrderId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SaleOrderLineIsarCacheQueryFilter on QueryBuilder<
    SaleOrderLineIsarCache, SaleOrderLineIsarCache, QFilterCondition> {
  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> amountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'amount',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> amountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'amount',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> amountEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> amountGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> amountLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> amountBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> discountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'discount',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> discountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'discount',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> discountEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> discountGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'discount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> discountLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'discount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> discountBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'discount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> displayTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'displayType',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> displayTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'displayType',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> displayTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> displayTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> displayTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> displayTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> displayTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> displayTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
          QAfterFilterCondition>
      displayTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
          QAfterFilterCondition>
      displayTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> displayTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayType',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> displayTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayType',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
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

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
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

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
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

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> isDownPaymentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isDownPayment',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> isDownPaymentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isDownPayment',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> isDownPaymentEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDownPayment',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
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

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
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

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
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

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
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

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
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

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
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

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
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

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
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

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> orderLineIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'orderLineId',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> orderLineIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'orderLineId',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> orderLineIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderLineId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> orderLineIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderLineId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> orderLineIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderLineId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> orderLineIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderLineId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> priceUnitIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'priceUnit',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> priceUnitIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'priceUnit',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> priceUnitEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priceUnit',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> priceUnitGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priceUnit',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> priceUnitLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priceUnit',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> priceUnitBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priceUnit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'productId',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'productId',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'productName',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'productName',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
          QAfterFilterCondition>
      productNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
          QAfterFilterCondition>
      productNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'productName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'productName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productUomQtyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'productUomQty',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productUomQtyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'productUomQty',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productUomQtyEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productUomQty',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productUomQtyGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productUomQty',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productUomQtyLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productUomQty',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> productUomQtyBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productUomQty',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> saleOrderIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'saleOrderId',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> saleOrderIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'saleOrderId',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> saleOrderIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saleOrderId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> saleOrderIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'saleOrderId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> saleOrderIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'saleOrderId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> saleOrderIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'saleOrderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> searchSaleOrderIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'searchSaleOrderId',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> searchSaleOrderIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'searchSaleOrderId',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> searchSaleOrderIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'searchSaleOrderId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> searchSaleOrderIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'searchSaleOrderId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> searchSaleOrderIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'searchSaleOrderId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> searchSaleOrderIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'searchSaleOrderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> taxIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxIds',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> taxIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxIds',
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> taxIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxIds',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> taxIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxIds',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> taxIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxIds',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> taxIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> taxIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'taxIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> taxIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'taxIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> taxIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'taxIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> taxIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'taxIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> taxIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'taxIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache,
      QAfterFilterCondition> taxIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'taxIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension SaleOrderLineIsarCacheQueryObject on QueryBuilder<
    SaleOrderLineIsarCache, SaleOrderLineIsarCache, QFilterCondition> {}

extension SaleOrderLineIsarCacheQueryLinks on QueryBuilder<
    SaleOrderLineIsarCache, SaleOrderLineIsarCache, QFilterCondition> {}

extension SaleOrderLineIsarCacheQuerySortBy
    on QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QSortBy> {
  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayType', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByDisplayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayType', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByIsDownPayment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownPayment', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByIsDownPaymentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownPayment', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByOrderLineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderLineId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByOrderLineIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderLineId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByPriceUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceUnit', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByPriceUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceUnit', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByProductName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByProductNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByProductUomQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productUomQty', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortByProductUomQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productUomQty', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortBySaleOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortBySaleOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortBySearchSaleOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchSaleOrderId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      sortBySearchSaleOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchSaleOrderId', Sort.desc);
    });
  }
}

extension SaleOrderLineIsarCacheQuerySortThenBy on QueryBuilder<
    SaleOrderLineIsarCache, SaleOrderLineIsarCache, QSortThenBy> {
  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayType', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByDisplayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayType', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByIsDownPayment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownPayment', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByIsDownPaymentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownPayment', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByOrderLineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderLineId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByOrderLineIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderLineId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByPriceUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceUnit', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByPriceUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceUnit', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByProductName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByProductNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByProductUomQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productUomQty', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenByProductUomQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productUomQty', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenBySaleOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenBySaleOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenBySearchSaleOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchSaleOrderId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QAfterSortBy>
      thenBySearchSaleOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchSaleOrderId', Sort.desc);
    });
  }
}

extension SaleOrderLineIsarCacheQueryWhereDistinct
    on QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QDistinct> {
  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QDistinct>
      distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QDistinct>
      distinctByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discount');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QDistinct>
      distinctByDisplayType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QDistinct>
      distinctByIsDownPayment() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDownPayment');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QDistinct>
      distinctByOrderLineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderLineId');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QDistinct>
      distinctByPriceUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priceUnit');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QDistinct>
      distinctByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productId');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QDistinct>
      distinctByProductName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QDistinct>
      distinctByProductUomQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productUomQty');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QDistinct>
      distinctBySaleOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saleOrderId');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QDistinct>
      distinctBySearchSaleOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'searchSaleOrderId');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, SaleOrderLineIsarCache, QDistinct>
      distinctByTaxIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxIds');
    });
  }
}

extension SaleOrderLineIsarCacheQueryProperty on QueryBuilder<
    SaleOrderLineIsarCache, SaleOrderLineIsarCache, QQueryProperty> {
  QueryBuilder<SaleOrderLineIsarCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, double?, QQueryOperations>
      amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, double?, QQueryOperations>
      discountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discount');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, String?, QQueryOperations>
      displayTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayType');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, bool?, QQueryOperations>
      isDownPaymentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDownPayment');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, String?, QQueryOperations>
      nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, int?, QQueryOperations>
      orderLineIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderLineId');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, double?, QQueryOperations>
      priceUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priceUnit');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, int?, QQueryOperations>
      productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productId');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, String?, QQueryOperations>
      productNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productName');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, double?, QQueryOperations>
      productUomQtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productUomQty');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, int?, QQueryOperations>
      saleOrderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saleOrderId');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, int?, QQueryOperations>
      searchSaleOrderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'searchSaleOrderId');
    });
  }

  QueryBuilder<SaleOrderLineIsarCache, List<int>?, QQueryOperations>
      taxIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxIds');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSaleOrderOptionIsarCacheCollection on Isar {
  IsarCollection<SaleOrderOptionIsarCache> get saleOrderOptionIsarCaches =>
      this.collection();
}

const SaleOrderOptionIsarCacheSchema = CollectionSchema(
  name: r'SaleOrderOptionIsarCache',
  id: -2608569013413154867,
  properties: {
    r'name': PropertySchema(
      id: 0,
      name: r'name',
      type: IsarType.string,
    ),
    r'optionId': PropertySchema(
      id: 1,
      name: r'optionId',
      type: IsarType.long,
    ),
    r'priceUnit': PropertySchema(
      id: 2,
      name: r'priceUnit',
      type: IsarType.double,
    ),
    r'productId': PropertySchema(
      id: 3,
      name: r'productId',
      type: IsarType.long,
    ),
    r'productName': PropertySchema(
      id: 4,
      name: r'productName',
      type: IsarType.string,
    ),
    r'quantity': PropertySchema(
      id: 5,
      name: r'quantity',
      type: IsarType.double,
    ),
    r'saleOrderId': PropertySchema(
      id: 6,
      name: r'saleOrderId',
      type: IsarType.long,
    ),
    r'searchSaleOrderId': PropertySchema(
      id: 7,
      name: r'searchSaleOrderId',
      type: IsarType.long,
    )
  },
  estimateSize: _saleOrderOptionIsarCacheEstimateSize,
  serialize: _saleOrderOptionIsarCacheSerialize,
  deserialize: _saleOrderOptionIsarCacheDeserialize,
  deserializeProp: _saleOrderOptionIsarCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'searchSaleOrderId': IndexSchema(
      id: 6606235200181214139,
      name: r'searchSaleOrderId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'searchSaleOrderId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _saleOrderOptionIsarCacheGetId,
  getLinks: _saleOrderOptionIsarCacheGetLinks,
  attach: _saleOrderOptionIsarCacheAttach,
  version: '3.3.2',
);

int _saleOrderOptionIsarCacheEstimateSize(
  SaleOrderOptionIsarCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.productName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _saleOrderOptionIsarCacheSerialize(
  SaleOrderOptionIsarCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.name);
  writer.writeLong(offsets[1], object.optionId);
  writer.writeDouble(offsets[2], object.priceUnit);
  writer.writeLong(offsets[3], object.productId);
  writer.writeString(offsets[4], object.productName);
  writer.writeDouble(offsets[5], object.quantity);
  writer.writeLong(offsets[6], object.saleOrderId);
  writer.writeLong(offsets[7], object.searchSaleOrderId);
}

SaleOrderOptionIsarCache _saleOrderOptionIsarCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SaleOrderOptionIsarCache();
  object.id = id;
  object.name = reader.readStringOrNull(offsets[0]);
  object.optionId = reader.readLongOrNull(offsets[1]);
  object.priceUnit = reader.readDoubleOrNull(offsets[2]);
  object.productId = reader.readLongOrNull(offsets[3]);
  object.productName = reader.readStringOrNull(offsets[4]);
  object.quantity = reader.readDoubleOrNull(offsets[5]);
  object.saleOrderId = reader.readLongOrNull(offsets[6]);
  object.searchSaleOrderId = reader.readLongOrNull(offsets[7]);
  return object;
}

P _saleOrderOptionIsarCacheDeserializeProp<P>(
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
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _saleOrderOptionIsarCacheGetId(SaleOrderOptionIsarCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _saleOrderOptionIsarCacheGetLinks(
    SaleOrderOptionIsarCache object) {
  return [];
}

void _saleOrderOptionIsarCacheAttach(
    IsarCollection<dynamic> col, Id id, SaleOrderOptionIsarCache object) {
  object.id = id;
}

extension SaleOrderOptionIsarCacheQueryWhereSort on QueryBuilder<
    SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QWhere> {
  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterWhere>
      anySearchSaleOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'searchSaleOrderId'),
      );
    });
  }
}

extension SaleOrderOptionIsarCacheQueryWhere on QueryBuilder<
    SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QWhereClause> {
  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
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

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
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

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterWhereClause> searchSaleOrderIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'searchSaleOrderId',
        value: [null],
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterWhereClause> searchSaleOrderIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'searchSaleOrderId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterWhereClause> searchSaleOrderIdEqualTo(int? searchSaleOrderId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'searchSaleOrderId',
        value: [searchSaleOrderId],
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterWhereClause> searchSaleOrderIdNotEqualTo(int? searchSaleOrderId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchSaleOrderId',
              lower: [],
              upper: [searchSaleOrderId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchSaleOrderId',
              lower: [searchSaleOrderId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchSaleOrderId',
              lower: [searchSaleOrderId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchSaleOrderId',
              lower: [],
              upper: [searchSaleOrderId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterWhereClause> searchSaleOrderIdGreaterThan(
    int? searchSaleOrderId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'searchSaleOrderId',
        lower: [searchSaleOrderId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterWhereClause> searchSaleOrderIdLessThan(
    int? searchSaleOrderId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'searchSaleOrderId',
        lower: [],
        upper: [searchSaleOrderId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterWhereClause> searchSaleOrderIdBetween(
    int? lowerSearchSaleOrderId,
    int? upperSearchSaleOrderId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'searchSaleOrderId',
        lower: [lowerSearchSaleOrderId],
        includeLower: includeLower,
        upper: [upperSearchSaleOrderId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SaleOrderOptionIsarCacheQueryFilter on QueryBuilder<
    SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QFilterCondition> {
  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
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

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
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

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
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

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
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

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
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

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
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

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
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

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
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

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
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

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
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

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
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

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> optionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'optionId',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> optionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'optionId',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> optionIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'optionId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> optionIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'optionId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> optionIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'optionId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> optionIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'optionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> priceUnitIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'priceUnit',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> priceUnitIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'priceUnit',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> priceUnitEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priceUnit',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> priceUnitGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priceUnit',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> priceUnitLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priceUnit',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> priceUnitBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priceUnit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> productIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'productId',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> productIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'productId',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> productIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> productIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> productIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> productIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> productNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'productName',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> productNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'productName',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> productNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> productNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> productNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> productNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> productNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> productNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
          QAfterFilterCondition>
      productNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'productName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
          QAfterFilterCondition>
      productNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'productName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> productNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> productNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'productName',
        value: '',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> quantityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'quantity',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> quantityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'quantity',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> quantityEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quantity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> quantityGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quantity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> quantityLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quantity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> quantityBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quantity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> saleOrderIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'saleOrderId',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> saleOrderIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'saleOrderId',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> saleOrderIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saleOrderId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> saleOrderIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'saleOrderId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> saleOrderIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'saleOrderId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> saleOrderIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'saleOrderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> searchSaleOrderIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'searchSaleOrderId',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> searchSaleOrderIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'searchSaleOrderId',
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> searchSaleOrderIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'searchSaleOrderId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> searchSaleOrderIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'searchSaleOrderId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> searchSaleOrderIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'searchSaleOrderId',
        value: value,
      ));
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache,
      QAfterFilterCondition> searchSaleOrderIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'searchSaleOrderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SaleOrderOptionIsarCacheQueryObject on QueryBuilder<
    SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QFilterCondition> {}

extension SaleOrderOptionIsarCacheQueryLinks on QueryBuilder<
    SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QFilterCondition> {}

extension SaleOrderOptionIsarCacheQuerySortBy on QueryBuilder<
    SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QSortBy> {
  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      sortByOptionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'optionId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      sortByOptionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'optionId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      sortByPriceUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceUnit', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      sortByPriceUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceUnit', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      sortByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      sortByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      sortByProductName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      sortByProductNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      sortByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      sortByQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      sortBySaleOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      sortBySaleOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      sortBySearchSaleOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchSaleOrderId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      sortBySearchSaleOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchSaleOrderId', Sort.desc);
    });
  }
}

extension SaleOrderOptionIsarCacheQuerySortThenBy on QueryBuilder<
    SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QSortThenBy> {
  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      thenByOptionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'optionId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      thenByOptionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'optionId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      thenByPriceUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceUnit', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      thenByPriceUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceUnit', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      thenByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      thenByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      thenByProductName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      thenByProductNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productName', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      thenByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      thenByQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      thenBySaleOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      thenBySaleOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderId', Sort.desc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      thenBySearchSaleOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchSaleOrderId', Sort.asc);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QAfterSortBy>
      thenBySearchSaleOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchSaleOrderId', Sort.desc);
    });
  }
}

extension SaleOrderOptionIsarCacheQueryWhereDistinct on QueryBuilder<
    SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QDistinct> {
  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QDistinct>
      distinctByOptionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'optionId');
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QDistinct>
      distinctByPriceUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priceUnit');
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QDistinct>
      distinctByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productId');
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QDistinct>
      distinctByProductName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QDistinct>
      distinctByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quantity');
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QDistinct>
      distinctBySaleOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saleOrderId');
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QDistinct>
      distinctBySearchSaleOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'searchSaleOrderId');
    });
  }
}

extension SaleOrderOptionIsarCacheQueryProperty on QueryBuilder<
    SaleOrderOptionIsarCache, SaleOrderOptionIsarCache, QQueryProperty> {
  QueryBuilder<SaleOrderOptionIsarCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, String?, QQueryOperations>
      nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, int?, QQueryOperations>
      optionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'optionId');
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, double?, QQueryOperations>
      priceUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priceUnit');
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, int?, QQueryOperations>
      productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productId');
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, String?, QQueryOperations>
      productNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productName');
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, double?, QQueryOperations>
      quantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quantity');
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, int?, QQueryOperations>
      saleOrderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saleOrderId');
    });
  }

  QueryBuilder<SaleOrderOptionIsarCache, int?, QQueryOperations>
      searchSaleOrderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'searchSaleOrderId');
    });
  }
}
