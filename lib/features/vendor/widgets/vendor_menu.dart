import 'package:curb_companion/features/vendor/domain/menu_item.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/vendor/widgets/menu_section.dart';
import 'package:curb_companion/features/vendor/widgets/no_menu_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class VendorMenu extends ConsumerWidget {
  final Vendor vendor;
  final PanelController vendorController;
  final Map<String, double> menuCategoryPositions;
  final Function(MenuItem)? updateSelectedMenuItem;
  const VendorMenu(this.vendor, this.vendorController,
      this.menuCategoryPositions, this.updateSelectedMenuItem,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // grab all the menu items with respective types
    List<MenuItem> entreeList = _getMenuTypeList('entree', vendor);
    List<MenuItem> sideList = _getMenuTypeList('side', vendor);
    List<MenuItem> drinkList = _getMenuTypeList('drink', vendor);
    List<MenuItem> dessertList = _getMenuTypeList('dessert', vendor);
    List<MenuItem> appetizerList = _getMenuTypeList('appetizer', vendor);
    List<MenuItem> comboList = _getMenuTypeList('combo', vendor);
    List<MenuItem> mealList = _getMenuTypeList('meal', vendor);

    // Create a map of the menu titles and their respective items
    Map<String, List> menuCategories = {
      'Entrees': entreeList,
      'Sides': sideList,
      'Drinks': drinkList,
      'dessert': dessertList,
      'Appetizers': appetizerList,
      'Combos': comboList,
      'Meals': mealList,
    };

    return Column(
      children: [
        if (vendor.menu.isEmpty) NoMenuItems(vendor: vendor),
        // Loop over the menu categories and create a menu section for each
        for (var menu in menuCategories.entries)
          if (menu.value.isNotEmpty)
            Column(
              children: [
                MenuSection(menu.key, menu.value, vendorController,
                    menuCategoryPositions, updateSelectedMenuItem),
                const SizedBox(height: 30),
              ],
            ),
      ],
    );
  }
}

// Get the list of menu items for a given type
List<MenuItem> _getMenuTypeList(String type, Vendor vendor) {
  // grab menu item of type
  List<MenuItem> menuItems = vendor.menu
      .where((MenuItem item) => item.type.toLowerCase() == type)
      .toList();
  if (menuItems.isNotEmpty) {
    return menuItems;
  }
  return [];
}
