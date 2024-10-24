import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingUpReportVendorMenuPanel extends StatefulWidget {
  late BuildContext context;
  late PanelController reportPanelController;
  late Vendor vendor;

  SlidingUpReportVendorMenuPanel(
      {super.key,
      required this.context,
      required this.reportPanelController,
      required this.vendor});

  @override
  State<SlidingUpReportVendorMenuPanel> createState() =>
      _SlidingUpReportVendorMenuPanelState();
}

class _SlidingUpReportVendorMenuPanelState
    extends State<SlidingUpReportVendorMenuPanel> {
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      backdropEnabled: true,
      backdropOpacity: 0.5,
      controller: widget.reportPanelController,
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height * 0.4,
      parallaxEnabled: true,
      parallaxOffset: 0.5,
      color: Theme.of(context).cardColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      panel: Material(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: _buildPanelContent(context)),
      collapsed: Container(),
    );
  }
}

Widget _buildPanelContent(BuildContext context) {
  return Material(
    borderRadius: const BorderRadius.all(
      Radius.circular(15),
    ),
    child: Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Report a menu issue",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Divider(
            // Divider under the "Report a menu issue" text
            thickness: 1,
            color: Colors.grey.withOpacity(0.35),
            height: 30,
          ),
          const SizedBox(height: 10),
          const Text(
            "Description",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          const TextField(
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "This issue will be shared with the store.",
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement action when submit button is pressed
              },
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
    ),
  );
}
