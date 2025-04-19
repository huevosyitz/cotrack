import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cotrack/components/components.dart';
import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:cotrack/pages/stats/view_models/category_stats.dart';
import 'package:cotrack/pages/stats/category_stats_screen.dart';
import 'package:cotrack/themes/yColors.dart';
import 'package:cotrack/themes/yIcons.dart';
import 'package:cotrack/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:watch_it/watch_it.dart';

enum StatsInterval {
  week,
  month,
  year,
}

class StatsScreen extends HookWidget {
  final transactionService = di.get<TransactionService>();
  final categoryService = di.get<TransactionCategoryService>();

  final statsTabs = [StatsTabs.income, StatsTabs.all, StatsTabs.expense];

  StatsScreen({super.key}); // 0 for Income, 1 for Expense

  @override
  Widget build(BuildContext context) {
    final selectedYearMonth = useState(DateTime.now());
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
            final groupedTransactions =
                _groupTransactionsByMonthAndCategory(transactionList);

            final allGroupTransactions =
                _groupTransactionsByTransactionType(transactionList);

            final selectedMonth =
                DateFormat("yyyy-MM").format(selectedYearMonth.value);
            final thisMonthDisplay =
                DateFormat("MMMM yyyy").format(selectedYearMonth.value);

            final selectedTab = statsTabs[selectedTabIndex.value];

            final thisMonthTransactions = selectedTab == StatsTabs.all
                ? allGroupTransactions[selectedMonth]?.values
                : groupedTransactions[selectedMonth]?[selectedTab.name]?.values;

            // Filter transactions based on the selected tab
            final filteredTransactions = thisMonthTransactions == null
                ? <CategoryStats>[]
                : _generateChartDataWithColors(
                    thisMonthTransactions.toList(), selectedTab);

            final sum = filteredTransactions.fold<double>(
                0, (sum, item) => sum + item.totalAmount);

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // navigate to previous or next month
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(yIcons.arrowLeft),
                      onPressed: () {
                        // Handle previous month action
                        selectedYearMonth.value = DateTime(
                          selectedYearMonth.value.year,
                          selectedYearMonth.value.month - 1,
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
                        // Handle next month action
                        selectedYearMonth.value = DateTime(
                          selectedYearMonth.value.year,
                          selectedYearMonth.value.month + 1,
                        );
                      },
                    ),
                  ],
                ),
                if (filteredTransactions.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        'No transactions for $thisMonthDisplay',
                        style: context.labelMedium,
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedTab == StatsTabs.all
                                  ? thisMonthDisplay
                                  : '$thisMonthDisplay (${displayFormattedCurrency(sum)})',
                              style: context.labelLarge,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              width: 130,
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
}

class CategoryStatsTransactionItem extends StatelessWidget {
  const CategoryStatsTransactionItem({
    super.key,
    required this.categoryStat,
    required this.selectedTab,
  });

  final CategoryStats categoryStat;
  final StatsTabs selectedTab;

  @override
  Widget build(BuildContext context) {
    var avatarIcon = selectedTab == StatsTabs.all
        ? (TransactionCategoryService
                    .transactionCategoriesMap[categoryStat.categoryId]
                    ?.transactionType ==
                TransactionType.income
            ? yIcons.income
            : yIcons.expense)
        : TransactionCategoryService
            .transactionCategoriesMap[categoryStat.categoryId]!.iconItem.icon;

    return CompactListTile(
      onTap: () => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => selectedTab == StatsTabs.all
            ? CategoryStatsScreen(
                transactionType: TransactionCategoryService
                    .transactionCategoriesMap[categoryStat.categoryId]!
                    .transactionType,
              )
            : CategoryStatsScreen(
                categoryId: categoryStat.categoryId,
              ),
      ),
      leading: CircleAvatar(
        backgroundColor: categoryStat.color,
        child: Icon(
          avatarIcon,
          color: yColors.background,
        ),
      ),
      title: Text(categoryStat.categoryName),
      trailing: Text(
        displayFormattedCurrency(categoryStat.totalAmount),
        style: context.labelMedium,
      ),
    );
  }
}

Map<String, Map<String, CategoryStats>> _groupTransactionsByTransactionType(
    List<Transaction> transactions) {
  Map<String, Map<String, CategoryStats>> groupedData = {};

  for (var transaction in transactions) {
    // Format the transaction date to get the month (e.g., "January 2023")
    String month = DateFormat('yyyy-MM').format(transaction.transaction_date);

    // Get the category name
    TransactionType transactionType = TransactionCategoryService
        .transactionCategoriesMap[transaction.category_id]!.transactionType;

    // Initialize the month group if it doesn't exist
    if (!groupedData.containsKey(month)) {
      groupedData[month] = {};
    }

    final data = CategoryStats(
      transaction.category_id,
      transactionType == TransactionType.income ? "Income" : "Expense",
      transaction.amount,
      statsTab: transactionType.toStatsTab(),
    );

    // Initialize the category group if it doesn't exist
    if (!groupedData[month]!.containsKey(transactionType.name)) {
      groupedData[month]![transactionType.name] = data;
    } else {
      groupedData[month]![transactionType.name]!.totalAmount +=
          transaction.amount;
    }
  }

  return groupedData;
}

Map<String, Map<String, Map<String, CategoryStats>>>
    _groupTransactionsByMonthAndCategory(List<Transaction> transactions) {
  Map<String, Map<String, Map<String, CategoryStats>>> groupedData = {};

  for (var transaction in transactions) {
    // Format the transaction date to get the month (e.g., "January 2023")
    String month = DateFormat('yyyy-MM').format(transaction.transaction_date);

    // Get the category name
    TransactionType transactionType = TransactionCategoryService
        .transactionCategoriesMap[transaction.category_id]!.transactionType;

    String categoryName = TransactionCategoryService
            .transactionCategoriesMap[transaction.category_id]?.name ??
        'Unknown';

    // Initialize the month group if it doesn't exist
    if (!groupedData.containsKey(month)) {
      groupedData[month] = {};
    }

    // Initialize the category group if it doesn't exist
    if (!groupedData[month]!.containsKey(transactionType.name)) {
      groupedData[month]![transactionType.name] = {};
    }

    final data = CategoryStats(
      transaction.category_id,
      TransactionCategoryService
              .transactionCategoriesMap[transaction.category_id]?.name ??
          'Unknown',
      transaction.amount,
      statsTab: transactionType.toStatsTab(),
    );

    if (!groupedData[month]![transactionType.name]!.containsKey(categoryName)) {
      groupedData[month]![transactionType.name]![categoryName] = data;
    } else {
      groupedData[month]![transactionType.name]![categoryName]!.totalAmount +=
          transaction.amount;
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
