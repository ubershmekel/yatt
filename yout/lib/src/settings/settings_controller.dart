import 'package:flutter/material.dart';
import 'package:yout/src/settings/languages.dart';
import 'package:yout/src/settings/simple_storage.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  // Make _simpleStorage a private variable so it is not used directly.
  final _simpleStorage = SimpleStorage();

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;
  Language _nativeLang = Language.invalidlanguage;
  Language _learningLang = Language.invalidlanguage;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;
  Language get nativeLang => _nativeLang;
  Language get learningLang => _learningLang;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    await _simpleStorage.init();
    _themeMode = await _getThemeMode();
    await _initLanguages();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  _initLanguages() async {
    // Read from storage the native and learning languages
    String nativeString =
        await _simpleStorage.getString(StorageKeys.nativeLanguage) ?? '';
    if (stringToLangMap.containsKey(nativeString)) {
      _nativeLang = stringToLangMap[nativeString]!;
    }

    String learningString =
        await _simpleStorage.getString(StorageKeys.targetLanguage) ?? '';
    if (stringToLangMap.containsKey(learningString)) {
      _learningLang = stringToLangMap[learningString]!;
    }
  }

  updateNativeLanguage(LanguageInfo info) async {
    debugPrint('updating native language to ${info.code3}');
    _nativeLang = stringToLangMap[info.code3]!;
    _simpleStorage.setString(StorageKeys.nativeLanguage, info.code3);
    notifyListeners();
  }

  updateLearningLanguage(LanguageInfo info) async {
    _learningLang = stringToLangMap[info.code3]!;
    _simpleStorage.setString(StorageKeys.targetLanguage, info.code3);
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    debugPrint("setting themeMode: $newThemeMode");
    await _simpleStorage.setString(StorageKeys.themeMode, newThemeMode.name);
  }

  Future<ThemeMode> _getThemeMode() async {
    final savedMode =
        await _simpleStorage.getString(StorageKeys.themeMode) ?? '';
    if (ThemeMode.values.asNameMap().containsKey(savedMode)) {
      return ThemeMode.values.byName(savedMode);
    }

    return ThemeMode.system;
  }
}
