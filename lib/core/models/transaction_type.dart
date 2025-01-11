enum TransactionType {
  income("Income"),
  expense("Expense"),
  transfer("Transfer");

  final String displayName;

  const TransactionType(this.displayName);
}
