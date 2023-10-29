import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sql_helper.dart';

class XPHandler {
  int _calculoXP(DateTime diaTarefa, DateTime diaCompletada) {
    int xp = 0;

    int meses = (diaTarefa.difference(diaCompletada).inDays / 30).ceil();
    int dias = diaTarefa.difference(diaCompletada).inDays + 1;

    //print(meses);
    //print(dias);

    if (meses > 6) {
      xp = 240;
    } else if (meses <= 6 && meses > 1) {
      xp = meses * 40;
    } else {
      xp = (dias * 1.3).ceil();
    }

    return xp;
  }

  Future<void> xPCalculator() async {
    final prefs = await SharedPreferences.getInstance();
    final dataRaw = prefs.getString('petData');

    final Map<String, dynamic> petData;

    var tarefas = await SQLHelper.getTarefasConcluidas();
    int xpAtual = 0;

    for(int i = 0; i < tarefas.length; i++) {

      DateFormat dateFormat0 = DateFormat("dd/MM/yyyy HH:mm");
      DateFormat dateFormat1 = DateFormat("dd/MM/yyyy");

      DateTime dataVencimento = dateFormat0.parse('${tarefas[i]['data']} ${tarefas[i]['hora']}');
      DateTime dataConclusao = dateFormat1.parse('${tarefas[i]['concluida']}');
      xpAtual += _calculoXP(dataVencimento, dataConclusao);
    }

    if (dataRaw != null) {
      final data = json.decode(dataRaw);
      petData = {
        'XP': xpAtual,
        'nivel': data["nivel"]
      };
    } else {
      petData = {'XP': 0, 'nivel': 0};
    }

    final userDataJson = json.encode(petData);
    await prefs.setString('petData', userDataJson);
  }

}
