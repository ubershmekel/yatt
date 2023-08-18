import 'package:flutter/material.dart';
import 'package:yout/src/settings/globals.dart';
import 'package:yout/src/translate/translate_view.dart';

import '../settings/settings_view.dart';

class Level {
  final String name;
  final String description;

  const Level(this.name, this.description);
}

class LevelSelectView extends StatelessWidget {
  const LevelSelectView({
    super.key,
    required this.globals,
  });

  final Globals globals;

  static const routeName = '/level-select';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select a level'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),

        // To work with lists that may contain a large number of items, it’s best
        // to use the ListView.builder constructor.
        //
        // In contrast to the default ListView constructor, which requires
        // building all Widgets up front, the ListView.builder constructor lazily
        // builds Widgets as they’re scrolled into view.
        body: ListView(
            // Providing a restorationId allows the ListView to restore the
            // scroll position when a user leaves and returns to the app after it
            // has been killed while running in the background.
            restorationId: 'levelSelectView',
            children: [
              ListTile(
                title: const Text('A1 - Translate single words'),
                leading: const Text(
                  '🏠',
                  style: TextStyle(fontSize: 40),
                ),
                onTap: () {
                  debugPrint('tapped 1');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          TranslateView(globals: globals, level: 'a1'),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('A2 - Translate simple sentences'),
                leading: const Text(
                  '🏫',
                  style: TextStyle(fontSize: 40),
                ),
                onTap: () {
                  debugPrint('tapped 2');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          TranslateView(globals: globals, level: 'a2'),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('B1 - Translate tricky sentences'),
                subtitle: const Text('In development'),
                enabled: false,
                leading: const Text(
                  '🚀',
                  style: TextStyle(fontSize: 40),
                ),
                onTap: () {
                  debugPrint('tapped 3');
                },
              )
            ]));
  }
}
