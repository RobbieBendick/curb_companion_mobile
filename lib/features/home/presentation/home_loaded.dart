import 'package:curb_companion/features/location/presentation/location_state_notifier.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/home/presentation/vendor_card_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeLoadedWidget extends ConsumerStatefulWidget {
  final Function openPanel;
  final Function updatePanelBuilder;
  final Map<String, List<Vendor>> sections;

  const HomeLoadedWidget({
    super.key,
    required this.openPanel,
    required this.updatePanelBuilder,
    required this.sections,
  });

  @override
  HomeLoadedWidgetState createState() => HomeLoadedWidgetState();
}

class HomeLoadedWidgetState extends ConsumerState<HomeLoadedWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Text(
                ref.watch(locationStateProvider.notifier).lastKnownLocation ==
                        null
                    ? "Orlando Vendors"
                    : 'Vendors Near You',
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            if (ref.watch(locationStateProvider.notifier).lastKnownLocation ==
                    null &&
                ref.watch(locationStateProvider.notifier).locationStream ==
                    null)
              const SizedBox(
                width: 300,
                child: Text(
                  "Please enter your address at the top of the page.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            const SizedBox(height: 16),
            for (var section in widget.sections.entries)
              VendorCardSlider(
                title: section.key,
                vendors: section.value,
              ),
          ],
        ),
      ),
    );
  }
}
