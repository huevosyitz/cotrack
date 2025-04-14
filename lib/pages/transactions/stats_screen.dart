import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/services/services.dart';
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

  final transactionTypes = [
    TransactionType.income.name,
    TransactionType.expense.name
  ];

  StatsScreen({super.key}); // 0 for Income, 1 for Expense

  @override
  Widget build(BuildContext context) {
    final selectedYearMonth = useState(DateTime.now());
    final selectedTabIndex = useState(1);

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

            final selectedMonth =
                DateFormat("yyyy-MM").format(selectedYearMonth.value);
            final thisMonthDisplay =
                DateFormat("MMMM yyyy").format(selectedYearMonth.value);

            final selectedTransactionType =
                transactionTypes[selectedTabIndex.value];

            final thisMonthTransactions =
                groupedTransactions[selectedMonth]?[selectedTransactionType];

            // Filter transactions based on the selected tab
            final filteredTransactions = thisMonthTransactions == null
                ? <ChartData>[]
                : _generateChartDataWithColors(
                    thisMonthTransactions.values.toList());

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
                const SizedBox(height: 16),
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
                  Expanded(
                    child: SfCircularChart(
                      title: ChartTitle(
                        text: selectedTabIndex.value == 0
                            ? 'Income ($thisMonthDisplay)'
                            : 'Expense ($thisMonthDisplay)',
                      ),
                      legend: Legend(
                        isVisible: true,
                        isResponsive: true,
                        overflowMode: LegendItemOverflowMode.wrap,
                        position: LegendPosition.bottom,
                        alignment: ChartAlignment.center,
                        itemPadding: 5,
                        textStyle: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      series: <PieSeries<ChartData, String>>[
                        PieSeries<ChartData, String>(
                          radius: '70%',
                          strokeColor: Colors.black.withOpacity(0.1),
                          strokeWidth: 1,
                          dataSource: filteredTransactions,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          pointColorMapper: (ChartData data, _) => data.color,
                          dataLabelSettings: const DataLabelSettings(
                              labelIntersectAction: LabelIntersectAction.shift,
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.outside,
                              labelAlignment: ChartDataLabelAlignment.bottom,
                              textStyle: TextStyle(
                                fontSize: 8,
                              ),
                              connectorLineSettings: ConnectorLineSettings(
                                  // Type of the connector line
                                  type: ConnectorType.curve)),
                          dataLabelMapper: (ChartData data, _) {
                            // Calculate the percentage
                            final total = filteredTransactions.fold<double>(
                                0, (sum, item) => sum + item.y);
                            final percentage =
                                ((data.y / total) * 100).toStringAsFixed(1);
                            return '${data.x}\r\n$percentage%';
                          },
                          animationDuration: 500,
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Map<String, Map<String, Map<String, ChartData>>>
    _groupTransactionsByMonthAndCategory(List<Transaction> transactions) {
  Map<String, Map<String, Map<String, ChartData>>> groupedData = {};

  for (var transaction in transactions) {
    // Format the transaction date to get the month (e.g., "January 2023")
    String month = DateFormat('yyyy-MM').format(transaction.transaction_date);

    // Get the category name
    String transactionType = TransactionCategoryService
            .transactionCategoriesMap[transaction.category_id]
            ?.transactionType
            .name ??
        'Unknown';

    String categoryName = TransactionCategoryService
            .transactionCategoriesMap[transaction.category_id]?.name ??
        'Unknown';

    // Initialize the month group if it doesn't exist
    if (!groupedData.containsKey(month)) {
      groupedData[month] = {};
    }

    // Initialize the category group if it doesn't exist
    if (!groupedData[month]!.containsKey(transactionType)) {
      groupedData[month]![transactionType] = {};
    }

    final data = ChartData(
      TransactionCategoryService
              .transactionCategoriesMap[transaction.category_id]?.name ??
          'Unknown',
      transaction.amount,
    );

    if (!groupedData[month]![transactionType]!.containsKey(categoryName)) {
      groupedData[month]![transactionType]![categoryName] = data;
    } else {
      groupedData[month]![transactionType]![categoryName]!.y +=
          transaction.amount;
    }
  }

  return groupedData;
}

List<ChartData> _generateChartDataWithColors(List<ChartData> transactions) {
  // Sort transactions by amount (descending)
  transactions.sort((a, b) => b.y.compareTo(a.y));

  return transactions.map((data) {
    // use the colors list to get the color based on the index
    final index = transactions.indexOf(data) % colors.length;
    final color = colors[index];

    return ChartData(data.x, data.y, color);
  }).toList();
}

List<Color> colors = [
  Color(0xfffe6f63),
  Color(0xfffe9650),
  Color(0xffffd041),
  Color(0xffffe800),
  Color(0xffc1e745),
  Color(0xff72d36c),
  Color(0xff66e9db),
  Color(0xff73b8e2),
  Color(0xff73b8e2),
  Color(0xffa589d6),
  Color(0xffec7ddc),
  Color(0xffe373a3),
  Color(0xfffe6f63),
  Color(0xfffe9650),
  Color(0xffffd041),
  Color(0xffffe800),
  Color(0xffc1e745),
  Color(0xff72d36c),
  Color(0xff66e9db),
  Color(0xff73b8e2),
  Color(0xff73b8e2),
  Color(0xffa589d6),
  Color(0xffec7ddc),
  Color(0xffe373a3),
];

Color? lerpMultiColor(double t) {
  int numColors = colors.length;

  // Clamp t between 0 and 1
  t = t.clamp(0.0, 1.0);

  // Determine the segment index
  int segment = (t * (numColors - 1)).floor();

  // Calculate the interpolation value within the segment
  double segmentT = t * (numColors - 1) - segment;

  final nextSegment = segment + 1;
  if (nextSegment >= numColors) {
    return colors[segment];
  }

  // Lerp between the appropriate colors
  return Color.lerp(colors[segment], colors[segment + 1], segmentT);
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  double y;
  final Color? color;
}
