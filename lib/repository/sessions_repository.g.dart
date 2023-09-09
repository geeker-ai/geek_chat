// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sessions_repository.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSessionTableCollection on Isar {
  IsarCollection<SessionTable> get sessionTables => this.collection();
}

const SessionTableSchema = CollectionSchema(
  name: r'SessionTable',
  id: 5727473030219078942,
  properties: {
    r'maxContextMsgCount': PropertySchema(
      id: 0,
      name: r'maxContextMsgCount',
      type: IsarType.long,
    ),
    r'maxContextSize': PropertySchema(
      id: 1,
      name: r'maxContextSize',
      type: IsarType.long,
    ),
    r'maxTokens': PropertySchema(
      id: 2,
      name: r'maxTokens',
      type: IsarType.long,
    ),
    r'model': PropertySchema(
      id: 3,
      name: r'model',
      type: IsarType.string,
    ),
    r'modelType': PropertySchema(
      id: 4,
      name: r'modelType',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'promptContent': PropertySchema(
      id: 6,
      name: r'promptContent',
      type: IsarType.string,
    ),
    r'sid': PropertySchema(
      id: 7,
      name: r'sid',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 8,
      name: r'status',
      type: IsarType.long,
    ),
    r'synced': PropertySchema(
      id: 9,
      name: r'synced',
      type: IsarType.bool,
    ),
    r'temperature': PropertySchema(
      id: 10,
      name: r'temperature',
      type: IsarType.double,
    ),
    r'type': PropertySchema(
      id: 11,
      name: r'type',
      type: IsarType.string,
    ),
    r'updated': PropertySchema(
      id: 12,
      name: r'updated',
      type: IsarType.long,
    )
  },
  estimateSize: _sessionTableEstimateSize,
  serialize: _sessionTableSerialize,
  deserialize: _sessionTableDeserialize,
  deserializeProp: _sessionTableDeserializeProp,
  idName: r'id',
  indexes: {
    r'sid': IndexSchema(
      id: 3962831672660911250,
      name: r'sid',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'type_status_updated': IndexSchema(
      id: 7077219493622794674,
      name: r'type_status_updated',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'type',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'status',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'updated',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'modelType_status_updated': IndexSchema(
      id: -5527483612767178693,
      name: r'modelType_status_updated',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'modelType',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'status',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'updated',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'status_updated': IndexSchema(
      id: 7156977361802596618,
      name: r'status_updated',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'updated',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _sessionTableGetId,
  getLinks: _sessionTableGetLinks,
  attach: _sessionTableAttach,
  version: '3.1.0+1',
);

int _sessionTableEstimateSize(
  SessionTable object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.model.length * 3;
  bytesCount += 3 + object.modelType.length * 3;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.promptContent;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.sid.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _sessionTableSerialize(
  SessionTable object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.maxContextMsgCount);
  writer.writeLong(offsets[1], object.maxContextSize);
  writer.writeLong(offsets[2], object.maxTokens);
  writer.writeString(offsets[3], object.model);
  writer.writeString(offsets[4], object.modelType);
  writer.writeString(offsets[5], object.name);
  writer.writeString(offsets[6], object.promptContent);
  writer.writeString(offsets[7], object.sid);
  writer.writeLong(offsets[8], object.status);
  writer.writeBool(offsets[9], object.synced);
  writer.writeDouble(offsets[10], object.temperature);
  writer.writeString(offsets[11], object.type);
  writer.writeLong(offsets[12], object.updated);
}

SessionTable _sessionTableDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SessionTable();
  object.id = id;
  object.maxContextMsgCount = reader.readLongOrNull(offsets[0]);
  object.maxContextSize = reader.readLongOrNull(offsets[1]);
  object.maxTokens = reader.readLongOrNull(offsets[2]);
  object.model = reader.readString(offsets[3]);
  object.modelType = reader.readString(offsets[4]);
  object.name = reader.readStringOrNull(offsets[5]);
  object.promptContent = reader.readStringOrNull(offsets[6]);
  object.sid = reader.readString(offsets[7]);
  object.status = reader.readLong(offsets[8]);
  object.synced = reader.readBool(offsets[9]);
  object.temperature = reader.readDoubleOrNull(offsets[10]);
  object.type = reader.readString(offsets[11]);
  object.updated = reader.readLongOrNull(offsets[12]);
  return object;
}

P _sessionTableDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readDoubleOrNull(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sessionTableGetId(SessionTable object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sessionTableGetLinks(SessionTable object) {
  return [];
}

void _sessionTableAttach(
    IsarCollection<dynamic> col, Id id, SessionTable object) {
  object.id = id;
}

extension SessionTableByIndex on IsarCollection<SessionTable> {
  Future<SessionTable?> getBySid(String sid) {
    return getByIndex(r'sid', [sid]);
  }

  SessionTable? getBySidSync(String sid) {
    return getByIndexSync(r'sid', [sid]);
  }

  Future<bool> deleteBySid(String sid) {
    return deleteByIndex(r'sid', [sid]);
  }

  bool deleteBySidSync(String sid) {
    return deleteByIndexSync(r'sid', [sid]);
  }

  Future<List<SessionTable?>> getAllBySid(List<String> sidValues) {
    final values = sidValues.map((e) => [e]).toList();
    return getAllByIndex(r'sid', values);
  }

  List<SessionTable?> getAllBySidSync(List<String> sidValues) {
    final values = sidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'sid', values);
  }

  Future<int> deleteAllBySid(List<String> sidValues) {
    final values = sidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'sid', values);
  }

  int deleteAllBySidSync(List<String> sidValues) {
    final values = sidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'sid', values);
  }

  Future<Id> putBySid(SessionTable object) {
    return putByIndex(r'sid', object);
  }

  Id putBySidSync(SessionTable object, {bool saveLinks = true}) {
    return putByIndexSync(r'sid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySid(List<SessionTable> objects) {
    return putAllByIndex(r'sid', objects);
  }

  List<Id> putAllBySidSync(List<SessionTable> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'sid', objects, saveLinks: saveLinks);
  }
}

extension SessionTableQueryWhereSort
    on QueryBuilder<SessionTable, SessionTable, QWhere> {
  QueryBuilder<SessionTable, SessionTable, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhere> anyStatusUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'status_updated'),
      );
    });
  }
}

