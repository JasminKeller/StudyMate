import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart';
import '../../services/course_respository.dart';
import '../../widgets/course_list_widget.dart';
import '../settings_screen.dart';

class CourseManagementScreen extends StatefulWidget {
  final String title;


  const CourseManagementScreen({super.key, required this.title});

  @override
  State<CourseManagementScreen> createState() => _CourseManagementScreenState();
}

class _CourseManagementScreenState extends State<CourseManagementScreen> {

  void _showAddCourseModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        String newCourse = '';
        var textEditingController = TextEditingController();
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) => Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    autofocus: true,
                    controller: textEditingController,
                    onChanged: (value) {
                      newCourse = value;
                    },
                    decoration: const InputDecoration(labelText: 'Neuer Kurs hinzufügen'),
                  ),
                  ElevatedButton(
                    child: const Text('Hinzufügen'),
                    onPressed: () async {
                      if (newCourse.isNotEmpty) {
                        await CourseRepository.instance.addCourse(courseName: newCourse);
                        var courseProvider = context.read<CourseProvider>();
                        courseProvider.readCourses();
                        Navigator.of(context).pop();

                      }
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SettingsScreen(),
              ));
            },
          ),
        ],
      ),
      body:  const CourseListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCourseModalBottomSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
