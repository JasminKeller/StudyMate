
import 'package:hive/hive.dart';
import 'package:studymate/entity/time_booking.dart';
import 'event.dart';
part 'course.g.dart';

@HiveType(typeId: 0)
class Course extends HiveObject{

  @HiveField(0)
  String id;

  @HiveField(1)
  String courseName;

  @HiveField(2)
  List<Event> events;

  @HiveField(3)
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

