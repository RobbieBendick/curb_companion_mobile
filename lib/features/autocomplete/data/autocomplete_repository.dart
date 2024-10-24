import 'package:curb_companion/shared/models/query.dart';
import 'package:curb_companion/features/location/domain/cc_address.dart';
import 'package:curb_companion/features/location/domain/cc_location.dart';
import 'package:dio/dio.dart';
import 'package:curb_companion/features/autocomplete/app/autocomplete_service.dart';
import 'package:geocoding/geocoding.dart';

class AutocompleteRepository {
  Future<List<CCLocation>> autocomplete(
      QueryModel query, String sessiontoken) async {
    List<CCLocation> locations = [];
    print('this is number 1');
    final Response response = await getAutocomplete(query, sessiontoken);
    print('this is number 2');
    for (var location in response.data['data']) {
      final List<Location> ls =
          await locationFromAddress(location['description']);
      final Location l = ls[0];
      final List<Placemark> ps =
          await placemarkFromCoordinates(l.latitude, l.longitude);

      final Placemark p = ps[0];
      locations.add(CCLocation(
        address: CCAddress(
          street: p.street,
          city: p.locality,
          state: p.administrativeArea,
          country: p.country,
          postalCode: p.postalCode,
        ),
        latitude: l.latitude,
        longitude: l.longitude,
      ));
    }
    return locations;
  }
}
