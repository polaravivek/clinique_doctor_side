import 'dart:async';

import 'package:clinique_doctor/controller/event_editing_dialog.controller.dart';
import 'package:clinique_doctor/controller/event_viewpage_controller.dart';
import 'package:clinique_doctor/model/event.dart';
import 'package:clinique_doctor/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class EventEditingDialog extends StatefulWidget {
  EventEditingDialog({Key? key, this.event, this.isForEdit = false})
      : super(key: key);

  Event? event;
  bool isForEdit;

  @override
  State<EventEditingDialog> createState() => _EventEditingDialogState();
}

class _EventEditingDialogState extends State<EventEditingDialog> {
  late DateTime fromDate;
  late DateTime toDate;

  final titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final EventViewPageController eventViewPageController =
      Get.put(EventViewPageController());

  @override
  void initState() {
    super.initState();
    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    } else {
      Event event = widget.event!;
      titleController.text = eventViewPageController.getTitle!;
      fromDate = event.from;
      toDate = event.to;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventEditingController>(
      init: EventEditingController(),
      builder: (controller) {
        return Material(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
                maxWidth: MediaQuery.of(context).size.width),
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(12),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildTitle(),
                        SizedBox(
                          height: 12,
                        ),
                        buildDateTimePicker(),
                        ElevatedButton(
                            onPressed: () {
                              var isValid = _formKey.currentState!.validate();
                              Event event;
                              if (isValid) {
                                if (widget.isForEdit) {
                                  event = new Event(
                                      id: widget.event!.id,
                                      title: titleController.text,
                                      from: fromDate,
                                      to: toDate);
                                } else {
                                  event = new Event(
                                      title: titleController.text,
                                      from: fromDate,
                                      to: toDate);
                                }

                                if (widget.isForEdit) {
                                  controller
                                      .saveInfo(event, true)
                                      .then((value) {
                                    print(event.title);
                                    print(event.from);
                                    print(event.to);
                                    eventViewPageController
                                        .changeTitle(event.title);
                                    eventViewPageController
                                        .changeFrom(event.from);
                                    eventViewPageController.changeTo(event.to);
                                    Navigator.pop(context);
                                  });
                                } else {
                                  controller
                                      .saveInfo(event, false)
                                      .then((value) => Navigator.pop(context));
                                }
                              }
                            },
                            child: Text("SAVE"))
                      ],
                    ),
                  ),
                ),
                Obx(() {
                  if (controller.isLoading) {
                    return Positioned.fill(
                        child: CircularProgressIndicator()
                            .center()
                            .backgroundColor(Colors.black26));
                  } else {
                    return SizedBox();
                  }
                })
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTitle() => TextFormField(
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(
              color: Color(0xFFD99D9D),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(
              color: Color(0xFFAA6262),
            ),
          ),
          border: OutlineInputBorder(),
          hintText: 'Add Title',
        ),
        onFieldSubmitted: (_) {},
        controller: titleController,
        validator: (title) =>
            title != null && title.isEmpty ? "Title can't be empty" : null,
      );

  Widget buildDateTimePicker() => Column(
        children: [
          buildFrom(),
          buildTo(),
        ],
      );

  Widget buildFrom() => buildHeader(
        header: "From",
        child: Row(children: [
          Expanded(
            flex: 3,
            child: buildDropdownField(
                text: Utils.toDate(fromDate),
                onClicked: () => pickFromDateTime(pickDate: true)),
          ),
          Expanded(
            flex: 2,
            child: buildDropdownField(
                text: Utils.toTime(fromDate),
                onClicked: () => pickFromDateTime(pickDate: false)),
          )
        ]),
      );

  Widget buildTo() => buildHeader(
        header: "To",
        child: Row(children: [
          Expanded(
            flex: 3,
            child: buildDropdownField(
                text: Utils.toDate(toDate),
                onClicked: () => pickToDateTime(pickDate: true)),
          ),
          Expanded(
            flex: 2,
            child: buildDropdownField(
                text: Utils.toTime(toDate),
                onClicked: () => pickToDateTime(pickDate: false)),
          )
        ]),
      );

  Widget buildDropdownField(
          {required String text, required VoidCallback onClicked}) =>
      ListTile(
        title: Text(
          text,
          style: TextStyle(fontSize: 12),
        ),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({required String header, required Row child}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(fontWeight: FontWeight.bold),
          ).padding(left: 10),
          child
        ],
      );

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);

    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    setState(() {
      fromDate = date;
    });
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate,
        pickDate: pickDate, firstDate: pickDate ? fromDate : null);

    if (date == null) return;

    setState(() {
      toDate = date;
    });
  }

  Future<DateTime?> pickDateTime(DateTime initialDate,
      {required bool pickDate, DateTime? firstDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime.now(),
          lastDate: DateTime(2101));

      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(initialDate));

      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }
}
