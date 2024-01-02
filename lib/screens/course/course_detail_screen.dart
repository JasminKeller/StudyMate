import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../entity/course.dart';
import '../../providers/course_provider.dart';
import '../../services/course_respository.dart';
import '../../widgets/event_list_widget.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({Key? key, required this.course}) : super(key: key);

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  String newEventName = '';

  void _showAddEventModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        var textEditingController = TextEditingController();
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.5,
          builder: (_, controller) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  autofocus: true,
                  controller: textEditingController,
                  onChanged: (value) {
                    newEventName = value;
                  },
                  decoration: const InputDecoration(labelText: 'Neuer Event-Name'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('Hinzufügen'),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && newEventName.isNotEmpty) {
                      await CourseRepository.instance.addEventToCourse(widget.course.id, newEventName, pickedDate);
                      var courseProvider = context.read<CourseProvider>();
                      courseProvider.readCourse();

                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
      await CourseRepository.instance.updateCourse(courseId: widget.course.id, courseName: newName);
      setState(() {
        widget.course.courseName = newName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.courseName),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editCourseName,
          ),
        ],
      ),
      body: Center(
        child: EventListWidget(course: widget.course),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventModalBottomSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
