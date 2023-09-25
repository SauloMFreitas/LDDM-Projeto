import 'package:flutter/material.dart';
import 'assets/AppStyles.dart';
import 'package:intl/intl.dart';
import 'ClassTarefa.dart';

class Lista extends StatefulWidget {
  DateTime? dataSelecionada = DateTime.now();

  Lista({this.dataSelecionada});

  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  List<Tarefa> _listaDeTarefas = [];
  List<bool> _isCheckedList = []; 

  void _carregarItens() {
    if(_listaDeTarefas.length == 0) {
    for (int i = 1; i <= 10; i++) {
      Tarefa novaTarefa = Tarefa(
        categoria: 'Faculdade',
        nomeTarefa: 'Tarefa $i',
        data: DateTime.now().toString(),
        notificacao: 'Não receber',
        descricao: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat',
      );

      _listaDeTarefas.add(novaTarefa);
      _isCheckedList.add(false);
    }
    }
  }

  void _excluirItem(int indice) {
    print('Item excluído = ' + _listaDeTarefas[indice].nomeTarefa);
    setState(() {
      _listaDeTarefas.removeAt(indice);
      _isCheckedList.removeAt(indice);
    });
  }

  Widget build(BuildContext context) {
    _carregarItens();

    String _data = DateFormat('dd/MM/yyyy').format(widget.dataSelecionada ?? DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Tarefas ${_data.toString()}'),
        centerTitle: true,
        backgroundColor: AppStyles.highlightColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: _listaDeTarefas.length,
          itemBuilder: (context, indice) {
            return Column(
              children: <Widget>[
                Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    _excluirItem(indice);
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
                              title: Text(_listaDeTarefas[indice].nomeTarefa),
                              content: Text(_listaDeTarefas[indice].descricao),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    _excluirItem(indice);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Excluir"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    print("Alterar " + _listaDeTarefas[indice].nomeTarefa + " selecionado");
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
                        '${_listaDeTarefas[indice].nomeTarefa} - ${DateFormat('HH:mm').format(DateTime.parse(_listaDeTarefas[indice].data))}',
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
