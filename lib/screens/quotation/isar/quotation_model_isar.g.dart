// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_model_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetQuotationModelIsarCollection on Isar {
  IsarCollection<QuotationModelIsar> get quotationModelIsars =>
      this.collection();
}

const QuotationModelIsarSchema = CollectionSchema(
  name: r'QuotationModelIsar',
  id: -5529262296144707307,
  properties: {
    r'activityDateDeadline': PropertySchema(
      id: 0,
      name: r'activityDateDeadline',
      type: IsarType.string,
    ),
    r'activityState': PropertySchema(
      id: 1,
      name: r'activityState',
      type: IsarType.string,
    ),
    r'activitySummary': PropertySchema(
      id: 2,
      name: r'activitySummary',
      type: IsarType.string,
    ),
    r'activityTypeId': PropertySchema(
      id: 3,
      name: r'activityTypeId',
      type: IsarType.long,
    ),
    r'activityTypeName': PropertySchema(
      id: 4,
      name: r'activityTypeName',
      type: IsarType.string,
    ),
    r'activityUserId': PropertySchema(
      id: 5,
      name: r'activityUserId',
      type: IsarType.long,
    ),
    r'activityUserName': PropertySchema(
      id: 6,
      name: r'activityUserName',
      type: IsarType.string,
    ),
    r'amountTax': PropertySchema(
      id: 7,
      name: r'amountTax',
      type: IsarType.double,
    ),
    r'amountTotal': PropertySchema(
      id: 8,
      name: r'amountTotal',
      type: IsarType.double,
    ),
    r'amountUntaxed': PropertySchema(
      id: 9,
      name: r'amountUntaxed',
      type: IsarType.double,
    ),
    r'currencyId': PropertySchema(
      id: 10,
      name: r'currencyId',
      type: IsarType.long,
    ),
    r'currencyRate': PropertySchema(
      id: 11,
      name: r'currencyRate',
      type: IsarType.double,
    ),
    r'currencyname': PropertySchema(
      id: 12,
      name: r'currencyname',
      type: IsarType.string,
    ),
    r'dateOrder': PropertySchema(
      id: 13,
      name: r'dateOrder',
      type: IsarType.string,
    ),
    r'invoiceStatus': PropertySchema(
      id: 14,
      name: r'invoiceStatus',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 15,
      name: r'name',
      type: IsarType.string,
    ),
    r'partnerId': PropertySchema(
      id: 16,
      name: r'partnerId',
      type: IsarType.long,
    ),
    r'partnerName': PropertySchema(
      id: 17,
      name: r'partnerName',
      type: IsarType.string,
    ),
    r'prepaymentPercent': PropertySchema(
      id: 18,
      name: r'prepaymentPercent',
      type: IsarType.double,
    ),
    r'serverId': PropertySchema(
      id: 19,
      name: r'serverId',
      type: IsarType.long,
    ),
    r'state': PropertySchema(
      id: 20,
      name: r'state',
      type: IsarType.string,
    ),
    r'userId': PropertySchema(
      id: 21,
      name: r'userId',
      type: IsarType.long,
    ),
    r'userName': PropertySchema(
      id: 22,
      name: r'userName',
      type: IsarType.string,
    )
  },
  estimateSize: _quotationModelIsarEstimateSize,
  serialize: _quotationModelIsarSerialize,
  deserialize: _quotationModelIsarDeserialize,
  deserializeProp: _quotationModelIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _quotationModelIsarGetId,
  getLinks: _quotationModelIsarGetLinks,
  attach: _quotationModelIsarAttach,
  version: '3.3.2',
);

