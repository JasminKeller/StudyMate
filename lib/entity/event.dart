
import 'package:hive/hive.dart';
part 'event.g.dart';

@HiveType(typeId: 1)
class Event extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String eventName;

  @HiveField(2)
  DateTime eventDateTime;

  @HiveField(3)
  DateTime? reminderDateTime;

  @HiveField(4)
  bool isReminderActive;

  Event({
    required this.id,
    required this.eventName,
    required this.eventDateTime,
    this.reminderDateTime,
    this.isReminderActive = false,
  });

  @override
  String toString() {
    return 'Event{eventName: $eventName, eventDateTime: $eventDateTime}';
  }
}
