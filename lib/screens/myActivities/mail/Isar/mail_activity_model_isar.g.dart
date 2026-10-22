// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mail_activity_model_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMailActivityGroupIsarCollection on Isar {
  IsarCollection<MailActivityGroupIsar> get mailActivityGroupIsars =>
      this.collection();
}

const MailActivityGroupIsarSchema = CollectionSchema(
  name: r'MailActivityGroupIsar',
  id: -740955420630688737,
  properties: {
    r'icon': PropertySchema(
      id: 0,
      name: r'icon',
      type: IsarType.string,
    ),
    r'model': PropertySchema(
      id: 1,
      name: r'model',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'overdueCount': PropertySchema(
      id: 3,
      name: r'overdueCount',
      type: IsarType.long,
    ),
    r'plannedCount': PropertySchema(
      id: 4,
      name: r'plannedCount',
      type: IsarType.long,
    ),
    r'serverId': PropertySchema(
      id: 5,
      name: r'serverId',
      type: IsarType.long,
    ),
    r'todayCount': PropertySchema(
      id: 6,
      name: r'todayCount',
      type: IsarType.long,
    ),
    r'totalCount': PropertySchema(
      id: 7,
      name: r'totalCount',
      type: IsarType.long,
    )
  },
  estimateSize: _mailActivityGroupIsarEstimateSize,
  serialize: _mailActivityGroupIsarSerialize,
  deserialize: _mailActivityGroupIsarDeserialize,
  deserializeProp: _mailActivityGroupIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _mailActivityGroupIsarGetId,
  getLinks: _mailActivityGroupIsarGetLinks,
  attach: _mailActivityGroupIsarAttach,
  version: '3.3.2',
);

int _mailActivityGroupIsarEstimateSize(
  MailActivityGroupIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.icon;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.model;
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
  return bytesCount;
}

void _mailActivityGroupIsarSerialize(
  MailActivityGroupIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.icon);
  writer.writeString(offsets[1], object.model);
  writer.writeString(offsets[2], object.name);
  writer.writeLong(offsets[3], object.overdueCount);
  writer.writeLong(offsets[4], object.plannedCount);
  writer.writeLong(offsets[5], object.serverId);
  writer.writeLong(offsets[6], object.todayCount);
  writer.writeLong(offsets[7], object.totalCount);
}

MailActivityGroupIsar _mailActivityGroupIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MailActivityGroupIsar(
    icon: reader.readStringOrNull(offsets[0]),
    model: reader.readStringOrNull(offsets[1]),
    name: reader.readStringOrNull(offsets[2]),
    overdueCount: reader.readLongOrNull(offsets[3]),
    plannedCount: reader.readLongOrNull(offsets[4]),
    serverId: reader.readLongOrNull(offsets[5]),
    todayCount: reader.readLongOrNull(offsets[6]),
    totalCount: reader.readLongOrNull(offsets[7]),
  );
  object.id = id;
  return object;
}

