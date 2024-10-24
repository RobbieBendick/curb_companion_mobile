import 'package:curb_companion/features/vendor/domain/menu_item.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/vendor/widgets/overlay_bookmark_button.dart';
import 'package:curb_companion/features/vendor/widgets/sliding_up_menu_item_panel.dart';
import 'package:curb_companion/features/vendor/widgets/sliding_up_report_vendor_menu_panel.dart';
import 'package:curb_companion/features/vendor/widgets/sliding_up_special_preferences_panel.dart';
import 'package:curb_companion/features/vendor/widgets/vendor_info_row.dart';
import 'package:curb_companion/features/vendor/widgets/vendor_menu.dart';
import 'package:curb_companion/features/vendor/widgets/vendor_menu_filter_title.dart';
import 'package:curb_companion/features/vendor/widgets/vendor_menu_report.dart';
import 'package:curb_companion/features/vendor/widgets/vendor_open_status_row.dart';
import 'package:curb_companion/features/vendor/widgets/vendor_profile_image.dart';
import 'package:curb_companion/features/vendor/widgets/vendor_title_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class VendorProfileScreen extends ConsumerStatefulWidget {
  const VendorProfileScreen({Key? key}) : super(key: key);

  @override
  VendorProfileScreenState createState() => VendorProfileScreenState();
}

class VendorProfileScreenState extends ConsumerState<VendorProfileScreen> {
  late PanelController vendorController;
  late PanelController specialPreferencesController;
  late PanelController reportPanelController;

  final ScrollController _scrollController = ScrollController();
  late MenuItem selectedMenuItem;
  bool isScrolled = false;
  late Widget appBarTitle;
  @override
  void initState() {
    selectedMenuItem = MenuItem(
      title: '',
      price: 0.0,
      description: '',
      type: '',
    );
    specialPreferencesController = PanelController();
    vendorController = PanelController();
    reportPanelController = PanelController();
    _scrollController.addListener(onScroll);
    super.initState();
  }

  int isScrolledDownHeight = 210;

  void onScroll() {
    setState(() {
      isScrolled = _scrollController.offset > isScrolledDownHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    // update the vendor's menu item modal
    void updateSelectedMenuItem(MenuItem menuItem) {
      setState(() {
        selectedMenuItem = menuItem;
      });
    }

    // Grab the vendor from the arguments passed in
    Vendor vendor = ModalRoute.of(context)!.settings.arguments as Vendor;

    // Keep track of the estimated pixels for each section
    Map<String, double> menuCategoryPositions = {
      'Entrees': 0,
      'Sides': 0,
      'Drinks': 0,
      'dessert': 0,
      'Appetizers': 0,
      'Combos': 0,
      'Meals': 0,
    };

    // Grab all the menu items with respective types
    List<MenuItem> entreeList = _getMenuTypeList('entree', vendor);
    List<MenuItem> sideList = _getMenuTypeList('side', vendor);
    List<MenuItem> drinkList = _getMenuTypeList('drink', vendor);
    List<MenuItem> dessertList = _getMenuTypeList('dessert', vendor);
    List<MenuItem> appetizerList = _getMenuTypeList('appetizer', vendor);
    List<MenuItem> comboList = _getMenuTypeList('combo', vendor);
    List<MenuItem> mealList = _getMenuTypeList('meal', vendor);

    // All categories in a list
    List<List<MenuItem>> allCategoryLists = [
      entreeList,
      sideList,
      drinkList,
      dessertList,
      appetizerList,
      comboList,
      mealList,
    ];

    // The estimated pixels from the top of the page to the first menu section
    double offset = 260;

    // Loop through all menu categories and set the estimated pixels for each section
    // We know each menu item height and how many items are in each category
    // so we can calculate the estimated pixels for each section
    for (var category in allCategoryLists) {
      if (category.isNotEmpty) {
        double menuItemHeight = 130;
        double sectionTitleHeight = 12;
        double categoryDividerHeight = 10;
        menuCategoryPositions[category[0].type] = offset;
        offset += (category.length * menuItemHeight) +
            sectionTitleHeight +
            categoryDividerHeight;
      }
    }

    // Set appbar title based on if the user has scrolled down or not
    appBarTitle = isScrolled
        ? VendorMenuFilterTitle(
            vendor, _scrollController, menuCategoryPositions)
        : Text(vendor.title);

    return Consumer(
      builder: (BuildContext context, WidgetRef ref, child) {
        return Scaffold(
          body: ScrollbarTheme(
            data: ScrollbarThemeData(
              thickness: MaterialStateProperty.all(3),
            ),
            child: CustomScrollView(
              physics: vendor.menu.isNotEmpty
                  ? null
                  : const NeverScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  surfaceTintColor: Theme.of(context).colorScheme.background,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  elevation: 3,
                  titleSpacing: 0,
                  pinned: true,
                  centerTitle: !isScrolled,
                  title: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: appBarTitle,
                  ),
                ),
                SliverFillRemaining(
                  child: Material(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          controller: _scrollController,
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  VendorProfileImage(vendor),
                                  const SizedBox(height: 5),
                                  Column(
                                    children: [
                                      VendorTitleRow(vendor),
                                      const SizedBox(height: 5),
                                      VendorInfoRow(vendor),
                                      const SizedBox(height: 5),
                                      VendorOpenStatusRow(vendor),
                                      const SizedBox(height: 20),
                                      VendorMenu(
                                        vendor,
                                        vendorController,
                                        menuCategoryPositions,
                                        updateSelectedMenuItem,
                                      ),
                                      if (vendor.menu.isNotEmpty)
                                        VendorMenuReport(
                                          panelController:
                                              reportPanelController,
                                        )
                                    ],
                                  ),
                                ],
                              ),
                              OverlayBookmarkButton(vendor: vendor)
                            ],
                          ),
                        ),
                        SlidingUpReportVendorMenuPanel(
                          context: context,
                          reportPanelController: reportPanelController,
                          vendor: vendor,
                        ),
                        SlidingUpMenuItemPanel(
                          context,
                          vendorController,
                          selectedMenuItem,
                          specialPreferencesController,
                        ),
                        SlidingUpSpecialPreferencesPanel(
                          context,
                          specialPreferencesController,
                          selectedMenuItem,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
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
