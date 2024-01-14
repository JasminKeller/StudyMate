import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:studymate/utils/notification_helper.dart';
import '../../entity/course.dart';
import '../../entity/event.dart';
import '../../providers/course_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../screens/event/event_detail_screen.dart';
import '../../services/course_repository.dart';

class EventListWidget extends StatefulWidget {
  final Course course;

  EventListWidget({Key? key, required this.course}) : super(key: key);

  @override
  _EventListWidgetState createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {

  void _toggleReminder(BuildContext context, Event event) async {
    if (event.isReminderActive) {
      event.isReminderActive = false;
      event.reminderDateTime = null;
      AwesomeNotifications().cancel(event.id!);
    } else {
      // Show date and time picker if the reminder is inactive
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: event.reminderDateTime ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (pickedDate != null) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(event.reminderDateTime ?? DateTime.now()),
        );

        if (pickedTime != null) {
          DateTime finalDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          event.reminderDateTime = finalDateTime;
          event.isReminderActive = true;

          await NotificationHelper.checkPermissionsAndScheduleSingleNotification(
            notificationId: event.id,
            dateTime: finalDateTime,
            context: context,
            title: 'Erinnerung für ${event.eventName}',
            body: 'Erinnerung für das Event ${event.eventName} - ${widget.course.courseName} ist geplant für ${DateFormat('dd.MM.yyyy HH:mm').format(finalDateTime)}.',
          );
        }
      }
    }

    await CourseRepository.instance.updateEventFromCourse(widget.course.id, event);
    CourseProvider courseProvider = context.read<CourseProvider>();
    courseProvider.readCourses();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    CourseProvider courseProvider = context.watch<CourseProvider>();
    DateTime currentDate = DateTime.now();

    return ListView.builder(
      itemCount: widget.course.events.length,
      itemBuilder: (context, index) {
        final event = widget.course.events[index];
        final formattedDate = event.eventDateTime != null
            ? DateFormat('d. MMMM').format(event.eventDateTime!)
            : '';

        IconData reminderIcon = Icons.notifications_off;
        Color iconColor = Colors.grey;

        if (event.reminderDateTime != null) {
          if (event.isReminderActive) {
            if (currentDate.isAfter(event.reminderDateTime!)) {
              reminderIcon = Icons.notifications;
              iconColor = Colors.grey;
            } else {
              reminderIcon = Icons.notifications_active;
              iconColor = Colors.red;
            }
          } else {
            reminderIcon = Icons.notifications_off;
            iconColor = Colors.grey;
          }
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailScreen(event: event, courseID: widget.course.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: Text(event.eventName),
                subtitle: Text(formattedDate, style: const TextStyle(fontSize: 12)),
                trailing: IconButton(
                  icon: Icon(reminderIcon, color: iconColor),
                  onPressed: () => _toggleReminder(context, event),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