int _quotationModelIsarEstimateSize(
  QuotationModelIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.activityDateDeadline;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.activityState;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.activitySummary;
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
    final value = object.currencyname;
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
    final value = object.invoiceStatus;
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
    final value = object.state;
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

void _quotationModelIsarSerialize(
  QuotationModelIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.activityDateDeadline);
  writer.writeString(offsets[1], object.activityState);
  writer.writeString(offsets[2], object.activitySummary);
  writer.writeLong(offsets[3], object.activityTypeId);
  writer.writeString(offsets[4], object.activityTypeName);
  writer.writeLong(offsets[5], object.activityUserId);
  writer.writeString(offsets[6], object.activityUserName);
  writer.writeDouble(offsets[7], object.amountTax);
  writer.writeDouble(offsets[8], object.amountTotal);
  writer.writeDouble(offsets[9], object.amountUntaxed);
  writer.writeLong(offsets[10], object.currencyId);
  writer.writeDouble(offsets[11], object.currencyRate);
  writer.writeString(offsets[12], object.currencyname);
  writer.writeString(offsets[13], object.dateOrder);
  writer.writeString(offsets[14], object.invoiceStatus);
  writer.writeString(offsets[15], object.name);
  writer.writeLong(offsets[16], object.partnerId);
  writer.writeString(offsets[17], object.partnerName);
  writer.writeDouble(offsets[18], object.prepaymentPercent);
  writer.writeLong(offsets[19], object.serverId);
  writer.writeString(offsets[20], object.state);
  writer.writeLong(offsets[21], object.userId);
  writer.writeString(offsets[22], object.userName);
}

QuotationModelIsar _quotationModelIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = QuotationModelIsar();
  object.activityDateDeadline = reader.readStringOrNull(offsets[0]);
  object.activityState = reader.readStringOrNull(offsets[1]);
  object.activitySummary = reader.readStringOrNull(offsets[2]);
  object.activityTypeId = reader.readLongOrNull(offsets[3]);
  object.activityTypeName = reader.readStringOrNull(offsets[4]);
  object.activityUserId = reader.readLongOrNull(offsets[5]);
  object.activityUserName = reader.readStringOrNull(offsets[6]);
  object.amountTax = reader.readDoubleOrNull(offsets[7]);
  object.amountTotal = reader.readDoubleOrNull(offsets[8]);
  object.amountUntaxed = reader.readDoubleOrNull(offsets[9]);
  object.currencyId = reader.readLongOrNull(offsets[10]);
  object.currencyRate = reader.readDoubleOrNull(offsets[11]);
  object.currencyname = reader.readStringOrNull(offsets[12]);
  object.dateOrder = reader.readStringOrNull(offsets[13]);
  object.id = id;
  object.invoiceStatus = reader.readStringOrNull(offsets[14]);
  object.name = reader.readStringOrNull(offsets[15]);
  object.partnerId = reader.readLongOrNull(offsets[16]);
  object.partnerName = reader.readStringOrNull(offsets[17]);
  object.prepaymentPercent = reader.readDoubleOrNull(offsets[18]);
  object.serverId = reader.readLongOrNull(offsets[19]);
  object.state = reader.readStringOrNull(offsets[20]);
  object.userId = reader.readLongOrNull(offsets[21]);
  object.userName = reader.readStringOrNull(offsets[22]);
  return object;
}

