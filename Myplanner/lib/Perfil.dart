import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';
import 'Sobre.dart';
import 'Token.dart';
import 'assets/AppStyles.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  void initState() {
    super.initState();

    // Verifique a validade do token ao iniciar a tela
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
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
          (route) => false,
    );
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
                  builder: (context) => Sobre(),
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
                  AppStyles.positiveButton, // Cor do botão de ação positiva
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
                  );
                  _getUserInfo();
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Sobre(),
                    ),
                  );
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
    // ignore: avoid_print
    print(userData);
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

  UpdatePerfil({
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
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController petNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController celularController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.oldName;
    emailController.text = widget.oldEmail;
    petNameController.text = widget.oldPetName;
    celularController.text = widget.oldCelular;
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
                  builder: (context) => Sobre(),
                ),
              );
            },
          ),
        ],
        backgroundColor: AppStyles.highlightColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: petNameController,
              decoration: const InputDecoration(labelText: 'Nome do Pet'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            TextField(
              controller: celularController,
              decoration: const InputDecoration(labelText: 'Celular'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateUserInfo();
                Navigator.pop(context);
              },
              child: const Text('Salvar Informações'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateUserInfo() async {
    final newName = nameController.text;
    final newEmail = emailController.text;
    final newPetName = petNameController.text;
    final newPassword = passwordController.text;
    final confirmNewPassword = confirmPasswordController.text;
    final newCelular = celularController.text;

    // Realize a validação de informações aqui
    if (newName.length < 3) {
      // Nome não pode ter menos de 3 letras
      // Adicione um feedback ao usuário ou uma caixa de diálogo de erro
      return;
    }

    if (!isValidEmail(newEmail)) {
      // Email deve ser válido
      // Adicione um feedback ao usuário ou uma caixa de diálogo de erro
      return;
    }

    if (newPassword.length < 8 ||
        !containsUppercase(newPassword) ||
        !containsLowercase(newPassword) ||
        !containsNumber(newPassword) ||
        newPassword != confirmNewPassword) {
      // Senha não atende aos requisitos
      // Adicione um feedback ao usuário ou uma caixa de diálogo de erro
      return;
    }

    // Obtenha os dados existentes do usuário do SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString('userData');

    if (userDataJson != null) {
      Map<String, dynamic> userData = json.decode(userDataJson);

      // Verifique se as novas informações são diferentes das antigas
      if (newName != widget.oldName) {
        userData['nome'] = newName;
      }

      if (newEmail != widget.oldEmail) {
        userData['email'] = newEmail;
      }

      if (newPetName != widget.oldPetName) {
        userData['nomePet'] = newPetName;
      }

      if (newPassword != widget.oldPassword) {
        userData['senha'] = newPassword;
      }

      if (newCelular != widget.oldCelular) {
        userData['celular'] = newCelular;
      }

      final updatedUserDataJson = json.encode(userData);

      await prefs.setString('userData', updatedUserDataJson);
    }
  }

  bool isValidEmail(String email) {
    // Validação simples de email
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  bool containsUppercase(String text) {
    return text.contains(RegExp(r'[A-Z]'));
  }

  bool containsLowercase(String text) {
    return text.contains(RegExp(r'[a-z]'));
  }

  bool containsNumber(String text) {
    return text.contains(RegExp(r'[0-9]'));
  }
}
