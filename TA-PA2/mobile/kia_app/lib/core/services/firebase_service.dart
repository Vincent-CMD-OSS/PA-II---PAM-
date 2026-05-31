// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'notification_data.dart';

// class FirebaseService {
//   static final FirebaseMessaging _firebaseMessaging =
//       FirebaseMessaging.instance;

//   static final FlutterLocalNotificationsPlugin
//       flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initialize() async {

//     try {

//       // WEB
//       if (kIsWeb) {

//         print('WEB FIREBASE SERVICE');

//         return;
//       }

//       // MOBILE ONLY (ANDROID / IOS)

//       // Request notification permission
//       await _firebaseMessaging.requestPermission();

//       // Android notification settings
//       const AndroidInitializationSettings
//           androidSettings =
//           AndroidInitializationSettings(
//         '@mipmap/ic_launcher',
//       );

//       // iOS notification settings
//       const DarwinInitializationSettings
//           iosSettings =
//           DarwinInitializationSettings();

//       // General initialization settings
//       const InitializationSettings
//           initializationSettings =
//           InitializationSettings(
//         android: androidSettings,
//         iOS: iosSettings,
//       );

//       // Initialize local notification
//       await flutterLocalNotificationsPlugin
//           .initialize(
//         initializationSettings,
//       );

//       // Listen Firebase notification
//       FirebaseMessaging.onMessage.listen(
//         (RemoteMessage message) async {

//           // Save to notification popup/menu
//           NotificationData.notifications.insert(0, {

//             'title':
//                 message.notification?.title ??
//                 'Notifikasi',

//             'subtitle':
//                 message.notification?.body ?? '',

//             'icon': Icons.notifications,

//             'color': Colors.blue,
//           });

//           // Show local notification
//           await showNotification(
//             title:
//                 message.notification?.title ??
//                 'Notifikasi',

//             body:
//                 message.notification?.body ?? '',
//           );
//         },
//       );

//       // Get FCM token
//       String? token =
//           await _firebaseMessaging.getToken();

//       print('FCM TOKEN: $token');

//     } catch (e) {

//       debugPrint(
//         'FirebaseService initialize error: $e',
//       );
//     }
//   }

//   static Future<void> showNotification({
//     required String title,
//     required String body,
//   }) async {

//     try {

//       // Skip web
//       if (kIsWeb) return;

//       // Android notification details
//       const AndroidNotificationDetails
//           androidDetails =
//           AndroidNotificationDetails(

//         'kia_channel',
//         'KIA Notification',

//         importance: Importance.max,
//         priority: Priority.high,
//       );

//       // iOS notification details
//       const DarwinNotificationDetails
//           iosDetails =
//           DarwinNotificationDetails();

//       // General notification details
//       const NotificationDetails
//           notificationDetails =
//           NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       );

//       // Show notification
//       await flutterLocalNotificationsPlugin.show(
//         0,
//         title,
//         body,
//         notificationDetails,
//       );

//     } catch (e) {

//       debugPrint(
//         'Show notification error: $e',
//       );
//     }
//   }
// }

// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:ta_pa2_pa3_project/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'notification_data.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // Initialize Firebase sekali lagi di background
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   print('Background Message Diterima: ${message.messageId}');
// }

// class FirebaseService {
//   static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   static Future<void> initialize() async {
//     try {
//       if (kIsWeb) return;

//       // 1. Request permission
//       await _firebaseMessaging.requestPermission();

//       // 2. Setup Local Notification (Wajib untuk Android background)
//       const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//       const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
//       const InitializationSettings initializationSettings = InitializationSettings(
//         android: androidSettings,
//         iOS: iosSettings,
//       );
//       await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//       // 3. DAFTARKAN BACKGROUND HANDLER (YANG TADI MISSING!)
//       FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//       // 4. Handler saat App Terbuka (Foreground)
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//         print('Foreground Message Diterima');
//         NotificationData.notifications.insert(0, {
//           'title': message.notification?.title ?? 'Notifikasi',
//           'subtitle': message.notification?.body ?? '',
//           'icon': Icons.notifications,
//           'color': Colors.blue,
//         });
//         await showNotification(
//           title: message.notification?.title ?? 'Notifikasi',
//           body: message.notification?.body ?? '',
//         );
//       });

//       // 5. Handler saat App di Background, lalu User KLIK Notifnya
//       FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//         print('Background Message Diklik: ${message.messageId}');
//       });

//       // 6. Cek kalau app dibuka dari notifikasi yang mati total
//       RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
//       if (initialMessage != null) {
//         print('App Dibuka Dari Notifikasi Mati');
//       }

//       // 7. Print Token (Akan dipakai untuk test di Langkah 2)
//       String? token = await _firebaseMessaging.getToken();
//       print('=========================================');
//       print('FCM TOKEN: $token');
//       print('=========================================');

//     } catch (e) {
//       debugPrint('FirebaseService initialize error: $e');
//     }
//   }

//   static Future<void> showNotification({required String title, required String body}) async {
//     try {
//       if (kIsWeb) return;

//       const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//         'kia_channel', // Channel ID
//         'KIA Notification', // Channel Name
//         importance: Importance.max,
//         priority: Priority.high,
//       );
//       const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       );
//       await flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
//     } catch (e) {
//       debugPrint('Show notification error: $e');
//     }
//   }

// }

// import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'notification_data.dart';

// class FirebaseService {
//   static final FirebaseMessaging _firebaseMessaging =
//       FirebaseMessaging.instance;

//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initialize() async {
//     try {
//       // WEB
//       if (kIsWeb) {
//         print('WEB FIREBASE SERVICE');

//         return;
//       }

