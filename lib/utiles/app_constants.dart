import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:alpha/models/language_model.dart';

class AppConstants {
  // ignore: constant_identifier_names
  static const APP_NAME = 'IDEALOOK';
  static const IS_LOGIN = 'USER_IS_LOGIN';
  static const USER_ID = 'USER_ID';
  static const isVerfied = 'isVerfied';
  static const USER_NAME = 'USER_NAME';
  static const SEEN = 'SEEN';
  static const IS_INTRO = 'IS_INTRO';
  static const languageEn = "en";
  static const orderid = "orderid";
  static const pass = "111";
  static const type = "عميل";
  static const countryCodeEn = "US";

  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';

  static const String HELP_PHONE = '+967775346074';
  static const String HELP_EMAIL = 'algomaieissa@gmail.com';

  static Future<String?>? getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  static List<String> gender = ['Active', 'NActive'];

  /// Languages
  static List<LanguageModel> languages = [
    // LanguageModel(
    //     imageUrl: 'assets/image/english.png',
    //     languageName: 'English',
    //     countryCode: 'US',
    //     languageCode: 'en'),
    LanguageModel(
        imageUrl: 'assets/image/arabic.png',
        languageName: 'عربى',
        countryCode: 'SA',
        languageCode: 'ar'),
  ];
}

class Resources {
  static String logo = 'assets/image/logo.jpg';
  static String logo_icon = 'assets/image/logo_icon.png';
}
