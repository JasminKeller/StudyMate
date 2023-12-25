import '../entity/course.dart';

class CourseRepository {
  static CourseRepository instance = CourseRepository._privateConstructor();
  CourseRepository._privateConstructor() {
    // _courses.add(Course(id: '1', courseName: 'Einführung in die Programmierung'));
    // _courses.add(Course(id: '2', courseName: 'Fortgeschrittene Datenbanktechniken'));
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
}
