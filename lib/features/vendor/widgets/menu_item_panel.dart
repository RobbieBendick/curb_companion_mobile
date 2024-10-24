import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MenuItemPanel extends StatelessWidget {
  final PanelController vendorController;
  const MenuItemPanel({super.key, required this.vendorController});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          color: Theme.of(context).colorScheme.background),
      child: Stack(
        children: [
          Image.network('https://source.unsplash.com/random/150x150'),
          Positioned(
            left: 10,
            top: 10,
            child: IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () => {vendorController.close()},
            ),
          ),
        ],
      ),
    ));
  }
}
