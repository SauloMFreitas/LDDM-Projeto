import 'package:flutter/material.dart';

class AppStyles {

  static Map<String, String> errorMessages = {
    'erro': 'Preencha este campo',
  };

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
      contentPadding: const EdgeInsets.all(10.0),
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
      // errorText: errorMessages['erro'],
    );
  }

  static InputDecoration decorationTextFieldType2({String labelText = ' '}) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: const EdgeInsets.all(10.0),
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

    Color primaryColor = const Color.fromARGB(255, 241, 241, 235);
    Color highlightColor = const Color.fromARGB(255, 230, 72, 74);
    Color positiveButton = const Color.fromARGB(250, 0, 190, 0);
    Color negativeButton = const Color.fromARGB(255, 190, 0, 0);

  final ButtonStyle customPositiveButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(250, 0, 190, 0),
    foregroundColor: Colors.white,
    textStyle: const TextStyle(
      fontSize: 16,
      color: Colors.white,

    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  final ButtonStyle customNegativeButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 190, 0, 0),
    foregroundColor: Colors.white,
    textStyle: const TextStyle(
      fontSize: 16,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}