P _mailActivityGroupIsarDeserializeProp<P>(
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
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _mailActivityGroupIsarGetId(MailActivityGroupIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mailActivityGroupIsarGetLinks(
    MailActivityGroupIsar object) {
  return [];
}

void _mailActivityGroupIsarAttach(
    IsarCollection<dynamic> col, Id id, MailActivityGroupIsar object) {
  object.id = id;
}

extension MailActivityGroupIsarQueryWhereSort
    on QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QWhere> {
  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MailActivityGroupIsarQueryWhere on QueryBuilder<MailActivityGroupIsar,
    MailActivityGroupIsar, QWhereClause> {
  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterWhereClause>
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

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterWhereClause>
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

extension MailActivityGroupIsarQueryFilter on QueryBuilder<
    MailActivityGroupIsar, MailActivityGroupIsar, QFilterCondition> {
  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> iconIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'icon',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> iconIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'icon',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> iconEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> iconGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> iconLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> iconBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'icon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> iconStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> iconEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
          QAfterFilterCondition>
      iconContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
          QAfterFilterCondition>
      iconMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'icon',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> iconIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'icon',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> iconIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'icon',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
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

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
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

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
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

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> modelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'model',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> modelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'model',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> modelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> modelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> modelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> modelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'model',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> modelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> modelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
          QAfterFilterCondition>
      modelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
          QAfterFilterCondition>
      modelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'model',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> modelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'model',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> modelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'model',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
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

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
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

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
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

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
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

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
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

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
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

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
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

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
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

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> overdueCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'overdueCount',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> overdueCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'overdueCount',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> overdueCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'overdueCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> overdueCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'overdueCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> overdueCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'overdueCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> overdueCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'overdueCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> plannedCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'plannedCount',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> plannedCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'plannedCount',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> plannedCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plannedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> plannedCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'plannedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> plannedCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'plannedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> plannedCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'plannedCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> serverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> serverIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
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

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
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

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
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

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> todayCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'todayCount',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> todayCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'todayCount',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> todayCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'todayCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> todayCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'todayCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> todayCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'todayCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> todayCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'todayCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> totalCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalCount',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> totalCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalCount',
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> totalCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> totalCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> totalCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar,
      QAfterFilterCondition> totalCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MailActivityGroupIsarQueryObject on QueryBuilder<
    MailActivityGroupIsar, MailActivityGroupIsar, QFilterCondition> {}

extension MailActivityGroupIsarQueryLinks on QueryBuilder<MailActivityGroupIsar,
    MailActivityGroupIsar, QFilterCondition> {}

extension MailActivityGroupIsarQuerySortBy
    on QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QSortBy> {
  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      sortByIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.asc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      sortByIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.desc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      sortByModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.asc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      sortByModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.desc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      sortByOverdueCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overdueCount', Sort.asc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      sortByOverdueCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overdueCount', Sort.desc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      sortByPlannedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedCount', Sort.asc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      sortByPlannedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedCount', Sort.desc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      sortByTodayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayCount', Sort.asc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      sortByTodayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayCount', Sort.desc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      sortByTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.asc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      sortByTotalCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.desc);
    });
  }
}

extension MailActivityGroupIsarQuerySortThenBy
    on QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QSortThenBy> {
  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      thenByIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.asc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      thenByIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.desc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      thenByModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.asc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      thenByModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.desc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      thenByOverdueCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overdueCount', Sort.asc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      thenByOverdueCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overdueCount', Sort.desc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      thenByPlannedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedCount', Sort.asc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      thenByPlannedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedCount', Sort.desc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      thenByTodayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayCount', Sort.asc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      thenByTodayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todayCount', Sort.desc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      thenByTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.asc);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QAfterSortBy>
      thenByTotalCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.desc);
    });
  }
}

extension MailActivityGroupIsarQueryWhereDistinct
    on QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QDistinct> {
  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QDistinct>
      distinctByIcon({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'icon', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QDistinct>
      distinctByModel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'model', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QDistinct>
      distinctByOverdueCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'overdueCount');
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QDistinct>
      distinctByPlannedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannedCount');
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QDistinct>
      distinctByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId');
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QDistinct>
      distinctByTodayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'todayCount');
    });
  }

  QueryBuilder<MailActivityGroupIsar, MailActivityGroupIsar, QDistinct>
      distinctByTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCount');
    });
  }
}

extension MailActivityGroupIsarQueryProperty on QueryBuilder<
    MailActivityGroupIsar, MailActivityGroupIsar, QQueryProperty> {
  QueryBuilder<MailActivityGroupIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MailActivityGroupIsar, String?, QQueryOperations>
      iconProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'icon');
    });
  }

  QueryBuilder<MailActivityGroupIsar, String?, QQueryOperations>
      modelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'model');
    });
  }

  QueryBuilder<MailActivityGroupIsar, String?, QQueryOperations>
      nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<MailActivityGroupIsar, int?, QQueryOperations>
      overdueCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overdueCount');
    });
  }

  QueryBuilder<MailActivityGroupIsar, int?, QQueryOperations>
      plannedCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannedCount');
    });
  }

  QueryBuilder<MailActivityGroupIsar, int?, QQueryOperations>
      serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<MailActivityGroupIsar, int?, QQueryOperations>
      todayCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'todayCount');
    });
  }

  QueryBuilder<MailActivityGroupIsar, int?, QQueryOperations>
      totalCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCount');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMailActivityIsarCollection on Isar {
  IsarCollection<MailActivityIsar> get mailActivityIsars => this.collection();
}

