import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'Sobre.dart';
import 'assets/AppStyles.dart';
import 'package:flutter/services.dart';
import 'sql_helper.dart';
import 'dart:async';
import 'ClassTarefa.dart';



final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();
final formatCurrency = NumberFormat.simpleCurrency();


class Lista extends StatefulWidget {
  String? dataSelecionada = DateFormat('dd/MM/yyyy').format(DateTime.now());

  Lista({this.dataSelecionada});

  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  List<Map<String, dynamic>> _tarefas = [];
  bool _estaAtualizando = true;
  late List<bool> _isCheckedList = List<bool>.generate(_tarefas.length, (index) => false);

  void _atualizaTarefas() async {
    final data = await SQLHelper.getTarefaByDate(widget.dataSelecionada!);
    setState(() {
      _tarefas = data;
      _estaAtualizando = false;
    });
  }
  void _apagaTarefa(int id) async {
    await SQLHelper.apagaTarefa(id);
    _scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
      content: Text('Tarefa apagada!'),
    ));
    _atualizaTarefas();
  }

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
        child: ListView.builder(
          itemCount: _tarefas.length,
          itemBuilder: (context, indice) {
            return Column(
              children: <Widget>[
                Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    _apagaTarefa(_tarefas[indice]['id']);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: _isCheckedList[indice],
                        onChanged: (value) {
                          setState(() {
                            _isCheckedList[indice] = value!; 
                          });
                        },
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(_tarefas[indice]['nome']),
                              content: Text(_tarefas[indice]['descricao']),
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
                                    print("Alterar " + _tarefas[indice]['nome'] + " selecionado");
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
                            : null, // Define o estilo como nulo se _isChecked for false
                      )
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
              ],
            );
          },
        ),
      ),
    );
  }
}
