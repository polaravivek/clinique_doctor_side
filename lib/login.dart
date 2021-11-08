import 'package:clinique/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email, password;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.white),
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
                                onPressed: () async {
                                  auth.signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );

                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString('email', email);

                                  Navigator.pushNamed(context, '/homepage');
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
      ),
    );
  }
}
