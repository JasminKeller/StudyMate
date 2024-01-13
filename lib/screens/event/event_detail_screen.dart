import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../entity/event.dart';
import '../../providers/course_provider.dart';
import '../../services/course_repository.dart';
import '../../utils/notification_helper.dart';

class EventDetailScreen extends StatefulWidget {
  final Event? event;
  final String courseID;

  EventDetailScreen({Key? key, required this.event, required this.courseID}) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late TextEditingController eventNameController;
  late FocusNode eventNameFocusNode;
  DateTime? eventDateTime;
  DateTime? reminderDateTime;
  bool isReminderActive = false;

  @override
  void initState() {
    super.initState();
    eventNameController =
        TextEditingController(text: widget.event?.eventName ?? '');
    eventNameFocusNode = FocusNode();
    eventDateTime = widget.event?.eventDateTime;
    reminderDateTime = widget.event?.reminderDateTime;
    isReminderActive = widget.event?.isReminderActive ?? false;
  }

  void dispose() {
    eventNameController.dispose();
    eventNameFocusNode.dispose();
    super.dispose();
  }

  void _openDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: eventDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        eventDateTime = pickedDate;
      });
    }
  }

  void _openReminderPicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: reminderDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(reminderDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          reminderDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          isReminderActive = true;
        });
      }
    }
  }

  void _saveEvent() async {
    String eventName = eventNameController.text;
    if (eventName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event Name darf nicht leer sein.')),
      );
      return;
    }

    if (widget.event == null) {
      // Neues Event erstellen und hinzufügen
      await CourseRepository.instance.addEventToCourse(
        widget.courseID,
        eventName,
        eventDateTime ?? DateTime
            .now(), // Verwenden Sie das aktuelle Datum, wenn kein Datum ausgewählt wurde
      );
    } else {
      // Bestehendes Event aktualisieren
      if (eventName != widget.event!.eventName ||
          eventDateTime != widget.event!.eventDateTime ||
          reminderDateTime != widget.event!.reminderDateTime ||
          isReminderActive != widget.event!.isReminderActive) {
        widget.event!.eventName = eventName;
        widget.event!.eventDateTime = eventDateTime;
        widget.event!.reminderDateTime = reminderDateTime;
        widget.event!.isReminderActive = isReminderActive;

        await CourseRepository.instance.updateEventFromCourse(
            widget.courseID, widget.event!);
      }
    }

    CourseProvider courseProvider = context.read<CourseProvider>();
    await courseProvider.readCourses();
    Navigator.of(context).pop(); // Zurück zum vorherigen Bildschirm navigieren
  }


  void _confirmDeleteEvent() async {
    final bool confirm = await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Event löschen'),
            content: const Text(
                'Bist du sicher, dass du dieses Event löschen möchtest?'),
            actions: [
              TextButton(
                child: const Text('Abbrechen'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text('Löschen'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
    ) ?? false;

    if (confirm) {
      await CourseRepository.instance.deleteEventFromCourse(widget.courseID, widget.event!.id);
      CourseProvider courseProvider = context.read<CourseProvider>();
      await courseProvider.readCourses();
      Navigator.of(context).pop();
    }
  }

  Widget _buildDateTimePicker(String label, DateTime? dateTime) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        TextButton(
          onPressed: dateTime == eventDateTime
              ? _openDatePicker
              : _openReminderPicker,
          child: Text(
            dateTime != null
                ? DateFormat('d. MMMM y, HH:mm').format(dateTime)
                : 'Nicht gesetzt',
            style: TextStyle(
              color: Theme
                  .of(context)
                  .colorScheme
                  .primary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle = widget.event == null
        ? 'Neues Event'
        : 'Event bearbeiten';
    String buttonTitle = widget.event == null
        ? 'Event hinzufügen'
        : 'Event aktualisieren';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: [
          if (widget.event != null) IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDeleteEvent,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 20),
            TextFormField(
              controller: eventNameController,
              focusNode: eventNameFocusNode,
              decoration: const InputDecoration(labelText: 'Event Name'),
            ),
            const SizedBox(height: 15),
            _buildDateTimePicker('Datum:', eventDateTime),
            const SizedBox(height: 15),
            _buildDateTimePicker('Erinnerung:', reminderDateTime),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text(buttonTitle),
              onPressed: _saveEvent,
            ),
          ],
        ),
      ),
    );
  }
}