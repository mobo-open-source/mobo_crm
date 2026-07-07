// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lead_model_isar_graph.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLeadModelIsarGraphCollection on Isar {
  IsarCollection<LeadModelIsarGraph> get leadModelIsarGraphs =>
      this.collection();
}

const LeadModelIsarGraphSchema = CollectionSchema(
  name: r'LeadModelIsarGraph',
  id: -3173498666871293540,
  properties: {
    r'count': PropertySchema(
      id: 0,
      name: r'count',
      type: IsarType.long,
    ),
    r'dayClose': PropertySchema(
      id: 1,
      name: r'dayClose',
      type: IsarType.double,
    ),
    r'expectedRevenue': PropertySchema(
      id: 2,
      name: r'expectedRevenue',
      type: IsarType.double,
    ),
    r'probability': PropertySchema(
      id: 3,
      name: r'probability',
      type: IsarType.double,
    ),
    r'proratedRevenue': PropertySchema(
      id: 4,
      name: r'proratedRevenue',
      type: IsarType.double,
    ),
    r'recurringRevenue': PropertySchema(
      id: 5,
      name: r'recurringRevenue',
      type: IsarType.double,
    ),
    r'recurringRevenueMonthly': PropertySchema(
      id: 6,
      name: r'recurringRevenueMonthly',
      type: IsarType.double,
    ),
    r'recurringRevenueMonthlyProrated': PropertySchema(
      id: 7,
      name: r'recurringRevenueMonthlyProrated',
      type: IsarType.double,
    ),
    r'recurringRevenueProrated': PropertySchema(
      id: 8,
      name: r'recurringRevenueProrated',
      type: IsarType.double,
    ),
    r'stageName': PropertySchema(
      id: 9,
      name: r'stageName',
      type: IsarType.string,
    )
  },
  estimateSize: _leadModelIsarGraphEstimateSize,
  serialize: _leadModelIsarGraphSerialize,
  deserialize: _leadModelIsarGraphDeserialize,
  deserializeProp: _leadModelIsarGraphDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _leadModelIsarGraphGetId,
  getLinks: _leadModelIsarGraphGetLinks,
  attach: _leadModelIsarGraphAttach,
  version: '3.3.2',
);

int _leadModelIsarGraphEstimateSize(
  LeadModelIsarGraph object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.stageName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _leadModelIsarGraphSerialize(
  LeadModelIsarGraph object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.count);
  writer.writeDouble(offsets[1], object.dayClose);
  writer.writeDouble(offsets[2], object.expectedRevenue);
  writer.writeDouble(offsets[3], object.probability);
  writer.writeDouble(offsets[4], object.proratedRevenue);
  writer.writeDouble(offsets[5], object.recurringRevenue);
  writer.writeDouble(offsets[6], object.recurringRevenueMonthly);
  writer.writeDouble(offsets[7], object.recurringRevenueMonthlyProrated);
  writer.writeDouble(offsets[8], object.recurringRevenueProrated);
  writer.writeString(offsets[9], object.stageName);
}

LeadModelIsarGraph _leadModelIsarGraphDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LeadModelIsarGraph();
  object.count = reader.readLong(offsets[0]);
  object.dayClose = reader.readDouble(offsets[1]);
  object.expectedRevenue = reader.readDouble(offsets[2]);
  object.id = id;
  object.probability = reader.readDouble(offsets[3]);
  object.proratedRevenue = reader.readDouble(offsets[4]);
  object.recurringRevenue = reader.readDouble(offsets[5]);
  object.recurringRevenueMonthly = reader.readDouble(offsets[6]);
  object.recurringRevenueMonthlyProrated = reader.readDouble(offsets[7]);
  object.recurringRevenueProrated = reader.readDouble(offsets[8]);
  object.stageName = reader.readStringOrNull(offsets[9]);
  return object;
}

