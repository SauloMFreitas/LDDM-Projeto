import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> criaTabela(sql.Database database) async {
    await database.execute("""CREATE TABLE produtos(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nome TEXT,
        valor REAL,
        ean INTEGER,
        qte INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'produtos.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await criaTabela(database);
      },
    );
  }

  static Future<int> adicionarProduto(String nome, double valor, int ean, int qte) async {
    final db = await SQLHelper.db();

    final dados = {'nome': nome, 'valor': valor, 'ean': ean, 'qte': qte};
    final id = await db.insert('produtos', dados,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> pegaProdutos() async {
    final db = await SQLHelper.db();
    return db.query('produtos', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> pegaUmProduto(int id) async {
    final db = await SQLHelper.db();
    return db.query('produtos', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> atualizaProduto(
      int id, String nome, double valor, int ean, int qte) async {
    final db = await SQLHelper.db();

    final dados = {
      'nome': nome,
      'valor': valor,
      'ean': ean,
      'qte': qte,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('produtos', dados, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> apagaProduto(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("produtos", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Erro ao apagar o item item: $err");
    }
  }
}