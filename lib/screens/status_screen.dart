import 'package:clinique_doctor/screens/event_editing_dialog.dart';
import 'package:clinique_doctor/screens/homepage.dart';
import 'package:clinique_doctor/widgets/calendar_widget.dart';
import 'package:clinique_doctor/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: navigationDrawer(context),
        appBar: AppBar(
          title: Text("Status").center(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(content: EventEditingDialog());
                });
          },
          child: Icon(Icons.add),
        ),
        body: CalendarWidget(
          clinicId: auth.currentUser!.uid,
        ));
  }
}
