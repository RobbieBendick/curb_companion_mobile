import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/home/presentation/favorite_vendor_button.dart';
import 'package:curb_companion/utils/helpers/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:curb_companion/features/theme/app/theme_service.dart';
import 'package:provider/provider.dart' as provider;

final favoriteStatusProvider =
    StateProvider.autoDispose((ref) => <int, bool>{});

class VendorCard extends ConsumerStatefulWidget {
  final Vendor vendor;
  final Function()? onTap;
  final bool? searchListView;

  const VendorCard({
    Key? key,
    required this.vendor,
    this.onTap,
    this.searchListView,
  }) : super(key: key);

  @override
  VendorCardState createState() => VendorCardState();
}

class VendorCardState extends ConsumerState<VendorCard> {
  StringHelper stringHelper = StringHelper();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var vendor = widget.vendor;
    double borderRadius = 5;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Container(
        width: widget.searchListView == true
            ? MediaQuery.of(context).size.width * 0.93
            : MediaQuery.of(context).size.width * 0.6,
        margin: const EdgeInsets.fromLTRB(0, 8, 3, 8),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          onTap: widget.onTap ??
              () => Navigator.pushNamed(
                    context,
                    Routes.vendorScreen,
                    arguments: vendor,
                  ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: widget.searchListView == true ? 160 : 120,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  image: DecorationImage(
                    image: widget.vendor.profileImage != null
                        ? NetworkImage(widget.vendor.profileImage!.imageURL)
                        : AssetImage(provider.Provider.of<ThemeService>(context,
                                        listen: false)
                                    .isDarkMode()
                                ? 'assets/images/default_vendor_dark.png'
                                : 'assets/images/default_vendor.png')
                            as ImageProvider,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        vendor.title.length > 18
                            ? '${vendor.title.substring(0, 18)}...'
                            : vendor.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      FavoriteVendorButton(
                        key: ValueKey(vendor.id.toString()),
                        vendor: vendor,
                        size: 23,
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .color!
                            .withOpacity(.7),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "${stringHelper.removeDecimalZero(vendor.distance!.toStringAsFixed(1))} mi",
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .color),
                      ),
                      const SizedBox(width: 4),
                      if (vendor.tags.isNotEmpty)
                        Text(
                          "• ",
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).textTheme.displaySmall!.color,
                          ),
                        ),
                      if (vendor.tags.isNotEmpty)
                        SizedBox(
                          width: widget.searchListView == true ? 240 : 135,
                          child: Text(
                            vendor.tags.join(", "),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .color,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2.5),
                  Row(
                    children: [
                      Text(
                        stringHelper.removeDecimalZero(
                            vendor.rating.toStringAsFixed(1)),
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .color),
                      ),
                      const SizedBox(width: 2),
                      Icon(Icons.star,
                          color:
                              Theme.of(context).textTheme.displaySmall!.color,
                          size: 14),
                      const SizedBox(width: 2),
                      Text(
                        "(${vendor.reviews.length})",
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.displaySmall!.color,
                            fontSize: 14),
                      )
                    ],
                  ),
                ]),
              ),
              if (widget.searchListView == true)
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Divider(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                    thickness: 1.5,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
