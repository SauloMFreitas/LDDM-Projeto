import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:intl/intl.dart';

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
        frequencia TEXT,
        descricao TEXT,
        id INTEGER PRIMARY KEY,
        concluida TEXT,
        idCopia INTEGER,
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

  static Future<int> adicionarTarefa(String categoria, String nome, String data, String hora, String notificacao, String frequencia, String descricao, String concluida) async {

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

    int idCopia = (frequencia == 'NÃ£o repetir') ? -1 : id;
    var tarefaCriada = await getTarefaById(id);
    //print('this - createdAt: ' + tarefaCriada[0]['createdAt']);
    await atualizaTarefa(id, idCopia, categoria, nome, data, hora, notificacao, frequencia, descricao, concluida, tarefaCriada[0]['createdAt']);

    tarefaCriada = await getTarefaById(id);
    //print('this - createdAt: ' + tarefaCriada[0]['createdAt']);

    //print("id = " + id.toString());
    //print("idCopia = " + idCopia.toString());

    final dateFormat = DateFormat('dd/MM/yyyy');
    DateTime dataInicial = dateFormat.parse(data);

    if (frequencia == 'Diariamente') {
      for (int i = 0; i < 365; i++) {
        // Atualiza data
        dataInicial = dataInicial.add(const Duration(days: 1));
        String novaData = dateFormat.format(dataInicial);
        await adicionarTarefaCopia(idCopia, categoria, nome, novaData, hora, notificacao, frequencia, descricao, '0');
      }
    }

    else if (frequencia == 'Semanalmente') {
      for (int i = 0; i < 52; i++) {
        // Atualiza data
        dataInicial = dataInicial.add(const Duration(days: 7));
        String novaData = dateFormat.format(dataInicial);
        await adicionarTarefaCopia(idCopia, categoria, nome, novaData, hora, notificacao, frequencia, descricao, '0');
      }
    }

    else if (frequencia == 'Mensalmente') {
      for (int i = 0; i < 12; i++) {
        dataInicial = _addMonthsToDateTime(dataInicial, 1);
        String novaData = dateFormat.format(dataInicial);
        await adicionarTarefaCopia(idCopia, categoria, nome, novaData, hora, notificacao, frequencia, descricao, '0');
      }
    }

    else if (frequencia == 'Anualmente') {
      for (int i = 0; i < 10; i++) {
        final novoAno = dataInicial.year + 1;
        dataInicial = DateTime(novoAno, dataInicial.month, dataInicial.day);
        String novaData = dateFormat.format(dataInicial);
        await adicionarTarefaCopia(idCopia, categoria, nome, novaData, hora, notificacao, frequencia, descricao, '0');
      }
    }

    return id;
  }

  static DateTime _addMonthsToDateTime(DateTime dateTime, int monthsToAdd) {
    var newYear = dateTime.year;
    var newMonth = dateTime.month + monthsToAdd;

    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }

    return DateTime(newYear, newMonth, dateTime.day);
  }

  static Future<int> adicionarTarefaCopia(int idCopia, String categoria, String nome, String data, String hora, String notificacao, String frequencia, String descricao, String concluida) async {

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

  static Future<List<Map<String, dynamic>>> getTarefasByIdCopia(int id, int idCopia) async {
    final db = await SQLHelper.db();
    return db.query('tarefas', where: "idCopia = ?", whereArgs: [idCopia]);
  }

  static Future<List<Map<String, dynamic>>> getTarefasConcluidas() async {
    final db = await SQLHelper.db();
    return db.query('tarefas', where: "concluida != ?", whereArgs: [0]);
  }

  static Future<int> atualizaTarefa(
      int id, int idCopia, String categoria, String nome, String data, String hora, String notificacao, String frequencia, String descricao, String concluida, String createdAt) async {
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
      'createdAt': createdAt
    };

    //print("creatAt: sTRING " + createdAt);

    final result = await db.update('tarefas', dados, where: "id = ?", whereArgs: [id]);
    return result;
  }
/*
  static Future<int> atualizaTarefaCopias(
      int id, int idCopia, String categoria, String nome, String data, String hora, String notificacao, String frequencia, String descricao, int concluida) async {
    final db = await SQLHelper.db();

    final tarefas = await SQLHelper.getTarefasByIdCopia(idCopia);

    // Verificar se frequencia e data nao mudaram
    bool data_frequencia_ok = false;
    for(int i = 0; i < data.length; i++) {
      if(tarefas[i]['frequencia'] == frequencia && tarefas[i]['data'] == data) {
        data_frequencia_ok = true;
      }
    }

    if(data_frequencia_ok) {
      for(int i = 0; i < data.length; i++) {
        final dados = {
          'idCopia': tarefas[i]['idCopia'],
          'categoria': tarefas[i]['categoria'],
          'nome': tarefas[i]['nome'],
          'data': tarefas[i]['data'],
          'hora': tarefas[i]['hora'],
          'notificacao': tarefas[i]['notificacao'],
          'frequencia': frequencia,
          'descricao': descricao,
          'concluida': concluida};
        final id = await db.insert('tarefas', dados, conflictAlgorithm: sql.ConflictAlgorithm.replace);
      }
    }



    for(int i = 0; i < data.length; i++) {





    }


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
*/
  static Future<void> apagaTarefa(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("tarefas", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Erro ($err) ao apagar a tarefa: $id");
    }
  }

  static Future<void> apagaTarefaCopias(int idAtual, int idCopia) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("tarefas", where: "idCopia = ? AND id >= ?", whereArgs: [idCopia, idAtual]);
    } catch (err) {
      debugPrint("Erro ($err) ao apagar as tarefas copiadas do id: $idCopia");
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