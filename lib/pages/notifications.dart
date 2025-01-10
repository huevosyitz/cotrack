import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../themes/themes.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          leading: IconButton(
            icon: const Icon(yIcons.leftArrow),
            onPressed: () {
              GoRouterHelper(context).canPop()
                  ? GoRouterHelper(context).pop()
                  : null;
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(yIcons.more),
              onPressed: () {},
            ).pr(8),
          ],
        ),
        body: Placeholder());
  }
}
