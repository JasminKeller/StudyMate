import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studymate/screens/course_detail_screen.dart';

import '../providers/course_provider.dart';

class CourseListWidget extends StatelessWidget {
  const CourseListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    CourseProvider courseProvider = context.watch<CourseProvider>();

    return ListView.builder(
      itemCount: courseProvider.course.length,
      itemBuilder: (context, index) {
        final course = courseProvider.course[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              title: Text(course.courseName),
              trailing: const Icon(Icons.navigate_next),
              // dense: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailScreen(
                      course: course,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
