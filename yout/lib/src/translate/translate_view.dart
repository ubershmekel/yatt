import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:yout/src/audio/listen.dart';
import 'package:yout/src/settings/globals.dart';
import 'package:yout/src/translate/translate_controller.dart';

import '../settings/settings_view.dart';

/// Displays a list of SampleItems.
class TranslateView extends StatefulWidget {
  final Globals globals;

  const TranslateView({
    super.key,
    required this.globals,
  });

  @override
  State<TranslateView> createState() => _TranslateViewState();

  static const routeName = '/translate';

  // var toTranslateBox = TextEditingController();
  // var translateBox = TextToTranslate();
  // var toTranslateText = 'Please translate this';
}

class _TranslateViewState extends State<TranslateView> {
  String _toTranslateText = 'Please translate this';
  Language _recordingLang = Language.invalidlanguage;
  Language _exampleLang = Language.invalidlanguage;
  final dictationBox = TextEditingController();
  final TranslateController controller = TranslateController();

  @override
  initState() {
    super.initState();
    controller.load().then((_) {
      _exampleLang = widget.globals.nativeLang;
      _recordingLang = widget.globals.learningLang;
      nextRound();
    });
  }

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
          ListTile(
            title: Text(_toTranslateText),
            // title: translateBox,
            //Text(toTranslateText),
            leading: const CircleAvatar(
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  // `heroTag` to avoid " multiple heroes that share the same tag within a subtree" error
                  // https://stackoverflow.com/a/69342661/177498
                  heroTag: UniqueKey(),
                  icon: const Icon(Icons.record_voice_over),
                  label: Text('Speak ${_recordingLang.name}'),
                  onPressed: () {
                    MySpeechToText().listen(
                      _recordingLang,
                      (SpeechRecognitionResult res) {
                        dictationBox.text = res.recognizedWords;
                      },
                    );
                  },
                ),
                FloatingActionButton.extended(
                  heroTag: UniqueKey(),
                  icon: const Icon(Icons.next_plan),
                  label: const Text('Next'),
                  onPressed: nextRound,
                ),
              ],
            ),
          ),
        ]));
  }

  nextRound() async {
    // _toTranslateText = TranslateController.filesList[0];
    Translation trans = (await controller.nextTranslation())!;
    setState(() {
      final tmp = _exampleLang;
      _exampleLang = _recordingLang;
      _recordingLang = tmp;
      debugPrint(
          "trans: ${trans.examples.length}, example:$_exampleLang, recording:$_recordingLang");

      var line = trans.examples[_exampleLang]?.firstOrNull;
      _toTranslateText = line ?? 'Strange error... where is the line?';
    });
  }
}
