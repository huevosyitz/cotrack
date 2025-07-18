import 'dart:convert';

class TransactionAccount {
  final int id;
  final String name;
  TransactionAccount({
    required this.id,
    required this.name,
  });

  TransactionAccount copyWith({
    int? id,
    String? name,
  }) {
    return TransactionAccount(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory TransactionAccount.fromMap(Map<String, dynamic> map) {
    return TransactionAccount(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionAccount.fromJson(String source) =>
      TransactionAccount.fromMap(json.decode(source));

  @override
  String toString() => 'TransactionAccount(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionAccount && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
