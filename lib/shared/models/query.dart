import 'package:curb_companion/shared/models/filter.dart';
import 'package:curb_companion/shared/models/tag.dart';

/// A model that's used for constructing queries, using the fields that are
/// instantiated.
class QueryModel {
  String? query;
  double? latitude;
  double? longitude;
  double? radius;
  List<Tag>? tags;
  List<Filter>? filters;

  QueryModel({
    this.query,
    this.latitude,
    this.longitude,
    this.radius,
    this.tags,
    this.filters,
  });

  /// Convert Search model to query string for simple query construction.
  String toQueryString() {
    int count = 0;
    String queryString = "?";
    if (query != null && query != "") {
      queryString += "q=";
      queryString += query!;
      count++;
    }
    if (latitude != null && longitude != null && radius != null) {
      if (count > 0) {
        queryString += "&";
      }
      queryString += "lat=";
      queryString += latitude!.toString();
      queryString += "&lon=";
      queryString += longitude!.toString();
      queryString += "&radius=";
      queryString += radius.toString();
    }
    if (tags != null && tags!.isNotEmpty) {
      var tagString = tags!.map((tag) => tag.title).join(",");
      queryString += "&tags=";
      queryString += tagString;
    }
    if (filters != null && filters!.isNotEmpty) {
      queryString += "&filters=";
      queryString += filters!.join(",");
    }

    return queryString;
  }
}
