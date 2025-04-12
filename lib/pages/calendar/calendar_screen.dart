import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/pages/calendar/daily_transactions_view.dart';
import 'package:cotrack/pages/pages.dart';
import 'package:cotrack/pages/transactions/daily_transactions_screen.dart';
import 'package:cotrack/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:watch_it/watch_it.dart';

import 'package:cotrack/core/services/services.dart';
import 'package:cotrack/pages/transactions/add_edit_transaction_modal_screen.dart';
import 'package:cotrack/themes/themes.dart';

const List<String> months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];

const List<String> weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

class CalendarScreen extends HookWidget {
  final EventController eventController = EventController();
  final monthState = GlobalKey<MonthViewState>();

  CalendarScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final transactionService = di.get<TransactionService>();
    final transactionQuery = transactionService.getAllMyTransactionsQuery();
    final categoryService = di.get<TransactionCategoryService>();
    final selectedDate = useState(DateTime.now());
    final selectedTransactions = useState<List<Transaction>>([]);

    transactionQuery.stream.listen((state) {
      if (state.status == QueryStatus.loading) {
        // show loading spinner
        if (context.mounted) context.loaderOverlay.show();
      } else if (state.data != null) {
        eventController.removeWhere((e) => true);
        final transactionList = state.data as List<Transaction>;

        final newEvents = transactionList
            .map((transaction) => CalendarEventData(
                  date: transaction.transaction_date,
                  title: transaction.amount.toString(),
                  event: transaction,
                  color:
                      categoryService.isIncomeCategory(transaction.category_id)
                          ? yColors.primary
                          : yColors.warn,
                ))
            .toList();

        eventController.addAll(newEvents);
        if (context.mounted) context.loaderOverlay.hide();
      }
    });

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 400,
            child: _monthView(
                categoryService, context, selectedDate, selectedTransactions),
          ),
          Expanded(
            child: DailyTransactionsView(
              date: selectedDate.value,
              transactionList: selectedTransactions.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _monthView(
      TransactionCategoryService categoryService,
      BuildContext context,
      ValueNotifier<DateTime> selectedDate,
      ValueNotifier<List<Transaction>> selectedTransactions) {
    return MonthView(
      controller: eventController,
      key: monthState,
      cellBuilder: (
        date,
        events,
        isToday,
        isInMonth,
        hideDaysNotInMonth,
      ) {
        final expenseAmount = events
            .map((e) => (e.event as Transaction))
            .where((e) => categoryService.isExpenseCategory(e.category_id))
            .map((e) => e.amount)
            .fold(0.0, (value, element) => value + element);

        final incomeAmount = events
            .map((e) => (e.event as Transaction))
            .where((e) => categoryService.isIncomeCategory(e.category_id))
            .map((e) => e.amount)
            .fold(0.0, (value, element) => value + element);

        return GestureDetector(
          onDoubleTap: () => openAddTransactionModal(context, date),
          onTap: () {
            selectedDate.value = date;
            selectedTransactions.value =
                events.map((e) => e.event as Transaction).toList();
            // openDailyTransactionModal(context, date, transactionQuery);
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedDate.value == date
                    ? context.primaryColor
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  maxRadius: 10,
                  backgroundColor:
                      isToday ? context.primaryColor : context.surface,
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 10,
                      color: isInMonth
                          ? (isToday
                              ? context.colorScheme.onPrimary
                              : context.colorScheme.onSurface)
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: .2),
                    ),
                  ),
                ),
                if (events.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (expenseAmount > 0)
                            Text(
                              expenseAmount.truncateToDouble() == expenseAmount
                                  ? expenseAmount.toInt().toString()
                                  : expenseAmount.toString().toString(),
                              style: TextStyle(
                                color: yColors.warn,
                                fontSize: 10,
                              ),
                            ),
                          if (incomeAmount > 0)
                            Text(
                              incomeAmount.truncateToDouble() == incomeAmount
                                  ? incomeAmount.toInt().toString()
                                  : incomeAmount.toString().toString(),
                              style: TextStyle(
                                color: yColors.primary,
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
      headerStringBuilder: (date, {secondaryDate}) =>
          "${months[date.month - 1]} ${date.year}",
      headerStyle: HeaderStyle(
        headerPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: yColors.background2,
        ),
        headerTextStyle: TextStyle(
          color: context.primaryColor,
        ),
        leftIconConfig: IconDataConfig(
          icon: (context) => GestureDetector(
            onTap: () {
              monthState.currentState?.previousPage();
            },
            child: Icon(
              yIcons.leftArrow,
              color: context.primaryColor,
            ),
          ),
        ),
        rightIconConfig: IconDataConfig(
          icon: (context) => GestureDetector(
            onTap: () {
              monthState.currentState?.nextPage();
            },
            child: Icon(
              yIcons.arrowRight,
              color: context.primaryColor,
            ),
          ),
        ),
      ),
      useAvailableVerticalSpace: true,
      weekDayBuilder: (day) => Center(
        // map day 0 to 6 to Mon to Sun trimmed by 3 characters
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(weekdays[day]),
        ),
      ),
      borderSize: 1,
      borderColor: yColors.background,
      showWeekends: true,
      minMonth: DateTime(1990),
      maxMonth: DateTime(2050),
      initialMonth: DateTime.now(),
      cellAspectRatio: 1,
      onPageChange: (date, pageIndex) => print("$date, $pageIndex"),
      startDay: WeekDays.sunday, // To change the first day of the week.
      // This callback will only work if cellBuilder is null.
      onEventTap: (event, date) => print("tap $event"),
      onEventDoubleTap: (events, date) => print("doubletap $events"),
      onEventLongTap: (event, date) => print("longtap $event"),
      onDateLongPress: (date) => print("longpress $date"),
      // headerBuilder: MonthHeader.hidden, // To hide month header
      showWeekTileBorder: false, // To show or hide header border
    );
  }

  Future<dynamic> openDailyTransactionModal(
      BuildContext context, DateTime date, Query<List<Transaction>> q) {
    return showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        context: context,
        builder: (context) => FractionallySizedBox(
              heightFactor: 0.7,
              child: DailyTransactionsScreen(
                date: date,
                onDismiss: (value) async {
                  if (value.refresh) {
                    await q.refetch();
                  }
                },
              ),
            ));
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
}
