import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_sample/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    String? languageCode;
    String? countryCode;
    final prefs = await SharedPreferences.getInstance();

    for (var i = 0; i < languages.length; ++i) {
      var language = languages[i];
      if (prefs.getString('languageCode') == language.languageCode) {
        languageCode = prefs.getString('languageCode')!;
        countryCode = prefs.getString('countryCode')!;
        break;
      }
    }
    if (languageCode == null || countryCode == null) {
      languageCode = prefs.getString('languageCode') ?? languages[0].languageCode;
      countryCode = prefs.getString('countryCode') ?? languages[0].countryCode;
    }

    state = Locale(languageCode, countryCode);
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    await prefs.setString('countryCode', locale.countryCode!);
    state = locale;
  }
}