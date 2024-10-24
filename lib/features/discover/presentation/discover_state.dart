part of 'discover_state_notifier.dart';

abstract class DiscoverState {}

class DiscoverInitialState extends DiscoverState {}

class DiscoverLoadingState extends DiscoverState {}

class DiscoverLoadedState extends DiscoverState {
  List<Vendor> vendors;
  DiscoverLoadedState(this.vendors);

  List<Object> get props => [vendors];
}

class DiscoverErrorState extends DiscoverState {
  DiscoverErrorState(this.errorMessage);

  final String errorMessage;
  List<Object> get props => [errorMessage];
}
