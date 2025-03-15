import 'dart:convert';

import 'package:cotrack/core/models/icon_item.dart';
import 'package:cotrack/core/models/transaction_type.dart';
import 'package:cotrack/themes/themes.dart';
import 'package:flutter/material.dart';

class TransactionCategory {
  final int id;
  final String name;
  final TransactionType transactionType;
  final IconItem iconItem;

  TransactionCategory({
    required this.id,
    required this.name,
    required this.transactionType,
    required this.iconItem,
  });

  TransactionCategory copyWith({
    int? id,
    String? name,
    String? description,
    TransactionType? transactionType,
    IconItem? iconItem,
  }) {
    return TransactionCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      transactionType: transactionType ?? this.transactionType,
      iconItem: iconItem ?? this.iconItem,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'transactionType': transactionType.name,
      'iconItemKey': iconItem.key,
    };
  }

  factory TransactionCategory.fromMap(Map<String, dynamic> map) {
    return TransactionCategory(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      transactionType: TransactionType.values
          .firstWhere((e) => e.name == map['transactionType']),
      iconItem: yIcons.getIconItem(map["iconItemKey"]),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionCategory.fromJson(String source) =>
      TransactionCategory.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransactionCategory(id: $id, name: $name, transactionType: $transactionType), iconItem: ${iconItem.key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionCategory &&
        other.id == id &&
        other.name == name &&
        other.transactionType == transactionType &&
        other.iconItem == iconItem;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        transactionType.hashCode ^
        iconItem.hashCode;
  }
}