P _leadModelIsarGraphDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _leadModelIsarGraphGetId(LeadModelIsarGraph object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _leadModelIsarGraphGetLinks(
    LeadModelIsarGraph object) {
  return [];
}

void _leadModelIsarGraphAttach(
    IsarCollection<dynamic> col, Id id, LeadModelIsarGraph object) {
  object.id = id;
}

extension LeadModelIsarGraphQueryWhereSort
    on QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QWhere> {
  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LeadModelIsarGraphQueryWhere
    on QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QWhereClause> {
  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterWhereClause>
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterWhereClause>
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

extension LeadModelIsarGraphQueryFilter
    on QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QFilterCondition> {
  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      countEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      countGreaterThan(
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      countLessThan(
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      countBetween(
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      dayCloseEqualTo(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      dayCloseGreaterThan(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      dayCloseLessThan(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      dayCloseBetween(
    double lower,
    double upper, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      expectedRevenueEqualTo(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      expectedRevenueGreaterThan(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      expectedRevenueLessThan(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      expectedRevenueBetween(
    double lower,
    double upper, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      probabilityEqualTo(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      probabilityGreaterThan(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      probabilityLessThan(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      probabilityBetween(
    double lower,
    double upper, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      proratedRevenueEqualTo(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      proratedRevenueGreaterThan(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      proratedRevenueLessThan(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      proratedRevenueBetween(
    double lower,
    double upper, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      recurringRevenueEqualTo(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      recurringRevenueGreaterThan(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      recurringRevenueLessThan(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      recurringRevenueBetween(
    double lower,
    double upper, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      recurringRevenueMonthlyEqualTo(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      recurringRevenueMonthlyGreaterThan(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      recurringRevenueMonthlyLessThan(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      recurringRevenueMonthlyBetween(
    double lower,
    double upper, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      recurringRevenueMonthlyProratedEqualTo(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      recurringRevenueMonthlyProratedGreaterThan(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      recurringRevenueMonthlyProratedLessThan(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      recurringRevenueMonthlyProratedBetween(
    double lower,
    double upper, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      recurringRevenueProratedEqualTo(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      recurringRevenueProratedGreaterThan(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      recurringRevenueProratedLessThan(
    double value, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      recurringRevenueProratedBetween(
    double lower,
    double upper, {
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      stageNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stageName',
      ));
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      stageNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stageName',
      ));
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      stageNameEqualTo(
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      stageNameGreaterThan(
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      stageNameLessThan(
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      stageNameBetween(
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      stageNameStartsWith(
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      stageNameEndsWith(
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

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      stageNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      stageNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stageName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      stageNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stageName',
        value: '',
      ));
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterFilterCondition>
      stageNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stageName',
        value: '',
      ));
    });
  }
}

extension LeadModelIsarGraphQueryObject
    on QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QFilterCondition> {}

extension LeadModelIsarGraphQueryLinks
    on QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QFilterCondition> {}

extension LeadModelIsarGraphQuerySortBy
    on QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QSortBy> {
  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByDayClose() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayClose', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByDayCloseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayClose', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByExpectedRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedRevenue', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByExpectedRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedRevenue', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByProbability() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probability', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByProbabilityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probability', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByProratedRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proratedRevenue', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByProratedRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proratedRevenue', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByRecurringRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenue', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByRecurringRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenue', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByRecurringRevenueMonthly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthly', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByRecurringRevenueMonthlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthly', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByRecurringRevenueMonthlyProrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthlyProrated', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByRecurringRevenueMonthlyProratedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthlyProrated', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByRecurringRevenueProrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueProrated', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByRecurringRevenueProratedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueProrated', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByStageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageName', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      sortByStageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageName', Sort.desc);
    });
  }
}

extension LeadModelIsarGraphQuerySortThenBy
    on QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QSortThenBy> {
  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByDayClose() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayClose', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByDayCloseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayClose', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByExpectedRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedRevenue', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByExpectedRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedRevenue', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByProbability() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probability', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByProbabilityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probability', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByProratedRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proratedRevenue', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByProratedRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proratedRevenue', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByRecurringRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenue', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByRecurringRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenue', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByRecurringRevenueMonthly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthly', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByRecurringRevenueMonthlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthly', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByRecurringRevenueMonthlyProrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthlyProrated', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByRecurringRevenueMonthlyProratedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthlyProrated', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByRecurringRevenueProrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueProrated', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByRecurringRevenueProratedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueProrated', Sort.desc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByStageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageName', Sort.asc);
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QAfterSortBy>
      thenByStageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageName', Sort.desc);
    });
  }
}

extension LeadModelIsarGraphQueryWhereDistinct
    on QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QDistinct> {
  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QDistinct>
      distinctByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'count');
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QDistinct>
      distinctByDayClose() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayClose');
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QDistinct>
      distinctByExpectedRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expectedRevenue');
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QDistinct>
      distinctByProbability() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'probability');
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QDistinct>
      distinctByProratedRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proratedRevenue');
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QDistinct>
      distinctByRecurringRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurringRevenue');
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QDistinct>
      distinctByRecurringRevenueMonthly() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurringRevenueMonthly');
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QDistinct>
      distinctByRecurringRevenueMonthlyProrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurringRevenueMonthlyProrated');
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QDistinct>
      distinctByRecurringRevenueProrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurringRevenueProrated');
    });
  }

  QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QDistinct>
      distinctByStageName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stageName', caseSensitive: caseSensitive);
    });
  }
}

extension LeadModelIsarGraphQueryProperty
    on QueryBuilder<LeadModelIsarGraph, LeadModelIsarGraph, QQueryProperty> {
  QueryBuilder<LeadModelIsarGraph, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LeadModelIsarGraph, int, QQueryOperations> countProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'count');
    });
  }

  QueryBuilder<LeadModelIsarGraph, double, QQueryOperations>
      dayCloseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayClose');
    });
  }

  QueryBuilder<LeadModelIsarGraph, double, QQueryOperations>
      expectedRevenueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expectedRevenue');
    });
  }

  QueryBuilder<LeadModelIsarGraph, double, QQueryOperations>
      probabilityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'probability');
    });
  }

  QueryBuilder<LeadModelIsarGraph, double, QQueryOperations>
      proratedRevenueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proratedRevenue');
    });
  }

  QueryBuilder<LeadModelIsarGraph, double, QQueryOperations>
      recurringRevenueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurringRevenue');
    });
  }

  QueryBuilder<LeadModelIsarGraph, double, QQueryOperations>
      recurringRevenueMonthlyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurringRevenueMonthly');
    });
  }

  QueryBuilder<LeadModelIsarGraph, double, QQueryOperations>
      recurringRevenueMonthlyProratedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurringRevenueMonthlyProrated');
    });
  }

  QueryBuilder<LeadModelIsarGraph, double, QQueryOperations>
      recurringRevenueProratedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurringRevenueProrated');
    });
  }

  QueryBuilder<LeadModelIsarGraph, String?, QQueryOperations>
      stageNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stageName');
    });
  }
}
