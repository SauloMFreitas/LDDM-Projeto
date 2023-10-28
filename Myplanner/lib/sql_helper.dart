import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:date_utils/date_utils.dart';
import 'package:intl/intl.dart';

/* IdCopia
       = -1 se for unico
       = id é a copia original
       = algum id menor é referencia à cópia
    */

class SQLHelper {
  static Future<void> criaTabela(sql.Database database) async {

    await database.execute("""CREATE TABLE tarefas (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        idCopia INTEGER,
        categoria TEXT,
        nome TEXT,
        data TEXT,
        hora TEXT,
        notificacao TEXT,
        frequencia TEXT,
        descricao TEXT,
        concluida INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'tarefas.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await criaTabela(database);
      },
    );
  }

  static Future<int> adicionarTarefa(String categoria, String nome, String data, String hora, String notificacao, String frequencia, String descricao, int concluida) async {

    final db = await SQLHelper.db();
    final dados = { 'idCopia': -1,
                    'categoria': categoria,
                    'nome': nome,
                    'data': data,
                    'hora': hora,
                    'notificacao': notificacao,
                    'frequencia': frequencia,
                    'descricao': descricao,
                    'concluida': concluida};
    final id = await db.insert('tarefas', dados,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    int idCopia = (frequencia == 'Não repetir') ? -1 : id;
    await atualizaTarefa(id, idCopia, categoria, nome, data, hora, notificacao, frequencia, descricao, concluida);

    print("id = " + id.toString());
    print("idCopia = " + idCopia.toString());

    final dateFormat = DateFormat('dd/MM/yyyy');
    DateTime dataInicial = dateFormat.parse(data);


    if (frequencia == 'Diariamente') {
      for (int i = 0; i < 365; i++) {
        // Atualiza data
        dataInicial = dataInicial.add(const Duration(days: 1));
        String novaData = dateFormat.format(dataInicial);
        await adicionarTarefaCopia(idCopia, categoria, nome, novaData, hora, notificacao, frequencia, descricao, concluida);
      }
    }

    else if (frequencia == 'Semanalmente') {
      for (int i = 0; i < 52; i++) {
        // Atualiza data
        dataInicial = dataInicial.add(const Duration(days: 7));
        String novaData = dateFormat.format(dataInicial);
        await adicionarTarefaCopia(idCopia, categoria, nome, novaData, hora, notificacao, frequencia, descricao, concluida);
      }
    }
/*
    else if (frequencia == 'Mensalmente') {
      for (int i = 0; i < 12; i++) {
        dataInicial = Utils.addMonthsToDateTime(dataInicial, 1);
        String novaData = dataInicial.toLocal().toString();

        // Chame sua função adicionarTarefaCopia com a novaData
        adicionarTarefaCopia(idCopia, categoria, nome, novaData, hora, notificacao, frequencia, descricao, concluida);
      }
    }

*/
    else if (frequencia == 'Anualmente') {
      for (int i = 0; i < 5; i++) {
        final novoAno = dataInicial.year + 1;
        dataInicial = DateTime(novoAno, dataInicial.month, dataInicial.day);
        String novaData = dateFormat.format(dataInicial);
        await adicionarTarefaCopia(idCopia, categoria, nome, novaData, hora, notificacao, frequencia, descricao, concluida);
      }
    }

    return id;
  }

  static Future<int> adicionarTarefaCopia(int idCopia, String categoria, String nome, String data, String hora, String notificacao, String frequencia, String descricao, int concluida) async {

    final db = await SQLHelper.db();

    final dados = { 'idCopia': idCopia,
                    'categoria': categoria,
                    'nome': nome,
                    'data': data,
                    'hora': hora,
                    'notificacao': notificacao,
                    'frequencia': frequencia,
                    'descricao': descricao,
                    'concluida': concluida};
    final id = await db.insert('tarefas', dados,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getTarefas() async {
    final db = await SQLHelper.db();
    return db.query('tarefas', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getTarefaById(int id) async {
    final db = await SQLHelper.db();
    return db.query('tarefas', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getTarefasByDate(String data) async {
    final db = await SQLHelper.db();
    return db.query('tarefas', where: "data = ?", whereArgs: [data], orderBy: "hora");
  }

  static Future<int> atualizaTarefa(
    int id, int idCopia, String categoria, String nome, String data, String hora, String notificacao, String frequencia, String descricao, int concluida) async {
    final db = await SQLHelper.db();

    final dados = {
      'idCopia': idCopia,
      'categoria': categoria,
      'nome': nome,
      'data': data,
      'hora': hora,
      'notificacao': notificacao,
      'frequencia': frequencia,
      'descricao': descricao,
      'concluida': concluida,
      'createdAt': DateTime.now().toString()
    };

    final result = await db.update('tarefas', dados, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<int> atualizaTarefaCopias(
      int idCopia, String categoria, String nome, String data, String hora, String notificacao, String frequencia, String descricao, int concluida) async {
    final db = await SQLHelper.db();

    //final data = await SQLHelper.getTarefasByIdCopia();

    final dados = {
      'idCopia': idCopia,
      'categoria': categoria,
      'nome': nome,
      'data': data,
      'hora': hora,
      'notificacao': notificacao,
      'frequencia': frequencia,
      'descricao': descricao,
      'concluida': concluida,
      'createdAt': DateTime.now().toString()
    };

    final result = await db.update('tarefas', dados, where: "idCopia = ?", whereArgs: [idCopia]);
    return result;
  }

  static Future<void> apagaTarefa(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("tarefas", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Erro ($err) ao apagar a tarefa: $id");
    }
  }
}
