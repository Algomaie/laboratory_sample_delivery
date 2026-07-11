// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:alpha/controller/localization_controller.dart';
import 'package:alpha/utiles/app_constants.dart';
import 'package:alpha/utiles/messages.dart';
import 'package:alpha/utiles/preference.dart';
import 'package:alpha/utiles/route_helper.dart';
import 'package:alpha/utiles/theme_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'helper/get_di.dart' as di;
import 'package:alpha/helper/migrate_orders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alpha/controller/settings_controller.dart';
import 'package:alpha/controller/license_controller.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // name
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);
// plugin initialization
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    String? payload = message.data['order_id'];
    flutterLocalNotificationsPlugin.cancel(0).then(
      (_) {
        return flutterLocalNotificationsPlugin.show(
          0,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              color: Colors.red,
              importance: channel.importance,
              priority: Priority.high,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: payload,
        );
      },
    );
  }
}



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Preference().instance();
  await Firebase.initializeApp();
  
  // تفعيل التخزين المحلي (Offline Persistence) 
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);

  // Request notification permissions for Android 13+ and iOS
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // تشغيل سكربت الترقية للطلبات (يعمل لمرة واحدة فقط للطلبات القديمة)
  MigrateOrders.runMigration();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // initializing the plugin
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  // foreground handler
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  Map<String, Map<String, String>> languages = await di.init();

  Get.put(SettingsController(), permanent: true);
  Get.put(LicenseController(), permanent: true);

  runApp(MyApp(
    languages: languages,
  ));
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>> languages;
  MyApp({super.key, required this.languages});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initLocalNotifications();
    _setupFCMListeners();
    _handleInitialMessage();
  }

  void _initLocalNotifications() {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);

    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response.payload);
      },
    );
  }

  void _setupFCMListeners() {
    // Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        String? payload = message.data['order_id'];
        flutterLocalNotificationsPlugin.cancel(0).then((_) {
          return flutterLocalNotificationsPlugin.show(
            0,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.red,
                importance: channel.importance,
                priority: Priority.high,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ),
            payload: payload,
          );
        });
      }
    });

    // Background notification tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateToOrder(message.data);
    });
  }

  Future<void> _handleInitialMessage() async {
    // App was terminated and opened by tapping notification
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      // Small delay to let the app finish initializing
      Future.delayed(Duration(seconds: 2), () {
        _navigateToOrder(initialMessage.data);
      });
    }
  }

  void _handleNotificationTap(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      _navigateToOrder({'order_id': payload});
    }
  }

  void _navigateToOrder(Map<String, dynamic> data) {
    String? orderId = data['order_id'];
    if (orderId != null && orderId.isNotEmpty) {
      Get.toNamed(RouteHelper.getAllOrdersRoute());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(builder: (localizeController) {
      return GetMaterialApp(
        title: AppConstants.APP_NAME,
        debugShowCheckedModeBanner: false,
        navigatorKey: Get.key,
        locale: localizeController.locale,
        translations: Messages(languages: widget.languages),
        fallbackLocale: Locale(AppConstants.languages[0].languageCode!,
            AppConstants.languages[0].countryCode),
        initialRoute: RouteHelper.getSplashRoute(),
        getPages: RouteHelper.routes,
        defaultTransition: Transition.topLevel,
        theme: ThemeModel().lightMode,
        transitionDuration: const Duration(milliseconds: 500),
      );
    });
  }
}
