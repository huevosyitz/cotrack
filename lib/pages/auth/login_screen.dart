import 'package:cotrack/core/services/user_service.dart';
import 'package:cotrack/core/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:watch_it/watch_it.dart';

class LoginScreen extends StatelessWidget {
  final UserService userService;
  const LoginScreen({super.key, required this.userService});

  @override
  Widget build(BuildContext context) {
    final appState = di.get<AppState>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SupaEmailAuth(
              onSignInComplete: (response) async {
                if (response.user != null) {
                  final user = await userService.getCurrentUser();
                  await appState.setCurrentUser(user);
                }
              },
              onSignUpComplete: (response) {},
              metadataFields: [
                MetaDataField(
                  prefixIcon: const Icon(Icons.person),
                  label: 'Username',
                  key: 'username',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter something';
                    }
                    return null;
                  },
                ),
                MetaDataField(
                  prefixIcon: const Icon(Icons.person),
                  label: 'Username',
                  key: 'username',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter something';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
