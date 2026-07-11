import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:alpha/models/license_model.dart';
import 'package:flutter/material.dart';

class LicenseController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;
  var isLicensed = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLocalLicense();
  }

  Future<String?> _getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Unique ID on Android
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // Unique ID on iOS
    }
    return null;
  }

  Future<DateTime> _getRealTime() async {
    try {
      final response = await http.get(Uri.parse('http://worldtimeapi.org/api/timezone/Etc/UTC')).timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return DateTime.parse(data['utc_datetime']);
      }
    } catch (e) {
      // Ignore if offline
    }
    return DateTime.now();
  }

  Future<void> checkLocalLicense() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedKey = prefs.getString('product_key');
    String? expiryString = prefs.getString('license_expiry');
    String? lastOpenedString = prefs.getString('last_opened_date');

    if (savedKey != null) {
      bool isValidLocally = true;
      DateTime nowLocal = DateTime.now();

      // Anti-tamper logic: if current time is older than last opened time
      if (lastOpenedString != null) {
        DateTime lastOpened = DateTime.parse(lastOpenedString);
        if (nowLocal.isBefore(lastOpened.subtract(Duration(minutes: 5)))) {
          isValidLocally = false;
        }
      }

      if (expiryString != null) {
        DateTime expiry = DateTime.parse(expiryString);
        if (nowLocal.isAfter(expiry)) {
          isValidLocally = false;
        }
      }

      if (isValidLocally) {
         prefs.setString('last_opened_date', nowLocal.toIso8601String());
         isLicensed.value = true;
         _verifyOnlineSilently(savedKey);
      } else {
         _revokeLocal();
      }

    } else {
      isLicensed.value = false;
    }
  }

  Future<void> _verifyOnlineSilently(String key) async {
    try {
      var query = await _firestore.collection('Licenses').where('key', isEqualTo: key).get();
      if (query.docs.isNotEmpty) {
        var doc = query.docs.first;
        var license = LicenseModel.fromMap(doc.data(), doc.id);
        
        if (license.isActive == false) {
          _revokeLocal();
          return;
        }

        if (license.expiryDate != null) {
          DateTime realTime = await _getRealTime();
          if (realTime.isAfter(license.expiryDate!.toDate())) {
            _revokeLocal();
            return;
          }
        }
      } else {
        _revokeLocal();
      }
    } catch (e) {}
  }

  void _revokeLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('product_key');
    await prefs.remove('license_expiry');
    isLicensed.value = false;
    Get.offAllNamed('/license');
  }

  Future<bool> activateLicense(String key) async {
    if (key.isEmpty) return false;
    isLoading.value = true;

    try {
      String? deviceId = await _getDeviceId();
      if (deviceId == null) {
        isLoading.value = false;
        Get.snackbar('خطأ', 'لم نتمكن من التعرف على جهازك', backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }

      var query = await _firestore.collection('Licenses').where('key', isEqualTo: key).get();

      if (query.docs.isEmpty) {
        isLoading.value = false;
        Get.snackbar('مفتاح غير صحيح', 'هذا المفتاح غير موجود في النظام', backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }

      var doc = query.docs.first;
      var license = LicenseModel.fromMap(doc.data(), doc.id);

      if (license.isActive == false) {
        isLoading.value = false;
        Get.snackbar('مفتاح معطل', 'تم تعطيل هذا المفتاح مسبقاً', backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }

      if (license.deviceId != null && license.deviceId != deviceId) {
        isLoading.value = false;
        Get.snackbar('مفتاح مستخدم', 'هذا المفتاح مستخدم على جهاز آخر ولا يمكن استخدامه هنا', backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }

      DateTime realTime = await _getRealTime();

      if (license.expiryDate != null && realTime.isAfter(license.expiryDate!.toDate())) {
         isLoading.value = false;
         Get.snackbar('مفتاح منتهي', 'انتهت صلاحية هذا المفتاح', backgroundColor: Colors.red, colorText: Colors.white);
         return false;
      }

      // Bind to this device
      await _firestore.collection('Licenses').doc(doc.id).update({
        'deviceId': deviceId,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('product_key', key);
      await prefs.setString('last_opened_date', DateTime.now().toIso8601String());
      if (license.expiryDate != null) {
         await prefs.setString('license_expiry', license.expiryDate!.toDate().toIso8601String());
      }
      
      isLicensed.value = true;
      isLoading.value = false;
      return true;

    } catch (e) {
      isLoading.value = false;
      Get.snackbar('خطأ', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }

  Future<String> generateLicense(String type, int? monthsDuration) async {
    var uuid = Uuid();
    String newKey = 'ALPHA-' + uuid.v4().substring(0, 13).toUpperCase();
    
    Timestamp? expiryDate;
    if (monthsDuration != null) {
      expiryDate = Timestamp.fromDate(DateTime.now().add(Duration(days: 30 * monthsDuration)));
    }

    LicenseModel newLicense = LicenseModel(
      key: newKey,
      isActive: true,
      deviceId: null,
      type: type,
      expiryDate: expiryDate,
    );

    await _firestore.collection('Licenses').add(newLicense.toMap());
    return newKey;
  }
}
