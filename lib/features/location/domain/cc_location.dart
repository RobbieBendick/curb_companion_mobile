import 'package:curb_companion/features/location/domain/cc_address.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';

part 'cc_location.g.dart';

@HiveType(typeId: 1)
class CCLocation {
  @HiveField(0)
  final double latitude;

  @HiveField(1)
  final double longitude;

  @HiveField(2)
  final double? altitude;

  @HiveField(3)
  final double? accuracy;

  @HiveField(4)
  late CCAddress? address;

  CCLocation({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
    this.address,
  });

  CCLocation.fromPosition(Position position)
      : latitude = position.latitude,
        longitude = position.longitude,
        altitude = position.altitude,
        accuracy = position.accuracy;
  CCLocation.fromJson(Map<String, dynamic> json)
      : latitude =
            json['coordinates'].isNotEmpty ? json['coordinates'][1] : null,
        longitude =
            json['coordinates'].isNotEmpty ? json['coordinates'][0] : null,
        altitude = json['altitude'],
        accuracy = json['accuracy'],
        address = json['address'] != null
            ? CCAddress.fromJson(json['address'])
            : null;

  Map<String, dynamic> toJson() => {
        'coordinates': [longitude, latitude],
        'altitude': altitude,
        'accuracy': accuracy,
      };

  @override
  String toString() {
    return '$latitude, $longitude';
  }
}
