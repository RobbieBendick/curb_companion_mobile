import 'package:curb_companion/features/home/presentation/location_appbar_title.dart';
import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/home/presentation/custom_search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExtendedSliverAppbarWithActions extends ConsumerWidget {
  final Function openPanel;
  final Function updatePanelBuilder;
  const ExtendedSliverAppbarWithActions(this.openPanel, this.updatePanelBuilder,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      flexibleSpace: FlexibleSpaceBar(
        background: Container(color: Theme.of(context).colorScheme.background),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
            height: 69,
            padding: const EdgeInsets.only(top: 10.0, bottom: 15),
            child: Hero(
              tag: "search",
              child: CustomSearchTextField(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.heroSearchScreen,
                  );
                },
              ),
            )),
      ),
      pinned: true,
      centerTitle: false,
      title: LocationAppbarTitle(updatePanelBuilder, openPanel),
      actions: [
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () async {
            Navigator.pushNamed(context, Routes.accountScreen);
          },
        ),
        // ref.read(userStateProvider.notifier).user != null
        //     ? IconButton(
        //         icon: Icon(
        //           Icons.notifications,
        //           color: Colors.amber.shade500, // yellow
        //         ),
        //         onPressed: () {
        //           Navigator.pushNamed(context, Routes.notificationScreen);
        //         },
        //       )
        //     : Container()
      ],
    );
  }
}
