
part of 'recent_search_state_notifier.dart';

abstract class RecentSearchState {}

class RecentSearchInitialState extends RecentSearchState {}

class RecentSearchLoadingState extends RecentSearchState {}

class RecentSearchLoadedState extends RecentSearchState {
  List<dynamic> recentSearches;

  RecentSearchLoadedState(this.recentSearches);

  List<Object> get props => [recentSearches];
}
