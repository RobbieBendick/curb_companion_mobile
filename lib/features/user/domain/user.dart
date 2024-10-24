import 'package:curb_companion/shared/models/profile_image.dart';
import 'package:curb_companion/features/location/domain/cc_location.dart';
import 'package:hive/hive.dart';

class User extends HiveObject {
  String? id;
  String? email;
  String? firstName;
  String? surname;
  CCImage? profileImage;
  CCLocation? location;
  List<String>? favorites;
  DateTime? dateOfBirth;
  List<CCLocation>? savedLocations;

  User({
    this.id,
    this.email,
    this.firstName,
    this.surname,
    this.profileImage,
    this.location,
    this.favorites,
    this.dateOfBirth,
    this.savedLocations,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    email = json['email'];
    firstName = json['firstName'];
    surname = json['surname'];
    profileImage = json['profileImage'] != null
        ? CCImage.fromJson(json['profileImage'])
        : null;
    location =
        json['location'] != null ? CCLocation.fromJson(json['location']) : null;
    favorites =
        json['favorites'] != null ? List<String>.from(json['favorites']) : null;
    dateOfBirth = json['dateOfBirth'] != null
        ? DateTime.parse(json['dateOfBirth'])
        : null;
    savedLocations = json['savedLocations'] != null
        ? List<CCLocation>.from(
            json['savedLocations'].map((x) => CCLocation.fromJson(x)))
        : null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'surname': surname,
        'profileImage': profileImage?.toJson(),
        'favorites': favorites,
        'location': location?.toJson(),
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'savedLocation': savedLocations?.map((x) => x.toJson()).toList(),
      };
}
