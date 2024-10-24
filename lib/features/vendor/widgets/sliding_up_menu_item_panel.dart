import 'package:curb_companion/features/vendor/domain/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingUpMenuItemPanel extends StatefulWidget {
  final BuildContext context;
  final PanelController panelController;
  final MenuItem? selectedMenuItem;
  final PanelController specialPreferencesController;

  const SlidingUpMenuItemPanel(
    this.context,
    this.panelController,
    this.selectedMenuItem,
    this.specialPreferencesController, {
    Key? key,
  }) : super(key: key);

  @override
  State<SlidingUpMenuItemPanel> createState() => _SlidingUpMenuItemPanelState();
}

class _SlidingUpMenuItemPanelState extends State<SlidingUpMenuItemPanel> {
  int _counter = 1;
  @override
  initState() {
    _counter = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      backdropEnabled: true,
      backdropOpacity: 0.5,
      controller: widget.panelController,
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height * 0.8,
      parallaxEnabled: true,
      parallaxOffset: 0.5,
      color: Theme.of(context).colorScheme.background,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      panel: _buildPanelContent(),
      collapsed: Container(),
    );
  }

  Widget _buildPanelContent() {
    double imageHeight = 200;
    // TODO: ??
    // int maxDescriptionLength = 200;

    double priceWithQuantity = widget.selectedMenuItem!.price! * _counter;

    // Build the panel content based on the selected menu item
    if (widget.selectedMenuItem != null) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: SizedBox(
          height: MediaQuery.of(widget.context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: imageHeight,
                    width: MediaQuery.of(widget.context).size.width,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      child: widget.selectedMenuItem!.image?.imageURL != null
                          ? Image.network(
                              widget.selectedMenuItem!.image!.imageURL,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/default_menu_item.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    left: 5,
                    child: GestureDetector(
                      onTap: () {
                        widget.panelController.close();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 22,
                            ),
                            onPressed: () {
                              widget.panelController.close();
                            },
                          )),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
                      child: Text(
                        widget.selectedMenuItem!.title,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                      child: Text(
                        widget.selectedMenuItem!.description != null
                            ? widget.selectedMenuItem!.description!
                            : "",
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Divider(
                        thickness: 6,
                        color: Theme.of(widget.context)
                            .dividerColor
                            .withOpacity(0.12),
                        height: 45),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                          child: Center(
                            child: SizedBox(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Preferences",
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: const Text(
                                          'Optional',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  GestureDetector(
                                    onTap: () {
                                      widget.specialPreferencesController
                                          .open();
                                    },
                                    child: Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                              "Add special instructions"),
                                          Icon(Icons.arrow_forward_ios,
                                              size: 16.0,
                                              color: Theme.of(widget.context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .color),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 6,
                          color: Theme.of(widget.context)
                              .dividerColor
                              .withOpacity(0.12),
                          height: 45,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                  offset: Offset(4, 4),
                                  blurRadius: 15,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            width: 150,
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.remove,
                                        color: _counter > 1
                                            ? Colors.black
                                            : Colors.grey),
                                    onPressed: () {
                                      setState(() {
                                        if (_counter > 1) {
                                          _counter--;
                                        }
                                      });
                                    }),
                                Text(_counter.toString(),
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black)),
                                IconButton(
                                    disabledColor: Colors.grey,
                                    icon: const Icon(Icons.add,
                                        color: Colors.black),
                                    onPressed: () {
                                      setState(() {
                                        _counter++;
                                      });
                                    })
                              ],
                            ))
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(16),
                      height: 73,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  Theme.of(context).iconTheme.color,
                              content: const Text(
                                'This feature is coming soon!',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _counter < 2
                                  ? 'Add to cart'
                                  : 'Add $_counter to cart',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              "\$${priceWithQuantity.toStringAsFixed(2)}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
