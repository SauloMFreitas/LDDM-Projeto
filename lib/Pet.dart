import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';
import 'assets/AppStyles.dart';


class Pet extends StatefulWidget {
  final int? xpAtual;
  const Pet({this.xpAtual});

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
        backgroundColor: AppStyles.highlightColor,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Text(
                "Jorjinho",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 30),

              Image.asset('images/Pet_$_nivelAtual.png'),
              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: LinearPercentIndicator(
                      width: 200.0,
                      lineHeight: 14.0,
                      percent: _getPercent(),
                      backgroundColor: Colors.grey,
                      progressColor: Colors.blue,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              Text('${widget.xpAtual! % 100}/100',
                  style: TextStyle(
                  fontSize: 15,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),),

              SizedBox(height: 30), 

              Text(
                'Nível: $_nivelAtual',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          )
        ],
      ),
    );
  }
}