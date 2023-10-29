import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class XPHandler {
  int _CalculoXP(DateTime diaTarefa, DateTime diaCompletada) {
    int Xp = 0;

    int meses = (diaTarefa.difference(diaCompletada).inDays / 30).ceil();
    int dias = diaTarefa.difference(diaCompletada).inDays + 1;

    print(meses);
    print(dias);

    if (meses > 6) {
      Xp = 240;
    } else if (meses <= 6 && meses > 1) {
      Xp = meses * 40;
    } else {
      Xp = (dias * 1.3).ceil();
    }

    return Xp;
  }

  Future<void> XPCalculator(DateTime diaTarefa, DateTime diaCompletada) async {
    final prefs = await SharedPreferences.getInstance();
    final data_raw = prefs.getString("XPDATA");

    final XPDATA;

    if (data_raw != null) {
      final data = json.decode(data_raw);
      XPDATA = {
        'XP': (data["XP"] + _CalculoXP(diaTarefa, diaCompletada)),
        'nivel': data["nivel"]
      };
    } else {
      XPDATA = {'XP': _CalculoXP(diaTarefa, diaCompletada), 'nivel': 0};
    }

    final userDataJson = json.encode(XPDATA);
    await prefs.setString('XPDATA', userDataJson);
  }
}
