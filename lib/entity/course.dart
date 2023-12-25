

import 'event.dart';

class Course {
  String id;
  String courseName;
  List<Event> events = <Event>[];

  Course({
    required this.id,
    required this.courseName,
    this.events = const <Event>[],
  });

  @override
  String toString() {
    return 'Course{courseName: $courseName}';
  }
}

