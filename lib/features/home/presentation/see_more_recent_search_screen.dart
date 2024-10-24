import 'package:curb_companion/features/recent_search/presentation/recent_search_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SeeMoreRecentSearchesScreen extends ConsumerStatefulWidget {
  const SeeMoreRecentSearchesScreen({Key? key}) : super(key: key);

  @override
  SeeMoreRecentSearchesScreenState createState() =>
      SeeMoreRecentSearchesScreenState();
}

class SeeMoreRecentSearchesScreenState
    extends ConsumerState<SeeMoreRecentSearchesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        var recentSearches =
            ref.watch(recentSearchesStateProvider.notifier).recentSearches;
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              surfaceTintColor: Theme.of(context).colorScheme.background,
              title: const Text("Recent Searches"),
              actions: [
                GestureDetector(
                  onTap: () {
                    ref
                        .read(recentSearchesStateProvider.notifier)
                        .clearSearches();
                    // force refresh list
                    setState(() {});
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text("Clear All"),
                  ),
                )
              ],
            ),
            SliverFillRemaining(
              child: Material(
                child: ListView.builder(
                  itemCount: recentSearches.length,
                  itemBuilder: (BuildContext context, int index) {
                    var recentSearch = recentSearches.reversed.toList()[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time_outlined,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              recentSearch.query,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.clear,
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            onPressed: () {
                              ref
                                  .read(recentSearchesStateProvider.notifier)
                                  .removeSearch(recentSearch.query);

                              // force refresh list
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
