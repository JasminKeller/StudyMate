import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../providers/course_provider.dart';
import 'package:provider/provider.dart';

import '../../services/course_respository.dart';
import '../../widgets/time_booking_list_widget.dart';

class TimeTrackingScreen extends StatefulWidget {
  const TimeTrackingScreen({Key? key}) : super(key: key);

  @override
  _TimeTrackingScreenState createState() => _TimeTrackingScreenState();
}

class _TimeTrackingScreenState extends State<TimeTrackingScreen> {
  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();
  String? selectedCourseId;
  DateTime? selectedStartTime;
  DateTime? selectedEndTime;

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Nicht gesetzt';
    return DateFormat('dd.MM.yyyy, HH:mm').format(dateTime);
  }

  void _showAddTimeBookingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // MediaQuery.of(context).viewInsets.bottom gibt die Höhe der Tastatur zurück.
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Kurs auswählen'),
                      items: Provider.of<CourseProvider>(context, listen: false)
                          .course
                          .map((course) {
                        return DropdownMenuItem(
                          value: course.id,
                          child: Text(course.courseName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedCourseId = value;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () => _pickDateTime(context, setModalState, isStartTime: true),
                      child: Text('Startzeit wählen: ${_formatDateTime(selectedStartTime)}'),
                    ),
                    ElevatedButton(
                      onPressed: () => _pickDateTime(context, setModalState, isStartTime: false),
                      child: Text('Endzeit wählen: ${_formatDateTime(selectedEndTime)}'),
                    ),
                    TextFormField(
                      controller: commentController,
                      decoration: const InputDecoration(labelText: 'Kommentar (optional)'),
                      onTap: () {
                        setModalState(() {});
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Buchen'),
                      onPressed: () async {
                        if (selectedCourseId != null && selectedStartTime != null && selectedEndTime != null) {
                          await CourseRepository.instance.addTimeBookingToCourse(
                            courseId: selectedCourseId!,
                            startDateTime: selectedStartTime!,
                            endDateTime: selectedEndTime!,
                            comment: commentController.text.isEmpty ? null : commentController.text,
                          );
                          Navigator.of(context).pop();
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  Future<void> _pickDateTime(BuildContext context, StateSetter setModalState, {required bool isStartTime}) async {
    final currentDate = DateTime.now();
    final initialDate = selectedStartTime ?? currentDate;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate == null) return;

    final TimeOfDay initialTime = TimeOfDay.fromDateTime(
        isStartTime ? selectedStartTime ?? currentDate : selectedEndTime ?? currentDate
    );
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime == null) return;

    setModalState(() {
      final selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      if (isStartTime) {
        selectedStartTime = selectedDateTime;
      } else {
        if (selectedStartTime != null && selectedDateTime.isBefore(selectedStartTime!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Die Endzeit kann nicht vor der Startzeit liegen.')),
          );
          return;
        }
        selectedEndTime = selectedDateTime;
      }
    });
  }

  @override
  void dispose() {

    commentController.dispose();
    commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courses = Provider.of<CourseProvider>(context).course;
    bool hasTimeBookings = courses.any((course) => course.timeBookings.isNotEmpty);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zeiterfassung'),
      ),
      body: hasTimeBookings
          ? TimeBookingListWidget()
          : const Center(
        child: Text(
          'Keine Zeitbuchungen vorhanden. Tippen Sie auf das Plus-Icon, um eine neue Zeitbuchung hinzuzufügen.',
          style: TextStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTimeBookingSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

extension on DateTime {
  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);
}
