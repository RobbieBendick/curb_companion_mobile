import 'package:curb_companion/constants/api_path.dart';
import 'package:curb_companion/utils/services/rest_api_service.dart';
import 'package:dio/dio.dart';

class ForgotPasswordService {
  /// Sends a forgot password verification code to an email.
  static Future<Response> emailVerification(Map<String, dynamic> data) async {
    return await post("$apiPath/auth/forgot-password", data);
  }

  /// Checks if the user has a matching email & forgot password verification code pair.
  static Future<Response> verifyEmail(Map<String, dynamic> data) async {
    return await post("$apiPath/auth/forgot-password/verify", data);
  }

  /// Attempts to reset the user's password after they've been through the forgot password process.
  static Future<Response> resetPassword(Map<String, dynamic> data) async {
    return await patch("$apiPath/auth/forgot-password/reset", data);
  }
}
