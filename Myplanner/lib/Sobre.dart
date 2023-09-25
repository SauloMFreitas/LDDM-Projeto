import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'assets/AppStyles.dart';

class Sobre extends StatefulWidget {
  @override
  _AddUsuarioState createState() => _AddUsuarioState();
}

class _AddUsuarioState extends State<Sobre> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Sobre"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            Text('Sobre'),
          ],
        ),
      ),
    );
  }
}
