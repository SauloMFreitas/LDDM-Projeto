import "package:flutter/material.dart";

import 'AddTarefa.dart';
import 'Calendario.dart';
import 'Lista.dart';
import 'Pet.dart';
import 'Perfil.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Inicio(),
  ));
}

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _indiceAtual = 0;
  final List<Widget> _telas = [
    Calendario("Calendario"),
    Lista("Tarefas"),
    AddTarefa("Criar Tarefa"),
    Pet("Meu Pet"),
    Perfil("Meu Perfil")
  ];

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu App com Menu"),
      ),
      body: _telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.yellow,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Calendário",backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted), label: "Tarefas",backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Criar Tarefa",backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Pet", backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil",backgroundColor: Colors.black)
        ],
      ),
    );
  }
}
