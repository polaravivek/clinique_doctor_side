import 'package:clinique_doctor/controller/homepage.controller.dart';
import 'package:clinique_doctor/controller/main.controller.dart';
import 'package:clinique_doctor/screens/appointment.screen.dart';
import 'package:clinique_doctor/screens/homepage.dart';
import 'package:clinique_doctor/screens/status_screen.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Drawer navigationDrawer(BuildContext context) {
  var width = MediaQuery.of(context).size.width;
  var height = MediaQuery.of(context).size.height;

  return Drawer(
    backgroundColor: Color(0xffFFC7C7),
    child: GetBuilder<HomePageController>(builder: (controller) {
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xff8A1818),
            ),
            height: height * 0.2,
            width: width,
          ),
          SizedBox(
            height: 20,
          ),
          Obx(() {
            return menuItem(
                "Home",
                controller.selectedString.value == "Home" ? true : false,
                controller,
                context);
          }),
          SizedBox(
            height: 10,
          ),
          Obx(() {
            return menuItem(
                "Status",
                controller.selectedString.value == "Status" ? true : false,
                controller,
                context);
          }),
          SizedBox(
            height: 10,
          ),
          Obx(() {
            return menuItem(
                "Appointments",
                controller.selectedString.value == "Appointments"
                    ? true
                    : false,
                controller,
                context);
          }),
        ],
      );
    }),
  );
}

InkWell menuItem(String menuLabel, bool isSelected,
    HomePageController controller, BuildContext context) {
  MainController mainController = Get.find<MainController>();
  return InkWell(
    splashColor: Color(0xffFFC7C7),
    highlightColor: Color(0xffFFC7C7),
    onTap: () {
      print(menuLabel);
      controller.changeSelected(menuLabel);
      if (menuLabel == "Home") {
        if (controller.modelDoctorInfo != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Homepage(
                  mainController.clinicTitle.value, controller.modelDoctorInfo),
            ),
          );
        } else {}
      } else if (menuLabel == "Status") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StatusScreen(),
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AppointmentScreen(),
          ),
        );
      }
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          menuLabel,
          style: TextStyle(
            fontSize: 18,
          ),
        ).padding(all: 15),
      ],
    )
        .backgroundColor(isSelected
            ? Color(0xff8A1818).withOpacity(0.20)
            : Colors.transparent)
        .clipRRect(all: 15)
        .padding(horizontal: 20),
  );
}
