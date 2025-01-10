import 'package:cotrack/core/models/auth_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  Future<String?> getAccessToken() async {
    return Supabase.instance.client.auth.currentSession?.accessToken;
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  Future<AuthResponse> signIn(
      {required String email, required String password}) async {
    var authResponse = await Supabase.instance.client.auth
        .signInWithPassword(email: email, password: password);

    return authResponse;
  }

  Future<AppUser?> getCurrentUser() async {
    var user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return null;
    }

    return AppUser(id: user.id, email: user.email!);
  }
}
