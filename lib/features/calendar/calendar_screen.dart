import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:cotrack/features/calendar/daily_transactions_view.dart';
import 'package:cotrack/features/calendar/monthly_view_comp.dart';
import 'package:cotrack/features/category/transaction_category_service.dart';
import 'package:cotrack/features/transactions/transaction.dart';
import 'package:cotrack/features/transactions/transaction_service.dart';
import 'package:cotrack/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import 'package:cotrack/features/stats/add_edit_transaction_modal_screen.dart';
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

  void refreshCalendarData(QueryState<List<Transaction>> state) {
    final transactions = state.data as List<Transaction>;
    final existingEvents = eventController.allEvents;

    // Build lookup maps for quick ID access
    final existingMap = {
      for (var e in existingEvents) (e.event as Transaction).id: e
    };
    final transactionMap = {for (var t in transactions) t.id: t};

    // Remove events no longer in transactions
    final toRemove = existingEvents
        .where((e) => !transactionMap.containsKey((e.event as Transaction).id))
        .toList();
    eventController.removeAll(toRemove);

    // Add new events
    final toAdd = transactions
        .where((t) => !existingMap.containsKey(t.id))
        .map(_toCalendarEvent)
        .toList();
    eventController.addAll(toAdd);

    // Update changed events
    for (var existingEvent in existingEvents) {
      final oldTran = existingEvent.event as Transaction;
      final newTran = transactionMap[oldTran.id];
      if (newTran != null && oldTran.updated_at != newTran.updated_at) {
        eventController.update(existingEvent, _toCalendarEvent(newTran));
      }
    }

    var (selectedDate, selectedTrans) = selectedDateTransactions.value;
    final today = selectedDate ?? DateTime.now();
    // get transactions for the selected date
    final filteredTransactions = transactions
        .where((t) => t.transaction_date.isSameDayAs(today))
        .toList();

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
                openAddTransactionModal(context, date);
              },
              onTap: (date, transactions) {
                selectedDateTransactions.value = (date, transactions);
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
      builder: (context) => AddEditTransactionModelScreen(
            initialTransactionDate: date,
          ));
}
