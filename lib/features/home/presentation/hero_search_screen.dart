import 'package:curb_companion/constants/constants.dart';
import 'package:curb_companion/features/discover/presentation/discover_state_notifier.dart';
import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/home/presentation/build_search_list_items.dart';
import 'package:curb_companion/features/home/presentation/custom_search_text_field.dart';
import 'package:curb_companion/features/home/presentation/tag_state_notifier.dart';
import 'package:curb_companion/features/recent_search/presentation/recent_search_state_notifier.dart';
import 'package:curb_companion/features/theme/app/theme_service.dart';
import 'package:curb_companion/features/location/domain/cc_location.dart';
import 'package:curb_companion/features/location/presentation/location_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

class HeroSearchScreen extends ConsumerStatefulWidget {
  const HeroSearchScreen({super.key});

  @override
  HeroSearchScreenState createState() => HeroSearchScreenState();
}

class HeroSearchScreenState extends ConsumerState<HeroSearchScreen> {
  RecentSearchLoadedState? _cachedRecentSearchState;
  late TextEditingController searchTextEditingController;

  @override
  void initState() {
    super.initState();
    searchTextEditingController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_cachedRecentSearchState == null) {
        await ref.read(recentSearchesStateProvider.notifier).loadSearches();
      }
      // grab arguments from navigator if exists and set the text field value
      if (mounted) {
        final textVal = ModalRoute.of(context)!.settings.arguments as String?;

        if (textVal != null) {
          getVendorsAndSetState(textVal);
          ref.read(recentSearchesStateProvider.notifier).addSearch(textVal);
        }
      }
    });
  }

  void getVendorsAndSetState(String val) async {
    final location = ref.read(locationStateProvider.notifier).getLocation();
    await ref.watch(discoverStateProvider.notifier).getVendors(val, location);
    ref.read(recentSearchesStateProvider.notifier).addSearch(val);
    setState(() {
      searchTextEditingController.value = TextEditingValue(
        text: val,
        selection: TextSelection.fromPosition(
          TextPosition(offset: val.length),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final CCLocation location =
        ref.read(locationStateProvider.notifier).lastKnownLocation ??
            CCLocation(
              latitude: orlandoCoordinates.latitude,
              longitude: orlandoCoordinates.longitude,
            );

    return Consumer(
      builder: (context, WidgetRef ref, child) {
        final recentSearchState = ref.watch(recentSearchesStateProvider);
        final recentSearches =
            ref.read(recentSearchesStateProvider.notifier).recentSearches;
        final reversedSearchesList = recentSearches.reversed.toList();

        final discoverState = ref.watch(discoverStateProvider);

        if (recentSearchState is RecentSearchLoadedState &&
            _cachedRecentSearchState == null) {
          _cachedRecentSearchState = recentSearchState;
        }

        var tagState = ref.read(tagStateProvider);
        return Scaffold(
          body: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                toolbarHeight: 100,
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).colorScheme.background,
                surfaceTintColor: Theme.of(context).colorScheme.background,
                elevation: 3,
                forceElevated: false,
                pinned: true,
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomSearchTextField(
                    provider: discoverStateProvider,
                    controller: searchTextEditingController,
                    onFieldSubmitted: (val) async {
                      await ref
                          .watch(discoverStateProvider.notifier)
                          .getVendors(val, location);
                      ref
                          .read(recentSearchesStateProvider.notifier)
                          .addSearch(val);
                    },
                    autoFocus: true,
                    backArrow: true,
                    onChanged: getVendorsAndSetState,
                  ),
                ),
                titleSpacing: 0,
              ),
              SliverFillRemaining(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (recentSearchState is RecentSearchLoadingState)
                        const CircularProgressIndicator(),
                      if (reversedSearchesList.isNotEmpty &&
                          discoverState is! DiscoverLoadingState &&
                          searchTextEditingController.text == "")
                        BuildSearchListItems(
                          onChanged: getVendorsAndSetState,
                          title: "Recent Searches",
                          items:
                              reversedSearchesList.map((e) => e.query).toList(),
                          icon: Icon(Icons.access_time_outlined,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color!
                                  .withOpacity(.7)),
                        ),
                      if (discoverState is! DiscoverLoadingState &&
                          searchTextEditingController.text == "")
                        BuildSearchListItems(
                          onChanged: getVendorsAndSetState,
                          title: "Cuisines",
                          items: tagState is TagLoadedState
                              ? tagState.tags.map((e) => e.title).toList()
                              : [],
                          icon: Icon(
                            Icons.search,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                      if (discoverState is DiscoverLoadedState &&
                          searchTextEditingController.text != "")
                        // list the vendors
                        _buildVendorInfoList(discoverState.vendors),
                      if (discoverState is DiscoverErrorState) ...[
                        const SizedBox(height: 16),
                        Text(
                          discoverState.errorMessage,
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVendorInfoList(List<Vendor> vendors) {
    return Column(
      children: [
        ...vendors.map((Vendor vendor) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  // take them to the vendor screen
                  Navigator.of(context).pushNamed(
                    Routes.vendorScreen,
                    arguments: vendors.first,
                  );
                },
                child: SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: ClipOval(
                          child: vendor.profileImage != null
                              ? Image.network(
                                  vendor.profileImage!.imageURL,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  provider.Provider.of<ThemeService>(context,
                                              listen: false)
                                          .isDarkMode()
                                      ? 'assets/images/default_vendor_dark.png'
                                      : 'assets/images/default_vendor.png',
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        constraints: const BoxConstraints(
                          maxWidth: 250,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              vendor.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              vendor.tags.join(", "),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "${vendor.distance!.toStringAsFixed(1)} mi",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10)
            ],
          );
        })
      ],
    );
  }
}
