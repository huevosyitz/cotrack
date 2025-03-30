import 'package:cotrack/core/models/models.dart';

import '../repo/transaction_account_repo.dart';

class TransactionAccountService {
  final TransactionAccountRepository _transactionAccountRepository;
  static List<TransactionAccount> allAccounts = [];
  static Map<int, TransactionAccount> transactionAccountsMap = {};
  static final queryKey = "getTransactionAccounts";

  TransactionAccountService(this._transactionAccountRepository);

  Future<List<TransactionAccount>> getAllTransactionAccounts() async {
    allAccounts =
        await _transactionAccountRepository.getAllTransactionAccounts();
    transactionAccountsMap = {for (var v in allAccounts) v.id: v};
    return allAccounts;
  }
}
