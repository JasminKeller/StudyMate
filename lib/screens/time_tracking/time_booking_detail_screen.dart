import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../entity/time_booking.dart';
import '../../providers/course_provider.dart';
import '../../services/course_repository.dart';

class TimeBookingDetailScreen extends StatefulWidget {
  final TimeBooking? booking;

  const TimeBookingDetailScreen({Key? key, this.booking}) : super(key: key);

  @override
  _TimeBookingDetailScreenState createState() => _TimeBookingDetailScreenState();
}

class _TimeBookingDetailScreenState extends State<TimeBookingDetailScreen> {
  String? selectedCourseId;
  DateTime? selectedStartTime;
  DateTime? selectedEndTime;

  TextEditingController? commentController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedCourseId = widget.booking?.courseId;
    selectedStartTime = widget.booking?.startDateTime;
    selectedEndTime = widget.booking?.endDateTime;

    commentController = TextEditingController(text: widget.booking?.comment);
    startTimeController = TextEditingController(
        text: widget.booking?.startDateTime != null
            ? DateFormat('dd.MM.yyyy, HH:mm').format(widget.booking!.startDateTime!)
            : '');
    endTimeController = TextEditingController(
        text: widget.booking?.endDateTime != null
            ? DateFormat('dd.MM.yyyy, HH:mm').format(widget.booking!.endDateTime!)
            : '');
  }

  @override
  void dispose() {
    startTimeController.dispose();
    endTimeController.dispose();
    commentController?.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Nicht gesetzt';
    return DateFormat('dd.MM.yyyy, HH:mm').format(dateTime);
  }

  Future<void> _pickDateTime(BuildContext context, {required bool isStartTime}) async {
    final currentDate = DateTime.now();
    final initialDate = isStartTime ? selectedStartTime ?? currentDate : selectedEndTime ?? currentDate;
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

    final selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    setState(() {
      if (isStartTime) {
        selectedStartTime = selectedDateTime;
        startTimeController.text = DateFormat('dd.MM.yyyy, HH:mm').format(selectedDateTime);
      } else {
        if (selectedStartTime != null && selectedDateTime.isBefore(selectedStartTime!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Die Endzeit kann nicht vor der Startzeit liegen.')),
          );
          return;
        }
        selectedEndTime = selectedDateTime;
        endTimeController.text = DateFormat('dd.MM.yyyy, HH:mm').format(selectedDateTime);
      }
      _formKey.currentState?.validate();
    });
  }

  void _saveTimeBooking() async {
    if (_formKey.currentState?.validate() == true) {
      if (selectedCourseId != null && selectedStartTime != null && selectedEndTime != null) {
        String comment = commentController!.text.isEmpty ? 'Kein Kommentar' : commentController!.text;
        if (widget.booking == null) {
          // Neue Zeitbuchung anlegen
          await CourseRepository.instance.addTimeBookingToCourse(
            courseId: selectedCourseId!,
            startDateTime: selectedStartTime!,
            endDateTime: selectedEndTime!,
            comment: comment,
          );
        } else {
          // Zeitbuchung anpassen
          await CourseRepository.instance.updateTimeBookingInCourse(
            timeBookingId: widget.booking!.id,
            courseId: selectedCourseId!,
            startDateTime: selectedStartTime!,
            endDateTime: selectedEndTime!,
            comment: comment,
          );
        }
        Provider.of<CourseProvider>(context, listen: false).readCourses();
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle = widget.booking == null ? 'Neue Zeitbuchung' : 'Zeitbuchung anpassen';
    String buttonTitle = widget.booking == null ? 'Zeitbuchung Hinzufügen' : 'Zeitbuchung Anpassen';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const SizedBox( height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Kurs auswählen'),
                value: selectedCourseId,
                items: Provider.of<CourseProvider>(context, listen: false)
                    .courses
                    .map((course) {
                  return DropdownMenuItem<String>(
                    value: course.id,
                    child: Text(course.courseName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCourseId = value;
                  });
                  _formKey.currentState?.validate();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte wählen Sie einen Kurs aus.';
                  }
                  return null;
                },
              ),

              const SizedBox( height: 15),
              TextFormField(
                controller: startTimeController,
                decoration: const InputDecoration(
                  labelText: 'Startzeit wählen:',
                  prefixIcon: Icon(Icons.play_arrow),
                ),
                readOnly: true,
                onTap: () => _pickDateTime(context, isStartTime: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Startzeit darf nicht leer sein.';
                  }
                  return null;
                },
              ),
              const SizedBox( height: 15),
              TextFormField(
                controller: endTimeController,
                decoration: const InputDecoration(
                  labelText: 'Endzeit wählen:',
                  prefixIcon: Icon(Icons.stop),
                ),
                readOnly: true,
                onTap: () => _pickDateTime(context, isStartTime: false),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Endzeit darf nicht leer sein.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: 'Kommentar (optional)',
                  prefixIcon: Icon(Icons.comment),
                ),
              ),
              const SizedBox( height: 20),
              ElevatedButton(
                child: Text(buttonTitle),
                onPressed: _saveTimeBooking,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
