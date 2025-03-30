import 'package:cotrack/core/models/models.dart';

import '../repo/transaction_account_repo.dart';

class TransactionAccountService {
  final TransactionAccountRepository _transactionAccountRepository;
  static List<TransactionAccount> allAccounts = [];
  static final queryKey = "getTransactionAccounts";

  TransactionAccountService(this._transactionAccountRepository);

  Future<List<TransactionAccount>> getAllTransactionAccounts() async {
    allAccounts =
        await _transactionAccountRepository.getAllTransactionAccounts();
    return allAccounts;
  }
}
