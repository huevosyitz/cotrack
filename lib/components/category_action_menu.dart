import 'package:cotrack/components/components.dart';
import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:cotrack/pages/category/add_edit_category_screen.dart';
import 'package:cotrack/pages/transactions/transaction_modal_screen.dart';
import 'package:cotrack/themes/themes.dart';
import 'package:cotrack/utils/deviceUtils.dart';
import 'package:flutter/material.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:watch_it/watch_it.dart';

class CategoryActionMenu extends StatelessWidget {
  final TransactionCategory category;

  final TransactionCategoryService categoryService =
      di.get<TransactionCategoryService>();

  CategoryActionMenu({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    // id 0 is just the add category button. no context menu for this button
    if (category.id == 0) {
      return CategoryIconAvatar(
        avatarSize: 30,
        iconSize: 30,
        category: category,
        showLabel: true,
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              context: context,
              builder: (context) => AddEditCategoryScreen());
          return;
        },
      );
    }

    return PieMenu(
      onToggle: (menuOpen) async {
        await HapticUtil.vibrate(level: HapticLevel.heavy);
      },
      actions: [
        PieAction(
          tooltip: const Text(''),
          onSelect: () => showModalBottomSheet(
            isScrollControlled: true,
            enableDrag: true,
            context: context,
            builder: (context) => AddEditCategoryScreen(categoryToEdit: category),
          ),

          /// Optical correction
          child: const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(yIcons.edit),
          ),
        ),
        PieAction(
          tooltip: const Text(''),
          onSelect: () => categoryService
              .deleteTransactionCategoryMutation()
              .mutate(category.id),
          child: Icon(yIcons.delete),
        ),
        PieAction(
          tooltip: const Text(''),
          onSelect: () => {},
          child: Icon(yIcons.sort),
        ),
      ],
      child: CategoryIconAvatar(
        avatarSize: 30,
        iconSize: 30,
        category: category,
        showLabel: true,
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              context: context,
              builder: (context) => TransactionModelScreen(
                    category: category,
                  ));
        },
      ),
    );
  }
}
