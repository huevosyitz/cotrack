import 'package:cotrack/core/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supaClient = Supabase.instance.client;

// convert list below to TransactionCategory object

class TransactionCategoryRepository {
  Future<List<TransactionCategory>> getAllTransactionCategories() {
    return Future.delayed(Duration(seconds: 1), () {
      return [
        TransactionCategory(
            id: 1,
            name: 'Snacks',
            description: 'Snacks',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 2,
            name: 'Donation',
            description: 'Donation',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 3,
            name: 'MonthlyExpense',
            description: 'MonthlyExpense',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 4,
            name: 'PC',
            description: 'PC',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 5,
            name: 'Insurance',
            description: 'Insurance',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 6,
            name: 'Cam/Gear',
            description: 'Cam/Gear',
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
            id: 9,
            name: 'Offering',
            description: 'Offering',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 10,
            name: 'Health',
            description: 'Health',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 11,
            name: 'Food',
            description: 'Food',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 12,
            name: 'Other',
            description: 'Other',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 13,
            name: 'Date',
            description: 'Date',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 14,
            name: 'Lend',
            description: 'Lend',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 15,
            name: 'Developer',
            description: 'Developer',
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
            id: 18,
            name: 'Transportation',
            description: 'Transportation',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 19,
            name: 'Hygene',
            description: 'Hygene',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 20,
            name: 'Parking',
            description: 'Parking',
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
            id: 24,
            name: 'Motmot',
            description: 'Motmot',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 25,
            name: 'Fuel',
            description: 'Fuel',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 26,
            name: 'Camping',
            description: 'Camping',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 27,
            name: 'Medicine',
            description: 'Medicine',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 28,
            name: 'RedmiInstall',
            description: 'RedmiInstall',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 29,
            name: 'Shared',
            description: 'Shared',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 30,
            name: 'Investment',
            description: 'Investment',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 31,
            name: 'Social Life',
            description: 'Social Life',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 32,
            name: 'SmartBro',
            description: 'SmartBro',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 33,
            name: 'Lot Loan',
            description: 'Lot Loan',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 34,
            name: 'Scates',
            description: 'Scates',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 35,
            name: 'Padala',
            description: 'Padala',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 36,
            name: 'Water',
            description: 'Water',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 37,
            name: 'Pag-Ibig',
            description: 'Pag-Ibig',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 38,
            name: 'Laundry',
            description: 'Laundry',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 39,
            name: 'Internet',
            description: 'Internet',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 40,
            name: 'Electricity',
            description: 'Electricity',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 41,
            name: 'Groceries',
            description: 'Groceries',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 42,
            name: 'Wedd',
            description: 'Wedd',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 43,
            name: 'Gym',
            description: 'Gym',
            transactionType: TransactionType.expense),
        TransactionCategory(
            id: 44,
            name: 'Ministry',
            description: 'Ministry',
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
