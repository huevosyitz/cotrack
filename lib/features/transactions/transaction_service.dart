import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cotrack/features/auth/user_service.dart';
import 'package:cotrack/features/transactions/transaction_entity.dart';
import 'package:cotrack/features/transactions/transaction_repo.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:intl/intl.dart';

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

  Future<List<Transaction>> getTransactionsForGroupForDay(DateTime date) async {
    var user = await _userService.getCurrentUser();

    return _transactionRepo.getTransactionsForGroupForDay(user.groupId, date);
  }

  Query<List<Transaction>> getTransactionsForDateQuery(DateTime date) {
    // Get transactions for date

    return Query(
        key: _getDateQueryKey(date),
        queryFn: () async {
          final transactions = await getTransactionsForGroupForDay(date);
          return transactions
              .where((t) =>
                  t.transaction_date.year == date.year &&
                  t.transaction_date.month == date.month &&
                  t.transaction_date.day == date.day)
              .toList();
        },
        initialData: []);
  }

  Query<List<Transaction>> getAllMyTransactionsQuery() {
    // Get transactions for group

    return Query(key: queryKey, queryFn: getAllMyTransactions, initialData: []);
  }

  Mutation<Transaction, Transaction> createTransactionMutation() {
    // Create transaction mutation

    return Mutation(
      key: "createTransaction",
      invalidateQueries: [queryKey],
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
        throw Exception(error);
      },
      onSuccess: (res, arg) {
        CachedQuery.instance
            .whereQuery((q) => q.key == _getDateQueryKey(res.transaction_date))
            ?.forEach((q) {
          q.invalidateQuery();
        });
      },
    );
  }

  Mutation<Transaction, Transaction> updateTransactionMutation() {
    return Mutation(
      key: "updateTransaction",
      invalidateQueries: [queryKey],
      queryFn: updateTransaction,
      onStartMutation: (transaction) {
        final queryObject = CachedQuery.instance.getQuery(queryKey);

        if (queryObject != null) {
          final query = queryObject as Query<List<Transaction>>;
          final fallback = query.state.data;

          // update old data
          query.update((oldData) {
            var idx = oldData?.indexWhere((t) => t.id == transaction.id);
            if (idx != null) {
              oldData?[idx] = transaction;
            }
            return oldData;
          });

          // return the previous data so that we can fallback to it if the
          // mutation fails.
          return fallback;
        }

        return [];
      },
      onError: (arg, error, fallback) {
        CachedQuery.instance.updateQuery(
            key: queryKey, updateFn: (_) => fallback as List<Transaction>);
        throw Exception(error);
      },
      onSuccess: (res, arg) {
        CachedQuery.instance
            .whereQuery((q) => q.key == _getDateQueryKey(res.transaction_date))
            ?.forEach((q) {
          q.invalidateQuery();
        });
      },
    );
  }

  Mutation<void, Transaction> deleteTransactionMutation() {
    return Mutation(
      key: "deleteTransaction",
      invalidateQueries: [queryKey],
      queryFn: deleteTransaction,
      onStartMutation: (transaction) {
        final getquery = CachedQuery.instance.getQuery(queryKey);

        if (getquery == null) return null;

        final query = getquery as Query<List<Transaction>>;
        final fallback = query.state.data;

        // optimistically set the data
        query.update((oldData) =>
            oldData?.where((t) => t.id != transaction.id).toList());

        // CachedQuery.instance
        //     .whereQuery(
        //         (q) => q.key == _getDateQueryKey(transaction.transaction_date))
        //     ?.forEach((q) {
        //   q.invalidateQuery();
        // });

        // return the previous data so that we can fallback to it if the
        // mutation fails.
        return fallback;
      },
      onError: (arg, error, fallback) {
        Loggy.error("Error deleting transaction: $error");
        CachedQuery.instance.updateQuery(
            key: queryKey, updateFn: (_) => fallback as List<Transaction>);
        throw Exception(error);
      },
      onSuccess: (res, arg) {},
    );
  }

  String _getDateQueryKey(DateTime date) {
    // Get query key for date

    return "$queryKey/${DateFormat('yyyy-MM-dd').format(date)}";
  }
}
