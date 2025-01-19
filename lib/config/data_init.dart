import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:watch_it/watch_it.dart';

class DataInit {
  static Future<void> init() async {
    await di<TransactionCategoryService>().setupTransactionCategories();

    final transactions =
        await di.get<TransactionService>().getAllMyTransactions();

    CachedQuery.instance.updateQuery(
        key: TransactionService.queryKey, updateFn: (_) => transactions);
  }
}
