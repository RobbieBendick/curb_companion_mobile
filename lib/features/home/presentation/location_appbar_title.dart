import 'package:curb_companion/features/location/presentation/location_state_notifier.dart';
import 'package:curb_companion/features/theme/app/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationAppbarTitle extends ConsumerStatefulWidget {
  final Function updatePanelBuilder;
  final Function openPanel;
  const LocationAppbarTitle(this.updatePanelBuilder, this.openPanel,
      {super.key});

  @override
  LocationAppbarTitleState createState() => LocationAppbarTitleState();
}

class LocationAppbarTitleState extends ConsumerState<LocationAppbarTitle> {
  final ThemeService themeService = ThemeService();
  @override
  Widget build(BuildContext context) {
    var lastKnownLocation =
        ref.watch(locationStateProvider.notifier).lastKnownLocation;
    var locationStream =
        ref.watch(locationStateProvider.notifier).locationStream;

    String displayAddressMessage() {
      if (locationStream != null) {
        return 'Streaming your location';
      } else if (lastKnownLocation == null) {
        return 'Please enter your address';
      } else {
        return lastKnownLocation.address?.street ??
            'No street address available';
      }
    }

    return Consumer(
      builder: (context, ref, child) {
        return GestureDetector(
          onTap: () {
            setState(() {
              // locationCubit.getLocations();
              widget.updatePanelBuilder("home");
              widget.openPanel();
            });
          },
          child: Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.redAccent,
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth:
                      0, // Allow minimum width to be as small as needed (fit-content)
                  maxWidth: MediaQuery.of(context).size.width *
                      0.45, // Maximum width constraint
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Text(
                      displayAddressMessage(),
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .color!
                            .withOpacity(0.95),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    );
                  },
                ),
              ),
              const Icon(Icons.keyboard_arrow_down)
            ],
          ),
        );
      },
    );
  }
}
