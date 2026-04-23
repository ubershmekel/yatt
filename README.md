# You Are The Translator

You Are The Translator is a hands-free language learning game. The app gives you
a sentence in one language, you translate it out loud, and the game checks your
spoken answer. It is designed for listening and speaking practice when a
screen-heavy lesson would be inconvenient.

## Links

- Website: https://youarethetranslator.com/
- App Store: https://apps.apple.com/us/app/you-are-the-translator/id6463097357
- Google Play: https://play.google.com/store/apps/details?id=com.andluck.yatt

## Repository layout

- `yout/` - Flutter mobile app.
- `web/` - Nuxt landing page for `youarethetranslator.com`.
- `art/` - Source logo, feature graphic, and generated image assets.
- `tools/gcptranslate/` - helper scripts for translating ARB files and
  generating lesson markdown.

## Local development

For the Flutter app:

```bash
cd yout
flutter pub get
flutter run -d chrome
```

For the website:

```bash
cd web
npm install
npm run dev
```

See [yout/README.md](yout/README.md), [web/README.md](web/README.md), and
[tools/gcptranslate/README.md](tools/gcptranslate/README.md) for more detailed
commands.

## Credits

- [Download buttons](<https://www.figma.com/file/h7BndySkjakJe41TdieRnL/AppStore-and-GooglePlay-(Community)?type=design&node-id=1-59&mode=design&t=bIuccxiOo9ZbpOSU-0>)
- Speaker icons created by Freepik - Flaticon -
  https://www.flaticon.com/free-icons/speaker
