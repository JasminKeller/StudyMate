

import 'package:flutter/cupertino.dart';

import '../entity/course.dart';
import '../services/course_respository.dart';

class CourseProvider extends ChangeNotifier {

  bool isLoading = false;
  List<Course> _courses = [];

  List<Course> get courses => _courses;

  CourseProvider() {
    readCourseWithLoadingState();
  }

  Future<void> readCourseWithLoadingState() async {
    isLoading = true;
    notifyListeners();
    _courses = await CourseRepository.instance.getCourses();
    isLoading = false;
    notifyListeners();
  }

  Future<void> readCourses({bool withNotifying = true}) async {
    _courses = await CourseRepository.instance.getCourses();

    if (withNotifying) {
      notifyListeners();
    }

  }

  Future<void> readCourse(String courseId) async {
    int index = _courses.indexWhere((course) => course.id == courseId);
    if (index != -1) {
      Course updatedCourse = await CourseRepository.instance.getCourseById(courseId);
      _courses[index] = updatedCourse;
      notifyListeners();
    }
  }

}