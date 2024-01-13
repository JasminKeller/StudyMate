import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studymate/providers/course_provider.dart';
import 'package:studymate/screens/course/course_management_screen.dart';
import 'package:studymate/screens/time_tracking/time_tracking_screen.dart';
import 'package:studymate/services/notification_controller.dart';
import 'package:studymate/theme/theme.dart';

void main() async {
  await AwesomeNotifications().initialize(
    null,  // for notification icon if a special one is needed
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        // defaultColor: Colors.teal,
        // ledColor: Colors.teal,
        // playSound: true,
        // enableVibration: true,
      )
    ],
    channelGroups: [
      NotificationChannelGroup(channelGroupKey: "basic_channel_group", channelGroupName: "Basic Group")
    ]
  );
  bool isAllowedToSendNotification = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
  runApp(
    ChangeNotifierProvider<CourseProvider>(
      create: (context) => CourseProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyMate',
      theme: lightMode,
      darkTheme: darkMode,
      home: BottomNavigation(),
    );
  }
}


class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 1;

  final List<Widget> _screens = [
    const CourseManagementScreen(title: 'Kursverwaltung'),
    const TimeTrackingScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkCourses();
  }

  void _checkCourses() async {
    CourseProvider courseProvider = Provider.of<CourseProvider>(context, listen: false);
    await courseProvider.readCourses();
    if (courseProvider.courses.isEmpty) {
      setState(() {
        _currentIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Kursverwaltung',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Zeiterfassung',
          ),
        ],
      ),
    );
  }
}