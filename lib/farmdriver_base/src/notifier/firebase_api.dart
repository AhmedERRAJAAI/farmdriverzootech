import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'provider.dart';

class FirebaseApi {
  // Create an instance of firebase messaging FCM
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Initialize notifications
  Future<void> initNotification(context) async {
    // Request permission from user (will prompt the user)
    await _firebaseMessaging.requestPermission();

    // Fetch the FCM token for this device
    final String? fCMToken = await _firebaseMessaging.getToken();
    // Print the token (normally you would send this to your server)
    if (fCMToken != null) {
      await PushNotificationProvider.setPhoneKey(fCMToken);
    }

    // Configure foreground message handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Extract notification details
      final notification = message.notification;
      if (notification != null) {
        // Handle notification in the foreground
        _handleForegroundNotification(notification.title, notification.body, context);
      }
    });

    // Initialize background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

// Handle foreground notifications
  void _handleForegroundNotification(String? title, String? body, context) {
    if (title != null && body != null) {
      showDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Erreur'),
          content: const Text("content"),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
  }

  // Handle background messages
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // Extract notification details
    final notification = message.notification;
    if (notification != null) {
      // Handle background notification (e.g., show a local notification)
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: (DateTime.now().millisecondsSinceEpoch / 1111).round(),
          channelKey: "reminder_channel_key",
          title: notification.title,
          body: notification.body,
        ),
      );
    }
  }
}
