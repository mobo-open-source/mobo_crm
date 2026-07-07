// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opportunity_model_isar_graph.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOpportunityModelIsarGraphCollection on Isar {
  IsarCollection<OpportunityModelIsarGraph> get opportunityModelIsarGraphs =>
      this.collection();
}

const OpportunityModelIsarGraphSchema = CollectionSchema(
  name: r'OpportunityModelIsarGraph',
  id: 6267944002825896581,
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
  estimateSize: _opportunityModelIsarGraphEstimateSize,
  serialize: _opportunityModelIsarGraphSerialize,
  deserialize: _opportunityModelIsarGraphDeserialize,
  deserializeProp: _opportunityModelIsarGraphDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _opportunityModelIsarGraphGetId,
  getLinks: _opportunityModelIsarGraphGetLinks,
  attach: _opportunityModelIsarGraphAttach,
  version: '3.3.2',
);

int _opportunityModelIsarGraphEstimateSize(
  OpportunityModelIsarGraph object,
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

void _opportunityModelIsarGraphSerialize(
  OpportunityModelIsarGraph object,
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

OpportunityModelIsarGraph _opportunityModelIsarGraphDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OpportunityModelIsarGraph();
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

P _opportunityModelIsarGraphDeserializeProp<P>(
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

Id _opportunityModelIsarGraphGetId(OpportunityModelIsarGraph object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _opportunityModelIsarGraphGetLinks(
    OpportunityModelIsarGraph object) {
  return [];
}

void _opportunityModelIsarGraphAttach(
    IsarCollection<dynamic> col, Id id, OpportunityModelIsarGraph object) {
  object.id = id;
}

extension OpportunityModelIsarGraphQueryWhereSort on QueryBuilder<
    OpportunityModelIsarGraph, OpportunityModelIsarGraph, QWhere> {
  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OpportunityModelIsarGraphQueryWhere on QueryBuilder<
    OpportunityModelIsarGraph, OpportunityModelIsarGraph, QWhereClause> {
  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
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

extension OpportunityModelIsarGraphQueryFilter on QueryBuilder<
    OpportunityModelIsarGraph, OpportunityModelIsarGraph, QFilterCondition> {
  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> countEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> dayCloseEqualTo(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> dayCloseGreaterThan(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> dayCloseLessThan(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> dayCloseBetween(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> expectedRevenueEqualTo(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> expectedRevenueGreaterThan(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> expectedRevenueLessThan(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> expectedRevenueBetween(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> probabilityEqualTo(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> probabilityGreaterThan(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> probabilityLessThan(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> probabilityBetween(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> proratedRevenueEqualTo(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> proratedRevenueGreaterThan(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> proratedRevenueLessThan(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> proratedRevenueBetween(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> recurringRevenueEqualTo(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> recurringRevenueGreaterThan(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> recurringRevenueLessThan(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> recurringRevenueBetween(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> recurringRevenueMonthlyEqualTo(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> recurringRevenueMonthlyGreaterThan(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> recurringRevenueMonthlyLessThan(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> recurringRevenueMonthlyBetween(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> recurringRevenueMonthlyProratedEqualTo(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> recurringRevenueMonthlyProratedGreaterThan(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> recurringRevenueMonthlyProratedLessThan(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> recurringRevenueMonthlyProratedBetween(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> recurringRevenueProratedEqualTo(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> recurringRevenueProratedGreaterThan(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> recurringRevenueProratedLessThan(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> recurringRevenueProratedBetween(
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> stageNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stageName',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> stageNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stageName',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
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

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> stageNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stageName',
        value: '',
      ));
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterFilterCondition> stageNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stageName',
        value: '',
      ));
    });
  }
}

extension OpportunityModelIsarGraphQueryObject on QueryBuilder<
    OpportunityModelIsarGraph, OpportunityModelIsarGraph, QFilterCondition> {}

extension OpportunityModelIsarGraphQueryLinks on QueryBuilder<
    OpportunityModelIsarGraph, OpportunityModelIsarGraph, QFilterCondition> {}

extension OpportunityModelIsarGraphQuerySortBy on QueryBuilder<
    OpportunityModelIsarGraph, OpportunityModelIsarGraph, QSortBy> {
  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByDayClose() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayClose', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByDayCloseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayClose', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByExpectedRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedRevenue', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByExpectedRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedRevenue', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByProbability() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probability', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByProbabilityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probability', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByProratedRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proratedRevenue', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByProratedRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proratedRevenue', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByRecurringRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenue', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByRecurringRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenue', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByRecurringRevenueMonthly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthly', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByRecurringRevenueMonthlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthly', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByRecurringRevenueMonthlyProrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthlyProrated', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByRecurringRevenueMonthlyProratedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthlyProrated', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByRecurringRevenueProrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueProrated', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByRecurringRevenueProratedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueProrated', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByStageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageName', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> sortByStageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageName', Sort.desc);
    });
  }
}

extension OpportunityModelIsarGraphQuerySortThenBy on QueryBuilder<
    OpportunityModelIsarGraph, OpportunityModelIsarGraph, QSortThenBy> {
  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByDayClose() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayClose', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByDayCloseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayClose', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByExpectedRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedRevenue', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByExpectedRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedRevenue', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByProbability() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probability', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByProbabilityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probability', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByProratedRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proratedRevenue', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByProratedRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proratedRevenue', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByRecurringRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenue', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByRecurringRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenue', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByRecurringRevenueMonthly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthly', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByRecurringRevenueMonthlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthly', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByRecurringRevenueMonthlyProrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthlyProrated', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByRecurringRevenueMonthlyProratedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueMonthlyProrated', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByRecurringRevenueProrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueProrated', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByRecurringRevenueProratedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringRevenueProrated', Sort.desc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByStageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageName', Sort.asc);
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph,
      QAfterSortBy> thenByStageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stageName', Sort.desc);
    });
  }
}

extension OpportunityModelIsarGraphQueryWhereDistinct on QueryBuilder<
    OpportunityModelIsarGraph, OpportunityModelIsarGraph, QDistinct> {
  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph, QDistinct>
      distinctByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'count');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph, QDistinct>
      distinctByDayClose() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayClose');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph, QDistinct>
      distinctByExpectedRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expectedRevenue');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph, QDistinct>
      distinctByProbability() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'probability');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph, QDistinct>
      distinctByProratedRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proratedRevenue');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph, QDistinct>
      distinctByRecurringRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurringRevenue');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph, QDistinct>
      distinctByRecurringRevenueMonthly() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurringRevenueMonthly');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph, QDistinct>
      distinctByRecurringRevenueMonthlyProrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurringRevenueMonthlyProrated');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph, QDistinct>
      distinctByRecurringRevenueProrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurringRevenueProrated');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, OpportunityModelIsarGraph, QDistinct>
      distinctByStageName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stageName', caseSensitive: caseSensitive);
    });
  }
}

extension OpportunityModelIsarGraphQueryProperty on QueryBuilder<
    OpportunityModelIsarGraph, OpportunityModelIsarGraph, QQueryProperty> {
  QueryBuilder<OpportunityModelIsarGraph, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, int, QQueryOperations>
      countProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'count');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, double, QQueryOperations>
      dayCloseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayClose');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, double, QQueryOperations>
      expectedRevenueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expectedRevenue');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, double, QQueryOperations>
      probabilityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'probability');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, double, QQueryOperations>
      proratedRevenueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proratedRevenue');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, double, QQueryOperations>
      recurringRevenueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurringRevenue');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, double, QQueryOperations>
      recurringRevenueMonthlyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurringRevenueMonthly');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, double, QQueryOperations>
      recurringRevenueMonthlyProratedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurringRevenueMonthlyProrated');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, double, QQueryOperations>
      recurringRevenueProratedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurringRevenueProrated');
    });
  }

  QueryBuilder<OpportunityModelIsarGraph, String?, QQueryOperations>
      stageNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stageName');
    });
  }
}
