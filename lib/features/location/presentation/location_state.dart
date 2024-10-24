part of 'location_state_notifier.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  LocationLoaded(this.locations, {this.streamLocation});

  final List<CCLocation> locations;
  final Stream<Position>? streamLocation;

  List<Object?> get props => [locations, streamLocation];
}

class LocationError extends LocationState {
  LocationError(this.errorMessage);

  final String errorMessage;
  List<Object> get props => [errorMessage];
}
