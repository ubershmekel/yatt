import 'package:flutter/material.dart';
import 'package:yout/src/settings/globals.dart';
import 'package:yout/src/settings/simple_storage.dart';

import '../settings/settings_view.dart';
import '../translate/translate_view.dart';
import 'language_item.dart';

class LanguageItemListView extends StatelessWidget {
  const LanguageItemListView({
    super.key,
    required this.globals,
    required this.mode,
    this.items = const [
      LanguageItem("English", "eng"),
      LanguageItem("Hebrew", "heb"),
      LanguageItem("Japanese", "jpn"),
    ],
  });

  final Globals globals;

  // static const routeName = '/';
  static const modeNative = 'select-native';
  static const modeLearn = 'select-learn';

  final String mode;
  final List<LanguageItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose your language'),
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
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'languageSelectListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
              title: Text(item.name),
              leading: const CircleAvatar(
                // Display the Flutter Logo image asset.
                foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              onTap: () {
                // Navigate to the details page. If the user leaves and returns to
                // the app after it has been killed while running in the
                // background, the navigation stack is restored.
                // Navigator.restorablePushNamed(
                //   context,
                //   SampleItemDetailsView.routeName,
                // );
                if (mode == modeNative) {
                  globals.simpleStorage
                      .setString(Keys.nativeLanguage, item.threeLetterCode);
                }
                if (mode == modeLearn) {
                  globals.simpleStorage
                      .setString(Keys.targetLanguage, item.threeLetterCode);
                }

                if (mode == modeNative) {
                  Navigator.restorablePushNamed(
                    context,
                    "/$modeLearn",
                  );
                } else {
                  Navigator.restorablePushNamed(
                    context,
                    TranslateView.routeName,
                  );
                }
              });
        },
      ),
    );
  }
}
