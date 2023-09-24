import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';

class Pet extends StatefulWidget {

  final int? xpAtual;
  Pet({this.xpAtual});

  @override
  _Pet createState() => _Pet();
}


class _Pet extends State<Pet> {

  int _nivelAtual = 0;

  TextEditingController _texto = TextEditingController();

  void _updateNivel() {

    if (widget.xpAtual != null && widget.xpAtual! >= 0) {
      _nivelAtual = (widget.xpAtual! / 100).floor();
    }

  }

  double _getPercent() {
    double percent = 1.0;

    if (widget.xpAtual != null && widget.xpAtual! >= 0) {
      int value = widget.xpAtual! % 100;
      percent = value / 100;
    }

    return percent;
  }

  @override
  Widget build(BuildContext context) {
    _updateNivel();
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Pet"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[

            Text("Jorjinho"),

            Image.asset('images/Pet_${_nivelAtual}.png'),

            Text('${widget.xpAtual!%100}/100'),

            LinearPercentIndicator(
                width: 200.0,
                lineHeight: 14.0,
                percent: _getPercent(),
                backgroundColor: Colors.grey,
                progressColor: Colors.blue,
            ),

            Text('Nivel: ${_nivelAtual}')

          ],
        ),
      ),
    );
  }
}
