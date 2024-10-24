import 'package:curb_companion/shared/models/query.dart';
import 'package:curb_companion/features/autocomplete/data/autocomplete_repository.dart';
import 'package:curb_companion/features/location/domain/cc_location.dart';
import 'package:curb_companion/utils/helpers/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

part 'autocomplete_state.dart';

final autocompleteStateProvider =
    StateNotifierProvider<AutocompleteStateNotifier, AutocompleteState>(
        (ref) => AutocompleteStateNotifier(ref));

class AutocompleteStateNotifier extends StateNotifier<AutocompleteState> {
  Ref ref;
  AutocompleteStateNotifier(this.ref) : super(AutocompleteInitial());

  AutocompleteRepository autocompleteRepository = AutocompleteRepository();

  String errorMessage = "";
  String sessiontoken = "";
  List<String> sessionQueries = [];

  Future<void> autocomplete(QueryModel query) async {
    try {
      state = AutocompleteLoading();
      if (sessionQueries.isEmpty ||
          sessiontoken == '' ||
          query.query == '' ||
          query.query == null ||
          (query.query != null &&
              query.query?.contains(sessionQueries.last) == false)) {
        sessiontoken = const Uuid().v4();
        sessionQueries = [query.query ?? ''];
      } else {
        sessionQueries.add(query.query ?? '');
      }

      List<CCLocation> locations =
          await autocompleteRepository.autocomplete(query, sessiontoken);

      if (kDebugMode) {
        print('locations: $locations');
      }

      state = AutocompleteLoaded(locations);
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      state = AutocompleteError(getErrorMessage(e));
    }
  }
}
