import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CircularTagsSkeleton extends StatefulWidget {
  const CircularTagsSkeleton({super.key});

  @override
  State<CircularTagsSkeleton> createState() => _CircularTagsSkeletonState();
}

class _CircularTagsSkeletonState extends State<CircularTagsSkeleton> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          5, // Replace with the number of circles you want to display
          (index) => Padding(
            padding: const EdgeInsets.all(9.5),
            child: ClipOval(
              child: Shimmer(
                duration: const Duration(seconds: 2),
                child: Container(
                  color: Colors.grey.withOpacity(0.7),
                  height: 55,
                  width: 55,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
