import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yout/src/settings/globals.dart';
import 'package:yout/src/translate/translate_view.dart';

import '../settings/settings_view.dart';

class Level {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final bool enabled;

  const Level(
      {required this.id,
      required this.name,
      required this.emoji,
      this.description = '',
      this.enabled = true});
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
    final List<Level> levels = [
      Level(
        id: 'invalid!!',
        name: AppLocalizations.of(context)!.learnPhrases,
        description: AppLocalizations.of(context)!.inDevelopment,
        emoji: '🚧',
        enabled: false,
      ),
      Level(
        id: 'a1',
        name: AppLocalizations.of(context)!.translateA1,
        emoji: '🏠',
      ),
      Level(
        id: 'a1b',
        name: AppLocalizations.of(context)!.translateA1B,
        emoji: '✈️',
      ),
      Level(
        id: 'a2',
        name: AppLocalizations.of(context)!.translateA2,
        emoji: '🏫',
      ),
      Level(
        id: 'b1',
        name: AppLocalizations.of(context)!.translateB1,
        description: AppLocalizations.of(context)!.helpImproveThisPlease,
        emoji: '🚀',
      ),
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.selectLevel),
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
              ...levels.map((lev) => ListTile(
                    title: Text(lev.name),
                    subtitle: lev.description.isNotEmpty
                        ? Text(lev.description)
                        : null,
                    leading: Text(
                      lev.emoji,
                      style: const TextStyle(fontSize: 40),
                    ),
                    enabled: lev.enabled,
                    onTap: lev.enabled
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TranslateView(
                                    globals: globals, level: lev.id),
                              ),
                            );
                          }
                        : null,
                  )),
            ]));
  }
}
