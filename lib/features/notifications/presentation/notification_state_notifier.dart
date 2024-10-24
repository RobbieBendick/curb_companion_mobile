import 'package:curb_companion/features/notifications/domain/notification.dart';
import 'package:curb_companion/features/notifications/data/notifications_repository.dart';
import 'package:curb_companion/utils/helpers/helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'notification_state.dart';

final notificationStateProvider =
    StateNotifierProvider<NotificationStateNotifier, NotificationState>(
        (ref) => NotificationStateNotifier());

class NotificationStateNotifier extends StateNotifier<NotificationState> {
  NotificationStateNotifier() : super(NotificationInitialState());
  List<Notification> _notifications = [];

  List<Notification> get notifications => _notifications;

  final NotificationRepository notificationRepository =
      NotificationRepository();
  String errorMessage = "";

  Future<void> getAllNotifications(String userId) async {
    try {
      state = NotificationLoadingState();

      if (userId.isEmpty) {
        state = NotificationLoadingState();
      } else {
        final notifications =
            await notificationRepository.getAllNotifications(userId);
        // NativeService.setAppBadgeCount(
        //     notifications.where((element) => !element.read).length);

        // TODO: Set badge count
        _notifications = notifications;
        state = NotificationLoadedState(_notifications);
      }
    } catch (e) {
      state = NotificationErrorState(getErrorMessage(e));
      rethrow;
    }
  }
}
