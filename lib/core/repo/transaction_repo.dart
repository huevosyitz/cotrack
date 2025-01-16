import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/repo/transaction_category_repo.dart';

class TransactionRepo {
  Future<Transaction> createTransaction(Transaction transaction) async {
    // Create transaction

    var tran = transaction.toMap()..remove("id");

    var result =
        await supaClient.from("transactions").insert(tran).select().single();

    return Transaction.fromMap(result);
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    // Update transaction

    var result = await supaClient
        .from("transactions")
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

    await supaClient
        .from("transactions")
        .delete()
        .eq("id", transaction.id)
        .select();
  }

  Future<List<Transaction>> getTransactionsForGroup(int groupId) async {
    // Get transactions

    var result =
        await supaClient.from("transactions").select().eq("group_id", groupId);

    return result.map((e) => Transaction.fromMap(e)).toList();
  }
}
