import 'package:curb_companion/constants/api_path.dart';
import 'package:curb_companion/utils/services/rest_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RegistrationService {
  static Future<Response> registerUser(Map<String, dynamic> data) async {
    String path = "$apiPath/auth/register";
    if (kDebugMode) {
      print(path);
      print(data);
    }
    return await post(path, data);
  }

  static Future<Response> emailVerification(Map<String, dynamic> data) async {
    return await post("$apiPath/auth/email-verification", data);
  }

  static Future<Response> emailVerificationVerify(data) async {
    return await post("$apiPath/auth/email-verification/verify", data);
  }
}
