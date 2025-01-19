// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_queries.dart';

// ignore_for_file: type=lint
class $CachedQueriesTable extends CachedQueries
    with TableInfo<$CachedQueriesTable, CachedQuery> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedQueriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _queryKeyMeta =
      const VerificationMeta('queryKey');
  @override
  late final GeneratedColumn<String> queryKey = GeneratedColumn<String>(
      'query_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _queryDataMeta =
      const VerificationMeta('queryData');
  @override
  late final GeneratedColumn<String> queryData = GeneratedColumn<String>(
      'query_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMsMeta =
      const VerificationMeta('createdAtMs');
  @override
  late final GeneratedColumn<int> createdAtMs = GeneratedColumn<int>(
      'created_at_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _durationMsMeta =
      const VerificationMeta('durationMs');
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
      'duration_ms', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [queryKey, queryData, createdAtMs, durationMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_queries';
  @override
  VerificationContext validateIntegrity(Insertable<CachedQuery> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('query_key')) {
      context.handle(_queryKeyMeta,
          queryKey.isAcceptableOrUnknown(data['query_key']!, _queryKeyMeta));
    } else if (isInserting) {
      context.missing(_queryKeyMeta);
    }
    if (data.containsKey('query_data')) {
      context.handle(_queryDataMeta,
          queryData.isAcceptableOrUnknown(data['query_data']!, _queryDataMeta));
    } else if (isInserting) {
      context.missing(_queryDataMeta);
    }
    if (data.containsKey('created_at_ms')) {
      context.handle(
          _createdAtMsMeta,
          createdAtMs.isAcceptableOrUnknown(
              data['created_at_ms']!, _createdAtMsMeta));
    } else if (isInserting) {
      context.missing(_createdAtMsMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
          _durationMsMeta,
          durationMs.isAcceptableOrUnknown(
              data['duration_ms']!, _durationMsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  CachedQuery map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedQuery(
      queryKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}query_key'])!,
      queryData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}query_data'])!,
      createdAtMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at_ms'])!,
      durationMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_ms']),
    );
  }

  @override
  $CachedQueriesTable createAlias(String alias) {
    return $CachedQueriesTable(attachedDatabase, alias);
  }
}

class CachedQuery extends DataClass implements Insertable<CachedQuery> {
  final String queryKey;
  final String queryData;
  final int createdAtMs;
  final int? durationMs;
  const CachedQuery(
      {required this.queryKey,
      required this.queryData,
      required this.createdAtMs,
      this.durationMs});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['query_key'] = Variable<String>(queryKey);
    map['query_data'] = Variable<String>(queryData);
    map['created_at_ms'] = Variable<int>(createdAtMs);
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    return map;
  }

  CachedQueriesCompanion toCompanion(bool nullToAbsent) {
    return CachedQueriesCompanion(
      queryKey: Value(queryKey),
      queryData: Value(queryData),
      createdAtMs: Value(createdAtMs),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
    );
  }

  factory CachedQuery.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedQuery(
      queryKey: serializer.fromJson<String>(json['queryKey']),
      queryData: serializer.fromJson<String>(json['queryData']),
      createdAtMs: serializer.fromJson<int>(json['createdAtMs']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'queryKey': serializer.toJson<String>(queryKey),
      'queryData': serializer.toJson<String>(queryData),
      'createdAtMs': serializer.toJson<int>(createdAtMs),
      'durationMs': serializer.toJson<int?>(durationMs),
    };
  }

  CachedQuery copyWith(
          {String? queryKey,
          String? queryData,
          int? createdAtMs,
          Value<int?> durationMs = const Value.absent()}) =>
      CachedQuery(
        queryKey: queryKey ?? this.queryKey,
        queryData: queryData ?? this.queryData,
        createdAtMs: createdAtMs ?? this.createdAtMs,
        durationMs: durationMs.present ? durationMs.value : this.durationMs,
      );
  CachedQuery copyWithCompanion(CachedQueriesCompanion data) {
    return CachedQuery(
      queryKey: data.queryKey.present ? data.queryKey.value : this.queryKey,
      queryData: data.queryData.present ? data.queryData.value : this.queryData,
      createdAtMs:
          data.createdAtMs.present ? data.createdAtMs.value : this.createdAtMs,
      durationMs:
          data.durationMs.present ? data.durationMs.value : this.durationMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedQuery(')
          ..write('queryKey: $queryKey, ')
          ..write('queryData: $queryData, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('durationMs: $durationMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(queryKey, queryData, createdAtMs, durationMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedQuery &&
          other.queryKey == this.queryKey &&
          other.queryData == this.queryData &&
          other.createdAtMs == this.createdAtMs &&
          other.durationMs == this.durationMs);
}

class CachedQueriesCompanion extends UpdateCompanion<CachedQuery> {
  final Value<String> queryKey;
  final Value<String> queryData;
  final Value<int> createdAtMs;
  final Value<int?> durationMs;
  final Value<int> rowid;
  const CachedQueriesCompanion({
    this.queryKey = const Value.absent(),
    this.queryData = const Value.absent(),
    this.createdAtMs = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedQueriesCompanion.insert({
    required String queryKey,
    required String queryData,
    required int createdAtMs,
    this.durationMs = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : queryKey = Value(queryKey),
        queryData = Value(queryData),
        createdAtMs = Value(createdAtMs);
  static Insertable<CachedQuery> custom({
    Expression<String>? queryKey,
    Expression<String>? queryData,
    Expression<int>? createdAtMs,
    Expression<int>? durationMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (queryKey != null) 'query_key': queryKey,
      if (queryData != null) 'query_data': queryData,
      if (createdAtMs != null) 'created_at_ms': createdAtMs,
      if (durationMs != null) 'duration_ms': durationMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedQueriesCompanion copyWith(
      {Value<String>? queryKey,
      Value<String>? queryData,
      Value<int>? createdAtMs,
      Value<int?>? durationMs,
      Value<int>? rowid}) {
    return CachedQueriesCompanion(
      queryKey: queryKey ?? this.queryKey,
      queryData: queryData ?? this.queryData,
      createdAtMs: createdAtMs ?? this.createdAtMs,
      durationMs: durationMs ?? this.durationMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (queryKey.present) {
      map['query_key'] = Variable<String>(queryKey.value);
    }
    if (queryData.present) {
      map['query_data'] = Variable<String>(queryData.value);
    }
    if (createdAtMs.present) {
      map['created_at_ms'] = Variable<int>(createdAtMs.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedQueriesCompanion(')
          ..write('queryKey: $queryKey, ')
          ..write('queryData: $queryData, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('durationMs: $durationMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedQueriesTable cachedQueries = $CachedQueriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cachedQueries];
}

typedef $$CachedQueriesTableCreateCompanionBuilder = CachedQueriesCompanion
    Function({
  required String queryKey,
  required String queryData,
  required int createdAtMs,
  Value<int?> durationMs,
  Value<int> rowid,
});
typedef $$CachedQueriesTableUpdateCompanionBuilder = CachedQueriesCompanion
    Function({
  Value<String> queryKey,
  Value<String> queryData,
  Value<int> createdAtMs,
  Value<int?> durationMs,
  Value<int> rowid,
});

class $$CachedQueriesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedQueriesTable> {
  $$CachedQueriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get queryKey => $composableBuilder(
      column: $table.queryKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get queryData => $composableBuilder(
      column: $table.queryData, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAtMs => $composableBuilder(
      column: $table.createdAtMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMs => $composableBuilder(
      column: $table.durationMs, builder: (column) => ColumnFilters(column));
}

class $$CachedQueriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedQueriesTable> {
  $$CachedQueriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get queryKey => $composableBuilder(
      column: $table.queryKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get queryData => $composableBuilder(
      column: $table.queryData, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAtMs => $composableBuilder(
      column: $table.createdAtMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMs => $composableBuilder(
      column: $table.durationMs, builder: (column) => ColumnOrderings(column));
}

class $$CachedQueriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedQueriesTable> {
  $$CachedQueriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get queryKey =>
      $composableBuilder(column: $table.queryKey, builder: (column) => column);

  GeneratedColumn<String> get queryData =>
      $composableBuilder(column: $table.queryData, builder: (column) => column);

  GeneratedColumn<int> get createdAtMs => $composableBuilder(
      column: $table.createdAtMs, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
      column: $table.durationMs, builder: (column) => column);
}

class $$CachedQueriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CachedQueriesTable,
    CachedQuery,
    $$CachedQueriesTableFilterComposer,
    $$CachedQueriesTableOrderingComposer,
    $$CachedQueriesTableAnnotationComposer,
    $$CachedQueriesTableCreateCompanionBuilder,
    $$CachedQueriesTableUpdateCompanionBuilder,
    (
      CachedQuery,
      BaseReferences<_$AppDatabase, $CachedQueriesTable, CachedQuery>
    ),
    CachedQuery,
    PrefetchHooks Function()> {
  $$CachedQueriesTableTableManager(_$AppDatabase db, $CachedQueriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedQueriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedQueriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedQueriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> queryKey = const Value.absent(),
            Value<String> queryData = const Value.absent(),
            Value<int> createdAtMs = const Value.absent(),
            Value<int?> durationMs = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedQueriesCompanion(
            queryKey: queryKey,
            queryData: queryData,
            createdAtMs: createdAtMs,
            durationMs: durationMs,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String queryKey,
            required String queryData,
            required int createdAtMs,
            Value<int?> durationMs = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedQueriesCompanion.insert(
            queryKey: queryKey,
            queryData: queryData,
            createdAtMs: createdAtMs,
            durationMs: durationMs,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedQueriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CachedQueriesTable,
    CachedQuery,
    $$CachedQueriesTableFilterComposer,
    $$CachedQueriesTableOrderingComposer,
    $$CachedQueriesTableAnnotationComposer,
    $$CachedQueriesTableCreateCompanionBuilder,
    $$CachedQueriesTableUpdateCompanionBuilder,
    (
      CachedQuery,
      BaseReferences<_$AppDatabase, $CachedQueriesTable, CachedQuery>
    ),
    CachedQuery,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedQueriesTableTableManager get cachedQueries =>
      $$CachedQueriesTableTableManager(_db, _db.cachedQueries);
}
