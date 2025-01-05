import 'dart:convert';

import 'package:alpha/controller/auth_controller.dart';
import 'package:alpha/controller/localization_controller.dart';
import 'package:alpha/models/language_model.dart';
import 'package:alpha/utiles/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Repository
  Get.lazyPut(() => AuthController());
  Get.lazyPut(() => LocalizationController());
  // Retrieving localized data
  Map<String, Map<String, String>> _languages = Map();
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> _mappedJson = json.decode(jsonStringValues);
    Map<String, String> _json = Map();
    _mappedJson.forEach((key, value) {
      _json[key] = value.toString();
    });
    _languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        _json;
  }
  return _languages;
}
