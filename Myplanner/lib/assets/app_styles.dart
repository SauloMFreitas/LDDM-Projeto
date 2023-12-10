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

  static const Color primaryColor = Color.fromARGB(255, 241, 241, 235);
  static const Color highlightColor = Color.fromARGB(255, 230, 72, 74);
  static const Color positiveButton = Color.fromARGB(250, 0, 190, 0);
  static const Color negativeButton = Color.fromARGB(255, 190, 0, 0);

  static final ButtonStyle customPositiveButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(250, 0, 190, 0), // Cor de fundo do botão
    textStyle: const TextStyle(
      fontSize: 16,
      color: Colors.white,
    ), // Estilo de texto do botão
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Espaçamento interno do botão
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Borda arredondada do botão
    ),
  );

  static final ButtonStyle customNegativeButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 190, 0, 0),
    textStyle: const TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
    // Estilo de texto do botão
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Espaçamento interno do botão
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Borda arredondada do botão
    ),
  );
}