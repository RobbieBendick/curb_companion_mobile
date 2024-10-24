part of 'user_state_notifier.dart';

/// Abstract state for [RegstrationCubit].
abstract class UserState {}

/// Initial state for [UserCubit].
class UserInitial extends UserState {}

/// Login currently state for [UserCubit].
class LoggingIn extends UserState {}

class LoggingInWithApple extends UserState {}

class LoggingInWithGoogle extends UserState {}

class DeletingUser extends UserState {}

/// Login successful state for [UserCubit].
class LoggedIn extends UserState {
  final User user;
  LoggedIn(this.user);
  List<Object> get props => [user];
}

/// Logout currently state for [UserCubit].
class LoggedOut extends UserState {}

// Bookmark states
class AddingBookmark extends UserState {}

class AddedBookmark extends UserState {}

class RemovingBookmark extends UserState {}

class RemovedBookmark extends UserState {}

/// Error state for [UserCubit].
class UserError extends UserState {
  UserError(this.errorMessage);

  final String errorMessage;
  List<Object> get props => [errorMessage];
}
