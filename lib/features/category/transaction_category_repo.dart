import 'package:cotrack/features/category/transaction_category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supaClient = Supabase.instance.client;

// convert list below to TransactionCategory object

class TransactionCategoryRepository {
  final String _tableName = "categories";

  Future<List<TransactionCategory>> getAllTransactionCategories() async {
    var list = await _supaClient
        .from(_tableName)
        .select()
        .order("id", ascending: true);

    return list.map((m) => TransactionCategory.fromMap(m)).toList();
  }

  Future<TransactionCategory> getTransactionCategoryById(int id) async {
    var result =
        await _supaClient.from(_tableName).select().eq("id", id).single();

    return TransactionCategory.fromMap(result);
  }

  Future<void> addTransactionCategory(
      TransactionCategory transactionCategory) async {
    await _supaClient
        .from(_tableName)
        .insert(transactionCategory.toMap()..remove("id"));
  }

  Future<void> editTransactionCategory(TransactionCategory category) async {
    await _supaClient
        .from(_tableName)
        .update(category.toMap())
        .eq("id", category.id);
  }

  Future<void> deleteTransactionCategory(int id) async {
    await _supaClient.from(_tableName).delete().eq("id", id);
  }
}
