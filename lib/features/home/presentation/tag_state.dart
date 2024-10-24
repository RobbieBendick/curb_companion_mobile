part of 'tag_state_notifier.dart';

/// Abstract state for [RegstrationCubit].
abstract class TagState {}

/// Initial state for [TagCubit].
class TagInitialState extends TagState {}

/// Loading state for [TagCubit].
class TagLoadingState extends TagState {}

/// Loaded state for [TagCubit].
class TagLoadedState extends TagState {
  List<Tag> tags;
  TagLoadedState(this.tags);

  List<Object> get props => [tags];
}

/// Filter loading state for [TagCubit].
/// This state is used when the user is filtering the list of [TagScreen].
class TagFilterLoading extends TagState {}

/// Filter loaded state for [TagCubit].
class TagFilterLoaded extends TagState {
  Map<String, List<Vendor>> sections;
  TagFilterLoaded(this.sections);

  List<Object> get props => [sections];
}

/// Error state for [TagCubit].
class TagErrorState extends TagState {
  TagErrorState(this.errorMessage);

  final String errorMessage;
  List<Object> get props => [errorMessage];
}
