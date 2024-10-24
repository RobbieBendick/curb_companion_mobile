import 'package:curb_companion/features/getting_started/presentation/theme_drop_down_button.dart';
import 'package:curb_companion/features/user/presentation/user_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Account'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('You are about to delete your account PERMANENTLY.'),
                  Text('Are you sure you want to do this?'),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('Yes'),
                onPressed: () async {
                  if (await ref
                      .watch(userStateProvider.notifier)
                      .deleteUser()) {
                    if (!mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
            ],
          );
        },
      );
    }

    return Consumer(
      builder: (context, WidgetRef ref, child) {
        return Material(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(context).colorScheme.background,
                surfaceTintColor: Theme.of(context).colorScheme.background,
                elevation: 3,
                forceElevated: false,
                pinned: true,
                title: const Text("Settings"),
                titleSpacing: 0,
              ),
              SliverFillRemaining(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    const ListTile(
                      title: Text("Dark Mode"),
                      trailing: ThemeDropDownButton(),
                    ),
                    if (ref.watch(userStateProvider.notifier).user != null)
                      ListTile(
                          title: const Text("Delete Account"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () => _showMyDialog(),
                          )),

                    // ref.read(userStateProvider.notifier).user != null
                    //     ? ListTile(
                    //         title: const Text("Notifications"),
                    //         onTap: () {
                    //           Navigator.of(context)
                    //               .pushNamed(Routes.notificationScreen);
                    //         },
                    //       )
                    //     : Container(),
                    // ListTile(
                    //   title: const Text("Privacy"),
                    //   onTap: () async {
                    //     launchUrlInWebView('https://example.com');
                    //   },
                    // ),
                    // ListTile(
                    //   title: const Text("About"),
                    //   onTap: () async {
                    //     launchUrlInWebView('https://example.com');
                    //   },
                    // ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
