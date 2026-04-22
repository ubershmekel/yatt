# Bug Fixes & Improvements

Issues found by auditing the codebase after the production breakage.

---

## Critical — Fix These First

### ~~1. `addListener` called inside `build()` — memory leak + duplicate callbacks~~ FIXED
**Files:** `yout/lib/src/translate/translate_view.dart:91`, `yout/lib/src/translate/learn_view.dart:102`

`dictationBox.addListener(onDictationBoxChanged)` is called on every rebuild. Each call stacks another listener on top without removing the previous one, so the callback fires N times for a single keystroke and old closures are never GC'd.

**Fix:** Move to `initState()` and `removeListener` in `dispose()`.

```dart
@override
void initState() {
  super.initState();
  dictationBox.addListener(onDictationBoxChanged);
}

@override
void dispose() {
  dictationBox.removeListener(onDictationBoxChanged);
  dictationBox.dispose();
  super.dispose();
}
```

---

### ~~2. `SettingsController` listener never removed — memory leak~~ FIXED
**Files:** `yout/lib/src/translate/translate_view.dart:76-79`, `yout/lib/src/translate/learn_view.dart:87-90`

An anonymous closure is added to `settingsController` in `initState()` but `dispose()` never calls `removeListener`. Every time the view is pushed/popped, another listener accumulates.

**Fix:** Store the callback in a field and remove it in `dispose()`.

```dart
late VoidCallback _settingsListener;

@override
void initState() {
  super.initState();
  _settingsListener = refreshLanguages;
  widget.globals.settingsController.addListener(_settingsListener);
}

@override
void dispose() {
  widget.globals.settingsController.removeListener(_settingsListener);
  super.dispose();
}
```

---

## High Priority

### 3. Array index out of bounds in `langToLocale()`
**File:** `yout/lib/src/app.dart:153`

```dart
var localeParts = xxMinusYy.split('-');
locale = Locale.fromSubtags(
    languageCode: localeParts[0], countryCode: localeParts[1]); // crashes if no '-'
```

Any language code in `languageToLocaleId` that lacks a country code (e.g. `"en"` instead of `"en-US"`) will throw `RangeError: Index out of range` at runtime.

**Fix:** Guard the index access:
```dart
locale = Locale.fromSubtags(
    languageCode: localeParts[0],
    countryCode: localeParts.length > 1 ? localeParts[1] : null);
```

---

### 4. Regex escape bug in Hebrew normalization
**File:** `yout/lib/src/translate/translate_controller.dart:141`

```dart
normalized = normalized.replaceAll(RegExp(r"(?:^|\\s)ב[\s\-]+"), "ב");
//                                              ^^^^ wrong
```

Inside a raw string (`r"..."`), `\\s` is a literal backslash followed by `s`, not a whitespace class. The lookahead never matches whitespace, so Hebrew words preceded by a space are not normalized.

**Fix:**
```dart
normalized = normalized.replaceAll(RegExp(r"(?:^|\s)ב[\s\-]+"), "ב");
```

---

## Medium Priority

### 5. `setState()` inside `Timer` without `mounted` check
**Files:** `yout/lib/src/translate/translate_view.dart:218`, `yout/lib/src/translate/learn_view.dart:221`

```dart
Timer(const Duration(seconds: 2), () => setState(() => _isReporting = false));
```

If the widget is disposed before the 2-second timer fires, this throws `setState() called after dispose()`.

**Fix:**
```dart
Timer(const Duration(seconds: 2), () {
  if (mounted) setState(() => _isReporting = false);
});
```

---

### 6. Unsafe null assertions on `_translation` and map values
**Files:** `yout/lib/src/translate/translate_view.dart:271,283,288,343`, `yout/lib/src/translate/learn_view.dart:258,301`

Multiple `!` force-unwraps on values that could be null (e.g. `_translation!.examples[_recordingLang]!`). If state gets out of sync these crash instead of degrading gracefully.

**Fix:** Replace force-unwraps with safe navigation (`?.`) and early returns or fallback values.

---

### 7. Inconsistent `mounted` checks
**File:** `yout/lib/src/translate/translate_view.dart:318`

Some places use `if (!mounted)` (old API) and others use `if (context.mounted)` (current API). Standardize on `context.mounted` throughout.

---

### 8. `onStartRecording()` return value not awaited
**File:** `yout/lib/src/translate/translate_view.dart:432-437`

```dart
sayAndRecord() async {
  await sayTheExample();
  await Future.delayed(const Duration(milliseconds: 500));
  await onStartRecording(); // onStartRecording returns a Future but isn't itself async
}

onStartRecording() {
  setState(() { isRecording = true; });
  return widget.globals.speechToText.listen(...); // unawaited inside
}
```

`onStartRecording` is not marked `async`, so errors from `listen()` are swallowed silently. Mark it `async` and `await` the inner call.

---

## Low Priority / Cleanup

### 9. Debug UI code mixed into production source files
**Files:** `yout/lib/src/audio/speak.dart:156-529`, `yout/lib/src/audio/listen.dart:138-636`

Each file contains a full debug/test app widget tree after the real class ends. This dead code inflates the binary and makes the files hard to navigate.

**Fix:** Delete the debug sections or move them to `test/` or a `debug/` folder excluded from release builds.

---

### 10. Typo in debug error message
**File:** `yout/lib/src/translate/translate_controller.dart:72`

```dart
'... Did you add them to the pubscpec.yaml?'
//                              ^^^^^^^^ should be pubspec.yaml
```

---

### 11. `TextEditingController` not disposed in views
**Files:** `translate_view.dart`, `learn_view.dart`

`dictationBox` is instantiated as a field but `dispose()` only calls `super.dispose()` after `speechToText.disposing()`. The controller itself is never disposed, leaking its internal resources.

**Fix:** Add `dictationBox.dispose()` in each `dispose()` override.

---

## Localization

### 12. Generated localization files not in `.gitignore` (or should be committed consistently)
The untracked `app_localizations*.dart` files suggest the generated output is not committed. Decide one way: either commit them (simpler CI) or add them to `.gitignore` and run `flutter gen-l10n` in CI. Currently neither is done, which caused a broken build after a fresh clone.
