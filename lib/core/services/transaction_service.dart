import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/repo/transaction_repo.dart';
import 'package:cotrack/core/services/services.dart';

class TransactionService {
  final TransactionRepo _transactionRepo;
  final UserService _userService;
  static final queryKey = "getAllTransactions";

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

  Future<List<Transaction>> getAllMyTransactions() async {
    // Get transactions

    var user = await _userService.getCurrentUser();

    return _transactionRepo.getTransactionsForGroup(user.groupId);
  }

  Query<List<Transaction>> getAllMyTransactionsQuery() {
    // Get transactions for group

    return Query(key: queryKey, queryFn: getAllMyTransactions, initialData: []);
  }

  Mutation<Transaction, Transaction> createTransactionMutation() {
    // Create transaction mutation

    return Mutation(
      key: "createTransaction",
      refetchQueries: [queryKey],
      queryFn: createTransaction,
      onStartMutation: (transaction) {
        final queryObject = CachedQuery.instance.getQuery(queryKey);

        if (queryObject != null) {
          final query = queryObject as Query<List<Transaction>>;
          final fallback = query.state.data;

          // optimistically set the data
          query.update((oldData) => [...?oldData, transaction]);

          // return the previous data so that we can fallback to it if the
          // mutation fails.
          return fallback;
        }

        return [];
      },
      onError: (arg, error, fallback) {
        CachedQuery.instance.updateQuery(
            key: queryKey, updateFn: (_) => fallback as List<Transaction>);
      },
    );
  }

  Mutation<void, Transaction> deleteTransactionMutation() {
    return Mutation(
      key: "deleteTransaction",
      invalidateQueries: [queryKey],
      queryFn: deleteTransaction,
      onStartMutation: (transaction) {
        final query =
            CachedQuery.instance.getQuery(queryKey) as Query<List<Transaction>>;
        final fallback = query.state.data;

        // optimistically set the data
        query.update((oldData) =>
            oldData?.where((t) => t.id != transaction.id).toList());

        // return the previous data so that we can fallback to it if the
        // mutation fails.
        return fallback;
      },
      onError: (arg, error, fallback) {
        Loggy.error("Error deleting transaction: $error");
        CachedQuery.instance.updateQuery(
            key: queryKey, updateFn: (_) => fallback as List<Transaction>);
      },
    );
  }
}
