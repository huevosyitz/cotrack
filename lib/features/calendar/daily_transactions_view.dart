import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cotrack/features/calendar/transaction_list_view.dart';
import 'package:cotrack/features/category/transaction_category_service.dart';
import 'package:cotrack/features/transactions/transaction.dart';
import 'package:cotrack/features/transactions/transaction_service.dart';
import 'package:cotrack/themes/themes.dart';
import 'package:cotrack/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watch_it/watch_it.dart';

class TransactionPassBackDto {
  final bool refresh;
  final Transaction? transaction;

  TransactionPassBackDto({required this.refresh, required this.transaction});
}

class DailyTransactionsView extends StatelessWidget {
  final TransactionService transactionService = di.get();
  final TransactionCategoryService categoryService =
      di.get<TransactionCategoryService>();
  final DateTime date;
  final List<Transaction> transactionList;

  final ValueChanged<TransactionPassBackDto>? onDismiss;
  final ValueNotifier<double> _sumExpense = ValueNotifier(0);
  final ValueNotifier<double> _sumIncome = ValueNotifier(0);

  DailyTransactionsView(
      {super.key,
      required this.date,
      required this.transactionList,
      this.onDismiss}) {
    transactionList.sort(
      (a, b) => a.transaction_date.compareTo(b.transaction_date),
    );
  }

  @override
  Widget build(BuildContext context) {
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

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainer,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('yyyy-MMM-dd').format(date),
                  style: context.bodyLarge,
                ),
                ValueListenableBuilder(
                    valueListenable: _sumIncome,
                    builder: (_, value, __) {
                      return Text(
                        displayFormattedCurrency(value),
                        style:
                            context.bodySmall!.copyWith(color: yColors.primary),
                      );
                    }),
                ValueListenableBuilder(
                    valueListenable: _sumExpense,
                    builder: (_, value, __) {
                      return Text(
                        displayFormattedCurrency(value),
                        style: context.bodySmall!.copyWith(color: yColors.warn),
                      );
                    })
              ],
            ),
          ),
        ),
        TransactionListView(
          transactionList: transactionList,
        ),
      ],
    );
  }
}
