import 'dart:io';

import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/main.dart';
import 'package:curb_companion/features/user/domain/user.dart';
import 'package:curb_companion/features/location/domain/cc_location.dart';
import 'package:curb_companion/features/location/presentation/location_state_notifier.dart';
import 'package:curb_companion/features/user/domain/login_model.dart';
import 'package:curb_companion/features/user/data/user_repository.dart';
import 'package:curb_companion/utils/services/firebase_service.dart';
import 'package:curb_companion/utils/services/rest_api_service.dart';
import 'package:curb_companion/utils/services/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'user_state.dart';

final userStateProvider = StateNotifierProvider<UserStateNotifier, UserState>(
    (ref) => UserStateNotifier(ref));

class UserStateNotifier extends StateNotifier<UserState> {
  final Ref ref;
  User? user;
  String errorMessage = "";
  UserRepository userRepository = UserRepository();

  UserStateNotifier(this.ref) : super(UserInitial());

  Future<bool> login(LoginModel loginModel) async {
    state = LoggingIn();
    try {
      String? deviceToken = await FirebaseService.getToken();
      loginModel.deviceToken = deviceToken;
      user = await userRepository.login(loginModel);
      state = LoggedIn(user!);

      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      return true;
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          errorMessage = "No internet connection";
        } else {
          if (kDebugMode) {
            print(e.response!.data["errorMessage"]);
          }
          errorMessage = e.response!.data["errorMessage"];
        }
      }
      state = UserError(errorMessage);
      rethrow;
    }
  }

  Future<bool> deleteUser() async {
    state = DeletingUser();
    try {
      if (user != null) {
        if (user?.id != null) {
          bool res = await UserRepository().delete(user!.id!);
          if (res) {
            logout();
            return res;
          }
        }
      }
      return false;
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          errorMessage = "No internet connection";
        } else {
          if (kDebugMode) {
            print(e.response!.data["errorMessage"]);
          }
          errorMessage = e.response!.data["errorMessage"];
        }
      }
      state = UserError(errorMessage);
      return false;
    }
  }

  Future<bool> loginWithApple() async {
    state = LoggingInWithApple();
    try {
      final AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);
      user = await userRepository.loginWithApple(credential);
      // PUKE BUT *SHOULD* WORK
      for (int i =
              ref.read(locationStateProvider.notifier).savedLocations.length -
                  1;
          i >= 0;
          i--) {
        await ref.read(locationStateProvider.notifier).updateCurrentLocation(
            ref.read(locationStateProvider.notifier).savedLocations[i]);
      }
      state = LoggedIn(user!);

      await RestApiService.updateUserDeviceToken(
          user!.id!, (await FirebaseService.getToken())!);
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      return true;
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          errorMessage = "No internet connection";
        } else {
          if (kDebugMode) {
            print(e.response!.data["errorMessage"]);
          }
          errorMessage = e.response!.data["errorMessage"];
        }
      }
      state = UserError(errorMessage);
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    state = LoggingInWithGoogle();
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'openid',
        ],
      );
      user = await userRepository.loginWithGoogle(googleSignIn);
      for (int i =
              ref.read(locationStateProvider.notifier).savedLocations.length -
                  1;
          i >= 0;
          i--) {
        await ref.read(locationStateProvider.notifier).updateCurrentLocation(
            ref.read(locationStateProvider.notifier).savedLocations[i]);
      }
      state = LoggedIn(user!);
      await RestApiService.updateUserDeviceToken(
          user!.id!, (await FirebaseService.getToken())!);
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      return true;
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          errorMessage = "No internet connection";
        } else {
          if (kDebugMode) {
            print(e.response);
            print(e.response!.data["errorMessage"]);
          }
          errorMessage = e.response!.data["errorMessage"];
        }
      }
      state = UserError(errorMessage);
      return false;
    }
  }

  Future<bool> verifyTokens() async {
    state = LoggingIn();
    try {
      Map<String, String> tokens = await SecureStorageService().readTokens();
      if (tokens.isEmpty) {
        state = UserInitial();
        return false;
      }
      user = await userRepository.verifyTokens();
      state = LoggedIn(user!);
      await RestApiService.updateUserDeviceToken(
          user!.id!, (await FirebaseService.getToken())!);
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      return true;
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          errorMessage = "No internet connection";
        } else {
          if (kDebugMode) {
            print(e.response!.data["errorMessage"]);
          }
          errorMessage = e.response!.data["errorMessage"];
        }
      }
      user = null;
      state = UserError(errorMessage);
      return false;
    }
  }

  Future<void> logout() async {
    user = null;
    await SecureStorageService().deleteAll();
    state = LoggedOut();
  }

  Future<void> updateCurrentLocation(CCLocation? location) async {
    try {
      User updatedUser = User.fromJson(user!.toJson());
      updatedUser.id = user!.id;
      updatedUser.location = location;
      user = await userRepository.updateUser(updatedUser);
      state = LoggedIn(user!);
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          errorMessage = "No internet connection";
        } else {
          if (kDebugMode) {
            print(e.response!.data["errorMessage"]);
          }
          errorMessage = e.response!.data["errorMessage"];
        }
      }
      state = UserError(errorMessage);
    }
  }

  Future<bool> addFavoriteVendor(String userId, String vendorId) async {
    try {
      state = AddingBookmark();
      await userRepository.addFavoriteVendor(userId, vendorId);
      state = AddedBookmark();
      return true;
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          errorMessage = "No internet connection";
        } else {
          if (kDebugMode) {
            print(e.response!.data["errorMessage"]);
          }
          errorMessage = e.response!.data["errorMessage"];
        }
      }
      state = UserError(errorMessage);
      return false;
    }
  }

  Future<bool> deleteFavoriteVendor(String userId, String vendorId) async {
    try {
      state = RemovingBookmark();
      await userRepository.deleteFavoriteVendor(userId, vendorId);
      state = RemovedBookmark();
      return true;
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          errorMessage = "No internet connection";
        } else {
          if (kDebugMode) {
            print(e.response!.data["errorMessage"]);
          }
          errorMessage = e.response!.data["errorMessage"];
        }
      }
      state = UserError(errorMessage);
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    if (user != null) {
      state = LoggedIn(user!);
      return true;
    } else {
      state = LoggedOut();
      return false;
    }
  }
}
