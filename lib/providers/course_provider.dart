

import 'dart:collection';

import 'package:flutter/cupertino.dart';

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
    loadCourses();
  }


  Future<void> deleteCourse(String courseId) async {
    await _courseService.deleteCourse(courseId);
    loadCourses();
  }

  Future<void> updateCourse(String courseId, String courseName) async {
    await _courseService.updateCourse(courseId: courseId, courseName: courseName);
    loadCourses();
  }

  Future<Course>? getCourseById(String courseId) async {
    Course course  = await _courseService.getCourseById(courseId);
    notifyListeners();
    return course ;
  }


  // Old Methods


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