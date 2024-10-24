import 'package:curb_companion/features/home/presentation/home_state_notifier.dart';
import 'package:curb_companion/features/location/domain/cc_location.dart';
import 'package:curb_companion/features/location/presentation/location_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class LocationRow extends ConsumerStatefulWidget {
  final CCLocation location;
  final double? height;
  final PanelController? panelController;
  final bool? locationPin;
  final bool? isCurrentLocation;

  const LocationRow(
    this.location,
    this.panelController, {
    Key? key,
    this.height,
    this.locationPin,
    this.isCurrentLocation = false,
  }) : super(key: key);

  @override
  LocationRowState createState() => LocationRowState();
}

class LocationRowState extends ConsumerState<LocationRow> {
  var color = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    var homeProvider = ref.watch(homeStateProvider.notifier);
    var locationProvider = ref.watch(locationStateProvider.notifier);
    var currentLocation = locationProvider.lastKnownLocation!;

    if (currentLocation.address!.street != widget.location.address!.street ||
        currentLocation.address!.city != widget.location.address!.city ||
        currentLocation.address!.state != widget.location.address!.state ||
        currentLocation.address!.postalCode !=
            widget.location.address!.postalCode) {
      color = Colors.transparent;
    } else {
      color = Theme.of(context).iconTheme.color!.withOpacity(0.1);

      if (locationProvider.locationStream != null) {
        color = Colors.transparent;
      }
    }

    return InkWell(
      onTap: () async {
        // set to current location
        await locationProvider.updateCurrentLocation(widget.location);

        // close modal
        if (widget.panelController != null) widget.panelController!.close();

        // update home sections
        homeProvider.getHomeSections(widget.location);

        // clear streaming position.
        locationProvider.locationStream = null;
      },
      child: Dismissible(
        background: Container(
          color: Colors.redAccent,
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    "Remove",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        key: Key(widget.location.address!.street!),
        direction: widget.isCurrentLocation!
            ? DismissDirection.none
            : DismissDirection.startToEnd,
        onDismissed: widget.isCurrentLocation!
            ? null
            : (direction) async {
                // check if this is the current location
                if (locationProvider.lastKnownLocation!.address!.street ==
                    widget.location.address!.street) {
                  await locationProvider.updateCurrentLocation(null);
                } else {
                  // remove from saved locations
                  await locationProvider.deleteSavedLocation(widget.location);
                }
                if (!mounted) return;
                // scaffold message saying location removed
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text(
                      'Location removed',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
        child: Container(
          color: color,
          height: widget.height ?? 85,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    if (widget.locationPin != null)
                      Container()
                    else
                      const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.redAccent,
                        ),
                      ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.location.address!.street ?? '',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "${widget.location.address?.city}, ${widget.location.address?.state}, ${widget.location.address?.postalCode}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
