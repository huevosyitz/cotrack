import 'package:cotrack/core/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supaClient = Supabase.instance.client;

// convert list below to TransactionCategory object

class TransactionCategoryRepository {
  Future<List<TransactionCategory>> getAllTransactionCategories() async {
    var list = await supaClient.from("categories").select();

    // map list to TransactionCategory
    return list.map((m) => TransactionCategory.fromMap(m)).toList();

    // return Future.delayed(Duration(seconds: 1), () {
    //   return [
    //     TransactionCategory(
    //         id: 11, name: 'Food', transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 41,
    //         name: 'Groceries',
    //         transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 18,
    //         name: 'Transportation',
    //         transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 20, name: 'Parking', transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 36, name: 'Water', transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 40,
    //         name: 'Electricity',
    //         transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 25, name: 'Fuel', transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 38, name: 'Laundry', transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 7, name: 'Leisure', transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 8,
    //         name: 'Treat/Give',
    //         transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 39, name: 'Internet', transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 10, name: 'Health', transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 12, name: 'Other', transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 16, name: 'Clothing', transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 17, name: 'Travel', transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 21, name: 'Car', transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 22,
    //         name: 'Household',
    //         transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 23, name: 'Load', transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 27, name: 'Medicine', transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 34, name: 'Scates', transactionType: TransactionType.expense),
    //     TransactionCategory(
    //         id: 5, name: 'Insurance', transactionType: TransactionType.expense),
    //   ];
    // });
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
        .from("categories")
        .insert(transactionCategory.toMap()..remove("id"));
  }
}
