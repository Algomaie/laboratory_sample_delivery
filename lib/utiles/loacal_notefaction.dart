// import 'dart:io';
// import 'dart:math';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:alpha/views/solid/showdelivers.dart';
// import 'package:rxdart/rxdart.dart';

// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class LocalNotifications {
//   static final FlutterLocalNotificationsPlugin
//       _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   static final onClickNotification = BehaviorSubject<String>();

// // on tap on any notification
//   static void onNotificationTap(NotificationResponse notificationResponse) {
//     onClickNotification.add(notificationResponse.payload!);
//   }

//   void initialize(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((message) {
//       if (kDebugMode) {
//         print("-----------------------------------------" +
//             message.notification!.body.toString());
//       }
//       if (Platform.isAndroid)
//         init(context, message);
//       else
//         showNotification(message);
//     });
//   }

//   Future<void> showNotification(RemoteMessage message) async {
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//       Random.secure().nextInt(100000).toString(),
//       "channel is used for Schedular app notifica",
//       importance: Importance.max,
//     );

//     AndroidNotificationDetails ndroidNotificationChannels =
//         AndroidNotificationDetails(
//             channel.id.toString(), channel.name.toString(),
//             // 'schedular_channel', // id
//             // 'Schedular Notifications', // title
//             channelDescription:
//                 'This channel is used for Schedular app notifications.', // description
//             importance: Importance.high,
//             priority: Priority.high,
//             ticker: "ticker");
//     NotificationDetails notificationDetails =
//         NotificationDetails(android: ndroidNotificationChannels);

//     Future.delayed(Duration.zero, () {
//       _flutterLocalNotificationsPlugin.show(
//           0,
//           message.notification!.title.toString(),
//           message.notification!.body.toString(),
//           notificationDetails);
//     });
//   }

// // initialize the local notifications
 

//   // show a simple notification
//   static Future showSimpleNotification({
//     required String title,
//     required String body,
//     required String payload,
//   }) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('your channel id', 'your channel name',
//             channelDescription: 'your channel description',
//             importance: Importance.max,
//             priority: Priority.high,
//             ticker: 'ticker');
//     const NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);
//     await _flutterLocalNotificationsPlugin
//         .show(0, title, body, notificationDetails, payload: payload);
//   }

//   // to show periodic notification at regular interval
//   static Future showPeriodicNotifications({
//     required String title,
//     required String body,
//     required String payload,
//   }) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('channel 2', 'your channel name',
//             channelDescription: 'your channel description',
//             importance: Importance.max,
//             priority: Priority.high,
//             ticker: 'ticker');
//     const NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);
//     await _flutterLocalNotificationsPlugin.periodicallyShow(
//         1, title, body, RepeatInterval.everyMinute, notificationDetails,
//         payload: payload);
//   }

//   // to schedule a local notification
//   static Future showScheduleNotification({
//     required String title,
//     required String body,
//     required String payload,
//   }) async {
//     tz.initializeTimeZones();
//     await _flutterLocalNotificationsPlugin.zonedSchedule(
//         2,
//         title,
//         body,
//         tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//         const NotificationDetails(
//             android: AndroidNotificationDetails(
//                 'channel 3', 'your channel name',
//                 channelDescription: 'your channel description',
//                 importance: Importance.max,
//                 priority: Priority.high,
//                 ticker: 'ticker')),
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         payload: payload);
//   }

//   // close a specific channel notification
//   static Future cancel(int id) async {
//     await _flutterLocalNotificationsPlugin.cancel(id);
//   }

//   // close all the notifications available
//   static Future cancelAll() async {
//     await _flutterLocalNotificationsPlugin.cancelAll();
//   }

//   Future<void> setUpInteractedMessage() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;

//     //Android
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission: ${settings.authorizationStatus}');
//     } else if (settings.authorizationStatus == AuthorizationStatus.provisional)
//       print('User not granted permission: ');
//     else {}
//     //Get the message from tapping on the notification when app is not in foreground
//     RemoteMessage? initialMessage = await messaging.getInitialMessage();

//     //If the message contains a service, navigate to the admin
//     if (initialMessage != null) {
//       // await _mapMessageToUser(initialMessage);
//     }

//     //This listens for messages when app is in background
//     // FirebaseMessaging.onMessageOpenedApp.listen(_mapMessageToUser);

//     //Listen to messages in Foreground
    

//       //Initialize FlutterLocalNotifications
//       final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//           FlutterLocalNotificationsPlugin();

//       const AndroidNotificationChannel channel = AndroidNotificationChannel(
//         'schedular_channel', // id
//         'Schedular Notifications', // title
//         description:
//             'This channel is used for Schedular app notifications.', // description
//         importance: Importance.max,
//       );

//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);

//       //Construct local notification using our created channel
//       if (notification != null && android != null) {
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 channelDescription: channel.description,
//                 icon: "@mipmap/ic_launcher", //Your app icon goes here
//                 // other properties...
//               ),
//             ));
//       }
//     });
//   }

//   void handleMessage(BuildContext context, RemoteMessage message) {
//     if (message.data["type"] == "issa") {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HomePage(),
//           ));
//     }
//   }
// }
