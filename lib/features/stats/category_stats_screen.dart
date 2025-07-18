import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:cotrack/features/calendar/transaction_list_view.dart';
import 'package:cotrack/features/calendar/view_models/transaction_list_view_sort_field.dart';
import 'package:cotrack/features/category/transaction_category_service.dart';
import 'package:cotrack/features/stats/stats_screen.dart';
import 'package:cotrack/features/stats/view_models/stats_interval.dart';
import 'package:cotrack/features/transactions/transaction_entity.dart';
import 'package:cotrack/features/transactions/transaction_service.dart';
import 'package:cotrack/features/transactions/transaction_type.dart';
import 'package:cotrack/themes/themes.dart';
import 'package:cotrack/utils/utils.dart';
import 'package:cotrack/core/viewModels/sort_by.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:watch_it/watch_it.dart';

class CategoryStatsScreen extends StatelessWidget {
  final transactionService = di.get<TransactionService>();
  final int xAxisVisible = 6;
  double axisVisibleMin = -1, axisVisibleMax = 7;
  final selectedMonth = ValueNotifier<DateTime?>(null);
  final int? categoryId;
  final TransactionType? transactionType;
  final StatsInterval interval;
  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
    enablePanning: true,
    enablePinching: true,
    zoomMode: ZoomMode.x,
  );

  CategoryStatsScreen({
    super.key,
    required this.interval,
    this.categoryId,
    this.transactionType,
  }) {
    // throw if both are null
    if (categoryId == null && transactionType == null) {
      throw ArgumentError(
          'Either categoryId or transactionType must be provided but not both.');
    }
  }

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

        final transactions = categoryId != null
            ? transactionList.where((e) => e.category_id == categoryId).toList()
            : transactionList
                .where((e) =>
                    TransactionCategoryService
                        .transactionCategoriesMap[e.category_id]!
                        .transactionType ==
                    transactionType)
                .toList();

        if (transactionList.isEmpty) {
          return const Center(
            child: Text("No transactions found"),
          );
        }

        final String appBarTitle;
        final TransactionType categoryTransaction;
        if (categoryId != null) {
          final category =
              TransactionCategoryService.transactionCategoriesMap[categoryId]!;
          appBarTitle = category.name;
          categoryTransaction = category.transactionType;
        } else if (transactionType != null) {
          appBarTitle = transactionType!.name.capitalizeFirst;
          categoryTransaction = transactionType!;
        } else {
          appBarTitle = 'All Transactions';
          categoryTransaction = transactionType!;
        }

        final groupedData =
            _groupTransactionsByInterval(transactions, interval);

        final chartData = generateChartData(transactions, interval);

        DateTimeCategoryAxis xAxis = getXAxisConfig(chartData);

        return Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
          ),
          body: Column(
            children: [
              SfCartesianChart(
                zoomPanBehavior: _zoomPanBehavior,
                primaryXAxis: xAxis,
                primaryYAxis: NumericAxis(
                  labelFormat: '{value}',
                  labelStyle: const TextStyle(fontSize: 10),
                  maximumLabels: 2,
                  minimum: 0,
                ),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  format: 'point.x : ₱point.y',
                  header: '',
                  shouldAlwaysShow: true,
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
                    color: _colorMap[categoryTransaction],
                    selectionBehavior: SelectionBehavior(
                      enable: true, // Enable selection
                      selectedBorderColor: yColors
                          .primaryTextFade1, // Border color for selected bar
                      selectedBorderWidth: 1, // Border width for selected bar
                      selectedColor: _colorMap[categoryTransaction],
                      // Optional: Change color on selection
                    ),
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

                    final intervalKey = getIntervalKey(interval, month);

                    final transactionList = groupedData[intervalKey] ?? [];

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
                          children: [
                            Text(
                              intervalKey,
                              style: context.bodyLarge,
                            ),
                            Text(
                              displayFormattedCurrency(sum),
                              style: context.bodyMedium!.copyWith(
                                  color: _colorMap[categoryTransaction]),
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
                            sortField: TransactionListViewSortField.amount,
                            sortOrder: SortOrder.descending,
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

  List<CategoryChartData> generateChartData(
      List<Transaction> transactions, StatsInterval interval) {
    final chartData =
        _sumTransactionsByInterval(transactions, interval).values.toList();

    final minTransactionDate = transactions
        .map((e) => e.transaction_date)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final maxTransactionDate = transactions
        .map((e) => e.transaction_date)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    switch (interval) {
      case StatsInterval.month:
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

        break;
      case StatsInterval.year:
        // generate years starting from the minTransactionDate to maxTransactionDate
        final years = <DateTime>[];
        DateTime currentDate = DateTime(minTransactionDate.year);
        DateTime endDate = DateTime(maxTransactionDate.year + 1);
        while (currentDate.isBefore(endDate)) {
          years.add(currentDate);
          currentDate = DateTime(currentDate.year + 1);
        }

        // fill in missing years with 0 values
        for (var year in years) {
          if (!chartData.any((data) => data.month.year == year.year)) {
            chartData.add(CategoryChartData(year, 0));
          }
        }
        break;

      case StatsInterval.week:
        // generate weeks starting from the minTransactionDate to maxTransactionDate
        final weeks = <DateTime>[];
        DateTime currentDate = minTransactionDate.subtractWeeks(
            minTransactionDate.weekday - 1); // Start from the first week
        DateTime endDate = maxTransactionDate
            .addWeeks(7 - maxTransactionDate.weekday); // End at the last week
        while (currentDate.isBefore(endDate)) {
          weeks.add(currentDate);
          currentDate = currentDate.addWeeks(1);
        }

        // fill in missing weeks with 0 values
        for (var week in weeks) {
          if (!chartData.any((data) => data.month == week)) {
            chartData.add(CategoryChartData(week, 0));
          }
        }
        break;
    }

    // Sort again after adding missing months
    chartData.sort(
      (a, b) {
        return a.month.compareTo(b.month); // Descending order
      },
    );

    return chartData;
  }

  DateTimeIntervalType getDateIntervalType() {
    final DateTimeIntervalType intervalType;

    switch (interval) {
      case StatsInterval.month:
        intervalType = DateTimeIntervalType.months;
        break;
      case StatsInterval.year:
        intervalType = DateTimeIntervalType.years;
        break;
      case StatsInterval.week:
        intervalType = DateTimeIntervalType.auto;
    }
    return intervalType;
  }

  DateTimeCategoryAxis getXAxisConfig(List<CategoryChartData> chartData) {
    late DateTimeIntervalType intervalType;
    late DateTime minimum;
    late DateTime maximum;
    late DateTime initialVisibleMinimum;
    late DateTime initialVisibleMaximum;
    late DateFormat dateFormat;

    switch (interval) {
      case StatsInterval.month:
        intervalType = DateTimeIntervalType.months;
        dateFormat = DateFormat('yyyy-MMM');
        minimum = chartData.first.month;
        maximum = chartData.last.month;
        initialVisibleMinimum =
            chartData.last.month.subtractMonths(xAxisVisible - 1);
        initialVisibleMaximum = chartData.last.month;
        break;
      case StatsInterval.year:
        dateFormat = DateFormat('yyyy');
        intervalType = DateTimeIntervalType.years;
        minimum = chartData.first.month;
        maximum = chartData.last.month;
        initialVisibleMinimum = chartData.last.month.subtractYears(4);
        initialVisibleMaximum = chartData.last.month;
        break;
      case StatsInterval.week:
        dateFormat = DateFormat('yyyy-MMM');
        intervalType = DateTimeIntervalType.auto;
        minimum = chartData.first.month;
        maximum = chartData.last.month;
        initialVisibleMinimum = chartData.last.month.subtractMonths(1);
        initialVisibleMaximum = chartData.last.month;
    }

    return DateTimeCategoryAxis(
      dateFormat: dateFormat,
      labelStyle: const TextStyle(fontSize: 8),
      labelRotation: 45,
      labelPlacement: LabelPlacement.betweenTicks,
      intervalType: intervalType,
      interval: 1,
      minimum: minimum,
      maximum: maximum,
      initialVisibleMinimum: initialVisibleMinimum,
      initialVisibleMaximum: initialVisibleMaximum,
    );
  }
}

Map<String, CategoryChartData> _sumTransactionsByInterval(
    List<Transaction> transactions, StatsInterval interval) {
  Map<String, CategoryChartData> groupedData = {};

  for (var transaction in transactions) {
    String intervalKey = getIntervalKey(interval, transaction.transaction_date);

    // Initialize the month group if it doesn't exist
    if (!groupedData.containsKey(intervalKey)) {
      groupedData[intervalKey] = CategoryChartData(
        transaction.transaction_date.firstDayOfMonth(),
        transaction.amount,
      );
    } else {
      groupedData[intervalKey]!.totalAmount += transaction.amount;
    }
  }

  return groupedData;
}

Map<String, List<Transaction>> _groupTransactionsByInterval(
    List<Transaction> transactions, StatsInterval interval) {
  Map<String, List<Transaction>> groupedData = {};

  for (var transaction in transactions) {
    // Format the transaction date to get the month (e.g., "January 2023")
    // String intervalKey = DateFormat('yyyy-MM').format(transaction.transaction_date);
    String intervalKey = getIntervalKey(interval, transaction.transaction_date);

    // Initialize the month group if it doesn't exist
    if (!groupedData.containsKey(intervalKey)) {
      groupedData[intervalKey] = [];
    }

    groupedData[intervalKey]!.add(transaction);
  }

  return groupedData;
}

class CategoryChartData {
  final DateTime month;
  double totalAmount;

  CategoryChartData(this.month, this.totalAmount);
}
