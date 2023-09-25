import 'package:flutter/material.dart';

class AppStyles {
  static const TextStyle styleTextField = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static InputDecoration decorationTextField({String labelText = ' '}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.black,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: EdgeInsets.all(10.0),
      filled: true,
      fillColor: Colors.grey[400],
    );
  }

  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 255, 255, 255),
  );

  static const TextStyle subtitleTextStyle = TextStyle(
    fontSize: 16,
    color: Color.fromARGB(255, 255, 255, 255),
  );

   static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 14,
    color: Color.fromARGB(255, 255, 255, 255),
  );

  static const Color primaryColor = Color.fromARGB(255, 46, 55, 66);
  static const Color highlightColor = Colors.red;
  static const Color positiveButton = Color.fromARGB(255, 0, 255, 0);
  static const Color negativeButton = Color.fromARGB(255, 255, 0, 0);
}
