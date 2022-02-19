import 'package:clinique_doctor/controller/calender.controller.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimeSlotController extends GetxController {
  CalendarScreenController calendarController =
      Get.find<CalendarScreenController>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ref = FirebaseDatabase.instance.reference();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var uid;

  final selectedTime = "".obs;

  @override
  void onInit() {
    uid = auth.currentUser!.uid;
    super.onInit();
  }
}
