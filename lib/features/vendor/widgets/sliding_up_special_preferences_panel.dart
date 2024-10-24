import 'package:curb_companion/shared/presentation/custom_text_form_field.dart';
import 'package:curb_companion/features/vendor/domain/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingUpSpecialPreferencesPanel extends StatefulWidget {
  final BuildContext context;
  final PanelController panelController;
  final MenuItem? selectedMenuItem;

  const SlidingUpSpecialPreferencesPanel(
    this.context,
    this.panelController,
    this.selectedMenuItem, {
    Key? key,
  }) : super(key: key);

  @override
  State<SlidingUpSpecialPreferencesPanel> createState() =>
      _SlidingUpSpecialPreferencesPanelState();
}

class _SlidingUpSpecialPreferencesPanelState
    extends State<SlidingUpSpecialPreferencesPanel> {
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      backdropEnabled: true,
      backdropOpacity: 0.5,
      controller: widget.panelController,
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height * 0.4,
      parallaxEnabled: true,
      parallaxOffset: 0.5,
      color: Theme.of(context).cardColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      panel: _buildPanelContent(), // Use a method to build the panel content
      collapsed: Container(),
    );
  }

  Widget _buildPanelContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      child: Column(
        children: [
          const Text(
            "Add special instructions for your item.",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            hintText: "Ex: No pickles, extra ketchup, etc.",
            onChanged: (value) {},
          ),
          const SizedBox(height: 20),
          SizedBox(
              height: 38,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  onPressed: () {
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
                  child: const Text("Add instructions")))
        ],
      ),
    );
  }
}
