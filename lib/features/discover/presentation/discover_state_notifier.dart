import 'dart:io';

import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/discover/data/discover_repository.dart';
import 'package:curb_companion/features/location/domain/cc_location.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'discover_state.dart';

final discoverStateProvider =
    StateNotifierProvider<DiscoverStateNotifier, DiscoverState>(
        (ref) => DiscoverStateNotifier());

class DiscoverStateNotifier extends StateNotifier<DiscoverState> {
  DiscoverStateNotifier() : super(DiscoverInitialState());
  final DiscoverRepository _discoverRepository = DiscoverRepository();
  String errorMessage = "";

  void setInitial() {
    state = DiscoverInitialState();
  }

  Future<void> getVendors(String searchVal, CCLocation location) async {
    try {
      state = DiscoverLoadingState();

      final List<Vendor> vendors =
          await _discoverRepository.searchVendors(searchVal, location);

      state = DiscoverLoadedState(vendors);
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
      state = DiscoverErrorState(errorMessage);
    }
  }
}
