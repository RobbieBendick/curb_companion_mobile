import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  static Future<Position?> attemptGetCurrentPosition() async {
    bool isLocationEnabled = await GeolocatorService.requestPermission();
    if (isLocationEnabled) {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true,
      );
    }
    return null;
  }

  static Future<Position?> getInitialLocation() async {
    Position? position = await attemptGetCurrentPosition();
    return position;
  }

  static Stream<Position> getStreamLocation() {
    return Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ));
  }

  // Ask for permission to use location services
  static Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  static Future<bool> isPermissionOnlyDenied() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.denied;
  }

  static Future<bool> isPermissionDeniedForever() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.deniedForever;
  }
}
