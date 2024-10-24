import 'package:curb_companion/features/vendor/domain/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MenuItemCard extends StatefulWidget {
  final MenuItem menuItem;
  final PanelController vendorController;
  final bool? isLast;
  final Function(MenuItem)? updateSelectedMenuItem;
  const MenuItemCard(
      {super.key,
      required this.menuItem,
      required this.vendorController,
      this.isLast,
      this.updateSelectedMenuItem});

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  bool _isTappedDown = false;
  @override
  Widget build(BuildContext context) {
    double cardHeight = 110;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                InkWell(
                  onTapDown: (details) {
                    setState(() {
                      _isTappedDown = true;
                    });
                  },
                  onTapUp: (details) {
                    setState(() {
                      _isTappedDown = false;
                    });
                  },
                  onTap: () {
                    widget.vendorController.open();
                    widget.updateSelectedMenuItem!(widget.menuItem);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isTappedDown
                          ? Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0.5)
                          : Theme.of(context).colorScheme.background,
                    ),
                    height: cardHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 14),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  widget.menuItem.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 5),
                              if (widget.menuItem.description != null &&
                                  widget.menuItem.description!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: SizedBox(
                                    width: 200,
                                    height: 30,
                                    child: Text(
                                      widget.menuItem.description ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  "\$${widget.menuItem.price!.toStringAsFixed(2)}",
                                  style: const TextStyle(fontSize: 12.5),
                                ),
                              ),
                              if (widget.isLast == false ||
                                  widget.isLast == null)
                                const SizedBox(height: 10)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0, top: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: SizedBox(
                              width: 130,
                              child: widget.menuItem.image != null
                                  ? Image.network(
                                      widget.menuItem.image!.imageURL,
                                      fit: BoxFit.cover,
                                      height: cardHeight - 20,
                                    )
                                  : Image.asset(
                                      'assets/images/default_menu_item.png',
                                      fit: BoxFit.cover,
                                      height: cardHeight - 20,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 7,
                  right: 12,
                  child: Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,
                      icon:
                          const Icon(Icons.add, size: 17, color: Colors.black),
                      color: Colors.black,
                      onPressed: () {
                        // add to cart when pressed when we have a cart
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Theme.of(context).iconTheme.color,
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
                    ),
                  ),
                ),
              ],
            ),
            widget.isLast == false || widget.isLast == null
                ? Divider(
                    height: 1,
                    thickness: 2,
                    color: Theme.of(context).dividerColor.withOpacity(0.03),
                  )
                : Divider(
                    height: 2,
                    color: Colors.grey.withOpacity(0.3),
                    thickness: 5,
                  ),
          ],
        ),
      ],
    );
  }
}
