import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:cotrack/pages/stats/category_stats.dart';
import 'package:cotrack/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryStatsScreen extends StatelessWidget {
  final List<Transaction> transactions;
  CategoryStatsScreen({super.key, required this.transactions});

  final Map<TransactionType, Color> _colorMap = {
    TransactionType.expense: yColors.warn,
    TransactionType.income: yColors.primary,
    TransactionType.transfer: yColors.neutral,
  };

  @override
  Widget build(BuildContext context) {
    final category = TransactionCategoryService
        .transactionCategoriesMap[transactions.first.category_id]!;

    final groupedData = _groupTransactionsByMonth(transactions).values.toList();

    final minTransactionDate = transactions
        .map((e) => e.transaction_date)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final maxTransactionDate = transactions
        .map((e) => e.transaction_date)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    // generate months starting from the minTransactionDate to maxTransactionDate
    final months = <String>[];
    DateTime currentDate =
        DateTime(minTransactionDate.year, minTransactionDate.month);
    DateTime endDate =
        DateTime(maxTransactionDate.year, maxTransactionDate.month + 1);
    while (currentDate.isBefore(endDate)) {
      months.add(DateFormat('yyyy-MM').format(currentDate));
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    }

    // fill in missing months with 0 values
    for (var month in months) {
      if (!groupedData.any((data) => data.month == month)) {
        groupedData.add(CategoryChartData(month, 0));
      }
    }
    // Sort again after adding missing months
    groupedData.sort(
      (a, b) {
        // Sort by month in descending order
        DateTime dateA = DateFormat('yyyy-MM').parse(a.month);
        DateTime dateB = DateFormat('yyyy-MM').parse(b.month);
        return dateA.compareTo(dateB); // Descending order
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: Column(
        children: [
          SfCartesianChart(
            primaryXAxis: CategoryAxis(
              labelStyle: const TextStyle(fontSize: 8),
              majorGridLines: const MajorGridLines(width: 0),
              labelRotation: 45,
              interval: 1,
            ),
            primaryYAxis: NumericAxis(
              labelFormat: '{value}',
              labelStyle: const TextStyle(fontSize: 10),
              maximumLabels: 2,
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              format: 'point.x : ₱point.y',
              header: '',
            ),
            // Columns will be rendered back to back
            enableSideBySideSeriesPlacement: false,
            series: <CartesianSeries<CategoryChartData, String>>[
              ColumnSeries<CategoryChartData, String>(
                animationDuration: 500,
                // emptyPointSettings: const EmptyPointSettings(
                //   mode: EmptyPointMode.drop,
                // ),
                dataSource: groupedData,
                xValueMapper: (CategoryChartData data, _) => data.month,
                yValueMapper: (CategoryChartData data, _) => data.totalAmount,
                color: _colorMap[category.transactionType],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Map<String, CategoryChartData> _groupTransactionsByMonth(
    List<Transaction> transactions) {
  Map<String, CategoryChartData> groupedData = {};

  for (var transaction in transactions) {
    // Format the transaction date to get the month (e.g., "January 2023")
    String month = DateFormat('yyyy-MM').format(transaction.transaction_date);

    // Initialize the month group if it doesn't exist
    if (!groupedData.containsKey(month)) {
      groupedData[month] = CategoryChartData(
        month,
        transaction.amount,
      );
    } else {
      groupedData[month]!.totalAmount += transaction.amount;
    }
  }

  return groupedData;
}

class CategoryChartData {
  final String month;
  double totalAmount;

  CategoryChartData(this.month, this.totalAmount);
}
