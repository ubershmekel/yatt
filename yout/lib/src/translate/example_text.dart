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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.text, style: const TextStyle(fontSize: 30.0)),
      leading: CircleAvatar(
        // Display the Flutter Logo image asset.
        foregroundImage: languageToInfo[widget.lang] == null
            ? null
            : AssetImage(languageToInfo[widget.lang]!.flagAssetPath()),
      ),
      onTap: sayTheExample,
    );
  }

  sayTheExample() async {
    // Stop the mic while the example is spoken
    widget.globals.speechToText.stopListening();

    var rate = 1.0;
    if (_isSayingExampleSlowly) {
      rate = 0.6;
    }
    _isSayingExampleSlowly = !_isSayingExampleSlowly;
    var res = await widget.globals.speak
        .speak(lang: widget.lang, text: widget.text, rate: rate);
    if (res != null && context.mounted) {
      Toast.toast(context, res.message);
    }
  }
}
