part of 'notification_state_notifier.dart';

abstract class NotificationState {}

class NotificationInitialState extends NotificationState {}

class NotificationLoadingState extends NotificationState {}

class NotificationLoadedState extends NotificationState {
  NotificationLoadedState(this.notifications);

  List<Notification> notifications;

  List<Object> get props => [notifications];
}

class NotificationErrorState extends NotificationState {
  NotificationErrorState(this.errorMessage);

  final String errorMessage;
  List<Object> get props => [errorMessage];
}
