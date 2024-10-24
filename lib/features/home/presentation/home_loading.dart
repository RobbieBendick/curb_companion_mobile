import 'package:curb_companion/features/home/presentation/vendor_card_slider_skeleton.dart';
import 'package:flutter/material.dart';

class HomeLoading extends StatelessWidget {
  const HomeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 16),
            VendorCardSliderSkeleton(),
            SizedBox(height: 40),
            VendorCardSliderSkeleton(),
          ],
        ),
      ),
    );
  }
}
