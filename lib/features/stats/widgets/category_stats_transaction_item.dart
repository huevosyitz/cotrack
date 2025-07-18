import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cotrack/components/components.dart';
import 'package:cotrack/features/category/transaction_category_service.dart';
import 'package:cotrack/features/stats/category_stats_screen.dart';
import 'package:cotrack/features/stats/view_models/category_stats.dart';
import 'package:cotrack/features/stats/view_models/stats_interval.dart';
import 'package:cotrack/features/transactions/transaction_type.dart';
import 'package:cotrack/themes/yColors.dart';
import 'package:cotrack/themes/yIcons.dart';
import 'package:cotrack/utils/utils.dart';
import 'package:flutter/material.dart';

class CategoryStatsTransactionItem extends StatelessWidget {
  const CategoryStatsTransactionItem({
    super.key,
    required this.categoryStat,
    required this.selectedTab,
    required this.interval,
  });

  final CategoryStats categoryStat;
  final StatsTabs selectedTab;
  final StatsInterval interval;

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
                interval: interval,
                transactionType: TransactionCategoryService
                    .transactionCategoriesMap[categoryStat.categoryId]!
                    .transactionType,
              )
            : CategoryStatsScreen(
                interval: interval,
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
