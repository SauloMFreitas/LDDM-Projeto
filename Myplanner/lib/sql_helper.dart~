import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'assets/AppStyles.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> criaTabela(sql.Database database) async {
    await database.execute("""CREATE TABLE tarefasTeste (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        categoria TEXT,
        nome TEXT,
        data TEXT,
        hora TEXT,
        notificacao TEXT,
        frequencia TEXT,
        descricao TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'tarefasTeste.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await criaTabela(database);
      },
    );
  }

  static Future<int> adicionarTarefa(String categoria, String nome, String data, String hora, String notificacao, String frequencia, String descricao) async {

    final db = await SQLHelper.db();
    final dados = { 'categoria': categoria,
                    'nome': nome,
                    'data': data,
                    'hora': hora,
                    'notificacao': notificacao,
                    'frequencia': frequencia,
                    'descricao': descricao};
    final id = await db.insert('tarefasTeste', dados,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> pegaTarefas() async {
    final db = await SQLHelper.db();
    return db.query('tarefasTeste', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getTarefaById(int id) async {
    final db = await SQLHelper.db();
    return db.query('tarefasTeste', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getTarefaByDate(String data) async {
    final db = await SQLHelper.db();
    return db.query('tarefasTeste', where: "data = ?", whereArgs: [data]);
  }

  static Future<int> atualizaTarefa(
    int id, String categoria, String nome, String data, String hora, String notificacao, String frequencia, String descricao) async {
    final db = await SQLHelper.db();

    final dados = {
      'categoria': categoria,
      'nome': nome,
      'data': data,
      'hora': hora,
      'notificacao': notificacao,
      'frequencia': frequencia,
      'descricao': descricao,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('tarefasTeste', dados, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> apagaTarefa(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("tarefasTeste", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Erro ($err) ao apagar a tarefa: $id");
    }
  }
}