import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/repo/repo.dart';

class TransactionCategoryService {
  final TransactionCategoryRepository _transactionCategoryRepository;
  static List<TransactionCategory> transactionCategories = [];

  TransactionCategoryService(this._transactionCategoryRepository);

  Future<List<TransactionCategory>> getTransactionCategories() async {
    var result =
        await _transactionCategoryRepository.getAllTransactionCategories();
    transactionCategories = result;
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
}
