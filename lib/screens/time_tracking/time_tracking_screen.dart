import 'package:flutter/material.dart';

import '../settings_screen.dart';

class TimeTrackingScreen extends StatelessWidget {

  const TimeTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zeiterfassung'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SettingsScreen(),
              ));
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Hier kannst du die Zeit erfassen.',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
