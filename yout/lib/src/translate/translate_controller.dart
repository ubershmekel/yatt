import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Language {
  eng,
  ara,
  deu,
  ell,
  fra,
  heb,
  ita,
  jpn,
  kor,
  por,
  rus,
  spa,
  invalidlanguage,
}

final langMap = Language.values.asNameMap();

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

    // File(path)
    //     .openRead()
    //     .map(utf8.decode)
    //     .transform(LineSplitter())
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
        if (!langMap.containsKey(lang)) {
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
}
