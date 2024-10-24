import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:flutter/material.dart';

class NoMenuItems extends StatelessWidget {
  final Vendor vendor;
  const NoMenuItems({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: Center(
            child: Column(
              children: [
                const Text(
                  "Sorry!",
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "It looks like ${vendor.title} doesn't have a menu yet.",
                  style: const TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
