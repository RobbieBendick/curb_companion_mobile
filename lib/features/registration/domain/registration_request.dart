import 'package:curb_companion/features/location/domain/cc_location.dart';

class RegistrationRequest {
  String email;
  String password;
  String confirmPassword;
  String firstName;
  String surname;
  String gender;
  DateTime? dateOfBirth;
  CCLocation? location;
  List<CCLocation> savedLocations = [];
  String phoneNumber;

  RegistrationRequest(
      {this.email = "",
      this.password = "",
      this.confirmPassword = "",
      this.firstName = "",
      this.surname = "",
      this.gender = "",
      this.phoneNumber = ""});

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "firstName": firstName,
        "surname": surname,
        "gender": gender,
        "dateOfBirth": dateOfBirth.toString(),
        "location": location != null ? location!.toJson() : null,
        "savedLocations": savedLocations.map((e) => e.toJson()).toList(),
        "phoneNumber": phoneNumber,
      };
}
