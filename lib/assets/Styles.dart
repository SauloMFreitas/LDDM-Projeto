import 'package:flutter/material.dart';

class Styles {
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
    );
  }
}
