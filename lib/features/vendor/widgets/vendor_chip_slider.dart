import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/home/presentation/home_state_notifier.dart';
import 'package:curb_companion/features/vendor/widgets/custom_chip.dart';
import 'package:curb_companion/features/theme/app/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorChipSliderTitle extends ConsumerStatefulWidget {
  final Vendor vendor;
  const VendorChipSliderTitle(this.vendor, {super.key});

  @override
  VendorChipSliderTitleState createState() => VendorChipSliderTitleState();
}

class VendorChipSliderTitleState extends ConsumerState<VendorChipSliderTitle> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        var homeSections = ref.read(homeStateProvider.notifier).sections;
        List<Vendor> mostPopularSectionVendors = homeSections['Most popular'];
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            Chip(
                backgroundColor:
                    ThemeService().isDarkMode() ? Colors.white70 : Colors.black,
                label: Text(
                  widget.vendor.title,
                  style: TextStyle(
                    color: ThemeService().isDarkMode()
                        ? Colors.black
                        : Colors.white,
                  ),
                )),
            const SizedBox(
              width: 10,
            ),
            for (var i = 0; i < mostPopularSectionVendors.length; i++)
              if (i <= 10 &&
                  mostPopularSectionVendors[i].id != widget.vendor.id)
                CustomChip(mostPopularSectionVendors[i]),
          ]),
        );
      },
    );
  }
}
