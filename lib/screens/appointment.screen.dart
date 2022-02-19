import 'package:clinique_doctor/screens/homepage.dart';
import 'package:clinique_doctor/widgets/calendar_widget.dart';
import 'package:clinique_doctor/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navigationDrawer(context),
      appBar: AppBar(
        title: Text("Appointments").center(),
      ),
      body: CalendarWidget(
        clinicId: auth.currentUser!.uid,
        isAppointment: true,
      ),
    );
  }
}
