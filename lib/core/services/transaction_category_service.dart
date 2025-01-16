import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/repo/repo.dart';

class TransactionCategoryService {
  final TransactionCategoryRepository _transactionCategoryRepository;
  static List<TransactionCategory> transactionCategories = [];
  static Map<int, TransactionCategory> transactionCategoriesMap = {};
  static final queryKey = "getTransactionCategories";

  TransactionCategoryService(this._transactionCategoryRepository);

  Future<List<TransactionCategory>> getTransactionCategories() async {
    var result =
        await _transactionCategoryRepository.getAllTransactionCategories();
    transactionCategories = result;

    transactionCategoriesMap = {for (var v in transactionCategories) v.id: v};
    return result;
  }

  Future<TransactionCategory> getTransactionCategoryById(String id) async {
    return await _transactionCategoryRepository.getTransactionCategoryById(id);
  }

  Future<void> addTransactionCategory(
      TransactionCategory transactionCategory) async {
    await _transactionCategoryRepository
        .addTransactionCategory(transactionCategory);
  }

  Query<List<TransactionCategory>> ggetTransactionCategoriesQuery() {
    // Get transactions for group

    return Query(
        key: queryKey, queryFn: getTransactionCategories, initialData: []);
  }
}
