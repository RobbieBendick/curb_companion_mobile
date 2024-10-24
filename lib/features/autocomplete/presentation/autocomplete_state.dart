part of 'autocomplete_state_notifier.dart';

abstract class AutocompleteState {}

class AutocompleteInitial extends AutocompleteState {}

class AutocompleteLoading extends AutocompleteState {}

class AutocompleteLoaded extends AutocompleteState {
  AutocompleteLoaded(this.locations);

  final List<CCLocation> locations;

  List<Object> get props => [locations];
}

class AutocompleteError extends AutocompleteState {
  AutocompleteError(this.errorMessage);

  final String errorMessage;
  List<Object> get props => [errorMessage];
}
