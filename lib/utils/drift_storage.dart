import 'dart:async';
import 'dart:convert';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cotrack/db/cached_queries.dart';
import 'package:drift/drift.dart';

final db = AppDatabase();

class CacheDriftStorage extends StorageInterface {
  @override
  Future<void> delete(String key) async {
    await (db.delete(db.cachedQueries)..where((f) => f.queryKey.equals(key)))
        .go();
  }

  @override
  void deleteAll() {
    db.delete(db.cachedQueries).go();
  }

  @override
  FutureOr<StoredQuery?> get(String key) async {
    var item = await (db.select(db.cachedQueries)
          ..where((f) => f.queryKey.equals(key))
          ..limit(1))
        .getSingleOrNull();
    if (item == null) {
      return null;
    }

    final json = jsonDecode(item.queryData);
    return StoredQuery(
      key: item.queryKey,
      data: json,
      createdAt: DateTime.fromMillisecondsSinceEpoch(item.createdAtMs),
      storageDuration: item.durationMs == null
          ? null
          : Duration(milliseconds: item.durationMs!),
    );
  }

  @override
  void put(StoredQuery query) async {
    final payload = jsonEncode(query.data);
    await db.into(db.cachedQueries).insert(
          CachedQueriesCompanion.insert(
            queryKey: query.key,
            queryData: payload,
            createdAtMs: query.createdAt.millisecondsSinceEpoch,
            durationMs: Value(query.storageDuration?.inMilliseconds),
          ),
        );
  }

  @override
  void close() {
    db.close();
  }
}
