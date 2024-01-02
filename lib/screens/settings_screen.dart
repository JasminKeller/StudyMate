import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isReminderOn = false;
  TimeOfDay selectedTime = TimeOfDay(hour: 8, minute: 0);

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        // Wenn eine neue Zeit ausgewählt wird, plane die Erinnerung neu, falls der Schalter aktiviert ist
        if (isReminderOn) {
          _checkPermissionsAndScheduleNotification();
        }
      });
    }
  }

  Future<void> _checkPermissionsAndScheduleNotification() async {
    if (await Permission.scheduleExactAlarm.request().isGranted) {
      _scheduleDailyReminder();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berechtigung zum Planen genauer Alarme wurde verweigert.'),
        ),
      );
    }
  }

  void _scheduleDailyReminder() {
    DateTime now = DateTime.now();
    DateTime scheduleAlarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    if (scheduleAlarmDateTime.isBefore(now)) {
      scheduleAlarmDateTime = scheduleAlarmDateTime.add(Duration(days: 1));
    }
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Geplante Erinnerung',
        body: 'Es ist Zeit für Ihre tägliche Erinnerung!',
      ),
      schedule: NotificationCalendar.fromDate(date: scheduleAlarmDateTime),
    );
  }

  void _sendTestNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: 'Test Notification',
        body: 'This is a test notification',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Einstellungen'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Tägliche Erinnerung um ${selectedTime.format(context)}'),
            trailing: Switch(
              value: isReminderOn,
              onChanged: (bool value) {
                setState(() {
                  isReminderOn = value;
                  if (isReminderOn) {
                    _checkPermissionsAndScheduleNotification();
                  } else {
                    AwesomeNotifications().cancel(10);
                  }
                });
              },
            ),
            onTap: () {
              _selectTime(context);
            },
          ),
          ListTile(
            title: ElevatedButton(
              onPressed: _sendTestNotification,
              child: Text('Erinnerung jetzt testen'),
            ),
          ),
        ],
      ),
    );
  }
}
