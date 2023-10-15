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
      debugPrint(
          'BIG PROBLEM - No translation files found for $level. Did you add them to the pubscpec.yaml?');
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
      normalized = normalized
          .replaceAll('あなた', '君')
          .replaceAll(RegExp('[僕俺]'), '私')
          .replaceAll('過ぎ', 'すぎ');
    }

    if (lang == Language.eng) {
      // Simplify a few common contractions
      normalized = normalized.replaceAll(RegExp(r"\bi am\b"), "i'm");
      normalized = normalized.replaceAll(RegExp(r"\bwe are\b"), "we're");
      normalized = normalized.replaceAll(RegExp(r"\byou are\b"), "you're");
      normalized = normalized.replaceAll(RegExp(r"\bthey are\b"), "they're");
      normalized = normalized.replaceAll(RegExp(r"\bi will\b"), "i'll");
      normalized = normalized.replaceAll(RegExp(r"\bwill not\b"), "won't");
      normalized = normalized.replaceAll(RegExp(r"\byou will\b"), "you'll");
      normalized = normalized.replaceAll(RegExp(r"\bthere is\b"), "there's");
      normalized = normalized.replaceAll(RegExp(r"\bhe is\b"), "he's");
      normalized = normalized.replaceAll(RegExp(r"\bshe is\b"), "she's");
      normalized = normalized.replaceAll(RegExp(r"\bdo not\b"), "don't");
      normalized = normalized.replaceAll(RegExp(r"\bcannot\b"), "can't");
      normalized = normalized.replaceAll(RegExp(r"\bare not\b"), "aren't");
      normalized = normalized.replaceAll(RegExp(r"\bwas not\b"), "wasn't");
      normalized = normalized.replaceAll(RegExp(r"\bis not\b"), "isn't");
    }

    if (lang == Language.heb) {
      // Note \b does not work with unicode
      // https://stackoverflow.com/questions/10590098/javascript-regexp-word-boundaries-unicode-characters
      normalized = normalized.replaceAll(RegExp(r"(?:^|\\s)ב[\s\-]+"), "ב");
    }

    if (normalized.isEmpty && text.length > 1) {
      // This happens often during dictation
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
