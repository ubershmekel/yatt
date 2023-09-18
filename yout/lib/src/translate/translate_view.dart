import 'dart:async';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:yout/src/audio/listen.dart';
import 'package:yout/src/settings/globals.dart';
import 'package:yout/src/settings/languages.dart';
import 'package:yout/src/translate/poppy_button.dart';
import 'package:yout/src/translate/translate_controller.dart';

import '../settings/settings_view.dart';

/// Displays a list of SampleItems.
class TranslateView extends StatefulWidget {
  final Globals globals;
  final String level;

  const TranslateView({
    super.key,
    required this.globals,
    required this.level,
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
  String _helpText = '';
  Language _recordingLang = Language.invalidlanguage;
  Language _exampleLang = Language.invalidlanguage;
  final dictationBox = TextEditingController();
  final TranslateController controller = TranslateController();
  Modes mode = Modes.trying;
  int roundsStarted = 0;
  bool isAutoNexting = false;
  bool isRecording = false;
  bool isSayingExampleSlowly = false;
  String lastDictationBoxText = '';
  late Future dependenciesInited;
  int adviceIndex = 0;
  int helpIndex = 0;

  initDependencies() async {
    await widget.globals.initWithPermissions();
  }

  @override
  initState() {
    super.initState();

    dependenciesInited = initDependencies();

    controller.load(widget.level).then((_) async {
      // Without awaiting here, the first text-to-speech will fail
      await dependenciesInited;
      refreshLanguages();
      nextRound();
    });

    widget.globals.settingsController.addListener(() {
      // Settings have changed, maybe it's a new language?
      refreshLanguages();
    });
  }

  refreshLanguages() {
    setState(() {
      _exampleLang = widget.globals.settingsController.nativeLang;
      _recordingLang = widget.globals.settingsController.learningLang;
    });
  }

  @override
  Widget build(BuildContext context) {
    dictationBox.addListener(onDictationBoxChanged);

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
        body: FutureBuilder(
          future: dependenciesInited,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return buildBody();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  final helpButtonKey = GlobalKey<PoppyButtonState>();
  final speakButtonKey = GlobalKey<PoppyButtonState>();
  final nextButtonKey = GlobalKey<PoppyButtonState>();
  final reportButtonKey = GlobalKey<PoppyButtonState>();

  buildBody() {
    return ListView(children: [
      ListTile(
        title: Text(_toTranslateText, style: const TextStyle(fontSize: 30.0)),
        leading: CircleAvatar(
          // Display the Flutter Logo image asset.
          foregroundImage: languageToInfo[_exampleLang] == null
              ? null
              : AssetImage(languageToInfo[_exampleLang]!.flagAssetPath()),
        ),
        onTap: sayTheExample,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: TextField(
          controller: dictationBox,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Your translation',
          ),
        ),
      ),
      Center(
          child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.end,
              children: [
            PoppyButton(
                key: speakButtonKey,
                button: FloatingActionButton.extended(
                  // `heroTag` to avoid " multiple heroes that share the same tag within a subtree" error
                  // https://stackoverflow.com/a/69342661/177498
                  heroTag: UniqueKey(),
                  icon: const Icon(Icons.mic),
                  label: Text(
                    '${AppLocalizations.of(context)!.speak} ${_recordingLang.name}',
                  ),
                  backgroundColor: isRecording
                      ? Colors.red
                      : Theme.of(context)
                          .floatingActionButtonTheme
                          .backgroundColor,
                  onPressed: onStartRecording,
                  tooltip:
                      'The app will start listening to your spoken words and check if your translation was correct',
                )),
            PoppyButton(
                key: nextButtonKey,
                button: FloatingActionButton.extended(
                  heroTag: UniqueKey(),
                  icon: isAutoNexting
                      ? SizedBox(
                          height: Theme.of(context).iconTheme.size,
                          width: Theme.of(context).iconTheme.size,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.next_plan),
                  label: Text(
                    AppLocalizations.of(context)!.next,
                  ),
                  tooltip: 'Skip this translation and go to the next',
                  onPressed: nextRound,
                )),
            PoppyButton(
                key: helpButtonKey,
                button: FloatingActionButton.extended(
                    heroTag: UniqueKey(),
                    icon: const Icon(Icons.hail_rounded),
                    label: Text(
                      AppLocalizations.of(context)!.help,
                    ),
                    onPressed: onHelp,
                    tooltip: 'See the possible answers for this translation')),
            PoppyButton(
                key: reportButtonKey,
                button: FloatingActionButton.extended(
                  heroTag: UniqueKey(),
                  icon: const Icon(Icons.bug_report),
                  label: Text(
                    AppLocalizations.of(context)!.report,
                  ),
                  onPressed: onReport,
                  tooltip:
                      'Email the developer about a missing translation or another problem',
                )),
          ])),
      Center(child: Text(_helpText)),
      Center(child: Text(_statusText, style: const TextStyle(fontSize: 200.0))),
    ]);
  }

  var _isReporting = false;
  onReport() async {
    // Prevent rapid-tapping of the report button
    if (_isReporting) {
      return;
    }
    _isReporting = true;
    Timer(
        const Duration(seconds: 2), () => setState(() => _isReporting = false));

    final Email email = Email(
      subject: 'YATT Report',
      body:
          'From: $_exampleLang, $_toTranslateText\n\nTo: $_recordingLang, ${dictationBox.text}\n\n',
      recipients: ['YATT <ubershmekel+yatt@gmail.com>'],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (err) {
      // iOS silently fails to email when there is no account set up for it.
      // > PlatformException (PlatformException(not_available, No email clients found!, null, null))
      if (context.mounted) {
        // Check `context.mounted` because of
        // https://stackoverflow.com/questions/68871880/do-not-use-buildcontexts-across-async-gaps

        // Hide previouse snack bars
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Please set up an email app to use the report button. You can also email ubershmekel@gmail.com directly."),
        ));
      }
    }
  }

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
    if (controller.isSameSentence(_recordingLang, text, viableTranslations)) {
      youWin();
    }
  }

