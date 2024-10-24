import 'package:curb_companion/features/forgot_password/app/forgot_password_service.dart';
import 'package:curb_companion/features/forgot_password/domain/forgot_password_reset_request.dart';
import 'package:curb_companion/shared/domain/email_verification_request.dart';
import 'package:curb_companion/shared/domain/verify_email_request.dart';

class ForgotPasswordRepository {
  Future<void> sendEmail(
      EmailVerificationRequest emailVerificationRequest) async {
    await ForgotPasswordService.emailVerification(
        emailVerificationRequest.toJson());
  }

  Future<void> verifyEmail(VerifyEmailRequest verifyEmailRequest) async {
    await ForgotPasswordService.verifyEmail(verifyEmailRequest.toJson());
  }

  Future<void> resetPassword(
      ForgotPasswordResetRequest forgotPasswordResetRequest) async {
    await ForgotPasswordService.resetPassword(
        forgotPasswordResetRequest.toJson());
  }
}
