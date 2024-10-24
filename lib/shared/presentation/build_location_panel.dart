import 'package:app_settings/app_settings.dart';
import 'package:curb_companion/constants/constants.dart';
import 'package:curb_companion/features/home/presentation/home_state_notifier.dart';
import 'package:curb_companion/features/location/domain/cc_location.dart';
import 'package:curb_companion/shared/models/query.dart';
import 'package:curb_companion/features/autocomplete/presentation/autocomplete_content.dart';
import 'package:curb_companion/features/autocomplete/presentation/autocomplete_state_notifier.dart';
import 'package:curb_companion/features/home/presentation/custom_search_text_field.dart';
import 'package:curb_companion/shared/presentation/location_row.dart';
import 'package:curb_companion/features/location/presentation/location_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BuildLocationPanel extends ConsumerStatefulWidget {
  final PanelController panelController;

  const BuildLocationPanel({
    super.key,
    required this.panelController,
  });

  @override
  BuildLocationPanelState createState() => BuildLocationPanelState();
}

class BuildLocationPanelState extends ConsumerState<BuildLocationPanel> {
  QueryModel queryModel = QueryModel();
  late TextEditingController addressController;

  @override
  void initState() {
    addressController = TextEditingController();
    var locationProvider = ref.read(locationStateProvider.notifier);
    queryModel.latitude = locationProvider.lastKnownLocation?.latitude ??
        orlandoCoordinates.latitude;
    queryModel.longitude = locationProvider.lastKnownLocation?.longitude ??
        orlandoCoordinates.longitude;
    queryModel.radius = 1000;
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Consumer(
        builder: (BuildContext context, WidgetRef watch, Widget? child) {
          return _buildLocationPanelContent(context);
        },
      ),
    );
  }

  Widget _buildLocationPanelContent(BuildContext context) {
    final locationState = ref.watch(locationStateProvider);
    final autocompleteState = ref.watch(autocompleteStateProvider);
    final autoCompleteNotifier = ref.watch(autocompleteStateProvider.notifier);

    if (locationState is LocationLoaded || locationState is LocationInitial) {
      var locationProvider = ref.watch(locationStateProvider.notifier);
      final List<CCLocation> uniqueLocations = locationProvider.savedLocations
          .fold<Map<String, CCLocation>>(
            {},
            (map, location) {
              final key =
                  '${location.latitude}-${location.longitude}'; // Create a unique key
              map[key] = location; // Overwrite if key already exists
              return map;
            },
          )
          .values
          .toList();

      return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
              child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                      onPressed: () {
                        widget.panelController.close();
                      },
                    ),
                    const Text(
                      'Addresses',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(width: 48.0),
                  ],
                ),
                Divider(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.15),
                ),
                const SizedBox(height: 15.0),
                CustomSearchTextField(
                    provider: autocompleteStateProvider,
                    controller: addressController,
                    hintText: "Search for an address",
                    onChanged: (q) async {
                      setState(
                        () {
                          addressController.value = TextEditingValue(
                            text: q,
                            selection: TextSelection.fromPosition(
                              TextPosition(offset: q.length),
                            ),
                          );
                        },
                      );
                      queryModel.query = q;
                      await autoCompleteNotifier.autocomplete(queryModel);
                      setState(() {});
                    }),
                const SizedBox(height: 12.0),
                Divider(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.15),
                ),
                if (autocompleteState is AutocompleteLoading)
                  const Center(child: CircularProgressIndicator())
                else if (autocompleteState is AutocompleteLoaded &&
                    addressController.text != "" &&
                    autocompleteState.locations.isNotEmpty)
                  AutocompleteContent(addressController: addressController)
                else if (autocompleteState is AutocompleteError)
                  Text(autocompleteState.errorMessage,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error))
                else
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: double.infinity,
                                  color: locationProvider.locationStream != null
                                      ? Theme.of(context)
                                          .iconTheme
                                          .color!
                                          .withOpacity(0.1)
                                      : Colors.transparent,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        16.0, 8.0, 16.0, 0),
                                    leading: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            if (locationProvider
                                                    .locationStream !=
                                                null) {
                                              print(
                                                  'location stream is not null');
                                              return;
                                            }

                                            bool locationServiceEnabled =
                                                await Geolocator
                                                    .isLocationServiceEnabled();

                                            // Check if location services are enabled
                                            if (locationServiceEnabled) {
                                              // Check if permissions are denied and last known location is null
                                              if (await Geolocator
                                                      .checkPermission() ==
                                                  LocationPermission.denied) {
                                                print(
                                                    LocationPermission.denied);
                                                // prompt the user to grant permissions
                                                await AppSettings
                                                    .openAppSettings(
                                                        type: AppSettingsType
                                                            .location);
                                                await locationProvider
                                                    .attemptSetCurrentLocation();
                                              } else {
                                                print('granted');
                                                widget.panelController.close();
                                                await locationProvider
                                                    .updateLocationStreamLocally();

                                                var currentLocation =
                                                    locationProvider
                                                        .currentLocation;
                                                if (currentLocation != null) {
                                                  await ref
                                                      .read(homeStateProvider
                                                          .notifier)
                                                      .getHomeSections(
                                                          currentLocation);
                                                }
                                              }
                                            }
                                          },
                                          child: Text(
                                            locationProvider.locationStream !=
                                                    null
                                                ? "Streaming your location"
                                                : "Stream your location",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                        ),
                                        const SizedBox(width: 12.0),
                                        Icon(
                                          Icons.location_on,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ),
                                      ],
                                    ),
                                    title:
                                        Container(), // Empty title to avoid alignment issues
                                  )),
                              Divider(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color!
                                    .withOpacity(0.15),
                              ),
                              if (locationProvider.savedLocations.isNotEmpty ||
                                  locationProvider.lastKnownLocation != null)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
                                  child: Text(
                                    "Saved Addresses",
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .color),
                                  ),
                                ),
                              Column(
                                children: [
                                  const SizedBox(height: 16.0),

                                  // active address
                                  if (locationProvider.lastKnownLocation !=
                                      null)
                                    LocationRow(
                                      locationProvider.lastKnownLocation!,
                                      widget.panelController,
                                      isCurrentLocation:
                                          locationProvider.locationStream ==
                                              null,
                                    ),
                                  // saved addresses
                                  ...uniqueLocations.map((location) {
                                    if (locationProvider
                                                .lastKnownLocation?.latitude ==
                                            location.latitude &&
                                        locationProvider
                                                .lastKnownLocation?.longitude ==
                                            location.longitude) {
                                      return const SizedBox();
                                    }
                                    return LocationRow(
                                      location,
                                      widget.panelController,
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          )));
    } else {
      return const CircularProgressIndicator();
    }
  }
}
