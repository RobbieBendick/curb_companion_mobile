import 'package:curb_companion/features/location/presentation/location_state_notifier.dart';
import 'package:curb_companion/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_settings/app_settings.dart';

class LocationScreen extends ConsumerWidget {
  const LocationScreen({super.key});

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
                    "Would you like to explore places near you?",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                Column(children: [
                  Image.asset('assets/images/blue_location.png'),
                  const SizedBox(height: 15),
                  const SizedBox(
                    width: 200,
                    child: Text(
                      "Start with sharing your location with us.",
                      style: TextStyle(fontSize: 17, height: 1.35),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 45,
                      child: ElevatedButton(
                        child: const Text(
                          "Continue",
                        ),
                        onPressed: () async {
                          if (context.mounted) {
                            final locationNotifier =
                                ref.watch(locationStateProvider.notifier);

                            await locationNotifier.attemptSetCurrentLocation();

                            if (locationNotifier.lastKnownLocation != null) {
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            } else {
                              await AppSettings.openAppSettings(
                                  type: AppSettingsType.location);
                              await locationNotifier
                                  .attemptSetCurrentLocation();

                              if (locationNotifier.lastKnownLocation != null &&
                                  context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 45,
                      child: ElevatedButton(
                        child: const Text(
                          "No, thanks.",
                        ),
                        onPressed: () async {
                          if (context.mounted) {
                            Navigator.pushNamed(
                              context,
                              Routes.locationServicesCancelScreen,
                            );
                          }
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
