import 'package:curb_companion/shared/presentation/custom_range_slider.dart';
import 'package:curb_companion/shared/presentation/draggable_rectangle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuildRatingsPanel extends ConsumerStatefulWidget {
  final Function(bool) setIsRangeSliderInUse;
  const BuildRatingsPanel({
    super.key,
    required this.setIsRangeSliderInUse,
  });

  @override
  BuildRatingsPanelState createState() => BuildRatingsPanelState();
}

class BuildRatingsPanelState extends ConsumerState<BuildRatingsPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const DraggableRectangle(),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.only(left: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Ratings",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CustomRangeSlider(
                  setIsRangeSliderInUse: widget.setIsRangeSliderInUse,
                ),
                const SizedBox(height: 35),
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .8,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("View Results"),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Reset",
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
