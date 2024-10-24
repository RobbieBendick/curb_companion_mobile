part of 'registration_state_notifier.dart';

/// Abstract state for [RegstrationCubit].
abstract class RegistrationState {}

/// Initial state for [RegistrationCubit].
class RegistrationInitial extends RegistrationState {}

/// Login currently state for [RegistrationCubit].
class Registering extends RegistrationState {}

/// Login successful state for [RegistrationCubit].
class Registered extends RegistrationState {}

/// Error state for [RegistrationCubit].
class RegistrationError extends RegistrationState {
  RegistrationError(this.errorMessage);

  final String errorMessage;
  List<Object> get props => [errorMessage];
}

class EmailVerifying extends RegistrationState {}

class EmailVerified extends RegistrationState {}

/// Error state for [RegistrationCubit].
class EmailVerificationError extends RegistrationState {
  EmailVerificationError(this.errorMessage);

  final String errorMessage;
  List<Object> get props => [errorMessage];
}

/// Onboarding error state for [RegistrationCubit]
class OnBoardingError extends RegistrationState {
  OnBoardingError(this.errorMessage);

  final String errorMessage;
  List<Object> get props => [errorMessage];
}
