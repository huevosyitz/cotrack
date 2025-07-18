import 'dart:convert';

class UserModel {
  final String id;
  final String email;
  final String username;
  final int groupId;
  
  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.groupId,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    int? groupId,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      groupId: groupId ?? this.groupId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      groupId: map['group_id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, username: $username, groupId: $groupId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.id == id &&
      other.email == email &&
      other.username == username &&
      other.groupId == groupId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      email.hashCode ^
      username.hashCode ^
      groupId.hashCode;
  }
}
