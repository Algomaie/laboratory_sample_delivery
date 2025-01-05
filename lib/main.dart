// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
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
import 'package:rxdart/rxdart.dart';
import 'helper/get_di.dart' as di;
import 'utiles/loacal_notefaction.dart';
import 'package:http/http.dart' as http;

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

  debugPrint('A bg message just showed up : ${message.messageId}');
  RemoteNotification notification = message.notification!;
  AndroidNotification android = message.notification!.android!;
  if (notification != null && android != null) {
    debugPrint(notification.hashCode.toString());
    flutterLocalNotificationsPlugin.cancel(0).then(
      (_) {
        debugPrint('cancelled');
        return flutterLocalNotificationsPlugin.show(
          // notification.hashCode,
          0,
          notification.title! + ' from bg',
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
        );
      },
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Preference().instance();
  await Firebase.initializeApp();
  // HttpOverrides.global = new MyHttpOverrides();  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
// used to pass messages from event handler to the UI
  Map<String, Map<String, String>> _languages = await di.init();
  runApp(MyApp(
    languages: _languages,
  ));
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>> languages;
  MyApp({super.key, required this.languages});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.

  void sendPushMessage(String token, String body, String title) async {
    try {
      print("---------------------------------------------");
      FirebaseMessaging.instance.getToken().then((token) async {
        print("---------------------$token------------------------");
      });
      var data = {
        'to': token,
        'priority': 'high',
        'notification': {'title': 'Asify', 'body': 'Subscribe to my channel'}
      };

      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAET2Srss:APA91bF7c_q7B1gen7ff3dqh3jkQrBTVwsUNfBOH3TURnceM1mBJL-bziAhmWEY-aQDVusSBvbQwg3C45HoCE-Tt3Dv3hWfzVvfP_78Nz9UNwsz8XSOQ9L-bYBReOw8tRSx2cwXZyW96',
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': "apointment Confirme",
            'status': 'done',
            'body': body,
            'title': title
          },
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'to': token
        }),
      );
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    if (WidgetsBinding.instance != null) {
      //
      // showing the notification if have any in background
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification notification = message.notification!;
        AndroidNotification android = message.notification!.android!;
        if (notification != null && android != null) {
          debugPrint(notification.hashCode.toString());
          flutterLocalNotificationsPlugin.cancel(0).then(
            (_) {
              debugPrint('cancelled');
              return flutterLocalNotificationsPlugin.show(
                // notification.hashCode,
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
              );
            },
          );
        }
      });
    }
    // onMessageClicked open app handler
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(notification.title!),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(notification.body!)],
                ),
              ),
            );
          },
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void showNotification() {
    flutterLocalNotificationsPlugin.show(
      // _counter, // will show the notification with different id. that means each notification will appear in the notification panel until yoiu remove them..
      0, // every it will replace the previous one
      "Testing ",
      "How you doing ?",
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          priority: Priority.high,
          color: Colors.blue,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
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
        // home: CheckFitScreen(),
        getPages: RouteHelper.routes,
        defaultTransition: Transition.topLevel,
        theme: ThemeModel().lightMode, // Provide light  theme.
        transitionDuration: const Duration(milliseconds: 500),
      );
    });
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseManageback(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(
      "-----------------${message.notification!.body.toString()}------------------------");
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
