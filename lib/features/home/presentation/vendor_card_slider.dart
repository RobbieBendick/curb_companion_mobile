import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/home/presentation/vendor_card.dart';
import 'package:flutter/material.dart';

class VendorCardSlider extends StatelessWidget {
  final List<Vendor> vendors;
  final String title;

  const VendorCardSlider({
    Key? key,
    required this.vendors,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.searchListScreen,
              arguments: {'title': title, 'vendors': vendors},
            );
          },
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          Routes.searchListScreen,
                          arguments: {'title': title, 'vendors': vendors},
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_circle_right_outlined,
                        size: 30,
                        weight: 20,
                      ),
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(.7)),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: vendors.length,
              itemBuilder: (context, index) {
                return VendorCard(
                  key: Key(vendors[index].id.toString()),
                  vendor: vendors[index],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
