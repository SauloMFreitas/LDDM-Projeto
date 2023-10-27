import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'sobre.dart';
import 'token.dart';
import 'assets/app_styles.dart';

class Pet extends StatefulWidget {
  final int? xpAtual;
  const Pet({super.key, this.xpAtual});

  @override
  _PetState createState() => _PetState();
}

class _PetState extends State<Pet> {
  int _nivelAtual = 0;
  String petName = "";
  //final TextEditingController _texto = TextEditingController();

  void _updateNivel() {
    if (widget.xpAtual != null && widget.xpAtual! >= 0) {
      _nivelAtual = (widget.xpAtual! / 100).floor();
    }
  }

  @override
  void initState() {
    super.initState();
    _updateNivel();

    // Verifique a validade do token ao iniciar a tela
    _checkTokenValidity();
    getPetFromSharedPreferences();
  }

  // Função para verificar a validade do token e redirecionar para a tela de login se for inválido
  Future<void> _checkTokenValidity() async {
    final tokenManager = TokenManager();
    final isValidToken = await tokenManager.isValidToken();

    if (!isValidToken) {
      // Redirecione o usuário para a tela de login
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

  double _getPercent() {
    double percent = 1.0;

    if (widget.xpAtual != null && widget.xpAtual! >= 0) {
      int value = widget.xpAtual! % 100;
      percent = value / 100;
    }

    return percent;
  }

  @override
  Widget build(BuildContext context) {
    _updateNivel();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Pet"),
        backgroundColor: AppStyles.highlightColor,
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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                petName,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Image.asset('images/Pet_$_nivelAtual.png'),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearPercentIndicator(
                    width: 200.0,
                    lineHeight: 14.0,
                    percent: _getPercent(),
                    backgroundColor: Colors.grey,
                    progressColor: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${widget.xpAtual! % 100}/100',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Nível: $_nivelAtual',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> getPetFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString('userData');

    if (userDataJson != null) {
      final userData = json.decode(userDataJson);
      final nomePet = userData['nomePet'];

      if (nomePet != null) {
        setState(() {
          petName = nomePet;
        });
      }
    } else {
      setState(() {
        petName = "Pet";
      });
    }
  }
}
