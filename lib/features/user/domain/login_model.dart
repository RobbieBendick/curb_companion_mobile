// TODO: Refactor to login
class LoginModel {
  String email;
  String password;
  String? deviceToken;

  LoginModel({
    required this.email,
    required this.password,
    this.deviceToken,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "deviceToken": deviceToken,
    };
  }
}
