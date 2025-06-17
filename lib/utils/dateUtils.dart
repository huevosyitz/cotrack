// create extension on Date
import 'package:intl/intl.dart';

extension DateUtils on DateTime {
  DateTime addMonths(int monthsToAdd) {
    final thisDate = this;
    int newYear = thisDate.year + ((thisDate.month + monthsToAdd - 1) ~/ 12);
    int newMonth = (thisDate.month + monthsToAdd - 1) % 12 + 1;
    int newDay = thisDate.day;

    // Handle shorter months (e.g. Feb)
    int lastDayOfNewMonth = DateTime(newYear, newMonth + 1, 0).day;
    if (newDay > lastDayOfNewMonth) {
      newDay = lastDayOfNewMonth;
    }

    return DateTime(newYear, newMonth, newDay);
  }

  DateTime subtractMonths(int monthsToSubtract) {
    final thisDate = this;

    // Calculate total months since year 0
    int totalMonths =
        (thisDate.year * 12) + (thisDate.month - 1) - monthsToSubtract;

    // Calculate new year and month
    int newYear = totalMonths ~/ 12;
    int newMonth = (totalMonths % 12) + 1;

    // Preserve the day, but adjust for shorter months
    int newDay = thisDate.day;
    int lastDayOfNewMonth = DateTime(newYear, newMonth + 1, 0).day;
    if (newDay > lastDayOfNewMonth) {
      newDay = lastDayOfNewMonth;
    }

    return DateTime(newYear, newMonth, newDay);
  }

  DateTime subtractYears(int yearsToSubtract) {
    return DateTime(year - yearsToSubtract, month, day);
  }
  

  DateTime addWeeks(int weeksToAdd) {
    return add(Duration(days: weeksToAdd * 7));
  }

  DateTime subtractWeeks(int weeksToSubtract) {
    return subtract(Duration(days: weeksToSubtract * 7));
  }

  String yyyyMM() {
    return DateFormat('yyyy-MM').format(this);
  }

  String yyyyMMM() {
    return DateFormat('yyyy-MMM').format(this);
  }

  String yyyyMMdd() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String MMMdd() {
    return DateFormat('MMM-dd').format(this);
  }

  String yyyyWeek() {
    return "$year-W${isoWeekNumber().toString().padLeft(2, '0')}";
  }

  // to first day of month
  DateTime firstDayOfMonth() {
    return DateTime(year, month, 1);
  }

  int isoWeekNumber() {
    // ISO 8601 week date: weeks start on Monday, and the first week of the year is the one with the first Thursday in it.
    final date = this;
    final firstThursday = date.subtract(Duration(days: date.weekday - 4));
    final yearStart = DateTime(firstThursday.year, 1, 1);
    final dayOfYear = firstThursday.difference(yearStart).inDays + 1;
    return ((dayOfYear - 1) / 7).floor() + 1;
  }

  String yearMonthWeek() {
    // Get the first day of the month
    final firstDayOfMonth = DateTime(year, month, 1);

    // Calculate the week number for the current date within the month
    final weekNumber =
        ((day + firstDayOfMonth.weekday - 2) / 7).floor() + 1;

    // Format the result as "yyyy-MMM-Wn"
    return "$year-${DateFormat('MMM').format(this)}-W$weekNumber";
  }
}
