import 'dart:io';

import 'package:curb_companion/features/forgot_password/domain/forgot_password_reset_request.dart';
import 'package:curb_companion/features/forgot_password/data/forgot_password_repository.dart';
import 'package:curb_companion/shared/domain/email_verification_request.dart';
import 'package:curb_companion/shared/domain/verify_email_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'forgot_password_state.dart';

final forgotPasswordStateProvider =
    StateNotifierProvider<ForgotPasswordStateNotifier, ForgotPasswordState>(
        (ref) => ForgotPasswordStateNotifier());

class ForgotPasswordStateNotifier extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordStateNotifier() : super(ForgotPasswordInitial());

  String errorMessage = "";
  ForgotPasswordRepository forgotPasswordRepository =
      ForgotPasswordRepository();

  ForgotPasswordResetRequest forgotPasswordModel = ForgotPasswordResetRequest();

  Future<bool> sendEmail(String email) async {
    try {
      state = EmailSending();
      await forgotPasswordRepository.sendEmail(EmailVerificationRequest(email));
      forgotPasswordModel.email = email;
      state = EmailSent();
      return true;
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          errorMessage = "No internet connection";
        } else {
          errorMessage = e.response!.data["errorMessage"];
        }
      }
      state = EmailSendingError(errorMessage);
      rethrow;
    }
  }

  Future<bool> verifyEmail(String email, String code) async {
    try {
      state = EmailVerifying();
      await forgotPasswordRepository
          .verifyEmail(VerifyEmailRequest(email, code));
      state = EmailVerified();
      return true;
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          errorMessage = "No internet connection";
        } else {
          errorMessage = e.response!.data["errorMessage"];
        }
      }
      state = EmailVerificationError(errorMessage);
      rethrow;
    }
  }

  Future<bool> resetPassword(
      ForgotPasswordResetRequest forgotPasswordModel) async {
    try {
      state = ResettingPassword();
      await forgotPasswordRepository.resetPassword(forgotPasswordModel);
      state = PasswordReset();
      return true;
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          errorMessage = "No internet connection";
        } else {
          errorMessage = e.response!.data["errorMessage"];
        }
      }
      state = ResetPasswordError(errorMessage);
      rethrow;
    }
  }
}
