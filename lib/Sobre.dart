import 'package:flutter/material.dart';
import 'assets/AppStyles.dart';

class Sobre extends StatelessWidget {
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
          padding: const EdgeInsets.all(16.0), // Espaçamento interno
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Título e corpo 1
              Text(
                'Sobre o aplicativo',
                style: TextStyle(
                  color: AppStyles.highlightColor, // Cor do título
                  fontSize: 24.0, // Tamanho da fonte do título
                  fontWeight: FontWeight.bold, // Peso da fonte do título
                ),
              ),
              Text(
                'My Planner é um Aplicativo de gestão pessoal gamificado.\nO aplicativo te ajuda a se programar melhor ao longo de seus dias enquanto observa seu pet evoluir e receber melhorias.\nCrie tarefas, faça-as e conclua-as para receber experiência para você e seu pet.',
                style: TextStyle(
                  color: Colors.black, // Cor do corpo
                  fontSize: 18.0, // Tamanho da fonte do corpo
                ),
                textAlign: TextAlign.center, // Alinhamento do texto
              ),
              SizedBox(height: 16.0), // Espaçamento entre os elementos

              // Título e corpo 2
              Text(
                'Sobre Nós',
                style: TextStyle(
                  color: AppStyles.highlightColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Aplicativo desenvolvido para o curso de ciências da Computação para a matéria de Laboratório de Desenvolvimento para dispositivos Móveis',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),

              // Título e corpo 3
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