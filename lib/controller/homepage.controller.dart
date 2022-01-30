import 'package:clinique_doctor/model/doctor_info.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePageController extends GetxController {
  final RxString selectedString = "Home".obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.reference();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late ModelDoctorInfo modelDoctorInfo;

  changeSelected(String selectedMenu) => selectedString.value = selectedMenu;

  @override
  void onInit() async {
    await getModelInfo(auth.currentUser!.uid);
    super.onInit();
  }

  Future getModelInfo(String uid) async {
    late int count;
    late String name;
    await firestore.collection("queue").doc(uid).get().then((value) {
      count = value.get("count");
      print(count);

      databaseRef
          .child("doctorInfo")
          .child("doctorPersonalInfo")
          .child(uid)
          .get()
          .then((value2) {
        name = value2!.value["name"];
        databaseRef
            .child("doctorInfo")
            .child("clinicInfo")
            .child(uid)
            .get()
            .then((value1) {
          if (value1!.key == uid) {
            var img = value1.value["img"];
            FirebaseStorage.instance
                .ref()
                .child(img)
                .getDownloadURL()
                .then((url) {
              Map<String, dynamic> map = Map.from(value1.value);
              print(map);
              map["count"] = count.toString();
              map["docId"] = uid;
              map["doctorName"] = name;
              map["img"] = url;

              modelDoctorInfo = ModelDoctorInfo.fromMap(map);

              print(modelDoctorInfo.img);
              print(modelDoctorInfo.toMap().toString());
            });
          }
        });
      });
    });
  }
}
