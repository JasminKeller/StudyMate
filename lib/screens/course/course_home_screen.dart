import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart';
import '../../widgets/add_course_modal.dart';
import '../../widgets/lists/course_list_widget.dart';
import '../../widgets/empty_state_widget.dart';
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
      builder: (_) => const AddCourseModal(),
    );
  }

  Widget _buildCourseContent() {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        if (courseProvider.courses.isEmpty) {
          return const EmptyStateWidget(
            iconData: Icons.book,
            message: 'Keine Kurse vorhanden.\nTippen Sie auf das Plus-Icon, um einen neuen Kurs hinzuzufügen.',
          );
        } else {
          return const CourseListWidget();
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: const Icon(Icons.school),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: _buildCourseContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'addCourse_btn',
        onPressed: _showAddCourseModalBottomSheet,
        icon: const Icon(Icons.add),
        label: const Text('Kurs hinzufügen'),
      ),
    );
  }
}
