import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlInWebView(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url),
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ));
  } else {
    throw 'Could not launch $url';
  }
}

String getErrorMessage(e) {
  if (e is DioException) {
    if (e.error is SocketException) {
      return "No internet connection";
    } else {
      if (kDebugMode) {
        print(e.response!.data["errorMessage"]);
      }
      return e.response!.data["errorMessage"];
    }
  }
  return e.toString();
}
