import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cotrack/components/components.dart';
import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:cotrack/pages/calendar/transaction_list_view.dart';
import 'package:cotrack/pages/stats/category_stats.dart';
import 'package:cotrack/themes/themes.dart';
import 'package:cotrack/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryStatsScreen extends StatelessWidget {
  final List<Transaction> transactions;
  CategoryAxisController? _axisController;
  final double xAxisVisible = 8;
  double axisVisibleMin = -1, axisVisibleMax = 7;
  final selectedMonth = ValueNotifier<String?>(null);

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

    final summedData = _sumTransactionsByMonth(transactions).values.toList();
    final groupedData = _groupTransactionsByMonth(transactions);

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
      if (!summedData.any((data) => data.month == month)) {
        summedData.add(CategoryChartData(month, 0));
      }
    }
    // Sort again after adding missing months
    summedData.sort(
      (a, b) {
        // Sort by month in descending order
        DateTime dateA = DateFormat('yyyy-MM').parse(a.month);
        DateTime dateB = DateFormat('yyyy-MM').parse(b.month);
        return dateA.compareTo(dateB); // Descending order
      },
    );

    void performSwipe(ChartSwipeDirection direction) {
      if (direction == ChartSwipeDirection.end) {
        if ((axisVisibleMax + xAxisVisible) < summedData.length) {
          axisVisibleMin = axisVisibleMin + xAxisVisible;
          axisVisibleMax = axisVisibleMax + xAxisVisible;
        } else {
          axisVisibleMin = summedData.length - xAxisVisible + 1;
          axisVisibleMax = summedData.length + 1.toDouble();
        }
      } else if (direction == ChartSwipeDirection.start) {
        if ((axisVisibleMin - xAxisVisible) >= 0) {
          axisVisibleMin = axisVisibleMin - xAxisVisible;
          axisVisibleMax = axisVisibleMax - xAxisVisible;
        } else {
          axisVisibleMin = -1;
          axisVisibleMax = xAxisVisible - 1;
        }
      }

      _axisController!.visibleMaximum = axisVisibleMax;
      _axisController!.visibleMinimum = axisVisibleMin;
    }

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
              initialVisibleMinimum: axisVisibleMin,
              initialVisibleMaximum: axisVisibleMax,
              onRendererCreated: (CategoryAxisController controller) {
                _axisController = controller;
              },
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
            onPlotAreaSwipe: (ChartSwipeDirection direction) =>
                performSwipe(direction),
            series: <CartesianSeries<CategoryChartData, String>>[
              ColumnSeries<CategoryChartData, String>(
                animationDuration: 500,
                // emptyPointSettings: const EmptyPointSettings(
                //   mode: EmptyPointMode.drop,
                // ),
                dataSource: summedData,
                xValueMapper: (CategoryChartData data, _) => data.month,
                yValueMapper: (CategoryChartData data, _) => data.totalAmount,
                color: _colorMap[category.transactionType],
                onPointTap: (pointInteractionDetails) {
                  final pointIndex = pointInteractionDetails.pointIndex;
                  if (pointIndex != null) {
                    final tappedData = summedData[pointIndex];
                    if (tappedData != null) {
                      // Handle the tap event here

                      selectedMonth.value = tappedData.month;
                      print(
                          'Tapped on ${tappedData.month} with amount: ${tappedData.totalAmount}');
                    }
                  }
                },
              ),
            ],
          ),
          const Divider(),
          ValueListenableBuilder(
              valueListenable: selectedMonth,
              builder: (_, value, __) {
                if (value == null) {
                  return const Center(
                    child: Text("Select a month to view transactions"),
                  );
                }

                final transactionList = groupedData[value] ?? [];

                final sum =
                    transactionList.fold(0.0, (sum, item) => sum + item.amount);

                final header = Container(
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainer,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat('yyyy-MMM')
                              .format(DateTime.parse("$value-01")),
                          style: context.bodyLarge,
                        ),
                        Text(
                          displayFormattedCurrency(sum),
                          style:
                              context.bodySmall!.copyWith(color: yColors.warn),
                        )
                      ],
                    ),
                  ),
                );

                return Expanded(
                  child: Column(
                    children: [
                      header,
                      if (transactionList.isEmpty) ...{
                        const Center(
                          child: Text("No transactions for this month"),
                        ),
                      } else ...{
                        TransactionListView(
                          transactionList: transactionList,
                        ),
                      }
                    ],
                  ),
                );

                // if (groupedData[selectedMonth.value]?.isEmpty ?? true) {
                //   return Expanded(
                //     child: Center(
                //       child: Text(
                //         'No transactions for $selectedMonth',
                //         style: context.labelMedium,
                //       ),
                //     ),
                //   );
                // } else {
                //   return Expanded(
                //       child: TransactionListView(
                //     transactionList: groupedData[selectedMonth.value]!,
                //   ));
                // }
              }),
        ],
      ),
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
        month,
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
  final String month;
  double totalAmount;

  CategoryChartData(this.month, this.totalAmount);
}