const MailActivityIsarSchema = CollectionSchema(
  name: r'MailActivityIsar',
  id: -5819158256914695817,
  properties: {
    r'activityId': PropertySchema(
      id: 0,
      name: r'activityId',
      type: IsarType.long,
    ),
    r'activityTypeId': PropertySchema(
      id: 1,
      name: r'activityTypeId',
      type: IsarType.string,
    ),
    r'activityTypeName': PropertySchema(
      id: 2,
      name: r'activityTypeName',
      type: IsarType.string,
    ),
    r'dateDeadline': PropertySchema(
      id: 3,
      name: r'dateDeadline',
      type: IsarType.string,
    ),
    r'groupId': PropertySchema(
      id: 4,
      name: r'groupId',
      type: IsarType.long,
    ),
    r'note': PropertySchema(
      id: 5,
      name: r'note',
      type: IsarType.string,
    ),
    r'resId': PropertySchema(
      id: 6,
      name: r'resId',
      type: IsarType.long,
    ),
    r'resModel': PropertySchema(
      id: 7,
      name: r'resModel',
      type: IsarType.string,
    ),
    r'resName': PropertySchema(
      id: 8,
      name: r'resName',
      type: IsarType.string,
    ),
    r'summary': PropertySchema(
      id: 9,
      name: r'summary',
      type: IsarType.string,
    ),
    r'userId': PropertySchema(
      id: 10,
      name: r'userId',
      type: IsarType.long,
    ),
    r'userName': PropertySchema(
      id: 11,
      name: r'userName',
      type: IsarType.string,
    )
  },
  estimateSize: _mailActivityIsarEstimateSize,
  serialize: _mailActivityIsarSerialize,
  deserialize: _mailActivityIsarDeserialize,
  deserializeProp: _mailActivityIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _mailActivityIsarGetId,
  getLinks: _mailActivityIsarGetLinks,
  attach: _mailActivityIsarAttach,
  version: '3.3.2',
);

int _mailActivityIsarEstimateSize(
  MailActivityIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.activityTypeId;
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
    final value = object.dateDeadline;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.resModel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.resName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.summary;
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

void _mailActivityIsarSerialize(
  MailActivityIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.activityId);
  writer.writeString(offsets[1], object.activityTypeId);
  writer.writeString(offsets[2], object.activityTypeName);
  writer.writeString(offsets[3], object.dateDeadline);
  writer.writeLong(offsets[4], object.groupId);
  writer.writeString(offsets[5], object.note);
  writer.writeLong(offsets[6], object.resId);
  writer.writeString(offsets[7], object.resModel);
  writer.writeString(offsets[8], object.resName);
  writer.writeString(offsets[9], object.summary);
  writer.writeLong(offsets[10], object.userId);
  writer.writeString(offsets[11], object.userName);
}

MailActivityIsar _mailActivityIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MailActivityIsar(
    activityId: reader.readLongOrNull(offsets[0]),
    activityTypeId: reader.readStringOrNull(offsets[1]),
    activityTypeName: reader.readStringOrNull(offsets[2]),
    dateDeadline: reader.readStringOrNull(offsets[3]),
    groupId: reader.readLongOrNull(offsets[4]),
    note: reader.readStringOrNull(offsets[5]),
    resId: reader.readLongOrNull(offsets[6]),
    resModel: reader.readStringOrNull(offsets[7]),
    resName: reader.readStringOrNull(offsets[8]),
    summary: reader.readStringOrNull(offsets[9]),
    userId: reader.readLongOrNull(offsets[10]),
    userName: reader.readStringOrNull(offsets[11]),
  );
  object.id = id;
  return object;
}

P _mailActivityIsarDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _mailActivityIsarGetId(MailActivityIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mailActivityIsarGetLinks(MailActivityIsar object) {
  return [];
}

void _mailActivityIsarAttach(
    IsarCollection<dynamic> col, Id id, MailActivityIsar object) {
  object.id = id;
}

extension MailActivityIsarQueryWhereSort
    on QueryBuilder<MailActivityIsar, MailActivityIsar, QWhere> {
  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MailActivityIsarQueryWhere
    on QueryBuilder<MailActivityIsar, MailActivityIsar, QWhereClause> {
  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterWhereClause>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterWhereClause> idBetween(
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

extension MailActivityIsarQueryFilter
    on QueryBuilder<MailActivityIsar, MailActivityIsar, QFilterCondition> {
  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityId',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityId',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityId',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityId',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityId',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityTypeIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityTypeId',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityTypeIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityTypeId',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityTypeIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityTypeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityTypeIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityTypeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityTypeIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityTypeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityTypeIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityTypeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityTypeIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activityTypeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityTypeIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activityTypeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityTypeIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activityTypeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityTypeIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activityTypeId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityTypeIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityTypeId',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityTypeIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityTypeId',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityTypeNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityTypeName',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityTypeNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityTypeName',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityTypeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activityTypeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityTypeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activityTypeName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityTypeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityTypeName',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      activityTypeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityTypeName',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      dateDeadlineIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateDeadline',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      dateDeadlineIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateDeadline',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      dateDeadlineEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateDeadline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      dateDeadlineGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateDeadline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      dateDeadlineLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateDeadline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      dateDeadlineBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateDeadline',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      dateDeadlineStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dateDeadline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      dateDeadlineEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dateDeadline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      dateDeadlineContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dateDeadline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      dateDeadlineMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dateDeadline',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      dateDeadlineIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateDeadline',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      dateDeadlineIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dateDeadline',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      groupIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'groupId',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      groupIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'groupId',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      groupIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      groupIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupId',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      groupIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupId',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      groupIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      noteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      noteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'resId',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'resId',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resId',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resId',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resId',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resModelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'resModel',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resModelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'resModel',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resModelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resModelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resModelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resModelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resModel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resModelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'resModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resModelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'resModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resModelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'resModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resModelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'resModel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resModelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resModel',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resModelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'resModel',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'resName',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'resName',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'resName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'resName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'resName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'resName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resName',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      resNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'resName',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      summaryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'summary',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      summaryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'summary',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      summaryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      summaryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      summaryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      summaryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'summary',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      summaryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      summaryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      summaryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      summaryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'summary',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      summaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summary',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      summaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'summary',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      userIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      userNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userName',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      userNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userName',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
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

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      userNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      userNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      userNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userName',
        value: '',
      ));
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterFilterCondition>
      userNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userName',
        value: '',
      ));
    });
  }
}

