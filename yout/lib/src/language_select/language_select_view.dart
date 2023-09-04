import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yout/src/settings/globals.dart';
import 'package:yout/src/settings/languages.dart';
import 'package:yout/src/welcome/level_select_view.dart';
import 'package:yout/src/welcome/welcome_view.dart';

import '../settings/settings_view.dart';

class LanguageItemListView extends StatelessWidget {
  const LanguageItemListView({
    super.key,
    required this.globals,
    required this.mode,
  });

  final Globals globals;

  // static const routeName = '/';
  static const modeNative = 'select-native';
  static const modeLearn = 'select-learn';
  static const nativeRoute = '/select-native';
  static const learnRoute = '/select-learn';

  final String mode;

  @override
  Widget build(BuildContext context) {
    var languageTiles = languageToInfo.entries.map((entry) {
      Language toDisable = Language.invalidlanguage;
      if (mode == modeNative) {
        toDisable = globals.settingsController.learningLang;
      } else {
        toDisable = globals.settingsController.nativeLang;
      }
      return ListTile(
          title: Text(entry.value.name),
          leading: CircleAvatar(
            // Display the Flutter Logo image asset.
            foregroundImage: AssetImage(entry.value.flagAssetPath()),
          ),
          enabled: entry.key != toDisable,
          onTap: () {
            // Navigate to the details page. If the user leaves and returns to
            // the app after it has been killed while running in the
            // background, the navigation stack is restored.
            // Navigator.restorablePushNamed(
            //   context,
            //   SampleItemDetailsView.routeName,
            // );
            if (mode == modeNative) {
              globals.settingsController.updateNativeLanguage(entry.value);
            }
            if (mode == modeLearn) {
              globals.settingsController.updateLearningLanguage(entry.value);
            }

            if (Navigator.canPop(context)) {
              // When invoked from the settings menu
              Navigator.pop(context);
            } else if (mode == modeNative) {
              Navigator.restorablePopAndPushNamed(
                context,
                WelcomeView.routeName,
              );
            } else {
              // Game on to the level select
              // Navigator.restorablePopAndPushNamed(
              //   context,
              //   TranslateView.routeName,
              // );

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LevelSelectView(globals: globals),
                ),
              );
            }
          });
    });

    return Scaffold(
        appBar: AppBar(
          title: Text(mode == modeNative
              ? AppLocalizations.of(context)!.nativeLanguage
              : AppLocalizations.of(context)!.learningLanguage),
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
            restorationId: 'languageSelectListView',
            children: [
              ListTile(
                title: Text(mode == modeNative
                    ? AppLocalizations.of(context)!.selectNativeLanguageSubtitle
                    : AppLocalizations.of(context)!
                        .selectLearnLanguageSubtitle),
              ),
              ...languageTiles,
            ]));
  }
}
