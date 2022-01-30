import 'dart:async';
import 'package:clinique_doctor/controller/homepage.controller.dart';
import 'package:clinique_doctor/controller/main.controller.dart';
import 'package:clinique_doctor/screens/homepage.dart';
import 'package:clinique_doctor/screens/info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/Register.dart';
import 'screens/login.dart';

var email;
var isAdded;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.lazyPut<HomePageController>(() => HomePageController());

  SharedPreferences prefs = await SharedPreferences.getInstance();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  email = prefs.getString('email');
  isAdded = prefs.getString('isInfoAdded');

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  runApp(
    MaterialApp(
        theme: ThemeData(
          primarySwatch: createMaterialColor(Color(0xffAB1818)),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/myApp': (context) => MyApp(),
          '/register': (context) => Register(),
          '/login': (context) => Login(),
        },
        initialRoute: '/myApp'),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final auth = FirebaseAuth.instance;
  final fdRef = FirebaseDatabase.instance.reference();
  MainController mainController = Get.put(MainController());
  HomePageController homePageController = Get.find<HomePageController>();

  var clinicName = "";

  @override
  void initState() {
    if (email != null) {
      fdRef
          .child("doctorInfo")
          .child("clinicInfo")
          .child(auth.currentUser!.uid)
          .once()
          .then((value) {
        setState(() {
          clinicName = value.value['clinicName'];
          mainController.clinicTitle.value = clinicName;
        });
        startTime();
      });
    } else {
      startTime();
    }

    super.initState();
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() {
    if (email == null) {
      Navigator.pushNamed(context, '/register');
    } else if (isAdded == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Information(null, null, null),
        ),
      ); // change this later by homepage
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Homepage(clinicName, homePageController.modelDoctorInfo),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0x9AAB1818),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(image: AssetImage('assets/images/img.png')),
      ),
    );
  }
}
