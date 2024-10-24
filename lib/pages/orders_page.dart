import 'package:curb_companion/shared/presentation/order_card.dart';
import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/user/presentation/user_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  OrdersPageState createState() => OrdersPageState();
}

class OrdersPageState extends ConsumerState<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Coming soon!')));
  }

  Widget guild(BuildContext context) {
    return Consumer(
      builder: (context, WidgetRef ref, child) {
        var user = ref.watch(userStateProvider.notifier).user;
        if (user == null) {
          // if no user is logged in, display a message to prompt the user to login
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.note_outlined, size: 55),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Please ",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, Routes.authScreen);
                      },
                      child: Text(
                        "login",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                    const Text(" or ", style: TextStyle(fontSize: 16)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, Routes.registrationScreen);
                      },
                      child: Text(
                        "register",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                const Text("to view your order history.",
                    style: TextStyle(fontSize: 16))
              ],
            ),
          );
        }
        // If user is logged in, display the orders page
        return CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              surfaceTintColor: Theme.of(context).colorScheme.background,
              backgroundColor: Theme.of(context).colorScheme.background,
              actions: [
                IconButton(
                  icon: const Icon(Icons.account_circle),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.accountScreen);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.amber.shade500,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.notificationScreen);
                  },
                ),
              ],
              centerTitle: false,
              title: const Text(
                "Orders",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              elevation: 5,
            ),
            const SliverFillRemaining(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Completed",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18),
                  // for loop for each completed order
                  OrderCard(),
                  OrderCard(),
                  OrderCard(),
                  OrderCard(),
                  OrderCard(),
                ],
              ),
            )),
          ],
        );
      },
    );
  }
}
