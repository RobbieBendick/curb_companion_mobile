class EmailVerificationRequest {
  String email;

  EmailVerificationRequest(this.email);

  Map<String, dynamic> toJson() => {
        "email": email,
      };
}
