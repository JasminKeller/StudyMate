import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:studymate/providers/course_provider.dart';
import 'package:studymate/providers/theme_provider.dart';
import 'package:studymate/screens/course/course_management_screen.dart';
import 'package:studymate/screens/time_tracking/time_tracking_screen.dart';
import 'package:studymate/services/notification_controller.dart';
import 'package:studymate/theme/theme.dart';

import 'entity/course.dart';
import 'entity/event.dart';
import 'entity/time_booking.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Stellt sicher, dass die Flutter-Bindungen initialisiert sind.

  // Den Pfad zum Dokumentenverzeichnis holen und Hive initialisieren
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  var settingsBox = await Hive.openBox('settings');
  bool darkMode = settingsBox.get('darkMode', defaultValue: false);
  // final coursesBox = await Hive.openBox<Course>('courses');

  Hive.registerAdapter(CourseAdapter());
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(TimeBookingAdapter());

  await Hive.openBox<Course>('courses');
  await Hive.openBox<Event>('events');
  await Hive.openBox<TimeBooking>('timeBookings');

  Intl.defaultLocale = 'de_DE';
  initializeDateFormatting('de_DE', null);

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
        enableVibration: true,
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
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider(darkMode)),
        ChangeNotifierProvider(create: (context) => CourseProvider()),
      ],
      child: const MyApp(),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyMate',
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: darkMode,
      theme: lightMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de', 'DE'),
      ],
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