import 'package:cotrack/core/models/user.dart';
import 'package:cotrack/core/repo/repo.dart';

class UserService {
  final UserRepo _userRepo;

  UserService(this._userRepo);

  Future<UserModel> getCurrentUser() async {
    // return UserModel(
    //     email: "huevos_yitz@outlook.com",
    //     firstName: "Yitzhak",
    //     lastName: "Huevos",
    //     middleName: "Mariquit",
    //     id: "12345",
    //     username: "yitz");

    // // final response = await httpClient.get('/user/$id');
    // // return UserModel.fromMap(response.data);

    var userId = supaClient.auth.currentSession!.user.id;
    return _userRepo.getUser(userId);
  }
}
