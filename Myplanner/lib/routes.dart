import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myplanner/calendario.dart';
import 'package:myplanner/lista.dart';

class Routes{
  static Map<String, Widget Function(BuildContext)> list = <String, WidgetBuilder>{
    '/home': (_) => const Calendario(),
    '/notification':(_) => Lista(dataSelecionada: DateFormat('dd/MM/yyyy').format(DateTime.now())),
  };

  static String initial = '/home';
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}