import 'dart:convert';

import 'package:cotrack/core/models/transaction_type.dart';
import 'package:flutter/material.dart';

class TransactionCategory {
  final int id;
  final String name;
  final TransactionType transactionType;
  final IconData iconData;

  TransactionCategory({
    required this.id,
    required this.name,
    required this.transactionType,
    this.iconData = Icons.category,
  });

  TransactionCategory copyWith({
    int? id,
    String? name,
    String? description,
    TransactionType? transactionType,
    IconData? iconData,
  }) {
    return TransactionCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      transactionType: transactionType ?? this.transactionType,
      iconData: iconData ?? this.iconData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'transactionType': transactionType.name,
      'iconData':
          "${convertToInt(iconData.codePoint)}|${iconData.fontFamily}|${iconData.fontPackage}",
    };
  }

  static int convertToInt(dynamic value) {
    if (value is int) {
      return value; // Already an integer
    } else if (value is String) {
      if (value.startsWith('0x') || value.startsWith('0X')) {
        // Hex string with "0x" prefix
        return int.parse(value.substring(2), radix: 16);
      } else if (RegExp(r'^[0-9]+$').hasMatch(value)) {
        // Stringified integer (decimal)
        return int.parse(value);
      } else {
        throw ArgumentError(
            'Invalid input: Must be an int, a hex string, or a stringified int.');
      }
    } else {
      throw ArgumentError('Invalid input type: Must be an int or a string.');
    }
  }

  factory TransactionCategory.fromMap(Map<String, dynamic> map) {
    final iconConcat = map['iconData'].toString().split('|');

    return TransactionCategory(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      transactionType: TransactionType.values
          .firstWhere((e) => e.name == map['transactionType']),
      iconData: IconData(
        convertToInt(iconConcat[0]),
        fontFamily: iconConcat[1].isEmpty ? null : iconConcat[1],
        fontPackage: iconConcat[2].isEmpty ? null : iconConcat[2],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionCategory.fromJson(String source) =>
      TransactionCategory.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransactionCategory(id: $id, name: $name, transactionType: $transactionType), iconData: $iconData';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionCategory &&
        other.id == id &&
        other.name == name &&
        other.transactionType == transactionType &&
        other.iconData == iconData;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        transactionType.hashCode ^
        iconData.hashCode;
  }
}
