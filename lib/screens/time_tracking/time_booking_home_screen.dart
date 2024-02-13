import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studymate/screens/time_tracking/time_booking_detail_screen.dart';
import '../../entity/time_booking.dart';
import '../../providers/course_provider.dart';
import '../../widgets/empty_state_widget.dart';

import '../../widgets/lists/time_booking_list_widget.dart';
import '../settings_screen.dart';

class TimeTrackingScreen extends StatefulWidget {
  const TimeTrackingScreen({Key? key}) : super(key: key);

  @override
  _TimeTrackingScreenState createState() => _TimeTrackingScreenState();
}

class _TimeTrackingScreenState extends State<TimeTrackingScreen> {

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final bool hasCourses = courseProvider.courses.isNotEmpty;
    final bool hasTimeBookings = courseProvider.courses.any((course) => course.timeBookings.isNotEmpty);

    void _navigateToAddTimeBookingScreen(TimeBooking? booking) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TimeBookingDetailScreen(booking: booking),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zeiterfassung'),
        leading: const Icon(Icons.timer),
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
          ? Padding(
        padding: const EdgeInsets.only(top: 10),
        child: hasTimeBookings
            ? TimeBookingListWidget(onEdit: _navigateToAddTimeBookingScreen)
            : const EmptyStateWidget(
          iconData: Icons.timer,
          message: 'Keine Zeitbuchungen vorhanden.\nErstellen Sie eine neue Zeitbuchung für einen Kurs.',
        ),
      )
          : const EmptyStateWidget(
        iconData: Icons.book,
        message: 'Bitte erstellen Sie zuerst Kurse, bevor Sie Zeitbuchungen vornehmen können.',
      ),
      floatingActionButton: hasCourses
          ? FloatingActionButton.extended(
        heroTag: 'addTimeBooking_btn',
        onPressed: () => _navigateToAddTimeBookingScreen(null),
        icon: const Icon(Icons.add),
        label: const Text('Zeitbuchung hinzufügen'),
      )
          : null, // Plus-Icon ausblenden, wenn keine Kurse vorhanden sind
    );
  }
}
