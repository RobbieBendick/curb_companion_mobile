part of 'home_state_notifier.dart';

/// Abstract state for [RegstrationCubit].
abstract class HomeState {}

/// Initial state for [HomeCubit].
class HomeInitialState extends HomeState {}

/// Loading state for [HomeCubit].
class HomeLoadingState extends HomeState {}

/// Loaded state for [HomeCubit].
class HomeLoadedState extends HomeState {
  Map<String, List<Vendor>> sections;
  HomeLoadedState(this.sections);

  List<Object> get props => [sections];
}

/// Filter loading state for [HomeCubit].
/// This state is used when the user is filtering the list of [HomeScreen].
class HomeFilterLoading extends HomeState {}

/// Filter loaded state for [HomeCubit].
class HomeFilterLoaded extends HomeState {
  Map<String, List<Vendor>> sections;
  HomeFilterLoaded(this.sections);

  List<Object> get props => [sections];
}

/// Error state for [HomeCubit].
class HomeErrorState extends HomeState {
  HomeErrorState(this.errorMessage);

  final String errorMessage;
  List<Object> get props => [errorMessage];
}
