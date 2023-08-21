import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kana_kit/kana_kit.dart';
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
  List<String> filesList = [];

  int _currentFileIndex = 0;
  final KanaKit _kanaKit = const KanaKit();

  TranslateController();

  load(String level) async {
    // final manifestJson =
    // await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    // if (filesList.isNotEmpty) {
    //   return;
    // }
    final manifestJson = await rootBundle.loadString('AssetManifest.json');
    filesList = json
        .decode(manifestJson)
        .keys
        .where((String key) => key
            .startsWith('assets/translatordb/$level')) // WhereIterable<String>
        .toList();

    if (filesList.isEmpty) {
      debugPrint('BIG PROBLEM - No translation files found');
    }
    debugPrint('files found: ${filesList.length}');
    for (String name in filesList) {
      debugPrint('Found $name');
    }
  }

  Future<Translation?> nextTranslation() async {
    if (filesList.isEmpty) {
      return null;
    }
    if (_currentFileIndex == 0) {
      filesList.shuffle();
    }
    final filename = filesList[_currentFileIndex];
    _currentFileIndex++;
    if (_currentFileIndex >= filesList.length) {
      _currentFileIndex = 0;
    }
    return Translation.loadFromFile(filename);
  }

  normalizeSentence(Language lang, String text) {
    // Note that RegExp(r'[^a-zA-Z0-9\s]') is wrong becaue it removes unicode.
    // We keep only:
    //   Letters as defined by unicode
    //   Whitespace
    //   Apostrophe ' (it is syntactically important in English)
    RegExp notAlphaNumRegex = RegExp(r"[^\p{Letter}0-9\s']", unicode: true);

    var normalized = text
        .replaceAll(notAlphaNumRegex, '')
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');

    if (lang == Language.jpn) {
      // In Japanese spaces don't matter, so we remove them.
      normalized = normalized.replaceAll(RegExp(r'\s'), r'');
      normalized = _kanaKit.toHiragana(normalized);
      normalized =
          normalized.replaceAll('あなた', '君').replaceAll(RegExp('[僕俺]'), '私');
    }

    if (lang == Language.eng) {
      // Simplify a few common contractions
      normalized = normalized.replaceAll(RegExp(r"\bi will\b"), "i'll");
    }

    if (normalized.isEmpty && text.length > 1) {
      // debugPrint('Normalized text went down to zero: $text');
      return text;
    }
    return normalized;
  }

  isSameSentence(Language lang, String text, List<String> options) {
    text = normalizeSentence(lang, text);
    for (String option in options) {
      var normalizedOption = normalizeSentence(lang, option);
      if (text == normalizedOption) {
        // debugPrint('isSameSentence: true');
        // debugPrint('isSameSentence: true, $text, $normalizedOption');
        return true;
      }
      // debugPrint(
      //     'isSameSentence normalizedOption: false: $text, $normalizedOption');
    }
    // debugPrint('isSameSentence false: $text, $options');
    return false;
  }
}
