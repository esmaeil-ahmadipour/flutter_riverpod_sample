// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> it_IT = {
  "app_title": " IT App "
};
static const Map<String,dynamic> de_DE = {
  "app_title": " DE App "
};
static const Map<String,dynamic> es_ES = {
  "app_title": " ES App "
};
static const Map<String,dynamic> fa_IR = {
  "app_title": " FA App "
};
static const Map<String,dynamic> fr_FR = {
  "app_title": " FR App "
};
static const Map<String,dynamic> en_US = {
  "app_title": " EN App "
};
static const Map<String, Map<String,dynamic>> mapLocales = {"it_IT": it_IT, "de_DE": de_DE, "es_ES": es_ES, "fa_IR": fa_IR, "fr_FR": fr_FR, "en_US": en_US};
}