extension SessionTableQueryWhere
    on QueryBuilder<SessionTable, SessionTable, QWhereClause> {
  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause> idBetween(
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

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause> sidEqualTo(
      String sid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sid',
        value: [sid],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause> sidNotEqualTo(
      String sid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sid',
              lower: [],
              upper: [sid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sid',
              lower: [sid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sid',
              lower: [sid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sid',
              lower: [],
              upper: [sid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      typeEqualToAnyStatusUpdated(String type) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'type_status_updated',
        value: [type],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      typeNotEqualToAnyStatusUpdated(String type) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type_status_updated',
              lower: [],
              upper: [type],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type_status_updated',
              lower: [type],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type_status_updated',
              lower: [type],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type_status_updated',
              lower: [],
              upper: [type],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      typeStatusEqualToAnyUpdated(String type, int status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'type_status_updated',
        value: [type, status],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      typeEqualToStatusNotEqualToAnyUpdated(String type, int status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type_status_updated',
              lower: [type],
              upper: [type, status],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type_status_updated',
              lower: [type, status],
              includeLower: false,
              upper: [type],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type_status_updated',
              lower: [type, status],
              includeLower: false,
              upper: [type],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type_status_updated',
              lower: [type],
              upper: [type, status],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      typeEqualToStatusGreaterThanAnyUpdated(
    String type,
    int status, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'type_status_updated',
        lower: [type, status],
        includeLower: include,
        upper: [type],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      typeEqualToStatusLessThanAnyUpdated(
    String type,
    int status, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'type_status_updated',
        lower: [type],
        upper: [type, status],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      typeEqualToStatusBetweenAnyUpdated(
    String type,
    int lowerStatus,
    int upperStatus, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'type_status_updated',
        lower: [type, lowerStatus],
        includeLower: includeLower,
        upper: [type, upperStatus],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      typeStatusEqualToUpdatedIsNull(String type, int status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'type_status_updated',
        value: [type, status, null],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      typeStatusEqualToUpdatedIsNotNull(String type, int status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'type_status_updated',
        lower: [type, status, null],
        includeLower: false,
        upper: [
          type,
          status,
        ],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      typeStatusUpdatedEqualTo(String type, int status, int? updated) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'type_status_updated',
        value: [type, status, updated],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      typeStatusEqualToUpdatedNotEqualTo(
          String type, int status, int? updated) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type_status_updated',
              lower: [type, status],
              upper: [type, status, updated],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type_status_updated',
              lower: [type, status, updated],
              includeLower: false,
              upper: [type, status],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type_status_updated',
              lower: [type, status, updated],
              includeLower: false,
              upper: [type, status],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type_status_updated',
              lower: [type, status],
              upper: [type, status, updated],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      typeStatusEqualToUpdatedGreaterThan(
    String type,
    int status,
    int? updated, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'type_status_updated',
        lower: [type, status, updated],
        includeLower: include,
        upper: [type, status],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      typeStatusEqualToUpdatedLessThan(
    String type,
    int status,
    int? updated, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'type_status_updated',
        lower: [type, status],
        upper: [type, status, updated],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      typeStatusEqualToUpdatedBetween(
    String type,
    int status,
    int? lowerUpdated,
    int? upperUpdated, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'type_status_updated',
        lower: [type, status, lowerUpdated],
        includeLower: includeLower,
        upper: [type, status, upperUpdated],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      modelTypeEqualToAnyStatusUpdated(String modelType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'modelType_status_updated',
        value: [modelType],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      modelTypeNotEqualToAnyStatusUpdated(String modelType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelType_status_updated',
              lower: [],
              upper: [modelType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelType_status_updated',
              lower: [modelType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelType_status_updated',
              lower: [modelType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelType_status_updated',
              lower: [],
              upper: [modelType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      modelTypeStatusEqualToAnyUpdated(String modelType, int status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'modelType_status_updated',
        value: [modelType, status],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      modelTypeEqualToStatusNotEqualToAnyUpdated(String modelType, int status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelType_status_updated',
              lower: [modelType],
              upper: [modelType, status],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelType_status_updated',
              lower: [modelType, status],
              includeLower: false,
              upper: [modelType],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelType_status_updated',
              lower: [modelType, status],
              includeLower: false,
              upper: [modelType],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelType_status_updated',
              lower: [modelType],
              upper: [modelType, status],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      modelTypeEqualToStatusGreaterThanAnyUpdated(
    String modelType,
    int status, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'modelType_status_updated',
        lower: [modelType, status],
        includeLower: include,
        upper: [modelType],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      modelTypeEqualToStatusLessThanAnyUpdated(
    String modelType,
    int status, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'modelType_status_updated',
        lower: [modelType],
        upper: [modelType, status],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      modelTypeEqualToStatusBetweenAnyUpdated(
    String modelType,
    int lowerStatus,
    int upperStatus, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'modelType_status_updated',
        lower: [modelType, lowerStatus],
        includeLower: includeLower,
        upper: [modelType, upperStatus],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      modelTypeStatusEqualToUpdatedIsNull(String modelType, int status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'modelType_status_updated',
        value: [modelType, status, null],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      modelTypeStatusEqualToUpdatedIsNotNull(String modelType, int status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'modelType_status_updated',
        lower: [modelType, status, null],
        includeLower: false,
        upper: [
          modelType,
          status,
        ],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      modelTypeStatusUpdatedEqualTo(
          String modelType, int status, int? updated) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'modelType_status_updated',
        value: [modelType, status, updated],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      modelTypeStatusEqualToUpdatedNotEqualTo(
          String modelType, int status, int? updated) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelType_status_updated',
              lower: [modelType, status],
              upper: [modelType, status, updated],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelType_status_updated',
              lower: [modelType, status, updated],
              includeLower: false,
              upper: [modelType, status],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelType_status_updated',
              lower: [modelType, status, updated],
              includeLower: false,
              upper: [modelType, status],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelType_status_updated',
              lower: [modelType, status],
              upper: [modelType, status, updated],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      modelTypeStatusEqualToUpdatedGreaterThan(
    String modelType,
    int status,
    int? updated, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'modelType_status_updated',
        lower: [modelType, status, updated],
        includeLower: include,
        upper: [modelType, status],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      modelTypeStatusEqualToUpdatedLessThan(
    String modelType,
    int status,
    int? updated, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'modelType_status_updated',
        lower: [modelType, status],
        upper: [modelType, status, updated],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      modelTypeStatusEqualToUpdatedBetween(
    String modelType,
    int status,
    int? lowerUpdated,
    int? upperUpdated, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'modelType_status_updated',
        lower: [modelType, status, lowerUpdated],
        includeLower: includeLower,
        upper: [modelType, status, upperUpdated],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      statusEqualToAnyUpdated(int status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status_updated',
        value: [status],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      statusNotEqualToAnyUpdated(int status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status_updated',
              lower: [],
              upper: [status],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status_updated',
              lower: [status],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status_updated',
              lower: [status],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status_updated',
              lower: [],
              upper: [status],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      statusGreaterThanAnyUpdated(
    int status, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status_updated',
        lower: [status],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      statusLessThanAnyUpdated(
    int status, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status_updated',
        lower: [],
        upper: [status],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      statusBetweenAnyUpdated(
    int lowerStatus,
    int upperStatus, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status_updated',
        lower: [lowerStatus],
        includeLower: includeLower,
        upper: [upperStatus],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      statusEqualToUpdatedIsNull(int status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status_updated',
        value: [status, null],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      statusEqualToUpdatedIsNotNull(int status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status_updated',
        lower: [status, null],
        includeLower: false,
        upper: [
          status,
        ],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      statusUpdatedEqualTo(int status, int? updated) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status_updated',
        value: [status, updated],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      statusEqualToUpdatedNotEqualTo(int status, int? updated) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status_updated',
              lower: [status],
              upper: [status, updated],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status_updated',
              lower: [status, updated],
              includeLower: false,
              upper: [status],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status_updated',
              lower: [status, updated],
              includeLower: false,
              upper: [status],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status_updated',
              lower: [status],
              upper: [status, updated],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      statusEqualToUpdatedGreaterThan(
    int status,
    int? updated, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status_updated',
        lower: [status, updated],
        includeLower: include,
        upper: [status],
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      statusEqualToUpdatedLessThan(
    int status,
    int? updated, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status_updated',
        lower: [status],
        upper: [status, updated],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterWhereClause>
      statusEqualToUpdatedBetween(
    int status,
    int? lowerUpdated,
    int? upperUpdated, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status_updated',
        lower: [status, lowerUpdated],
        includeLower: includeLower,
        upper: [status, upperUpdated],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SessionTableQueryFilter
    on QueryBuilder<SessionTable, SessionTable, QFilterCondition> {
  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      maxContextMsgCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'maxContextMsgCount',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      maxContextMsgCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'maxContextMsgCount',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      maxContextMsgCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxContextMsgCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      maxContextMsgCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxContextMsgCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      maxContextMsgCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxContextMsgCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      maxContextMsgCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxContextMsgCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      maxContextSizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'maxContextSize',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      maxContextSizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'maxContextSize',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      maxContextSizeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxContextSize',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      maxContextSizeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxContextSize',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      maxContextSizeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxContextSize',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      maxContextSizeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxContextSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      maxTokensIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'maxTokens',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      maxTokensIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'maxTokens',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      maxTokensEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxTokens',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      maxTokensGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxTokens',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      maxTokensLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxTokens',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      maxTokensBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxTokens',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> modelEqualTo(
    String value, {
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      modelGreaterThan(
    String value, {
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> modelLessThan(
    String value, {
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> modelBetween(
    String lower,
    String upper, {
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      modelStartsWith(
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> modelEndsWith(
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> modelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'model',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> modelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'model',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      modelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'model',
        value: '',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      modelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'model',
        value: '',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      modelTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      modelTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      modelTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      modelTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modelType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      modelTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      modelTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      modelTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      modelTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modelType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      modelTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelType',
        value: '',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      modelTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modelType',
        value: '',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> nameContains(
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      promptContentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'promptContent',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      promptContentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'promptContent',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      promptContentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'promptContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      promptContentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'promptContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      promptContentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'promptContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      promptContentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'promptContent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      promptContentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'promptContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      promptContentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'promptContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      promptContentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'promptContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      promptContentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'promptContent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      promptContentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'promptContent',
        value: '',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      promptContentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'promptContent',
        value: '',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> sidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      sidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> sidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> sidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> sidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> sidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> sidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> sidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> sidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sid',
        value: '',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      sidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sid',
        value: '',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> statusEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      statusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      statusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> statusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> syncedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'synced',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      temperatureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'temperature',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      temperatureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'temperature',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      temperatureEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'temperature',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      temperatureGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'temperature',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      temperatureLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'temperature',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      temperatureBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'temperature',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> typeEqualTo(
    String value, {
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> typeLessThan(
    String value, {
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      typeStartsWith(
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> typeEndsWith(
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

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      updatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updated',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      updatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updated',
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      updatedEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updated',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      updatedGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updated',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      updatedLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updated',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterFilterCondition>
      updatedBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SessionTableQueryObject
    on QueryBuilder<SessionTable, SessionTable, QFilterCondition> {}

extension SessionTableQueryLinks
    on QueryBuilder<SessionTable, SessionTable, QFilterCondition> {}

extension SessionTableQuerySortBy
    on QueryBuilder<SessionTable, SessionTable, QSortBy> {
  QueryBuilder<SessionTable, SessionTable, QAfterSortBy>
      sortByMaxContextMsgCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxContextMsgCount', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy>
      sortByMaxContextMsgCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxContextMsgCount', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy>
      sortByMaxContextSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxContextSize', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy>
      sortByMaxContextSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxContextSize', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortByMaxTokens() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxTokens', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortByMaxTokensDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxTokens', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortByModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortByModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortByModelType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelType', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortByModelTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelType', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortByPromptContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptContent', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy>
      sortByPromptContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptContent', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortBySid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sid', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortBySidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sid', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy>
      sortByTemperatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortByUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> sortByUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated', Sort.desc);
    });
  }
}

extension SessionTableQuerySortThenBy
    on QueryBuilder<SessionTable, SessionTable, QSortThenBy> {
  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy>
      thenByMaxContextMsgCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxContextMsgCount', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy>
      thenByMaxContextMsgCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxContextMsgCount', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy>
      thenByMaxContextSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxContextSize', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy>
      thenByMaxContextSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxContextSize', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenByMaxTokens() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxTokens', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenByMaxTokensDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxTokens', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenByModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenByModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'model', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenByModelType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelType', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenByModelTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelType', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenByPromptContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptContent', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy>
      thenByPromptContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promptContent', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenBySid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sid', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenBySidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sid', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy>
      thenByTemperatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'temperature', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenByUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated', Sort.asc);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QAfterSortBy> thenByUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated', Sort.desc);
    });
  }
}

extension SessionTableQueryWhereDistinct
    on QueryBuilder<SessionTable, SessionTable, QDistinct> {
  QueryBuilder<SessionTable, SessionTable, QDistinct>
      distinctByMaxContextMsgCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxContextMsgCount');
    });
  }

  QueryBuilder<SessionTable, SessionTable, QDistinct>
      distinctByMaxContextSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxContextSize');
    });
  }

  QueryBuilder<SessionTable, SessionTable, QDistinct> distinctByMaxTokens() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxTokens');
    });
  }

  QueryBuilder<SessionTable, SessionTable, QDistinct> distinctByModel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'model', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QDistinct> distinctByModelType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modelType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QDistinct> distinctByPromptContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'promptContent',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QDistinct> distinctBySid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<SessionTable, SessionTable, QDistinct> distinctBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'synced');
    });
  }

  QueryBuilder<SessionTable, SessionTable, QDistinct> distinctByTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'temperature');
    });
  }

  QueryBuilder<SessionTable, SessionTable, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SessionTable, SessionTable, QDistinct> distinctByUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updated');
    });
  }
}

extension SessionTableQueryProperty
    on QueryBuilder<SessionTable, SessionTable, QQueryProperty> {
  QueryBuilder<SessionTable, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SessionTable, int?, QQueryOperations>
      maxContextMsgCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxContextMsgCount');
    });
  }

  QueryBuilder<SessionTable, int?, QQueryOperations> maxContextSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxContextSize');
    });
  }

  QueryBuilder<SessionTable, int?, QQueryOperations> maxTokensProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxTokens');
    });
  }

  QueryBuilder<SessionTable, String, QQueryOperations> modelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'model');
    });
  }

  QueryBuilder<SessionTable, String, QQueryOperations> modelTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modelType');
    });
  }

  QueryBuilder<SessionTable, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<SessionTable, String?, QQueryOperations>
      promptContentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'promptContent');
    });
  }

  QueryBuilder<SessionTable, String, QQueryOperations> sidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sid');
    });
  }

  QueryBuilder<SessionTable, int, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<SessionTable, bool, QQueryOperations> syncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'synced');
    });
  }

  QueryBuilder<SessionTable, double?, QQueryOperations> temperatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'temperature');
    });
  }

  QueryBuilder<SessionTable, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<SessionTable, int?, QQueryOperations> updatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updated');
    });
  }
}
