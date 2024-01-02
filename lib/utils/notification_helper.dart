import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationHelper {


  static Future<void> _checkPermissionsAndCreateNotification({
    required BuildContext context,
    required int id,
    required String title,
    required String body,
    required DateTime scheduleDateTime,
  }) async {
    if (await Permission.scheduleExactAlarm
        .request()
        .isGranted) {
      _createNotification(
          id: id, title: title, body: body, scheduleDateTime: scheduleDateTime);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Berechtigung zum Planen genauer Alarme wurde verweigert.'),
        ),
      );
    }
  }

  static void _createNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduleDateTime,
  }) {
    if (scheduleDateTime.isBefore(DateTime.now())) {
      return; // Geplante Zeit liegt in der Vergangenheit, keine Benachrichtigung erstellen
    }
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
      ),
      schedule: NotificationCalendar.fromDate(date: scheduleDateTime),
    );
  }


  // Daily Notification
  static Future<void> checkPermissionsAndScheduleDailyNotification(
      TimeOfDay selectedTime, BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime scheduleAlarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // Fügt einen Tag hinzu, wenn die geplante Zeit vor der aktuellen Zeit liegt
    if (scheduleAlarmDateTime.isBefore(now)) {
      scheduleAlarmDateTime = scheduleAlarmDateTime.add(Duration(days: 1));
    }

    await _checkPermissionsAndCreateNotification(
      context: context,
      id: 10,
      title: 'Geplante Erinnerung',
      body: 'Es ist Zeit für Ihre tägliche Erinnerung!',
      scheduleDateTime: scheduleAlarmDateTime,
    );
  }

  // Single Notification
  static Future<void> checkPermissionsAndScheduleSingleNotification({
    required int notificationId,
    required DateTime dateTime,
    required BuildContext context,
    String title = 'Einmalige Erinnerung',
    String body = 'Es ist Zeit für Ihre Erinnerung!',
  }) async {
    await _checkPermissionsAndCreateNotification(
      context: context,
      id: notificationId,
      title: title,
      body: body,
      scheduleDateTime: dateTime,
    );
  }

}