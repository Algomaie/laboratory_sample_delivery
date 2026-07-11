import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alpha/controller/license_controller.dart';
import 'package:alpha/utiles/route_helper.dart';
import 'package:alpha/widgets/custom_button.dart';
import 'package:alpha/widgets/dynamic_logo.dart';
import 'package:alpha/utiles/preference.dart';
import 'package:alpha/utiles/app_constants.dart';
import 'package:alpha/views/solid/license_manager_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class LicenseActivationScreen extends StatefulWidget {
  @override
  _LicenseActivationScreenState createState() => _LicenseActivationScreenState();
}

class _LicenseActivationScreenState extends State<LicenseActivationScreen> {
  final LicenseController licenseController = Get.find<LicenseController>();
  final TextEditingController keyController = TextEditingController();

  void _activate() async {
    if (keyController.text.trim().isEmpty) {
      Get.snackbar('تنبيه', 'يرجى إدخال مفتاح التفعيل', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    bool success = await licenseController.activateLicense(keyController.text.trim());
    if (success) {
      Preference sharePref = Preference.shared;
      final isLogin = sharePref.getString(AppConstants.IS_LOGIN) ?? "0";
      final isIntro = sharePref.getString(AppConstants.IS_INTRO) ?? "0";

      if (isIntro == '1') {
        if (isLogin == "1") {
          Get.offAllNamed(RouteHelper.getInitialRoute());
        } else {
          Get.offAllNamed(RouteHelper.getLoginRoute());
        }
      } else {
        Get.offAllNamed(RouteHelper.getOnBoardingRoute());
        sharePref.setString(AppConstants.IS_INTRO, '1');
      }
    }
  }

  void _showSecretAdminLogin() {
    TextEditingController _passController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("المدير: إدارة الرخص"),
          content: TextField(
            controller: _passController,
            obscureText: true,
            decoration: InputDecoration(hintText: "كلمة السر السرية"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_passController.text == "admin123") {
                  Navigator.pop(context);
                  Get.to(() => LicenseManagerScreen());
                } else {
                  Navigator.pop(context);
                  Get.snackbar('خطأ', 'كلمة السر غير صحيحة', backgroundColor: Colors.red, colorText: Colors.white);
                }
              },
              child: Text("دخول"),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onLongPress: _showSecretAdminLogin,
                  child: DynamicLogo(width: 150, height: 150),
                ),
                SizedBox(height: 30),
                Text(
                  "تفعيل التطبيق",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                ),
                SizedBox(height: 10),
                Text(
                  "هذا التطبيق محمي برخصة تجارية.\nيرجى إدخال مفتاح المنتج الخاص بك للمتابعة.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: keyController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "ABCD-1234-EFGH-5678",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Obx(() => licenseController.isLoading.value
                    ? CircularProgressIndicator()
                    : CustomButton(
                        buttonText: "تفعيل",
                        onPressed: _activate,
                      )),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    final Uri url = Uri.parse('https://wa.me/967775346074');
                    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                      Get.snackbar('خطأ', 'لا يمكن فتح الرابط', backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  },
                  icon: Icon(Icons.contact_support, color: Colors.green),
                  label: Text(
                    "للحصول على مفتاح التفعيل تواصل معنا\n+967 775 346 074",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
