import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../entity/course.dart';
import '../entity/event.dart';
import '../providers/course_provider.dart';
import '../services/course_respository.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.courseName),
      ),
      body: Center(
        child: EventListWidget(course: widget.course),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.add),
      ),
    );
  }
}



class EventListWidget extends StatelessWidget {

  final Course course;

  const EventListWidget({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    CourseProvider courseProvider = context.watch<CourseProvider>();

    return ListView.builder(
      itemCount: course.events.length,
      itemBuilder: (context, index) {
        final event = course.events[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              title: Text(event.eventName),
              // dense: true,
            ),
          ),
        );
      },
    );
  }
}