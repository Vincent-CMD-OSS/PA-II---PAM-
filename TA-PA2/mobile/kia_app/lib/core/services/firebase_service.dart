import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_data.dart';

class FirebaseService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {

    try {

      // WEB
      if (kIsWeb) {

        print('WEB FIREBASE SERVICE');

        return;
      }

      // MOBILE ONLY (ANDROID / IOS)

      // Request notification permission
      await _firebaseMessaging.requestPermission();

      // Android notification settings
      const AndroidInitializationSettings
          androidSettings =
          AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      // iOS notification settings
      const DarwinInitializationSettings
          iosSettings =
          DarwinInitializationSettings();

      // General initialization settings
      const InitializationSettings
          initializationSettings =
          InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize local notification
      await flutterLocalNotificationsPlugin
          .initialize(
        initializationSettings,
      );

      // Listen Firebase notification
      FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) async {

          // Save to notification popup/menu
          NotificationData.notifications.insert(0, {

            'title':
                message.notification?.title ??
                'Notifikasi',

            'subtitle':
                message.notification?.body ?? '',

            'icon': Icons.notifications,

            'color': Colors.blue,
          });

          // Show local notification
          await showNotification(
            title:
                message.notification?.title ??
                'Notifikasi',

            body:
                message.notification?.body ?? '',
          );
        },
      );

      // Get FCM token
      String? token =
          await _firebaseMessaging.getToken();

      print('FCM TOKEN: $token');

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

      // Skip web
      if (kIsWeb) return;

      // Android notification details
      const AndroidNotificationDetails
          androidDetails =
          AndroidNotificationDetails(

        'kia_channel',
        'KIA Notification',

        importance: Importance.max,
        priority: Priority.high,
      );

      // iOS notification details
      const DarwinNotificationDetails
          iosDetails =
          DarwinNotificationDetails();

      // General notification details
      const NotificationDetails
          notificationDetails =
          NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Show notification
      await flutterLocalNotificationsPlugin.show(
        0,
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