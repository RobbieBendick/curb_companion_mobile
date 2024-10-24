import 'package:curb_companion/features/home/presentation/favorite_state_notifier.dart';
import 'package:curb_companion/features/user/presentation/user_state_notifier.dart';
import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteVendorButton extends ConsumerStatefulWidget {
  final Vendor vendor;
  final double size;
  final Color? color;
  final bool? isFilledIn;

  const FavoriteVendorButton({
    super.key,
    required this.vendor,
    required this.size,
    this.color,
    this.isFilledIn,
  });

  @override
  FavoriteVendorButtonState createState() => FavoriteVendorButtonState();
}

class FavoriteVendorButtonState extends ConsumerState<FavoriteVendorButton> {
  @override
  Widget build(BuildContext context) {
    var userNotifier = ref.watch(userStateProvider.notifier);
    var favoriteVendors = ref.watch(favoriteStateProvider).favoriteVendorIds;

    IconData getIcon() {
      // check if the current vendor is in the list of favorite vendors
      bool isFavorite = favoriteVendors.any((id) => id == widget.vendor.id);

      // determine the icon based on the favorited status
      IconData icon = isFavorite
          ? widget.isFilledIn == true
              ? Icons.bookmark_added
              : Icons.bookmark_added_outlined
          : widget.isFilledIn == true
              ? Icons.bookmark_add
              : Icons.bookmark_add_outlined;

      return icon;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(30),
      child: Icon(
        getIcon(),
        color: widget.color ?? Theme.of(context).textTheme.bodyMedium!.color,
        size: widget.size,
      ),
      onTap: () async {
        var userID = userNotifier.user?.id;

        if (userID != null) {
          // add vendor to user's favorites
          if (userNotifier.user != null &&
              userNotifier.user?.favorites != null) {
            if (!userNotifier.user!.favorites!.contains(widget.vendor.id)) {
              await userNotifier.addFavoriteVendor(userID, widget.vendor.id);
              if (mounted) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context).iconTheme.color,
                    content: const Text("Added to favorites!",
                        style: TextStyle(color: Colors.white)),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }

              // update user's favorites
              userNotifier.user!.favorites!.add(widget.vendor.id);

              // re-render bookmark icon(s)
              // ignore: unused_result
              ref.refresh(favoriteStateProvider);
            } else {
              var success = await userNotifier.deleteFavoriteVendor(
                  userID, widget.vendor.id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text(
                      'Unfavorited...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );

                // update user's favorites
                userNotifier.user?.favorites
                    ?.removeWhere((id) => id == widget.vendor.id);

                // re-render bookmark icon(s)
                // ignore: unused_result
                ref.refresh(favoriteStateProvider);
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).iconTheme.color,
                      content: const Text(
                        'Couldn\'t unfavorite.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
              }
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(children: [
                  InkWell(
                    onTap: () =>
                        {Navigator.popAndPushNamed(context, Routes.authScreen)},
                    child: Text(
                      'Register ',
                      style:
                          TextStyle(color: Theme.of(context).iconTheme.color),
                    ),
                  ),
                  const Text('or '),
                  InkWell(
                    onTap: () =>
                        {Navigator.popAndPushNamed(context, Routes.authScreen)},
                    child: Text(
                      'login ',
                      style:
                          TextStyle(color: Theme.of(context).iconTheme.color),
                    ),
                  ),
                  const Text('to favorite this vendor.'),
                ]),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        }
      },
    );
  }
}
