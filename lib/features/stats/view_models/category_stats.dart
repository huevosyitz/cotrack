import 'package:cotrack/features/transactions/transaction_type.dart';
import 'package:flutter/material.dart';

enum StatsTabs { income, all, expense }

extension StatsTabsExtension on TransactionType {
  StatsTabs toStatsTab() {
    switch (this) {
      case TransactionType.income:
        return StatsTabs.income;
      case TransactionType.expense:
        return StatsTabs.expense;
      default:
        throw ArgumentError(
            'Invalid TransactionType: $this. Cannot convert to StatsTabs.');
    }
  }
}

class CategoryStats {
  CategoryStats(this.categoryId, this.categoryName, this.totalAmount,
      {this.color, this.statsTab});
  final int categoryId;
  final String categoryName;
  double totalAmount;
  StatsTabs? statsTab;
  final Color? color;
}
