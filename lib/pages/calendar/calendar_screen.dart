import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:cotrack/core/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import 'package:cotrack/core/services/services.dart';
import 'package:cotrack/pages/calendar/transaction_modal_screen.dart';
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

DateTime get _now => DateTime.now();

// final events = [
//   CalendarEventData(
//     date: _now,
//     title: 456.24.toString(),
//     color: yColors.primary,
//     startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
//   ),
//   CalendarEventData(
//     date: _now,
//     title: 234234.toString(),
//     color: yColors.warn,
//     startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
//   ),
// ];

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CalendarMonthView());
  }
}

class CalendarMonthView extends StatelessWidget {
  final EventController eventController = EventController();
  final monthState = GlobalKey<MonthViewState>();

  CalendarMonthView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final q = di.get<TransactionService>().getAllMyTransactionsQuery();
    final categoryService = di.get<TransactionCategoryService>();

    q.stream.listen((state) {
      if (state.status == QueryStatus.loading) {
        // show loading spinner
      }
      if (state.data != null) {
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
      }
    });

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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              maxRadius: 10,
              backgroundColor: isToday ? context.primaryColor : context.surface,
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  fontSize: 12,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (expenseAmount > 0)
                        Text(
                          expenseAmount.toString(),
                          style: TextStyle(
                            color: yColors.warn,
                            fontSize: 12,
                          ),
                        ),
                      if (incomeAmount > 0)
                        Text(
                          incomeAmount.toString(),
                          style: TextStyle(
                            color: yColors.primary,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              )
          ],
        );

        // // Return your widget to display as month cell.
        // return Container(
        //   decoration: BoxDecoration(
        //     border: Border.all(
        //       color: yColors.background3,
        //       width: 0.5,
        //     ),
        //     // color: isToday ? context.primaryColorDark : context.backgroundColor,
        //   ),
        //   child: Text(date.day.toString(),
        //       style: TextStyle(
        //           color: isInMonth
        //               ? Theme.of(context).colorScheme.onSurface
        //               : Theme.of(context)
        //                   .colorScheme
        //                   .onSurface
        //                   .withValues(alpha: .3))),
        // );
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
        // child: Text(WeekDays.values[day]
        //     .toString()
        //     .substring(WeekDays.values[day].toString().indexOf('.') + 1)),
      ),
      borderSize: 1,
      borderColor: yColors.background,
      showWeekends: true,
      minMonth: DateTime(1990),
      maxMonth: DateTime(2050),
      initialMonth: DateTime.now(),
      cellAspectRatio: 1,
      onPageChange: (date, pageIndex) => print("$date, $pageIndex"),
      onCellTap: (events, date) async {
        // Implement callback when user taps on a cell.
        print(date);

        showCupertinoSheet(
            context: context,
            pageBuilder: (context) => TransactionModelScreen(
                  date: date,
                ));

        // var result = await showCupertinoModalBottomSheet(
        //     expand: true,
        //     isDismissible: false,
        //     useRootNavigator: true,
        //     context: context,
        //     backgroundColor: Colors.transparent,
        //     builder: (context) => TransactionModelScreen(
        //           date: date,
        //         ));
      },
      startDay: WeekDays.sunday, // To change the first day of the week.
      // This callback will only work if cellBuilder is null.
      onEventTap: (event, date) => print(event),
      onEventDoubleTap: (events, date) => print(events),
      onEventLongTap: (event, date) => print(event),
      onDateLongPress: (date) => print(date),
      // headerBuilder: MonthHeader.hidden, // To hide month header
      showWeekTileBorder: false, // To show or hide header border
    );
  }
}
