import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'login.dart';
import 'check_fields.dart';
import 'assets/app_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CadastrarUsuario extends StatefulWidget {
  const CadastrarUsuario({Key? key}) : super(key: key);

  @override
  _CadastrarUsuarioState createState() => _CadastrarUsuarioState();
}

class _CadastrarUsuarioState extends State<CadastrarUsuario> {
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _celular = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _nomePet = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  final TextEditingController _confirmacaoSenha = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isPasswordConfirmVisible = false;
  Map<String, String> _errorMessages = {};
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cadastrar-se'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.info),
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
          child: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: () async {
                    await _handleGoogleSignIn();
                  },
                  icon: const Icon(Icons.account_circle),
                  label: const Text('Logar com Google'),
                  style: ElevatedButton.styleFrom(
                    //backgroundColor: Colors.red,
                  ),
                ),

                TextField(
                  controller: _nome,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    hintText: 'Digite seu nome',
                    errorText: _errorMessages['nome'],
                  ),
                  keyboardType: TextInputType.name,
                ),

                TextField(
                  controller: _celular,
                  decoration: InputDecoration(
                    labelText: 'Celular',
                    hintText: 'Digite seu celular',
                    errorText: _errorMessages['celular'],
                  ),
                  keyboardType: TextInputType.phone,
                ),

                TextField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'Digite seu e-mail',
                    errorText: _errorMessages['email'],
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),

                TextField(
                  controller: _nomePet,
                  decoration: InputDecoration(
                    labelText: 'Nome do Pet',
                    hintText: 'Digite o nome do seu pet',
                    errorText: _errorMessages['nomePet'],
                  ),
                  keyboardType: TextInputType.name,
                ),

                TextField(
                  controller: _senha,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Digite sua senha',
                    errorText: _errorMessages['senha'],
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),

                TextField(
                  controller: _confirmacaoSenha,
                  obscureText: !_isPasswordConfirmVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirme sua senha',
                    hintText: 'Digite novamente sua senha',
                    errorText: _errorMessages['confirmacaoSenha'],
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordConfirmVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordConfirmVisible = !_isPasswordConfirmVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.positiveButton,
                  ),
                  child: const Text("Cadastrar"),
                  onPressed: () async {
                    setState(() {
                      _errorMessages = _validateFields();
                    });

                    if (_errorMessages.isEmpty) {
                      await _saveUserLocally();
                      // Restante do código para salvar no Firestore, etc.
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      // Agora você pode acessar as informações do usuário usando
      // userCredential.user, como por exemplo, userCredential.user.displayName.

      // Adapte conforme necessário, por exemplo, salvar no Firestore.

    } catch (error) {
      print(error);
      // Tratar erros conforme necessário.
    }
  }

  Map<String, String> _validateFields() {
    final nome = _nome.text;
    final celular = _celular.text;
    final email = _email.text;
    final nomePet = _nomePet.text;
    final senha = _senha.text;
    final confirmacaoSenha = _confirmacaoSenha.text;

    Map<String, String> errors = {};

    if (nome.isEmpty) {
      errors['nome'] = "Por favor, preencha seu nome.";
    }

    if (celular.isEmpty) {
      errors['celular'] = "Por favor, preencha seu número de celular.";
    }

    if (email.isEmpty) {
      errors['email'] = "Por favor, preencha seu e-mail.";
    } else if (!CheckFields.isEmailValid(email)) {
      errors['email'] = "O e-mail não é válido.";
    }

    if (nomePet.isEmpty) {
      errors['nomePet'] = "Por favor, preencha o nome do seu pet.";
    }

    if (senha.isEmpty) {
      errors['senha'] = "Por favor, preencha sua senha.";
    } else if (senha.length < 8 ||
        !CheckFields.containsUppercaseLetter(senha) ||
        !CheckFields.containsLowercaseLetter(senha) ||
        !CheckFields.containsNumber(senha)) {
      errors['senha'] =
      "A senha deve ter no mínimo 8 caracteres, conter pelo menos 1 letra maiúscula, 1 letra minúscula e números.";
    }

    if (confirmacaoSenha.isEmpty) {
      errors['confirmacaoSenha'] = "Por favor, confirme sua senha.";
    } else if (senha != confirmacaoSenha) {
      errors['confirmacaoSenha'] = "As senhas não são iguais.";
    }

    return errors;
  }


  Future<void> _saveUserLocally() async {
    final prefs = await SharedPreferences.getInstance();

    final userData = {
      'nome': _nome.text,
      'celular': _celular.text,
      'email': _email.text,
      'nomePet': _nomePet.text,
      'senha': _senha.text,
      'token': ""
    };

    final userDataJson = json.encode(userData);

    await prefs.setString('userData', userDataJson);

    // Agora, vamos salvar esses dados no Firestore
    try {
      await FirebaseFirestore.instance.collection('usuarios').add({
        'nome': _nome.text,
        'celular': _celular.text,
        'email': _email.text,
        'nomePet': _nomePet.text,
        // Você provavelmente não deve salvar a senha no Firestore por razões de segurança.
        // 'senha': _senha.text,
        'token': "",
      });

      print('Usuário salvo no Firestore com sucesso!');
    } catch (error) {
      print('Erro ao salvar usuário no Firestore: $error');
      // Tratar erros conforme necessário.
    }
  }
}