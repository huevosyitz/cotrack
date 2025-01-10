import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

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

class CalendarScreen extends StatelessWidget {
  final EventController eventController = EventController();
  final monthState = GlobalKey<MonthViewState>();

  CalendarScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MonthView(
      controller: eventController,
      key: monthState,
      cellBuilder: (
        date,
        events,
        isToday,
        isInMonth,
        hideDaysNotInMonth,
      ) {
        // Return your widget to display as month cell.
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: yColors.background3,
              width: 0.5,
            ),
            color: isToday ? context.primaryColorDark : context.backgroundColor,
          ),
          child: Text(date.day.toString(),
              style: TextStyle(
                  color: isInMonth
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: .3)
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
        // child: Text(WeekDays.values[day]
        //     .toString()
        //     .substring(WeekDays.values[day].toString().indexOf('.') + 1)),
      ),
      borderSize: 1,
      borderColor: yColors.background3,
      showWeekends: true,
      minMonth: DateTime(1990),
      maxMonth: DateTime(2050),
      initialMonth: DateTime(2021),
      cellAspectRatio: 1,
      onPageChange: (date, pageIndex) => print("$date, $pageIndex"),
      onCellTap: (events, date) {
        // Implement callback when user taps on a cell.
        print(date);
      },
      startDay: WeekDays.sunday, // To change the first day of the week.
      // This callback will only work if cellBuilder is null.
      onEventTap: (event, date) => print(event),
      onEventDoubleTap: (events, date) => print(events),
      onEventLongTap: (event, date) => print(event),
      onDateLongPress: (date) => print(date),
      // headerBuilder: MonthHeader.hidden, // To hide month header
      showWeekTileBorder: false, // To show or hide header border
    ));
  }
}
