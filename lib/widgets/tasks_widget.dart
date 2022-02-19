import 'package:clinique_doctor/controller/event_viewpage_controller.dart';
import 'package:clinique_doctor/controller/main.controller.dart';
import 'package:clinique_doctor/model/event.dart';
import 'package:clinique_doctor/screens/eventviewpage_screen.dart';
import 'package:clinique_doctor/widgets/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({Key? key}) : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  MainController mainController = Get.find<MainController>();
  EventViewPageController eventViewPageController =
      Get.put(EventViewPageController());

  @override
  Widget build(BuildContext context) {
    final selectedEvents = mainController.eventsOfSelectedDate;
    if (selectedEvents.isEmpty) {
      return Center(
        child: Text(
          "No Event Found",
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      );
    }

    return Obx(() => SfCalendar(
          onTap: (details) {
            eventViewPageController.changeTitle("");
            print("tapped");
            if (details.appointments != null) {
              Event eventsDetails = details.appointments!.first;
              print(eventsDetails.id);

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      EventViewingPage(eventDetails: eventsDetails)));
            }
          },
          view: CalendarView.timelineDay,
          dataSource: EventDataSouce(mainController.allEvents),
          initialDisplayDate: mainController.selectedDate,
          todayHighlightColor: Colors.black,
        ));
  }
}
