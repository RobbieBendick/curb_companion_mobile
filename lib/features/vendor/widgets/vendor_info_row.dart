import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/utils/helpers/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorInfoRow extends ConsumerWidget {
  final Vendor vendor;
  const VendorInfoRow(this.vendor, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StringHelper stringHelper = StringHelper();
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.vendorMoreInfoScreen,
          arguments: vendor,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            size: 16,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
          const SizedBox(width: 5),
          Text(
            vendor.rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            '(${vendor.reviews.length})',
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(width: 6),
          if (vendor.distance != null)
            Row(
              children: [
                Text(
                  "|",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.withOpacity(0.7),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "${stringHelper.removeDecimalZero(vendor.distance!.toStringAsFixed(1))} mi",
                  style: const TextStyle(fontSize: 15),
                ),
                if (vendor.tags.isNotEmpty)
                  Row(
                    children: [
                      Text(
                        " | ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.withOpacity(0.7),
                        ),
                      ),
                      Text(vendor.tags[0]),
                      if (vendor.tags.length > 1)
                        Row(
                          children: [
                            Text(
                              " | ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.withOpacity(0.7),
                              ),
                            ),
                            Text(vendor.tags[1]),
                          ],
                        ),
                    ],
                  ),
                Icon(
                  Icons.keyboard_arrow_right,
                  size: 18,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                )
              ],
            ),
        ],
      ),
    );
  }
}
