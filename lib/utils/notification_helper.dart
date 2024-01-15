import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    } else {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'basic_channel',
          title: title,
          body: body,
        ),
        schedule: NotificationCalendar.fromDate(date: scheduleDateTime),
      );
      if (kDebugMode) {
        print('Benachrichtigung erstellt für $title um ${DateFormat('dd.MM.yyyy HH:mm').format(scheduleDateTime)}.');
      }
    }
  }


  // Daily Notification
  static Future<void> checkPermissionsAndScheduleDailyNotification(
      TimeOfDay selectedTime, BuildContext context) async {
    if (await Permission.notification.request().isGranted) {
      scheduleDailyReminderNotification(selectedTime);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Berechtigung für Benachrichtigungen wurde verweigert.'),
        ),
      );
    }
  }

  // Daily Notification
  static void scheduleDailyReminderNotification(TimeOfDay selectedTime) {
    DateTime now = DateTime.now();
    DateTime firstInstance = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);

    // Wenn die erste Instanz in der Vergangenheit liegt, fangen Sie morgen an.
    if (firstInstance.isBefore(now)) {
      firstInstance = firstInstance.add(const Duration(days: 1));
    }

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 111111,
        channelKey: 'basic_channel',
        title: 'Tägliche Erinnerung',
        body: 'Es ist Zeit für Ihre tägliche Erinnerung!',
      ),
      schedule: NotificationCalendar(
        year: firstInstance.year,
        month: firstInstance.month,
        day: firstInstance.day,
        hour: firstInstance.hour,
        minute: firstInstance.minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );

    if (kDebugMode) {
      print('Tägliche Erinnerung geplant für ${DateFormat('dd.MM.yyyy HH:mm').format(firstInstance)}.');
    }
  }

  // Single Notification
  static Future<void> checkPermissionsAndScheduleSingleNotification({
    required int notificationId,
    required DateTime dateTime,
    required BuildContext context,
    required String title,
  }) async {
    await _checkPermissionsAndCreateNotification(
      context: context,
      id: notificationId,
      title: 'Erinnerung für $title',
      body: 'Erinnerung für $title ist geplant für ${DateFormat('dd.MM.yyyy HH:mm').format(dateTime)}.',
      scheduleDateTime: dateTime,
    );
    if (kDebugMode) {
      print('Erinnerung für Event $title und notificationID $notificationId geplant für ${DateFormat('dd.MM.yyyy HH:mm').format(dateTime)}.');
    }
  }

}