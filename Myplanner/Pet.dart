import 'package:flutter/material.dart';

class Pet extends StatelessWidget {
  final String texto;

  Pet(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(texto),
      ),
    );
  }
}