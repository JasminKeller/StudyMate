// Mocks generated by Mockito 5.4.4 from annotations
// in studymate/test/service/course_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:studymate/entity/course.dart' as _i2;
import 'package:studymate/entity/event.dart' as _i5;
import 'package:studymate/services/course_service.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeCourse_0 extends _i1.SmartFake implements _i2.Course {
  _FakeCourse_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [CourseService].
///
/// See the documentation for Mockito's code generation for more information.
class MockCourseService extends _i1.Mock implements _i3.CourseService {
  MockCourseService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i2.Course>> getCourses() => (super.noSuchMethod(
        Invocation.method(
          #getCourses,
          [],
        ),
        returnValue: _i4.Future<List<_i2.Course>>.value(<_i2.Course>[]),
      ) as _i4.Future<List<_i2.Course>>);

  @override
  _i4.Future<void> addCourse({required String? courseName}) =>
      (super.noSuchMethod(
        Invocation.method(
          #addCourse,
          [],
          {#courseName: courseName},
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> deleteCourse(String? courseId) => (super.noSuchMethod(
        Invocation.method(
          #deleteCourse,
          [courseId],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> updateCourse({
    required String? courseId,
    required String? courseName,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateCourse,
          [],
          {
            #courseId: courseId,
            #courseName: courseName,
          },
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<_i2.Course> getCourseById(String? courseId) => (super.noSuchMethod(
        Invocation.method(
          #getCourseById,
          [courseId],
        ),
        returnValue: _i4.Future<_i2.Course>.value(_FakeCourse_0(
          this,
          Invocation.method(
            #getCourseById,
            [courseId],
          ),
        )),
      ) as _i4.Future<_i2.Course>);

  @override
  _i4.Future<List<_i5.Event>> getEventsByCourseId(String? courseId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getEventsByCourseId,
          [courseId],
        ),
        returnValue: _i4.Future<List<_i5.Event>>.value(<_i5.Event>[]),
      ) as _i4.Future<List<_i5.Event>>);

  @override
  _i4.Future<List<_i5.Event>> getEventsFromCourse(String? courseId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getEventsFromCourse,
          [courseId],
        ),
        returnValue: _i4.Future<List<_i5.Event>>.value(<_i5.Event>[]),
      ) as _i4.Future<List<_i5.Event>>);

  @override
  _i4.Future<int> addEventToCourse(
    String? courseId,
    String? eventName,
    DateTime? eventDateTime,
    DateTime? reminderDateTime,
    bool? isReminderActive,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addEventToCourse,
          [
            courseId,
            eventName,
            eventDateTime,
            reminderDateTime,
            isReminderActive,
          ],
        ),
        returnValue: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);

  @override
  _i4.Future<void> deleteEventFromCourse(
    String? courseId,
    int? eventId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteEventFromCourse,
          [
            courseId,
            eventId,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> updateEventFromCourse(
    String? courseId,
    _i5.Event? event,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateEventFromCourse,
          [
            courseId,
            event,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> addTimeBookingToCourse({
    required String? courseId,
    required DateTime? startDateTime,
    required DateTime? endDateTime,
    String? comment,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addTimeBookingToCourse,
          [],
          {
            #courseId: courseId,
            #startDateTime: startDateTime,
            #endDateTime: endDateTime,
            #comment: comment,
          },
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> deleteTimeBookingFromCourse(
    String? courseId,
    int? timeBookingId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteTimeBookingFromCourse,
          [
            courseId,
            timeBookingId,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> updateTimeBookingInCourse({
    required int? timeBookingId,
    required String? courseId,
    required DateTime? startDateTime,
    required DateTime? endDateTime,
    String? comment,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateTimeBookingInCourse,
          [],
          {
            #timeBookingId: timeBookingId,
            #courseId: courseId,
            #startDateTime: startDateTime,
            #endDateTime: endDateTime,
            #comment: comment,
          },
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}