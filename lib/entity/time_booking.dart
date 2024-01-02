class TimeBooking {
  int id;
  String? comment;
  DateTime startDateTime;
  DateTime endDateTime;
  String courseId;

  TimeBooking({
    required this.id,
    this.comment,
    required this.startDateTime,
    required this.endDateTime,
    required this.courseId,
  });

  int get durationInMinutes => endDateTime.difference(startDateTime).inMinutes;

  @override
  String toString() {
    return 'TimeBooking{id: $id, comment: $comment, startDateTime: $startDateTime, endDateTime: $endDateTime, courseId: $courseId, durationInMinutes: $durationInMinutes}';
  }
}
