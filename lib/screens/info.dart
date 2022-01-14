import 'package:clinique_doctor/screens/addLocation.dart';
import 'package:clinique_doctor/screens/homepage.dart';
import 'package:clinique_doctor/model/doctor_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Information extends StatefulWidget {
  final LatLng location;
  final ModelDoctorInfo model;
  final File image;

  Information(this.location, this.model, this.image);

  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  File _image;
  final ImagePicker _picker = ImagePicker();
  final fdRef = FirebaseDatabase.instance.reference();
  final auth = FirebaseAuth.instance;

  final TextEditingController _clinicNameController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _specializedController = TextEditingController();
  final TextEditingController _morningTimeController = TextEditingController();
  final TextEditingController _eveningTimeController = TextEditingController();
  final TextEditingController _dayOffController = TextEditingController();
  final TextEditingController _lateAllowedController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  static var doctorName;

  static bool added = false;

  void fetchLocation(LatLng location) async {
    final addresses =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    _addressController.text =
        "${addresses[0].street}, ${addresses[0].subLocality}, ${addresses[0].locality}, ${addresses[0].country}, ${addresses[0].postalCode}";
  }

  @override
  void initState() {
    if (widget.location != null) {
      fetchLocation(widget.location);
    }
    final snaps = fdRef
        .child('doctorInfo')
        .child('doctorPersonalInfo')
        .child('${auth.currentUser.uid}')
        .reference();
    snaps.once().then((DataSnapshot snapshot) {
      doctorName = snapshot.value['name'];
    });

    if (widget.model != null) {
      _clinicNameController.text = widget.model.clinicName;
      _feeController.text = widget.model.fees;
      _specializedController.text = widget.model.specialization;
      _morningTimeController.text = widget.model.morningTime;
      _eveningTimeController.text = widget.model.eveningTime;
      _dayOffController.text = widget.model.dayOff;
      _lateAllowedController.text = widget.model.lateTime;
    }

    if (widget.image != null) {
      setState(() {
        _image = widget.image;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<File> compressImage(String path, int quality) async {
      final newPath = p.join((await getTemporaryDirectory()).path,
          '${DateTime.now()}.${p.extension(path)}');

      final result = await FlutterImageCompress.compressAndGetFile(
        path,
        newPath,
        quality: quality,
      );

      return result;
    }

    Future getImage() async {
      final image = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);

      if (image == null) {
        return;
      }

      var file = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );

      if (file == null) {
        return;
      }

      file = await compressImage(file.path, 35);

      setState(() {
        _image = file;
      });
    }

    Future UploadPic(BuildContext context) async {
      String fileName = p.basename(_image.path);
      final fireStorageReference =
          FirebaseStorage.instance.ref().child(fileName);
      final uploadTask = fireStorageReference.putFile(File(_image.path));
      await uploadTask.whenComplete(() => print('complete'));
    }

    // Future<String> downloadURL(String imageName) async {
    //   String downloadURL =
    //       await FirebaseStorage.instance.ref(imageName).getDownloadURL();
    //   return downloadURL;
    // }

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Color(0x9AAB1818),
      ),
    );
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFFDDDD),
        primaryColor: Color(0xFFFFDDDD),
        primaryColorDark: Color(0xFFFFB5B5),
        accentColor: Color(0xFFFFFFF),
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                'INFORMATION COLLECTION',
                style: TextStyle(
                    color: Colors.white, fontSize: 14, letterSpacing: 2),
              ),
            ),
            backgroundColor: Color(0xff8A1818),
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Color(0xff8A1818),
                      child: ClipOval(
                        child: SizedBox(
                          width: 180,
                          height: 180,
                          child: (_image != null)
                              ? Image.file(
                                  File(_image.path),
                                  fit: BoxFit.fill,
                                )
                              : Image(
                                  image: AssetImage('assets/images/person.jpg'),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.camera,
                        size: 30,
                        color: Color(0xff8A1818),
                      ),
                      onPressed: () {
                        getImage();
                      },
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NewTextFieldForInfo(
                      controller: _clinicNameController,
                      hintText: 'Enter clinic name',
                      textInputType: TextInputType.text,
                      maxlength: 40,
                    ),
                    NewTextFieldForInfo(
                      controller: _feeController,
                      hintText: 'Enter your fees',
                      textInputType: TextInputType.number,
                      maxlength: 10,
                    ),
                    NewTextFieldForInfo(
                      controller: _specializedController,
                      hintText: 'Enter specialization',
                      textInputType: TextInputType.text,
                      maxlength: 20,
                    ),
                    NewTextFieldForInfo(
                      controller: _morningTimeController,
                      hintText: 'Enter morning time',
                      textInputType: TextInputType.text,
                      maxlength: 30,
                    ),
                    NewTextFieldForInfo(
                      controller: _eveningTimeController,
                      hintText: 'Enter evening time',
                      textInputType: TextInputType.text,
                      maxlength: 30,
                    ),
                    NewTextFieldForInfo(
                      controller: _dayOffController,
                      hintText: 'Enter day off (ex. sunday)',
                      textInputType: TextInputType.text,
                      maxlength: 20,
                    ),
                    NewTextFieldForInfo(
                      controller: _lateAllowedController,
                      hintText: 'Enter late allowed time',
                      textInputType: TextInputType.text,
                      maxlength: 20,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 18),
                          elevation: 5,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          primary: Color(0xFF8A1818),
                        ),
                        onPressed: () {
                          added = true;
                          ModelDoctorInfo model = new ModelDoctorInfo(
                              _clinicNameController.value.text,
                              "",
                              "",
                              _eveningTimeController.value.text,
                              _feeController.value.text,
                              _morningTimeController.value.text,
                              _specializedController.value.text,
                              0.0,
                              0.0,
                              0.0,
                              0,
                              "",
                              _dayOffController.value.text,
                              _lateAllowedController.value.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddLocation(
                                model: model,
                                file: _image,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'ADD LOCATION',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    added
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "you can edit the address:",
                                  style: TextStyle(
                                      color: Color(0xFF8A1818),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    added
                        ? NewTextFieldForInfo(
                            controller: _addressController,
                            hintText: '',
                            maxlength: 100,
                            maxLine: 3,
                            textInputType: TextInputType.streetAddress)
                        : Container(),
                    Center(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 18),
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            primary: Color(0xFF8A1818),
                          ),
                          onPressed: () async {
                            UploadPic(context);
                            fdRef
                                .child('doctorInfo')
                                .child('clinicInfo')
                                .child(auth.currentUser.uid)
                                .set({
                              "address": _addressController.value.text,
                              "clinicName": _clinicNameController.value.text,
                              "evening time": _eveningTimeController.value.text,
                              "fees": _feeController.value.text,
                              "latitude": widget.location.latitude,
                              "longitude": widget.location.longitude,
                              "morning time": _morningTimeController.value.text,
                              "name": doctorName,
                              "review": 0,
                              "dayoff": _dayOffController.value.text,
                              "specialization":
                                  _specializedController.value.text,
                              "lateAllowedTime":
                                  _lateAllowedController.value.text,
                              "img": p.basename(_image.path)
                            }).then((value) async {
                              _firestore
                                  .collection('queue')
                                  .doc(auth.currentUser.uid)
                                  .set({"count": 0});
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('isInfoAdded', "true").then(
                                    (value) => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Homepage(
                                            _clinicNameController.value.text),
                                      ),
                                    ),
                                  );
                            });
                          },
                          child: Text(
                            'ADD QUEUE',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}

class NewTextFieldForInfo extends StatelessWidget {
  const NewTextFieldForInfo({
    Key key,
    @required this.controller,
    @required this.hintText,
    @required this.textInputType,
    this.obscure,
    this.maxlength,
    this.maxLine,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final bool obscure;
  final int maxlength;
  final int maxLine;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        maxLines: maxLine,
        maxLength: (maxlength != null) ? maxlength : 20,
        obscureText: (obscure == null) ? false : true,
        cursorColor: Color(0xFF9B3D3D),
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          counterText: "",
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
          hintText: hintText,
        ),
      ),
    );
  }
}
