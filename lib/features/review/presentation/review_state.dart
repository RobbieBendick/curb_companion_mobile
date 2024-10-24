part of 'review_state_notifier.dart';

/// Abstract state for [RegstrationCubit].
abstract class ReviewState {}

/// Initial state for [HomeCubit].
class ReviewInitialState extends ReviewState {}

/// Loading state for [HomeCubit].
class ReviewLoadingState extends ReviewState {}

/// Loaded state for [HomeCubit].
class ReviewLoadedState extends ReviewState {}

/// Filter loading state for [HomeCubit].
/// This state is used when the user is filtering the list of [HomeScreen].
class ReviewFilterLoading extends ReviewState {}

/// Filter loaded state for [HomeCubit].
class ReviewFilterLoaded extends ReviewState {
  Map<String, List<Vendor>> sections;
  ReviewFilterLoaded(this.sections);

  List<Object> get props => [sections];
}

/// Error state for [HomeCubit].
class ReviewErrorState extends ReviewState {
  ReviewErrorState(this.errorMessage);

  final String errorMessage;
  List<Object> get props => [errorMessage];
}
