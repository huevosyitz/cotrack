import 'package:cotrack/features/auth/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supaClient = Supabase.instance.client;

class UserRepo {
  Future<UserModel> getUser(String userId) async {
    var result =
        await _supaClient.from("profiles").select().eq("id", userId).single();

    return UserModel.fromMap(result);
  }
}
