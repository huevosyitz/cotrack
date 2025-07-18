import 'package:cotrack/features/auth/user.dart';
import 'package:cotrack/features/auth/user_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final UserRepo _userRepo;

  UserService(this._userRepo);

  Future<UserModel> getCurrentUser() async {
    var userId = Supabase.instance.client.auth.currentSession!.user.id;
    return _userRepo.getUser(userId);
  }
}
