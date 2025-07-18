import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cotrack/features/category/transaction_category_service.dart';
import 'package:cotrack/features/stats/view_models/category_stats.dart';
import 'package:cotrack/features/stats/view_models/stats_interval.dart';
import 'package:cotrack/features/stats/widgets/category_stats_transaction_item.dart';
import 'package:cotrack/features/transactions/transaction.dart';
import 'package:cotrack/features/transactions/transaction_service.dart';
import 'package:cotrack/features/transactions/transaction_type.dart';
import 'package:cotrack/themes/yColors.dart';
import 'package:cotrack/themes/yIcons.dart';
import 'package:cotrack/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:watch_it/watch_it.dart';

class StatsScreen extends HookWidget {
  final transactionService = di.get<TransactionService>();
  final categoryService = di.get<TransactionCategoryService>();

  final statsTabs = [StatsTabs.income, StatsTabs.all, StatsTabs.expense];

  StatsScreen({super.key}); // 0 for Income, 1 for Expense

  @override
  Widget build(BuildContext context) {
    final selectedDateTime = useState(DateTime.now());
    final selectedTabIndex = useState(statsTabs.indexOf(StatsTabs.expense));
    final selectedInterval = useState(StatsInterval.month);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: QueryBuilder(
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

            // Group transactions by month and category
            final groupedTransactions = _groupTransactionsByIntervalAndCategory(
                selectedInterval.value, transactionList);

            final allGroupTransactions = _groupTransactionsByTransactionType(
                selectedInterval.value, transactionList);

            final selectedIntervalKey =
                getIntervalKey(selectedInterval.value, selectedDateTime.value);

            final selectedTab = statsTabs[selectedTabIndex.value];

            final thisIntervalTransactions = selectedTab == StatsTabs.all
                ? allGroupTransactions[selectedIntervalKey]?.values
                : groupedTransactions[selectedIntervalKey]?[selectedTab.name]
                    ?.values;

            // Filter transactions based on the selected tab
            final filteredTransactions = thisIntervalTransactions == null
                ? <CategoryStats>[]
                : _generateChartDataWithColors(
                    thisIntervalTransactions.toList(), selectedTab);

            final String headerDisplayText = generateHeaderText(
                selectedInterval,
                selectedDateTime.value,
                selectedTab,
                filteredTransactions);

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(yIcons.arrowLeft),
                      onPressed: () {
                        selectedDateTime.value = addIntervalToDateTime(
                          selectedDateTime.value,
                          selectedInterval.value,
                          -1,
                        );
                      },
                    ),
                    SegmentedButton(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(
                          value: 0,
                          label: Text('Income'),
                        ),
                        ButtonSegment(
                          value: 1,
                          label: Text('All'),
                        ),
                        ButtonSegment(
                          value: 2,
                          label: Text('Expense'),
                        ),
                      ],
                      selected: {selectedTabIndex.value},
                      onSelectionChanged: (Set<int> selectedTransactionType) {
                        selectedTabIndex.value = selectedTransactionType.first;
                      },
                    ),
                    IconButton(
                      icon: const Icon(yIcons.arrowRight),
                      onPressed: () {
                        selectedDateTime.value = addIntervalToDateTime(
                          selectedDateTime.value,
                          selectedInterval.value,
                          1,
                        );
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            headerDisplayText,
                            style: context.titleMedium,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButton<StatsInterval>(
                              isDense: true,
                              isExpanded: true,
                              hint: Text("Select a fruit"),
                              value: selectedInterval.value,
                              onChanged: (StatsInterval? newValue) {
                                selectedInterval.value = newValue!;
                              },
                              items: StatsInterval.values
                                  .map<DropdownMenuItem<StatsInterval>>(
                                      (StatsInterval value) {
                                return DropdownMenuItem<StatsInterval>(
                                  value: value,
                                  child: Text(value.name.capitalizeFirst),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (filteredTransactions.isEmpty)
                      SizedBox(
                        height: 300,
                        child: Center(
                          child: Text(
                            'No transactions for "$selectedIntervalKey"',
                            style: context.labelMedium,
                          ),
                        ),
                      )
                    else
                      SfCircularChart(
                        margin: EdgeInsets.zero,
                        series: <PieSeries<CategoryStats, String>>[
                          PieSeries<CategoryStats, String>(
                            radius: '70%',
                            strokeColor: Colors.black.withValues(alpha: 0.1),
                            strokeWidth: 1,
                            dataSource: filteredTransactions,
                            xValueMapper: (CategoryStats data, _) =>
                                data.categoryName,
                            yValueMapper: (CategoryStats data, _) =>
                                data.totalAmount,
                            pointColorMapper: (CategoryStats data, _) =>
                                data.color,
                            dataLabelSettings: const DataLabelSettings(
                                labelIntersectAction:
                                    LabelIntersectAction.shift,
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.outside,
                                labelAlignment: ChartDataLabelAlignment.bottom,
                                textStyle: TextStyle(
                                  fontSize: 8,
                                ),
                                connectorLineSettings: ConnectorLineSettings(
                                    // Type of the connector line
                                    type: ConnectorType.curve)),
                            dataLabelMapper: (CategoryStats data, _) {
                              // Calculate the percentage
                              final total = filteredTransactions.fold<double>(
                                  0, (sum, item) => sum + item.totalAmount);
                              final percentage =
                                  ((data.totalAmount / total) * 100)
                                      .toStringAsFixed(1);
                              return '${data.categoryName}\r\n$percentage%';
                            },
                            animationDuration: 500,
                          ),
                        ],
                      ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTransactions.length,
                    itemBuilder: (_, index) {
                      return CategoryStatsTransactionItem(
                          interval: selectedInterval.value,
                          categoryStat: filteredTransactions[index],
                          selectedTab: selectedTab);
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  DateTime addIntervalToDateTime(
      DateTime dateTime, StatsInterval interval, int count) {
    switch (interval) {
      case StatsInterval.week:
        return count > 0
            ? dateTime.addWeeks(count)
            : dateTime.subtractWeeks(-count);
      case StatsInterval.month:
        return count > 0
            ? dateTime.addMonths(count)
            : dateTime.subtractMonths(-count);
      case StatsInterval.year:
        return DateTime(dateTime.year + count);
    }
  }

  String generateHeaderText(
      ValueNotifier<StatsInterval> selectedInterval,
      DateTime selectedDateTime,
      StatsTabs selectedTab,
      List<CategoryStats> filteredTransactions) {
    final String displayText =
        getIntervalKey(selectedInterval.value, selectedDateTime);

    if (selectedTab == StatsTabs.all) {
      return displayText;
    } else {
      final sum = filteredTransactions.fold<double>(
          0, (sum, item) => sum + item.totalAmount);
      return '$displayText (${displayFormattedCurrency(sum)})';
    }
  }

  Map<String, Map<String, CategoryStats>> _groupTransactionsByTransactionType(
      StatsInterval interval, List<Transaction> transactions) {
    Map<String, Map<String, CategoryStats>> groupedData = {};

    for (var transaction in transactions) {
      // Format the transaction date to get the month (e.g., "January 2023")

      String intervalKey =
          getIntervalKey(interval, transaction.transaction_date);

      // Get the category name
      TransactionType transactionType = TransactionCategoryService
          .transactionCategoriesMap[transaction.category_id]!.transactionType;

      // Initialize the month group if it doesn't exist
      if (!groupedData.containsKey(intervalKey)) {
        groupedData[intervalKey] = {};
      }

      final data = CategoryStats(
        transaction.category_id,
        transactionType == TransactionType.income ? "Income" : "Expense",
        transaction.amount,
        statsTab: transactionType.toStatsTab(),
      );

      // Initialize the category group if it doesn't exist
      if (!groupedData[intervalKey]!.containsKey(transactionType.name)) {
        groupedData[intervalKey]![transactionType.name] = data;
      } else {
        groupedData[intervalKey]![transactionType.name]!.totalAmount +=
            transaction.amount;
      }
    }

    return groupedData;
  }

  Map<String, Map<String, Map<String, CategoryStats>>>
      _groupTransactionsByIntervalAndCategory(
          StatsInterval interval, List<Transaction> transactions) {
    Map<String, Map<String, Map<String, CategoryStats>>> groupedData = {};

    for (var transaction in transactions) {
      // Format the transaction date to get the month (e.g., "January 2023")
      String intervalKey =
          getIntervalKey(interval, transaction.transaction_date);

      // Get the category name
      TransactionType transactionType = TransactionCategoryService
          .transactionCategoriesMap[transaction.category_id]!.transactionType;

      String categoryName = TransactionCategoryService
              .transactionCategoriesMap[transaction.category_id]?.name ??
          'Unknown';

      // Initialize the month group if it doesn't exist
      if (!groupedData.containsKey(intervalKey)) {
        groupedData[intervalKey] = {};
      }

      // Initialize the category group if it doesn't exist
      if (!groupedData[intervalKey]!.containsKey(transactionType.name)) {
        groupedData[intervalKey]![transactionType.name] = {};
      }

      final data = CategoryStats(
        transaction.category_id,
        TransactionCategoryService
                .transactionCategoriesMap[transaction.category_id]?.name ??
            'Unknown',
        transaction.amount,
        statsTab: transactionType.toStatsTab(),
      );

      if (!groupedData[intervalKey]![transactionType.name]!
          .containsKey(categoryName)) {
        groupedData[intervalKey]![transactionType.name]![categoryName] = data;
      } else {
        groupedData[intervalKey]![transactionType.name]![categoryName]!
            .totalAmount += transaction.amount;
      }
    }

    return groupedData;
  }

  List<CategoryStats> _generateChartDataWithColors(
      List<CategoryStats> categoryStatList, StatsTabs statTab) {
    // Sort transactions by amount (descending)
    categoryStatList.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

    return categoryStatList.map((data) {
      // use the colors list to get the color based on the index
      final index = categoryStatList.indexOf(data) % yColorPallete.length;
      // Get the category name
      TransactionType transactionType = TransactionCategoryService
          .transactionCategoriesMap[data.categoryId]!.transactionType;

      Color color;

      final greenColorIndex = 5;
      final redishColorIndex = 0;

      switch (transactionType) {
        case TransactionType.income:
          color = statTab == StatsTabs.all
              ? yColorPallete[greenColorIndex]
              : yColorPallete[greenColorIndex + index];
          break;
        case TransactionType.expense:
          color = statTab == StatsTabs.all
              ? yColorPallete[redishColorIndex]
              : yColorPallete[index + redishColorIndex];
        default:
          color = yColorPallete[index];
      }

      return CategoryStats(data.categoryId, data.categoryName, data.totalAmount,
          color: color, statsTab: data.statsTab ?? statTab);
    }).toList();
  }

  Color? lerpMultiColor(double t) {
    int numColors = yColorPallete.length;

    // Clamp t between 0 and 1
    t = t.clamp(0.0, 1.0);

    // Determine the segment index
    int segment = (t * (numColors - 1)).floor();

    // Calculate the interpolation value within the segment
    double segmentT = t * (numColors - 1) - segment;

    final nextSegment = segment + 1;
    if (nextSegment >= numColors) {
      return yColorPallete[segment];
    }

    // Lerp between the appropriate colors
    return Color.lerp(
        yColorPallete[segment], yColorPallete[segment + 1], segmentT);
  }
}

String getIntervalKey(
    StatsInterval selectedInterval, DateTime selectedDateTime) {
  switch (selectedInterval) {
    case StatsInterval.week:
      return selectedDateTime.yearMonthWeek();
    case StatsInterval.month:
      return DateFormat("MMM yyyy").format(selectedDateTime);
    case StatsInterval.year:
      return selectedDateTime.year.toString();
  }
}
