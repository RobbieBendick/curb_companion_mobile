import 'package:curb_companion/main.dart';
import 'package:curb_companion/utils/services/local_notifications_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final firebaseMessaging = FirebaseMessaging.instance;

class FirebaseService {
  static Future<void> init() async {
    await Firebase.initializeApp();
    NotificationSettings permission =
        await FirebaseMessaging.instance.requestPermission();

    if (permission.authorizationStatus == AuthorizationStatus.authorized) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
              alert: true, badge: true, sound: true);

      await firebaseMessaging.requestPermission();

      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedAppHandler);

      FirebaseMessaging.onMessage.listen(_onMessageHandler);

      await LocalNotificationsService.init();
    }
  }

  static Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  static Future<void> _onMessageOpenedAppHandler(RemoteMessage message) async {
    if (message.data['route'] != null) {
      navigatorKey.currentState
          ?.pushNamed(message.data['route'], arguments: message);
    }
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    // If you want to do anything with the background message, do it here
  }

  static Future<void> _onMessageHandler(RemoteMessage message) async {
    await LocalNotificationsService.showNotification(message);
  }
}
