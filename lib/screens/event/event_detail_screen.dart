import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../entity/event.dart';
import '../../providers/course_provider.dart';
import '../../services/course_respository.dart';
import '../../utils/notification_helper.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;
  final String courseID;

  EventDetailScreen({Key? key, required this.event, required this.courseID}) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late TextEditingController eventNameController;
  late FocusNode eventNameFocusNode;

  @override
  void initState() {
    super.initState();
    eventNameController = TextEditingController(text: widget.event.eventName);
    eventNameFocusNode = FocusNode();
  }

  void _openDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.event.eventDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      DateTime finalDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );

      setState(() {
        widget.event.eventDateTime = pickedDate;
      });

      await CourseRepository.instance.updateEventFromCourse(widget.courseID, widget.event);
      CourseProvider courseProvider = context.read<CourseProvider>();
      courseProvider.readCourse();
    }
  }

  void _openReminderPicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.event.reminderDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(widget.event.reminderDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        final DateTime finalReminderDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          widget.event.reminderDateTime = finalReminderDateTime;
          widget.event.isReminderActive = true;
        });

        await NotificationHelper.checkPermissionsAndScheduleSingleNotification(
          notificationId: widget.event.id,
          dateTime: finalReminderDateTime,
          context: context,
          title: 'Erinnerung: ${widget.event.eventName}',
          body: 'Ihre Erinnerung für ${widget.event.eventName} ist geplant für ${DateFormat('dd.MM.yyyy HH:mm').format(finalReminderDateTime)}',
        );

        await CourseRepository.instance.updateEventFromCourse(widget.courseID, widget.event);
        CourseProvider courseProvider = context.read<CourseProvider>();
        courseProvider.readCourse();
      }
    }
  }


  void _updateEventName(String newName) async {
    if (newName.isNotEmpty && newName != widget.event.eventName) {
      widget.event.eventName = newName;

      await CourseRepository.instance.updateEventFromCourse(widget.courseID, widget.event);
      CourseProvider courseProvider = context.read<CourseProvider>();
      courseProvider.readCourse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // TODO: Löschfunktion implementieren
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: eventNameController,
              focusNode: eventNameFocusNode, // Assign the FocusNode
              enabled: true,
              decoration: InputDecoration(
                labelText: 'Event Name',
                labelStyle: TextStyle(fontSize: 16.0),
                hintStyle: TextStyle(fontSize: 16.0),
              ),
              onChanged: (newName) {
                _updateEventName(newName); // Listen for changes
              },
              onFieldSubmitted: (newName) {
                _updateEventName(newName); // Handle field submission (focus lost)
              },
            ),
            SizedBox(height: 40.0),
            GestureDetector(
              onTap: _openDatePicker,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.date_range, size: 20.0),
                      SizedBox(width: 8.0),
                      Text(
                        'Datum',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  Text(
                    DateFormat('d. MMMM y').format(widget.event.eventDateTime!),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.0),
            GestureDetector(
              onTap: _openReminderPicker,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.alarm, size: 20.0),
                      SizedBox(width: 8.0),
                      Text(
                        'Erinnerung',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  Text(
                    widget.event.reminderDateTime != null
                        ? DateFormat('d. MMMM y, HH:mm').format(widget.event.reminderDateTime!)
                        : 'Keine Erinnerung',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    eventNameController.dispose();
    eventNameFocusNode.dispose();
    super.dispose();
  }
}
