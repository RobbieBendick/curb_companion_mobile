import 'package:geocoding/geocoding.dart';
import 'package:hive/hive.dart';

part 'cc_address.g.dart';

@HiveType(typeId: 0)
class CCAddress extends HiveObject {
  @HiveField(0)
  final String? street;

  @HiveField(1)
  final String? city;

  @HiveField(2)
  final String? state;

  @HiveField(3)
  final String? country;

  @HiveField(4)
  final String? postalCode;

  CCAddress({
    this.street,
    this.city,
    this.state,
    this.country,
    this.postalCode,
  });

  CCAddress.fromPlacemark(Placemark placemark)
      : street = placemark.street,
        city = placemark.locality,
        state = placemark.administrativeArea,
        country = placemark.country,
        postalCode = placemark.postalCode;

  CCAddress.fromJson(Map<String, dynamic> json)
      : street = json['street'],
        city = json['city'],
        state = json['state'],
        country = json['country'],
        postalCode = json['postalCode'];

  Map<String, dynamic> toJson() => {
        'street': street,
        'city': city,
        'state': state,
        'country': country,
        'postalCode': postalCode,
      };

  @override
  String toString() {
    return '$street, $city, $state, $country, $postalCode';
  }
}
