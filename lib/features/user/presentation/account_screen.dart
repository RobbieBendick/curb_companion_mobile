import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/user/domain/user.dart';
import 'package:curb_companion/features/user/presentation/user_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(userStateProvider.notifier);
    User? user = ref.watch(userStateProvider.notifier).user;
    final userProvider = ref.watch(userStateProvider.notifier);

    if (state is LoggedIn) {
      user = state.user;
    }
    return Material(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          surfaceTintColor: Theme.of(context).colorScheme.background,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: ListView(
          children: [
            if (user != null && user.profileImage != null)
              CircleAvatar(
                radius: 110, // Adjust the radius as needed
                backgroundImage: NetworkImage(
                  user.profileImage!.imageURL,
                ),
                backgroundColor: Colors.transparent,
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0, 16),
              child: Text(
                "Account",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ListBody(
              children: [
                ListTile(
                  leading: const Icon(Icons.restaurant_menu),
                  title: const Text("Catering Request"),
                  onTap: () => {
                    Navigator.pushNamed(context, Routes.cateringRequestScreen),
                  },
                  trailing: const Icon(Icons.keyboard_arrow_right),
                ),
              ],
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(context).dividerColor,
            ),
            // Account Settings
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
              child: Text(
                "Account Settings",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ListBody(
              mainAxis: Axis.vertical,
              children: [
                // Settings page
                Material(
                  child: ListTile(
                    title: const Text("Settings"),
                    subtitle: Text(
                      "Change your account settings",
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.settingsScreen),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                ),
              ],
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(context).dividerColor,
            ),
            // More
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
              child: Text(
                "More",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ListBody(
              mainAxis: Axis.vertical,
              children: [
                // About page
                Material(
                  child: ListTile(
                    title: const Text("Privacy Policy"),
                    onTap: () async {
                      const url = 'https://curbcompanion.com/privacy-policy';
                      if (await canLaunchUrlString(url)) {
                        await launchUrlString(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                ),
                Divider(
                  indent: 16,
                  height: 1,
                  thickness: .5,
                  color: Theme.of(context).dividerColor,
                ),
                // Legal page
                Material(
                  child: ListTile(
                    title: const Text("Terms of Service"),
                    onTap: () async {
                      const url =
                          'https://curbcompanion.com/terms-and-conditions';
                      if (await canLaunchUrlString(url)) {
                        await launchUrlString(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                ),
                Divider(
                  indent: 16,
                  height: 1,
                  thickness: .5,
                  color: Theme.of(context).dividerColor,
                ),
                Material(
                  child: ListTile(
                    onTap: () async {
                      if (userProvider.user != null) {
                        await userProvider.logout();
                        if (!mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.authScreen,
                          (route) => false,
                        );
                      } else {
                        if (!mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.authScreen,
                          (route) => false,
                        );
                      }
                    },
                    title: userProvider.user == null
                        ? const Text("Login")
                        : const Text("Logout"),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
