import 'package:curb_companion/features/user/presentation/user_state_notifier.dart';
import 'package:curb_companion/features/notifications/presentation/notification_state_notifier.dart';
import 'package:curb_companion/features/notifications/presentation/notification_card.dart';
import 'package:curb_companion/utils/services/rest_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends ConsumerState<NotificationScreen> {
  dynamic notificationNotifier;
  @override
  initState() {
    super.initState();
    if (ref.read(userStateProvider.notifier).user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        var user = ref.read(userStateProvider.notifier).user;
        if (user == null || user.id == null) return;

        await ref.read(notificationStateProvider.notifier).getAllNotifications(
            ref.read(userStateProvider.notifier).user!.id!);
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    notificationNotifier = ref.watch(notificationStateProvider.notifier);
    if (notificationNotifier == null) {
      return const Scaffold(body: Center(child: Text("plz login")));
    } else if (notificationNotifier.state is NotificationLoadedState) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Notifications"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: ListView.builder(
          itemCount: notificationNotifier.state.notifications.length,
          itemBuilder: (context, index) {
            return NotificationCard(
              read: notificationNotifier.state.notifications[index].read,
              description: notificationNotifier.state.notifications[index].body,
              timeAgo: notificationNotifier.state.notifications[index].age,
              onTap: () async {
                setState(() {
                  notificationNotifier.state.notifications[index].read = true;
                });

                await RestApiService.readNotification(
                    notificationNotifier.state.notifications[index].id!);
                if (!mounted) return;
                Navigator.of(context).pushNamed(
                    notificationNotifier.state.notifications[index].route);
              },
            );
          },
        ),
      );
    } else if (notificationNotifier.state is NotificationLoadingState) {
      return Scaffold(
        body: Text(notificationNotifier!.state!.toString()),
      );
    } else if (notificationNotifier.state is NotificationErrorState) {
      return Scaffold(
        body: Center(
            child: Text(notificationNotifier!.state!.errorMessage.toString())),
      );
    } else {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
}
