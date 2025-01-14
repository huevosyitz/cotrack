import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cotrack/components/show_confirmation_modal.dart';
import 'package:cotrack/core/services/services.dart';
import 'package:cotrack/core/state/app_state.dart';
import 'package:cotrack/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

class SettingsScreen extends WatchingWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = watchValue(((AppState s) => s.currentUser));
    final authService = di.get<AuthService>();

    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
          ),
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: context.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          yIcons.profile,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${user.firstName} ${user.lastName}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(
                  color: yColors.background3,
                ),
                const SizedBox(height: 10),
                ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: [
                    _listRouteTile(context, "Logout", yIcons.logout, "",
                        onTap: () {
                      showConfirmationModal(
                          context, "Are you sure you want to logout?",
                          () async {
                        authService.signOut();
                      },
                          cancelText: "Cancel",
                          confirmText: "Logout",
                          headerText: "Confirm Logout");
                    }),
                  ],
                ),
              ],
            ),
          ))),
    );
  }

  ListTile _listRouteTile(
      BuildContext context, String title, IconData icon, String routeName,
      {Function? onTap}) {
    return ListTile(
      dense: true,
      title: Text(title),
      leading: Icon(icon),
      trailing: onTap == null ? const Icon(yIcons.arrowRight) : null,
      onTap: () async {
        onTap != null ? await onTap() : context.pushTo(routeName);
      },
    );
  }
}
