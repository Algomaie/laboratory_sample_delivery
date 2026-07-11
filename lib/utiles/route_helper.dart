import 'package:alpha/views/auth/sign_in_screen.dart';
import 'package:alpha/views/auth/sign_up_screen.dart';
import 'package:alpha/views/auth/license_screen.dart';
import 'package:alpha/views/dashboard/dashboard_screen.dart';
import 'package:alpha/views/home/home_screen.dart';
import 'package:alpha/views/onboarding/onboaring_screen.dart';
import 'package:alpha/views/profile/help_support_screen.dart';
import 'package:alpha/views/profile/settings_screen.dart';
import 'package:alpha/views/profile/settings_screenadmin.dart';
import 'package:alpha/views/profile/update_user_info_screen.dart';
import 'package:alpha/views/solid/add_customer_screen.dart';
import 'package:alpha/views/solid/add_deliver_screen.dart';
import 'package:alpha/views/solid/addsimple.dart';
import 'package:alpha/views/solid/customersdata.dart';
import 'package:alpha/views/solid/deliversdata.dart';
import 'package:alpha/views/solid/showcustomerorder.dart';
import 'package:alpha/views/solid/show_customers_screen.dart';
import 'package:alpha/views/solid/showdelivers.dart';
import 'package:alpha/views/solid/showordrs.dart';
import 'package:alpha/views/solid/showsimples.dart';
import 'package:alpha/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String language = '/language';
  static const String settings = '/settings';
  static const String addtran = '/addtran';
  static const String dreviers = '/dreviers';
  static const String addsimpl = '/addsimple';
  static const String showsimpl = '/showsimple';
  static const String Homescreen = '/Homescreen';
  static const String adminhome = '/adminhomepage';
  static const String showCusttomer = '/showCusttomer';
  static const String addCusttmer = '/addCusttmer';
  static const String showorder = '/showorder';
  static const String showdeldata = '/showdeliversdata';
  static const String showCustdata = '/showCustdata';

  static const String editProfile = '/edit-profile';
  static const String onBoarding = '/on-boarding';
  static const String login = '/sign-in';
  static const String register = '/sign-up';
  static const String license = '/license';
  static const String changePassword = '/change-password';
  static const String helpSupport = '/help-support';
  static const String showuser = '/showuserpage';
  static const String OrdersScree = '/OrdersScreen';

  static String getInitialRoute({String? username}) =>
      '$initial?username=$username';

  static String showuserslRoute({String? username}) =>
      '$showuser?username=$username';
  static String getLanguageRoute(String page) => '$language?page=$page';

  static String getSettingsRoute() => settings;
  static String getshowdeldatasRoute() => showdeldata;
  static String getshowCustdatasRoute() => showCustdata;

  static String getSplashRoute() => splash;

  static String getEditProfileRoute() => '$editProfile';
  static String getChangePasswordRoute() => '$changePassword';
  static String getHelpSupportRoute() => '$helpSupport';
  static String getaddtran() => '$addtran';
  static String getadminhometRoute() => '$adminhome';
  static String getdreviers() => '$dreviers';
  static String getaddsimpleRoute() => addsimpl;
  static String getshowsimpleRoute() => showsimpl;
  static String getaddCusttmerRoute() => addCusttmer;
  static String getOrdersScreenRoute() => OrdersScree;
  static String getCustomersRoute() => showCusttomer;
  static String getAllOrdersRoute() => showorder;

  static String getOnBoardingRoute() => '$onBoarding';
  static String getLoginRoute() => '$login';
  static String getLicenseRoute() => '$license';
  static String getRegisterRoute() => '$register';
  static String getHomeScreenRoute() => '$Homescreen';

  static List<GetPage> routes = [
    GetPage(
        name: initial,
        page: () => getRoute(DashboardScreen(
              pageIndex: 0,
              username: Get.parameters['username'],
            ))),
    GetPage(name: showuser, page: () => getRoute(showCusttomers())),
    GetPage(name: addCusttmer, page: () => AddCustomerScreen()),
    GetPage(name: showdeldata, page: () => showdeliversdata()),
    GetPage(name: showCustdata, page: () => showcustomersdata()),
    GetPage(
        name: addtran,
        page: () {
          return AddDeliverScreen();
        }),
    GetPage(name: addsimpl, page: () => addsimple()),
    GetPage(
        name: adminhome,
        page: () {
          return SettingsScreenadmin();
        }),
    GetPage(
        name: splash,
        page: () {
          return SplashScreen();
        }),
    GetPage(name: dreviers, page: () => HomePage()),
    GetPage(name: showsimpl, page: () => simpledata()),
    GetPage(name: onBoarding, page: () => OnBoardingScreen()),
    GetPage(name: OrdersScree, page: () => OrdersScreen()),
    GetPage(name: Homescreen, page: () => HomeScreen()),
    GetPage(
      name: settings,
      page: () => SettingsScreen(),
    ),
    // GetPage(
    //   name: changePassword,
    //   page: () => ChangePasswordScreen(),
    // ),
    GetPage(
      name: showCusttomer,
      page: () => showCusttomers(),
    ),
    GetPage(
      name: helpSupport,
      page: () => HelpSupportScreen(),
    ),
    GetPage(name: editProfile, page: () => UpdateUserInfoScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: register, page: () => RegisterScreen()),
    GetPage(name: license, page: () => LicenseActivationScreen()),
    GetPage(name: showorder, page: () => Orders()),
  ];

  static getRoute(Widget navigateTo) {
    return navigateTo;
  }
}
