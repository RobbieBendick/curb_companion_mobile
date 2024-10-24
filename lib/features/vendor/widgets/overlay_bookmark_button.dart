import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/home/presentation/favorite_vendor_button.dart';
import 'package:flutter/material.dart';

class OverlayBookmarkButton extends StatelessWidget {
  final Vendor vendor;
  const OverlayBookmarkButton({Key? key, required this.vendor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      top: 7,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.background.withOpacity(0.9),
        ),
        child: FavoriteVendorButton(
          vendor: vendor,
          size: 22,
          key: Key(vendor.id.toString()),
        ),
      ),
    );
  }
}
