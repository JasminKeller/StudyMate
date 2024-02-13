
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:studymate/entity/event.dart';

import '../entity/course.dart';
import '../services/course_service.dart';

class CourseProvider extends ChangeNotifier {

  // Provider wird von der UI-Komponte aufgerufen
  // Provider ruft Service auf

  // Zugriff auf die Singleton-Instanz von CourseService
  final CourseService _courseService = CourseService.instance;

  bool isLoading = false;
  List<Course> _courses = [];

  UnmodifiableListView<Course> get courses => UnmodifiableListView(_courses);


  CourseProvider() {
    loadCourses();
  }

  void loadCourses() async {
    _courses = await _courseService.getCourses();
    notifyListeners();
  }

  Future<void> addCourse({required String courseName}) async {
    await _courseService.addCourse(courseName: courseName);
    readCourseWithLoadingState();
  }


  Future<void> deleteCourse(String courseId) async {
    await _courseService.deleteCourse(courseId);
    readCourseWithLoadingState();
  }

  Future<void> updateCourse(String courseId, String courseName) async {
    await _courseService.updateCourse(courseId: courseId, courseName: courseName);
    readCourseWithLoadingState();
  }

  Future<Course>? getCourseById(String courseId) async {
    Course course  = await _courseService.getCourseById(courseId);
    readCourseWithLoadingState();
    return course ;
  }

  Future<List<Event>> getEventsByCourseId(String courseId) async {
    try {
      final List<Event> events = await _courseService.getEventsByCourseId(courseId);
      readCourseWithLoadingState();
      return events;
    } catch (e) {
      // TODO: Error handling
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
    try {
      final newEventId = await _courseService.addEventToCourse(
        courseId,
        eventName,
        eventDateTime,
        reminderDateTime,
        isReminderActive,
      );
      readCourseWithLoadingState();
      return newEventId;
    } catch (e) {
      // TODO: Error handling
      return -1;
    }
  }

  Future<void> deleteEventFromCourse(String courseId, int eventId) async {
    try {
      await _courseService.deleteEventFromCourse(courseId, eventId);
      readCourseWithLoadingState();
    } catch (e) {
      // TODO: Error handling
    }
  }

  Future<void> updateEventFromCourse(String courseId, Event event) async {
    try {
      await _courseService.updateEventFromCourse(courseId, event);
      readCourseWithLoadingState();
    } catch (e) {
      // TODO: Error handling
    }
  }


  // TimeBooking Methoden

  Future<void> addTimeBookingToCourse({
    required String courseId,
    required DateTime startDateTime,
    required DateTime endDateTime,
    String? comment,
  }) async {
    try {
      await _courseService.addTimeBookingToCourse(
        courseId: courseId,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        comment: comment,
      );
      readCourseWithLoadingState();
    } catch (e) {
      // TODO: Error handling
    }
  }

  Future<void> deleteTimeBookingFromCourse(String courseId, int timeBookingId) async {
    try {
      await _courseService.deleteTimeBookingFromCourse(courseId, timeBookingId);
      readCourseWithLoadingState();
    } catch (e) {
      // TODO: Error handling
    }
  }

  Future<void> updateTimeBookingInCourse({
    required int timeBookingId,
    required String courseId,
    required DateTime startDateTime,
    required DateTime endDateTime,
    String? comment,
  }) async {
    try {
      await _courseService.updateTimeBookingInCourse(
        timeBookingId: timeBookingId,
        courseId: courseId,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        comment: comment,
      );
      readCourseWithLoadingState();
    } catch (e) {
      // TODO: Error handling
    }
  }


  // Old Methods with loading state
  Future<void> readCourseWithLoadingState() async {
    isLoading = true;
    notifyListeners();
    _courses = await CourseService.instance.getCourses();
    isLoading = false;
    notifyListeners();
  }

  Future<void> readCourses({bool withNotifying = true}) async {
    _courses = await CourseService.instance.getCourses();

    if (withNotifying) {
      notifyListeners();
    }

  }

  Future<void> readCourse(String courseId) async {
    int index = _courses.indexWhere((course) => course.id == courseId);
    if (index != -1) {
      Course updatedCourse = await CourseService.instance.getCourseById(courseId);
      _courses[index] = updatedCourse;
      notifyListeners();
    }
  }

}