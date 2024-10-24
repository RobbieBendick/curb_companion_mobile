import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HeroSearchScreenSkeleton extends StatelessWidget {
  const HeroSearchScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 11; i++) _buildSearchRowSkeleton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchRowSkeleton() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipOval(
              child: Shimmer(
                duration: const Duration(seconds: 2),
                child: Container(
                  color: Colors.grey.withOpacity(0.7),
                  height: 45,
                  width: 45,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Shimmer(
              duration: const Duration(seconds: 2),
              child: Container(
                height: 10,
                width: 200,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
