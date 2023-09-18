import 'package:flutter/material.dart';

class Calendario extends StatelessWidget {
  final String texto;

  Calendario(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(texto),
      ),
    );
  }
}