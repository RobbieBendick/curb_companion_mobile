import 'dart:io';

import 'package:curb_companion/features/location/presentation/location_state_notifier.dart';
import 'package:curb_companion/features/registration/domain/registration_request.dart';
import 'package:curb_companion/features/registration/data/registration_repository.dart';
import 'package:curb_companion/shared/domain/email_verification_request.dart';
import 'package:curb_companion/shared/domain/verify_email_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'registration_state.dart';

/// This cubit is used to manage the [RegistrationState]. Its constructor sets the
/// current state to [RegistrationInitial].
///
/// On creation, this cubit also creates a [RegistrationRequest] to get users registration
/// information and [RegistrationRepository] for handling API calls.
///
/// When the [registerUser] method is called, this cubit emits state
/// [Registering].
///
/// If Registration is successful, this cubit emits [Registered].
///
/// On failure, it emits [RegistrationError] with the given error message and rethrows
/// the current error.

final registrationStateProvider =
    StateNotifierProvider<RegistrationStateNotifier, RegistrationState>(
        (ref) => RegistrationStateNotifier(ref));

class RegistrationStateNotifier extends StateNotifier<RegistrationState> {
  final Ref ref;
  final RegistrationRequest registrationModel = RegistrationRequest();
  final RegistrationRepository registrationRepository =
      RegistrationRepository();
  String errorMessage = "";

  RegistrationStateNotifier(this.ref) : super(RegistrationInitial());

  Future<bool> registerUser() async {
    try {
      state = Registering();
      registrationModel.location =
          ref.watch(locationStateProvider.notifier).lastKnownLocation;
      registrationModel.savedLocations =
          ref.watch(locationStateProvider.notifier).savedLocations;
      await registrationRepository.registerUser(registrationModel);
      state = Registered();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
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
      state = RegistrationError(errorMessage);
      rethrow;
    }
  }

  Future<bool> emailVerification(String email) async {
    try {
      state = EmailVerifying();
      await registrationRepository.sendEmail(EmailVerificationRequest(email));
      return true;
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          errorMessage = "No internet connection";
        } else {
          errorMessage = e.response!.data["errorMessage"];
        }
      }
      state = EmailVerificationError(errorMessage);
      rethrow;
    }
  }

  Future<bool> verifyEmail(String code) async {
    try {
      state = EmailVerifying();
      await registrationRepository
          .verifyEmail(VerifyEmailRequest(registrationModel.email, code));
      state = EmailVerified();
      return true;
    } catch (e) {
      if (e is DioException) {
        if (e.error is SocketException) {
          errorMessage = "No internet connection";
        } else {
          errorMessage = e.response!.data["errorMessage"];
        }
      }
      state = EmailVerificationError(errorMessage);
      rethrow;
    }
  }
}
