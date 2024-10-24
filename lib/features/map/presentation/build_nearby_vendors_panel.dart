import 'package:curb_companion/features/location/presentation/location_state_notifier.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/map/presentation/map_state_notifier.dart';
import 'package:curb_companion/utils/helpers/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:curb_companion/features/theme/app/theme_service.dart';
import 'package:provider/provider.dart' as provider;

class BuildNearbyVendorsPanel extends ConsumerStatefulWidget {
  final List<Vendor> vendors;
  final Function updateSelectedVendor;
  final PanelController panelController;
  final Function animateToVendor;
  final Function updatePanelBuilder;
  final MapState state;

  const BuildNearbyVendorsPanel(
      this.vendors,
      this.updateSelectedVendor,
      this.panelController,
      this.updatePanelBuilder,
      this.state,
      this.animateToVendor,
      {Key? key})
      : super(key: key);

  @override
  MyWidgetState createState() => MyWidgetState();
}

class MyWidgetState extends ConsumerState<BuildNearbyVendorsPanel> {
  StringHelper stringHelper = StringHelper();
  @override
  Widget build(BuildContext context) {
    final List<Vendor> vendors = widget.vendors;
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              ref.watch(locationStateProvider.notifier).lastKnownLocation !=
                      null
                  ? "Vendors Near You"
                  : "Orlando Vendors",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (widget.state is MapLoadingState)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (widget.state is MapErrorState)
            Expanded(
              child: Center(
                child: Text(
                  (widget.state as MapErrorState).errorMessage,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          if (widget.state is MapLoadedState && widget.vendors.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'No vendors found',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          if (widget.state is MapLoadedState && widget.vendors.isNotEmpty) ...[
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                itemCount: vendors.length,
                itemBuilder: (context, index) {
                  final vendor = vendors[index];
                  return Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          height: 82,
                          width: 82,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: vendor.profileImage != null
                                ? Image.network(
                                    vendor.profileImage!.imageURL,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    provider.Provider.of<ThemeService>(context,
                                                listen: false)
                                            .isDarkMode()
                                        ? 'assets/images/default_vendor_dark.png'
                                        : 'assets/images/default_vendor.png',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      title: SizedBox(
                        child: Text(
                          vendor.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${stringHelper.removeDecimalZero(vendor.distance?.toStringAsFixed(1))} miles away",
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                stringHelper.removeDecimalZero(
                                  vendor.rating.toStringAsFixed(1),
                                ),
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              const Icon(Icons.star, size: 13),
                              const SizedBox(width: 5),
                              Text(
                                "${vendor.reviews.length} reviews",
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        widget.animateToVendor(vendor);
                        widget.updateSelectedVendor(vendor);
                        widget.panelController.close();

                        // wait 0.25 seconds before opening the panel
                        Future.delayed(
                          const Duration(milliseconds: 250),
                          () {
                            // switch the panel builder
                            widget.updatePanelBuilder('vendor');
                            // open the panel
                            widget.panelController.animatePanelToPosition(0.01);
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ],
      ),
    );
  }
}
