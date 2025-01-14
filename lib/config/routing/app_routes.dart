// GoRouter configuration
import 'dart:async';

import 'package:cotrack/config/routing/app_shell.dart';
import 'package:cotrack/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:watch_it/watch_it.dart';

class AppRoutes {
  AppRoutes._();
  static const home = 'home';
  static const calendar = 'calendar';
  static const stats = 'stats';
  static const accounts = 'accounts';
  static const profile = 'profile';
  static const settings = 'settings';
  static const auth = 'auth';
  static const login = 'login';
  static const logout = 'logout';
  static const notifications = 'notifications';
  static const obraBookmarked = 'obraBookmarked';
  static const obraRecommended = 'obraRecommended';
  static const obraDetail = 'obraDetail';
  static const obrasByCategory = 'obrasByCategory';
  static const allCategories = 'allCategories';

  // profile
  static const profileEdit = 'edit-profile';
  static const profileNotifications = 'profile-notifications';
  static const profileProviderRegistration = 'profile-provider-registration';
  static const profilePayment = 'profile-payment';
  static const profileSecurity = 'profile-security';
  static const profilePrivacy = 'profile-privacy';
  static const profileHelpCenter = 'profile-help-center';

  static const providerHome = 'provider-today';
  static const providerListing = 'provider-listing';
  static const providerCalendar = 'provider-calendar';
  static const providerInbox = 'provider-inbox';
  static const providerProfile = 'provider-profile';
}

final appRouter = GoRouter(
  refreshListenable:
      GoRouterRefreshStream(Supabase.instance.client.auth.onAuthStateChange),
  redirect: (context, state) {
    final isAuth = Supabase.instance.client.auth.currentUser != null;
    if (!isAuth && !state.fullPath!.startsWith('/auth')) {
      return '/auth/login';
    } else if (isAuth && state.fullPath == '/auth/login') {
      return '/';
    }

    if (state.matchedLocation == "/") {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      name: AppRoutes.auth,
      path: '/auth',
      routes: [
        GoRoute(
          name: AppRoutes.login,
          path: '/login',
          builder: (context, state) => LoginScreen(
            userService: di.get(),
          ),
        ),
      ],
      builder: (context, state) => const NotificationScreen(),
    ),
    // -----------------------------------------------------------------------

    // // PROFILE
    // GoRoute(
    //   name: AppRoutes.profileEdit,
    //   path: '/profile/edit',
    //   builder: (context, state) => const EditProfileScreen(),
    // ),
    // GoRoute(
    //   name: AppRoutes.profileNotifications,
    //   path: '/profile/notifications',
    //   builder: (context, state) => const EditProfileScreen(),
    // ),
    // GoRoute(
    //   name: AppRoutes.profilePayment,
    //   path: '/profile/payments',
    //   builder: (context, state) => const EditProfileScreen(),
    // ),
    // GoRoute(
    //   name: AppRoutes.profileSecurity,
    //   path: '/profile/security',
    //   builder: (context, state) => const EditProfileScreen(),
    // ),
    // GoRoute(
    //   name: AppRoutes.profilePrivacy,
    //   path: '/profile/privacy',
    //   builder: (context, state) => const EditProfileScreen(),
    // ),
    // GoRoute(
    //   name: AppRoutes.profileHelpCenter,
    //   path: '/profile/help-center',
    //   builder: (context, state) => const EditProfileScreen(),
    // ),
    // GoRoute(
    //   name: AppRoutes.profileProviderRegistration,
    //   path: '/profile/provider-registration',
    //   builder: (context, state) => ProviderRegistrationFormScreen(),
    // ),

    // -----------------------------------------------------------------------
    // CLIENT VIEW TABS
    StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(shell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              name: AppRoutes.home,
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              name: AppRoutes.calendar,
              path: '/calendar',
              builder: (context, state) => CalendarScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              name: AppRoutes.stats,
              path: '/stats',
              builder: (context, state) => StatsScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              name: AppRoutes.accounts,
              path: '/accounts',
              builder: (context, state) => const AccountsScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              name: AppRoutes.settings,
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ]),
        ])
  ],
);

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
