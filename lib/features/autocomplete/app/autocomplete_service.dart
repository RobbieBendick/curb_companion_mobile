import 'package:curb_companion/constants/api_path.dart';
import 'package:curb_companion/shared/models/query.dart';
import 'package:dio/dio.dart';
import 'package:curb_companion/utils/services/rest_api_service.dart';

Future<Response> getAutocomplete(QueryModel query, String sessiontoken) {
  return get(
      "$apiPath/search/autocomplete/${query.toQueryString()}?sessiontoken=$sessiontoken");
}
