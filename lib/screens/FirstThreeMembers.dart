import 'package:flutter/material.dart';

class FirstThreeMembers extends StatefulWidget {
  @override
  _FirstThreeMembersState createState() => _FirstThreeMembersState();
}

class _FirstThreeMembersState extends State<FirstThreeMembers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First Three Members"),
      ),
    );
  }
}
