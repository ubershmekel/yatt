enum Language {
  eng,
  ara,
  deu,
  ell,
  fra,
  heb,
  ita,
  jpn,
  kor,
  por,
  rus,
  spa,
  invalidlanguage,
}

final stringToLangMap = Language.values.asNameMap();

// Note on Android default emulator,
// ar-EG and he-IL are not available :/
Map<Language, String> languageToLocaleId = {
  Language.eng: 'en-US',
  Language.ara: 'ar-EG',
  Language.deu: 'de-DE',
  Language.ell: 'el-GR',
  Language.fra: 'fr-FR',
  Language.heb: 'he-IL',
  Language.ita: 'it-IT',
  Language.jpn: 'ja-JP',
  Language.kor: 'ko-KR',
  Language.por: 'pt-BR',
  Language.rus: 'ru-RU',
  Language.spa: 'es-ES',
};

class LanguageInfo {
  final String name;
  final String localeId;
  final String code3;

  LanguageInfo({
    required this.name,
    required this.localeId,
    required this.code3,
  });

  flagAssetPath() {
    return 'assets/images/language_flags/$code3.png';
  }
}

Map<Language, LanguageInfo> languageToInfo = {
  Language.eng: LanguageInfo(name: 'English', localeId: 'en-US', code3: 'eng'),
  Language.ara: LanguageInfo(name: 'Arabic', localeId: 'ar-EG', code3: 'ara'),
  Language.deu: LanguageInfo(name: 'German', localeId: 'de-DE', code3: 'deu'),
  Language.ell: LanguageInfo(name: 'Greek', localeId: 'el-GR', code3: 'ell'),
  Language.fra: LanguageInfo(name: 'French', localeId: 'fr-FR', code3: 'fra'),
  Language.heb: LanguageInfo(name: 'Hebrew', localeId: 'he-IL', code3: 'heb'),
  Language.ita: LanguageInfo(name: 'Italian', localeId: 'it-IT', code3: 'ita'),
  Language.jpn: LanguageInfo(name: 'Japanese', localeId: 'ja-JP', code3: 'jpn'),
  Language.kor: LanguageInfo(name: 'Korean', localeId: 'ko-KR', code3: 'kor'),
  Language.por:
      LanguageInfo(name: 'Portuguese', localeId: 'pt-BR', code3: 'por'),
  Language.rus: LanguageInfo(name: 'Russian', localeId: 'ru-RU', code3: 'rus'),
  Language.spa: LanguageInfo(name: 'Spanish', localeId: 'es-ES', code3: 'spa'),
};
