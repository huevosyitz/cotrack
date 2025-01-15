import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/repo/transaction_repo.dart';
import 'package:cotrack/core/services/services.dart';

class TransactionService {
  final TransactionRepo _transactionRepo;
  final UserService _userService;

  // inject TransactionRepo
  TransactionService(this._transactionRepo, this._userService);

  Future<Transaction> createTransaction(Transaction transaction) async {
    // Create transaction

    return _transactionRepo.createTransaction(transaction);
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    // Update transaction

    return _transactionRepo.updateTransaction(transaction);
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    // Delete transaction

    return _transactionRepo.deleteTransaction(transaction);
  }

  Future<List<Transaction>> getTransactions() async {
    // Get transactions

    var user = await _userService.getCurrentUser();

    return _transactionRepo.getTransactionsForGroup(user.groupId);
  }
}
