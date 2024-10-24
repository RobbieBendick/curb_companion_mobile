import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/utils/helpers/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorOpenStatusRow extends ConsumerWidget {
  final Vendor vendor;
  const VendorOpenStatusRow(this.vendor, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              StringHelper.openText(vendor.schedule),
              style: TextStyle(
                fontSize: 15,
                color: vendor.isOpen ? Colors.greenAccent : Colors.redAccent,
              ),
            ),
          ],
        )
      ],
    );
  }
}
