import 'package:firebase_messaging/firebase_messaging.dart';

import 'provider.dart';

class FirebaseApi {
  // Create an instance of firebase messaging FCM
  final _firebaseMessaging = FirebaseMessaging.instance;
  // Initialize notifications
  Future<void> initNotification() async {
    // request permission from user (will prompt the user)
    await _firebaseMessaging.requestPermission();

    //fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();
    //print the token (normally you would send this to your server)
    await PushNotificationProvider.setPhoneKey(fCMToken);
  }

  // Handle received messages

  // handle foreground and background settings
}
