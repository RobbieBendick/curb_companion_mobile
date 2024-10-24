import 'dart:io';

import 'package:curb_companion/shared/models/filter.dart';
import 'package:curb_companion/shared/models/tag.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/home/presentation/home_state_notifier.dart';
import 'package:curb_companion/features/home/data/tag_repository.dart';
import 'package:curb_companion/features/location/domain/cc_location.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'tag_state.dart';

final tagStateProvider = StateNotifierProvider<TagStateNotifier, TagState>(
    (ref) => TagStateNotifier(ref));

class TagStateNotifier extends StateNotifier<TagState> {
  final Ref ref;
  List<Tag> allTags = [];
  List<Tag> activeTags = [];
  List<Filter> filters = [];
  List<Filter> activeFilters = [];

  String errorMessage = "";

  final TagRepository _tagRepository = TagRepository();

  TagStateNotifier(this.ref) : super(TagInitialState());

  void reset() {
    activeTags = [];
    activeFilters = [];
  }

  Future<void> getAllTags() async {
    try {
      state = TagLoadingState();
      allTags = await _tagRepository.getAllTags();

      state = TagLoadedState(allTags);
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          errorMessage = "No internet connection";
        } else {
          if (kDebugMode) {
            print(e.response!.data["errorMessage"]);
          }
          errorMessage = e.response!.data["errorMessage"];
        }
      }
      state = TagErrorState(errorMessage);
    }
  }

  Future<void> toggleTag(Tag tag, CCLocation location) async {
    tag.active = !tag.active;

    if (tag.active) {
      activeTags.add(tag);
    } else {
      activeTags.remove(tag);
    }

    await ref.read(homeStateProvider.notifier).getHomeSections(location);
  }
}
