import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:cotrack/pages/pages.dart';
import 'package:cotrack/themes/themes.dart';

class MonthlyCalendarView extends StatelessWidget {
  final monthState = GlobalKey<MonthViewState>();
  final EventController eventController;
  final transactionService = di.get<TransactionService>();
  final categoryService = di.get<TransactionCategoryService>();
  final Function(DateTime)? onDoubleTap;
  final Function(DateTime, List<Transaction>)? onTap;
  final selectedDate = ValueNotifier(DateTime.now());

  MonthlyCalendarView({
    super.key,
    required this.eventController,
    this.onDoubleTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
          onDoubleTap: () => onDoubleTap?.call(date),
          onTap: () {
            selectedDate.value = date;
            onTap?.call(
                date, events.map((e) => e.event as Transaction).toList());
          },
          child: BorderedCalendarCell(
              selectedDate: selectedDate,
              date2: date,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    maxRadius: 8,
                    backgroundColor:
                        isToday ? context.primaryColor : context.surface.withValues(alpha: 0),
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
                                expenseAmount.truncateToDouble() ==
                                        expenseAmount
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
              )),
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
}

class BorderedCalendarCell extends StatelessWidget {
  final ValueNotifier<DateTime> selectedDate;
  final Widget child;
  final DateTime date2;

  const BorderedCalendarCell(
      {super.key,
      required this.selectedDate,
      required this.date2,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: selectedDate,
      builder: (context, date, _) {
        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: date.isSameDayAs(date2)
                  ? context.primaryColor.withValues(alpha: .3)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child:
              child, // This won’t rebuild unless you change the `child` param
        );
      },
    );
  }
}
