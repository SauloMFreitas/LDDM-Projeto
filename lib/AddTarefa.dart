import 'package:flutter/material.dart';

class AddTarefa extends StatelessWidget {
  final String texto;

  AddTarefa(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(texto),
      ),
    );
  }
}