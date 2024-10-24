import 'dart:async';
import 'package:curb_companion/constants/constants.dart';
import 'package:curb_companion/shared/models/query.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/map/presentation/map_state_notifier.dart';
import 'package:curb_companion/features/map/presentation/build_nearby_vendors_panel.dart';
import 'package:curb_companion/features/map/presentation/build_vendor_panel.dart';
import 'package:curb_companion/features/location/presentation/location_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends ConsumerState<MapPage> {
  MapLoadedState? cachedMapState;

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  final QueryModel query = QueryModel(
    latitude: 0,
    longitude: 0,
  );
  Function? panelBuilder;

  late double slidingPanelMinHeight;
  late double slidingPanelMaxHeight;
  final PanelController panelController = PanelController();
  late BitmapDescriptor markerIcon;

  Vendor? selectedVendor;
  late bool isDraggable = false;

  Timer timer = Timer(const Duration(days: 0), () => {});

  List<Vendor> cachedVendors = [];
  double nearbyVendorsPanelMinHeight = 170;
  @override
  void initState() {
    super.initState();
    slidingPanelMinHeight = nearbyVendorsPanelMinHeight;
    slidingPanelMaxHeight = 250;
    isDraggable = false;
    final locNotifier = ref.read(locationStateProvider.notifier);
    final mapNotifier = ref.read(mapStateProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      query.latitude =
          locNotifier.currentLocation?.latitude ?? orlandoCoordinates.latitude;
      query.longitude = locNotifier.currentLocation?.longitude ??
          orlandoCoordinates.longitude;
      query.radius = 30;
      markerIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), "assets/images/default_vendor.png");

      if (cachedMapState == null) {
        await mapNotifier.getNearbyVendors(query);
      }

      var mapState = mapNotifier;
      if (mapState is MapErrorState) {
        if (mapState.errorMessage == 'No internet connection') {
          int count = 5;
          timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
            await mapNotifier.getNearbyVendors(query);
            if (mapState is MapLoadedState || count == 0) {
              timer.cancel();
            } else {
              count--;
            }
          });
        }
      }
      if (mapState is MapLoadedState) {
        if (mounted) panelController.open();
      }
    });
  }

  @override
  void dispose() {
    if (timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, child) {
        final locationNotifier = ref.watch(locationStateProvider.notifier);
        final location = locationNotifier.getLocation();
        final userLat = location.latitude;
        final userLon = location.longitude;

        // sets the minimum height to just big enough to see the "View Menu" button
        // hopefully this works on every phone? kinda sketched out by this one ngl
        double slidingPanelSelectedVendorMinHeight =
            MediaQuery.of(context).size.height * 0.35;

        double slidingPanelNearbyVendorsMaxHeight =
            MediaQuery.of(context).size.height * 0.27;

        final mapState = ref.watch(mapStateProvider);
        if (mapState is MapLoadedState && cachedMapState == null) {
          cachedMapState = mapState;
        }
        final state = ref.watch(mapStateProvider);

        List<Marker> markers = [];
        List<Vendor> vendors = [];
        if (state is MapLoadedState) {
          vendors = state.vendors;
          if (vendors.isNotEmpty) {
            markers = vendors.map((Vendor vendor) {
              return Marker(
                icon: vendor.isOpen
                    ? BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen,
                      )
                    : BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                infoWindow: InfoWindow(
                  title: vendor.title,
                  snippet: vendor.location!.address!.street,
                ),
                onTap: () {
                  setState(() {
                    selectedVendor = vendor;
                  });
                },
                markerId: MarkerId(vendor.id),
                position: LatLng(
                  vendor.location!.latitude,
                  vendor.location!.longitude,
                ),
              );
            }).toList();
          }

          // Cache vendors
          cachedVendors = vendors;
        }
        CameraPosition userCameraPosition = CameraPosition(
          target: LatLng(userLat.toDouble(), userLon.toDouble()),
          zoom: 14.4746,
        );
        void updatePanelBuilder(String panelName) {
          setState(() {
            switch (panelName) {
              case 'vendor':
                panelBuilder = () => BuildVendorPanel(
                      selectedVendor,
                      panelController,
                      updatePanelBuilder,
                      updateSelectedVendor,
                    );
                slidingPanelMinHeight = slidingPanelSelectedVendorMinHeight;
                slidingPanelMaxHeight = 520;
                updateIsDraggable(true);
                break;
              case 'nearbyVendors':
                panelBuilder = () => BuildNearbyVendorsPanel(
                      vendors,
                      updateSelectedVendor,
                      panelController,
                      updatePanelBuilder,
                      state,
                      animateToVendor,
                    );
                slidingPanelMinHeight = nearbyVendorsPanelMinHeight;
                slidingPanelMaxHeight = slidingPanelNearbyVendorsMaxHeight;
                updateIsDraggable(false);

                break;
              default:
                panelBuilder = () => BuildNearbyVendorsPanel(
                      vendors,
                      updateSelectedVendor,
                      panelController,
                      updatePanelBuilder,
                      state,
                      animateToVendor,
                    );
                slidingPanelMinHeight = nearbyVendorsPanelMinHeight;
                slidingPanelMaxHeight = slidingPanelNearbyVendorsMaxHeight;
                updateIsDraggable(false);
            }
          });
        }

        return CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              child: Scaffold(
                body: SlidingUpPanel(
                  isDraggable: isDraggable,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  color: Theme.of(context).colorScheme.background,
                  controller: panelController,
                  minHeight: panelBuilder == null
                      ? nearbyVendorsPanelMinHeight
                      : slidingPanelMinHeight,
                  maxHeight: panelBuilder == null
                      ? MediaQuery.of(context).size.height * 0.27
                      : slidingPanelMaxHeight,
                  panelBuilder: (sc) => panelBuilder == null
                      ? BuildNearbyVendorsPanel(
                          vendors,
                          updateSelectedVendor,
                          panelController,
                          updatePanelBuilder,
                          state,
                          animateToVendor,
                        )
                      : panelBuilder!(),
                  body: GoogleMap(
                    mapToolbarEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: userCameraPosition,
                    onMapCreated: (GoogleMapController controller) {
                      _mapController.complete(controller);
                    },
                    markers: Set<Marker>.of(markers),
                    padding: const EdgeInsets.only(bottom: 175),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void animateToVendor(Vendor vendor) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(
          vendor.location!.latitude,
          vendor.location!.longitude,
        ),
      ),
    );
  }

  void updateSelectedVendor(Vendor? vendor) {
    setState(() {
      selectedVendor = vendor;
    });
  }

  void updateIsDraggable(bool draggable) {
    setState(() {
      isDraggable = draggable;
    });
  }
}
