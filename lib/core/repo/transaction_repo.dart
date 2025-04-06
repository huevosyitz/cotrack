import 'package:cotrack/core/models/models.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supaClient = Supabase.instance.client;

class TransactionRepo {
  final String _tableName = "transactions";
  Future<Transaction> createTransaction(Transaction transaction) async {
    // Create transaction

    var tran = transaction.toMap()..remove("id");

    var result =
        await _supaClient.from("transactions").insert(tran).select().single();

    return Transaction.fromMap(result);
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    // Update transaction

    var result = await _supaClient
        .from(_tableName)
        .update({
          "transaction_date": transaction.transaction_date,
          "amount": transaction.amount,
          "category_id": transaction.category_id,
          "notes": transaction.notes,
          "updated_by": transaction.updated_by,
        })
        .eq("id", transaction.id)
        .single();

    return Transaction.fromMap(result);
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    // Delete transaction

    await _supaClient
        .from(_tableName)
        .delete()
        .eq("id", transaction.id)
        .select();
  }

  Future<List<Transaction>> getTransactionsForGroup(int groupId) async {
    // Get transactions

    var result =
        await _supaClient.from(_tableName).select().eq("group_id", groupId);

    return result.map((e) => Transaction.fromMap(e)).toList();
  }

  Future<List<Transaction>> getTransactionsForGroupForDay(
      int groupId, DateTime date) async {
    // Get transactions
    // Format date to 'yyyy-MM-dd'
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    // Define start and end timestamps for the given day
    String startOfDay = "$formattedDate 00:00:00.000Z";
    String endOfDay = "$formattedDate 23:59:59.999Z";

    var result = await _supaClient
        .from(_tableName)
        .select()
        .eq("group_id", groupId)
        .gte('transaction_date', startOfDay)
        .lt('transaction_date', endOfDay);

    return result.map((e) => Transaction.fromMap(e)).toList();
  }
}
