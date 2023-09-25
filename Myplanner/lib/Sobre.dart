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
        title: Text("Sobre"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Title(color: Colors.lightBlue, child: const Text('Sobre o aplicativo', style: TextStyle(color: Colors.lightBlue, fontSize: 30),)),
                Text('My Planner é um Aplicativo de gestão pessoal gamificado.\nO aplicativo te ajuda a se programar melhor ao longo de seus dias enquanto observa seu pet evoluir e receber melhorias.\nCrie tarefas, faça-as e conclua-as para receber experiência para você e seu pet.',
                textAlign: TextAlign.center,
                style: 
                TextStyle(
                  color: Colors.white,
                ),),

                SizedBox(height: 16.0),

                Title(color: Colors.lightBlue, child: Text('Sobre Nós', style: TextStyle(color: Colors.lightBlue, fontSize: 30))),
                Text('Aplicativo desenvolvido para o curso de ciências da Computação para a matéria de Laboratório de Desenvolvimento para dispositivos Móveis',
                textAlign: TextAlign.center,
                style: 
                TextStyle(
                  color: Colors.white,
                ),),

                SizedBox(height: 16.0),


                Title(color: Colors.lightBlue, child: Text('Alunos Envolvidos', style: TextStyle(color: Colors.lightBlue, fontSize: 30))),
                Text('Gabriel Vargas\nMateus Leal\nNilson Deon\nSaulo de Moura',
                textAlign: TextAlign.center,
                style: 
                TextStyle(
                  color: Colors.white,
                ),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
