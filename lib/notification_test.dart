import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import 'core/notification_controller.dart';

class NotificationTest extends StatefulWidget {
  const NotificationTest({super.key});

  @override
  State<NotificationTest> createState() => _NotificationTestState();
}

class _NotificationTestState extends State<NotificationTest> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceived,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: OutlinedButton(
          child: const Text("Notify"),
          onPressed: () {
            AwesomeNotifications().createNotification(
              content: NotificationContent(
                id: 1,
                channelKey: "reminder_channel_key",
                title: "Hello from notifications",
                body: "Yay! I have a just received a notification",
              ),
              schedule: NotificationCalendar(
                year: 2024,
                month: 8,
                day: 21,
                hour: 17,
                minute: 7,
                second: 0,
                millisecond: 0,
                repeats: false,
              ),
            );
          },
        ),
      ),
    );
  }
}
