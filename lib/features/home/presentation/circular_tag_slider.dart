import 'package:curb_companion/shared/models/tag.dart';
import 'package:curb_companion/features/home/presentation/tag_state_notifier.dart';
import 'package:curb_companion/features/location/presentation/location_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CircularTagSlider extends ConsumerStatefulWidget {
  const CircularTagSlider({
    super.key,
  });

  @override
  CircularTagSliderState createState() => CircularTagSliderState();
}

class CircularTagSliderState extends ConsumerState<CircularTagSlider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.read(tagStateProvider);

    return SliverToBoxAdapter(
      child: Column(
        children: [
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(width: 16),
                if (state is TagLoadedState)
                  ...state.tags.map(
                    (tag) => _buildTagCategory(tag, context),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagCategory(Tag tag, BuildContext context) {
    final currentLocation =
        ref.read(locationStateProvider.notifier).getLocation();

    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: ref
                          .watch(tagStateProvider.notifier)
                          .activeTags
                          .where((tag) => tag.active)
                          .contains(tag)
                      ? Theme.of(context).iconTheme.color!
                      : Colors.transparent,
                  width: 3.5,
                ),
              ),
              child: Ink(
                decoration: tag.image != null
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          image: NetworkImage(
                            tag.image!.imageURL,
                          ),
                          fit: BoxFit.cover,
                        ),
                      )
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/images/default_menu_item.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                width: 65,
                height: 65,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    ref
                        .read(tagStateProvider.notifier)
                        .toggleTag(tag, currentLocation);
                  },
                ),
              )),
          const SizedBox(height: 8),
          Text(
            tag.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
