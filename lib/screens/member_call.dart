import 'dart:collection';
import 'package:clinique_doctor/widgets/build_queue_member.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

var _count = 0;
final auth = FirebaseAuth.instance;
var _firstUid;

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class MemberCall extends StatefulWidget {
  final title;
  final uid;

  const MemberCall(this.title, this.uid);

  @override
  State<MemberCall> createState() => _MemberCallState();
}

class _MemberCallState extends State<MemberCall> {
  List<String> _arr = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffFFC7C7),
        appBar: AppBar(
          centerTitle: true,
          actionsIconTheme: IconThemeData(color: Colors.white),
          title: Text(widget.title),
          automaticallyImplyLeading: false,
          actions: [],
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
              SizedBox(
                height: 10,
              ),
              //container for showing queue members
              Expanded(
                child: Container(
                  child: StreamBuilder(
                    stream: _firestore
                        .collection('queue')
                        .doc('${auth.currentUser.uid}')
                        .collection('queue')
                        .orderBy('time')
                        .limit(3)
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
                        int index = 0;
                        for (var sn in snap) {
                          if (index == 0) {
                            _firstUid = sn.id;
                            print(_firstUid);
                          }
                          LinkedHashMap<String, dynamic> s = sn.data();
                          var name = s['name'];
                          _arr.add(name);
                          index++;
                        }

                        if (_arr.length == 0) {
                          return queueMember("No member available", "",
                              Colors.white, Colors.white, Colors.black);
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: _arr.length,
                            itemBuilder: (_, index) {
                              return queueMember(
                                  "${_arr[index]}",
                                  "${index + 1}.",
                                  Colors.green,
                                  Colors.lightGreen,
                                  Colors.white);
                            },
                          );
                        }
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
                            _firestore
                                .collection('queue')
                                .doc('${widget.uid}')
                                .collection('queue')
                                .snapshots()
                                .forEach((element) {
                              element.docs.forEach((element) {
                                print(element.id);
                                print(_firstUid.toString());
                                if (_firstUid.toString() ==
                                    element.id.toString()) {
                                  element.reference.delete().then((value) {
                                    _firestore
                                        .collection('queue')
                                        .doc('${widget.uid}')
                                        .get()
                                        .then((value) {
                                      var count = value["count"];

                                      _firestore
                                          .collection('queue')
                                          .doc('${widget.uid}')
                                          .update({'count': --count}).then(
                                              (value) {
                                        // Navigator.pop(context);
                                      });
                                    });
                                  });
                                }
                              });
                            });
                          },
                          child: Text(
                            "CALL FIRST MEMBER",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
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
                          onPressed: () {
                            _firestore
                                .collection('queue')
                                .doc('${widget.uid}')
                                .collection('queue')
                                .snapshots()
                                .forEach((element) {
                              element.docs.forEach((element) {
                                if (_firstUid.toString() ==
                                    element.id.toString()) {
                                  element.reference.get().then((value) {
                                    _firestore
                                        .collection('queue')
                                        .doc('${widget.uid}')
                                        .collection('holdQueue')
                                        .doc(_firstUid.toString())
                                        .set(value.data())
                                        .then((value) {
                                      element.reference.delete();
                                    });
                                  });
                                }
                              });
                            });
                          },
                          child: Text(
                            "SEND TO HOLD",
                            style: TextStyle(
                              fontSize: 12,
                            ),
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
    );
  }
}
