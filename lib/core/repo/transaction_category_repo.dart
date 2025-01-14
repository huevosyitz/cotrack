import 'package:cotrack/core/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supaClient = Supabase.instance.client;

// convert list below to TransactionCategory object

class TransactionCategoryRepository {
  Future<List<TransactionCategory>> getAllTransactionCategories() {
    return Future.delayed(Duration(seconds: 1), () {
      return [
        TransactionCategory(
            id: 11,
            name: 'Food',
            description: 'Food',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 41,
            name: 'Groceries',
            description: 'Groceries',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 18,
            name: 'Transportation',
            description: 'Transportation',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 20,
            name: 'Parking',
            description: 'Parking',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 36,
            name: 'Water',
            description: 'Water',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 40,
            name: 'Electricity',
            description: 'Electricity',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 25,
            name: 'Fuel',
            description: 'Fuel',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 38,
            name: 'Laundry',
            description: 'Laundry',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 7,
            name: 'Leisure',
            description: 'Leisure',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 8,
            name: 'Treat/Give',
            description: 'Treat/Give',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 39,
            name: 'Internet',
            description: 'Internet',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 10,
            name: 'Health',
            description: 'Health',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 12,
            name: 'Other',
            description: 'Other',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 16,
            name: 'Clothing',
            description: 'Clothing',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 17,
            name: 'Travel',
            description: 'Travel',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 21,
            name: 'Car',
            description: 'Car',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 22,
            name: 'Household',
            description: 'Household',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 23,
            name: 'Load',
            description: 'Load',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 27,
            name: 'Medicine',
            description: 'Medicine',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 34,
            name: 'Scates',
            description: 'Scates',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 5,
            name: 'Insurance',
            description: 'Insurance',
            transactionType: TransactionType.expense),
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
