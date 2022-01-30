import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/UserInfoModel.dart';
import 'package:clinique_doctor/screens/login.dart';

class Register extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

const MaterialColor _buttonTextColor = MaterialColor(0xFFFFB5B5, <int, Color>{
  50: Color(0xFFFFB5B5),
  100: Color(0xFFFFB5B5),
  200: Color(0xFFFFB5B5),
  300: Color(0xFFFFB5B5),
  400: Color(0xFFFFB5B5),
  500: Color(0xFFFFB5B5),
  600: Color(0xFFFFB5B5),
  700: Color(0xFFFFB5B5),
  800: Color(0xFFFFB5B5),
  900: Color(0xFFFFB5B5)
});

class _MyAppState extends State<Register> {
  late String email, password, name, dob, phoneNo, confirmPass;
  final auth = FirebaseAuth.instance;
  final fb = FirebaseDatabase.instance;

  DateTime _date = DateTime.now();
  DateTime finalYear = DateTime.now();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? _datePicker = await showDatePicker(
        context: context,
        initialDate: DateTime(_date.year),
        firstDate: DateTime(1945),
        lastDate: DateTime(finalYear.year),
        builder: (BuildContext? context, Widget? child) {
          return Theme(
            data: ThemeData(
              primaryColor: Color(0xFFFFB5B5),
              colorScheme:
                  ColorScheme.fromSwatch(primarySwatch: _buttonTextColor)
                      .copyWith(secondary: Color(0xFFFFB5B5)),
            ),
            child: child!,
          );
        });
    {
      if (_datePicker != null && _datePicker != _date) {
        setState(() {
          _date = _datePicker;
          _dateController.value =
              TextEditingValue(text: _date.toString().split(" ").first);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffFFC7C7),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Color(0xFF9B3D3D),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 40, right: 60, left: 60, bottom: 10),
                      child: TextField(
                        cursorColor: Color(0xFF9B3D3D),
                        controller: _nameController,
                        onChanged: (v) {
                          name = v.toString();
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
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
                          hintText: 'Enter Your Name',
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              cursorColor: Color(0xFF9B3D3D),
                              controller: _dateController,
                              onChanged: (v) {
                                dob = v.toString();
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
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
                                hintText: "Pick Date Of Birth",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(10)),
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFF9B3D3D)),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectDate(context);
                              });
                            },
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    NewTextField(
                      controller: _phoneController,
                      hintText: 'Enter Your Phone No.',
                      textInputType: TextInputType.number,
                      maxlength: 10,
                    ),
                    NewTextField(
                      controller: _emailController,
                      hintText: 'Enter Email Address',
                      textInputType: TextInputType.emailAddress,
                      maxlength: 40,
                    ),
                    NewTextField(
                      controller: _passwordController,
                      hintText: 'Create Password',
                      textInputType: TextInputType.number,
                      obscure: true,
                    ),
                    NewTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirm Password',
                      textInputType: TextInputType.number,
                      obscure: true,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 60),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        textBaseline: TextBaseline.ideographic,
                        children: [
                          Container(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  textStyle: const TextStyle(fontSize: 18),
                                  elevation: 5,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 30),
                                  primary: Color(0xFF9B3D3D)),
                              onPressed: () async {
                                if (_passwordController.text.compareTo(
                                        _confirmPasswordController.text) ==
                                    0) {
                                  auth
                                      .createUserWithEmailAndPassword(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                  )
                                      .then((value) {
                                    UserInfoModel userInfoModel =
                                        new UserInfoModel(
                                            name,
                                            _emailController.text.trim(),
                                            _phoneController.text,
                                            _dateController.text);
                                    ref
                                        .child("doctorInfo")
                                        .child("doctorPersonalInfo")
                                        .child(auth.currentUser!.uid)
                                        .set({
                                      "name": userInfoModel.name,
                                      "email": userInfoModel.email,
                                      "phoneNo": userInfoModel.phoneNo,
                                      "dob": userInfoModel.dob
                                    }).then((value) async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString(
                                          'email', userInfoModel.email);
                                      Navigator.pushNamed(context, '/login');
                                    });
                                  }).onError((error, stackTrace) {
                                    print(error);
                                  });
                                } else {
                                  return print("password doesn't match");
                                }
                              },
                              child: Text("Register"),
                            ),
                          ),
                          Container(
                            child: Text(
                              'Already have,',
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) => new Login(),
                                ),
                              );
                            },
                            child: Container(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Color(0xFF9B3D3D),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NewTextField extends StatelessWidget {
  const NewTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.textInputType,
    this.obscure,
    this.maxlength,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final bool? obscure;
  final int? maxlength;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
      child: TextField(
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
