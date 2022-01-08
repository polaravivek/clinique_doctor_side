import 'package:clinique_doctor/screens/homepage.dart';
import 'package:clinique_doctor/screens/info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email, password;
  final auth = FirebaseAuth.instance;
  final fdRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
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
                      "Login",
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
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Color(0xFF9B3D3D),
                        onChanged: (v) {
                          email = v.toString();
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
                          hintText: 'Enter Registered Email',
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                      child: TextField(
                        obscureText: true,
                        cursorColor: Color(0xFF9B3D3D),
                        onChanged: (v) {
                          password = v.toString();
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
                              color: Color(
                                0xFFAA6262,
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'Enter Your Password',
                        ),
                      ),
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
                                    vertical: 10, horizontal: 40),
                                primary: Color(0xFF9B3D3D),
                              ),
                              onPressed: () {
                                try {
                                  auth
                                      .signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  )
                                      .then((value) async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString('email', email);
                                    prefs.setString('isInfoAdded', "true");
                                    fdRef
                                        .child('doctorInfo')
                                        .child('clinicInfo')
                                        .child('${auth.currentUser.uid}')
                                        .get()
                                        .then((value) {
                                      if (value.value == null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Information(null, null, null),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Homepage(
                                                value.value["clinicName"]),
                                          ),
                                        );
                                      }
                                    });
                                  }).onError((error, stackTrace) {
                                    print(error);
                                  });
                                } catch (e) {
                                  print("message is : $e");
                                }
                              },
                              child: Text("Login"),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Don't have,",
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Container(
                              child: Text(
                                "Register",
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
