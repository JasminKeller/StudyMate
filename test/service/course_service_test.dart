import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:studymate/entity/event.dart';
import 'package:studymate/services/course_service.dart';
import 'package:studymate/entity/course.dart';

import 'course_service_test.mocks.dart';

@GenerateMocks([CourseService])
void main() {
  late MockCourseService courseService;

  setUpAll(() {
    courseService = MockCourseService();
  });

  group('CourseService Test', () {
    test('test getCourses', () async {
      final courses = [Course(id: '111', courseName: 'Math')];
      when(courseService.getCourses()).thenAnswer((_) async => courses);

      final result = await courseService.getCourses();

      expect(result, isA<List<Course>>());
      expect(result, equals(courses));
    });

    test('test addCourse', () async {
      const courseName = 'New Math Course';
      when(courseService.addCourse(courseName: anyNamed('courseName')))
          .thenAnswer((_) async => {});

      await courseService.addCourse(courseName: courseName);

      verify(courseService.addCourse(courseName: courseName)).called(1);
    });

    test('test deleteCourse', () async {
      const courseId = '111';
      when(courseService.deleteCourse(courseId)).thenAnswer((_) async => {});

      await courseService.deleteCourse(courseId);

      verify(courseService.deleteCourse(courseId)).called(1);
    });

  });

  group('EventService Test', () {

    test('test addEventToCourse', () async {
      const courseId = '222';
      const eventName = 'Math Test 222';
      final eventDateTime = DateTime.now();
      final reminderDateTime = DateTime.now().add(const Duration(days: 1));
      const isReminderActive = false;

      const newEventId = 1;
      when(courseService.addEventToCourse(
        courseId,
        eventName,
        eventDateTime,
        reminderDateTime,
        isReminderActive,
      )).thenAnswer((_) async => newEventId);

      final resultId  = await courseService.addEventToCourse(
        courseId,
        eventName,
        eventDateTime,
        reminderDateTime,
        isReminderActive,
      );

      verify(courseService.addEventToCourse(
        courseId,
        eventName,
        eventDateTime,
        reminderDateTime,
        isReminderActive,
      )).called(1);

      expect(resultId , equals(newEventId));
    });


    test('test getEventsByCourseId', () async {
      const courseId = '111';
      final events = [Event(id: 111, eventName: 'Math Test 111', eventDateTime: DateTime.now())];
      when(courseService.getEventsByCourseId(courseId))
          .thenAnswer((_) async => events);

      final result = await courseService.getEventsByCourseId(courseId);

      expect(result, isA<List<Event>>());
      expect(result, equals(events));
    });

  });

  test('test updateEventFromCourse', () async {
    const courseId = '111';
    final event = Event(id: 111, eventName: 'Math Test 111', eventDateTime: DateTime.now());
    when(courseService.updateEventFromCourse(courseId, event)).thenAnswer((_) async => {});

    await courseService.updateEventFromCourse(courseId, event);

    verify(courseService.updateEventFromCourse(courseId, event)).called(1);
  });

  test('test deleteEventFromCourse', () async {
    const courseId = '111';
    const eventId = 111;
    when(courseService.deleteEventFromCourse(courseId, eventId)).thenAnswer((_) async => {});

    await courseService.deleteEventFromCourse(courseId, eventId);

    verify(courseService.deleteEventFromCourse(courseId, eventId)).called(1);
  });


}
