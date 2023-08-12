import 'package:yout/src/audio/sound_files.dart';
import 'package:yout/src/audio/listen.dart';
import 'package:yout/src/audio/speak.dart';
import 'package:yout/src/settings/languages.dart';
import 'package:yout/src/settings/simple_storage.dart';
import '../settings/settings_controller.dart';
import '../settings/settings_service.dart';

class Globals {
  late SettingsController settingsController;
  final SimpleStorage simpleStorage = SimpleStorage();
  final Speak speak = Speak();
  Language nativeLang = Language.invalidlanguage;
  Language learningLang = Language.invalidlanguage;
  final SoundFiles audioFiles = SoundFiles();

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
    // Read from storage the native and learning languages
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
