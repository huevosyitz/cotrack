import 'dart:convert';

import 'package:cotrack/core/models/transaction_type.dart';

class TransactionCategory {
  final String id;
  final String name;
  final String description;
  final TransactionType transactionType;

  TransactionCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.transactionType,
  });

  TransactionCategory copyWith({
    String? id,
    String? name,
    String? description,
    TransactionType? transactionType,
  }) {
    return TransactionCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      transactionType: transactionType ?? this.transactionType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'transactionType': transactionType.name,
    };
  }

  factory TransactionCategory.fromMap(Map<String, dynamic> map) {
    return TransactionCategory(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      transactionType: TransactionType.values
          .firstWhere((e) => e.toString() == map['transactionType']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionCategory.fromJson(String source) =>
      TransactionCategory.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransactionCategory(id: $id, name: $name, description: $description, transactionType: $transactionType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionCategory &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.transactionType == transactionType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        transactionType.hashCode;
  }
}
