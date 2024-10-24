import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomChip extends ConsumerWidget {
  final Vendor vendor;
  const CustomChip(this.vendor, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.vendorScreen,
              arguments: vendor,
            );
          },
          child: Chip(
            label: Text(vendor.title),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
