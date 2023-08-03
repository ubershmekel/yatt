import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:yout/src/audio/listen.dart';

import '../settings/settings_view.dart';

/// Displays a list of SampleItems.
class TranslateView extends StatelessWidget {
  TranslateView({
    super.key,
  });

  static const routeName = '/translate';

  var dictationBox = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('You are the translator'),
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
        body: ListView(children: [
          const ListTile(
            title: Text('The phrase to translate'),
            leading: CircleAvatar(
              // Display the Flutter Logo image asset.
              foregroundImage: AssetImage('assets/images/flutter_logo.png'),
            ),
            // ]
            // Center(
            //     child: Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [const Text("What you should translate")],
            // ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: TextField(
              controller: dictationBox,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your translation',
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  icon: const Icon(Icons.record_voice_over),
                  label: const Text('Speak'),
                  onPressed: () {
                    MySpeechToText().listen(
                      (SpeechRecognitionResult res) {
                        dictationBox.text = res.recognizedWords;
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ]));
  }
}
