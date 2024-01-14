import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../providers/course_provider.dart';
import '../../entity/course.dart';
import '../../entity/time_booking.dart';
import '../../services/course_repository.dart';

class TimeBookingListWidget extends StatefulWidget {
  final Function(TimeBooking) onEdit;

  const TimeBookingListWidget({Key? key, required this.onEdit}) : super(key: key);

  @override
  _TimeBookingListWidgetState createState() => _TimeBookingListWidgetState();
}

class _TimeBookingListWidgetState extends State<TimeBookingListWidget> {
  Map<String, bool> courseExpansionState = {};

  @override
  Widget build(BuildContext context) {
    final coursesWithBookings = Provider.of<CourseProvider>(context)
        .courses
        .where((course) => course.timeBookings.isNotEmpty)
        .toList();

    return ListView.builder(
      itemCount: coursesWithBookings.length + 1, // Erhöhen Sie die itemCount um 1
      itemBuilder: (BuildContext context, int index) {
        if (index == coursesWithBookings.length) {
          // Fügen Sie hier das Padding für das letzte Element ein
          return Padding(padding: EdgeInsets.only(bottom: 80)); // 80 ist ein Beispielwert
        }
        Course course = coursesWithBookings[index];
        return _buildCourseTile(course);
      },
    );

  }

  ExpansionTile _buildCourseTile(Course course) {
    String totalDuration = _calculateTotalDuration(course.timeBookings);

    return ExpansionTile(
      title: _buildCourseTitle(course.courseName, totalDuration),
      initiallyExpanded: courseExpansionState[course.id] ?? false,
      onExpansionChanged: (bool expanded) => setState(() => courseExpansionState[course.id] = expanded),
      children: course.timeBookings.map((booking) => _buildBookingItem(booking, course)).toList(),
    );
  }

  Row _buildCourseTitle(String courseName, String totalDuration) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(courseName), Text(totalDuration)],
    );
  }

  Dismissible _buildBookingItem(TimeBooking booking, Course course) {
    String formattedDateTime = _formatBookingDateTime(booking);
    return Dismissible(
      key: Key(booking.id.toString()),
      direction: DismissDirection.endToStart,
      background: _buildDeleteBackground(),
      onDismissed: (direction) => _deleteBooking(course, booking),
      child: ListTile(
        leading: const Icon(Icons.access_time),
        title: Text(booking.comment ?? 'Kein Kommentar'),
        subtitle: Text(formattedDateTime),
        trailing: Text(_formatDuration(booking.durationInMinutes)),
        onTap: () => widget.onEdit(booking),
      ),
    );
  }

  Container _buildDeleteBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20.0),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Future<void> _deleteBooking(Course course, TimeBooking booking) async {
    await CourseRepository.instance.deleteTimeBookingFromCourse(course.id, booking.id);
    await Provider.of<CourseProvider>(context, listen: false).readCourse(course.id);
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

  String _formatBookingDateTime(TimeBooking booking) {
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
    return formattedDateTime;
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
