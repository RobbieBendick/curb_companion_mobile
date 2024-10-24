import 'package:curb_companion/features/home/presentation/circular_tags_skeleton.dart';
import 'package:curb_companion/features/home/presentation/home_state_notifier.dart';
import 'package:curb_companion/features/home/presentation/tag_state_notifier.dart';
import 'package:curb_companion/features/home/presentation/circular_tag_slider.dart';
import 'package:curb_companion/features/home/presentation/extended_sliver_appbar_with_actions.dart';
import 'package:curb_companion/features/home/presentation/home_error.dart';
import 'package:curb_companion/features/home/presentation/home_loaded.dart';
import 'package:curb_companion/features/home/presentation/home_loading.dart';
import 'package:curb_companion/features/location/domain/cc_location.dart';
import 'package:curb_companion/features/location/presentation/location_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  final Function openPanel;
  final Function updatePanelBuilder;
  final Function updatePageIndex;

  const HomePage({
    Key? key,
    required this.openPanel,
    required this.updatePanelBuilder,
    required this.updatePageIndex,
  }) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  HomeLoadedState? cachedHomeState;
  TagLoadedState? cachedTagsState;
  late CCLocation location;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final locationNotifier = ref.read(locationStateProvider.notifier);
      await locationNotifier.load();
      location = locationNotifier.getLocation();

      final homeNotifier = ref.read(homeStateProvider.notifier);
      final tagNotifier = ref.read(tagStateProvider.notifier);
      homeNotifier.getHomeSections(location);

      // // Retrieve sections
      // if (cachedHomeState == null) {
      // }
      // Retrieve tags
      if (cachedTagsState == null) {
        await tagNotifier.getAllTags();
      }
    });
  }

  @override
  void dispose() {
    // cachedHomeState = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeStateProvider);
    final tagState = ref.watch(tagStateProvider);
    // if (homeState is HomeLoadedState && cachedHomeState == null) {
    //   cachedHomeState = homeState;
    // }
    if (tagState is TagLoadedState && cachedTagsState == null) {
      cachedTagsState = tagState;
    }
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thickness: MaterialStateProperty.all(3),
      ),
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          ExtendedSliverAppbarWithActions(
            widget.openPanel,
            widget.updatePanelBuilder,
          ),
          SliverFillRemaining(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.watch(tagStateProvider.notifier).reset();
                await ref
                    .watch(homeStateProvider.notifier)
                    .getHomeSections(location);
              },
              child: CustomScrollView(slivers: [
                if (tagState is TagLoadingState) const CircularTagsSkeleton(),
                if (tagState is TagLoadedState && tagState.tags.isNotEmpty) ...[
                  // don't use const here or tag borders dont update appropriately
                  // ignore: prefer_const_constructors
                  CircularTagSlider(),
                ],
                if (tagState is TagErrorState)
                  HomeError(errorMessage: tagState.errorMessage),
                // const BetaBanner(),
                if (homeState is HomeLoadingState) const HomeLoading(),
                if (homeState is HomeLoadedState)
                  HomeLoadedWidget(
                    sections: homeState.sections,
                    openPanel: widget.openPanel,
                    updatePanelBuilder: widget.updatePanelBuilder,
                  ),
                if (homeState is HomeErrorState)
                  HomeError(errorMessage: homeState.errorMessage),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
