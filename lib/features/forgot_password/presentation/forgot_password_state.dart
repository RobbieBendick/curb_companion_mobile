part of 'forgot_password_state_notifier.dart';

/// Abstract state for [ForgotPasswordCubit].
abstract class ForgotPasswordState {}

/// Initial state for [ForgotPasswordCubit].
class ForgotPasswordInitial extends ForgotPasswordState {}

class EmailSending extends ForgotPasswordState {}

class EmailSent extends ForgotPasswordState {}

class EmailSendingError extends ForgotPasswordState {
  EmailSendingError(this.errorMessage);

  final String errorMessage;
  List<Object> get props => [errorMessage];
}

class EmailVerifying extends ForgotPasswordState {}

class EmailVerified extends ForgotPasswordState {}

class EmailVerificationError extends ForgotPasswordState {
  EmailVerificationError(this.errorMessage);

  final String errorMessage;
  List<Object> get props => [errorMessage];
}

class ResettingPassword extends ForgotPasswordState {}

class PasswordReset extends ForgotPasswordState {}

class ResetPasswordError extends ForgotPasswordState {
  ResetPasswordError(this.errorMessage);

  final String errorMessage;
  List<Object> get props => [errorMessage];
}
