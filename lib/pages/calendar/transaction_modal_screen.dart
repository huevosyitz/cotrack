import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cotrack/core/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:watch_it/watch_it.dart';

class TransactionModelScreen extends WatchingStatefulWidget {
  final DateTime? date;
  final TransactionCategory? category;

  const TransactionModelScreen({
    super.key,
    this.date,
    this.category,
  });

  @override
  State<TransactionModelScreen> createState() => _TransactionModelScreenState();
}

class _TransactionModelScreenState extends State<TransactionModelScreen> {
  TransactionType selectedType = TransactionType.expense;
  final _formKey = GlobalKey<FormBuilderState>();
  final transactionService = di.get<TransactionService>();

  @override
  Widget build(BuildContext context) {
    final user = watchValue(((AppState s) => s.currentUser));

    return Scaffold(
      appBar: AppBar(
        title: SegmentedButton<TransactionType>(
          segments: const <ButtonSegment<TransactionType>>[
            ButtonSegment<TransactionType>(
              value: TransactionType.income,
              label: Text('Income'),
              // icon: Icon(Icons.calendar_view_day)
            ),
            ButtonSegment<TransactionType>(
              value: TransactionType.expense,
              label: Text('Expense'),
              // icon: Icon(Icons.calendar_view_week)
            ),
          ],
          selected: <TransactionType>{selectedType},
          onSelectionChanged: (Set<TransactionType> transactionSelected) {
            setState(() {
              // By default there is only a single segment that can be
              // selected at one time, so its value is always the first
              // item in the selected set.
              selectedType = transactionSelected.first;
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            spacing: 12,
            children: [
              FormBuilder(
                key: _formKey,
                child: Column(
                  spacing: 12,
                  children: [
                    FormBuilderDateTimePicker(
                      name: 'date',
                      format: DateFormat('yyyy-MMM-dd'),
                      enabled: true,
                      inputType: InputType.date,
                      initialDate: widget.date ?? DateTime.now(),
                      initialValue: widget.date ?? DateTime.now(),
                      decoration: InputDecoration(
                          labelText: 'Date',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal)),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'amount',
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      decoration: const InputDecoration(
                          labelText: 'Amount',
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.positiveNumber(),
                      ]),
                    ),
                    FormBuilderChoiceChip<dynamic>(
                      name: 'category_id',
                      decoration: const InputDecoration(labelText: 'Category'),
                      initialValue: widget.category?.id,
                      spacing: 3,
                      showCheckmark: false,
                      visualDensity: VisualDensity.compact,
                      options: TransactionCategoryService.transactionCategories
                          .map((category) => FormBuilderChipOption(
                                value: category.id,
                                child: Text(category.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        print(value);
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    FormBuilderChoiceChip<dynamic>(
                      name: 'type',
                      decoration: const InputDecoration(labelText: 'Account'),
                      initialValue: "Cash",
                      spacing: 3,
                      options: const [
                        FormBuilderChipOption(value: "Cash"),
                        FormBuilderChipOption(value: "Credit Card"),
                        FormBuilderChipOption(value: "Debit Card"),
                      ],
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                    FormBuilderTextField(
                      name: 'notes',
                      decoration: const InputDecoration(
                          labelText: 'Notes',
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    MaterialButton(
                      minWidth: double.infinity,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () async {
                        // Validate and save the form values
                        _formKey.currentState?.saveAndValidate();
                        debugPrint(_formKey.currentState?.value.toString());

                        // On another side, can access all field values without saving form with instantValues
                        _formKey.currentState?.validate();
                        debugPrint(
                            _formKey.currentState?.instantValue.toString());

                        if (_formKey.currentState?.isValid == true) {
                          // Save the form data
                          // final transaction = Transaction(
                          //   id: '1',
                          //   title: _formKey.currentState?.value['title'],
                          //   amount: _formKey.currentState?.value['amount'],
                          //   date: _formKey.currentState?.value['date'],
                          //   categoryId: _formKey.currentState?.value['category'],
                          //   note: _formKey.currentState?.value['note'],
                          // );
                          // TransactionService.addTransaction(transaction);
                          // Navigator.of(context).pop();

                          // Save the form data

                          var form = _formKey.currentState!.value;

                          if (user == null) {
                            throw Exception("User not found");
                          }

                          final transaction = Transaction(
                              id: 0,
                              created_at: DateTime.now(),
                              transaction_date: form["date"],
                              amount: double.parse(form["amount"]),
                              category_id: form["category_id"],
                              notes: form["notes"],
                              created_by: user.id,
                              updated_by: user.id,
                              group_id: user.groupId);

                          var tran = await transactionService
                              .createTransaction(transaction);

                          Loggy.info("Created transaction: $tran");

                          if (context.mounted) context.pop();
                        }
                      },
                      child: const Text('Save'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
