import 'package:flutter/material.dart';

class Login extends StatefulWidget {

  Login();

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Segunda Tela"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Você está na segunda tela",
              style: TextStyle(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}