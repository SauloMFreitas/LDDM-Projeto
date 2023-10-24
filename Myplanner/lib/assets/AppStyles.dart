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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: EdgeInsets.all(10.0),
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
    );

  }

  static InputDecoration decorationTextFieldType2({String labelText = ' '}) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: EdgeInsets.all(10.0),
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle subtitleTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

   static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.black,
  );

  static const Color primaryColor = Color.fromARGB(255, 241, 241, 235);
  static const Color highlightColor = Color.fromARGB(255, 230, 72, 74);
  static const Color positiveButton = Color.fromARGB(255, 0, 190, 0);
  static const Color negativeButton = Color.fromARGB(255, 188, 0, 0);
}