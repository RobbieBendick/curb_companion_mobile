import 'package:curb_companion/features/theme/app/theme_service.dart';
import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/home/presentation/favorite_vendor_button.dart';
import 'package:curb_companion/features/home/presentation/vendor_more_info_list_item.dart';
import 'package:curb_companion/features/map/presentation/build_schedule.dart';
import 'package:curb_companion/utils/helpers/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart' as provider;

class VendorMoreInfoScreen extends StatelessWidget {
  const VendorMoreInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // grab the arguments passed to this screen
    final Vendor vendor = ModalRoute.of(context)!.settings.arguments as Vendor;
    late Set<Marker> markers;

    markers = <Marker>{
      Marker(
        markerId: MarkerId(vendor.id),
        position: LatLng(
          vendor.location!.latitude,
          vendor.location!.longitude,
        ),
        infoWindow: InfoWindow(
          title: vendor.title,
          snippet: vendor.location!.address!.street,
        ),
      ),
    };
    Future<void> openDirections(double lat, double lon) async {
      final availableMaps = await MapLauncher.installedMaps;
      print(
          availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

      await availableMaps.first.showMarker(
        coords: Coords(lat, lon),
        title: "Curb Companion",
      );
      // Uri googleUrl = Uri.parse(
      //     'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
      // if (await canLaunchUrl(googleUrl)) {
      //   await launchUrl(googleUrl);
      // } else {
      //   throw 'Unable to open directions.';
      // }
    }

    StringHelper stringHelper = StringHelper();
    List<VendorMoreInfoListItem> listTiles = [
      VendorMoreInfoListItem(
        title: vendor.location!.address!.street ?? '',
        leadingIcon: const Icon(
          Icons.location_on_outlined,
          color: Colors.red,
        ),
        trailingIcon: Icon(
          Icons.directions_outlined,
          color: provider.Provider.of<ThemeService>(context, listen: false)
                  .isDarkMode()
              ? Colors.grey
              : Colors.black54,
        ),
        onTap: () {
          openDirections(
            vendor.location!.latitude,
            vendor.location!.longitude,
          );
        },
      ),
      VendorMoreInfoListItem(
        title: StringHelper.openText(vendor.schedule),
        leadingIcon: Icon(Icons.menu_open,
            color: vendor.isOpen ? Colors.greenAccent : Colors.redAccent),
        expandedContent: BuildSchedule(schedule: vendor.schedule),
        trailingIcon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey,
        ),
        trailingIconClose: const Icon(
          Icons.keyboard_arrow_up,
          color: Colors.grey,
        ),
      ),
      VendorMoreInfoListItem(
        title:
            "${stringHelper.removeDecimalZero(vendor.rating.toStringAsFixed(1))} (${vendor.reviews.length} ratings)",
        leadingIcon: const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        trailingIcon: null,
        onTap: () {
          Navigator.pushNamed(context, Routes.reviewVendorScreen,
              arguments: vendor);
        },
      ),
      VendorMoreInfoListItem(
          title: vendor.website?.toString() ?? '',
          leadingIcon: const Icon(Icons.language, color: Colors.blue),
          trailingIcon: const Icon(Icons.arrow_outward, color: Colors.grey),
          onTap: () {
            launchUrl(Uri.parse(vendor.website!));
          }),
      VendorMoreInfoListItem(
        title: vendor.phoneNumber?.toString() ?? '',
        leadingIcon:
            Icon(Icons.phone, color: Theme.of(context).iconTheme.color),
        trailingIcon: const Icon(Icons.arrow_outward, color: Colors.grey),
        onTap: () {
          launchUrl(Uri.parse('tel:${vendor.phoneNumber}'));
        },
        last: true,
      ),
    ];
    return Scaffold(
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: Text(vendor.title),
            backgroundColor: Theme.of(context).colorScheme.background,
            surfaceTintColor: Theme.of(context).colorScheme.background,
            elevation: 3,
            forceElevated: false,
            pinned: true,
            titleSpacing: 0,
            actions: [
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 10),
                child: FavoriteVendorButton(
                  vendor: vendor,
                  size: 25,
                  key: Key(vendor.id.toString()),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery.of(context).size.width * .9,
              height: MediaQuery.of(context).size.height * .3,
              child: GoogleMap(
                markers: markers,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    vendor.location!.latitude,
                    vendor.location!.longitude,
                  ),
                  zoom: 15,
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      if (vendor.tags.isNotEmpty)
                        const SizedBox(
                          height: 3,
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      for (VendorMoreInfoListItem listTile in listTiles)
                        listTile.title != "" ? listTile : const SizedBox(),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
