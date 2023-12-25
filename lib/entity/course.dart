

class Course {
  String id;
  String courseName;

  Course({
    required this.id,
    required this.courseName,
  });

  @override
  String toString() {
    return 'Course{courseName: $courseName}';
  }
}

