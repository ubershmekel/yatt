import 'package:shared_preferences/shared_preferences.dart';

enum StorageKeys {
  nativeLanguage,
  targetLanguage,
  themeMode,
}

class SimpleStorage {
  late SharedPreferences prefs;

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<String?> getString(StorageKeys key) async {
    return prefs.getString(key.name);
  }

  Future<bool> setString(StorageKeys key, String value) async {
    return prefs.setString(key.name, value);
  }
}
