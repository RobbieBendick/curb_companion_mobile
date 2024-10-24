import 'package:curb_companion/features/vendor/domain/menu_item.dart';
import 'package:curb_companion/features/vendor/widgets/menu_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MenuSection extends ConsumerWidget {
  final List sectionVendors;
  final String sectionTitle;
  final Map<String, double> menuCategoryPositions;
  final Function(MenuItem)? updateSelectedMenuItem;

  final PanelController vendorController;

  const MenuSection(
      this.sectionTitle,
      this.sectionVendors,
      this.vendorController,
      this.menuCategoryPositions,
      this.updateSelectedMenuItem,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                sectionTitle[0].toUpperCase() + sectionTitle.substring(1),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < sectionVendors.length; i++)
          MenuItemCard(
            menuItem: sectionVendors[i],
            vendorController: vendorController,
            updateSelectedMenuItem: updateSelectedMenuItem,
            isLast: i == sectionVendors.length - 1,
          )
      ],
    );
  }
}
