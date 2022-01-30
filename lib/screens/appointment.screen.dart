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
        title: Text("Appointment").center(),
      ),
      body: Container(
        child: Text("Appointment").center(),
      ),
    );
  }
}
