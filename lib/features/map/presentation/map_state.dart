part of 'map_state_notifier.dart';

abstract class MapState {}

class MapInitialState extends MapState {}

class MapLoadingState extends MapState {}

class MapLoadedState extends MapState {
  MapLoadedState(this.vendors);

  List<Vendor> vendors;

  List<Object> get props => [vendors];
}

class MapErrorState extends MapState {
  MapErrorState(this.errorMessage);

  final String errorMessage;
  List<Object> get props => [errorMessage];
}
