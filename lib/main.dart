import 'dart:ui';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:cotrack/config/config.dart';
import 'package:cotrack/config/data_init.dart';
import 'package:cotrack/core/services/logger.dart';
import 'package:cotrack/core/services/registrations.dart';
import 'package:cotrack/themes/themes.dart';
import 'package:cotrack/utils/drift_storage.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pwa_install_plus/pwa_install_plus.dart';
import 'package:pwa_update_listener/pwa_update_listener.dart';

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

  PWAInstall().setup(installCallback: () {
    debugPrint('APP INSTALLED!');
  });

  Registrations.setup();
  await AppConfig.init();
  await DatabaseSetup.init();
  await AuthInit.init();
  await DataInit.init();

  CachedQuery.instance.configFlutter(
    storage: CacheDriftStorage(),
    config: QueryConfigFlutter(
      // Globally set the refetch duration
      refetchDuration: Duration(hours: 24),
    ),
  );

  runApp(GlobalLoaderOverlay(
    overlayWidgetBuilder: (_) {
      return const Center(
        child: CircularProgressIndicator(
          color: yColors.primary,
        ),
      );
    },
    child: Builder(builder: (context) {
      return PwaUpdateListener(
        onReady: () {
          /// Show a snackbar to get users to reload into a newer version
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Expanded(child: Text('A new update is ready')),
                  TextButton(
                    onPressed: () {
                      reloadPwa();
                    },
                    child: Text('UPDATE'),
                  ),
                ],
              ),
              duration: Duration(days: 365),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
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
      );
    }),
  ));
}
