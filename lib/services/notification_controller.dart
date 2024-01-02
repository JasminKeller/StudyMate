
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationController {

  // Erklärung für @pragma("vm:entry-point"):
  // Markiert die Methode als Einstiegspunkt für die VM, um zu verhindern, dass sie beim Tree Shaking entfernt wird,
  // da sie potenziell von nativem Plattformcode aufgerufen wird und nicht direkt aus dem Dart-Code.


  // Use this method to detect when a new notification is created or a sheduled notification is fired
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your Code
  }


  // Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your Code
  }


  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod (ReceivedAction receivedAction) async {
    // Your Code
  }

  // Use this method to detect when the notification is clicked
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod (ReceivedAction receivedAction) async {
    // Your Code
  }

}