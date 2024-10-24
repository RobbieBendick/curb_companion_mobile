import 'package:curb_companion/shared/models/query.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/map/data/map_repository.dart';
import 'package:curb_companion/utils/helpers/helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'map_state.dart';

final mapStateProvider = StateNotifierProvider<MapStateNotifier, MapState>(
    (ref) => MapStateNotifier());

class MapStateNotifier extends StateNotifier<MapState> {
  MapStateNotifier() : super(MapInitialState());
  List<Vendor> _vendors = [];

  List<Vendor> get vendors => _vendors;

  final MapRepository mapRepository = MapRepository();
  String errorMessage = "";

  Future<void> setNearbyVendors(List<Vendor> vendors) async {
    _vendors = vendors;
    state = MapLoadedState(vendors);
  }

  Future<void> getNearbyVendors(QueryModel query) async {
    try {
      state = MapLoadingState();
      final vendors = await mapRepository.getNearbyVendors(query);
      _vendors = vendors;
      state = MapLoadedState(vendors);
    } catch (e) {
      state = MapErrorState(getErrorMessage(e));
    }
  }
}