P _quotationModelIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readDoubleOrNull(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readDoubleOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readLongOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readDoubleOrNull(offset)) as P;
    case 19:
      return (reader.readLongOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readLongOrNull(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _quotationModelIsarGetId(QuotationModelIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _quotationModelIsarGetLinks(
    QuotationModelIsar object) {
  return [];
}

void _quotationModelIsarAttach(
    IsarCollection<dynamic> col, Id id, QuotationModelIsar object) {
  object.id = id;
}

extension QuotationModelIsarQueryWhereSort
    on QueryBuilder<QuotationModelIsar, QuotationModelIsar, QWhere> {
  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension QuotationModelIsarQueryWhere
    on QueryBuilder<QuotationModelIsar, QuotationModelIsar, QWhereClause> {
  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterWhereClause>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterWhereClause>
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
}

extension QuotationModelIsarQueryFilter
    on QueryBuilder<QuotationModelIsar, QuotationModelIsar, QFilterCondition> {
  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityDateDeadlineIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityDateDeadline',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityDateDeadlineIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityDateDeadline',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityDateDeadlineEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityDateDeadline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityDateDeadlineGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityDateDeadline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityDateDeadlineLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityDateDeadline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityDateDeadlineBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityDateDeadline',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityDateDeadlineStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activityDateDeadline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityDateDeadlineEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activityDateDeadline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityDateDeadlineContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activityDateDeadline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityDateDeadlineMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activityDateDeadline',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityDateDeadlineIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityDateDeadline',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityDateDeadlineIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityDateDeadline',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityStateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityState',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityStateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityState',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityStateEqualTo(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityStateGreaterThan(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityStateLessThan(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityStateBetween(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityStateStartsWith(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityStateEndsWith(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityStateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activityState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityStateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activityState',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityStateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityState',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityStateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityState',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activitySummaryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activitySummary',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activitySummaryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activitySummary',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activitySummaryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activitySummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activitySummaryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activitySummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activitySummaryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activitySummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activitySummaryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activitySummary',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activitySummaryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activitySummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activitySummaryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activitySummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activitySummaryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activitySummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activitySummaryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activitySummary',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activitySummaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activitySummary',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activitySummaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activitySummary',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityTypeIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityTypeId',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityTypeIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityTypeId',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityTypeIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityTypeId',
        value: value,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityTypeIdGreaterThan(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityTypeIdLessThan(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityTypeIdBetween(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityTypeNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityTypeName',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityTypeNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityTypeName',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityTypeNameEqualTo(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityTypeNameGreaterThan(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityTypeNameLessThan(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityTypeNameBetween(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityTypeNameStartsWith(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityTypeNameEndsWith(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityTypeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activityTypeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityTypeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activityTypeName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityTypeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityTypeName',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityTypeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityTypeName',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityUserIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityUserId',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityUserIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityUserId',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityUserIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityUserId',
        value: value,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityUserIdGreaterThan(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityUserIdLessThan(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityUserIdBetween(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityUserNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityUserName',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityUserNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityUserName',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityUserNameEqualTo(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityUserNameGreaterThan(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityUserNameLessThan(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityUserNameBetween(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityUserNameStartsWith(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityUserNameEndsWith(
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityUserNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activityUserName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityUserNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activityUserName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityUserNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityUserName',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      activityUserNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityUserName',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      amountTaxIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'amountTax',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      amountTaxIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'amountTax',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      amountTotalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'amountTotal',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      amountTotalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'amountTotal',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      amountUntaxedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'amountUntaxed',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      amountUntaxedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'amountUntaxed',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencyIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currencyId',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencyIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currencyId',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencyIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currencyId',
        value: value,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencyRateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currencyRate',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencyRateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currencyRate',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencyRateEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currencyRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencyRateGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currencyRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencyRateLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currencyRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencyRateBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currencyRate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencynameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currencyname',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencynameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currencyname',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencynameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currencyname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencynameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currencyname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencynameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currencyname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencynameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currencyname',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencynameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currencyname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencynameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currencyname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencynameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currencyname',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencynameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currencyname',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencynameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currencyname',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      currencynameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currencyname',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      dateOrderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateOrder',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      dateOrderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateOrder',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      dateOrderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dateOrder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      dateOrderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dateOrder',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      dateOrderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateOrder',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      dateOrderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dateOrder',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      invoiceStatusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'invoiceStatus',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      invoiceStatusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'invoiceStatus',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      invoiceStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'invoiceStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      invoiceStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'invoiceStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      invoiceStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invoiceStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      invoiceStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'invoiceStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      partnerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'partnerId',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      partnerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'partnerId',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      partnerIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partnerId',
        value: value,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      partnerNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'partnerName',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      partnerNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'partnerName',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      partnerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'partnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      partnerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'partnerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      partnerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partnerName',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      partnerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'partnerName',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      prepaymentPercentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'prepaymentPercent',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      prepaymentPercentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'prepaymentPercent',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      prepaymentPercentEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prepaymentPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      prepaymentPercentGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prepaymentPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      prepaymentPercentLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prepaymentPercent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      prepaymentPercentBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prepaymentPercent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      serverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      serverIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      stateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'state',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      stateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'state',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      stateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      stateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'state',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      stateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      stateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'state',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      userIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      userNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userName',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      userNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userName',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
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

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      userNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      userNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      userNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userName',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterFilterCondition>
      userNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userName',
        value: '',
      ));
    });
  }
}

extension QuotationModelIsarQueryObject
    on QueryBuilder<QuotationModelIsar, QuotationModelIsar, QFilterCondition> {}

extension QuotationModelIsarQueryLinks
    on QueryBuilder<QuotationModelIsar, QuotationModelIsar, QFilterCondition> {}

extension QuotationModelIsarQuerySortBy
    on QueryBuilder<QuotationModelIsar, QuotationModelIsar, QSortBy> {
  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByActivityDateDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityDateDeadline', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByActivityDateDeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityDateDeadline', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByActivityState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityState', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByActivityStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityState', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByActivitySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activitySummary', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByActivitySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activitySummary', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByActivityTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeId', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByActivityTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeId', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByActivityTypeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeName', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByActivityTypeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeName', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByActivityUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserId', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByActivityUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserId', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByActivityUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserName', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByActivityUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserName', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByAmountTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTax', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByAmountTaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTax', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByAmountTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTotal', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByAmountTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTotal', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByAmountUntaxed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountUntaxed', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByAmountUntaxedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountUntaxed', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByCurrencyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyId', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByCurrencyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyId', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByCurrencyRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyRate', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByCurrencyRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyRate', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByCurrencyname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyname', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByCurrencynameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyname', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByDateOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOrder', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByDateOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOrder', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByInvoiceStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceStatus', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByInvoiceStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceStatus', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByPartnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerId', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByPartnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerId', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByPartnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByPartnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByPrepaymentPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prepaymentPercent', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByPrepaymentPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prepaymentPercent', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      sortByUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.desc);
    });
  }
}

extension QuotationModelIsarQuerySortThenBy
    on QueryBuilder<QuotationModelIsar, QuotationModelIsar, QSortThenBy> {
  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByActivityDateDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityDateDeadline', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByActivityDateDeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityDateDeadline', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByActivityState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityState', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByActivityStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityState', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByActivitySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activitySummary', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByActivitySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activitySummary', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByActivityTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeId', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByActivityTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeId', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByActivityTypeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeName', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByActivityTypeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeName', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByActivityUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserId', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByActivityUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserId', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByActivityUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserName', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByActivityUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserName', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByAmountTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTax', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByAmountTaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTax', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByAmountTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTotal', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByAmountTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTotal', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByAmountUntaxed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountUntaxed', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByAmountUntaxedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountUntaxed', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByCurrencyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyId', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByCurrencyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyId', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByCurrencyRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyRate', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByCurrencyRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyRate', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByCurrencyname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyname', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByCurrencynameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyname', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByDateOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOrder', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByDateOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOrder', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByInvoiceStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceStatus', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByInvoiceStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invoiceStatus', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByPartnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerId', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByPartnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerId', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByPartnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByPartnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partnerName', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByPrepaymentPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prepaymentPercent', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByPrepaymentPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prepaymentPercent', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.asc);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QAfterSortBy>
      thenByUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.desc);
    });
  }
}

extension QuotationModelIsarQueryWhereDistinct
    on QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct> {
  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByActivityDateDeadline({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityDateDeadline',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByActivityState({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityState',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByActivitySummary({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activitySummary',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByActivityTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityTypeId');
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByActivityTypeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityTypeName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByActivityUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityUserId');
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByActivityUserName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityUserName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByAmountTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountTax');
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByAmountTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountTotal');
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByAmountUntaxed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountUntaxed');
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByCurrencyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currencyId');
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByCurrencyRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currencyRate');
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByCurrencyname({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currencyname', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByDateOrder({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateOrder', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByInvoiceStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'invoiceStatus',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByPartnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partnerId');
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByPartnerName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partnerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByPrepaymentPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prepaymentPercent');
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId');
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByState({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'state', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }

  QueryBuilder<QuotationModelIsar, QuotationModelIsar, QDistinct>
      distinctByUserName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userName', caseSensitive: caseSensitive);
    });
  }
}

extension QuotationModelIsarQueryProperty
    on QueryBuilder<QuotationModelIsar, QuotationModelIsar, QQueryProperty> {
  QueryBuilder<QuotationModelIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<QuotationModelIsar, String?, QQueryOperations>
      activityDateDeadlineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityDateDeadline');
    });
  }

  QueryBuilder<QuotationModelIsar, String?, QQueryOperations>
      activityStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityState');
    });
  }

  QueryBuilder<QuotationModelIsar, String?, QQueryOperations>
      activitySummaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activitySummary');
    });
  }

  QueryBuilder<QuotationModelIsar, int?, QQueryOperations>
      activityTypeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityTypeId');
    });
  }

  QueryBuilder<QuotationModelIsar, String?, QQueryOperations>
      activityTypeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityTypeName');
    });
  }

  QueryBuilder<QuotationModelIsar, int?, QQueryOperations>
      activityUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityUserId');
    });
  }

  QueryBuilder<QuotationModelIsar, String?, QQueryOperations>
      activityUserNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityUserName');
    });
  }

  QueryBuilder<QuotationModelIsar, double?, QQueryOperations>
      amountTaxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountTax');
    });
  }

  QueryBuilder<QuotationModelIsar, double?, QQueryOperations>
      amountTotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountTotal');
    });
  }

  QueryBuilder<QuotationModelIsar, double?, QQueryOperations>
      amountUntaxedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountUntaxed');
    });
  }

  QueryBuilder<QuotationModelIsar, int?, QQueryOperations>
      currencyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currencyId');
    });
  }

  QueryBuilder<QuotationModelIsar, double?, QQueryOperations>
      currencyRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currencyRate');
    });
  }

  QueryBuilder<QuotationModelIsar, String?, QQueryOperations>
      currencynameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currencyname');
    });
  }

  QueryBuilder<QuotationModelIsar, String?, QQueryOperations>
      dateOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateOrder');
    });
  }

  QueryBuilder<QuotationModelIsar, String?, QQueryOperations>
      invoiceStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'invoiceStatus');
    });
  }

  QueryBuilder<QuotationModelIsar, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<QuotationModelIsar, int?, QQueryOperations> partnerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partnerId');
    });
  }

  QueryBuilder<QuotationModelIsar, String?, QQueryOperations>
      partnerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partnerName');
    });
  }

  QueryBuilder<QuotationModelIsar, double?, QQueryOperations>
      prepaymentPercentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prepaymentPercent');
    });
  }

  QueryBuilder<QuotationModelIsar, int?, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<QuotationModelIsar, String?, QQueryOperations> stateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'state');
    });
  }

  QueryBuilder<QuotationModelIsar, int?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<QuotationModelIsar, String?, QQueryOperations>
      userNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userName');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCurrencySymbolIsarCollection on Isar {
  IsarCollection<CurrencySymbolIsar> get currencySymbolIsars =>
      this.collection();
}

