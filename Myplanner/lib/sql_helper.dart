import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:intl/intl.dart';

class SQLHelper {
  static Future<void> criaTabela(sql.Database database) async {

    await database.execute("""CREATE TABLE tarefas (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        categoria TEXT,
        nome TEXT,
        data TEXT,
        hora TEXT,
        notificacao TEXT,
        descricao TEXT,
        concluida TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);

    await database.execute("""CREATE TABLE tarefas_pendentes_add (
        usuario TEXT,
        categoria TEXT,
        nome TEXT,
        data TEXT,
        hora TEXT,
        notificacao TEXT,
        descricao TEXT,
        id INTEGER PRIMARY KEY,
        concluida TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);

    await database.execute("""CREATE TABLE tarefas_pendentes_delete (
        id INTEGER PRIMARY KEY,
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

  static Future<sql.Database> db_pendente_add() async {
    return sql.openDatabase(
      'tarefas_pendentes_add.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await criaTabela(database);
      },
    );
  }

  static Future<sql.Database> db_pendente_delete() async {
    return sql.openDatabase(
      'tarefas_pendentes_delete.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await criaTabela(database);
      },
    );
  }

  static Future<int> adicionarTarefa(String categoria, String nome, String data, String hora, String notificacao, String descricao, String concluida) async {

    final db = await SQLHelper.db();
    final dados = {
      'categoria': categoria,
      'nome': nome,
      'data': data,
      'hora': hora,
      'notificacao': notificacao,
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

  static Future<int> countTarefasNaoConcluidasByDate(String data) async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> tarefas = await db.query('tarefas',
        where: "concluida == ? AND data = ?",
        whereArgs: [0, data]
    );
    return tarefas.length;
  }

  static Future<int> countTarefasConcluidasByDate(String data) async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> tarefas = await db.query('tarefas',
        where: "concluida != ? AND data = ?",
        whereArgs: [0, data]
    );
    return tarefas.length;
  }

  static Future<int> countTarefasConcluidas() async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> tarefas = await db.query('tarefas',
        where: "concluida != ?",
        whereArgs: [0]
    );
    return tarefas.length;
  }

  static Future<List<Map<String, dynamic>>> getTarefaById(int id) async {
    final db = await SQLHelper.db();
    return db.query('tarefas', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getTarefasByDate(String data) async {
    final db = await SQLHelper.db();
    return db.query('tarefas', where: "data = ?", whereArgs: [data], orderBy: "hora");
  }

  static Future<List<Map<String, dynamic>>> getTarefasConcluidas() async {
    final db = await SQLHelper.db();
    return db.query('tarefas', where: "concluida != ?", whereArgs: [0]);
  }

  static Future<int> atualizaTarefa(
      int id, String categoria, String nome, String data, String hora, String notificacao, String descricao, String concluida, String createdAt) async {
    final db = await SQLHelper.db();

    final dados = {
      'categoria': categoria,
      'nome': nome,
      'data': data,
      'hora': hora,
      'notificacao': notificacao,
      'descricao': descricao,
      'concluida': concluida,
      'createdAt': createdAt
    };

    final result = await db.update('tarefas', dados, where: "id = ?", whereArgs: [id]);
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

  // Salvar tarefas localmente para add depois
  static Future<int> adicionarTarefaPendenteAdd(Map<String, dynamic> tarefa) async {
    final db = await SQLHelper.db_pendente_add();
    return await db.insert('tarefas_pendentes_add', tarefa);
  }

  static Future<List<Map<String, dynamic>>> obterTarefasPendentesAdd() async {
    final db = await SQLHelper.db_pendente_add();
    return await db.query('tarefas_pendentes_add');
  }

  static Future<int> removerTarefaPendenteAdd(int id) async {
    final db = await SQLHelper.db_pendente_add();
    return await db.delete('tarefas_pendentes_add', where: 'id = ?', whereArgs: [id]);
  }

  // Salvar tarefas localmente para deletar depois
  static Future<int> adicionarTarefaPendenteDelete(int id) async {
    final db = await SQLHelper.db_pendente_delete();
    return await db.insert('tarefas_pendentes_delete', {'id': id});
  }

  static Future<List<Map<String, dynamic>>> obterTarefasPendentesDelete() async {
    final db = await SQLHelper.db_pendente_delete();
    return await db.query('tarefas_pendentes_delete');
  }

  static Future<int> removerTarefaPendenteDelete(int id) async {
    final db = await SQLHelper.db_pendente_delete();
    return await db.delete('tarefas_pendentes_delete', where: 'id = ?', whereArgs: [id]);
  }
}