import 'package:curb_companion/shared/models/filter.dart';
import 'package:curb_companion/shared/models/query.dart';
import 'package:curb_companion/shared/models/tag.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/utils/services/rest_api_service.dart';
import 'package:dio/dio.dart';

class HomeRepository {
  Future<Map<String, dynamic>> getHomeSections(QueryModel queryModel) async {
    Response response = await RestApiService.getHomeSections(queryModel);

    if (response.data['data'] == null) {
      return <String, List<Vendor>>{};
    }

    List<Tag> tags = [];
    if (response.data['tags'] != null) {
      tags = response.data['tags'].map<Tag>((tag) {
        return Tag.fromJson(tag);
      }).toList();
    }

    List<Filter> filters = [];
    if (response.data['filters'] != null) {
      filters = response.data['filters'].map<Filter>((filter) {
        return Filter.fromJson(filter);
      }).toList();
    }
    Map<String, List<Vendor>> sections = {};

    // set the section title and the list of vendors
    response.data['data'].forEach((key, value) {
      List<Vendor> newVendors = [];
      newVendors = value.map<Vendor>((vendor) {
        return Vendor.fromJson(vendor);
      }).toList();
      sections[key] = newVendors;
    });

    Map<String, dynamic> w = {
      "tags": tags,
      "filters": filters,
      "sections": sections,
    };
    return w;
  }

  Future<Map<String, List<Vendor>>> queryVendors(QueryModel queryModel) async {
    Response response = await RestApiService.queryVendors(queryModel);

    Map<String, List<Vendor>> sections =
        response.data['sections'].map<String, List<Vendor>>((section) {
      return MapEntry(
          section['title'],
          section['vendors'].map<Vendor>((vendor) {
            return Vendor.fromJson(vendor);
          }).toList());
    });

    return sections;
  }

  // get home tags
  Future<List<dynamic>> getHomeTags() async {
    Response response = await RestApiService.getHomeTags();
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data['data'];
    } else {
      throw Exception('Failed to load tags');
    }
  }
}
