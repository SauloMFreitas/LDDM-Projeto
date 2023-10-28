import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'sobre.dart';
import 'token.dart';
import 'check_fields.dart';
import 'assets/app_styles.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  void initState() {
    super.initState();
    _checkTokenValidity();
    _getUserInfo();
  }

  // Função para verificar a validade do token e redirecionar para a tela de login se for inválido
  Future<void> _checkTokenValidity() async {
    final tokenManager = TokenManager();
    final isValidToken = await tokenManager.isValidToken();

    if (!isValidToken) {
      _redirectToLoginScreen();
    }
  }

  void _redirectToLoginScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => Login(),
    ));
  }

  File? _image;
  final picker = ImagePicker();
  String userName = "";
  String userEmail = "";
  String petName = "";
  String celular = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
              );
            },
          ),
        ],
        backgroundColor: AppStyles.highlightColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _pickImage();
                },
                child: Center(
                  // Centraliza a imagem de perfil
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : const AssetImage('assets/user_avatar.jpg')
                    as ImageProvider,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  _pickImage();
                },
                child: const Text('Trocar Imagem de Perfil'),
              ),
              const SizedBox(height: 20),
              buildInfoRow("Nome", userName),
              buildInfoRow("Email", userEmail),
              buildInfoRow("Celular", celular),
              buildInfoRow("Nome do Pet", petName),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  AppStyles.positiveButton,
                ),
                onPressed: () {
                  // Navegar para a tela de atualização de perfil
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdatePerfil(
                        oldName: userName,
                        oldEmail: userEmail,
                        oldPetName: petName,
                        oldCelular: celular,
                        oldPassword: password,
                      ),
                    ),
                  ).then((result) {
                    _getUserInfo();
                  });
                },

                child: const Text('Atualizar Informações'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.negativeButton),
                onPressed: () async {
                  final tokenManager = TokenManager();
                  await tokenManager.invalidateToken();

                  // Redirecione o usuário para a tela de login
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Login(),
                  ));
                },
                child: const Text('Sair'),
              ),
            ],
          ),
        ),
      ),
    );
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
          'nome': nome,
        };
      }
    }

    // Se os dados do usuário não existirem ou estiverem incompletos, retorne null
    return null;
  }

  void _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0), // Adicione o Padding aqui
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class UpdatePerfil extends StatefulWidget {
  final String oldName;
  final String oldEmail;
  final String oldPetName;
  final String oldCelular;
  final String oldPassword;

  const UpdatePerfil({super.key,
    required this.oldName,
    required this.oldEmail,
    required this.oldPetName,
    required this.oldCelular,
    required this.oldPassword,
  });

  @override
  _UpdatePerfilState createState() => _UpdatePerfilState();
}

class _UpdatePerfilState extends State<UpdatePerfil> {
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _celular = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _nomePet = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  final TextEditingController _confirmacaoSenha = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isPasswordConfirmVisible = false;
  Map<String, String> _errorMessages = {};

  @override
  void initState() {
    super.initState();
    _nome.text = widget.oldName;
    _email.text = widget.oldEmail;
    _nomePet.text = widget.oldPetName;
    _celular.text = widget.oldCelular;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Atualizar Perfil'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Sobre(),
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
                          _isPasswordConfirmVisible =
                          !_isPasswordConfirmVisible;
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
                  child: const Text("Atualizar Informações"),
                  onPressed: () {
                    setState(() {
                      _errorMessages = _validateFields();
                    });

                    if (_errorMessages.isEmpty) {

                      _saveUserLocally();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Sucesso'),
                            content: const Text('Seu perfil foi atualizado com sucesso!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => Perfil(),
                      ));
                    }
                  },
                ),
              ],
            ),
          ),
        ));
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
      'token': getTokenFromSharedPreferences()
    };

    final userDataJson = json.encode(userData);

    await prefs.setString('userData', userDataJson);
  }

  Future<String?> getTokenFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString('userData');

    if (userDataJson != null) {
      final userData = json.decode(userDataJson);
      final token = userData['token'];

      if (token != null) {
        return token;
      }
    }

    return null;
  }
}