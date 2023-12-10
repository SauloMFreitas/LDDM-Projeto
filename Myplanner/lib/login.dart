import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cadastrar_usuario.dart';
import 'token.dart';
import 'app_styles.dart';
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

  String userName = "";
  String userEmail = "";
  String petName = "";
  String celular = "";
  String password = "";

  Future<Map<String, String>?> getUsuarioFromSharedPreferences() async {
    // Obtém uma instância de SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Obtém os dados do usuário em formato JSON a partir do SharedPreferences
    final userDataJson = prefs.getString('userData');

    if (userDataJson != null) {
      // Se os dados do usuário existirem, analise o JSON para obter as informações
      final userData = json.decode(userDataJson);
      final email = userData['email'];
      final celular = userData['celular'];
      final nomePet = userData['nomePet'];
      final nome = userData['nome'];

      if (email != null && celular != null && nomePet != null && nome != null) {
        // Se todas as informações estiverem presentes, retorne um mapa com os dados do usuário
        return {
          'email': email,
          'celular': celular,
          'nomePet': nomePet,
          'nome': nome
        };
      }
    }

    return null;
  }

  void _getUserInfo() async {
    final userData = await getUsuarioFromSharedPreferences();
    if (userData != null) {
      setState(() {
        userName = userData['nome'] ?? "";
        userEmail = userData['email'] ?? "";
        petName = userData['nomePet'] ?? "";
        celular = userData['celular'] ?? "";
        password = userData['senha'] ?? "";
      });
    }
  }

  Future<void> updateTokenInSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString('userData');

    if (userDataJson != null) {
      Map<String, dynamic> userData = json.decode(userDataJson);

      var token = TokenManager.generateToken();
      userData['token'] = token;

      var token_str = token.toString();

      final updatedUserDataJson = json.encode(userData);

      await prefs.setString('userData', updatedUserDataJson);

      print('loginnnnnnnn: userEmail');

      // Atualizar token no Firebase
      _getUserInfo();
      await FirebaseFirestore.instance.collection('usuarios').doc(userEmail).set({
        'nome': userName,
        'celular': celular,
        'email': userEmail,
        'nomePet': petName,
        'senha': password,
        'avatar': "",
      });

      print('\n\n\n\n\n\n\n\n\n\n\n\nUsuário atualizado no Firestore com sucesso!');

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
    final AppStyles appStyles = AppStyles();
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
          backgroundColor: appStyles.highlightColor,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/images/myPlanner.png'),
                ),
                const SizedBox(height: 50.0),
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
                            backgroundColor: appStyles.positiveButton,
                          ),
                          onPressed: _realizarLogin,
                          child: const Text("Entrar"),
                        ),

                        const SizedBox(width: 10.0),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appStyles.positiveButton,
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