import 'package:yout/src/audio/listen.dart';
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

class Globals {
  late SettingsController settingsController;
  late SimpleStorage simpleStorage;
  Language nativeLang = Language.invalidlanguage;
  Language learningLang = Language.invalidlanguage;

  init() async {
    // Set up the SettingsController, which will glue user settings to multiple
    // Flutter Widgets.
    // Load the user's preferred theme while the splash screen is displayed.
    // This prevents a sudden theme change when the app is first displayed.
    settingsController = SettingsController(SettingsService());
    await settingsController.loadSettings();

    simpleStorage = SimpleStorage();
    await simpleStorage.init();

    await initLanguages();

    await MySpeechToText().init();
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
