import 'package:flutter/material.dart';
import 'assets/app_styles.dart';

class Sobre extends StatelessWidget {
  const Sobre({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sobre"),
        centerTitle: true,
        backgroundColor: AppStyles.highlightColor,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Text(
                'Sobre o aplicativo',
                style: TextStyle(
                  color: AppStyles.highlightColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'My Planner é um Aplicativo de gestão pessoal gamificado.\nO aplicativo te ajuda a se programar melhor ao longo de seus dias enquanto observa seu pet evoluir e receber melhorias.\nCrie tarefas, faça-as e conclua-as para receber experiência para você e para seu pet.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),

              Text(
                'Sobre Nós',
                style: TextStyle(
                  color: AppStyles.highlightColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Aplicativo desenvolvido para o curso de Ciência da Computação para a matéria de Laboratório de Desenvolvimento para Dispositivos Móveis',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),

              Text(
                'Alunos Envolvidos',
                style: TextStyle(
                  color: AppStyles.highlightColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Gabriel Vargas\nMateus Leal\nNilson Deon\nSaulo de Moura',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
