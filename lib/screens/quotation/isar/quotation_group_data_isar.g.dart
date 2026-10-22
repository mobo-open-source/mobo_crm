// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_group_data_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetQuotationGroupDataIsarCollection on Isar {
  IsarCollection<QuotationGroupDataIsar> get quotationGroupDataIsars =>
      this.collection();
}

const QuotationGroupDataIsarSchema = CollectionSchema(
  name: r'QuotationGroupDataIsar',
  id: -2783122758979513991,
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
    r'count': PropertySchema(
      id: 3,
      name: r'count',
      type: IsarType.long,
    ),
    r'currencyRate': PropertySchema(
      id: 4,
      name: r'currencyRate',
      type: IsarType.double,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'prepaymentPercent': PropertySchema(
      id: 6,
      name: r'prepaymentPercent',
      type: IsarType.double,
    )
  },
  estimateSize: _quotationGroupDataIsarEstimateSize,
  serialize: _quotationGroupDataIsarSerialize,
  deserialize: _quotationGroupDataIsarDeserialize,
  deserializeProp: _quotationGroupDataIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _quotationGroupDataIsarGetId,
  getLinks: _quotationGroupDataIsarGetLinks,
  attach: _quotationGroupDataIsarAttach,
  version: '3.3.2',
);

int _quotationGroupDataIsarEstimateSize(
  QuotationGroupDataIsar object,
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
  return bytesCount;
}

void _quotationGroupDataIsarSerialize(
  QuotationGroupDataIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amountTax);
  writer.writeDouble(offsets[1], object.amountTotal);
  writer.writeDouble(offsets[2], object.amountUntaxed);
  writer.writeLong(offsets[3], object.count);
  writer.writeDouble(offsets[4], object.currencyRate);
  writer.writeString(offsets[5], object.name);
  writer.writeDouble(offsets[6], object.prepaymentPercent);
}

QuotationGroupDataIsar _quotationGroupDataIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = QuotationGroupDataIsar();
  object.amountTax = reader.readDouble(offsets[0]);
  object.amountTotal = reader.readDouble(offsets[1]);
  object.amountUntaxed = reader.readDouble(offsets[2]);
  object.count = reader.readLong(offsets[3]);
  object.currencyRate = reader.readDouble(offsets[4]);
  object.id = id;
  object.name = reader.readStringOrNull(offsets[5]);
  object.prepaymentPercent = reader.readDouble(offsets[6]);
  return object;
}

