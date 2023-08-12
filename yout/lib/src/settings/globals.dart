import 'package:flutter/material.dart';
import 'package:yout/src/audio/audio_files.dart';
import 'package:yout/src/audio/listen.dart';
import 'package:yout/src/audio/speak.dart';
import 'package:yout/src/settings/simple_storage.dart';
import '../settings/settings_controller.dart';
import '../settings/settings_service.dart';

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

final stringToLangMap = Language.values.asNameMap();

// Note on Android default emulator,
// ar-EG and he-IL are not available :/
Map<Language, String> languageToLocaleId = {
  Language.eng: 'en-US',
  Language.ara: 'ar-EG',
  Language.deu: 'de-DE',
  Language.ell: 'el-GR',
  Language.fra: 'fr-FR',
  Language.heb: 'he-IL',
  Language.ita: 'it-IT',
  Language.jpn: 'ja-JP',
  Language.kor: 'ko-KR',
  Language.por: 'pt-BR',
  Language.rus: 'ru-RU',
  Language.spa: 'es-ES',
};

class Globals {
  late SettingsController settingsController;
  final SimpleStorage simpleStorage = SimpleStorage();
  final Speak speak = Speak();
  Language nativeLang = Language.invalidlanguage;
  Language learningLang = Language.invalidlanguage;
  final AudioFiles audioFiles = AudioFiles();

  init() async {
    // Set up the SettingsController, which will glue user settings to multiple
    // Flutter Widgets.
    // Load the user's preferred theme while the splash screen is displayed.
    // This prevents a sudden theme change when the app is first displayed.
    settingsController = SettingsController(SettingsService());
    await settingsController.loadSettings();

    await simpleStorage.init();

    await initLanguages();

    await MySpeechToText().init();

    await speak.init();
  }

  initLanguages() async {
    String nativeString =
        await simpleStorage.getString(Keys.nativeLanguage) ?? '';
    if (stringToLangMap.containsKey(nativeString)) {
      nativeLang = stringToLangMap[nativeString]!;
    }

    String learningString =
        await simpleStorage.getString(Keys.targetLanguage) ?? '';
    if (stringToLangMap.containsKey(learningString)) {
      learningLang = stringToLangMap[learningString]!;
    }
  }
}
