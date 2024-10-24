import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ChipSliderSkeleton extends StatefulWidget {
  const ChipSliderSkeleton({super.key});

  @override
  State<ChipSliderSkeleton> createState() => _ChipSliderSkeletonState();
}

Widget chipSkeleton() {
  return Row(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Shimmer(
          duration: const Duration(seconds: 2),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.7),
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            height: 20,
            width: 77,
          ),
        ),
      ),
      const SizedBox(width: 10),
    ],
  );
}

class _ChipSliderSkeletonState extends State<ChipSliderSkeleton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 4; i++) chipSkeleton(),
      ],
    );
  }
}
