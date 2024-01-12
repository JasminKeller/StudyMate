import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../entity/time_booking.dart';
import '../../providers/course_provider.dart';
import '../../services/course_respository.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/time_booking_list_widget.dart';
import '../settings_screen.dart';

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
  TimeBooking? editingBooking;

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
                      value: selectedCourseId,
                      items: Provider.of<CourseProvider>(context, listen: false)
                          .courses
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
                      child: Text(editingBooking == null ? 'Buchen' : 'Anpassen'),
                      onPressed: () async {
                        if (selectedCourseId != null && selectedStartTime != null && selectedEndTime != null) {
                          String comment = commentController.text.isEmpty ? 'Kein Kommentar' : commentController.text;

                          if (editingBooking == null) {
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
                              timeBookingId: editingBooking!.id,
                              courseId: selectedCourseId!,
                              startDateTime: selectedStartTime!,
                              endDateTime: selectedEndTime!,
                              comment: comment,
                            );
                          }
                          Provider.of<CourseProvider>(context, listen: false).readCourseWithLoadingState();
                          Navigator.of(context).pop();
                          setState(() {
                            editingBooking = null;
                            selectedCourseId = null;
                            selectedStartTime = null;
                            selectedEndTime = null;
                            commentController.clear();
                          });
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

  void _showEditTimeBookingSheet(BuildContext context, TimeBooking booking) {
    selectedCourseId = booking.courseId;
    selectedStartTime = booking.startDateTime;
    selectedEndTime = booking.endDateTime;
    commentController.text = booking.comment ?? '';
    editingBooking = booking;

    _showAddTimeBookingSheet(context);
  }

  void editTimeBooking(TimeBooking booking) {
    _showEditTimeBookingSheet(context, booking);
  }

  Future<void> _pickDateTime(BuildContext context, StateSetter setModalState, {required bool isStartTime}) async {
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
    final courseProvider = Provider.of<CourseProvider>(context);
    final bool hasCourses = courseProvider.courses.isNotEmpty;
    final bool hasTimeBookings = courseProvider.courses.any((course) => course.timeBookings.isNotEmpty);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Zeiterfassung'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SettingsScreen(),
              ));
            },
          ),
        ],
      ),
      body: hasCourses
          ? (hasTimeBookings
          ? TimeBookingListWidget(onEdit: editTimeBooking)
          : const EmptyStateWidget(
              iconData: Icons.timer,
              message: 'Keine Zeitbuchungen vorhanden.\nErstellen Sie eine neue Zeitbuchung für einen Kurs.',
      ))
          : const EmptyStateWidget(
              iconData: Icons.book,
              message: 'Bitte erstellen Sie zuerst Kurse, bevor Sie Zeitbuchungen vornehmen können.',
      ),
      floatingActionButton: hasCourses
          ? FloatingActionButton.extended(
        onPressed: () => _showAddTimeBookingSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Zeitbuchung hinzufügen'),
      )
          : null, // Plus-Icon ausblenden, wenn keine Kurse vorhanden sind
    );
  }
}
