import 'package:curb_companion/features/notifications/domain/notification.dart';
import 'package:curb_companion/utils/services/rest_api_service.dart';
import 'package:dio/dio.dart';

class NotificationRepository {
  Future<List<Notification>> getAllNotifications(String userId) async {
    final Response response = await RestApiService.getAllNotifications(userId);
    List<dynamic>? data = response.data['data'];
    List<Notification> notificationList = [];
    if (data == null) {
      return notificationList;
    }
    for (int i = 0; i < data.length; i++) {
      notificationList.add(Notification.fromJson(data[i]));
    }
    return notificationList;
  }
}
