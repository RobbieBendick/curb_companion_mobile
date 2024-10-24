import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:curb_companion/features/theme/app/theme_service.dart';
import 'package:provider/provider.dart' as provider;

class VendorProfileImage extends ConsumerWidget {
  final Vendor vendor;
  const VendorProfileImage(this.vendor, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return vendor.profileImage?.imageURL != null
        ? Image.network(
            vendor.profileImage?.imageURL ?? '',
            width: MediaQuery.of(context).size.width,
            height: 190,
            fit: BoxFit.cover,
          )
        : Image.asset(
            provider.Provider.of<ThemeService>(context, listen: false)
                    .isDarkMode()
                ? 'assets/images/default_vendor_dark.png'
                : 'assets/images/default_vendor.png',
            height: 190,
            width: 325,
          );
  }
}
