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
  final ValueNotifier<double> _sumExpense = ValueNotifier(0);
  final ValueNotifier<double> _sumIncome = ValueNotifier(0);

  DailyTransactionsScreen(
      {super.key, required this.date, required this.transactionService});

  @override
  Widget build(BuildContext context) {
    final categoryService = di.get<TransactionCategoryService>();
    return QueryBuilder(
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

        // Calculate sum of transaction list amounts
        _sumExpense.value = transactionList.fold(0.0, (sum, item) {
          return sum +
              (categoryService.isExpenseCategory(item.category_id)
                  ? item.amount
                  : 0);
        });

        _sumIncome.value = transactionList.fold(0.0, (sum, item) {
          return sum +
              (categoryService.isIncomeCategory(item.category_id)
                  ? item.amount
                  : 0);
        });

        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('yyyy-MMM-dd').format(date)),
                ValueListenableBuilder(
                    valueListenable: _sumIncome,
                    builder: (_, value, __) {
                      return Text(
                        "₱ ${value.toStringAsFixed(2)}",
                        style:
                            context.bodySmall!.copyWith(color: yColors.primary),
                      );
                    }),
                ValueListenableBuilder(
                    valueListenable: _sumExpense,
                    builder: (_, value, __) {
                      return Text(
                        "₱ ${value.toStringAsFixed(2)}",
                        style: context.bodySmall!.copyWith(color: yColors.warn),
                      );
                    })
              ],
            ),
          ),
          body: SlidableAutoCloseBehavior(
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
                    minLeadingWidth: 60,
                    leading: SizedBox(
                      width: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            TransactionCategoryService
                                .transactionCategoriesMap[
                                    transactionList[index].category_id]!
                                .name,
                            style: context.labelSmall!
                                .copyWith(color: yColors.primaryTextFade1),
                          )
                        ],
                      ),
                    ),
                    title: (transactionList[index].notes ?? "").isEmpty
                        ? Text(
                            TransactionCategoryService
                                .transactionCategoriesMap[
                                    transactionList[index].category_id]!
                                .name,
                            style: TextStyle(color: yColors.primaryTextFade2))
                        : Text(transactionList[index]!.notes!),
                    subtitle: Text(
                      TransactionAccountService
                              .transactionAccountsMap[
                                  transactionList[index].account_id]
                              ?.name ??
                          "Unknown",
                      style: context.labelSmall!
                          .copyWith(color: yColors.primaryTextFade1),
                    ),
                    trailing: Text(
                      "₱ ${transactionList[index].amount}",
                      style: context.labelSmall!.copyWith(
                          color: categoryService.isIncomeCategory(
                                  transactionList[index].category_id)
                              ? yColors.primary
                              : yColors.warn),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
