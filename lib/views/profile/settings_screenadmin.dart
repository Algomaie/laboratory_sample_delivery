import 'package:alpha/controller/auth_controller.dart';
import 'package:alpha/utiles/app_constants.dart';
import 'package:alpha/utiles/preference.dart';
import 'package:alpha/utiles/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alpha/views/solid/showallusers.dart';
import 'package:alpha/views/solid/admin_settings_screen.dart';
import 'package:alpha/views/solid/license_manager_screen.dart';

class SettingsScreenadmin extends StatelessWidget {
  Preference sharePref = Preference.shared;
  SettingsScreenadmin({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F8FA),
      appBar: AppBar(
        title: Text(
          "الاعدادات",
          style: GoogleFonts.cairo(
            textStyle: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        elevation: 0.3,
        backgroundColor: Colors.white,
      ),
      body: GetBuilder<AuthController>(builder: (authController) {
        return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
                padding: const EdgeInsetsDirectional.only(
                  start: 15.0,
                  end: 15.0,
                  top: 20.0,
                  bottom: 20.0,
                ),
                child: Column(
                  children: [
                    _itemList(context,
                        icon: Icons.person,
                        title: "الملف الشخصي".tr, onPressed: () {
                      Get.toNamed(RouteHelper.getEditProfileRoute());
                    }),
                    const SizedBox(
                      height: 7,
                    ),
                    _itemList(context,
                        icon: Icons.settings,
                        title: "إعدادات هوية المختبر", onPressed: () {
                      Get.to(() => AdminSettingsScreen());
                    }),
                    const SizedBox(
                      height: 7,
                    ),
                    _itemList(context,
                        icon: Icons.key,
                        title: "إدارة رخص التطبيق", onPressed: () {
                      Get.to(() => LicenseManagerScreen());
                    }),
                    const SizedBox(
                      height: 7,
                    ),
                    _itemList(context,
                        icon: Icons.person,
                        title: "إضافة موصل".tr, onPressed: () {
                      Get.toNamed(RouteHelper.getaddtran());
                    }),
                    const SizedBox(
                      height: 7,
                    ),
                    _itemList(context,
                        icon: Icons.person,
                        title: "عرض المُوصلين".tr, onPressed: () {
                      Get.toNamed(RouteHelper.getshowdeldatasRoute());
                    }),
                    const SizedBox(
                      height: 7,
                    ),
                    _itemList(context, icon: Icons.lock, title: "إضافة عميل".tr,
                        onPressed: () {
                      Get.toNamed(RouteHelper.getaddCusttmerRoute());
                    }),
                    const SizedBox(
                      height: 7,
                    ),
                    _itemList(context,
                        icon: Icons.lock,
                        title: "عرض طلبات العملاء".tr, onPressed: () {
                      Get.toNamed(RouteHelper.getAllOrdersRoute());
                    }),
                    const SizedBox(
                      height: 7,
                    ),
                    _itemList(context,
                        icon: Icons.lock,
                        title: "تعديل الرسائل".tr, onPressed: () {
                      Get.toNamed(RouteHelper.getaddsimpleRoute());
                    }),
                    const SizedBox(
                      height: 7,
                    ),
                    _itemList(context,
                        icon: Icons.help,
                        title: "عرض العملاء".tr, onPressed: () {
                      Get.toNamed(RouteHelper.getshowCustdatasRoute());
                    }),
                    const SizedBox(
                      height: 7,
                    ),
                    // _itemList(context,
                    //     icon: Icons.help,
                    //     title: "عرض المستخدمين".tr, onPressed: () {
                    //   Get.offAndToNamed(showusers());
                    // }),
                    // const SizedBox(
                    //   height: 7,
                    // ),
                    // _itemList(context,
                    //     icon: Icons.logout,
                    //     title: "عرض تقارير ".tr, onPressed: () {
                    //   authController.signOut(context);
                    // }),
                    const SizedBox(
                      height: 7,
                    ),
                    _itemList(context,
                        icon: Icons.lock,
                        title: "تغير كلمة السر".tr, onPressed: () {
                      Get.toNamed(RouteHelper.getChangePasswordRoute());
                    }),
                    const SizedBox(
                      height: 7,
                    ),
                    _itemList(context, icon: Icons.help, title: "مساعدة".tr,
                        onPressed: () {
                      Get.toNamed(RouteHelper.getHelpSupportRoute());
                    }),
                    const SizedBox(
                      height: 7,
                    ),
                    _itemList(context, icon: Icons.logout, title: "خروج".tr,
                        onPressed: () {
                      authController.signOut(context);
                    }),
                  ],
                )));
      }),
    );
  }

  Widget _itemList(context, {icon, title, onPressed}) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey,
              size: 20,
            ),
            SizedBox(
              width: 14,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
