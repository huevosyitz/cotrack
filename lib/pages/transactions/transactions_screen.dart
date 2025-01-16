import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:watch_it/watch_it.dart';

class TransactionsScreen extends HookWidget {
  TransactionsScreen({super.key});
  final transactionService = di.get<TransactionService>();

  @override
  Widget build(BuildContext context) {
    final transactionsQuery =
        useQuery(["getAllTransactions"], transactionService.getTransactions);

    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(16),
          child: Builder(
            builder: (context) {
              if (transactionsQuery.isLoading) {
                return const Center(
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator()));
              }

              if (transactionsQuery.isError) {
                return Center(
                  child: Text(
                    'Error: ${transactionsQuery.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              var list = transactionsQuery.data as List<Transaction>;

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(TransactionCategoryService
                            .transactionCategoriesMap[list[index].category_id]
                            ?.name ??
                        "Unknown"),
                    subtitle: Text(list[index].amount.toString()),
                  );
                },
              );
            },
          )),
    );
  }
}
