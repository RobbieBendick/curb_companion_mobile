import 'package:curb_companion/shared/presentation/custom_range_slider_thumb_shape.dart';
import 'package:flutter/material.dart';

class CustomRangeSlider extends StatefulWidget {
  late Function(bool) setIsRangeSliderInUse;
  CustomRangeSlider({
    super.key,
    required this.setIsRangeSliderInUse,
  });

  @override
  State<CustomRangeSlider> createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  late RangeValues currentRangeValues;
  @override
  void initState() {
    currentRangeValues = const RangeValues(4.5, 5);

    super.initState();
  }

  _sliderTheme(BuildContext context) {
    return Theme.of(context).sliderTheme.copyWith(
        overlayColor: Colors.black,
        rangeTickMarkShape: const RoundRangeSliderTickMarkShape(
          tickMarkRadius: 8.0,
        ),
        activeTickMarkColor: Colors.black,
        inactiveTickMarkColor: Colors.grey.shade600,
        rangeThumbShape: CustomRangeSliderThumbShape(),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
        showValueIndicator: ShowValueIndicator.never,
        activeTrackColor: Colors.black,
        inactiveTrackColor: Colors.grey.shade600);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 18.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "${currentRangeValues.start != 5 ? "Over " : ""}${currentRangeValues.start % 1 == 0 ? currentRangeValues.start.toInt() : currentRangeValues.start}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(Icons.star, color: Colors.amber)
            ],
          ),
        ),
        const SizedBox(height: 15),
        SliderTheme(
          data: _sliderTheme(context),
          child: RangeSlider(
            values: currentRangeValues,
            max: 5,
            min: 3,
            divisions: 4,
            onChangeStart: (RangeValues values) {
              widget.setIsRangeSliderInUse(true);
            },
            onChangeEnd: (RangeValues values) {
              widget.setIsRangeSliderInUse(false);
            },
            onChanged: (RangeValues values) {
              setState(() {
                currentRangeValues = values;
              });
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .89,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (double i = 3; i <= 5; i += 0.5)
                Text(
                  i % 1 == 0 ? i.toInt().toString() : i.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: i < currentRangeValues.start
                        ? Colors.grey
                        : Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
