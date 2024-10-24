import 'package:curb_companion/features/home/presentation/tag_state_notifier.dart';
import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/home/presentation/custom_search_text_field.dart';
import 'package:curb_companion/features/home/presentation/search_tag_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({super.key});

  @override
  DiscoverPageState createState() => DiscoverPageState();
}

class DiscoverPageState extends ConsumerState<DiscoverPage> {
  TagLoadedState? _cachedTagsState;
  late TextEditingController clickedTagTitleController;

  @override
  void initState() {
    super.initState();
    clickedTagTitleController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final tagStateNotifier = ref.read(tagStateProvider.notifier);

      if (_cachedTagsState == null) {
        await tagStateNotifier.getAllTags();
      }
      if (mounted) setState(() {});
    });
  }

  void setTextFieldValue(String searchVal) async {
    setState(() {
      clickedTagTitleController.text = searchVal;
    });

    // move to hero search screen
    Navigator.pushNamed(
      context,
      Routes.heroSearchScreen,
      arguments: searchVal,
    );
  }

  @override
  void dispose() {
    _cachedTagsState = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var state = ref.read(tagStateProvider);
      return Scaffold(
        body: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: Container(
                  height: 69,
                  padding: const EdgeInsets.only(top: 10.0, bottom: 15),
                  child: Hero(
                    tag: "search",
                    child: CustomSearchTextField(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.heroSearchScreen,
                        );
                      },
                    ),
                  ),
                ),
              ),
              automaticallyImplyLeading: false,
              centerTitle: false,
              title: const Text(
                "Discover",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.account_circle),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.accountScreen);
                  },
                ),
                // TODO: commented out Notifications Button until notifications work
                // IconButton(
                //   icon: Icon(
                //     Icons.notifications,
                //     color: Colors.amber.shade500, // yellow
                //   ),
                //   onPressed: () {
                //     Navigator.pushNamed(context, Routes.notificationScreen);
                //   },
                // ),
              ],
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (state is TagLoadingState)
                      const Center(
                        child: Text(
                          "Loading...",
                        ),
                      ),
                    if (state is TagLoadedState)
                      MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: GridView(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: state.tags.map((tag) {
                            return SearchTagCard(
                              key: Key(tag.title),
                              tag: tag.title,
                              image: tag.image?.imageURL,
                              onTap: setTextFieldValue,
                            );
                          }).toList(),
                        ),
                      ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
