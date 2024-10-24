import 'dart:io';

import 'package:curb_companion/shared/models/filter.dart';
import 'package:curb_companion/shared/models/query.dart';
import 'package:curb_companion/shared/models/tag.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/home/data/home_repository.dart';
import 'package:curb_companion/features/home/presentation/tag_state_notifier.dart';
import 'package:curb_companion/features/location/domain/cc_location.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'home_state.dart';

final homeStateProvider = StateNotifierProvider<HomeStateNotifier, HomeState>(
    (ref) => HomeStateNotifier(ref));

class HomeStateNotifier extends StateNotifier<HomeState> {
  final Ref ref;
  List<Tag> tags = [];
  List<Filter> filters = [];

  String errorMessage = "";
  Map<String, List<Vendor>> _sections = {};

  final HomeRepository _homeRepository = HomeRepository();

  HomeStateNotifier(this.ref) : super(HomeInitialState());

  Map<String, dynamic> get sections => _sections;

  QueryModel queryModel(CCLocation location, {double? radius}) {
    List<Tag> activeTags = ref.read(tagStateProvider.notifier).activeTags;
    List<Filter> activeFilters =
        ref.read(tagStateProvider.notifier).activeFilters;
    double lat = location.latitude;
    double lng = location.longitude;

    return QueryModel(
      tags: activeTags,
      filters: activeFilters,
      latitude: lat,
      longitude: lng,
      radius: radius ?? 50,
    );
  }

  Future<void> getHomeSections(CCLocation location) async {
    try {
      state = HomeLoadingState();

      final Map homeData =
          await _homeRepository.getHomeSections(queryModel(location));

      tags = homeData['tags'];
      filters = homeData['filters'];

      Map<String, List<Vendor>> sections = homeData['sections'];
      _sections = sections;

      state = HomeLoadedState(sections);
    } catch (e) {
      print(e);
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
      state = HomeErrorState(errorMessage);
    }
  }

  Future<void> getVendors(CCLocation location) async {
    try {
      state = HomeFilterLoading();

      tags.where((tag) => tag.active).toList();

      filters.where((filter) => filter.active).toList();

      final Map<String, List<Vendor>> sections =
          await _homeRepository.queryVendors(queryModel(location));

      _sections = sections;

      state = HomeFilterLoaded(sections);
    } catch (e) {
      print(e);
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
      state = HomeErrorState(errorMessage);
    }
  }
}