extension MailActivityIsarQueryObject
    on QueryBuilder<MailActivityIsar, MailActivityIsar, QFilterCondition> {}

extension MailActivityIsarQueryLinks
    on QueryBuilder<MailActivityIsar, MailActivityIsar, QFilterCondition> {}

extension MailActivityIsarQuerySortBy
    on QueryBuilder<MailActivityIsar, MailActivityIsar, QSortBy> {
  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByActivityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityId', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByActivityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityId', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByActivityTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeId', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByActivityTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeId', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByActivityTypeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeName', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByActivityTypeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeName', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByDateDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDeadline', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByDateDeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDeadline', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy> sortByResId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resId', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByResIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resId', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByResModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resModel', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByResModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resModel', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByResName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resName', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByResNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resName', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortBySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortBySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      sortByUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.desc);
    });
  }
}

extension MailActivityIsarQuerySortThenBy
    on QueryBuilder<MailActivityIsar, MailActivityIsar, QSortThenBy> {
  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByActivityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityId', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByActivityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityId', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByActivityTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeId', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByActivityTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeId', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByActivityTypeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeName', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByActivityTypeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeName', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByDateDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDeadline', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByDateDeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateDeadline', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy> thenByResId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resId', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByResIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resId', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByResModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resModel', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByResModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resModel', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByResName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resName', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByResNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resName', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenBySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenBySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.asc);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QAfterSortBy>
      thenByUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.desc);
    });
  }
}

extension MailActivityIsarQueryWhereDistinct
    on QueryBuilder<MailActivityIsar, MailActivityIsar, QDistinct> {
  QueryBuilder<MailActivityIsar, MailActivityIsar, QDistinct>
      distinctByActivityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityId');
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QDistinct>
      distinctByActivityTypeId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityTypeId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QDistinct>
      distinctByActivityTypeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityTypeName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QDistinct>
      distinctByDateDeadline({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateDeadline', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QDistinct>
      distinctByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId');
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QDistinct>
      distinctByResId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resId');
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QDistinct>
      distinctByResModel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resModel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QDistinct> distinctByResName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QDistinct> distinctBySummary(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'summary', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QDistinct>
      distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }

  QueryBuilder<MailActivityIsar, MailActivityIsar, QDistinct>
      distinctByUserName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userName', caseSensitive: caseSensitive);
    });
  }
}

extension MailActivityIsarQueryProperty
    on QueryBuilder<MailActivityIsar, MailActivityIsar, QQueryProperty> {
  QueryBuilder<MailActivityIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MailActivityIsar, int?, QQueryOperations> activityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityId');
    });
  }

  QueryBuilder<MailActivityIsar, String?, QQueryOperations>
      activityTypeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityTypeId');
    });
  }

  QueryBuilder<MailActivityIsar, String?, QQueryOperations>
      activityTypeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityTypeName');
    });
  }

  QueryBuilder<MailActivityIsar, String?, QQueryOperations>
      dateDeadlineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateDeadline');
    });
  }

  QueryBuilder<MailActivityIsar, int?, QQueryOperations> groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<MailActivityIsar, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<MailActivityIsar, int?, QQueryOperations> resIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resId');
    });
  }

  QueryBuilder<MailActivityIsar, String?, QQueryOperations> resModelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resModel');
    });
  }

  QueryBuilder<MailActivityIsar, String?, QQueryOperations> resNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resName');
    });
  }

  QueryBuilder<MailActivityIsar, String?, QQueryOperations> summaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'summary');
    });
  }

  QueryBuilder<MailActivityIsar, int?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<MailActivityIsar, String?, QQueryOperations> userNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userName');
    });
  }
}
