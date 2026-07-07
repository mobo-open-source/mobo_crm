// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_list_data_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCustomerListDataIsarCollection on Isar {
  IsarCollection<CustomerListDataIsar> get customerListDataIsars =>
      this.collection();
}

const CustomerListDataIsarSchema = CollectionSchema(
  name: r'CustomerListDataIsar',
  id: 3625027311678810519,
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
    r'activityTypeIcon': PropertySchema(
      id: 3,
      name: r'activityTypeIcon',
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
    r'categoryValues': PropertySchema(
      id: 8,
      name: r'categoryValues',
      type: IsarType.stringList,
    ),
    r'city': PropertySchema(
      id: 9,
      name: r'city',
      type: IsarType.string,
    ),
    r'commercialPartnerId': PropertySchema(
      id: 10,
      name: r'commercialPartnerId',
      type: IsarType.long,
    ),
    r'commercialPartnerName': PropertySchema(
      id: 11,
      name: r'commercialPartnerName',
      type: IsarType.string,
    ),
    r'companyDisplayName': PropertySchema(
      id: 12,
      name: r'companyDisplayName',
      type: IsarType.string,
    ),
    r'companyId': PropertySchema(
      id: 13,
      name: r'companyId',
      type: IsarType.long,
    ),
    r'companyName': PropertySchema(
      id: 14,
      name: r'companyName',
      type: IsarType.string,
    ),
    r'companyType': PropertySchema(
      id: 15,
      name: r'companyType',
      type: IsarType.string,
    ),
    r'countryId': PropertySchema(
      id: 16,
      name: r'countryId',
      type: IsarType.long,
    ),
    r'countryName': PropertySchema(
      id: 17,
      name: r'countryName',
      type: IsarType.string,
    ),
    r'customerRank': PropertySchema(
      id: 18,
      name: r'customerRank',
      type: IsarType.long,
    ),
    r'email': PropertySchema(
      id: 19,
      name: r'email',
      type: IsarType.string,
    ),
    r'function': PropertySchema(
      id: 20,
      name: r'function',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 21,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'isCompany': PropertySchema(
      id: 22,
      name: r'isCompany',
      type: IsarType.bool,
    ),
    r'meetingCount': PropertySchema(
      id: 23,
      name: r'meetingCount',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 24,
      name: r'name',
      type: IsarType.string,
    ),
    r'opportunityCount': PropertySchema(
      id: 25,
      name: r'opportunityCount',
      type: IsarType.long,
    ),
    r'phone': PropertySchema(
      id: 26,
      name: r'phone',
      type: IsarType.string,
    ),
    r'saleOrderCount': PropertySchema(
      id: 27,
      name: r'saleOrderCount',
      type: IsarType.long,
    ),
    r'serverId': PropertySchema(
      id: 28,
      name: r'serverId',
      type: IsarType.long,
    ),
    r'stateId': PropertySchema(
      id: 29,
      name: r'stateId',
      type: IsarType.long,
    ),
    r'stateName': PropertySchema(
      id: 30,
      name: r'stateName',
      type: IsarType.string,
    ),
    r'supplierRank': PropertySchema(
      id: 31,
      name: r'supplierRank',
      type: IsarType.long,
    )
  },
  estimateSize: _customerListDataIsarEstimateSize,
  serialize: _customerListDataIsarSerialize,
  deserialize: _customerListDataIsarDeserialize,
  deserializeProp: _customerListDataIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _customerListDataIsarGetId,
  getLinks: _customerListDataIsarGetLinks,
  attach: _customerListDataIsarAttach,
  version: '3.3.2',
);

int _customerListDataIsarEstimateSize(
  CustomerListDataIsar object,
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
    final value = object.activityTypeIcon;
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
    final list = object.categoryValues;
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
    final value = object.city;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.commercialPartnerName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.companyDisplayName;
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
    final value = object.companyType;
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
    final value = object.email;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.function;
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
    final value = object.phone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.stateName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _customerListDataIsarSerialize(
  CustomerListDataIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.activityDateDeadline);
  writer.writeString(offsets[1], object.activityState);
  writer.writeString(offsets[2], object.activitySummary);
  writer.writeString(offsets[3], object.activityTypeIcon);
  writer.writeLong(offsets[4], object.activityTypeId);
  writer.writeString(offsets[5], object.activityTypeName);
  writer.writeLong(offsets[6], object.activityUserId);
  writer.writeString(offsets[7], object.activityUserName);
  writer.writeStringList(offsets[8], object.categoryValues);
  writer.writeString(offsets[9], object.city);
  writer.writeLong(offsets[10], object.commercialPartnerId);
  writer.writeString(offsets[11], object.commercialPartnerName);
  writer.writeString(offsets[12], object.companyDisplayName);
  writer.writeLong(offsets[13], object.companyId);
  writer.writeString(offsets[14], object.companyName);
  writer.writeString(offsets[15], object.companyType);
  writer.writeLong(offsets[16], object.countryId);
  writer.writeString(offsets[17], object.countryName);
  writer.writeLong(offsets[18], object.customerRank);
  writer.writeString(offsets[19], object.email);
  writer.writeString(offsets[20], object.function);
  writer.writeBool(offsets[21], object.isActive);
  writer.writeBool(offsets[22], object.isCompany);
  writer.writeLong(offsets[23], object.meetingCount);
  writer.writeString(offsets[24], object.name);
  writer.writeLong(offsets[25], object.opportunityCount);
  writer.writeString(offsets[26], object.phone);
  writer.writeLong(offsets[27], object.saleOrderCount);
  writer.writeLong(offsets[28], object.serverId);
  writer.writeLong(offsets[29], object.stateId);
  writer.writeString(offsets[30], object.stateName);
  writer.writeLong(offsets[31], object.supplierRank);
}

CustomerListDataIsar _customerListDataIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CustomerListDataIsar();
  object.activityDateDeadline = reader.readStringOrNull(offsets[0]);
  object.activityState = reader.readStringOrNull(offsets[1]);
  object.activitySummary = reader.readStringOrNull(offsets[2]);
  object.activityTypeIcon = reader.readStringOrNull(offsets[3]);
  object.activityTypeId = reader.readLongOrNull(offsets[4]);
  object.activityTypeName = reader.readStringOrNull(offsets[5]);
  object.activityUserId = reader.readLongOrNull(offsets[6]);
  object.activityUserName = reader.readStringOrNull(offsets[7]);
  object.categoryValues = reader.readStringList(offsets[8]);
  object.city = reader.readStringOrNull(offsets[9]);
  object.commercialPartnerId = reader.readLongOrNull(offsets[10]);
  object.commercialPartnerName = reader.readStringOrNull(offsets[11]);
  object.companyDisplayName = reader.readStringOrNull(offsets[12]);
  object.companyId = reader.readLongOrNull(offsets[13]);
  object.companyName = reader.readStringOrNull(offsets[14]);
  object.companyType = reader.readStringOrNull(offsets[15]);
  object.countryId = reader.readLongOrNull(offsets[16]);
  object.countryName = reader.readStringOrNull(offsets[17]);
  object.customerRank = reader.readLongOrNull(offsets[18]);
  object.email = reader.readStringOrNull(offsets[19]);
  object.function = reader.readStringOrNull(offsets[20]);
  object.id = id;
  object.isActive = reader.readBoolOrNull(offsets[21]);
  object.isCompany = reader.readBoolOrNull(offsets[22]);
  object.meetingCount = reader.readLongOrNull(offsets[23]);
  object.name = reader.readStringOrNull(offsets[24]);
  object.opportunityCount = reader.readLongOrNull(offsets[25]);
  object.phone = reader.readStringOrNull(offsets[26]);
  object.saleOrderCount = reader.readLongOrNull(offsets[27]);
  object.serverId = reader.readLongOrNull(offsets[28]);
  object.stateId = reader.readLongOrNull(offsets[29]);
  object.stateName = reader.readStringOrNull(offsets[30]);
  object.supplierRank = reader.readLongOrNull(offsets[31]);
  return object;
}

