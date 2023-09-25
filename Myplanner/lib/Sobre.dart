import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'assets/AppStyles.dart';

class Sobre extends StatefulWidget {
  @override
  _Sobre createState() => _Sobre();
}

class _Sobre extends State<Sobre> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sobre"),
        backgroundColor: AppStyles.highlightColor,
      ),
      
      body: Container(
        padding: const EdgeInsets.all(32),
      
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Title(color: AppStyles.highlightColor, child: const Text('Sobre o aplicativo', style: TextStyle(color: AppStyles.highlightColor, fontSize: 30),)),
                    const Text('My Planner é um Aplicativo de gestão pessoal gamificado.\nO aplicativo te ajuda a se programar melhor ao longo de seus dias enquanto observa seu pet evoluir e receber melhorias.\nCrie tarefas, faça-as e conclua-as para receber experiência para você e seu pet.',
                    textAlign: TextAlign.center,
                    style: 
                    TextStyle(
                      color: Colors.black,
                    ),),

                    const SizedBox(height: 16.0),

                    Title(color: AppStyles.highlightColor, child: const Text('Sobre Nós', style: TextStyle(color: AppStyles.highlightColor, fontSize: 30))),
                    const Text('Aplicativo desenvolvido para o curso de ciências da Computação para a matéria de Laboratório de Desenvolvimento para dispositivos Móveis',
                    textAlign: TextAlign.center,
                    style: 
                    TextStyle(
                      color: Colors.black,
                    ),),

                    const SizedBox(height: 16.0),


                    Title(color: AppStyles.highlightColor, child: const Text('Alunos Envolvidos', style: TextStyle(color: AppStyles.highlightColor, fontSize: 30))),
                    const Text('Gabriel Vargas\nMateus Leal\nNilson Deon\nSaulo de Moura',
                    textAlign: TextAlign.center,
                    style: 
                    TextStyle(
                      color: Colors.black,
                    ),
                  ),
          ],
        ),
              ],
            ),
      ),
    );
  }
}
