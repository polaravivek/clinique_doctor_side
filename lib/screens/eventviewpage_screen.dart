import 'package:clinique_doctor/controller/event_viewpage_controller.dart';
import 'package:clinique_doctor/model/event.dart';
import 'package:clinique_doctor/screens/event_editing_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class EventViewingPage extends StatefulWidget {
  final Event eventDetails;

  EventViewingPage({Key? key, required this.eventDetails}) : super(key: key);

  @override
  _EventViewingPageState createState() => _EventViewingPageState();
}

class _EventViewingPageState extends State<EventViewingPage> {
  final EventViewPageController eventViewPageController =
      Get.put(EventViewPageController());
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  eventViewPageController
                      .changeTitle(widget.eventDetails.title);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: EventEditingDialog(
                            event: widget.eventDetails,
                            isForEdit: true,
                          ),
                        );
                      });
                },
                icon: Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.delete),
              ),
            ],
            title: Text("View Event").center(),
          ),
          body: GetBuilder<EventViewPageController>(
            init: EventViewPageController(),
            builder: (controller) {
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      "Title :",
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Obx(() => Text(
                          (controller.getTitle!.isEmpty)
                              ? widget.eventDetails.title
                              : controller.getTitle!,
                          style: TextStyle(fontSize: 16),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => buildText(
                        (controller.getTitle!.isEmpty)
                            ? widget.eventDetails.from
                            : controller.getFrom!,
                        "From"),
                  ),
                  Obx(
                    () => buildText(
                        (controller.getTitle!.isEmpty)
                            ? widget.eventDetails.to
                            : controller.getTo!,
                        "To"),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildText(DateTime dateTime, String title) {
    String day;
    if (dateTime.weekday == 1) {
      day = "Monday";
    } else if (dateTime.weekday == 2) {
      day = "Tuesday";
    } else if (dateTime.weekday == 3) {
      day = "Wednesday";
    } else if (dateTime.weekday == 4) {
      day = "Thursday";
    } else if (dateTime.weekday == 5) {
      day = "Friday";
    } else if (dateTime.weekday == 6) {
      day = "Saturday";
    } else {
      day = "Sunday";
    }

    return ListTile(
      title: Text(
        "$title :",
        style: TextStyle(fontSize: 20),
      ),
      trailing: Text(
          ("$day, ${dateTime.day} ${dateTime.month}, ${dateTime.year} ${dateTime.hour}:${dateTime.minute}")),
    );
  }
}
