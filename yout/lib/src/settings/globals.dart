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
  var _inited = false;
  var _initedWithPermissions = false;

  init() async {
    if (_inited) {
      return;
    }
    _inited = true;

    // Set up the SettingsController, which will glue user settings to multiple
    // Flutter Widgets.
    // Load the user's preferred theme while the splash screen is displayed.
    // This prevents a sudden theme change when the app is first displayed.
    settingsController = SettingsController();
    await settingsController.loadSettings();

    await simpleStorage.init();
  }

  initWithPermissions() async {
    if (_initedWithPermissions) {
      return;
    }
    _initedWithPermissions = true;

    await speechToText.init();

    await speak.init();
  }
}