P _customerListDataIsarDeserializeProp<P>(
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
      return (reader.readStringList(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readLongOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readLongOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readLongOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readBoolOrNull(offset)) as P;
    case 22:
      return (reader.readBoolOrNull(offset)) as P;
    case 23:
      return (reader.readLongOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readLongOrNull(offset)) as P;
    case 26:
      return (reader.readStringOrNull(offset)) as P;
    case 27:
      return (reader.readLongOrNull(offset)) as P;
    case 28:
      return (reader.readLongOrNull(offset)) as P;
    case 29:
      return (reader.readLongOrNull(offset)) as P;
    case 30:
      return (reader.readStringOrNull(offset)) as P;
    case 31:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _customerListDataIsarGetId(CustomerListDataIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _customerListDataIsarGetLinks(
    CustomerListDataIsar object) {
  return [];
}

void _customerListDataIsarAttach(
    IsarCollection<dynamic> col, Id id, CustomerListDataIsar object) {
  object.id = id;
}

extension CustomerListDataIsarQueryWhereSort
    on QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QWhere> {
  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CustomerListDataIsarQueryWhere
    on QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QWhereClause> {
  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterWhereClause>
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterWhereClause>
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

extension CustomerListDataIsarQueryFilter on QueryBuilder<CustomerListDataIsar,
    CustomerListDataIsar, QFilterCondition> {
  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityDateDeadlineIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityDateDeadline',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityDateDeadlineIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityDateDeadline',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityDateDeadlineEqualTo(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityDateDeadlineGreaterThan(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityDateDeadlineLessThan(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityDateDeadlineBetween(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityDateDeadlineStartsWith(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityDateDeadlineEndsWith(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      activityDateDeadlineContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activityDateDeadline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      activityDateDeadlineMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activityDateDeadline',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityDateDeadlineIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityDateDeadline',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityDateDeadlineIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityDateDeadline',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityStateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityState',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityStateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityState',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityStateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityState',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityStateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityState',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activitySummaryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activitySummary',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activitySummaryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activitySummary',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activitySummaryEqualTo(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activitySummaryGreaterThan(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activitySummaryLessThan(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activitySummaryBetween(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activitySummaryStartsWith(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activitySummaryEndsWith(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      activitySummaryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activitySummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      activitySummaryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activitySummary',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activitySummaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activitySummary',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activitySummaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activitySummary',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityTypeIconIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityTypeIcon',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityTypeIconIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityTypeIcon',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityTypeIconEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityTypeIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityTypeIconGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityTypeIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityTypeIconLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityTypeIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityTypeIconBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityTypeIcon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityTypeIconStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activityTypeIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityTypeIconEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activityTypeIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      activityTypeIconContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activityTypeIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      activityTypeIconMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activityTypeIcon',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityTypeIconIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityTypeIcon',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityTypeIconIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityTypeIcon',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityTypeIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityTypeId',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityTypeIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityTypeId',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityTypeIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityTypeId',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityTypeNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityTypeName',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityTypeNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityTypeName',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityTypeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityTypeName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityTypeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityTypeName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityUserIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityUserId',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityUserIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityUserId',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityUserIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityUserId',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityUserNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activityUserName',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityUserNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activityUserName',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityUserNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityUserName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> activityUserNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityUserName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> categoryValuesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'categoryValues',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> categoryValuesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'categoryValues',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> categoryValuesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryValues',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> categoryValuesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryValues',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> categoryValuesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryValues',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> categoryValuesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryValues',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> categoryValuesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoryValues',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> categoryValuesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoryValues',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      categoryValuesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoryValues',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      categoryValuesElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoryValues',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> categoryValuesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryValues',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> categoryValuesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categoryValues',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> categoryValuesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryValues',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> categoryValuesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryValues',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> categoryValuesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryValues',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> categoryValuesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryValues',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> categoryValuesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryValues',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> categoryValuesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryValues',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> cityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'city',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> cityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'city',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> cityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> cityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> commercialPartnerIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'commercialPartnerId',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> commercialPartnerIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'commercialPartnerId',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> commercialPartnerIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commercialPartnerId',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> commercialPartnerIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'commercialPartnerId',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> commercialPartnerIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'commercialPartnerId',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> commercialPartnerIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'commercialPartnerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> commercialPartnerNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'commercialPartnerName',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> commercialPartnerNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'commercialPartnerName',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> commercialPartnerNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commercialPartnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> commercialPartnerNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'commercialPartnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> commercialPartnerNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'commercialPartnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> commercialPartnerNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'commercialPartnerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> commercialPartnerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'commercialPartnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> commercialPartnerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'commercialPartnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      commercialPartnerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'commercialPartnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      commercialPartnerNameMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'commercialPartnerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> commercialPartnerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commercialPartnerName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> commercialPartnerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'commercialPartnerName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyDisplayNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'companyDisplayName',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyDisplayNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'companyDisplayName',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyDisplayNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'companyDisplayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyDisplayNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'companyDisplayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyDisplayNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'companyDisplayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyDisplayNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'companyDisplayName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyDisplayNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'companyDisplayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyDisplayNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'companyDisplayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      companyDisplayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'companyDisplayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      companyDisplayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'companyDisplayName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyDisplayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'companyDisplayName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyDisplayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'companyDisplayName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'companyId',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'companyId',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'companyId',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyIdGreaterThan(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyIdLessThan(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyIdBetween(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'companyName',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'companyName',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyNameEqualTo(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyNameGreaterThan(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyNameLessThan(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyNameBetween(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyNameStartsWith(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyNameEndsWith(
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      companyNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'companyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      companyNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'companyName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'companyName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'companyName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'companyType',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'companyType',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'companyType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'companyType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'companyType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'companyType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'companyType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'companyType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      companyTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'companyType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      companyTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'companyType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'companyType',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> companyTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'companyType',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> countryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'countryId',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> countryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'countryId',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> countryIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'countryId',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> countryNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'countryName',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> countryNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'countryName',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> countryNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'countryName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> countryNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'countryName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> customerRankIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customerRank',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> customerRankIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customerRank',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> customerRankEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerRank',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> customerRankGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerRank',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> customerRankLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerRank',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> customerRankBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerRank',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> emailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> emailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> emailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> emailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'email',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      emailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      emailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'email',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> functionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'function',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> functionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'function',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> functionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'function',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> functionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'function',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> functionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'function',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> functionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'function',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> functionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'function',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> functionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'function',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      functionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'function',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      functionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'function',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> functionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'function',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> functionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'function',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> isActiveIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isActive',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> isActiveIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isActive',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> isActiveEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> isCompanyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isCompany',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> isCompanyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isCompany',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> isCompanyEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompany',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> meetingCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'meetingCount',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> meetingCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'meetingCount',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> meetingCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'meetingCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> meetingCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'meetingCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> meetingCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'meetingCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> meetingCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'meetingCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> opportunityCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'opportunityCount',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> opportunityCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'opportunityCount',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> opportunityCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'opportunityCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> opportunityCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'opportunityCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> opportunityCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'opportunityCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> opportunityCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'opportunityCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> phoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phone',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> phoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phone',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> saleOrderCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'saleOrderCount',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> saleOrderCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'saleOrderCount',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> saleOrderCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saleOrderCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> saleOrderCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'saleOrderCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> saleOrderCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'saleOrderCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> saleOrderCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'saleOrderCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> serverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> serverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverId',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> serverIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverId',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
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

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> stateIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stateId',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> stateIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stateId',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> stateIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateId',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> stateIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stateId',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> stateIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stateId',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> stateIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stateId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> stateNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stateName',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> stateNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stateName',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> stateNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> stateNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> stateNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> stateNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stateName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> stateNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'stateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> stateNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'stateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      stateNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stateName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
          QAfterFilterCondition>
      stateNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stateName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> stateNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> stateNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stateName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> supplierRankIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'supplierRank',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> supplierRankIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'supplierRank',
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> supplierRankEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supplierRank',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> supplierRankGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'supplierRank',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> supplierRankLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'supplierRank',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar,
      QAfterFilterCondition> supplierRankBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'supplierRank',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CustomerListDataIsarQueryObject on QueryBuilder<CustomerListDataIsar,
    CustomerListDataIsar, QFilterCondition> {}

extension CustomerListDataIsarQueryLinks on QueryBuilder<CustomerListDataIsar,
    CustomerListDataIsar, QFilterCondition> {}

extension CustomerListDataIsarQuerySortBy
    on QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QSortBy> {
  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByActivityDateDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityDateDeadline', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByActivityDateDeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityDateDeadline', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByActivityState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityState', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByActivityStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityState', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByActivitySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activitySummary', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByActivitySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activitySummary', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByActivityTypeIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeIcon', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByActivityTypeIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeIcon', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByActivityTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeId', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByActivityTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeId', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByActivityTypeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeName', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByActivityTypeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeName', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByActivityUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserId', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByActivityUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserId', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByActivityUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserName', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByActivityUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserName', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCommercialPartnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commercialPartnerId', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCommercialPartnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commercialPartnerId', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCommercialPartnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commercialPartnerName', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCommercialPartnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commercialPartnerName', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCompanyDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyDisplayName', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCompanyDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyDisplayName', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCompanyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyName', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCompanyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyName', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCompanyType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyType', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCompanyTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyType', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCountryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCountryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCountryName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryName', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCountryNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryName', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCustomerRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerRank', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByCustomerRankDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerRank', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByFunction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'function', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByFunctionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'function', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByIsCompany() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompany', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByIsCompanyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompany', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByMeetingCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meetingCount', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByMeetingCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meetingCount', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByOpportunityCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opportunityCount', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByOpportunityCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opportunityCount', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortBySaleOrderCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderCount', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortBySaleOrderCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderCount', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByStateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateId', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByStateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateId', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByStateName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateName', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortByStateNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateName', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortBySupplierRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplierRank', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      sortBySupplierRankDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplierRank', Sort.desc);
    });
  }
}

extension CustomerListDataIsarQuerySortThenBy
    on QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QSortThenBy> {
  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByActivityDateDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityDateDeadline', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByActivityDateDeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityDateDeadline', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByActivityState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityState', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByActivityStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityState', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByActivitySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activitySummary', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByActivitySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activitySummary', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByActivityTypeIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeIcon', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByActivityTypeIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeIcon', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByActivityTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeId', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByActivityTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeId', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByActivityTypeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeName', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByActivityTypeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityTypeName', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByActivityUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserId', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByActivityUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserId', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByActivityUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserName', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByActivityUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityUserName', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCommercialPartnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commercialPartnerId', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCommercialPartnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commercialPartnerId', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCommercialPartnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commercialPartnerName', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCommercialPartnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commercialPartnerName', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCompanyDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyDisplayName', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCompanyDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyDisplayName', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCompanyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyName', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCompanyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyName', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCompanyType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyType', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCompanyTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyType', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCountryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCountryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCountryName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryName', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCountryNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryName', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCustomerRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerRank', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByCustomerRankDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerRank', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByFunction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'function', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByFunctionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'function', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByIsCompany() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompany', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByIsCompanyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompany', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByMeetingCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meetingCount', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByMeetingCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meetingCount', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByOpportunityCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opportunityCount', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByOpportunityCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opportunityCount', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenBySaleOrderCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderCount', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenBySaleOrderCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saleOrderCount', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByStateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateId', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByStateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateId', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByStateName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateName', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenByStateNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateName', Sort.desc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenBySupplierRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplierRank', Sort.asc);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QAfterSortBy>
      thenBySupplierRankDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplierRank', Sort.desc);
    });
  }
}

extension CustomerListDataIsarQueryWhereDistinct
    on QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct> {
  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByActivityDateDeadline({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityDateDeadline',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByActivityState({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityState',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByActivitySummary({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activitySummary',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByActivityTypeIcon({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityTypeIcon',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByActivityTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityTypeId');
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByActivityTypeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityTypeName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByActivityUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityUserId');
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByActivityUserName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityUserName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByCategoryValues() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryValues');
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByCity({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'city', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByCommercialPartnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commercialPartnerId');
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByCommercialPartnerName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commercialPartnerName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByCompanyDisplayName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'companyDisplayName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'companyId');
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByCompanyName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'companyName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByCompanyType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'companyType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByCountryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'countryId');
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByCountryName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'countryName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByCustomerRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerRank');
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByFunction({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'function', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByIsCompany() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompany');
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByMeetingCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'meetingCount');
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByOpportunityCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'opportunityCount');
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctBySaleOrderCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saleOrderCount');
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId');
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByStateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stateId');
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctByStateName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stateName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomerListDataIsar, CustomerListDataIsar, QDistinct>
      distinctBySupplierRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supplierRank');
    });
  }
}

extension CustomerListDataIsarQueryProperty on QueryBuilder<
    CustomerListDataIsar, CustomerListDataIsar, QQueryProperty> {
  QueryBuilder<CustomerListDataIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CustomerListDataIsar, String?, QQueryOperations>
      activityDateDeadlineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityDateDeadline');
    });
  }

  QueryBuilder<CustomerListDataIsar, String?, QQueryOperations>
      activityStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityState');
    });
  }

  QueryBuilder<CustomerListDataIsar, String?, QQueryOperations>
      activitySummaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activitySummary');
    });
  }

  QueryBuilder<CustomerListDataIsar, String?, QQueryOperations>
      activityTypeIconProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityTypeIcon');
    });
  }

  QueryBuilder<CustomerListDataIsar, int?, QQueryOperations>
      activityTypeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityTypeId');
    });
  }

  QueryBuilder<CustomerListDataIsar, String?, QQueryOperations>
      activityTypeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityTypeName');
    });
  }

  QueryBuilder<CustomerListDataIsar, int?, QQueryOperations>
      activityUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityUserId');
    });
  }

  QueryBuilder<CustomerListDataIsar, String?, QQueryOperations>
      activityUserNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityUserName');
    });
  }

  QueryBuilder<CustomerListDataIsar, List<String>?, QQueryOperations>
      categoryValuesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryValues');
    });
  }

  QueryBuilder<CustomerListDataIsar, String?, QQueryOperations> cityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'city');
    });
  }

  QueryBuilder<CustomerListDataIsar, int?, QQueryOperations>
      commercialPartnerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commercialPartnerId');
    });
  }

  QueryBuilder<CustomerListDataIsar, String?, QQueryOperations>
      commercialPartnerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commercialPartnerName');
    });
  }

  QueryBuilder<CustomerListDataIsar, String?, QQueryOperations>
      companyDisplayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'companyDisplayName');
    });
  }

  QueryBuilder<CustomerListDataIsar, int?, QQueryOperations>
      companyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'companyId');
    });
  }

  QueryBuilder<CustomerListDataIsar, String?, QQueryOperations>
      companyNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'companyName');
    });
  }

  QueryBuilder<CustomerListDataIsar, String?, QQueryOperations>
      companyTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'companyType');
    });
  }

  QueryBuilder<CustomerListDataIsar, int?, QQueryOperations>
      countryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'countryId');
    });
  }

  QueryBuilder<CustomerListDataIsar, String?, QQueryOperations>
      countryNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'countryName');
    });
  }

  QueryBuilder<CustomerListDataIsar, int?, QQueryOperations>
      customerRankProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerRank');
    });
  }

  QueryBuilder<CustomerListDataIsar, String?, QQueryOperations>
      emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<CustomerListDataIsar, String?, QQueryOperations>
      functionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'function');
    });
  }

  QueryBuilder<CustomerListDataIsar, bool?, QQueryOperations>
      isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<CustomerListDataIsar, bool?, QQueryOperations>
      isCompanyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompany');
    });
  }

  QueryBuilder<CustomerListDataIsar, int?, QQueryOperations>
      meetingCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'meetingCount');
    });
  }

  QueryBuilder<CustomerListDataIsar, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<CustomerListDataIsar, int?, QQueryOperations>
      opportunityCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'opportunityCount');
    });
  }

  QueryBuilder<CustomerListDataIsar, String?, QQueryOperations>
      phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<CustomerListDataIsar, int?, QQueryOperations>
      saleOrderCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saleOrderCount');
    });
  }

  QueryBuilder<CustomerListDataIsar, int?, QQueryOperations>
      serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }

  QueryBuilder<CustomerListDataIsar, int?, QQueryOperations> stateIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stateId');
    });
  }

  QueryBuilder<CustomerListDataIsar, String?, QQueryOperations>
      stateNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stateName');
    });
  }

  QueryBuilder<CustomerListDataIsar, int?, QQueryOperations>
      supplierRankProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supplierRank');
    });
  }
}
