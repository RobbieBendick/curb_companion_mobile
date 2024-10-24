import 'dart:io';

import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/utils/services/rest_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'review_state.dart';

final reviewStateProvider =
    StateNotifierProvider<ReviewStateNotifier, ReviewState>(
        (ref) => ReviewStateNotifier(ref));

class ReviewStateNotifier extends StateNotifier<ReviewState> {
  final Ref ref;
  String errorMessage = "";

  ReviewStateNotifier(this.ref) : super(ReviewInitialState());

  Future<void> createVendorReview(
    String vendorId,
    String title,
    String description,
    double rating,
  ) async {
    try {
      state = ReviewLoadingState();
      await RestApiService.createVendorReview(
        vendorId,
        title,
        description,
        rating,
      );

      state = ReviewLoadedState();
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
      state = ReviewErrorState(errorMessage);
    }
  }

  Future<void> deleteVendorReview(String vendorId) async {
    try {
      state = ReviewLoadingState();
      await RestApiService.deleteVendorReview(vendorId);

      state = ReviewLoadedState();
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
      state = ReviewErrorState(errorMessage);
    }
  }
}