  onHelp() async {
    // Stop the mic while the example is spoken
    widget.globals.speechToText.stopListening();

    // mode = Modes.helped;
    String oneAnswer =
        _translation!.examples[_recordingLang]!.firstOrNull ?? '';
    if (oneAnswer == '') {
      debugPrint('Something is wrong. No translation.');
      return;
    }
    var exampleLines = _translation!.examples[_recordingLang]!;
    setState(() {
      _helpText = '';
      for (var example in exampleLines) {
        _helpText += '$example\n\n';
      }
    });

    await widget.globals.speak.speak(
        lang: _recordingLang,
        text: exampleLines[helpIndex % exampleLines.length]);
    helpIndex++;
  }

  onStartRecording() {
    setState(() {
      isRecording = true;
    });
    return widget.globals.speechToText.listen(
      _recordingLang,
      onRecordingStatus,
    );
  }

  onRecordingStatus(SpeechStatus status) {
    debugPrint('onRecordingStatus: ${status.isListening}');
    if (!mounted) {
      // Probably just closed the screen, so don't care about the updates
      return;
    }
    if (status.lang != _recordingLang) {
      debugPrint(
          "onRecordingStatus: lang != _recordingLang. So ignoring results.");
      return;
    }
    if (status.isListening) {
      setState(() {
        isRecording = true;
      });
    } else {
      setState(() {
        if (isRecording) {
          // Only want to check during the transition.
          // This might be called more than once.
          Timer(const Duration(seconds: 1), checkAfterFinishedRecording);
        }
        isRecording = false;
      });
    }
    // Update the dictation box, the game will update the status from onDictationBoxChanged
    if (status.result != null) {
      dictationBox.text = status.result!.recognizedWords;
    }
  }

  checkAfterFinishedRecording() {
    if (!isRecording && mode != Modes.success) {
      if (adviceIndex == 0) {
        showAdviceUseRecord();
      } else if (adviceIndex == 1) {
        showAdviceUseHelp();
      } else if (adviceIndex == 2) {
        showAdviceUseNext();
      } else if (adviceIndex == 3) {
        showAdviceUseReport();
      }
      adviceIndex++;
    }
  }

  youWin() async {
    // `stopListening` is important because if the recording is on
    // then the yay sound is quieter. Also, we don't want the recording
    // to carry on to the next round.
    widget.globals.speechToText.stopListening();

    // Remove help text to make sure the celebratory _statusText is visible
    _helpText = '';

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
    // 3 seconds felt a bit fast and tiring.
    await Future.delayed(const Duration(seconds: 4));
    nextRound();
  }

  showAdviceUseHelp() {
    helpButtonKey.currentState?.pulse();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(AppLocalizations.of(context)!.adviceHelp,
          style: const TextStyle(fontSize: 26.0)),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ));
  }

  showAdviceUseRecord() {
    speakButtonKey.currentState?.pulse();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(AppLocalizations.of(context)!.adviceRecord,
          style: const TextStyle(fontSize: 26.0)),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ));
  }

  showAdviceUseNext() {
    nextButtonKey.currentState?.pulse();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(AppLocalizations.of(context)!.adviceNext,
          style: const TextStyle(fontSize: 26.0)),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ));
  }

  showAdviceUseReport() {
    reportButtonKey.currentState?.pulse();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(AppLocalizations.of(context)!.adviceReport,
          style: const TextStyle(fontSize: 26.0)),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ));
  }

  nextRound() async {
    roundsStarted++;
    isSayingExampleSlowly = false;
    isAutoNexting = false;
    _helpText = '';
    if (widget.globals.speechToText.isListening) {
      widget.globals.speechToText.stopListening();
    }

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
          'Where is the line? Report this error to the developer please';
      _toTranslateText = line;
      sayAndRecord();
    });
  }

  sayAndRecord() async {
    await sayTheExample();
    // On Andרoid, it seems the recording starts before the example is fully said
    // so I add this 500ms delay.
    await Future.delayed(const Duration(milliseconds: 500));
    await onStartRecording();
  }

  sayTheExample() {
    // Stop the mic while the example is spoken
    widget.globals.speechToText.stopListening();

    var rate = 1.0;
    if (isSayingExampleSlowly) {
      rate = 0.6;
    }
    isSayingExampleSlowly = !isSayingExampleSlowly;
    return widget.globals.speak
        .speak(lang: _exampleLang, text: _toTranslateText, rate: rate);
  }

  @override
  void dispose() {
    // We're getting closed
    widget.globals.speechToText.disposing();
    super.dispose();
  }
}
