import 'package:curb_companion/features/recent_search/domain/recent_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
part 'recent_search_state.dart';

final recentSearchesStateProvider =
    StateNotifierProvider<RecentSearchesNotifier, RecentSearchState>(
        (ref) => RecentSearchesNotifier());

class RecentSearchesNotifier extends StateNotifier<RecentSearchState> {
  var _searches = <dynamic>[];
  RecentSearchesNotifier() : super(RecentSearchInitialState()) {
    loadSearches();
  }

  get recentSearches => _searches;

  loadSearches() async {
    state = RecentSearchLoadingState();
    final box = await Hive.openBox('recentSearches');
    final searches = await box.get('searches');
    if (searches == null) {
      _searches = [];
      state = RecentSearchLoadedState([]);
      return;
    }
    _searches = searches;
    state = RecentSearchLoadedState(searches);
    await box.close();
  }

  Future<void> _saveSearches() async {
    final box = await Hive.openBox('recentSearches');
    await box.put('searches', _searches);
    await box.close();
  }

  Future<void> addSearch(String query) async {
    if (query.isEmpty) return;
    final searchItem = SearchItem(query, DateTime.now());
    int maxRecentSearchesLength = 10;

    // Remove the last search if the list is full
    if (_searches.length >= maxRecentSearchesLength) _searches.removeAt(0);

    // Remove the search if it already exists
    // And add it to the top of the list
    final index = _searches.indexWhere((element) => element.query == query);
    if (index != -1) _searches.removeAt(index);

    _searches.add(searchItem);
    state = RecentSearchLoadedState([..._searches, searchItem]);

    await _saveSearches();
  }

  Future<void> removeSearch(String query) async {
    _searches.removeWhere((element) => element.query == query);
    state = RecentSearchLoadedState([..._searches]);

    await _saveSearches();
  }

  Future<void> clearSearches() async {
    _searches = [];
    state = RecentSearchLoadedState([]);
    await _saveSearches();
  }
}
