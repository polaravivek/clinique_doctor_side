import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

Widget queueMember(
    String name, String index, Color color1, Color color2, Color textColor) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
        child: GradientCard(
          elevation: 2,
          shadowColor: Colors.black54,
          gradient: LinearGradient(colors: [color1, color2]),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  '$index',
                  style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    child: Icon(Icons.import_contacts_sharp),
                    radius: 20,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Center(
                  child: Text(
                    '$name',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
