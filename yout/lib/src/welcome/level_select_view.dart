import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yout/src/settings/globals.dart';
import 'package:yout/src/translate/learn_view.dart';
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
        name: AppLocalizations.of(context)!.moreLevels,
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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialog(context, lev.id),
                            );
                          }
                        : null,
                  )),
            ]));
  }

  Widget _buildPopupDialog(BuildContext context, String levelId) {
    const double buttonLabelWidth = 160;
    const double buttonHeight = 100;
    return AlertDialog(
      // title: const Text('Popup example'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: [
            SizedBox(
                height: buttonHeight,
                child: FloatingActionButton.extended(
                  // `heroTag` to avoid " multiple heroes that share the same tag within a subtree" error
                  // https://stackoverflow.com/a/69342661/177498
                  heroTag: UniqueKey(),
                  icon: const Icon(Icons.nordic_walking),
                  label: SizedBox(
                      width: buttonLabelWidth,
                      child: Text(
                        AppLocalizations.of(context)!.modeDescriptionLean,
                      )),
                  onPressed: () {
                    // `Navigator.pop(context)` to dismiss the dialog so it's
                    // not visible when the user returns.
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            LearnView(globals: globals, level: levelId),
                      ),
                    );
                  },
                ))
          ]),
          const SizedBox(height: 20),
          Row(children: [
            SizedBox(
                height: buttonHeight,
                child: FloatingActionButton.extended(
                  // `heroTag` to avoid " multiple heroes that share the same tag within a subtree" error
                  // https://stackoverflow.com/a/69342661/177498
                  heroTag: UniqueKey(),
                  icon: const Icon(Icons.directions_bike),
                  label: SizedBox(
                      width: buttonLabelWidth,
                      child: Text(
                          AppLocalizations.of(context)!.modeDescriptionPlay)),
                  onPressed: () {
                    // `Navigator.pop(context)` to dismiss the dialog so it's
                    // not visible when the user returns.
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            TranslateView(globals: globals, level: levelId),
                      ),
                    );
                  },
                ))
          ]),
        ],
      ),
    );
  }
}
