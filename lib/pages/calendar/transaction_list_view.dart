import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cotrack/components/components.dart';
import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:cotrack/core/viewModels/sort_by.dart';
import 'package:cotrack/pages/calendar/view_models/transaction_list_view_sort_field.dart';
import 'package:cotrack/pages/stats/add_edit_transaction_modal_screen.dart';
import 'package:cotrack/themes/themes.dart';
import 'package:cotrack/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:watch_it/watch_it.dart';

class TransactionListView extends StatelessWidget {
  final TransactionService transactionService = di.get();
  final TransactionCategoryService categoryService =
      di.get<TransactionCategoryService>();

  final TransactionListViewSortField? sortField;
  final SortOrder? sortOrder;

  TransactionListView({
    super.key,
    required this.transactionList,
    this.sortField,
    this.sortOrder = SortOrder.ascending,
  });

  final List<Transaction> transactionList;

  @override
  Widget build(BuildContext context) {
    return SlidableAutoCloseBehavior(
      child: Expanded(
        child: ListView.builder(
          itemCount: transactionList.length,
          itemBuilder: (context, index) {
            if (sortField != null) {
              sortTransactions(transactionList, sortField!, sortyBy: sortOrder);
            }

            final transaction = transactionList[index];

            return Slidable(
              // The end action pane is the one at the right or the bottom side.
              endActionPane: ActionPane(
                extentRatio: .5,
                motion: StretchMotion(),
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                        outlinedButtonTheme: OutlinedButtonThemeData(
                            style: ButtonStyle(
                                iconColor: WidgetStatePropertyAll(
                                    context.colorScheme.onErrorContainer)))),
                    child: SlidableAction(
                      onPressed: (_) => showModalBottomSheet(
                          isScrollControlled: true,
                          enableDrag: true,
                          context: context,
                          builder: (context) => AddEditTransactionModelScreen(
                                transactionToEdit: transaction,
                              )),
                      icon: yIcons.edit,
                      backgroundColor: context.colorScheme.onPrimary,
                      label: 'Edit',
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                        outlinedButtonTheme: OutlinedButtonThemeData(
                            style: ButtonStyle(
                                iconColor: WidgetStatePropertyAll(
                                    context.colorScheme.onErrorContainer)))),
                    child: MutationBuilder(
                        mutation:
                            transactionService.deleteTransactionMutation(),
                        builder: (context, state, mutate) {
                          return SlidableAction(
                            onPressed: (_) async {
                              await mutate(transaction);
                            },
                            backgroundColor: context.colorScheme.errorContainer,
                            foregroundColor:
                                context.colorScheme.onErrorContainer,
                            icon: yIcons.delete,
                            label: 'Delete',
                          );
                        }),
                  ),
                ],
              ),
              child: CompactListTile(
                leading: SizedBox(
                  width: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        TransactionCategoryService
                            .transactionCategoriesMap[transaction.category_id]!
                            .name,
                        style: context.labelSmall!
                            .copyWith(color: yColors.primaryTextFade1),
                      )
                    ],
                  ),
                ),
                title: (transaction.notes ?? "").isEmpty
                    ? Text(
                        TransactionCategoryService
                            .transactionCategoriesMap[transaction.category_id]!
                            .name,
                        style: TextStyle(color: yColors.primaryTextFade2))
                    : Text(transaction.notes!),
                subtitle: Text(
                  "${TransactionAccountService.transactionAccountsMap[transaction.account_id]?.name ?? "Unknown"} - (${transaction.transaction_date.MMMdd()})",
                  style: context.labelSmall!
                      .copyWith(color: yColors.primaryTextFade1),
                ),
                trailing: Text(
                  displayFormattedCurrency(transaction.amount),
                  style: context.labelSmall!.copyWith(
                      color: categoryService
                              .isIncomeCategory(transaction.category_id)
                          ? yColors.primary
                          : yColors.warn),
                ),
                onTap: () => showModalBottomSheet(
                    isScrollControlled: true,
                    enableDrag: true,
                    context: context,
                    builder: (context) => AddEditTransactionModelScreen(
                          transactionToEdit: transaction,
                        )),
              ),
            );
          },
        ),
      ),
    );
  }

  void sortTransactions(
      List<Transaction> transactions, TransactionListViewSortField sortField,
      {SortOrder? sortyBy = SortOrder.ascending}) {
    transactions.sort((a, b) {
      int comparison;
      switch (sortField) {
        case TransactionListViewSortField.date:
          comparison = a.transaction_date.compareTo(b.transaction_date);
          break;
        case TransactionListViewSortField.amount:
          comparison = a.amount.compareTo(b.amount);
          break;
      }
      // Reverse the comparison result if descending order is required
      return sortyBy == SortOrder.ascending ? comparison : -comparison;
    });
  }
}
