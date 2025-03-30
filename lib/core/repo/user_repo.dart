import 'package:cotrack/core/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supaClient = Supabase.instance.client;

class UserRepo {
  Future<UserModel> getUser(String userId) async {
    var result =
        await _supaClient.from("profiles").select().eq("id", userId).single();

    return UserModel.fromMap(result);
  }
}
