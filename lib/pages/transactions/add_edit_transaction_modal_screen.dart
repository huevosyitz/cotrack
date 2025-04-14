import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:cotrack/core/state/app_state.dart';
import 'package:cotrack/themes/extensions.dart';
import 'package:cotrack/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:watch_it/watch_it.dart';

class AddEditTransactionModelScreen extends WatchingWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final selectedCategoryType =
      ValueNotifier<TransactionType>(TransactionType.expense);
  bool isEdit = false;
  double? initialAmount;
  int? initialAccountId;
  String? initialNotes;

  DateTime? initialTransactionDate;
  TransactionCategory? initialCategory;
  final Transaction? transactionToEdit;

  AddEditTransactionModelScreen({
    super.key,
    this.initialTransactionDate,
    this.initialCategory,
    this.transactionToEdit,
  }) {
    _initializeData();
  }

  void _initializeData() {
    if (transactionToEdit != null) {
      isEdit = true;
      initialAmount = transactionToEdit!.amount;
      initialTransactionDate = transactionToEdit!.transaction_date;
      initialCategory = TransactionCategoryService.allCategories
          .singleWhere((f) => f.id == transactionToEdit!.category_id);
      selectedCategoryType.value = initialCategory!.transactionType;
      initialAccountId = transactionToEdit!.account_id;
      initialNotes = transactionToEdit!.notes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionService = di.get<TransactionService>();
    final user = watchValue(((AppState s) => s.currentUser));
    final selectedType = watch(selectedCategoryType).value;
    List<TransactionCategory> displayCategories =
        selectedType == TransactionType.income
            ? TransactionCategoryService.incomeCategories
            : TransactionCategoryService.expenseCategories;

    final allAccounts = TransactionAccountService.allAccounts;

    if (user == null) {
      throw Exception("User not found");
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          SegmentedButton<TransactionType>(
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
              selectedCategoryType.value = transactionSelected.first;
            },
          ),
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
        child: Column(
          spacing: 8,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    spacing: 12,
                    children: [
                      _buildDateTimePicker(),
                      _buildAmountTextField(),
                      _buildCategoryChoices(displayCategories),
                      _buildAccountChoices(allAccounts),
                      _buildNotesField(),
                    ],
                  ),
                ),
              ),
            ),
            _buildSaveButton(transactionService, user)
          ],
        ),
      ),
    );
  }

  MutationBuilder<Transaction, Transaction> _buildSaveButton(
      TransactionService transactionService, UserModel user) {
    return MutationBuilder(
        mutation: isEdit
            ? transactionService.updateTransactionMutation()
            : transactionService.createTransactionMutation(),
        builder: (context, snapshot, mutate) {
          return MaterialButton(
            minWidth: double.infinity,
            color: Theme.of(context).colorScheme.primary,
            onPressed: snapshot.isLoading
                ? null
                : () => _handleSave(user, mutate, context),
            child: snapshot.isLoading
                ? const CircularProgressIndicator()
                : const Text('Save'),
          );
        });
  }

  void _handleSave(
      UserModel user,
      Future<MutationState<Transaction?>> Function(Transaction args) mutate,
      BuildContext context) async {
    // Validate and save the form values
    _formKey.currentState?.saveAndValidate();
    debugPrint(_formKey.currentState?.value.toString());

    try {
      if (_formKey.currentState?.isValid == true) {
        var form = _formKey.currentState!.value;
        Transaction transactionToSubmit = _buildTransactionObject(form, user);

        var tran = await mutate(transactionToSubmit);

        Loggy.info("Created transaction: $tran");

        if (context.mounted) {
          context.pop({'refresh': true, 'transaction': tran});
        }
      }
    } catch (e) {
      Loggy.error("Error saving transaction: $e");
      context.showMessage(e.toString());
    }
  }

  Transaction _buildTransactionObject(
      Map<String, dynamic> form, UserModel user) {
    Transaction transactionToSubmit;

    if (isEdit) {
      transactionToSubmit = transactionToEdit!.copyWith(
        updated_at: DateTime.now(),
        transaction_date: form["date"],
        amount: double.parse(form["amount"]),
        category_id: form["category_id"],
        notes: form["notes"],
        account_id: form["account"],
        updated_by: user.id,
      );
    } else {
      transactionToSubmit = Transaction(
        id: generateUuid(),
        created_at: DateTime.now(),
        updated_at: null,
        transaction_date: form["date"],
        amount: double.parse(form["amount"]),
        category_id: form["category_id"],
        notes: form["notes"],
        account_id: form["account"],
        created_by: user.id,
        updated_by: user.id,
        group_id: user.groupId,
      );
    }
    return transactionToSubmit;
  }

  FormBuilderTextField _buildNotesField() {
    return FormBuilderTextField(
      name: 'notes',
      initialValue: initialNotes,
      decoration: const InputDecoration(
          labelText: 'Notes',
          floatingLabelBehavior: FloatingLabelBehavior.always),
    );
  }

  FormBuilderChoiceChip<dynamic> _buildAccountChoices(
      List<TransactionAccount> allAccounts) {
    return FormBuilderChoiceChip<dynamic>(
      name: 'account',
      decoration: const InputDecoration(labelText: 'Account'),
      initialValue: initialAccountId ?? allAccounts.first.id,
      spacing: 3,
      options: allAccounts
          .map((account) => FormBuilderChipOption(
                value: account.id,
                child: Text(account.name),
              ))
          .toList(),
      onChanged: (value) {
        print(value);
      },
    );
  }

  FormBuilderChoiceChip<dynamic> _buildCategoryChoices(
      List<TransactionCategory> displayCategories) {
    return FormBuilderChoiceChip<dynamic>(
      name: 'category_id',
      decoration: const InputDecoration(labelText: 'Category'),
      initialValue: initialCategory?.id,
      spacing: 3,
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      options: displayCategories
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
    );
  }

  FormBuilderTextField _buildAmountTextField() {
    return FormBuilderTextField(
      name: 'amount',
      keyboardType: TextInputType.number,
      initialValue: initialAmount == null
          ? null
          : NumberFormat("##0.##").format(initialAmount),
      autofocus: true,
      decoration: const InputDecoration(
          labelText: 'Amount',
          floatingLabelBehavior: FloatingLabelBehavior.always),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.positiveNumber(),
      ]),
    );
  }

  FormBuilderDateTimePicker _buildDateTimePicker() {
    return FormBuilderDateTimePicker(
      name: 'date',
      format: DateFormat('yyyy-MMM-dd'),
      enabled: true,
      inputType: InputType.date,
      // initialDate: date ?? DateTime.now(),
      initialValue: initialTransactionDate ?? DateTime.now(),
      decoration: InputDecoration(
          labelText: 'Date',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.normal)),
      style: TextStyle(
          color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.normal),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
    );
  }
}
