import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../entity/event.dart';
import '../../providers/course_provider.dart';
import '../../services/course_repository.dart';
import '../../services/snackbar_service.dart';
import '../../utils/notification_helper.dart';

class EventDetailScreen extends StatefulWidget {
  final Event? event;
  final String courseID;

  EventDetailScreen({Key? key, required this.event, required this.courseID}) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  SnackbarService snackbarService = SnackbarService();

  // initialisierung der TextController und FocusNode
  late TextEditingController eventNameController;
  late TextEditingController eventDateController;
  late TextEditingController reminderDateController;
  late FocusNode eventNameFocusNode;

  DateTime? eventDate;
  DateTime? reminderDateTime;
  bool isReminderActive = false;

  final _formKey = GlobalKey<FormState>();

  bool _attemptedSubmit = false;


  @override
  void initState() {
    super.initState();
    eventNameController =
        TextEditingController(text: widget.event?.eventName ?? '');
    eventDateController = TextEditingController(
        text: widget.event?.eventDateTime != null
            ? DateFormat('d. MMMM y', 'de_DE').format(widget.event!.eventDateTime!)
            : '');
    reminderDateController = TextEditingController(
        text: widget.event?.reminderDateTime != null
            ? DateFormat('d. MMMM y, HH:mm', 'de_DE').format(widget.event!.reminderDateTime!)
            : '');
    eventNameFocusNode = FocusNode();

    eventDate = widget.event?.eventDateTime;
    reminderDateTime = widget.event?.reminderDateTime;
    isReminderActive = widget.event?.isReminderActive ?? false;
  }

  void dispose() {
    eventNameController.dispose();
    eventNameFocusNode.dispose();
    eventDateController.dispose();
    reminderDateController.dispose();
    super.dispose();
  }

  void _openDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: eventDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        eventDate = pickedDate;
        eventDateController.text = DateFormat('d. MMMM y', 'de_DE').format(pickedDate);
        if (_attemptedSubmit) {
          _formKey.currentState?.validate();
        }
      });
    }
  }


  void _openReminderPicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: reminderDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(reminderDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          reminderDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          reminderDateController.text = DateFormat('d. MMMM y, HH:mm', 'de_DE').format(reminderDateTime!);
          isReminderActive = true;
        });

      } else {
        if (isReminderActive) {
          setState(() {
            isReminderActive = false;
          });
        }
      }
    } else {

      if (isReminderActive) {
        setState(() {
          isReminderActive = false;
        });
      }
    }
  }


  void _saveEvent() async {
    setState(() {
      _attemptedSubmit = true;
    });
    if (_formKey.currentState?.validate() == true) {
      String eventName = eventNameController.text;

      isReminderActive = reminderDateTime != null && reminderDateTime!.isAfter(DateTime.now());

      if (widget.event == null) {
        // Neues Event erstellen und hinzufügen
        int newEventId = await CourseRepository.instance.addEventToCourse(
          widget.courseID,
          eventName,
          eventDate!,
          reminderDateTime,
          isReminderActive,
        );
        print('newEventId: $newEventId');
        if (isReminderActive) {
          await NotificationHelper.checkPermissionsAndScheduleSingleNotification(
            notificationId: newEventId,
            dateTime: reminderDateTime!,
            context: context,
            title: eventName,
          );
          snackbarService.showReminderUpdatedSnackbar(context, true);
        }


      } else {
        // Bestehendes Event aktualisieren
        bool wasReminderUpdated = isReminderActive != widget.event!.isReminderActive;
        widget.event!.eventName = eventName;
        widget.event!.eventDateTime = eventDate!;
        widget.event!.reminderDateTime = reminderDateTime;
        widget.event!.isReminderActive = isReminderActive;

        await CourseRepository.instance.updateEventFromCourse(
            widget.courseID, widget.event!);
        if (wasReminderUpdated) {
          if (isReminderActive) {
            await NotificationHelper.checkPermissionsAndScheduleSingleNotification(
              notificationId: widget.event!.id,
              dateTime: reminderDateTime!,
              context: context,
              title: eventName,
            );
            snackbarService.showReminderUpdatedSnackbar(context, true);
          } else {
            AwesomeNotifications().cancel(widget.event!.id!);
          }
        }
      }

      CourseProvider courseProvider = context.read<CourseProvider>();
      await courseProvider.readCourses();
      Navigator.of(context).pop();
    }
  }



  void _confirmDeleteEvent() async {
    final bool confirm = await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Prüfung/Abgabe löschen?'),
            content: const Text(
                'Bist du sicher, dass du diese Prüfung/Abgabe löschen möchtest?'),
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
      AwesomeNotifications().cancel(widget.event!.id!);
      await CourseRepository.instance.deleteEventFromCourse(widget.courseID, widget.event!.id);
      CourseProvider courseProvider = context.read<CourseProvider>();
      await courseProvider.readCourses();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null ? 'Neue Prüfung/Abgabe erstellen' : 'Prüfung/Abgabe bearbeiten',
          style: const TextStyle(fontSize: 24),),
        actions: [
          if (widget.event != null) IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDeleteEvent,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: eventNameController,
                focusNode: eventNameFocusNode,
                decoration: const InputDecoration(labelText: 'Prüfung-/Abgabename'),
                onChanged: (value) {
                  if (_attemptedSubmit) {
                    _formKey.currentState?.validate();
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Prüfung-/Abgabename darf nicht leer sein.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: eventDateController,
                decoration: const InputDecoration(labelText: 'Datum', prefixIcon: Icon(Icons.calendar_today),),
                readOnly: true,
                onTap: _openDatePicker,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Datum darf nicht leer sein.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: reminderDateController,
                decoration: InputDecoration(
                  labelText: 'Erinnerung: (Optional)',
                  prefixIcon: const Icon(Icons.alarm),
                  suffixIcon: reminderDateController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      if (isReminderActive) {
                        snackbarService.showReminderUpdatedSnackbar(context, false);
                        AwesomeNotifications().cancel(widget.event!.id!);
                      }
                      setState(() {
                        reminderDateTime = null;
                        reminderDateController.clear();
                        isReminderActive = false;
                      });
                    },
                  )
                      : null,
                ),
                readOnly: true,
                onTap: _openReminderPicker,
                validator: (value) {
                  if (reminderDateTime != null && reminderDateTime!.isBefore(DateTime.now())) {
                    return 'Erinnerungsdatum darf nicht in der Vergangenheit liegen.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEvent,
                child: Text(widget.event == null ? 'Prüfung/Abgabe hinzufügen' : 'Prüfung/Abgabe aktualisieren'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}