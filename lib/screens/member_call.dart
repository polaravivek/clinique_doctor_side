import 'dart:collection';
import 'dart:convert';
import 'package:clinique_doctor/widgets/build_queue_member.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  List<String> _tokens = [];

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  String constructFCMPayload(String token, int number) {
    return jsonEncode({
      'to': token,
      'data': {},
      'notification': {
        'title': (number != null)
            ? (number == 0)
                ? "It's Your Turn"
                : (number == 1)
                    ? "It's Your Number Go!"
                    : (number == 2)
                        ? "Be Ready You Have To Go Next"
                        : (number != 3)
                            ? "Your Number: $number"
                            : "Your Number Is About To Come"
            : "Put You On Hold",
        'body': (number != null)
            ? 'sent to you from ${widget.title}'
            : "Doctor Put You On Hold Because You Are Late",
      },
    });
  }

  Future<void> sendPushMessage(String _token, int index) async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http
          .post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization':
                  'key=AAAANUzwdEg:APA91bGheTPXvLz8S-zhS7FeBUbg8ySrVItGRUotk2hyDraw8E43GOdTU_5bUfrjpzULa1YX5Mk5ntZ4OOyclEvtNpXw49eHTi8LPWIL0-SVPcYjz5Cw-uZciQlkb_pZuariOw3e6rdW',
            },
            body: constructFCMPayload(_token, index),
          )
          .then((value) => print(value.body));
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

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
                        _tokens.clear();
                        int index = 0;
                        for (var sn in snap) {
                          if (index == 0) {
                            _firstUid = sn.id;
                            print(_firstUid);
                          }

                          LinkedHashMap<String, dynamic> s = sn.data();
                          var name = s['name'];
                          String token = s['token'];
                          _arr.add(name);
                          _tokens.add(token);
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
                                .orderBy("time")
                                .get()
                                .then((value) {
                              final elem = value.docs.first;
                              print(elem.data());
                              elem.reference.delete().then((value) {
                                _firestore
                                    .collection('queue')
                                    .doc('${widget.uid}')
                                    .get()
                                    .then((value) {
                                  var count = value["count"];
                                  _firestore
                                      .collection('queue')
                                      .doc('${widget.uid}')
                                      .update({'count': --count}).then((value) {
                                    for (var i = 0; i < _tokens.length; i++) {
                                      if (_tokens[i] != null) {
                                        sendPushMessage(_tokens[i], i + 1).then(
                                            (value) => print(
                                                "notification sent successfully"));
                                      }
                                    }
                                  });
                                });
                              });
                            });
                          },
                          child: Text(
                            "CALL NEXT MEMBER",
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
                                .orderBy("time")
                                .get()
                                .then((value) {
                              final elem = value.docs.first;
                              print(elem.data()['token']);
                              _firestore
                                  .collection('queue')
                                  .doc('${auth.currentUser.uid}')
                                  .collection('holdQueue')
                                  .doc(elem.id)
                                  .set(elem.data())
                                  .then((value) {
                                sendPushMessage(elem.data()['token'], null);
                                elem.reference.delete();
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
