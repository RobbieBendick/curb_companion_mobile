import 'package:curb_companion/shared/models/query.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/location/domain/cc_location.dart';
import 'package:curb_companion/utils/services/rest_api_service.dart';
import 'package:dio/dio.dart';

class DiscoverRepository {
  Future<List<Vendor>> searchVendors(
      String searchVal, CCLocation location) async {
    QueryModel queryModel = QueryModel(
      query: searchVal,
      latitude: location.latitude,
      longitude: location.longitude,
      radius: 30,
      tags: [],
      filters: [],
    );
    Response response = await RestApiService.queryVendors(queryModel);

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data['data'].map<Vendor>((vendor) {
        return Vendor.fromJson(vendor);
      }).toList();
    } else {
      throw Exception('Failed to load vendors');
    }
  }
}
