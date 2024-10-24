import 'package:curb_companion/features/user/domain/user.dart';
import 'package:curb_companion/features/user/domain/login_model.dart';
import 'package:curb_companion/utils/services/rest_api_service.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class UserRepository {
  Future<User> login(LoginModel loginModel) async {
    Response response = await RestApiService.login(loginModel);
    User user = User.fromJson(response.data['data']);
    return user;
  }

  Future<bool> delete(String id) async {
    Response response = await RestApiService.deleteUser(id);
    return true;
  }

  Future<User> verifyTokens() async {
    Response response = await RestApiService.verifyTokens();
    User user = User.fromJson(response.data['data']);
    return user;
  }

  Future<User> loginWithApple(
      AuthorizationCredentialAppleID credentials) async {
    Response response = await RestApiService.appleAuth(credentials);
    User user = User.fromJson(response.data['data']);
    return user;
  }

  Future<User> loginWithGoogle(GoogleSignIn googleSignIn) async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final Map<String, dynamic> userInfo = {
        "id": googleUser.id,
        "email": googleUser.email,
        "displayName": googleUser.displayName,
        "photoUrl": googleUser.photoUrl,
        "accessToken": googleAuth.accessToken,
        "identityToken": googleAuth.idToken,
      };
      Response response = await RestApiService.googleAuth(userInfo);
      User user = User.fromJson(response.data['data']);
      return user;
    }
    throw Exception("Google login failed");
  }

  Future<void> addFavoriteVendor(String userId, String vendorId) async {
    await RestApiService.addFavoriteVendor(userId, vendorId);
  }

  Future<void> deleteFavoriteVendor(String userId, String vendorId) async {
    await RestApiService.deleteFavoriteVendor(userId, vendorId);
  }

  Future<User> updateUser(User user) async {
    Response response = await RestApiService.updateUser(user);

    user = User.fromJson(response.data['data']);
    return user;
  }
}
