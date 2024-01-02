
import 'package:studymate/entity/time_booking.dart';
import 'event.dart';

class Course {
  String id;
  String courseName;
  List<Event> events;
  List<TimeBooking> timeBookings;

  Course({
    required this.id,
    required this.courseName,
    List<Event>? events,
    List<TimeBooking>? timeBookings,
  }) : events = events ?? [],
        timeBookings = timeBookings ?? [];

  @override
  String toString() {
    return 'Course{id: $id, courseName: $courseName, events: $events, timeBookings: $timeBookings}';
  }
}

