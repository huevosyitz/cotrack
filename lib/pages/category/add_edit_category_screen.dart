import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:cotrack/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:watch_it/watch_it.dart';

class AddEditCategoryScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final ValueNotifier<bool> _isFormValid = ValueNotifier(false);
  late bool _isEdit = false;
  final TransactionCategory? categoryToEdit;

  AddEditCategoryScreen({super.key, this.categoryToEdit}) {
    if (categoryToEdit != null) {
      _formKey.currentState?.patchValue({
        'categoryName': categoryToEdit?.name,
        'type': categoryToEdit?.transactionType.name,
        'icon': categoryToEdit?.iconItem.key,
      });

      _isEdit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryService = di.get<TransactionCategoryService>();
    return Scaffold(
      appBar: AppBar(
        title: _isEdit
            ? Text("Update '${categoryToEdit?.name}'")
            : Text('Add New Category'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
                  onChanged: () {
                    // Check if the form is valid
                    _isFormValid.value =
                        _formKey.currentState?.validate() ?? false;
                  },
                  child: Column(
                    spacing: 12,
                    children: [
                      FormBuilderTextField(
                        name: 'categoryName',
                        initialValue: _isEdit ? categoryToEdit?.name : null,
                        autofocus: true,
                        decoration: InputDecoration(
                            labelText: 'Category Name',
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(3),
                        ]),
                      ),
                      FormBuilderChoiceChip<dynamic>(
                        name: 'type',
                        decoration:
                            const InputDecoration(labelText: 'Category Type'),
                        initialValue: _isEdit
                            ? categoryToEdit?.transactionType.name
                            : TransactionType.expense.name,
                        spacing: 3,
                        options: const [
                          FormBuilderChipOption(value: "expense"),
                          FormBuilderChipOption(value: "income"),
                          FormBuilderChipOption(value: "transfer"),
                        ],
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        onChanged: (value) {
                          print(value);
                        },
                      ),
                      FormBuilderChoiceChip<dynamic>(
                        name: 'icon',
                        decoration: const InputDecoration(labelText: 'Icon'),
                        initialValue: _isEdit
                            ? categoryToEdit?.iconItem.key
                            : yIcons.iconMap.keys.first,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceBetween,
                        showCheckmark: false,
                        runSpacing: 12,
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        options: yIcons.iconMap.keys
                            .map((ico) => FormBuilderChipOption(
                                  value: ico,
                                  child: Icon(
                                    yIcons.iconMap[ico],
                                    size: 30,
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          print(value);
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SaveButton(categoryService)
          ],
        ),
      ),
    );
  }

  Padding SaveButton(TransactionCategoryService categoryService) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ValueListenableBuilder(
        valueListenable: _isFormValid,
        builder: (context, value, child) => MutationBuilder(
            mutation: _isEdit
                ? categoryService.editTransactionCategoryMutation()
                : categoryService.addTransactionCategoryMutation(),
            builder: (context, state, mutate) {
              return MaterialButton(
                color: context.colorScheme.primary,
                minWidth: double.infinity,
                disabledColor:
                    context.colorScheme.primary.withValues(alpha: .5),
                onPressed: value
                    ? () async {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          // Save the form

                          logger.d(_formKey.currentState?.value);

                          final name =
                              _formKey.currentState?.value['categoryName'];
                          final type = _formKey.currentState?.value['type'];
                          final iconKey = _formKey.currentState?.value['icon'];

                          final category = TransactionCategory(
                              id: _isEdit ? categoryToEdit?.id ?? 0 : 0,
                              name: name,
                              transactionType: TransactionType.values
                                  .firstWhere((a) => a.name == type),
                              iconItem: yIcons.getIconItem(iconKey));

                          await mutate(category);
                          Loggy.info(
                              "Created/Updated category: $category.$name!");

                          if (context.mounted) context.pop();
                        }
                      }
                    : null,
                child: const Text('Save'),
              );
            }),
      ),
    );
  }
}
