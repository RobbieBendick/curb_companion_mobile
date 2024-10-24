import 'package:curb_companion/features/location/domain/cc_location.dart';
import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/autocomplete/presentation/autocomplete_state_notifier.dart';
import 'package:curb_companion/features/home/presentation/home_state_notifier.dart';
import 'package:curb_companion/features/location/presentation/location_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AutoCompleteRow extends ConsumerStatefulWidget {
  final dynamic location;
  final TextEditingController addressController;
  const AutoCompleteRow({
    super.key,
    required this.addressController,
    this.location,
  });

  @override
  AutoCompleteRowState createState() => AutoCompleteRowState();
}

class AutoCompleteRowState extends ConsumerState<AutoCompleteRow> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: InkWell(
          onTap: () {
            _showConfirmationDialog(context, widget.location);
          },
          child: SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              children: [
                const Icon(
                  Icons.location_pin,
                  color: Colors.redAccent,
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.location.address!.street ?? '',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${widget.location.address?.city}, ${widget.location.address?.state}, ${widget.location.address?.postalCode}",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, CCLocation location) {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text(
            'Save this address?',
            textAlign: TextAlign.center,
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 70,
                height: 30,
                child: ElevatedButton(
                  onPressed: () async {
                    await ref
                        .watch(locationStateProvider.notifier)
                        .updateCurrentLocation(location);
                    widget.addressController.clear();
                    // close the keyboard
                    // refresh the page and state
                    if (!mounted) return;
                    ref.invalidate(autocompleteStateProvider);
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.homeScreen, (route) => false);

                    ref.watch(homeStateProvider.notifier).getHomeSections(ref
                        .watch(locationStateProvider.notifier)
                        .lastKnownLocation!);
                    setState(() {});
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                  width: 16), // Adding some space between the buttons
              SizedBox(
                width: 70,
                height: 30,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