const CurrencySymbolIsarSchema = CollectionSchema(
  name: r'CurrencySymbolIsar',
  id: 5105413638845595318,
  properties: {
    r'currencyId': PropertySchema(
      id: 0,
      name: r'currencyId',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    ),
    r'symbol': PropertySchema(
      id: 2,
      name: r'symbol',
      type: IsarType.string,
    )
  },
  estimateSize: _currencySymbolIsarEstimateSize,
  serialize: _currencySymbolIsarSerialize,
  deserialize: _currencySymbolIsarDeserialize,
  deserializeProp: _currencySymbolIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _currencySymbolIsarGetId,
  getLinks: _currencySymbolIsarGetLinks,
  attach: _currencySymbolIsarAttach,
  version: '3.3.2',
);

int _currencySymbolIsarEstimateSize(
  CurrencySymbolIsar object,
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
    final value = object.symbol;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _currencySymbolIsarSerialize(
  CurrencySymbolIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.currencyId);
  writer.writeString(offsets[1], object.name);
  writer.writeString(offsets[2], object.symbol);
}

CurrencySymbolIsar _currencySymbolIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CurrencySymbolIsar();
  object.currencyId = reader.readLongOrNull(offsets[0]);
  object.id = id;
  object.name = reader.readStringOrNull(offsets[1]);
  object.symbol = reader.readStringOrNull(offsets[2]);
  return object;
}

