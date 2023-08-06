import 'package:shared_preferences/shared_preferences.dart';

enum Keys {
  nativeLanguage,
  targetLanguage,
  themeMode,
}

class SimpleStorage {
  late SharedPreferences prefs;

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<String?> getString(Keys key) async {
    return prefs.getString(key.name);
  }

  Future<bool> setString(Keys key, String value) async {
    return prefs.setString(key.name, value);
  }
}
