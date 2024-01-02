import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart';
import '../entity/course.dart';

class TimeBookingListWidget extends StatefulWidget {
  @override
  _TimeBookingListWidgetState createState() => _TimeBookingListWidgetState();
}

class _TimeBookingListWidgetState extends State<TimeBookingListWidget> {
  Map<String, bool> courseExpansionState = {};

  @override
  Widget build(BuildContext context) {
    final coursesWithBookings = Provider.of<CourseProvider>(context)
        .course
        .where((course) => course.timeBookings.isNotEmpty)
        .toList();

    // Drucken der Kurse und ihrer Buchungen
    print("Gefundene Kurse mit Buchungen: ${coursesWithBookings.length}");
    for (var course in coursesWithBookings) {
      print("Kurs: ${course.courseName}, Buchungen: ${course.timeBookings.length}");
    }

    return ListView.builder(
      itemCount: coursesWithBookings.length,
      itemBuilder: (BuildContext context, int index) {
        Course course = coursesWithBookings[index];
        return ExpansionTile(
          title: Text(course.courseName),
          onExpansionChanged: (bool expanded) {
            setState(() {
              courseExpansionState[course.id] = expanded;
            });
          },
          initiallyExpanded: courseExpansionState[course.id] ?? false,
          children: course.timeBookings.map((booking) {
            return ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(booking.comment ?? 'Kein Kommentar'),
              subtitle: Text('Von ${_formatDateTime(booking.startDateTime)} bis ${_formatDateTime(booking.endDateTime)}'),
              trailing: Text(_formatDuration(booking.durationInMinutes)),
            );
          }).toList(),
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy, HH:mm').format(dateTime);
  }

  String _formatDuration(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return hours > 0 ? '${hours}h ${minutes}min' : '${minutes}min';
  }
}
