import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yout/src/language_select/language_item_list_view.dart';
import 'package:yout/src/settings/globals.dart';
import 'package:yout/src/translate/translate_view.dart';

import 'sample_feature/sample_item_details_view.dart';
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
    final translateRoute = TranslateView(globals: globals);
    final selectNativeRoute = LanguageItemListView(
        globals: globals, mode: LanguageItemListView.modeNative);
    final selectLearnRoute = LanguageItemListView(
        globals: globals, mode: LanguageItemListView.modeLearn);

    Widget defaultRoute = translateRoute;
    if (globals.nativeLang == Language.invalidlanguage) {
      defaultRoute = selectNativeRoute;
    } else if (globals.learningLang == Language.invalidlanguage) {
      defaultRoute = selectLearnRoute;
    }
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
            Locale('en', ''), // English, no country code
          ],

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
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: globals.settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: globals.settingsController);
                  case SampleItemDetailsView.routeName:
                    return const SampleItemDetailsView();
                  case TranslateView.routeName:
                    return translateRoute;
                  // case LanguageItemListView.routeName:
                  case '/${LanguageItemListView.modeLearn}':
                    return selectLearnRoute;
                  case '/${LanguageItemListView.modeNative}':
                    return selectNativeRoute;
                  case '/':
                  default:
                    return defaultRoute;
                }
              },
            );
          },
        );
      },
    );
  }
}
