import 'package:cotrack/core/services/services.dart';
import 'package:watch_it/watch_it.dart';

class DataInit {
  static Future<void> init() async {
    await di<TransactionCategoryService>().setupTransactionCategories();
  }
}
