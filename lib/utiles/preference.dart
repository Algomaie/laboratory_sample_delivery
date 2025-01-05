import 'dart:async';
import 'dart:convert';

import 'package:get_storage/get_storage.dart';

class Preference {
  static const String authorization = "AUTHORIZATION";

  static const String selectedLanguage = "LANGUAGE";
  static const String selectedCountryCode = "SELECTED_COUNTRY_CODE";

  /// ------------------ SINGLETON -----------------------
  static final Preference _preference = Preference._internal();

  factory Preference() {
    return _preference;
  }

  Preference._internal();

  static Preference get shared => _preference;

  static GetStorage? _pref;

  Future<GetStorage?> instance() async {
    if (_pref != null) return _pref;
    await GetStorage.init().then((value) {
      if (value) {
        _pref = GetStorage();
      }
    }).catchError((onError) {
      _pref = null;
    });
    return _pref;
  }

  String? getString(String key) {
    return _pref!.read(key);
  }

  Future<void> setString(String key, String value) {
    return _pref!.write(key, value);
  }

  int? getInt(String key) {
    return _pref!.read(key);
  }

  Future<void> setInt(String key, int value) {
    return _pref!.write(key, value);
  }

  bool? getBool(String key) {
    return _pref!.read(key);
  }

  Future<void> setBool(String key, bool value) {
    return _pref!.write(key, value);
  }

  double? getDouble(String key) {
    return _pref!.read(key);
  }

  Future<void> setDouble(String key, double value) {
    return _pref!.write(key, value);
  }

  List<String>? getStringList(String key) {
    var listAsDynamic = _pref!.read(key);

    if (listAsDynamic is String) {
      // Handle case when value is a string
      List<String> list = listAsDynamic.isEmpty ? [] : [listAsDynamic];
      return list;
    } else if (listAsDynamic is List<dynamic>) {
      // Handle case when value is a list
      List<String> list = listAsDynamic.map((item) => item.toString()).toList();
      return list;
    }

    return null; // Handle any other cases
  }

  Future<void> setStringList(String key, List<String> value) {
    return _pref!.write(key, value);
  }

  Future<void> remove(key, [multi = false]) async {
    GetStorage? pref = await instance();
    if (multi) {
      key.forEach((f) async {
        return await pref!.remove(f);
      });
    } else {
      return await pref!.remove(key);
    }
  }

  static Future<bool> clear() async {
    _pref!.getKeys().forEach((key) async {
      await _pref!.remove(key);
    });

    return Future.value(true);
  }

  static Future<bool> clearLogout() async {
    return Future.value(true);
  }
}
