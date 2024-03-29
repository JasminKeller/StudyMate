import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../entity/course.dart';
import '../entity/event.dart';
import '../entity/time_booking.dart';

class CourseService {

  // Service wird vom Provider aufgerufen
  // Service ruft Hive direkt auf

  static final CourseService instance = CourseService._privateConstructor();
  final Box<Course> _coursesBox = Hive.box<Course>('courses');

  CourseService._privateConstructor() {}

  int _getNextEventId(Course course) {
    int highestId = 0;
    for (var event in course.events) {
      if (event.id > highestId) {
        highestId = event.id;
      }
    }
    return highestId + 1;
  }

  Future<List<Course>> getCourses() async {
    return _coursesBox.values.toList();
  }

  Future<void> addCourse({required String courseName}) async {
    var courseId = DateTime.now().millisecondsSinceEpoch.toString();
    var newCourse = Course(id: courseId, courseName: courseName);
    await _coursesBox.put(newCourse.id, newCourse);
  }


  Future<void> deleteCourse(String courseId) async {
    await _coursesBox.delete(courseId);
  }

  Future<void> updateCourse(
      {required String courseId, required String courseName}) async {
    final course = await getCourseById(courseId);
    course.courseName = courseName;
    await _coursesBox.put(courseId, course);
  }

  Future<Course> getCourseById(String courseId) async {
    return _coursesBox.get(courseId)!; // TODO: check if null
  }

  // Event Methoden
  // Auf Grund des Kapselung Prinzip werden die Events über die CourseRepository verwaltet

  Future<List<Event>> getEventsByCourseId(String courseId) async {
    // var course = _courses.firstWhere((c) => c.id == courseId);
    final course = await getCourseById(courseId);
    return course.events;
  }

  Future<List<Event>> getEventsFromCourse(String courseId) async {
    final course = await getCourseById(courseId);
    if (course != null) {
      if (kDebugMode) {
        print('getEventsFromCourse: ${course.events}');
      }
      return course.events;
    } else {
      return [];
    }
  }

  Future<int> addEventToCourse(
    String courseId,
    String eventName,
    DateTime eventDateTime,
    DateTime? reminderDateTime,
    bool isReminderActive,
  ) async {
    //var course = _courses.firstWhere((c) => c.id == courseId);
    final course = await getCourseById(courseId);
    var newEventId = _getNextEventId(course);

    Event newEvent = Event(
      id: newEventId,
      eventName: eventName,
      eventDateTime: eventDateTime,
      reminderDateTime: reminderDateTime,
      isReminderActive: isReminderActive,
    );
    course.events.add(newEvent);
    await _coursesBox.put(courseId, course);
    return newEventId;
  }

  Future<void> deleteEventFromCourse(String courseId, int eventId) async {
    var course = await getCourseById(courseId);
    course.events.removeWhere((event) => event.id == eventId);
    await _coursesBox.put(courseId, course);
  }

  Future<void> updateEventFromCourse(String courseId, Event event) async {
    var course = await getCourseById(courseId);
    var index = course.events.indexWhere((e) => e.id == event.id);
    course.events[index] = event;
    await _coursesBox.put(courseId, course);
  }

  // TimeBooking Methoden
  // Auf Grund des Kapselung Prinzip werden die TimeBooking über die CourseRepository verwaltet

  int _getNextTimeBookingId(Course course) {
    int highestId = 0;
    for (var booking in course.timeBookings) {
      if (booking.id > highestId) {
        highestId = booking.id;
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
    final course = await getCourseById(courseId);
    final newTimeBookingId = _getNextTimeBookingId(course);

    final newTimeBooking = TimeBooking(
      id: newTimeBookingId,
      comment: comment,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      courseId: courseId,
    );
    course.timeBookings.add(newTimeBooking);
    await _coursesBox.put(courseId, course);
  }

  Future<void> deleteTimeBookingFromCourse(
      String courseId, int timeBookingId) async {
    final course = await getCourseById(courseId);
    course.timeBookings.removeWhere((booking) => booking.id == timeBookingId);
    await _coursesBox.put(courseId, course);
  }

  Future<void> updateTimeBookingInCourse({
    required int timeBookingId,
    required String courseId,
    required DateTime startDateTime,
    required DateTime endDateTime,
    String? comment,
  }) async {
    final course = await getCourseById(courseId);
    final index = course.timeBookings
        .indexWhere((booking) => booking.id == timeBookingId);

    final updatedTimeBooking = TimeBooking(
      id: timeBookingId,
      comment: comment,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      courseId: courseId,
    );

    course.timeBookings[index] = updatedTimeBooking;
    await _coursesBox.put(courseId, course);
  }
}