P _currencySymbolIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _currencySymbolIsarGetId(CurrencySymbolIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _currencySymbolIsarGetLinks(
    CurrencySymbolIsar object) {
  return [];
}

void _currencySymbolIsarAttach(
    IsarCollection<dynamic> col, Id id, CurrencySymbolIsar object) {
  object.id = id;
}

extension CurrencySymbolIsarQueryWhereSort
    on QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QWhere> {
  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CurrencySymbolIsarQueryWhere
    on QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QWhereClause> {
  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterWhereClause>
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

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterWhereClause>
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
}

extension CurrencySymbolIsarQueryFilter
    on QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QFilterCondition> {
  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      currencyIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currencyId',
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      currencyIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currencyId',
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      currencyIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currencyId',
        value: value,
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
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

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
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

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
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

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
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

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
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

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
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

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
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

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
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

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
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

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
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

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
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

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
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

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      symbolIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'symbol',
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      symbolIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'symbol',
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      symbolEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'symbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      symbolGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'symbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      symbolLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'symbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      symbolBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'symbol',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      symbolStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'symbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      symbolEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'symbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      symbolContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'symbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      symbolMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'symbol',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      symbolIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'symbol',
        value: '',
      ));
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterFilterCondition>
      symbolIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'symbol',
        value: '',
      ));
    });
  }
}

