import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yout/src/language_select/language_select_view.dart';
import 'package:yout/src/settings/globals.dart';
import 'package:yout/src/settings/languages.dart';
import 'package:yout/src/translate/translate_view.dart';
import 'package:yout/src/welcome/level_select_view.dart';
import 'package:yout/src/welcome/welcome_view.dart';

import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.globals,
  });

  final Globals globals;

  @override
  Widget build(BuildContext context) {
    // We define the icon size here because otherwise it's null
    // and defaults to 24. To be safe, and allow sizing other parts
    // of the layout based on icon size - we define it here.
    // See mentions of `Theme.of(context).iconTheme.size`.
    const iconThemeData = IconThemeData(size: 38);
    final theme = ThemeData(iconTheme: iconThemeData);
    final themeDark =
        ThemeData(brightness: Brightness.dark, iconTheme: iconThemeData);

    final translateRoute = TranslateView(globals: globals, level: 'a1');
    final selectNativeRoute = LanguageItemListView(
        globals: globals, mode: LanguageItemListView.modeNative);
    final selectLearnRoute = LanguageItemListView(
        globals: globals, mode: LanguageItemListView.modeLearn);
    final levelSelectView = LevelSelectView(globals: globals);

    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: globals.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // The "debug" banner showing up in screenshots got my app rejected
          // in the ios app store review.
          debugShowCheckedModeBanner: false,

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('ar', ''),
            Locale('de', ''),
            Locale('el', ''),
            Locale('fr', ''),
            Locale('he', ''),
            Locale('it', ''),
            Locale('ja', ''),
            Locale('ko', ''),
            Locale('pt', ''),
            Locale('ru', ''),
            Locale('es', ''),
            // Locale('he', 'IL'),
          ],

          locale: langToLocale(globals.settingsController.nativeLang),

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: theme,
          darkTheme: themeDark,
          themeMode: globals.settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            Widget defaultRoute = levelSelectView;
            if (globals.settingsController.nativeLang ==
                Language.invalidlanguage) {
              // Probably first time opening the app
              defaultRoute = selectNativeRoute;
            } else if (globals.settingsController.learningLang ==
                Language.invalidlanguage) {
              defaultRoute = WelcomeView();
              // Probably closed the app after choosing a native language
              // defaultRoute = selectLearnRoute;
            }
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: globals.settingsController);
                  case LevelSelectView.routeName:
                    return levelSelectView;
                  case TranslateView.routeName:
                    return translateRoute;
                  // case LanguageItemListView.routeName:
                  case LanguageItemListView.learnRoute:
                    return selectLearnRoute;
                  case LanguageItemListView.nativeRoute:
                    return selectNativeRoute;
                  case WelcomeView.routeName:
                    return WelcomeView();
                  case '/':
                  default:
                    return defaultRoute;
                  // return WelcomeView();
                }
              },
            );
          },
        );
      },
    );
  }
}

Locale? langToLocale(Language lang) {
  Locale? locale;
  if (lang == Language.invalidlanguage) {
    return null;
  }
  var xxMinusYy = languageToLocaleId[lang]!;
  var localeParts = xxMinusYy.split('-');
  locale = Locale.fromSubtags(
      languageCode: localeParts[0], countryCode: localeParts[1]);
  // debugPrint('langToLocale $locale');
  return locale;
}
