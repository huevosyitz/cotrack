import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cotrack/components/components.dart';
import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:cotrack/themes/themes.dart';
import 'package:cotrack/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:watch_it/watch_it.dart';

class DailyTransactionsScreen extends StatelessWidget {
  final DateTime date;
  final TransactionService transactionService;
  const DailyTransactionsScreen(
      {super.key, required this.date, required this.transactionService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('yyyy-MMM-dd').format(date)),
      ),
      body: QueryBuilder(
        query: transactionService.getTransactionsForDateQuery(date),
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
                child: SizedBox(
                    width: 20, height: 20, child: CircularProgressIndicator()));
          }

          if (state.isError) {
            return Center(
              child: Text(
                'Error: ${state.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          var transactionList = state.data as List<Transaction>;

          return SlidableAutoCloseBehavior(
            child: ListView.builder(
              itemCount: transactionList.length,
              itemBuilder: (context, index) {
                return Slidable(
                  // The end action pane is the one at the right or the bottom side.
                  endActionPane: ActionPane(
                    extentRatio: .4,
                    motion: StretchMotion(),
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                            outlinedButtonTheme: OutlinedButtonThemeData(
                                style: ButtonStyle(
                                    iconColor: WidgetStatePropertyAll(context
                                        .colorScheme.onErrorContainer)))),
                        child: MutationBuilder(
                            mutation:
                                transactionService.deleteTransactionMutation(),
                            builder: (context, state, mutate) {
                              return SlidableAction(
                                onPressed: (_) =>
                                    mutate(transactionList[index]),
                                backgroundColor:
                                    context.colorScheme.errorContainer,
                                foregroundColor:
                                    context.colorScheme.onErrorContainer,
                                icon: yIcons.delete,
                                label: 'Delete',
                              );
                            }),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: yColors.background2,
                      child: Icon(
                        TransactionCategoryService
                            .transactionCategoriesMap[
                                transactionList[index].category_id]!
                            .iconItem
                            .icon,
                        color: context.primaryColor,
                        size: 25,
                      ),
                    ),
                    title: Text(TransactionCategoryService
                            .transactionCategoriesMap[
                                transactionList[index].category_id]
                            ?.name ??
                        "Unknown"),
                    subtitle: Text(transactionList[index].amount.toString()),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
