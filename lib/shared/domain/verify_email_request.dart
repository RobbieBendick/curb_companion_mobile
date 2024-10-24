class VerifyEmailRequest {
  String email;
  String code;

  VerifyEmailRequest(this.email, this.code);

  Map<String, dynamic> toJson() => {
        "email": email,
        "code": code,
      };
}
