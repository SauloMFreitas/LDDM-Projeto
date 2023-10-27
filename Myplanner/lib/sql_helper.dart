import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> criaTabela(sql.Database database) async {
    await database.execute("""CREATE TABLE tarefas (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
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
    final dados = { 'categoria': categoria,
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
    int id, String categoria, String nome, String data, String hora, String notificacao, String frequencia, String descricao, int concluida) async {
    final db = await SQLHelper.db();

    final dados = {
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

    final result =
    await db.update('tarefas', dados, where: "id = ?", whereArgs: [id]);
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
