import 'package:flutter/material.dart';

class CustomRangeSliderThumbShape extends RangeSliderThumbShape {
  static const double _thumbRadius = 10.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size.fromRadius(_thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool? isDiscrete,
    bool? isEnabled,
    bool? isOnTop,
    bool? isPressed,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
  }) {
    final canvas = context.canvas;
    final thumbPaint = Paint()..color = Colors.black;
    if (thumb?.index == 0) {
      // draw a larger circle
      canvas.drawCircle(center, _thumbRadius + 4, thumbPaint);
    } else {
      canvas.drawCircle(center, _thumbRadius - 3.5, thumbPaint);
    }
  }
}
