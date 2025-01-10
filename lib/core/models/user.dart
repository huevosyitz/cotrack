import 'dart:convert';

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String middleName;
  final String lastName;
  final String userName;
  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.userName,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? middleName,
    String? lastName,
    String? userName,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      userName: userName ?? this.userName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'userName': userName,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      middleName: map['middleName'] ?? '',
      lastName: map['lastName'] ?? '',
      userName: map['userName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, firstName: $firstName, middleName: $middleName, lastName: $lastName, userName: $userName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.firstName == firstName &&
        other.middleName == middleName &&
        other.lastName == lastName &&
        other.userName == userName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        firstName.hashCode ^
        middleName.hashCode ^
        lastName.hashCode ^
        userName.hashCode;
  }
}
