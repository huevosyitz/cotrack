import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/repo/repo.dart';

class TransactionCategoryService {
  final TransactionCategoryRepository _transactionCategoryRepository;
  static List<TransactionCategory> expenseCategories = [];
  static List<TransactionCategory> incomeCategories = [];
  static Map<int, TransactionCategory> transactionCategoriesMap = {};
  static final queryKey = "getTransactionCategories";

  TransactionCategoryService(this._transactionCategoryRepository);

  Future<List<TransactionCategory>> setupTransactionCategories() async {
    var allCategories =
        await _transactionCategoryRepository.getAllTransactionCategories();
    expenseCategories = allCategories
        .where((e) => e.transactionType == TransactionType.expense)
        .toList();

    transactionCategoriesMap = {for (var v in allCategories) v.id: v};
    return allCategories;
  }

  Future<TransactionCategory> getTransactionCategoryById(String id) async {
    return await _transactionCategoryRepository.getTransactionCategoryById(id);
  }

  Future<void> addTransactionCategory(
      TransactionCategory transactionCategory) async {
    await _transactionCategoryRepository
        .addTransactionCategory(transactionCategory);
  }

  bool isExpenseCategory(int categoryId) {
    return transactionCategoriesMap[categoryId]?.transactionType ==
        TransactionType.expense;
  }

  bool isIncomeCategory(int categoryId) {
    return transactionCategoriesMap[categoryId]?.transactionType ==
        TransactionType.income;
  }

  Query<List<TransactionCategory>> getTransactionCategoriesQuery() {
    // Get transactions for group

    return Query(
        key: queryKey, queryFn: setupTransactionCategories, initialData: []);
  }
}
