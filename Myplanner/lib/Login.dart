import 'package:shared_preferences/shared_preferences.dart';
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

  bool _salvarLogin = false;

  String _emailSalvo = "";
  String _senhaSalva = "";
  
  _salvarSenha() async{

    if (_salvarLogin == true) {
      _emailSalvo = _email.text;
      _senhaSalva = _senha.text;

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("email", _emailSalvo);
      await prefs.setString("senha", _senhaSalva);

      print("Operação salvar: $_emailSalvo , $_senhaSalva");
    }
  }

  _recuperarSenha() async{
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _emailSalvo = prefs.getString("email") ?? "Sem valor";
      _senhaSalva = prefs.getString("senha") ?? "Sem valor";
    });
    print("Operação recuperar: $_emailSalvo , $_senhaSalva");
  }

  _removerSenha() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("email");
    prefs.remove("senha");
    print("Operação remover");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: AppStyles.highlightColor,
        centerTitle: true,
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Salvar login"),

                Checkbox(
                  value: _salvarLogin,
                  onChanged: (value) {
                    setState(() {
                      _salvarLogin = value!; 
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 16.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 16,),
                ElevatedButton(
                  child: Text("Recuperar"),
                  onPressed: _recuperarSenha,
                ),
                SizedBox(width: 16,),
                ElevatedButton(
                  child: Text("Remover"),
                  onPressed: _removerSenha,
                ),
              ],
            ),

            SizedBox(height: 16.0),
            
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: Text("Entrar"),
              onPressed: () {
                _salvarSenha();
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