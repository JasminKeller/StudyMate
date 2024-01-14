class Event {
  int id;
  String eventName;
  DateTime eventDateTime;
  DateTime? reminderDateTime;
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
