import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:studymate/utils/notification_helper.dart';
import '../../entity/course.dart';
import '../../entity/event.dart';
import '../../providers/course_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../screens/event/event_detail_screen.dart';
import '../../services/course_repository.dart';
import '../../services/snackbar_service.dart';

class EventListWidget extends StatefulWidget {
  final Course course;

  EventListWidget({Key? key, required this.course}) : super(key: key);

  @override
  _EventListWidgetState createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  SnackbarService snackbarService = SnackbarService();

  @override
  Widget build(BuildContext context) {
    CourseProvider courseProvider = context.watch<CourseProvider>();
    DateTime currentDate = DateTime.now();

    return ListView.builder(
      itemCount: widget.course.events.length + 1,
      itemBuilder: (context, index) {
        if (index == widget.course.events.length) {
          return const Padding(padding: EdgeInsets.only(bottom: 80));
        }
        final event = widget.course.events[index];
        final formattedDate = event.eventDateTime != null
            ? DateFormat('EEEE, d. MMMM yyyy', 'de_DE').format(event.eventDateTime!)
            : '';

        IconData reminderIcon = Icons.notifications_off;
        Color iconColor = Colors.grey;

        if (event.reminderDateTime != null && event.isReminderActive && !currentDate.isAfter(event.reminderDateTime!)) {
          reminderIcon = Icons.notifications_active;
          iconColor = Colors.red;
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
              ),
            ),
          ),
        );
      },
    );
  }
}
