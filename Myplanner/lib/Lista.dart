import 'package:flutter/material.dart';

class Lista extends StatelessWidget {
  final String texto;

  Lista(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(texto),
      ),
    );
  }
}