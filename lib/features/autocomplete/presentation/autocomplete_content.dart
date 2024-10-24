import 'package:curb_companion/features/autocomplete/presentation/autocomplete_state_notifier.dart';
import 'package:curb_companion/shared/presentation/autocomplete_row.dart';
import 'package:curb_companion/shared/presentation/powered_by_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AutocompleteContent extends ConsumerStatefulWidget {
  final TextEditingController? addressController;

  const AutocompleteContent({
    super.key,
    this.addressController,
  });

  @override
  AutocompleteContentState createState() => AutocompleteContentState();
}

class AutocompleteContentState extends ConsumerState<AutocompleteContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final autocompleteState =
        ref.watch(autocompleteStateProvider.notifier).state;
    if (autocompleteState is AutocompleteInitial) {
      return const Center(
        child: Text('Enter an address to get started!'),
      );
    } else if (autocompleteState is AutocompleteLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (autocompleteState is AutocompleteError) {
      return Center(
        child: Text(autocompleteState.errorMessage),
      );
    } else if (autocompleteState is AutocompleteLoaded &&
        autocompleteState.locations.isNotEmpty) {
      return SingleChildScrollView(
        child: Column(
          children: [
            ...(autocompleteState as AutocompleteLoaded)
                .locations
                .map((location) {
              return AutoCompleteRow(
                addressController:
                    widget.addressController ?? _searchController,
                location: location,
              );
            }),
            const PoweredByGoogle()
          ],
        ),
      );
    } else if (autocompleteState is AutocompleteLoaded &&
        (autocompleteState as AutocompleteLoaded).locations.isEmpty) {
      return const Center(
        child: Text('No results'),
      );
    } else {
      return const Center(
        child: Text('Error'),
      );
    }
  }
}
