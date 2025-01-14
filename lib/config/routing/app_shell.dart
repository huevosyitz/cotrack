import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cotrack/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watch_it/watch_it.dart';

class AppShell extends WatchingWidget {
  final StatefulNavigationShell shell;

  const AppShell({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
              onTap: (value) => shell.goBranch(value),
              currentIndex: shell.currentIndex,
              backgroundColor: context.backgroundColor,
              selectedItemColor: context.primaryColor,
              unselectedItemColor: context.primaryColor.withValues(alpha: 0.3),
              //         backgroundColor: yColors.background,
              // selectedItemColor: yColors.primary,
              // unselectedItemColor: yColors.background3,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    yIcons.home,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(yIcons.calendar),
                  label: 'Calendar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(yIcons.booking),
                  label: 'Transactions',
                ),
                BottomNavigationBarItem(
                  icon: Icon(yIcons.finance),
                  label: 'Accounts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(yIcons.settings),
                  label: 'Settings',
                ),
              ]),
          body: shell),
    );
  }
}
