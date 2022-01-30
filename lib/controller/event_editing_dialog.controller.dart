import 'package:clinique_doctor/model/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventEditingController extends GetxController {
  final Event? event = null;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  final RxBool loading = false.obs;

  bool get isLoading => loading.value;

  startLoading() => loading.value = true;
  stopLoading() => loading.value = false;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> saveInfo(Event event, bool isForEdit) async {
    startLoading();

    if (isForEdit) {
      print(event.id);
      _firestore
          .collection("custom_status")
          .doc(auth.currentUser!.uid)
          .collection("status")
          .doc(event.id)
          .update(event.toMap())
          .then((value) {
        print("updated");
        stopLoading();
      });
    } else {
      _firestore
          .collection("custom_status")
          .doc(auth.currentUser!.uid)
          .collection("status")
          .doc()
          .set(event.toMap())
          .then((value) {
        print("success");
        stopLoading();
      });
    }
  }
}
