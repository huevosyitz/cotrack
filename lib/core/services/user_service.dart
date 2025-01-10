import 'package:cotrack/core/models/user.dart';

class UserService {
  Future<UserModel> getUser(String id) async {
    return UserModel(
        email: "huevos_yitz@outlook.com",
        firstName: "Yitzhak",
        lastName: "Huevos",
        middleName: "Mariquit",
        id: "12345",
        userName: "yitz");

    // final response = await httpClient.get('/user/$id');
    // return UserModel.fromMap(response.data);
  }
}
