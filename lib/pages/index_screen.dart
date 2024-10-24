import 'package:curb_companion/features/home/presentation/home_page.dart';
import 'package:curb_companion/features/map/presentation/map_screen.dart';

import 'package:curb_companion/pages/orders_page.dart';
import 'package:curb_companion/shared/presentation/build_location_panel.dart';
import 'package:curb_companion/features/discover/presentation/discover_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

/// Screen that displays whenever a user logs in. Contains the Home, Search,
/// Map, & Account settings pages.
class IndexScreen extends ConsumerStatefulWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  IndexScreenState createState() => IndexScreenState();
}

class IndexScreenState extends ConsumerState<IndexScreen> {
  int _currPageIndex = 0;
  late PanelController _panelController;
  Function? panelBuilder;
  late RangeValues currentRangeValues;
  late double panelMaxHeight;
  late PanelController acceptLocationPanelController;
  late List<Widget> _pages;
  bool _isDraggable = true;
  @override
  void initState() {
    currentRangeValues = const RangeValues(4.5, 5);
    _panelController = PanelController();
    acceptLocationPanelController = PanelController();
    panelMaxHeight = 0;
    _pages = [
      HomePage(
        openPanel: openPanel,
        updatePanelBuilder: updatePanelBuilder,
        updatePageIndex: updatePageIndex,
      ),
      // const DiscoverPage(),
      const MapPage(),
      // const OrdersPage(),
    ];
    _isDraggable = true;
    super.initState();
  }

  void updatePanelBuilder(String panelName) {
    setState(() {
      switch (panelName) {
        case "home":
          panelBuilder = () => BuildLocationPanel(
                panelController: _panelController,
              );
          panelMaxHeight = MediaQuery.of(context).size.height * 0.8;
          break;
        default:
          panelBuilder = () => BuildLocationPanel(
                panelController: _panelController,
              );
      }
    });
  }

  void openPanel() {
    _panelController.open();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Stack(
          children: [
            SlidingUpPanel(
              isDraggable: false,
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.background,
              minHeight: 0.0, // ensures the panel is closed by default
              backdropEnabled: true,
              controller: _panelController,
              panelBuilder: (sc) => panelBuilder == null
                  ? BuildLocationPanel(
                      panelController: _panelController,
                    )
                  : panelBuilder!(),
              body: Scaffold(
                body: CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  slivers: <Widget>[
                    SliverFillRemaining(
                      child: _pages[_currPageIndex],
                    ),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  onTap: updatePageIndex,
                  showUnselectedLabels: true,
                  unselectedItemColor: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.5),
                  selectedItemColor: Theme.of(context).iconTheme.color,
                  selectedLabelStyle:
                      TextStyle(color: Theme.of(context).iconTheme.color),
                  unselectedLabelStyle: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.5)),
                  currentIndex: _currPageIndex,
                  items: const [
                    BottomNavigationBarItem(
                      label: "Home",
                      icon: Icon(Icons.home),
                    ),
                    // BottomNavigationBarItem(
                    //   label: "Discover",
                    //   icon: Icon(
                    //     Icons.search,
                    //   ),
                    // ),
                    BottomNavigationBarItem(
                      label: "Map",
                      icon: Icon(
                        Icons.map,
                      ),
                    ),
                    // BottomNavigationBarItem(
                    //   icon: Icon(
                    //     Icons.shopping_bag,
                    //   ),
                    //   label: "Orders",
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void updatePageIndex(int index) {
    setState(() {
      _currPageIndex = index;
    });
  }
}
