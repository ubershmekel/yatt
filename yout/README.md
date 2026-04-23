# You Are The Translator App

This directory contains the Flutter app for You Are The Translator.

The app teaches language practice through short spoken translation prompts. A
player selects their native language and a target language, listens to a
sentence, says the translation, and gets feedback from speech recognition.

## Supported languages

The current localization files cover Arabic, German, Greek, English, Spanish,
French, Hebrew, Italian, Japanese, Korean, Portuguese, and Russian.

Lesson content is stored under `assets/translatordb/` by level (`a1`, `a1b`,
`a2`, `b1`).

## Setup

Install Flutter, then fetch dependencies:

```bash
flutter pub get
```

## Running locally

```bash
flutter run -d chrome
```

You can also run against a connected device or simulator by replacing `chrome`
with the device id from `flutter devices`.

## Testing

```bash
flutter test
```

## Building releases

```bash
# Android app bundle
flutter build appbundle

# iOS archive
flutter build ipa
```

## Generated assets

```bash
# Generate app icons from ../art/yatt-logo-1024.png
dart run flutter_launcher_icons

# Generate localization classes from lib/src/localization/*.arb
flutter gen-l10n
```

To generate missing ARB translations from English, see
[../tools/gcptranslate/README.md](../tools/gcptranslate/README.md).

## App stores

- App Store: https://apps.apple.com/us/app/you-are-the-translator/id6463097357
- Google Play: https://play.google.com/store/apps/details?id=com.andluck.yatt
