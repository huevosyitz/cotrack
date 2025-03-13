import 'dart:io';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cached_storage/cached_storage.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:watch_it/watch_it.dart';

class DataInit {
  static Future<void> init() async {
    await di<TransactionCategoryService>().setupTransactionCategories();

    // CachedQuery.instance.deleteCache();

    CachedQuery.instance.configFlutter(
      storage: await CachedStorage.ensureInitialized(),
      config: QueryConfigFlutter(
        // Globally set the refetch duration
        refetchDuration: Duration(hours: 24),
      ),
      observers: [
        QueryLoggingObserver(colors: !Platform.isIOS),
      ],
    );
  }
}
