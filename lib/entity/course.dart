

import 'event.dart';

class Course {
  String id;
  String courseName;
  List<Event> events;

  Course({
    required this.id,
    required this.courseName,
    List<Event>? events,
  }) : events = events ?? [];

  @override
  String toString() {
    return 'Course{courseName: $courseName}';
  }
}

