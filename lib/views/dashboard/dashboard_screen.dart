import 'dart:async';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alpha/utiles/app_constants.dart';
import 'package:alpha/utiles/preference.dart';
import 'package:alpha/utiles/route_helper.dart';
import 'package:alpha/views/profile/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String? username;
  final int pageIndex;
  DashboardScreen({required this.pageIndex, this.username});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _pageIndex = 0;
  List<Widget> _screens = [];
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = false; // No need for GetPlatform check, always set to false
  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;
  Preference sharePref = Preference.shared;
  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      HomeScreen(
        username: widget.username,
      ),
      SettingsScreen(),
    ];
    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Interval(0.2, 1.0, curve: Curves.fastOutSlowIn),
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: Interval(0.2, 1.0, curve: Curves.fastOutSlowIn),
    );

    fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
    borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
      borderRadiusCurve,
    );

    _hideBottomBarAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    Future.delayed(
      Duration(seconds: 1),
      () => _fabAnimationController.forward(),
    );
    Future.delayed(
      Duration(seconds: 1),
      () => _borderRadiusAnimationController.forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          if (_canExit) {
            return true;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'اضغط مرتين للخروج',
                style: TextStyle(color: Colors.white),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(8.0), // Adjust padding as needed
            ));
            _canExit = true;
            Future.delayed(Duration(seconds: 2), () {
              _canExit = false;
            });
            return false;
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        floatingActionButton: Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 8.0),
          child: AvatarGlow(
            endRadius: 30,
            glowColor: Theme.of(context).primaryColor,
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(50.0), // Adjust the value as needed
              ),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                print(
                    "----------------${sharePref.getString(AppConstants.type)}---------------");
                if (sharePref.getString(AppConstants.type) != "عميل" &&
                    sharePref.getString(AppConstants.type) != "موصل") {
                  _borderRadiusAnimationController.reset();
                  Get.toNamed(RouteHelper.getadminhometRoute());
                  _borderRadiusAnimationController.forward();
                } else {
                  _borderRadiusAnimationController.reset();
                  //  Get.toNamed(RouteHelper.getHomeScreenRoute());
                  _borderRadiusAnimationController.forward();
                }
              },
              child: Icon(
                Icons.girl,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: bottomBarIconsList.length,
          tabBuilder: (int index, bool isActive) {
            final color =
                isActive ? Colors.white : Color.fromARGB(255, 205, 205, 205);
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  bottomBarIconsList[index],
                  size: 24,
                  color: color,
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: AutoSizeText(
                    bottomBarTitlesList[index].tr,
                    maxLines: 1,
                    style: TextStyle(color: color),
                    // group: autoSizeGroup,
                  ),
                )
              ],
            );
          },
          activeIndex: _pageIndex,
          onTap: (int index) => _setPage(index),
          backgroundColor: Theme.of(context).primaryColor,
          splashColor: Colors.red,
          notchAndCornersAnimation: borderRadiusAnimation,
          splashSpeedInMilliseconds: 300,
          notchSmoothness: NotchSmoothness.defaultEdge,
          gapLocation: GapLocation.center,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          hideAnimationController: _hideBottomBarAnimationController,
          shadow: BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 12,
            spreadRadius: 0.5,
            color: Theme.of(context).primaryColor,
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  List<IconData> bottomBarIconsList = [
    Icons.home_filled,
    Icons.person,
  ];

  List<String> bottomBarTitlesList = [
    'الرئيسية'.tr,
    'الإعدادات'.tr,
  ];
}
