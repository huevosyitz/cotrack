import 'package:cotrack/core/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supaClient = Supabase.instance.client;

class TransactionCategoryRepository {
  Future<List<TransactionCategory>> getAllTransactionCategories() {
    return Future.delayed(Duration(seconds: 1), () {
      return [
        TransactionCategory(
          id: '1',
          name: 'Food',
          description: 'All food related expenses',
          transactionType: TransactionType.expense,
        ),
        TransactionCategory(
          id: '2',
          name: 'Salary',
          description: 'All salary related income',
          transactionType: TransactionType.income,
        ),
        TransactionCategory(
          id: '3',
          name: 'Transport',
          description: 'All transport related expenses',
          transactionType: TransactionType.expense,
        ),
        TransactionCategory(
          id: '4',
          name: 'Rent',
          description: 'All rent related expenses',
          transactionType: TransactionType.expense,
        ),
        TransactionCategory(
          id: '5',
          name: 'Gift',
          description: 'All gift related expenses',
          transactionType: TransactionType.expense,
        ),
        TransactionCategory(
          id: '6',
          name: 'Interest',
          description: 'All interest related income',
          transactionType: TransactionType.income,
        ),
        TransactionCategory(
          id: '7',
          name: 'Dividend',
          description: 'All dividend related income',
          transactionType: TransactionType.income,
        ),
        TransactionCategory(
          id: '8',
          name: 'Investment',
          description: 'All investment related income',
          transactionType: TransactionType.income,
        ),
        TransactionCategory(
          id: '9',
          name: 'Other',
          description: 'All other transactions',
          transactionType: TransactionType.expense,
        ),
      ];
    });
  }

  Future<TransactionCategory> getTransactionCategoryById(String id) {
    return Future.delayed(Duration(seconds: 1), () async {
      var all = await getAllTransactionCategories();
      return all.firstWhere((element) => element.id == id);
    });
  }

  Future<void> addTransactionCategory(
      TransactionCategory transactionCategory) async {
    await supaClient
        .from("transaction_categories")
        .upsert(transactionCategory.toMap());
  }
}