P _quotationGroupDataIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _quotationGroupDataIsarGetId(QuotationGroupDataIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _quotationGroupDataIsarGetLinks(
    QuotationGroupDataIsar object) {
  return [];
}

void _quotationGroupDataIsarAttach(
    IsarCollection<dynamic> col, Id id, QuotationGroupDataIsar object) {
  object.id = id;
}

extension QuotationGroupDataIsarQueryWhereSort
    on QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QWhere> {
  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension QuotationGroupDataIsarQueryWhere on QueryBuilder<
    QuotationGroupDataIsar, QuotationGroupDataIsar, QWhereClause> {
  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
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
}

extension QuotationGroupDataIsarQueryFilter on QueryBuilder<
    QuotationGroupDataIsar, QuotationGroupDataIsar, QFilterCondition> {
  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> amountTaxEqualTo(
    double value, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> amountTaxGreaterThan(
    double value, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> amountTaxLessThan(
    double value, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> amountTaxBetween(
    double lower,
    double upper, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> amountTotalEqualTo(
    double value, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> amountTotalGreaterThan(
    double value, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> amountTotalLessThan(
    double value, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> amountTotalBetween(
    double lower,
    double upper, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> amountUntaxedEqualTo(
    double value, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> amountUntaxedGreaterThan(
    double value, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> amountUntaxedLessThan(
    double value, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> amountUntaxedBetween(
    double lower,
    double upper, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> countEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> countGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> countLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> countBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'count',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> currencyRateEqualTo(
    double value, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> currencyRateGreaterThan(
    double value, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> currencyRateLessThan(
    double value, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> currencyRateBetween(
    double lower,
    double upper, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> prepaymentPercentEqualTo(
    double value, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> prepaymentPercentGreaterThan(
    double value, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> prepaymentPercentLessThan(
    double value, {
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

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar,
      QAfterFilterCondition> prepaymentPercentBetween(
    double lower,
    double upper, {
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
}

extension QuotationGroupDataIsarQueryObject on QueryBuilder<
    QuotationGroupDataIsar, QuotationGroupDataIsar, QFilterCondition> {}

extension QuotationGroupDataIsarQueryLinks on QueryBuilder<
    QuotationGroupDataIsar, QuotationGroupDataIsar, QFilterCondition> {}

extension QuotationGroupDataIsarQuerySortBy
    on QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QSortBy> {
  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      sortByAmountTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTax', Sort.asc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      sortByAmountTaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTax', Sort.desc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      sortByAmountTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTotal', Sort.asc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      sortByAmountTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTotal', Sort.desc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      sortByAmountUntaxed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountUntaxed', Sort.asc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      sortByAmountUntaxedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountUntaxed', Sort.desc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      sortByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      sortByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      sortByCurrencyRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyRate', Sort.asc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      sortByCurrencyRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyRate', Sort.desc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      sortByPrepaymentPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prepaymentPercent', Sort.asc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      sortByPrepaymentPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prepaymentPercent', Sort.desc);
    });
  }
}

extension QuotationGroupDataIsarQuerySortThenBy on QueryBuilder<
    QuotationGroupDataIsar, QuotationGroupDataIsar, QSortThenBy> {
  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      thenByAmountTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTax', Sort.asc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      thenByAmountTaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTax', Sort.desc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      thenByAmountTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTotal', Sort.asc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      thenByAmountTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountTotal', Sort.desc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      thenByAmountUntaxed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountUntaxed', Sort.asc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      thenByAmountUntaxedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountUntaxed', Sort.desc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      thenByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      thenByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      thenByCurrencyRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyRate', Sort.asc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      thenByCurrencyRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyRate', Sort.desc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      thenByPrepaymentPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prepaymentPercent', Sort.asc);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QAfterSortBy>
      thenByPrepaymentPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prepaymentPercent', Sort.desc);
    });
  }
}

extension QuotationGroupDataIsarQueryWhereDistinct
    on QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QDistinct> {
  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QDistinct>
      distinctByAmountTax() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountTax');
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QDistinct>
      distinctByAmountTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountTotal');
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QDistinct>
      distinctByAmountUntaxed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountUntaxed');
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QDistinct>
      distinctByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'count');
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QDistinct>
      distinctByCurrencyRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currencyRate');
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuotationGroupDataIsar, QuotationGroupDataIsar, QDistinct>
      distinctByPrepaymentPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prepaymentPercent');
    });
  }
}

extension QuotationGroupDataIsarQueryProperty on QueryBuilder<
    QuotationGroupDataIsar, QuotationGroupDataIsar, QQueryProperty> {
  QueryBuilder<QuotationGroupDataIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<QuotationGroupDataIsar, double, QQueryOperations>
      amountTaxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountTax');
    });
  }

  QueryBuilder<QuotationGroupDataIsar, double, QQueryOperations>
      amountTotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountTotal');
    });
  }

  QueryBuilder<QuotationGroupDataIsar, double, QQueryOperations>
      amountUntaxedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountUntaxed');
    });
  }

  QueryBuilder<QuotationGroupDataIsar, int, QQueryOperations> countProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'count');
    });
  }

  QueryBuilder<QuotationGroupDataIsar, double, QQueryOperations>
      currencyRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currencyRate');
    });
  }

  QueryBuilder<QuotationGroupDataIsar, String?, QQueryOperations>
      nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<QuotationGroupDataIsar, double, QQueryOperations>
      prepaymentPercentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prepaymentPercent');
    });
  }
}
