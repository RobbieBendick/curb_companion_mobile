import 'dart:convert';

import 'package:curb_companion/constants/api_path.dart';
import 'package:curb_companion/shared/models/query.dart';
import 'package:curb_companion/features/user/domain/user.dart';
import 'package:curb_companion/features/location/domain/cc_location.dart';
import 'package:curb_companion/features/user/domain/login_model.dart';
import 'package:curb_companion/utils/services/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Used for storing secure account data.
final SecureStorageService _storage = SecureStorageService();

/// Method used for all get requests.
/// Adds JWT tokens to the header of the request, if there are any.
Future<Response> get(String url) async {
  Map<String, String> headers = {"Accept": "application/json"};
  headers.addAll(await _storage.readTokens());

  final Response response = await Dio().get(
    url,
    options: Options(
      headers: headers,
    ),
  );
  if (response.headers.map["access-token"] != null &&
      response.headers.map["refresh-token"] != null) {
    await _storage.storeTokens(response.headers.map["access-token"]!.first,
        response.headers.map["refresh-token"]!.first);
  }
  return response;
}

Future<Response> patch(String url, Map<String, dynamic> body) async {
  Map<String, String> headers = {
    "Acception": "application/json",
    "Content-type": "application/json",
  };
  headers.addAll(await _storage.readTokens());

  final Response response = await Dio().patch(
    url,
    data: json.encode(body),
    options: Options(
      headers: headers,
    ),
  );
  if (response.headers.map["access-token"] != null &&
      response.headers.map["refresh-token"] != null) {
    await _storage.storeTokens(response.headers.map["access-token"]!.first,
        response.headers.map["refresh-token"]!.first);
  }
  return response;
}

Future<Response> delete(String url, Map<String, dynamic> body) async {
  Map<String, String> headers = {
    "Acception": "application/json",
    "Content-type": "application/json",
  };
  headers.addAll(await _storage.readTokens());

  final Response response = await Dio().delete(
    url,
    data: json.encode(body),
    options: Options(
      headers: headers,
    ),
  );
  if (response.headers.map["access-token"] != null &&
      response.headers.map["refresh-token"] != null) {
    await _storage.storeTokens(response.headers.map["access-token"]!.first,
        response.headers.map["refresh-token"]!.first);
  }
  return response;
}

/// Method used for all post requests.
/// Adds JWT tokens to the header of the request, if there are any.
/// Gets JWT tokens and stores them, if there are any.
Future<Response> post(String url, Map<String, dynamic> body) async {
  Map<String, String> headers = {
    "Acception": "application/json",
    "Content-type": "application/json",
  };
  headers.addAll(await _storage.readTokens());

  final Response response = await Dio().post(
    url,
    data: json.encode(body),
    options: Options(
      headers: headers,
    ),
  );

  if (response.headers.map["access-token"] != null &&
      response.headers.map["refresh-token"] != null) {
    await _storage.storeTokens(response.headers.map["access-token"]!.first,
        response.headers.map["refresh-token"]!.first);
  }
  return response;
}

/// A service created to interact with the backend that manages this app.
class RestApiService {
  /// Dynamically retrieves API path based on current platform.

  /// Attempts to login a user with a given email and password.
  static Future<Response> login(LoginModel loginModel) async {
    return await post("$apiPath/auth/login", loginModel.toJson());
  }

  static Future<Response> updateUser(User user) async {
    return await patch("$apiPath/users/${user.id}", user.toJson());
  }

  static Future<Response> updateUserDeviceToken(
      String userId, String deviceToken) async {
    Map<String, dynamic> body = {};
    body["deviceToken"] = deviceToken;
    return await patch("$apiPath/users/$userId/update-device-token", body);
  }

  /// Gets a list of a specific user's reviews.
  static Future<Response> getUserReviews(String userId) async {
    return await get("$apiPath/user/$userId/reviews");
  }

  /// Adds a favorite vendor for the user.
  static Future<Response> addFavoriteVendor(
      String userId, String vendorId) async {
    return await post(
        "$apiPath/users/$userId/favorites", {"vendorId": vendorId});
  }

  /// Deletes a favorite vendor for the user.
  static Future<Response> deleteFavoriteVendor(
      String userId, String vendorId) async {
    return await delete(
        "$apiPath/users/$userId/favorites", {"vendorId": vendorId});
  }

