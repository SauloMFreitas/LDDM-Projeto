import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sobre.dart';
import 'assets/app_styles.dart';
import 'sql_helper.dart';
import 'cadastrar_tarefa.dart';
import 'xp_handler.dart';

final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class Lista extends StatefulWidget {
  String? dataSelecionada = DateFormat('dd/MM/yyyy').format(DateTime.now());

  Lista({super.key, this.dataSelecionada});

  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  List<Map<String, dynamic>> _tarefas = [];
  late List<bool> _isCheckedList;
  String _categoriaSelecionada = '';
  bool _estaAtualizado = false;

  Map<String, Color> categoriaParaCor = {
    'Faculdade': Colors.blue,
    'Lazer': Colors.green,
    'Saúde': Colors.red,
    'Trabalho': Colors.yellow
  };

  @override
  void initState() {
    super.initState();
    _atualizaTarefas();
  }

  void _atualizaTarefas() async {
    if (!_estaAtualizado) {
      final data = await SQLHelper.getTarefasByDate(widget.dataSelecionada!);
      //final data = await SQLHelper.getTarefas();
      setState(() {
        _tarefas = data;
        _isCheckedList = List<bool>.generate(_tarefas.length, (index) => false);
      });
      _estaAtualizado = true;
    }
  }

  void _printChecked() {
    for (int i = 0; i < _isCheckedList.length; i++) {
      //print("[$i] : " + _isCheckedList[i].toString());
    }
  }

  void _marcarTarefa(int id, int index, int valor) async {
    if (valor > 0) {
      final xp = XPHandler();
      xp.XPCalculator(_tarefas[index]['data'], DateTime.now());
    }
    SQLHelper.atualizaTarefa(
      id,
      _tarefas[index]['idCopia'],
      _tarefas[index]['categoria'],
      _tarefas[index]['nome'],
      _tarefas[index]['data'],
      _tarefas[index]['hora'],
      _tarefas[index]['notificacao'],
      _tarefas[index]['frequencia'],
      _tarefas[index]['descricao'],
      valor,
    );
    _estaAtualizado = false;
  }

  void _apagaTarefa(int id) async {
    await SQLHelper.apagaTarefa(id);
    _scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
      content: Text('Tarefa apagada!'),
    ));
    _estaAtualizado = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Tarefas ${widget.dataSelecionada!}'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Sobre(),
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
                Text(
                  _categoriaSelecionada.isEmpty
                      ? "Filtro".toString()
                      : _categoriaSelecionada.toString(),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_alt_rounded),
                  onSelected: (String categoria) {
                    setState(() {
                      if (categoria == "Todas") {
                        _categoriaSelecionada = "";
                      } else {
                        _categoriaSelecionada = categoria;
                      }
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    List<PopupMenuEntry<String>> items = [];
                    items.add(
                      const PopupMenuItem<String>(
                        value: "Todas",
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.grey,
                            ),
                            SizedBox(width: 8),
                            Text("Todas"),
                          ],
                        ),
                      ),
                    );
                    items.addAll(categoriaParaCor.keys.map((categoria) {
                      return PopupMenuItem<String>(
                        value: categoria,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor:
                                  categoriaParaCor[categoria] ?? Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(categoria),
                          ],
                        ),
                      );
                    }).toList());
                    return items;
                  },
                ),
              ],
            ),
            Expanded(
              child: _tarefas.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "Nenhuma tarefa cadastrada para o dia ${widget.dataSelecionada}"),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyles.positiveButton,
                            ),
                            onPressed: () {
                              DateTime dataFormatada = DateFormat('dd/MM/yyyy')
                                  .parse(widget.dataSelecionada!);
                              //print(_dataFormatada);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CadastrarTarefa(
                                      data: dataFormatada, editarTarefa: false),
                                ),
                              ).then((result) {
                                _estaAtualizado = false;
                                _atualizaTarefas();
                              });
                            },
                            child: const Text("Cadastrar tarefa"),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tarefas.length,
                      itemBuilder: (context, indice) {
                        if (_categoriaSelecionada.isNotEmpty &&
                            _tarefas[indice]['categoria'] !=
                                _categoriaSelecionada) {
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
                                  color: categoriaParaCor[_tarefas[indice]
                                          ['categoria']] ??
                                      Colors.grey[400],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  leading: Checkbox(
                                    value: _isCheckedList[indice],
                                    activeColor: Colors.lightGreen,
                                    onChanged: (value) {
                                      setState(() {
                                        _estaAtualizado = false;
                                        _isCheckedList[indice] = value!;
                                        int valor = value ? 1 : 0;
                                        _marcarTarefa(_tarefas[indice]['id'],
                                            indice, valor);
                                      });
                                      _printChecked();
                                    },
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              'Nome: ${_tarefas[indice]['nome']}'),
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  'Categoria: ${_tarefas[indice]['categoria']}'),
                                              Text(
                                                  'Data: ${_tarefas[indice]['data']}'),
                                              Text(
                                                  'Horário: ${_tarefas[indice]['hora']}'),
                                              Text(
                                                  'Descrição: ${_tarefas[indice]['descricao']}'),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Fechar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  onLongPress: () {
                                    //print("Clique com onLongPress ${indice}");
                                  },
                                  title: Text(
                                    '${_tarefas[indice]['nome']} - ${_tarefas[indice]['hora']}',
                                    style: _isCheckedList[indice]
                                        ? const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationColor: Colors.black,
                                            decorationThickness: 2.0,
                                          )
                                        : null,
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.create_outlined),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Editar Tarefa'),
                                                content: const Text(
                                                    'Deseja editar esta tarefa?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      _estaAtualizado = false;
                                                      DateTime dataTarefa =
                                                          DateFormat(
                                                                  'dd/MM/yyyy HH:mm')
                                                              .parse(_tarefas[
                                                                          indice]
                                                                      ['data'] +
                                                                  ' ' +
                                                                  _tarefas[
                                                                          indice]
                                                                      ['hora']);
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => CadastrarTarefa(
                                                              data: dataTarefa,
                                                              editarTarefa:
                                                                  true,
                                                              idAtualizar: _tarefas[indice]
                                                                  ['id'],
                                                              idCopiaAtualizar:
                                                                  _tarefas[indice][
                                                                      'idCopia'],
                                                              categoriaAtualizar: _tarefas[indice]
                                                                  ['categoria'],
                                                              nomeAtualizar:
                                                                  _tarefas[indice]
                                                                      ['nome'],
                                                              notificacaoAtualizar:
                                                                  _tarefas[indice][
                                                                      'notificacao'],
                                                              frequenciaAtualizar:
                                                                  _tarefas[indice][
                                                                      'frequencia'],
                                                              descricaoAtualizar:
                                                                  _tarefas[indice]
                                                                      ['descricao']),
                                                        ),
                                                      ).then((result) {
                                                        _estaAtualizado = false;
                                                        _atualizaTarefas();
                                                      });
                                                    },
                                                    child: const Text('Sim'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Não'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Excluir Tarefa'),
                                                content: const Text(
                                                    'Deseja excluir esta tarefa?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _apagaTarefa(
                                                            _tarefas[indice]
                                                                ['id']);
                                                        _estaAtualizado = false;
                                                      });
                                                      Navigator.of(context)
                                                          .pop(); // Fecha o AlertDialog de confirmação
                                                      _estaAtualizado = false;
                                                      _atualizaTarefas();

                                                      // Exibe um AlertDialog de sucesso
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Sucesso'),
                                                            content: const Text(
                                                                'Sua tarefa foi deletada com sucesso!'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(); // Fecha o AlertDialog de sucesso
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'OK'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: const Text('Sim'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Fecha o AlertDialog de confirmação
                                                    },
                                                    child: const Text('Não'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15.0),
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
