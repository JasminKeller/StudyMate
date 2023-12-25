import 'package:flutter/material.dart';
import '../entity/course.dart';
import '../providers/course_provider.dart';
import 'package:provider/provider.dart';

class EventListWidget extends StatelessWidget {

  final Course course;

  const EventListWidget({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    CourseProvider courseProvider = context.watch<CourseProvider>();

    return ListView.builder(
      itemCount: course.events.length,
      itemBuilder: (context, index) {
        final event = course.events[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              title: Text(event.eventName),
              trailing: IconButton(
                icon: const Icon(Icons.notifications_off),
                onPressed: () {
                  // TODO: Calendar Popup
                },
              ),
              // dense: true,
            ),
          ),
        );
      },
    );
  }
}