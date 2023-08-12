import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yout/src/settings/languages.dart';

class Translation {
  String filename = '';
  Map<Language, List<String>> examples = {};

  static Future<Translation> loadFromFile(String path) async {
    // # lang:eng
    //
    // A book is lying on the desk.
    final instance = Translation();
    instance.filename = path;
    Language currentLang = Language.invalidlanguage;

    final fileContents = await rootBundle.loadString(path);

    LineSplitter.split(fileContents).forEach((String line) {
      line = line.trim();
      if (line.isEmpty) {
        return;
      }
      if (line[0] == '#') {
        final parts = line.split(':');
        if (parts.length != 2) {
          return;
        }
        String lang = parts[1];
        if (!stringToLangMap.containsKey(lang)) {
          debugPrint('Unknown language: $lang');
          return;
        }
        currentLang = Language.values.byName(lang);
        instance.examples[currentLang] = [];
      } else {
        instance.examples[currentLang]?.add(line);
      }
    });
    return instance;
  }
}

class TranslateController {
  static List<String> filesList = [];

  TranslateController();

  load() async {
    // final manifestJson =
    // await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    if (filesList.isNotEmpty) {
      return;
    }
    final manifestJson = await rootBundle.loadString('AssetManifest.json');
    filesList = json
        .decode(manifestJson)
        .keys
        .where((String key) =>
            key.startsWith('assets/translatordb')) // WhereIterable<String>
        .toList();

    debugPrint('files found: ${filesList.length}');
    for (String name in filesList) {
      debugPrint('Found $name');
    }
  }

  Future<Translation?> nextTranslation() async {
    if (filesList.isEmpty) {
      return null;
    }
    var rng = Random();
    final index = rng.nextInt(filesList.length);
    final filename = filesList[index];
    return Translation.loadFromFile(filename);
  }

  normalizeSentence(String text) {
    // Note that RegExp(r'[^a-zA-Z0-9\s]') is wrong becaue it removes unicode.
    // We keep only:
    //   Letters as defined by unicode
    //   Whitespace
    //   Apostrophe ' (it is syntactically important in English)
    RegExp notAlphaNumRegex = RegExp(r"[^\p{Letter}0-9\s']", unicode: true);

    final normalized = text
        .replaceAll(notAlphaNumRegex, '')
        .toLowerCase()
        .trim()
        .replaceAll(RegExp('\\s+'), ' ');
    if (normalized.isEmpty && text.length > 1) {
      // debugPrint('Normalized text went down to zero: $text');
      return text;
    }
    return normalized;
  }

  isSameSentence(String text, List<String> options) {
    text = normalizeSentence(text);
    for (String option in options) {
      if (text == normalizeSentence(option)) {
        debugPrint('isSameSentence: true');
        return true;
      }
    }
    debugPrint('isSameSentence false: $text, $options');
    return false;
  }
}
