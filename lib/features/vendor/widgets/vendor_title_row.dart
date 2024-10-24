import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorTitleRow extends ConsumerWidget {
  final Vendor vendor;
  const VendorTitleRow(this.vendor, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      vendor.title,
      style: const TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}
