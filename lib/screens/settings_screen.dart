import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../utils/notification_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool isReminderOn;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    _loadReminderSettings();
  }

  Future<void> _loadReminderSettings() async {
    var settingsBox = Hive.box('settings');
    isReminderOn = settingsBox.get('isDailyReminderOn', defaultValue: false);
    var storedTime = settingsBox.get('dailyReminderTime', defaultValue: '08:00');
    selectedTime = _parseTime(storedTime);
    setState(() {});
  }

  TimeOfDay _parseTime(String time) {
    var parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        isReminderOn = true;
        Hive.box('settings').put('dailyReminderTime', '${selectedTime.hour}:${selectedTime.minute}');
        Hive.box('settings').put('isDailyReminderOn', isReminderOn);
        NotificationHelper.checkPermissionsAndScheduleDailyNotification(selectedTime, context);
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
    final ThemeData theme = Theme.of(context);

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
                isReminderOn ? Icons.notifications_active : Icons.notifications_off,
                color: isReminderOn ? theme.colorScheme.primary : theme.disabledColor,
              ),
              onPressed: () {
                setState(() {
                  isReminderOn = !isReminderOn;
                  Hive.box('settings').put('isDailyReminderOn', isReminderOn);
                  if (isReminderOn) {
                    NotificationHelper.checkPermissionsAndScheduleDailyNotification(selectedTime, context);
                  } else {
                    AwesomeNotifications().cancel(111111);
                    if (kDebugMode) {
                      print('Tägliche Erinnerung deaktiviert.');
                    }
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
