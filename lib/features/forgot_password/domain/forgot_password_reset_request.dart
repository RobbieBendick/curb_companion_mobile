class ForgotPasswordResetRequest {
  String email = "";
  String newPassword = "";
  String confirmPassword = "";
  String code = "";

  ForgotPasswordResetRequest(
      {this.email = "",
      this.newPassword = "",
      this.confirmPassword = "",
      this.code = ""});

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": newPassword,
        "confirmPassword": confirmPassword,
        "code": code,
      };
}
