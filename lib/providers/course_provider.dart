

import 'package:flutter/cupertino.dart';

import '../entity/course.dart';
import '../services/course_respository.dart';

class CourseProvider extends ChangeNotifier {

  bool isLoading = false;
  List<Course> _course = [];

  List<Course> get course => _course;

  CourseProvider() {
    readCourseWithLoadingState();
  }

  Future<void> readCourseWithLoadingState() async {
    isLoading = true;
    notifyListeners();
    _course = await CourseRepository.instance.getCourses();
    isLoading = false;
    notifyListeners();
  }

  Future<void> readCourse({bool withNotifying = true}) async {
    _course = await CourseRepository.instance.getCourses();

    if (withNotifying) {
      notifyListeners();
    }

  }

}