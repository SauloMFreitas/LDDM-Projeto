import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CadastrarUsuario.dart';
import 'Token.dart';
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
  bool _mostrarSenha = false;
  bool _emailValido = true;

  Future<Map<String, String>?> getEmailAndSenhaFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString('userData');

    if (userDataJson != null) {
      final userData = json.decode(userDataJson);
      final email = userData['email'];
      final senha = userData['senha'];

      if (email != null && senha != null) {
        return {
          'email': email,
          'senha': senha,
        };
      }
    }

    return null;
  }

  _realizarLogin() async {
    final usuario = await getEmailAndSenhaFromSharedPreferences();

    if (usuario != null) {
      if (_email.text == usuario['email'] && _senha.text == usuario['senha']) {
        updateTokenInSharedPreferences();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Inicio()),
        );
      }
    }
  }

  _validarEmail(String email) {
    if (email.contains('@') && email.contains('.')) {
      setState(() {
        _emailValido = true;
      });
    } else {
      setState(() {
        _emailValido = false;
      });
    }
  }

  Future<void> updateTokenInSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString('userData');

    if (userDataJson != null) {
      Map<String, dynamic> userData = json.decode(userDataJson);

      userData['token'] = TokenManager.generateToken();

      final updatedUserDataJson = json.encode(userData);

      await prefs.setString('userData', updatedUserDataJson);
    }
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    errorText: _emailValido ? null : 'E-mail inválido',
                  ),
                  style: AppStyles.styleTextField,
                  controller: _email,
                  onChanged: (email) {
                    _validarEmail(email);
                  },
                ),
                SizedBox(height: 16.0),
                TextField(
                  keyboardType: TextInputType.text,
                  obscureText: !_mostrarSenha,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _mostrarSenha ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _mostrarSenha = !_mostrarSenha;
                        });
                      },
                    ),
                  ),
                  style: AppStyles.styleTextField,
                  controller: _senha,
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
                    SizedBox(width: 16.0),
                    /* ElevatedButton(
                  child: Text("Recuperar"),
                  onPressed: _recuperarSenha,
                ),
                SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                  child: Text("Remover"),
                  onPressed: _removerSenha,
                ),
              ],
            ),
            SizedBox(height: 16.0), */
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyles.positiveButton,
                          ),
                          child: Text("Entrar"),
                          onPressed: _realizarLogin,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyles.positiveButton,
                          ),
                          child: Text("Cadastrar"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddUsuario()),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                )
              ]),
        ));
  }
}
