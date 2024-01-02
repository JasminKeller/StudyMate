import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart';
import '../entity/course.dart';
import '../entity/time_booking.dart';

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

    return ListView.builder(
      itemCount: coursesWithBookings.length,
      itemBuilder: (BuildContext context, int index) {
        Course course = coursesWithBookings[index];
        String totalDuration = _calculateTotalDuration(course.timeBookings);

        return ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(course.courseName),
              Text(totalDuration),
            ],
          ),
          onExpansionChanged: (bool expanded) {
            setState(() {
              courseExpansionState[course.id] = expanded;
            });
          },
          initiallyExpanded: courseExpansionState[course.id] ?? false,
          children: course.timeBookings.map((booking) {
            final startDateTime = booking.startDateTime;
            final endDateTime = booking.endDateTime;
            final isSameDay = startDateTime.day == endDateTime.day &&
                startDateTime.month == endDateTime.month &&
                startDateTime.year == endDateTime.year;

            String formattedDateTime = _formatDateTime(startDateTime);
            if (!isSameDay) {
              formattedDateTime += ' - ';
              formattedDateTime += _formatDateTime(endDateTime);
            } else {
              formattedDateTime += ', ${_formatTime(startDateTime)} - ${_formatTime(endDateTime)}';
            }

            return ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(booking.comment ?? 'Kein Kommentar'),
              subtitle: Text(formattedDateTime),
              trailing: Text(_formatDuration(booking.durationInMinutes)),
            );
          }).toList(),
        );
      },
    );
  }

  String _calculateTotalDuration(List<TimeBooking> timeBookings) {
    int totalMinutes = 0;
    for (var booking in timeBookings) {
      totalMinutes += booking.durationInMinutes;
    }
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours}h ${minutes}min';
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }

  String _formatDuration(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours}h ${minutes}min';
  }
}
