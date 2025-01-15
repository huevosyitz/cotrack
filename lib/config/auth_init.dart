import 'package:cotrack/core/services/user_service.dart';
import 'package:cotrack/core/state/app_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watch_it/watch_it.dart';

class AuthInit {
  static Future<void> init() async {
    final appState = di.get<AppState>();
    final userService = di.get<UserService>();

    Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      switch (event) {
        case AuthChangeEvent.initialSession:
        // handle initial session
        case AuthChangeEvent.userUpdated:
        // handle user updated
        case AuthChangeEvent.tokenRefreshed:
        // handle token refreshed
        case AuthChangeEvent.signedIn:
        // handle signed in
        case AuthChangeEvent.passwordRecovery:
        // handle password recovery
        case AuthChangeEvent.mfaChallengeVerified:
          // handle mfa challenge verified

          if (session?.user.id != null) {
            final user = await userService.getCurrentUser();
            await appState.setCurrentUser(user);
          } else {
            await appState.setCurrentUser(null);
          }

          break;
        case AuthChangeEvent.userDeleted:
        // handle user deleted
        case AuthChangeEvent.signedOut:
          // handle signed out
          await appState.setCurrentUser(null);
          break;
      }
    });
  }
}
