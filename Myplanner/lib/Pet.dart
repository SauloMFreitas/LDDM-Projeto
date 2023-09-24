import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';
import 'assets/AppStyles.dart';


class Pet extends StatefulWidget {
  final int? xpAtual;
  const Pet({this.xpAtual});

  @override
  // ignore: library_private_types_in_public_api
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Jorjinho"),
              const SizedBox(height: 16),

              Image.asset('images/Pet_$_nivelAtual.png'),
              const SizedBox(height: 16),

              Text('${widget.xpAtual! % 100}/100'),
              const SizedBox(height: 16), 

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearPercentIndicator(
                    width: 200.0,
                    lineHeight: 14.0,
                    percent: _getPercent(),
                    backgroundColor: Colors.white,
                    progressColor: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text('Nivel: $_nivelAtual'),

            ],
          )
        ],
      ),
    );
  }
}