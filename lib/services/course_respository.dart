import '../entity/course.dart';
import '../entity/event.dart';

class CourseRepository {
  static CourseRepository instance = CourseRepository._privateConstructor();
  CourseRepository._privateConstructor() {
    _courses.add(Course(id: '1', courseName: 'Mobile Computing', events: [
      Event(id: '55555', eventName: 'Prüfung 1'),
    ]));
    _courses.add(Course(id: '2', courseName: 'Coud Computing', events: [
      Event(id: '55555', eventName: 'Abgabe Projektarbeit'),
    ]));
    _courses.add(Course(id: '2', courseName: 'Transferprojekt', events: [
      Event(id: '55555', eventName: 'Projektarbeit'),
    ]));

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

  Future<void> addEventToCourse(String courseId, Event event) async {
    var course = _courses.firstWhere((c) => c.id == courseId);
    course.events.add(event);
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
}
