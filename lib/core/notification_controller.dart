import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationController {
  //use this method to detect when a new notification is scheduled
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receiveNotification) async {}

  //use this method to detect every time a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receiveNotification) async {
    // FlutterRingtonePlayer().play(
    //   android: AndroidSounds.notification,
    //   ios: IosSounds.glass,
    // );
  }

  //use this method to detect every time a notification is dismissed
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceived(ReceivedAction receiveAction) async {
    // FlutterRingtonePlayer().stop();
  }

  //use this method to detect every time a notification is clicked
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receiveAction) async {}
}
