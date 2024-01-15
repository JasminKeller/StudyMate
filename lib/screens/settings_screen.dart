import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../utils/notification_helper.dart';

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
          NotificationHelper.checkPermissionsAndScheduleDailyNotification(selectedTime, context);
        }
      });
    }
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
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Tägliche Erinnerung um ${selectedTime.format(context)}'),
            trailing: IconButton(
              icon: Icon(
                isReminderOn ? Icons.notifications : Icons.notifications_off,
                color: isReminderOn ? Colors.blue : null,
              ),
              onPressed: () {
                setState(() {
                  isReminderOn = !isReminderOn;
                  if (isReminderOn) {
                    NotificationHelper.checkPermissionsAndScheduleDailyNotification(selectedTime, context);
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
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (newValue) {
                themeProvider.toggleDarkMode();
              },
            ),
          ),
          if(kDebugMode)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: _sendTestNotification,
                child: const Text('Erinnerung jetzt testen'),
              ),
            ),
        ],
      ),
    );
  }
}
