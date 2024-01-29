import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../services/course_repository.dart';

class AddCourseModal extends StatelessWidget {
  const AddCourseModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String newCourseName = '';
    var textEditingController = TextEditingController();

    void _addCourse() async {
      if (newCourseName.isNotEmpty) {
        var courseProvider = Provider.of<CourseProvider>(context, listen: false);
        await CourseRepository.instance.addCourse(courseProvider, courseName: newCourseName);
        Navigator.of(context).pop();
      }
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
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
                onChanged: (value) => newCourseName = value,
                decoration: const InputDecoration(labelText: 'Neuer Kurs hinzufügen'),
                onEditingComplete: _addCourse,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _addCourse,
                child: const Text('Hinzufügen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}