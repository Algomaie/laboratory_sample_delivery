import 'dart:convert';

import 'package:alpha/controller/auth_controller.dart';
import 'package:alpha/controller/localization_controller.dart';
import 'package:alpha/models/language_model.dart';
import 'package:alpha/utiles/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alpha/helper/auth_service.dart';

import 'package:alpha/data/repository/user_repository.dart';
import 'package:alpha/data/repository/customer_repository.dart';
import 'package:alpha/data/repository/deliver_repository.dart';
import 'package:alpha/data/repository/order_repository.dart';
import 'package:alpha/controller/profile_controller.dart';
import 'package:alpha/controller/user_controller.dart';

Future<Map<String, Map<String, String>>> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.put(AuthService(), permanent: true);

  // Repository
  Get.lazyPut(() => UserRepository());
  Get.lazyPut(() => CustomerRepository());
  Get.lazyPut(() => DeliverRepository());
  Get.lazyPut(() => OrderRepository());

  // Controllers
  Get.lazyPut(() => AuthController());
  Get.lazyPut(() => ProfileController());
  Get.lazyPut(() => UserController());
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