//       // REQUEST FIREBASE NOTIFICATION PERMISSION
//       await _firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//       );

//       // ANDROID SETTINGS
//       const AndroidInitializationSettings androidSettings =
//           AndroidInitializationSettings(
//         '@mipmap/ic_launcher',
//       );

//       // IOS SETTINGS
//       const DarwinInitializationSettings iosSettings =
//           DarwinInitializationSettings();

//       // GENERAL SETTINGS
//       const InitializationSettings initializationSettings =
//           InitializationSettings(
//         android: androidSettings,
//         iOS: iosSettings,
//       );

//       // INITIALIZE LOCAL NOTIFICATION
//       await flutterLocalNotificationsPlugin.initialize(
//         initializationSettings,
//       );

//       // ANDROID 13+ NOTIFICATION PERMISSION
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.requestNotificationsPermission();

//       // CREATE ANDROID NOTIFICATION CHANNEL
//       const AndroidNotificationChannel channel = AndroidNotificationChannel(
//         'kia_channel',
//         'KIA Notification',
//         description: 'Notification channel for KIA App',
//         importance: Importance.high,
//       );

//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);

//       // FOREGROUND MESSAGE
//       FirebaseMessaging.onMessage.listen(
//         (RemoteMessage message) async {
//           print('MESSAGE DATA: ${message.data}');
//           print('MESSAGE NOTIFICATION: ${message.notification}');

//           final title = message.notification?.title ??
//               message.data['title'] ??
//               'Notifikasi';

//           final body = message.notification?.body ?? message.data['body'] ?? '';

//           NotificationData.notifications.insert(0, {
//             'title': title,
//             'subtitle': body,
//             'icon': Icons.notifications,
//             'color': Colors.blue,
//           });

//           await showNotification(
//             title: title,
//             body: body,
//           );
//         },
//       );

//       // MESSAGE WHEN APP OPENED FROM NOTIFICATION
//       FirebaseMessaging.onMessageOpenedApp.listen(
//         (RemoteMessage message) {
//           print(
//             'NOTIFICATION CLICKED: '
//             '${message.notification?.title}',
//           );
//         },
//       );

//       // GET FCM TOKEN
//       String? token = await _firebaseMessaging.getToken();

//       print('FCM TOKEN: $token');

//       // TOKEN REFRESH
//       FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//         print(
//           'NEW FCM TOKEN: $newToken',
//         );
//       });
//     } catch (e) {
//       debugPrint(
//         'FirebaseService initialize error: $e',
//       );
//     }
//   }

//   static Future<void> showNotification({
//     required String title,
//     required String body,
//   }) async {
//     try {
//       // SKIP WEB
//       if (kIsWeb) return;

//       // ANDROID DETAILS
//       const AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//         'kia_channel',
//         'KIA Notification',
//         channelDescription: 'Notification channel for KIA App',
//         importance: Importance.max,
//         priority: Priority.high,
//         playSound: true,
//       );

//       // IOS DETAILS
//       const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

//       // GENERAL DETAILS
//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       );

//       // SHOW LOCAL NOTIFICATION
//       await flutterLocalNotificationsPlugin.show(
//         DateTime.now().millisecondsSinceEpoch ~/ 1000,
//         title,
//         body,
//         notificationDetails,
//       );
//     } catch (e) {
//       debugPrint(
//         'Show notification error: $e',
//       );
//     }
//   }
// }

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_data.dart';

class FirebaseService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    try {
      // WEB
      if (kIsWeb) {
        print('WEB FIREBASE SERVICE');

        return;
      }

      // REQUEST FIREBASE NOTIFICATION PERMISSION
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // ANDROID SETTINGS
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      // IOS SETTINGS
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings();

      // GENERAL SETTINGS
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // INITIALIZE LOCAL NOTIFICATION
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
      );

      // ANDROID 13+ NOTIFICATION PERMISSION
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      // CREATE ANDROID NOTIFICATION CHANNEL
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'kia_channel',
        'KIA Notification',
        description: 'Notification channel for KIA App',
        importance: Importance.high,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // FOREGROUND MESSAGE
      FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) async {
          print(
            'MESSAGE DATA: ${message.data}',
          );

          print(
            'MESSAGE NOTIFICATION: '
            '${message.notification}',
          );

          final title = message.notification?.title ??
              message.data['title'] ??
              'Notifikasi';

          final body = message.notification?.body ?? message.data['body'] ?? '';

          // SAVE TO NOTIFICATION MENU
          NotificationData.notifications.insert(0, {
            'title': title,
            'subtitle': body,
            'icon': Icons.notifications,
            'color': Colors.blue,
          });

          // SHOW LOCAL NOTIFICATION
          await showNotification(
            title: title,
            body: body,
          );
        },
      );

      // MESSAGE WHEN APP OPENED FROM NOTIFICATION
      FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
          print(
            'NOTIFICATION CLICKED: '
            '${message.notification?.title}',
          );
        },
      );

      // GET FCM TOKEN
      String? token = await _firebaseMessaging.getToken();

      print('FCM TOKEN: $token');

      // TOKEN REFRESH
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        print(
          'NEW FCM TOKEN: $newToken',
        );
      });
    } catch (e) {
      debugPrint(
        'FirebaseService initialize error: $e',
      );
    }
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    try {
      // SKIP WEB
      if (kIsWeb) return;

      // ANDROID DETAILS
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'kia_channel',
        'KIA Notification',
        channelDescription: 'Notification channel for KIA App',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );

      // IOS DETAILS
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

      // GENERAL DETAILS
      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // SHOW LOCAL NOTIFICATION
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        notificationDetails,
      );
    } catch (e) {
      debugPrint(
        'Show notification error: $e',
      );
    }
  }
}
