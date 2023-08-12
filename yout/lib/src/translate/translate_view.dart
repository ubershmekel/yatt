import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:yout/src/audio/listen.dart';
import 'package:yout/src/settings/globals.dart';
import 'package:yout/src/settings/languages.dart';
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

enum Modes {
  trying,
  success,
  helped,
}

class _TranslateViewState extends State<TranslateView> {
  Translation? _translation;
  String _toTranslateText = 'Please translate this';
  String _statusText = '';
  Language _recordingLang = Language.invalidlanguage;
  Language _exampleLang = Language.invalidlanguage;
  final dictationBox = TextEditingController();
  final TranslateController controller = TranslateController();
  Modes mode = Modes.trying;
  int roundsStarted = 0;
  bool isAutoNexting = false;

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
    dictationBox.addListener(onDictationBoxChanged);
    const nextButtonIcon = Icon(Icons.next_plan);

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
            onTap: sayTheExample,
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
                  onPressed: onStartRecording,
                ),
                FloatingActionButton.extended(
                  heroTag: UniqueKey(),
                  icon: isAutoNexting
                      ? SizedBox(
                          height: nextButtonIcon.size,
                          width: nextButtonIcon.size,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : nextButtonIcon,
                  label: const Text('Next'),
                  onPressed: nextRound,
                ),
                FloatingActionButton.extended(
                  heroTag: UniqueKey(),
                  icon: const Icon(Icons.hail_rounded),
                  label: const Text('Help'),
                  onPressed: onHelp,
                ),
              ],
            ),
          ),
          Center(
              child:
                  Text(_statusText, style: const TextStyle(fontSize: 200.0))),
        ]));
  }

  String lastDictationBoxText = '';
  onDictationBoxChanged() {
    String text = dictationBox.text;
    if (text == lastDictationBoxText) {
      // Avoid some log spam, and triple checking.
      // For example, every time the cursor moves this is called.
      return;
    }
    lastDictationBoxText = text;
    debugPrint('onDictationBoxChanged: $text');
    if (_translation == null) {
      return;
    }
    if (mode != Modes.trying) {
      return;
    }

    List<String> viableTranslations = _translation!.examples[_recordingLang]!;
    if (controller.isSameSentence(text, viableTranslations)) {
      youWin();
    }
  }

  onHelp() async {
    mode = Modes.helped;
    String oneAnswer =
        _translation!.examples[_recordingLang]!.firstOrNull ?? '';
    if (oneAnswer == '') {
      debugPrint('Something is wrong. No translation.');
      return;
    }
    dictationBox.text = oneAnswer;
    await widget.globals.speak.speak(_recordingLang, oneAnswer);
  }

  onStartRecording() {
    return MySpeechToText().listen(
      _recordingLang,
      onRecordingStatus,
    );
  }

  onRecordingStatus(Language lang, SpeechRecognitionResult res) {
    if (lang != _recordingLang) {
      debugPrint(
          "onRecordingStatus: lang != _recordingLang. So ignoring results.");
      return;
    }

    // Update the dictation box, the game will update the status from onDictationBoxChanged
    dictationBox.text = res.recognizedWords;
  }

  youWin() async {
    if (mode == Modes.success) {
      debugPrint('Something is wrong. You already won.');
      return;
    }
    mode = Modes.success;
    widget.globals.audioFiles.yay();
    setState(() {
      _statusText = '✅🎉';
    });

    isAutoNexting = true;
    await Future.delayed(const Duration(seconds: 3));
    nextRound();
  }

  nextRound() async {
    roundsStarted++;
    isAutoNexting = false;
    // _toTranslateText = TranslateController.filesList[0];
    mode = Modes.trying;
    _translation = (await controller.nextTranslation());
    _statusText = '';
    dictationBox.text = '';
    setState(() {
      final tmp = _exampleLang;
      _exampleLang = _recordingLang;
      _recordingLang = tmp;
      debugPrint(
          "trans: ${_translation?.examples.length}, example:$_exampleLang, recording:$_recordingLang");

      var line = _translation?.examples[_exampleLang]?.firstOrNull ??
          'Strange error... where is the line?';
      _toTranslateText = line;
      sayAndRecord();
    });
  }

  sayAndRecord() async {
    await sayTheExample();
    // On Anrdoid, it seems the recording starts before the example is fully said
    // so I add this 500ms delay.
    await Future.delayed(const Duration(milliseconds: 500));
    await onStartRecording();
  }

  sayTheExample() {
    return widget.globals.speak.speak(_exampleLang, _toTranslateText);
  }
}
