import 'dart:ui';

import 'package:calendar_view/calendar_view.dart';
import 'package:cotrack/config/config.dart';
import 'package:cotrack/core/services/logger.dart';
import 'package:cotrack/core/services/registrations.dart';
import 'package:cotrack/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:loader_overlay/loader_overlay.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    Loggy.error(details.exceptionAsString());
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    Loggy.error(error.toString());
    Loggy.error(stack.toString());
    return true;
  };

  Registrations.setup();
  await AppConfig.init();
  await DatabaseSetup.init();
  await AuthInit.init();

  final queryClient = QueryClient(
      defaultQueryOptions: DefaultQueryOptions(
    cacheDuration: const Duration(days: 1),
  ));

  runApp(GlobalLoaderOverlay(
    overlayWidgetBuilder: (_) {
      return const Center(
        child: CircularProgressIndicator(
          color: yColors.primary,
        ),
      );
    },
    child: QueryClientProvider(
      queryClient: queryClient,
      child: CalendarControllerProvider(
        controller: EventController(),
        child: MaterialApp.router(
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
          // theme: yTheme.dark,
          // darkTheme: yTheme.dark,
          // themeMode: ThemeMode.dark,
          // The Mandy red, light theme.
          theme: AppTheme.light,
          // The Mandy red, dark theme.
          darkTheme: AppTheme.dark,
          // Use dark or light theme based on system setting.
          themeMode: ThemeMode.system,
        ),
      ),
    ),
  ));
}
