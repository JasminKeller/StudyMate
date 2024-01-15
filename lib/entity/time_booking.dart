import 'package:hive/hive.dart';
part 'time_booking.g.dart';

@HiveType(typeId: 2)
class TimeBooking extends HiveObject {

  @HiveField(0)
  int id;

  @HiveField(1)
  String? comment;

  @HiveField(2)
  DateTime startDateTime;

  @HiveField(3)
  DateTime endDateTime;

  @HiveField(4)
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
