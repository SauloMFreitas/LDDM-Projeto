import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Sobre.dart';
import 'assets/AppStyles.dart';
import 'sql_helper.dart';
import 'dart:async';

final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();

class Lista extends StatefulWidget {
  String? dataSelecionada = DateFormat('dd/MM/yyyy').format(DateTime.now());

  Lista({this.dataSelecionada});

  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  List<Map<String, dynamic>> _tarefas = [];
  bool _estaAtualizando = true;
  late List<bool> _isCheckedList = List<bool>.generate(
      _tarefas.length, (index) => false);

  Map<String, Color> categoriaParaCor = {
    'Faculdade': Colors.blue,
    'Lazer': Colors.green,
    'Saúde': Colors.red,
    'Trabalho': Colors.yellow
  };

  String _categoriaSelecionada = ''; // Categoria selecionada para filtragem

  void _atualizaTarefas() async {
    final data = await SQLHelper.getTarefasByDate(widget.dataSelecionada!);
    setState(() {
      _tarefas = data;
      _isCheckedList = _tarefas.map((tarefa) => tarefa['concluida'] == 1).toList();
    });
    // _printChecked();
  }

  void _printChecked() {
    for (int i = 0; i < _isCheckedList.length; i++) {
      print("[$i] : " + _isCheckedList[i].toString());
    }
  }
/*
  void _marcarTarefa(int id, int index, int valor) async{
    SQLHelper.atualizaTarefa(
      id,
      _tarefas[index]['categoria'],
      _tarefas[index]['nome'],
      _tarefas[index]['data'],
      _tarefas[index]['hora'],
      _tarefas[index]['notificacao'],
      _tarefas[index]['frequencia'],
      _tarefas[index]['descricao'],
      valor
    );
    _atualizaTarefas();
  }*/

  void _apagaTarefa(int id) async {
    await SQLHelper.apagaTarefa(id);
    _scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
      content: Text('Tarefa apagada!'),
    ));
    _atualizaTarefas();
  }

  @override
  Widget build(BuildContext context) {
    _atualizaTarefas();
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Tarefas ${widget.dataSelecionada!}'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Sobre(),
                ),
              );
            },
          ),
        ],
        backgroundColor: AppStyles.highlightColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("Filtro"),
                PopupMenuButton<String>(
                  icon: Icon(Icons.filter_alt_rounded),
                  onSelected: (String categoria) {
                    setState(() {
                      if (categoria == "Nenhum filtro") {
                        _categoriaSelecionada = "";
                      } else {
                        _categoriaSelecionada = categoria;
                      }
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    List<PopupMenuEntry<String>> items = [];

                    items.addAll(categoriaParaCor.keys.map((categoria) {
                      return PopupMenuItem<String>(
                        value: categoria,
                        child: Text(categoria),
                      );
                    }).toList());
                    items.add(
                      PopupMenuItem<String>(
                        value: "Nenhum filtro",
                        child: Text("Nenhum filtro"),
                      ),
                    );

                    return items;
                  },
                ),
              ],
            )
            ,
            Expanded(
              child: ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: (context, indice) {

                  if (_categoriaSelecionada.isNotEmpty &&
                      _tarefas[indice]['categoria'] != _categoriaSelecionada) {
                    return Container();
                  }

                  return Column(
                    children: <Widget>[
                      Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          _apagaTarefa(_tarefas[indice]['id']);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: categoriaParaCor[_tarefas[indice]['categoria']] ??
                                Colors.grey[400],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            leading: Checkbox(
                              value: _isCheckedList[indice],
                              onChanged: (value) {
                                setState(() {
                                  _isCheckedList[indice] = value!;
                                  //int _valorInteiro = value ? 1 : 0;
                                  //_marcarTarefa(_tarefas[indice]['id'], indice, _valorInteiro);
                                });
                                _printChecked();
                              },
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(_tarefas[indice]['nome']),
                                    content: Text(
                                        _tarefas[indice]['descricao']),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          _apagaTarefa(_tarefas[indice]['id']);
                                          Navigator.pop(context);
                                        },
                                        child: Text("Excluir"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          print("Alterar " +
                                              _tarefas[indice]['nome'] +
                                              " selecionado");
                                          Navigator.pop(context);
                                        },
                                        child: Text("Editar"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onLongPress: () {
                              print("Clique com onLongPress ${indice}");
                            },
                            title: Text(
                              '${_tarefas[indice]['nome']} - [${_tarefas[indice]['data']}] - ${_tarefas[indice]['hora']}',
                              style: _isCheckedList[indice]
                                  ? TextStyle(
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.red,
                                decorationThickness: 2.0,
                              )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}