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

  // to first day of month
  DateTime firstDayOfMonth() {
    return DateTime(this.year, this.month, 1);
  }
}
