import 'package:curb_companion/constants/constants.dart';
import 'package:curb_companion/features/home/presentation/home_state_notifier.dart';
import 'package:curb_companion/features/location/domain/cc_address.dart';
import 'package:curb_companion/features/location/domain/cc_location.dart';
import 'package:curb_companion/features/location/data/location_repository.dart';
import 'package:curb_companion/features/user/presentation/user_state_notifier.dart';
import 'package:curb_companion/utils/helpers/helper.dart';
import 'package:curb_companion/utils/services/geolocator_service.dart';
import 'package:curb_companion/utils/services/rest_api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';

part 'location_state.dart';

final locationStateProvider =
    StateNotifierProvider<LocationStateNotifier, LocationState>(
        (ref) => LocationStateNotifier(ref));

class LocationStateNotifier extends StateNotifier<LocationState> {
  Ref ref;
  LocationRepository locationRepository = LocationRepository();
  String boxName = "wtf";

  CCLocation? currentLocation;

  CCLocation? _lastKnownLocation;
  CCLocation? get lastKnownLocation => _lastKnownLocation;

  Stream<Position>? _locationStream;
  Stream<Position>? get locationStream => _locationStream;

  List<CCLocation> _savedLocations = [];
  List<CCLocation> get savedLocations => _savedLocations;

  LocationStateNotifier(this.ref) : super(LocationInitial()) {
    load();
  }

  set lastKnownLocation(CCLocation? location) {
    _lastKnownLocation = location;
    state = LocationLoaded([
      if (_lastKnownLocation != null) _lastKnownLocation!,
      ..._savedLocations
    ]);
  }

  set savedLocations(List<CCLocation> locations) {
    _savedLocations = locations.toSet().toList();
    state = LocationLoaded([
      if (_lastKnownLocation != null) _lastKnownLocation!,
      ..._savedLocations
    ]);
  }

  set locationStream(Stream<Position>? stream) {
    _locationStream = stream;

    // Move the last known location to savedLocations if it exists and is not already in the list
    if (_lastKnownLocation != null &&
        stream != null &&
        !_savedLocations.any((loc) =>
            loc.latitude == _lastKnownLocation!.latitude &&
            loc.longitude == _lastKnownLocation!.longitude)) {
      _savedLocations.add(_lastKnownLocation!);
    }

    // if we're actually setting the location stream to a value
    // then we don't need an "active" location
    if (stream != null) {
      _lastKnownLocation = null;
    }

    // Ensure unique locations in savedLocations
    _savedLocations = _savedLocations.toSet().toList();

    state = LocationLoaded([
      if (_lastKnownLocation != null) _lastKnownLocation!,
      ..._savedLocations
    ]);
  }

  Future<void> load() async {
    state = LocationLoading();

    if (ref.watch(userStateProvider.notifier).state is! LoggedIn) {
      await _loadFromHive();
    } else {
      await _loadFromApi();
    }
  }

  Future<void> _loadFromHive() async {
    Box box = await Hive.openBox(boxName);
    try {
      _lastKnownLocation = box.get("lastKnownLocation");
      _savedLocations = (box.get("savedLocations", defaultValue: []) as List)
          .cast<CCLocation>();
      var temp = box.get("locationStream");
      if (temp != null) {
        await updateLocationStreamLocally();
      }

      state = LocationLoaded([getLocation(), ..._savedLocations]);
    } catch (e) {
      state = LocationError(getErrorMessage(e));
    }
  }

  Future<void> _loadFromApi() async {
    _lastKnownLocation = ref.watch(userStateProvider.notifier).user!.location;
    _savedLocations =
        ref.watch(userStateProvider.notifier).user!.savedLocations!;
    state = LocationLoaded([getLocation(), ..._savedLocations]);
  }

  CCLocation getLocation() {
    return currentLocation ??
        _lastKnownLocation ??
        CCLocation(
            latitude: orlandoCoordinates.latitude,
            longitude: orlandoCoordinates.longitude);
  }

  Future<void> updateCurrentLocation(CCLocation? location) async {
    try {
      state = LocationLoading();
      if (ref.watch(userStateProvider.notifier).user == null) {
        await _updateLastKnownLocationLocally(location);
      } else {
        await _updateLastKnownLocationViaApi(location);
      }
      Box box = await Hive.openBox(boxName);
      box.put("locationStream", null);
    } catch (e) {
      state = LocationError(getErrorMessage(e));
    }
  }

  Future<void> _updateLastKnownLocationLocally(CCLocation? location) async {
    Box box = await Hive.openBox(boxName);
    try {
      currentLocation = location;

      _lastKnownLocation = location;
      await box.put("lastKnownLocation", location);

      if (location != null && !_savedLocations.contains(location)) {
        _savedLocations.add(location);
        await box.put("savedLocations", _savedLocations);
      }

      state = LocationLoaded([
        if (_lastKnownLocation != null) _lastKnownLocation!,
        ..._savedLocations
      ]);
    } catch (e) {
      state = LocationError(getErrorMessage(e));
    }
  }

