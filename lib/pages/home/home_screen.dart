import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cotrack/components/components.dart';
import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:cotrack/pages/calendar/transaction_modal_screen.dart';
import 'package:cotrack/themes/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reorderables/reorderables.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
            child: CategoryGridWrapper(
                categories: TransactionCategoryService.expenseCategories)),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(99)),
        ),
        onPressed: () {
          showCupertinoSheet(
              context: context,
              pageBuilder: (context) => TransactionModelScreen());
        },
        child: const Icon(yIcons.add),
      ),
    );
  }
}

class CategoryGridWrapper extends StatefulWidget {
  final List<TransactionCategory> categories;
  const CategoryGridWrapper({super.key, required this.categories});

  @override
  State<CategoryGridWrapper> createState() => _CategoryGridWrapperState();
}

class _CategoryGridWrapperState extends State<CategoryGridWrapper> {
  List<Widget> categoryWidgets = [];

  @override
  void initState() {
    super.initState();
    categoryWidgets = widget.categories
        .map((TransactionCategory category) => CategoryIconAvatar(
              avatarSize: 30,
              iconSize: 30,
              category: category,
              showLabel: true,
              onPressed: () {
                showCupertinoSheet(
                    context: context,
                    pageBuilder: (context) => TransactionModelScreen(
                          category: category,
                        ));
              },
            ))
        .toList();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      Widget row = categoryWidgets.removeAt(oldIndex);
      categoryWidgets.insert(newIndex, row);
    });
  }

  @override
  Widget build(BuildContext context) {
    var wrap = ReorderableWrap(
      spacing: 22.0,
      runSpacing: 22.0,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.spaceBetween,
      onReorder: _onReorder,
      children: categoryWidgets,
    );

    return SizedBox(width: context.width, child: wrap);
  }
}
