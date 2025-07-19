import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:cotrack/core/services/logger.dart';
import 'package:cotrack/features/calendar/daily_transactions_view.dart';
import 'package:cotrack/features/calendar/monthly_view_comp.dart';
import 'package:cotrack/features/category/transaction_category_service.dart';
import 'package:cotrack/features/transactions/transaction_add_modal_screen.dart';
import 'package:cotrack/features/transactions/transaction_entity.dart';
import 'package:cotrack/features/transactions/transaction_service.dart';
import 'package:cotrack/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import 'package:cotrack/themes/themes.dart';

class CalendarScreen extends StatelessWidget {
  final EventController eventController = EventController();
  final monthState = GlobalKey<MonthViewState>();
  final transactionService = di.get<TransactionService>();
  final categoryService = di.get<TransactionCategoryService>();
  final selectedDateTransactions =
      AlwaysNotifyValueNotifier<(DateTime?, List<Transaction>)>((null, []));

  CalendarScreen({
    super.key,
  }) {
    final transactionQuery = transactionService.getAllMyTransactionsQuery();

    transactionQuery.stream.listen((state) {
      if (state.status == QueryStatus.loading) {
        // show loading spinner
      } else if (state.data != null) {
        refreshCalendarData(state);
      }
    });
  }

  List<Transaction> getTransactionForDate(DateTime date) {
    return transactionService
            .getAllMyTransactionsQuery()
            .state
            .data
            ?.where((t) => t.transaction_date.isSameDayAs(date))
            .toList() ??
        [];
  }

  void refreshCalendarData(QueryState<List<Transaction>> state) {
    final transactions = state.data as List<Transaction>;

    eventController.removeWhere((a) => true);

    var toAdd = <CalendarEventData>[];

    var getDistinctDates = transactions
        .map((e) => e.transaction_date.yyyyMMdd())
        .toSet()
        .map((e) => DateTime.parse(e))
        .toList()
      ..sort((a, b) => a.compareTo(b));

    // for each distinct day, add a dummy transaction with one expenseAmount and one incomeAmount
    for (var date in getDistinctDates) {
      var transactionsForDate = transactions
          .where((t) => t.transaction_date.isSameDayAs(date))
          .toList();

      final expenseAmount = transactionsForDate
          .where((e) => categoryService.isExpenseCategory(e.category_id))
          .map((e) => e.amount)
          .fold(0.0, (value, element) => value + element);

      final incomeAmount = transactionsForDate
          .where((e) => categoryService.isIncomeCategory(e.category_id))
          .map((e) => e.amount)
          .fold(0.0, (value, element) => value + element);

      if (expenseAmount > 0) {
        // Create a dummy transaction for the date
        final dummyTransaction = Transaction(
          id: "dummy-${date.toIso8601String()}",
          amount: expenseAmount,
          category_id: TransactionCategoryService
              .expenseCategories.first.id, // dummy category
          transaction_date: date,
          updated_at: date,
          created_at: date,
          account_id: 1,
          created_by: "user",
          notes: "Dummy transaction for $date",
          group_id: 1,
          updated_by: "user",
        );
        toAdd.add(_toCalendarEvent(dummyTransaction));
      }

      if (incomeAmount > 0) {
        final dummyTransaction = Transaction(
          id: "dummy-${date.toIso8601String()}",
          amount: incomeAmount,
          category_id: TransactionCategoryService
              .incomeCategories.first.id, // dummy category
          transaction_date: date,
          updated_at: date,
          created_at: date,
          account_id: 1,
          created_by: "user",
          notes: "Dummy transaction for $date",
          group_id: 1,
          updated_by: "user",
        );
        toAdd.add(_toCalendarEvent(dummyTransaction));
      }
    }
    eventController.addAll(toAdd);

    refreshSelectedDateTransactions();
  }

  void refreshSelectedDateTransactions() {
    var (selectedDate, selectedTrans) = selectedDateTransactions.value;
    final today = selectedDate ?? DateTime.now();
    // get transactions for the selected date
    final filteredTransactions = getTransactionForDate(today);

    selectedDateTransactions.value = (today, filteredTransactions);
  }

  CalendarEventData<Transaction> _toCalendarEvent(Transaction t) {
    return CalendarEventData(
      date: t.transaction_date,
      title: "${t.id}::${t.updated_at ?? ""}",
      event: t,
      color: categoryService.isIncomeCategory(t.category_id)
          ? yColors.primary
          : yColors.warn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 400,
            child: MonthlyCalendarView(
              eventController: eventController,
              onDoubleTap: (date) {
                var txForDay = getTransactionForDate(date);
                selectedDateTransactions.value = (date, txForDay);
                openAddTransactionModal(context, date);
              },
              onTap: (date, transactions) {
                var txForDay = getTransactionForDate(date);
                selectedDateTransactions.value = (date, txForDay);
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<(DateTime?, List<Transaction>)>(
                valueListenable: selectedDateTransactions,
                builder: (context, value, child) {
                  var (date, list) = value;
                  if (date == null) {
                    return const Center(
                      child: Text("No transactions for this date"),
                    );
                  }

                  return DailyTransactionsView(
                    date: date,
                    transactionList: list,
                  );
                }),
          ),
        ],
      ),
    );
  }
}

Future<dynamic> openAddTransactionModal(BuildContext context, DateTime date) {
  return showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (context) => AddTransactionModelScreen(
            initialTransactionDate: date,
          ));
}
