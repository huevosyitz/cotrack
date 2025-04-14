import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/models/transaction_account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supaClient = Supabase.instance.client;

// convert list below to TransactionAccount object

class TransactionAccountRepository {
  final String _tableName = "accounts";

  Future<List<TransactionAccount>> getAllTransactionAccounts() async {
    var list = await _supaClient
        .from(_tableName)
        .select()
        .order("id", ascending: true);

    return list.map((m) => TransactionAccount.fromMap(m)).toList();
  }

  Future<TransactionAccount> getTransactionAccountById(int id) async {
    var result =
        await _supaClient.from(_tableName).select().eq("id", id).single();

    return TransactionAccount.fromMap(result);
  }

  Future<void> addTransactionAccount(
      TransactionAccount transactionCategory) async {
    await _supaClient
        .from(_tableName)
        .insert(transactionCategory.toMap()..remove("id"));
  }

  Future<void> editTransactionAccount(TransactionAccount account) async {
    await _supaClient
        .from(_tableName)
        .update(account.toMap())
        .eq("id", account.id);
  }

  Future<void> deleteTransactionAccount(int id) async {
    await _supaClient.from(_tableName).delete().eq("id", id);
  }
}
