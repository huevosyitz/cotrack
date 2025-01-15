import 'dart:convert';

import 'package:flutter/widgets.dart';

class Transaction {
  final int id;
  final DateTime created_at;
  final DateTime transaction_date;
  final double amount;
  final int category_id;
  final String? notes;
  final String created_by;
  final String updated_by;
  final int group_id;

  Transaction({
    required this.id,
    required this.created_at,
    required this.transaction_date,
    required this.amount,
    required this.category_id,
    required this.notes,
    required this.created_by,
    required this.updated_by,
    required this.group_id,
  });

  Transaction copyWith({
    int? id,
    DateTime? created_at,
    DateTime? transaction_date,
    double? amount,
    int? category_id,
    ValueGetter<String?>? notes,
    String? created_by,
    String? updated_by,
    int? group_id,
  }) {
    return Transaction(
      id: id ?? this.id,
      created_at: created_at ?? this.created_at,
      transaction_date: transaction_date ?? this.transaction_date,
      amount: amount ?? this.amount,
      category_id: category_id ?? this.category_id,
      notes: notes != null ? notes() : this.notes,
      created_by: created_by ?? this.created_by,
      updated_by: updated_by ?? this.updated_by,
      group_id: group_id ?? this.group_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': created_at.toIso8601String(),
      'transaction_date': transaction_date.toIso8601String(),
      'amount': amount,
      'category_id': category_id,
      'notes': notes,
      'created_by': created_by,
      'updated_by': updated_by,
      'group_id': group_id,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id']?.toInt() ?? 0,
      created_at: DateTime.parse(map['created_at']),
      transaction_date: DateTime.parse(map['transaction_date']),
      amount: map['amount']?.toDouble() ?? 0.0,
      category_id: map['category_id']?.toInt() ?? 0,
      notes: map['notes'],
      created_by: map['created_by'] ?? '',
      updated_by: map['updated_by'] ?? '',
      group_id: map['group_id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Transaction(id: $id, created_at: $created_at, transaction_date: $transaction_date, amount: $amount, category_id: $category_id, notes: $notes, created_by: $created_by, updated_by: $updated_by, group_id: $group_id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Transaction &&
        other.id == id &&
        other.created_at == created_at &&
        other.transaction_date == transaction_date &&
        other.amount == amount &&
        other.category_id == category_id &&
        other.notes == notes &&
        other.created_by == created_by &&
        other.updated_by == updated_by &&
        other.group_id == group_id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        created_at.hashCode ^
        transaction_date.hashCode ^
        amount.hashCode ^
        category_id.hashCode ^
        notes.hashCode ^
        created_by.hashCode ^
        updated_by.hashCode ^
        group_id.hashCode;
  }
}
