
class Event {
  String id;
  String eventName;

  Event({
    required this.id,
    required this.eventName,
  });

  @override
  String toString() {
    return 'Event{eventName: $eventName}';
  }
}

enum EventType {
  Exam,
  Task,
}
