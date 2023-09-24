import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'AddTarefa.dart';
import 'Calendario.dart';
import 'Lista.dart';
import 'Pet.dart';
import 'Perfil.dart';
import 'app_styles.dart';

void main() {
  initializeDateFormatting('pt_BR');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Inicio(),
    theme: ThemeData(
      scaffoldBackgroundColor: AppStyles.primaryColor, // Defina a cor de fundo preta para todo o aplicativo
      primaryColor: Colors.white,
      hintColor: Colors.black,
    ),
  ));
}

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _indiceAtual = 0;
  final List<Widget> _telas = [
    Calendario(),
    Lista(),
    AddTarefa(),
    Pet(xpAtual: 120),
    Perfil()
  ];

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        
        currentIndex: _indiceAtual,
        unselectedItemColor: Colors.grey,
        selectedItemColor: const Color.fromARGB(255, 26, 26, 26),
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Calendário",backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted), label: "Tarefas",backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Criar Tarefa",backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Pet", backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil",backgroundColor: Colors.white)
        ],
      ),
    );
  }
}
