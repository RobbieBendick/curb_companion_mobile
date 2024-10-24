import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class VendorCardSliderSkeleton extends StatelessWidget {
  const VendorCardSliderSkeleton({super.key});

  Widget buildVendorSliderHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Shimmer(
          duration: const Duration(seconds: 2),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.7),
            ),
            height: 10,
            width: 110,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 21.0),
          child: ClipOval(
            child: Shimmer(
              duration: const Duration(seconds: 2),
              interval: const Duration(milliseconds: 700),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 20,
                height: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildVendorCardSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer(
          child: Container(
            width: 163,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.7),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 163,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer(
                duration: const Duration(seconds: 2),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.7),
                  ),
                  width: 90,
                  height: 8,
                ),
              ),
              ClipOval(
                child: Shimmer(
                  duration: const Duration(seconds: 2),
                  interval: const Duration(milliseconds: 500),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 10,
                    height: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Shimmer(
              duration: const Duration(seconds: 2),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.7),
                ),
                width: 50,
                height: 8,
              ),
            ),
            const SizedBox(width: 5),
            Shimmer(
              duration: const Duration(seconds: 2),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.7),
                ),
                width: 50,
                height: 8,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        children: [
          buildVendorSliderHeader(),
          const SizedBox(height: 10),
          Row(
            children: [
              buildVendorCardSkeleton(),
              const SizedBox(width: 17),
              buildVendorCardSkeleton(),
            ],
          ),
        ],
      ),
    );
  }
}
