import 'package:clinique_doctor/screens/homepage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarScreenController extends GetxController {
  Rx<DateTime> selectedDate = DateTime.now().obs;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  RxMap appointmentData = {}.obs;

  changeSelectedDate(DateTime date) => selectedDate.value = date;

  getAllAlreadyTakenSlots() {
    var result = firebaseFirestore
        .collection("appointments")
        .doc(auth.currentUser!.uid)
        .snapshots()
        .map((doc) => doc.data());

    result.listen((data) {
      // print("data $data");
      appointmentData.value = data![selectedDate.value.toString()];
    });
  }
}
