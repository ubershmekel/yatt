import 'package:yout/src/audio/sound_files.dart';
import 'package:yout/src/audio/listen.dart';
import 'package:yout/src/audio/speak.dart';
import 'package:yout/src/settings/simple_storage.dart';
import '../settings/settings_controller.dart';

class Globals {
  late SettingsController settingsController;
  final SimpleStorage simpleStorage = SimpleStorage();
  final Speak speak = Speak();
  final MySpeechToText speechToText = MySpeechToText();
  final SoundFiles audioFiles = SoundFiles();

  init() async {
    // Set up the SettingsController, which will glue user settings to multiple
    // Flutter Widgets.
    // Load the user's preferred theme while the splash screen is displayed.
    // This prevents a sudden theme change when the app is first displayed.
    settingsController = SettingsController();
    await settingsController.loadSettings();

    await simpleStorage.init();

    await speechToText.init();

    await speak.init();
  }
}