extension CurrencySymbolIsarQueryObject
    on QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QFilterCondition> {}

extension CurrencySymbolIsarQueryLinks
    on QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QFilterCondition> {}

extension CurrencySymbolIsarQuerySortBy
    on QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QSortBy> {
  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterSortBy>
      sortByCurrencyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyId', Sort.asc);
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterSortBy>
      sortByCurrencyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyId', Sort.desc);
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterSortBy>
      sortBySymbol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbol', Sort.asc);
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterSortBy>
      sortBySymbolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbol', Sort.desc);
    });
  }
}

extension CurrencySymbolIsarQuerySortThenBy
    on QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QSortThenBy> {
  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterSortBy>
      thenByCurrencyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyId', Sort.asc);
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterSortBy>
      thenByCurrencyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyId', Sort.desc);
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterSortBy>
      thenBySymbol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbol', Sort.asc);
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QAfterSortBy>
      thenBySymbolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'symbol', Sort.desc);
    });
  }
}

extension CurrencySymbolIsarQueryWhereDistinct
    on QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QDistinct> {
  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QDistinct>
      distinctByCurrencyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currencyId');
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QDistinct>
      distinctBySymbol({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'symbol', caseSensitive: caseSensitive);
    });
  }
}

extension CurrencySymbolIsarQueryProperty
    on QueryBuilder<CurrencySymbolIsar, CurrencySymbolIsar, QQueryProperty> {
  QueryBuilder<CurrencySymbolIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CurrencySymbolIsar, int?, QQueryOperations>
      currencyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currencyId');
    });
  }

  QueryBuilder<CurrencySymbolIsar, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<CurrencySymbolIsar, String?, QQueryOperations> symbolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'symbol');
    });
  }
}
