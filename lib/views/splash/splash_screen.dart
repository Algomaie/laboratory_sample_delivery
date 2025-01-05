import 'dart:async';

import 'package:hexcolor/hexcolor.dart';
import 'package:alpha/utiles/app_constants.dart';
import 'package:alpha/utiles/preference.dart';
import 'package:alpha/utiles/route_helper.dart';
import 'package:alpha/widgets/myimage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  String? seen;
  int? index;
  Preference sharePref = Preference.shared;
  late Animation<double> animation;
  late AnimationController controller;

  @override
  initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    initSetting();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: HexColor("#193D4D"),
        ),
        child: ScaleTransition(
            scale: animation,
            child: Center(
              child: MyImage(
                  width: 300,
                  height: 300,
                  fit: BoxFit.fill,
                  imagePath: Resources.logo),
            )),
      ),
    );
  }

  initSetting() async {
    final seen = sharePref.getString(AppConstants.SEEN) ?? "0";
    final isLogin = sharePref.getString(AppConstants.IS_LOGIN) ?? "0";
    final isIntro = sharePref.getString(AppConstants.IS_INTRO) ?? "0";
    final delayDuration = Duration(seconds: 3);

    Future<void> navigateToRoute(String routeName) async {
      Timer(delayDuration, () => Get.offAndToNamed(routeName));
    }

    if (isIntro == '1') {
      if (seen == "1") {
        final initialRoute = isLogin == "1"
            ? RouteHelper.getInitialRoute()
            : RouteHelper.getLoginRoute();

        await navigateToRoute(initialRoute);
      } else {
        await navigateToRoute(RouteHelper.getOnBoardingRoute());
      }
    } else {
      await navigateToRoute(RouteHelper.getOnBoardingRoute());
      disableIntro();
    }
  }

  void disableIntro() {
    sharePref.setString(AppConstants.IS_INTRO, '1');
  }
}
