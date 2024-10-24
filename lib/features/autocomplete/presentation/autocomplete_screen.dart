import 'package:curb_companion/constants/constants.dart';
import 'package:curb_companion/shared/models/query.dart';
import 'package:curb_companion/features/autocomplete/presentation/autocomplete_content.dart';
import 'package:curb_companion/features/autocomplete/presentation/autocomplete_state_notifier.dart';
import 'package:curb_companion/features/home/presentation/custom_search_text_field.dart';
import 'package:curb_companion/features/location/presentation/location_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AutocompleteScreen extends ConsumerStatefulWidget {
  const AutocompleteScreen({super.key});

  @override
  AutocompleteScreenState createState() => AutocompleteScreenState();
}

class AutocompleteScreenState extends ConsumerState<AutocompleteScreen> {
  QueryModel queryModel = QueryModel();
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    queryModel.latitude =
        ref.read(locationStateProvider.notifier).lastKnownLocation?.latitude ??
            orlandoCoordinates.latitude;
    queryModel.longitude =
        ref.read(locationStateProvider.notifier).lastKnownLocation?.latitude ??
            orlandoCoordinates.longitude;
    queryModel.radius = autocompleteMaxRadius;
    addressController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final autocompleteNotifier = ref.watch(autocompleteStateProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Address'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomSearchTextField(
                provider: autocompleteStateProvider,
                controller: addressController,
                hintText: "Search for an address",
                onChanged: (q) async {
                  setState(
                    () {
                      addressController.value = TextEditingValue(
                        text: q,
                        selection: TextSelection.fromPosition(
                          TextPosition(offset: q.length),
                        ),
                      );
                    },
                  );
                  queryModel.query = q;
                  await autocompleteNotifier.autocomplete(queryModel);
                  setState(() {});
                }),
          ),
          const SizedBox(height: 12.0),
          Divider(
            color:
                Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.15),
          ),
          AutocompleteContent(
            addressController: addressController,
          ),
        ],
      ),
    );
  }
}
