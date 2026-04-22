import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('he'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru')
  ];

  /// No description provided for @adviceHelp.
  ///
  /// In en, this message translates to:
  /// **'Tap the \'Help\' button if you don\'t know the answer'**
  String get adviceHelp;

  /// No description provided for @adviceNext.
  ///
  /// In en, this message translates to:
  /// **'Tap the \'Next\' button to skip this one'**
  String get adviceNext;

  /// No description provided for @adviceRecord.
  ///
  /// In en, this message translates to:
  /// **'Tap the \'Speak\' button then say your answer out loud'**
  String get adviceRecord;

  /// No description provided for @adviceReport.
  ///
  /// In en, this message translates to:
  /// **'Tap the \'Report\' button if you found a bug or a missing translation'**
  String get adviceReport;

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'You Are The Translator'**
  String get appTitle;

  /// No description provided for @cool.
  ///
  /// In en, this message translates to:
  /// **'Cool'**
  String get cool;

  /// No description provided for @earnPoints.
  ///
  /// In en, this message translates to:
  /// **'Earn points and track your progress'**
  String get earnPoints;

  /// No description provided for @gotit.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotit;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @helpImproveThisPlease.
  ///
  /// In en, this message translates to:
  /// **'Help improve this level by reporting if you find a bug or a missing translation'**
  String get helpImproveThisPlease;

  /// No description provided for @inDevelopment.
  ///
  /// In en, this message translates to:
  /// **'In development'**
  String get inDevelopment;

  /// No description provided for @learnPhrases.
  ///
  /// In en, this message translates to:
  /// **'Learn phrases by reciting them aloud'**
  String get learnPhrases;

  /// No description provided for @moreLevels.
  ///
  /// In en, this message translates to:
  /// **'More levels, phrases, reminders, points, and streaks'**
  String get moreLevels;

  /// No description provided for @learningLanguage.
  ///
  /// In en, this message translates to:
  /// **'Learning language'**
  String get learningLanguage;

  /// No description provided for @nativeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Native language'**
  String get nativeLanguage;

  /// No description provided for @letsStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start!'**
  String get letsStart;

  /// No description provided for @modeDescriptionLean.
  ///
  /// In en, this message translates to:
  /// **'Learn - listen and repeat'**
  String get modeDescriptionLean;

  /// No description provided for @modeDescriptionPlay.
  ///
  /// In en, this message translates to:
  /// **'Play - listen and translate'**
  String get modeDescriptionPlay;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @selectLevel.
  ///
  /// In en, this message translates to:
  /// **'Select a level'**
  String get selectLevel;

  /// No description provided for @selectNativeLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a language that you understand well. You will be translating to and from this language.'**
  String get selectNativeLanguageSubtitle;

  /// No description provided for @selectLearnLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the language that you want to learn. You will be translating to and from this language.'**
  String get selectLearnLanguageSubtitle;

  /// No description provided for @speak.
  ///
  /// In en, this message translates to:
  /// **'Speak'**
  String get speak;

  /// No description provided for @translateA1.
  ///
  /// In en, this message translates to:
  /// **'A1 - Translate simple words'**
  String get translateA1;

  /// No description provided for @translateA1B.
  ///
  /// In en, this message translates to:
  /// **'A1B - Translate travel phrases'**
  String get translateA1B;

  /// No description provided for @translateA2.
  ///
  /// In en, this message translates to:
  /// **'A2 - Translate simple sentences'**
  String get translateA2;

  /// No description provided for @translateB1.
  ///
  /// In en, this message translates to:
  /// **'B1 - Translate tricky sentences'**
  String get translateB1;

  /// No description provided for @welcomeHandsFree.
  ///
  /// In en, this message translates to:
  /// **'Hands-free language learning...'**
  String get welcomeHandsFree;

  /// No description provided for @welcomeListen.
  ///
  /// In en, this message translates to:
  /// **'Listen to a phrase in your native language'**
  String get welcomeListen;

  /// No description provided for @welcomeSay.
  ///
  /// In en, this message translates to:
  /// **'Then say it out loud in the language you\'re learning'**
  String get welcomeSay;

  /// No description provided for @welcomeYouAreTheTranslator.
  ///
  /// In en, this message translates to:
  /// **'You are the translator'**
  String get welcomeYouAreTheTranslator;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'el',
        'en',
        'es',
        'fr',
        'he',
        'it',
        'ja',
        'ko',
        'pt',
        'ru'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
