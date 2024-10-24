import 'package:curb_companion/features/location/presentation/location_state_notifier.dart';
import 'package:curb_companion/features/theme/app/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_settings/app_settings.dart';
import 'package:provider/provider.dart' as provider;

class LocationCancelScreen extends ConsumerWidget {
  const LocationCancelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(builder: (context, WidgetRef ref, child) {
      return Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const Text(
                    "We'll set your location to our default Orlando, Florida which is where we're most prominent.",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                Column(children: [
                  Image.asset(
                      provider.Provider.of<ThemeService>(context, listen: false)
                              .isDarkMode()
                          ? 'assets/images/arrow_pointing_to_location_dark.png'
                          : 'assets/images/arrow_pointing_to_location.png'),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .8,
                    child: const Text(
                      "To change your location, just tap on the location bar on the top of the home page and type your address in or stream your location!",
                      style: TextStyle(fontSize: 19, height: 1.35),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 45,
                      child: ElevatedButton(
                        child: const Text(
                          "Continue",
                        ),
                        onPressed: () {
                          // go back to the location settings page
                          Navigator.pop(context);

                          // move on to next element of the stack
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ]),
        ),
      );
    });
  }
}
