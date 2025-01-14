import 'dart:convert';

import 'package:cotrack/core/models/transaction_type.dart';

class TransactionCategory {
  final int id;
  final String name;
  final TransactionType transactionType;

  TransactionCategory({
    required this.id,
    required this.name,
    required this.transactionType,
  });

  TransactionCategory copyWith({
    int? id,
    String? name,
    String? description,
    TransactionType? transactionType,
  }) {
    return TransactionCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      transactionType: transactionType ?? this.transactionType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'transactionType': transactionType.name,
    };
  }

  factory TransactionCategory.fromMap(Map<String, dynamic> map) {
    return TransactionCategory(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      transactionType: TransactionType.values
          .firstWhere((e) => e.name == map['transactionType']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionCategory.fromJson(String source) =>
      TransactionCategory.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransactionCategory(id: $id, name: $name, transactionType: $transactionType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionCategory &&
        other.id == id &&
        other.name == name &&
        other.transactionType == transactionType;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ transactionType.hashCode;
  }
}
