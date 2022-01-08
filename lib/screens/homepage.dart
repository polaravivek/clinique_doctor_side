import 'dart:collection';

import 'package:clinique_doctor/screens/member_call.dart';
import 'package:clinique_doctor/widgets/build_queue_member.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
var _count = 0;
List<String> _arr = [];
List<String> _holdArr = [];

class Homepage extends StatefulWidget {
  final title;

  const Homepage(this.title);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isReal = true;

  @override
  void initState() {
    _arr.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logout() {
      auth.signOut().then((value) async {
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Navigator.pushNamedAndRemoveUntil(
            context, "/login", (Route<dynamic> route) => false);
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffFFC7C7),
        appBar: AppBar(
          centerTitle: true,
          actionsIconTheme: IconThemeData(color: Colors.white),
          title: Text(widget.title),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  print("button pressed");
                  logout();
                },
                icon: Icon(Icons.settings)),
          ],
          backgroundColor: Color(0xff8A1818),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      color: Color(0xffFFA8A8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: Column(
                          children: [
                            Text(
                              "PATIENT COUNT",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff8A1818),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            StreamBuilder(
                                stream:
                                    _firestore.collection('queue').snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text("loading....");
                                  }
                                  final snap = snapshot.data.docs;

                                  for (var sn in snap) {
                                    if (sn.id == auth.currentUser.uid) {
                                      _count = sn.get('count');
                                      break;
                                    }
                                  }
                                  return Text(
                                    "$_count",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff8A1818),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Card(
                      color: Color(0xffFFA8A8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "EXPECTED TIME",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff8A1818),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            StreamBuilder(
                                stream:
                                    _firestore.collection('queue').snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text("loading....");
                                  }
                                  final snap = snapshot.data.docs;

                                  for (var sn in snap) {
                                    if (sn.id == auth.currentUser.uid) {
                                      _count = sn.get('count');
                                      break;
                                    }
                                  }

                                  return Text(
                                    "${_count * 5} min",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff8A1818),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(40),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10),
                              textStyle: const TextStyle(
                                  fontSize: 16, letterSpacing: 1.5),
                              elevation: 5,
                              primary:
                                  isReal ? Colors.red[400] : Color(0xFF8A1818),
                            ),
                            onPressed: () {
                              if (!isReal) {
                                setState(() {
                                  _arr.clear();
                                  isReal = true;
                                });
                              }
                            },
                            child: Text("REAL QUEUE"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(40),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10),
                              textStyle: const TextStyle(
                                  fontSize: 16, letterSpacing: 1.5),
                              elevation: 5,
                              primary:
                                  isReal ? Color(0xFF8A1818) : Colors.red[400],
                            ),
                            onPressed: () {
                              if (isReal) {
                                setState(() {
                                  isReal = false;
                                });
                              }
                            },
                            child: Text("HOLD QUEUE"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //container for showing queue members
              Expanded(
                child: Container(
                  child: (isReal)
                      ? StreamBuilder(
                          stream: _firestore
                              .collection('queue')
                              .doc('${auth.currentUser.uid}')
                              .collection('queue')
                              .orderBy('time')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Lottie.asset('assets/lottie/queue.json',
                                  width: 300,
                                  height: 300,
                                  frameRate: FrameRate(60),
                                  repeat: true);
                            } else {
                              final snap = snapshot.data.docs;
                              _arr.clear();
                              for (var sn in snap) {
                                LinkedHashMap<String, dynamic> s = sn.data();
                                var name = s['name'];
                                _arr.add(name);
                              }

                              if (_arr.length == 0) {
                                return queueMember("No member available", "",
                                    Colors.white, Colors.white, Colors.black);
                              } else {
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: _arr.length,
                                  itemBuilder: (_, index) {
                                    if (index >= 3) {
                                      return queueMember(
                                          "${_arr[index]}",
                                          "${index + 1}.",
                                          Colors.white,
                                          Colors.white,
                                          Colors.black);
                                    } else {
                                      return queueMember(
                                          "${_arr[index]}",
                                          "${index + 1}.",
                                          Colors.green,
                                          Colors.lightGreen,
                                          Colors.white);
                                    }
                                  },
                                );
                              }
                            }
                          },
                        )
                      : StreamBuilder(
                          stream: _firestore
                              .collection('queue')
                              .doc('${auth.currentUser.uid}')
                              .collection('holdQueue')
                              .orderBy('time')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Lottie.asset('assets/lottie/queue.json',
                                  width: 300,
                                  height: 300,
                                  frameRate: FrameRate(60),
                                  repeat: true);
                            }

                            final snap = snapshot.data.docs;
                            _holdArr.clear();
                            for (var sn in snap) {
                              LinkedHashMap<String, dynamic> s = sn.data();
                              var name = s['name'];
                              _holdArr.add(name);
                            }

                            if (_holdArr.length == 0) {
                              return queueMember("No member available", "",
                                  Colors.white, Colors.white, Colors.black);
                            } else {
                              return ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: _holdArr.length,
                                itemBuilder: (_, index) {
                                  return queueMember(
                                      "${_holdArr[index]}",
                                      "${index + 1}.",
                                      Colors.white,
                                      Colors.white,
                                      Colors.black);
                                },
                              );
                            }
                          },
                        ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 7),
                            textStyle: const TextStyle(fontSize: 14),
                            elevation: 5,
                            primary: Color(0xFF8A1818),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MemberCall(
                                        widget.title, auth.currentUser.uid)));
                          },
                          child: Text("CALL FIRST MEMBER"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            textStyle: const TextStyle(fontSize: 14),
                            elevation: 5,
                            primary: Color(0xFF8A1818),
                          ),
                          onPressed: () {},
                          child: Text("SEND IT TO HOLD"),
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
    );
  }
}
