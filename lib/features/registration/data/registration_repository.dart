import 'package:curb_companion/features/registration/app/registration_service.dart';
import 'package:curb_companion/shared/domain/email_verification_request.dart';
import 'package:curb_companion/shared/domain/verify_email_request.dart';
import 'package:curb_companion/features/registration/domain/registration_request.dart';
import 'package:flutter/foundation.dart';

class RegistrationRepository {
  Future<void> registerUser(RegistrationRequest registrationRequest) async {
    var response =
        await RegistrationService.registerUser(registrationRequest.toJson());
    if (kDebugMode) {
      print(response.data);
    }
    return;
  }

  Future<void> sendEmail(
      EmailVerificationRequest emailVerificationRequest) async {
    await RegistrationService.emailVerification(
        emailVerificationRequest.toJson());
  }

  Future<void> verifyEmail(
      VerifyEmailRequest emailVerificationVerifyRequest) async {
    await RegistrationService.emailVerificationVerify(
        emailVerificationVerifyRequest.toJson());
  }
}
