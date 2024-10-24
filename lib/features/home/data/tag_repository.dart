import 'package:curb_companion/shared/models/tag.dart';
import 'package:curb_companion/utils/services/rest_api_service.dart';
import 'package:dio/dio.dart';

// TODO: Refactor to it's own feature
class TagRepository {
  Future<List<Tag>> getAllTags() async {
    Response response = await RestApiService.getAllTags();
    print('response: ${response.data}');

    List<Tag> tags = [];
    if (response.data['data'] != null) {
      for (int i = 0; i < response.data['data'].length; i++) {
        print('adding a single tag...');
        tags.add(Tag.fromJson(response.data['data'][i]));
      }
    }

    return tags;
  }
}