  Future<void> updateLocationStreamLocally() async {
    try {
      state = LocationLoading();

      Box box = await Hive.openBox(boxName);
      Stream<Position> loc = Geolocator.getPositionStream();
      await box.put("locationStream", true);
      _locationStream = loc;
      int counter = 0;

      loc.listen((event) async {
        if (currentLocation != null &&
            (currentLocation?.latitude != event.latitude ||
                currentLocation?.longitude != event.longitude)) {
          currentLocation = CCLocation.fromPosition(event);

          state = LocationLoaded(
            [
              if (_lastKnownLocation != null) _lastKnownLocation!,
              ..._savedLocations
            ],
            streamLocation: _locationStream,
          );
          if (currentLocation != null && counter % 10 == 0) {
            await ref
                .watch(homeStateProvider.notifier)
                .getHomeSections(currentLocation!);
          }
          counter += 1;
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      state = LocationError(getErrorMessage(e));
    }
  }

  Future<void> _updateLastKnownLocationViaApi(CCLocation? location) async {
    try {
      await ref
          .watch(userStateProvider.notifier)
          .updateCurrentLocation(location!);
      _lastKnownLocation = ref.watch(userStateProvider.notifier).user!.location;
      _savedLocations =
          ref.watch(userStateProvider.notifier).user!.savedLocations!;
      state = LocationLoaded([
        if (_lastKnownLocation != null) _lastKnownLocation!,
        ..._savedLocations
      ]);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      state = LocationError(getErrorMessage(e));
    }
  }

  Future<void> attemptSetCurrentLocation() async {
    try {
      state = LocationLoading();
      Position? position = await GeolocatorService.attemptGetCurrentPosition();
      if (position == null) return;

      CCLocation newLocation = CCLocation.fromPosition(position);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          newLocation.latitude, newLocation.longitude);
      newLocation.address = CCAddress.fromPlacemark(placemarks[0]);

      await updateCurrentLocation(newLocation);

      _locationStream = GeolocatorService.getStreamLocation();
      state = LocationLoaded([
        if (_lastKnownLocation != null) _lastKnownLocation!,
        ..._savedLocations
      ], streamLocation: _locationStream);
    } catch (e) {
      state = LocationError(getErrorMessage(e));
    }
  }

  Future<void> deleteCurrentLocation(CCLocation location) async {
    try {
      state = LocationLoading();
      _lastKnownLocation = null;
      if (ref.watch(userStateProvider.notifier).user == null) {
        await _deleteLocationLocally();
      } else {
        await _deleteLocationViaApi();
      }
    } catch (e) {
      state = LocationError(getErrorMessage(e));
    }
  }

  Future<void> _deleteLocationLocally() async {
    Box box = await Hive.openBox(boxName);
    await box.put("lastKnownLocation", _lastKnownLocation);
    state = LocationLoaded(_savedLocations);
  }

  Future<void> _deleteLocationViaApi() async {
    if (_savedLocations.isNotEmpty) {
      _lastKnownLocation = _savedLocations[0];
    } else {
      _lastKnownLocation = null;
    }
    await ref
        .watch(userStateProvider.notifier)
        .updateCurrentLocation(_lastKnownLocation);
    state = LocationLoaded([
      if (_lastKnownLocation != null) _lastKnownLocation!,
      ..._savedLocations
    ]);
  }

  Future<void> deleteSavedLocation(CCLocation location) async {
    try {
      state = LocationLoading();
      if (ref.watch(userStateProvider.notifier).user == null) {
        await _deleteSavedLocationLocally(location);
      } else {
        await _deleteSavedLocationViaApi(location);
      }
    } catch (e) {
      state = LocationError(getErrorMessage(e));
    }
  }

  Future<void> _deleteSavedLocationLocally(CCLocation location) async {
    _savedLocations.remove(location);
    Box box = await Hive.openBox(boxName);
    await box.put("savedLocations", _savedLocations);
    state = LocationLoaded([
      if (_lastKnownLocation != null) _lastKnownLocation!,
      ..._savedLocations
    ]);
  }

  Future<void> _deleteSavedLocationViaApi(CCLocation location) async {
    await RestApiService.deleteSavedLocation(
      ref.watch(userStateProvider.notifier).user!.id!,
      location,
    );
    _savedLocations.remove(location);
    state = LocationLoaded([
      if (_lastKnownLocation != null) _lastKnownLocation!,
      ..._savedLocations
    ]);
  }
}
