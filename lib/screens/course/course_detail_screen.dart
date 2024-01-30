import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../entity/course.dart';
import '../../providers/course_provider.dart';
import '../../services/course_service.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/lists/event_list_widget.dart';
import '../event/event_detail_screen.dart';
import '../../entity/event.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({Key? key, required this.course}) : super(key: key);

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {


  void _navigateToEventDetailScreen(Event? event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventDetailScreen(event: event, courseID: widget.course.id),
      ),
    );
  }

  void _confirmDeleteCourse() async {
    bool confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kurs löschen?'),
        content: Text(
            'Bist du sicher, dass du den Kurs "${widget.course.courseName}" löschen möchtest?\n\n'
                'Alle Prüfungen/Abgaben und Zeitbuchungen auf diesem Kurs werden gelöscht.'
        ),
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
      var courseProvider = Provider.of<CourseProvider>(context, listen: false);
      await courseProvider.deleteCourse(widget.course.id);

      Navigator.of(context).pop();
    }
  }

  Future<void> _deleteCourseAndEvents(String courseId) async {
    final List<Event> events = await CourseService.instance.getEventsFromCourse(courseId);
    for (final Event event in events) {
      if (event.isReminderActive && event.reminderDateTime != null && event.reminderDateTime!.isAfter(DateTime.now())) {
        AwesomeNotifications().cancel(event.id!);
        if (kDebugMode) {
          print('Canceled notification for event ${event.eventName} with id ${event.id}');
        }
      }
    }
    await CourseService.instance.deleteCourse(courseId);
  }




  void _editCourseName() async {
    var textEditingController = TextEditingController(text: widget.course.courseName);
    var newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kursnamen bearbeiten'),
        content: TextField(
          controller: textEditingController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Neuer Kursname'),
        ),
        actions: [
          TextButton(
            child: const Text('Abbrechen'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Speichern'),
            onPressed: () {
              Navigator.of(context).pop(textEditingController.text);
            },
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && newName != widget.course.courseName) {
      var courseProvider = Provider.of<CourseProvider>(context, listen: false);
      await courseProvider.updateCourse(widget.course.id, newName);
      setState(() {
        widget.course.courseName = newName;
      });
    }
  }

  Widget _buildEventContent() {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        if (widget.course.events.isEmpty) {
          return const EmptyStateWidget(
            iconData: Icons.event_note,
            message: 'Keine Prüfungen oder Abgabetermine.\nTippen Sie auf das Plus-Icon, um eine neue Prüfung oder Abgabe hinzuzufügen.',
          );
        } else {
          return EventListWidget(course: widget.course);
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.course.courseName,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editCourseName,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDeleteCourse,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Consumer<CourseProvider>(
              builder: (context, courseProvider, child) {
                if (courseProvider.courses.isEmpty) {
                  return const EmptyStateWidget(
                    iconData: Icons.event_note,
                    message: 'Keine Prüfungen oder Abgabetermine.\nTippen Sie auf das Plus-Icon, um eine neue Prüfung oder Abgabe hinzuzufügen.',
                  );
                } else {
                  return EventListWidget(course: widget.course);
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToEventDetailScreen(null),
        icon: const Icon(Icons.add),
        label: const Text('Prüfung/Abgabe hinzufügen'),
      ),
    );
  }



}
