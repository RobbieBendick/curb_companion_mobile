import 'package:curb_companion/features/home/presentation/custom_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChipSlider extends ConsumerStatefulWidget {
  final Function openPanel;
  final Function updatePanelBuilder;
  const ChipSlider(
      {super.key, required this.openPanel, required this.updatePanelBuilder});

  @override
  ChipSliderState createState() => ChipSliderState();
}

class ChipSliderState extends ConsumerState<ChipSlider> {
  double seperatorLength = 8;
  double iconSize = 19;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(width: 14),
                CustomRoundedChip(
                  onPressed: () {},
                  label: 'Preorder',
                  avatar: Icon(
                    Icons.timer_outlined,
                    size: iconSize,
                    color: Theme.of(context).textTheme.labelLarge!.color,
                  ),
                ),
                SizedBox(width: seperatorLength),
                CustomRoundedChip(
                  onPressed: () async {},
                  label: 'Catering',
                  avatar: Icon(
                    Icons.people_outline,
                    size: iconSize,
                    color: Theme.of(context).textTheme.labelLarge!.color,
                  ),
                ),
                SizedBox(width: seperatorLength),
                CustomRoundedChip(
                  onPressed: () {
                    widget.updatePanelBuilder("ratings");
                    widget.openPanel();
                  },
                  avatar: Icon(Icons.star_border,
                      size: iconSize,
                      color: Theme.of(context).textTheme.bodyMedium!.color),
                  label: 'Ratings',
                  icon: Icon(
                    Icons.arrow_drop_down,
                    size: iconSize,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
