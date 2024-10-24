import 'package:curb_companion/features/vendor/domain/menu_item.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorMenuFilterTitle extends ConsumerStatefulWidget {
  final Vendor vendor;
  final ScrollController _scrollController;
  final Map<String, double> menuCategoryPositions;
  const VendorMenuFilterTitle(
      this.vendor, this._scrollController, this.menuCategoryPositions,
      {Key? key})
      : super(key: key);

  @override
  VendorMenuFilterTitleState createState() => VendorMenuFilterTitleState();
}

class VendorMenuFilterTitleState extends ConsumerState<VendorMenuFilterTitle> {
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    widget._scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    widget._scrollController.removeListener(onScroll);
    super.dispose();
  }

  String findHighestValue(Map<String, double> map) {
    double maxValue = 0;
    String maxKey = '';

    map.forEach((key, value) {
      if (value > maxValue) {
        maxValue = value;
        maxKey = key;
      }
    });
    return maxKey;
  }

  void onScroll() {
    double scrollOffset = widget._scrollController.offset;

    String category = '';
    widget.menuCategoryPositions.forEach((key, value) {
      // cushion to make sure the user is in the section
      double cushion = 35;
      // if user is at the bottom of the page, highlight the last section
      if (scrollOffset >= widget._scrollController.position.maxScrollExtent) {
        category = findHighestValue(widget.menuCategoryPositions);
      }
      if (scrollOffset >= value - cushion) {
        category = key;
      }
    });

    if (selectedCategory != category) {
      setState(() {
        selectedCategory = category;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // grab all the menu items with respective types
    List<MenuItem> entreeList = _getMenuTypeList('entree', widget.vendor);
    List<MenuItem> sideList = _getMenuTypeList('side', widget.vendor);
    List<MenuItem> drinkList = _getMenuTypeList('drink', widget.vendor);
    List<MenuItem> dessertList = _getMenuTypeList('dessert', widget.vendor);
    List<MenuItem> appetizerList = _getMenuTypeList('appetizer', widget.vendor);
    List<MenuItem> comboList = _getMenuTypeList('combo', widget.vendor);
    List<MenuItem> mealList = _getMenuTypeList('meal', widget.vendor);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var list in [
            entreeList,
            sideList,
            drinkList,
            dessertList,
            appetizerList,
            comboList,
            mealList
          ])
            if (list.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    double bottomOfPage =
                        widget._scrollController.position.maxScrollExtent;
                    // moves user to the section
                    // if the section is at the bottom of the page, move to the bottom of the page
                    if (widget.menuCategoryPositions[list[0].type]! >=
                        bottomOfPage) {
                      widget._scrollController.animateTo(bottomOfPage,
                          duration: const Duration(milliseconds: 25),
                          curve: Curves.easeIn);
                    } else {
                      widget._scrollController.animateTo(
                        widget.menuCategoryPositions[list[0].type] as double,
                        duration: const Duration(milliseconds: 25),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: selectedCategory == list[0].type ? 1.0 : 0.5,
                    child: Text(
                      list[0].type.toLowerCase() != 'dessert'
                          ? '${list[0].type[0].toUpperCase() + list[0].type.substring(1).toLowerCase()}s'
                          : list[0].type[0].toUpperCase() +
                              list[0].type.substring(1).toLowerCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
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
