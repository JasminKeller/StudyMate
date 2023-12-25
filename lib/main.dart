import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studymate/providers/course_provider.dart';
import 'package:studymate/screens/home_screen.dart';
import 'package:studymate/theme/theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider<CourseProvider>(
      create: (context) => CourseProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyMate',
      theme: lightMode,
      darkTheme: darkMode,
      home: const HomeScreen(title: 'StudyMate'),
    );
  }
}
