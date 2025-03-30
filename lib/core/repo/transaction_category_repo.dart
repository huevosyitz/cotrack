import 'package:cotrack/core/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supaClient = Supabase.instance.client;

// convert list below to TransactionCategory object

class TransactionCategoryRepository {
  final String _tableName = "categories";
  Future<List<TransactionCategory>> getAllTransactionCategories() async {
    var list = await supaClient.from("categories").select().order("id", ascending: true);

    return list.map((m) => TransactionCategory.fromMap(m)).toList();
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
        .from(_tableName)
        .insert(transactionCategory.toMap()..remove("id"));
  }

  Future<void> editTransactionCategory(TransactionCategory category) async {
    await supaClient
        .from(_tableName)
        .update(category.toMap())
        .eq("id", category.id);
  }

  Future<void> deleteTransactionCategory(int id) async {
    await supaClient.from(_tableName).delete().eq("id", id);
  }
}
