import 'package:flutter/material.dart';
import 'assets/AppStyles.dart';
import 'main.dart';

class Login extends StatefulWidget {

  Login();

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _email = TextEditingController();
  TextEditingController _senha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: AppStyles.decorationTextField(labelText: 'E-mail'),
              style: AppStyles.styleTextField,
              controller: _email,
              onSubmitted: (String _email) {
                print('_email = ' + _email);
              }
            ),

            SizedBox(height: 16.0),

            TextField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: AppStyles.decorationTextField(labelText: 'Senha'),
              style: AppStyles.styleTextField,
              controller: _senha,
              onSubmitted: (String _senha) {
                print('_senha = ' + _senha);
              }
            ),

            SizedBox(height: 16.0),
            
            ElevatedButton(
              child: Text("Entrar"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Inicio()
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}