  /// Attempts to verify stored JWTs.
  static Future<Response> verifyTokens() async {
    return await get("$apiPath/auth/verify-tokens");
  }

  /// Gets the vendors data by id.
  static Future<Response> getVendorById(id) async {
    return await get("$apiPath/vendors/$id/");
  }

  /// Gets a list of vendors by a given query model, constructed by some or all
  /// query parameters.
  // static Future<Response> queryVendors(QueryModel query) async {
  //   return await _get("$apiPath/vendors/search/${query.toQueryString()}");
  // }

  /// Gets a list of a vendor's reviews.
  static Future<Response> getVendorReviews(id) async {
    return await get("$apiPath/vendors/$id/reviews");
  }

  /// Gets a list of categorized sections of vendors.
  // static Future<Response> getHomeSections(QueryModel query) async {
  //   return await _get("$apiPath/home/sections/${query.toQueryString()}");
  // }

  /// Starts the vendor's live session.
  static Future<Response> goLive(id) async {
    return await get("$apiPath/vendors/$id/go-live");
  }

  /// Ends the vendor's live session.
  static Future<Response> endLive(id) async {
    return await get("$apiPath/vendors/$id/end-live");
  }

  /// Attempts to reset the user's password. (Requires a JWT)
  static Future<Response> resetPassword(
      String password, String confirmPassword) async {
    return await patch("$apiPath/auth/reset-password", {
      "password": password,
      "confirmPassword": confirmPassword,
    });
  }

  static Future<Response> deleteUser(String id) async {
    return await delete("$apiPath/user/$id", {});
  }

  /// Attemps to create a review for a specific vendor.
  static Future<Response> createVendorReview(
    String vendorId,
    String title,
    String description,
    double rating,
  ) async {
    return await post("$apiPath/vendors/$vendorId/reviews", {
      "title": title,
      "description": description,
      "rating": rating,
    });
  }

  static Future<Response> deleteVendorReview(
    String vendorId,
  ) async {
    return await delete("$apiPath/vendors/$vendorId/reviews", {
      "vendorId": vendorId,
    });
  }

  // static Future<Response> getVendorTags(
  //   String vendorId,
  // ) async {
  //   return await _get("$apiPath/vendors/$vendorId/get-tags");
  // }

  static Future<Response> getTags() async {
    return await get("$apiPath/tags");
  }

  static Future<Response> getFilters() async {
    return await get("$apiPath/filters");
  }

  static Future<Response> getHomeSections(
    QueryModel query,
  ) async {
    return await get("$apiPath/home/sections/${query.toQueryString()}");
  }

  static Future<Response> getHomeTags() async {
    return await get("$apiPath/home/tags");
  }

  static Future<Response> queryVendors(
    QueryModel query,
  ) async {
    return await get("$apiPath/vendors/search/${query.toQueryString()}");
  }

  static Future<Response> deleteSavedLocation(
    String userId,
    CCLocation location,
  ) async {
    return await patch("$apiPath/users/$userId/unsave-location", {
      "location": location,
    });
  }

  static Future<Response> appleAuth(
      AuthorizationCredentialAppleID credentials) async {
    return await post("$apiPath/auth/apple-auth", {
      "code": credentials.authorizationCode,
      "email": credentials.email,
      "firstName": credentials.givenName,
      "surname": credentials.familyName,
      "identityToken": credentials.identityToken,
    });
  }

  static Future<Response> googleAuth(userInfo) async {
    return await post("$apiPath/auth/google-auth", userInfo);
  }

  static Future<Response> getNearbyVendors(QueryModel query) {
    return get("$apiPath/vendors/search/${query.toQueryString()}");
  }

  static Future<Response> getAllTags() {
    return get("$apiPath/tags/");
  }

  static Future<Response> getAllNotifications(String userId) {
    return get("$apiPath/notifications/$userId");
  }

  static Future<Response> readNotification(String notificationId) {
    return get("$apiPath/notifications/read/$notificationId");
  }

  static Future<Response> autocomplete(QueryModel query, String sessiontoken) {
    return get(
        "$apiPath/search/autocomplete/${query.toQueryString()}?sessiontoken=$sessiontoken");
  }

  static Future<Response> sendCateringRequest(
      String email, String subject, String description) {
    return post("$apiPath/catering/create-catering-request", {
      email: email,
      subject: subject,
      description: description,
    });
  }
}
