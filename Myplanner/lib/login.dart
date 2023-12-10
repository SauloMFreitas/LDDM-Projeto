import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cadastrar_usuario.dart';
import 'token.dart';
import 'assets/app_styles.dart';
import 'main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();
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

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Inicio(),
        ));
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

      // Atualizar token no Firebase


    }
  }

  void _verificarLoginSalvo() async {
    final usuario = await getEmailAndSenhaFromSharedPreferences();

    if (usuario != null) {
      if (usuario['email'] != null && usuario['senha'] != null) {
        _email.text = usuario['email'] ?? '';
        _senha.text = usuario['senha'] ?? '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _verificarLoginSalvo();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.info, color: Colors.white,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
            ),
          ],
          backgroundColor: AppStyles.highlightColor,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  child: Image.asset('images/myPlanner.png'),
                ),
                const SizedBox(height: 50.0),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    errorText: _emailValido ? null : 'E-mail invÃ¡lido',
                  ),
                  style: AppStyles.styleTextField,
                  controller: _email,
                  onChanged: (email) {
                    _validarEmail(email);
                  },
                ),
                const SizedBox(height: 16.0),
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
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyles.positiveButton,
                          ),
                          onPressed: _realizarLogin,
                          child: const Text("Entrar"),
                        ),

                        const SizedBox(width: 10.0),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyles.positiveButton,
                          ),
                          child: const Text("Cadastrar"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CadastrarUsuario()),
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