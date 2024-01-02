import '../entity/course.dart';
import '../entity/event.dart';
import '../entity/time_booking.dart';

class CourseRepository {
  static CourseRepository instance = CourseRepository._privateConstructor();

  CourseRepository._privateConstructor() {
    // Zum testen
    _courses.add(Course(
      id: '1',
      courseName: 'Mobile Computing',
      events: [
        Event(id: 1, eventName: 'Prüfung 1', eventDateTime: DateTime(2024, 6, 1), reminderDateTime: DateTime(2024, 5, 31)),
      ],
      timeBookings: [
        TimeBooking(
            id: 1,
            startDateTime: DateTime(2024, 5, 30, 10, 0),
            endDateTime: DateTime(2024, 5, 30, 12, 0),
            courseId: '1',
            comment: 'Vorbereitung auf die Prüfung'
        ),
        TimeBooking(
            id: 2,
            startDateTime: DateTime(2024, 5, 30, 10, 0),
            endDateTime: DateTime(2024, 5, 30, 12, 0),
            courseId: '1',
            comment: 'Vorbereitung auf die Prüfung 2'
        ),
      ],
    ));
    _courses.add(Course(id: '2', courseName: 'Cloud Computing', events: [
      Event(id: 2, eventName: 'Abgabe Projektarbeit', eventDateTime: DateTime(2024, 7, 15)),
    ],
      timeBookings: [
        TimeBooking(
            id: 3,
            startDateTime: DateTime(2024, 5, 30, 10, 0),
            endDateTime: DateTime(2024, 5, 30, 12, 0),
            courseId: '2',
            comment: 'Vorbereitung auf die Prüfung'
        ),
      ],
    ));
    _courses.add(Course(id: '3', courseName: 'Transferprojekt', events: [
      Event(id: 3, eventName: 'Projektarbeit', eventDateTime: DateTime(2024, 8, 20)),
    ]));
  }

  int _getNextEventId() {
    int highestId = 0;
    for (var course in _courses) {
      for (var event in course.events) {
        if (event.id > highestId) {
          highestId = event.id;
        }
      }
    }
    return highestId + 1;
  }

  final _courses = <Course>[];

  Future<List<Course>> getCourses() async {
    return _courses;
  }

  Future<void> addCourse({required String courseName,}) async {
    print('triggered addCourse: $courseName');
    var courseId = DateTime.now().millisecondsSinceEpoch.toString();
    _courses.add(Course(id: courseId, courseName: courseName));
  }

  Future<void> deleteCourse(String courseId) async {
    _courses.removeWhere((course) => course.id == courseId);
  }

  Future<void> updateCourse({required String courseId, required String courseName}) async {
    final course = _courses.firstWhere((course) => course.id == courseId);
    course.courseName = courseName;
  }

  Future<Course> getCourseById(int courseId) async {
    return _courses.firstWhere((course) => course.id == courseId);
  }

  // Event Methoden
  // Auf Grund des Kapselung Prinzip werden die Events über die CourseRepository verwaltet

  Future<List<Event>> getEventsByCourseId(String courseId) async {
    var course = _courses.firstWhere((c) => c.id == courseId);
    return course.events;
  }

  // In CourseRepository
  Future<void> addEventToCourse(String courseId, String eventName, DateTime eventDateTime) async {
    var course = _courses.firstWhere((c) => c.id == courseId);

    int newEventId = _getNextEventId();

    Event newEvent = Event(
      id: newEventId,
      eventName: eventName,
      eventDateTime: eventDateTime,
    );

    course.events.add(newEvent);
  }


  Future<void> deleteEventFromCourse(String courseId, String eventId) async {
    var course = _courses.firstWhere((c) => c.id == courseId);
    course.events.removeWhere((event) => event.id == eventId);
  }

  Future<void> updateEventFromCourse(String courseId, Event event) async {
    var course = _courses.firstWhere((c) => c.id == courseId);
    var index = course.events.indexWhere((e) => e.id == event.id);
    course.events[index] = event;
  }

  // TimeBooking Methoden
  // Auf Grund des Kapselung Prinzip werden die TimeBooking über die CourseRepository verwaltet

  int _getNextTimeBookingId() {
    int highestId = 0;
    for (var course in _courses) {
      for (var booking in course.timeBookings) {
        if (booking.id > highestId) {
          highestId = booking.id;
        }
      }
    }
    return highestId + 1;
  }

  Future<void> addTimeBookingToCourse({
    required String courseId,
    required DateTime startDateTime,
    required DateTime endDateTime,
    String? comment,
  }) async {
    final course = _courses.firstWhere((c) => c.id == courseId);
    final newTimeBookingId = _getNextTimeBookingId();

    final newTimeBooking = TimeBooking(
      id: newTimeBookingId,
      comment: comment,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      courseId: courseId,
    );

    course.timeBookings.add(newTimeBooking);
  }

}
