import 'package:flutter/material.dart';
import 'package:yout/src/settings/globals.dart';
import 'package:yout/src/settings/languages.dart';
import 'package:yout/src/tools/toast.dart';

class ExampleText extends StatefulWidget {
  const ExampleText({
    Key? key,
    required this.text,
    required this.lang,
    required this.globals,
  }) : super(key: key);

  final Globals globals;
  final String text;
  final Language lang;

  @override
  State<ExampleText> createState() => ExampleTextState();
}

class ExampleTextState extends State<ExampleText> {
  bool _isSayingExampleSlowly = false;
  bool _isPlaying = false;

  @override
  void didUpdateWidget(ExampleText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The widget gets reused when text is replaced
    // so we must make sure to reset its settings.
    if (widget.text != oldWidget.text) {
      _isSayingExampleSlowly = false;
      _isPlaying = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.text, style: const TextStyle(fontSize: 30.0)),
      leading: CircleAvatar(
        // Display the Flutter Logo image asset.
        foregroundImage: languageImage(),
      ),
      onTap: sayTheExample,
    );
  }

  languageImage() {
    if (languageToInfo[widget.lang] == null) {
      return null;
    }
    if (_isPlaying) {
      return const AssetImage('assets/images/simple_speaker.png');
    }
    return AssetImage(languageToInfo[widget.lang]!.flagAssetPath());
  }

  sayTheExample() async {
    // Stop the mic while the example is spoken
    widget.globals.speechToText.stopListening();
    debugPrint('saying example: ${widget.text} $_isSayingExampleSlowly');
    var rate = 1.0;
    if (_isSayingExampleSlowly) {
      rate = 0.6;
    }
    _isSayingExampleSlowly = !_isSayingExampleSlowly;
    setState(() {
      _isPlaying = true;
    });
    var res = await widget.globals.speak
        .speak(lang: widget.lang, text: widget.text, rate: rate);
    setState(() {
      _isPlaying = false;
    });
    if (res != null && context.mounted) {
      Toast.toast(context, res.message);
    }
  }
}
