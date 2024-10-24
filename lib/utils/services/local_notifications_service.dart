import 'dart:convert';

import 'package:curb_companion/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocalNotificationsService {
  static Future<void> init() async {
    DarwinInitializationSettings iosNotificationDetails =
        const DarwinInitializationSettings();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: iosNotificationDetails);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotificationHandler,
    );
  }

  static void onSelectNotificationHandler(NotificationResponse data) {
    var jsonData = {};
    if (data.payload != null) {
      jsonData = jsonDecode(data.payload!);
    }
    navigatorKey.currentState?.pushNamed(jsonData['route']);
  }

  static Future<void> showNotification(RemoteMessage message) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'push_notifications',
      'Push Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    var notification = message.notification;

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID (use unique value for different notifications)
      notification!.title,
      notification.body,
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }
}
