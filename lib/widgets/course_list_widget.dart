import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../services/course_respository.dart';
import 'delete_icon_widget.dart';

class CourseListWidget extends StatelessWidget {
  const CourseListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    CourseProvider courseProvider = context.watch<CourseProvider>();

    return ListView.builder(
      itemCount: courseProvider.courses.length,
      itemBuilder: (context, index) {
        final course = courseProvider.courses[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              title: Text(course.courseName),
            ),
          ),
        );
      },
    );
  }
}
