import 'dart:math';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cotrack/components/components.dart';
import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:cotrack/pages/calendar/transaction_list_view.dart';
import 'package:cotrack/pages/stats/models/category_stats.dart';
import 'package:cotrack/themes/themes.dart';
import 'package:cotrack/utils/extensions.dart';
import 'package:cotrack/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:watch_it/watch_it.dart';

class CategoryStatsScreen extends StatelessWidget {
  final transactionService = di.get<TransactionService>();
  CategoryAxisController? _axisController;
  final int xAxisVisible = 6;
  double axisVisibleMin = -1, axisVisibleMax = 7;
  final selectedMonth = ValueNotifier<DateTime?>(null);
  final int categoryId;
  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
    enablePanning: true,
    enablePinching: true,
    zoomMode: ZoomMode.x,
  );

  CategoryStatsScreen({super.key, required this.categoryId});

  final Map<TransactionType, Color> _colorMap = {
    TransactionType.expense: yColors.warn,
    TransactionType.income: yColors.primary,
    TransactionType.transfer: yColors.neutral,
  };

  @override
  Widget build(BuildContext context) {
    return QueryBuilder(
      query: transactionService.getAllMyTransactionsQuery(),
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.isError) {
          return Center(
            child: Text(
              'Error: ${state.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final transactionList = state.data as List<Transaction>;

        final transactions =
            transactionList.where((e) => e.category_id == categoryId).toList();

        if (transactionList.isEmpty) {
          return const Center(
            child: Text("No transactions found"),
          );
        }

        final category =
            TransactionCategoryService.transactionCategoriesMap[categoryId]!;

        final chartData = _sumTransactionsByMonth(transactions).values.toList();
        final groupedData = _groupTransactionsByMonth(transactions);

        final minTransactionDate = transactions
            .map((e) => e.transaction_date)
            .reduce((a, b) => a.isBefore(b) ? a : b);
        final maxTransactionDate = transactions
            .map((e) => e.transaction_date)
            .reduce((a, b) => a.isAfter(b) ? a : b);

        // generate months starting from the minTransactionDate to maxTransactionDate
        final months = <DateTime>[];
        DateTime currentDate =
            DateTime(minTransactionDate.year, minTransactionDate.month);
        DateTime endDate =
            DateTime(maxTransactionDate.year, maxTransactionDate.month + 1);
        while (currentDate.isBefore(endDate)) {
          months.add(currentDate);
          currentDate = DateTime(currentDate.year, currentDate.month + 1);
        }

        // fill in missing months with 0 values
        for (var month in months) {
          if (!chartData.any((data) => data.month == month)) {
            chartData.add(CategoryChartData(month, 0));
          }
        }

        // Sort again after adding missing months
        chartData.sort(
          (a, b) {
            return a.month.compareTo(b.month); // Descending order
          },
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(category.name),
          ),
          body: Column(
            children: [
              SfCartesianChart(
                zoomPanBehavior: _zoomPanBehavior,
                primaryXAxis: DateTimeCategoryAxis(
                  dateFormat: DateFormat('yyyy-MMM'),
                  labelStyle: const TextStyle(fontSize: 8),
                  labelRotation: 45,
                  labelPlacement: LabelPlacement.betweenTicks,
                  intervalType: DateTimeIntervalType.months,
                  interval: 1,
                  minimum: chartData.first.month,
                  maximum: chartData.last.month,
                  initialVisibleMinimum:
                      chartData.last.month.subtractMonths(xAxisVisible - 1),
                  initialVisibleMaximum: chartData.last.month,
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
                series: <CartesianSeries<CategoryChartData, DateTime>>[
                  ColumnSeries<CategoryChartData, DateTime>(
                    animationDuration: 500,
                    dataSource: [...chartData],
                    xValueMapper: (CategoryChartData data, _) => data.month,
                    yValueMapper: (CategoryChartData data, _) =>
                        data.totalAmount,
                    color: _colorMap[category.transactionType],
                    onPointTap: (pointInteractionDetails) {
                      final pointIndex = pointInteractionDetails.pointIndex;
                      if (pointIndex != null) {
                        final tappedData = chartData[pointIndex];
                        // Handle the tap event here

                        selectedMonth.value = tappedData.month;
                        Loggy.debug(
                            'Tapped on ${tappedData.month} with amount: ${tappedData.totalAmount}');
                      }
                    },
                  ),
                ],
              ),
              const Divider(),
              ValueListenableBuilder(
                  valueListenable: selectedMonth,
                  builder: (_, month, __) {
                    if (month == null) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: const Center(
                            child: Text(
                                "Tap on a bar in the graph to view transactions for that month."),
                          ),
                        ),
                      );
                    }

                    final transactionList = groupedData[month.yyyyMM()] ?? [];

                    final sum = transactionList.fold(
                        0.0, (sum, item) => sum + item.amount);

                    final header = Container(
                      decoration: BoxDecoration(
                        color: context.colorScheme.surfaceContainer,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              DateFormat('yyyy-MMMM').format(month),
                              style: context.bodyLarge,
                            ),
                            Text(
                              displayFormattedCurrency(sum),
                              style: context.bodySmall!
                                  .copyWith(color: yColors.warn),
                            )
                          ],
                        ),
                      ),
                    );

                    if (transactionList.isEmpty) {
                      Column(
                        children: [
                          header,
                          Expanded(
                            child: const Center(
                              child: Text("No transactions for this month"),
                            ),
                          ),
                        ],
                      );
                    }

                    return Expanded(
                      child: Column(
                        children: [
                          header,
                          TransactionListView(
                            transactionList: transactionList,
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        );
      },
    );
  }
}

Map<String, CategoryChartData> _sumTransactionsByMonth(
    List<Transaction> transactions) {
  Map<String, CategoryChartData> groupedData = {};

  for (var transaction in transactions) {
    // Format the transaction date to get the month (e.g., "January 2023")
    String month = DateFormat('yyyy-MM').format(transaction.transaction_date);

    // Initialize the month group if it doesn't exist
    if (!groupedData.containsKey(month)) {
      groupedData[month] = CategoryChartData(
        transaction.transaction_date.firstDayOfMonth(),
        transaction.amount,
      );
    } else {
      groupedData[month]!.totalAmount += transaction.amount;
    }
  }

  return groupedData;
}

Map<String, List<Transaction>> _groupTransactionsByMonth(
    List<Transaction> transactions) {
  Map<String, List<Transaction>> groupedData = {};

  for (var transaction in transactions) {
    // Format the transaction date to get the month (e.g., "January 2023")
    String month = DateFormat('yyyy-MM').format(transaction.transaction_date);

    // Initialize the month group if it doesn't exist
    if (!groupedData.containsKey(month)) {
      groupedData[month] = [];
    }

    groupedData[month]!.add(transaction);
  }

  return groupedData;
}

class CategoryChartData {
  final DateTime month;
  double totalAmount;

  CategoryChartData(this.month, this.totalAmount);
}
