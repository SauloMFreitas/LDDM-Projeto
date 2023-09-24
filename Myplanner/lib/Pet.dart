import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Pet extends StatefulWidget {

  final int? xpAtual;
  Pet({this.xpAtual});

  @override
  _Pet createState() => _Pet();
}

class _Pet extends State<Pet> {

  TextEditingController _texto = TextEditingController();

  @override
  Widget build(BuildContext context) {

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

            LinearPercentIndicator(
                width: 140.0,
                lineHeight: 14.0,
                percent: 0.5,
                backgroundColor: Colors.grey,
                progressColor: Colors.blue,
              ),

          ],
        ),
      ),
    );
  }
}
