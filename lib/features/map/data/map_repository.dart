import 'package:curb_companion/shared/models/query.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/utils/services/rest_api_service.dart';
import 'package:dio/dio.dart';

class MapRepository {
  Future<List<Vendor>> getNearbyVendors(QueryModel query) async {
    final Response response = await RestApiService.getNearbyVendors(query);
    List<dynamic> data = response.data['data'];
    List<Vendor> vendorList = [];

    for (int i = 0; i < data.length; i++) {
      vendorList.add(Vendor.fromJson(data[i]));
    }
    return vendorList;
  }
}
