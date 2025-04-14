import 'package:cotrack/core/models/user.dart';
import 'package:cotrack/core/repo/repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final UserRepo _userRepo;

  UserService(this._userRepo);

  Future<UserModel> getCurrentUser() async {

    var userId = Supabase.instance.client.auth.currentSession!.user.id;
    return _userRepo.getUser(userId);
  }
}
