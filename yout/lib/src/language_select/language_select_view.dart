import 'package:flutter/material.dart';
import 'package:yout/src/settings/globals.dart';
import 'package:yout/src/settings/languages.dart';
import 'package:yout/src/translate/translate_view.dart';

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
              Navigator.pop(context);
            } else if (mode == modeNative) {
              Navigator.restorablePopAndPushNamed(
                context,
                "/$modeLearn",
              );
            } else {
              Navigator.restorablePopAndPushNamed(
                context,
                TranslateView.routeName,
              );
            }
          });
    });

    return Scaffold(
        appBar: AppBar(
          title: Text(mode == modeNative ? "Native language?" : 'Learn what?'),
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
                    ? 'Choose a language that you understand well. You will be translating to and from this language.'
                    : "Select the language that you want to learn. You will be translating to and from this language."),
              ),
              ...languageTiles,
            ]));
  }
}
