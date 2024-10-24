import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/home/presentation/favorite_vendor_button.dart';
import 'package:curb_companion/features/map/presentation/build_schedule.dart';
import 'package:curb_companion/shared/presentation/draggable_rectangle.dart';
import 'package:curb_companion/utils/helpers/string_helper.dart';
import 'package:curb_companion/features/theme/app/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart' as provider;

class BuildVendorPanel extends ConsumerStatefulWidget {
  final Vendor? selectedVendor;
  final PanelController panelController;
  final Function? updatePanelBuilder;
  final Function? updateSelectedVendor;
  const BuildVendorPanel(this.selectedVendor, this.panelController,
      this.updatePanelBuilder, this.updateSelectedVendor,
      {super.key});

  @override
  BuildVendorPanelState createState() => BuildVendorPanelState();
}

class BuildVendorPanelState extends ConsumerState<BuildVendorPanel> {
  ThemeService themeService = ThemeService();
  StringHelper stringHelper = StringHelper();

  Future<void> openDirections(double latitude, double longitude) async {
    Uri googleUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Unable to open directions.';
    }
  }

  @override
  Widget build(BuildContext context) {
    Vendor? selectedVendor = widget.selectedVendor;
    double circleRadius = 50;
    double iconSize = 24;
    Widget buildCircleButton(Icon icon, String label, Function onTap) {
      return Column(
        children: [
          Container(
            width: circleRadius,
            height: circleRadius,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: provider.Provider.of<ThemeService>(context, listen: false)
                      .isDarkMode()
                  ? Color.fromARGB(255, 21, 22, 22)
                  : Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  offset: Offset(3, 3),
                  blurRadius: 10,
                ),
              ],
              border: Border.all(
                  color: Theme.of(context).iconTheme.color!, width: 1),
            ),
            child: IconButton(
              onPressed: () {
                onTap();
              },
              icon: icon,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      );
    }

    return Consumer(
      builder: (context, ref, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            color: Theme.of(context).colorScheme.background,
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const DraggableRectangle(),
                    const SizedBox(height: 25),
                    SingleChildScrollView(
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: selectedVendor!.profileImage != null
                                ? Image.network(
                                    selectedVendor.profileImage!.imageURL,
                                    fit: BoxFit.cover)
                                : Image.asset(
                                    provider.Provider.of<ThemeService>(context,
                                                listen: false)
                                            .isDarkMode()
                                        ? 'assets/images/default_vendor_dark.png'
                                        : 'assets/images/default_vendor.png',
                                  ),
                          ),
                        ),
                        title: SizedBox(
                          width: double.infinity,
                          child: Text(
                            selectedVendor.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${stringHelper.removeDecimalZero(selectedVendor.distance!.toStringAsFixed(1))} miles away"),
                            Row(
                              children: [
                                Text(
                                  selectedVendor.rating.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const Icon(Icons.star, size: 12),
                                const SizedBox(width: 5),
                                Text(
                                  "${selectedVendor.reviews.length} reviews",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Row of circular icon buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildCircleButton(
                            Icon(
                              Icons.call,
                              size: iconSize,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            "Call", () {
                          if (selectedVendor.phoneNumber != null) {
                            launchUrl(
                              Uri(
                                scheme: 'tel',
                                path: selectedVendor.phoneNumber.toString(),
                              ),
                            );
                          }
                        }),
                        buildCircleButton(
                          Icon(
                            Icons.email,
                            size: iconSize,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          "Email",
                          () {
                            if (selectedVendor.email != null) {
                              launchUrl(
                                Uri(
                                  scheme: 'mailto',
                                  path: selectedVendor.email.toString(),
                                ),
                              );
                            }
                          },
                        ),
                        buildCircleButton(
                          Icon(
                            Icons.star,
                            size: iconSize + 3,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          "Review",
                          () {
                            // Take them to Reviews Screen
                            Navigator.pushNamed(
                              context,
                              Routes.reviewVendorScreen,
                              arguments: selectedVendor,
                            );
                          },
                        ),
                        buildCircleButton(
                          Icon(
                            Icons.directions,
                            size: iconSize,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          "Directions",
                          () {
                            if (selectedVendor.location != null) {
                              openDirections(selectedVendor.location!.latitude,
                                  selectedVendor.location!.longitude);
                            }
                          },
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Container(
                                width: circleRadius,
                                height: circleRadius,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: provider.Provider.of<ThemeService>(
                                              context,
                                              listen: false)
                                          .isDarkMode()
                                      ? Color.fromARGB(255, 21, 22, 22)
                                      : Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.3),
                                      offset: Offset(3, 3),
                                      blurRadius: 10,
                                    ),
                                  ],
                                  border: Border.all(
                                      color: Theme.of(context).iconTheme.color!,
                                      width: 1),
                                ),
                                child: FavoriteVendorButton(
                                  key: Key(selectedVendor.id.toString()),
                                  isFilledIn: true,
                                  vendor: selectedVendor,
                                  size: 24,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Favorite",
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 38,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.vendorScreen,
                              arguments: selectedVendor);
                        },
                        child: const Text('View Menu'),
                      ),
                    ),
                    const SizedBox(height: 17),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    const SizedBox(height: 17),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Vendor Hours",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              if (selectedVendor.menu.isNotEmpty)
                                Text(
                                  selectedVendor.isOpen ? "Open" : "Closed",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: selectedVendor.isOpen
                                        ? Colors.green
                                        : themeService.isDarkMode()
                                            ? Theme.of(context)
                                                .colorScheme
                                                .error
                                            : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                BuildSchedule(schedule: selectedVendor.schedule)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selectedVendor.menu.isNotEmpty)
                      SizedBox(
                          width: MediaQuery.of(context).size.width * .9,
                          child: Divider(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .color!
                                .withOpacity(0.3),
                          ))
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 8,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        widget.panelController.animatePanelToPosition(0);
                        widget.updatePanelBuilder!('nearbyVendors');
                        widget.updateSelectedVendor!(null);
                      });
                    },
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
