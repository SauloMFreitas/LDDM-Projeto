import 'dart:js';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myplanner/notification_service.dart';
import 'package:provider/provider.dart';
import 'assets/app_styles.dart';

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

import 'cadastrar_tarefa.dart';
import 'calendario.dart';
import 'lista.dart';
import 'pet.dart';
import 'perfil.dart';
import 'firebase_options.dart';

void main() async {
  initializeDateFormatting('pt_BR');

  // Conectar ao Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(providers: [
      Provider<NotificationService>(create: (context) => NotificationService()),
    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Inicio(),
        theme: ThemeData(
          scaffoldBackgroundColor: AppStyles.primaryColor,
          textTheme: const TextTheme(
            bodyLarge: AppStyles.bodyTextStyle,
            displayLarge: AppStyles.titleTextStyle,
            displayMedium: AppStyles.subtitleTextStyle,
          ),
        ),
      )
    )
  );
}

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _indiceAtual = 0;
  final List<Widget> _telas = [
    Calendario(),
    Lista(dataSelecionada: DateFormat('dd/MM/yyyy').format(DateTime.now())),
    CadastrarTarefa(data: DateTime.now().toLocal(), editarTarefa: false),
    const Pet(),
    const Perfil(),
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
        type: BottomNavigationBarType.fixed,
        currentIndex: _indiceAtual,
        unselectedItemColor: Colors.grey,
        selectedItemColor: const Color.fromARGB(255, 26, 26, 26),
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: "Calendário",
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted),
              label: "Tarefas",
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              label: "Criar Tarefa",
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.pets),
              label: "Pet",
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Perfil",
              backgroundColor: Colors.white),
        ],
      ),
    );
  }
}
