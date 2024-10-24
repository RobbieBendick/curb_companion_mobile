import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class VendorMenuReport extends StatelessWidget {
  final PanelController panelController;
  const VendorMenuReport({super.key, required this.panelController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.88,
      child: Center(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                panelController.open();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Report a menu or pricing issue",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                      decorationColor:
                          Theme.of(context).textTheme.bodyMedium!.color,
                      decorationThickness: 0.5,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.arrow_forward,
                    size: 15,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
