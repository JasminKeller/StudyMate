

import 'package:flutter/cupertino.dart';

import '../entity/course.dart';
import '../services/course_respository.dart';

class CourseProvider extends ChangeNotifier {

  bool isLoading = false;
  List<Course> _courses = [];

  List<Course> get courses => _courses;

  CourseProvider() {
    readCoursesWithLoadingState();
  }

  Future<void> readCoursesWithLoadingState() async {
    isLoading = true;
    notifyListeners();
    _courses = await CourseRepository.instance.getCourses();
    isLoading = false;
    notifyListeners();
  }

  Future<void> readCourse({bool withNotifying = true}) async {
    _courses = await CourseRepository.instance.getCourses();

    if (withNotifying) {
      notifyListeners();
    }
  }

}