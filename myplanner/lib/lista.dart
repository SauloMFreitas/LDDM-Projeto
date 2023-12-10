import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sobre.dart';
import 'app_styles.dart';
import 'sql_helper.dart';
import 'cadastrar_tarefa.dart';
import 'xp_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  List<bool> _isCheckedList = [];
  String _categoriaSelecionada = '';
  bool _estaAtualizado = false;
  static final xp = XPHandler();

  Map<String, Color> categoriaParaCor = {
    'Faculdade': Colors.blue,
    'Lazer': Colors.green,
    'Pessoal': Colors.orange,
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
        _isCheckedList = List<bool>.generate(_tarefas.length, (index) => !(_tarefas[index]['concluida'] == '0'));
      });
      _estaAtualizado = true;
      _printChecked();
    }
  }

  void _printChecked() {
    for (int i = 0; i < _isCheckedList.length; i++) {
      //print("[$i] : " + _isCheckedList[i].toString());
    }
  }

  Future<bool> _verificarConexao() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<Map<String, String>?> getUsuarioFromSharedPreferences() async {
    // Obtém uma instância de SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Obtém os dados do usuário em formato JSON a partir do SharedPreferences
    final userDataJson = prefs.getString('userData');

    if (userDataJson != null) {
      // Se os dados do usuário existirem, analise o JSON para obter as informações
      final userData = json.decode(userDataJson);
      final email = userData['email'];
      final celular = userData['celular'];
      final nomePet = userData['nomePet'];
      final nome = userData['nome'];

      if (email != null && celular != null && nomePet != null && nome != null) {
        // Se todas as informações estiverem presentes, retorne um mapa com os dados do usuário
        return {
          'email': email,
          'celular': celular,
          'nomePet': nomePet,
          'nome': nome
        };
      }
    }

    return null;
  }

  String userEmail = "";
  var id = 0;

  void _getUserInfo() async {
    final userData = await getUsuarioFromSharedPreferences();
    if (userData != null) {
      setState(() {
        userEmail = userData['email'] ?? "";
      });
    }
  }

  void _marcarTarefa(int id, int index, String concluido) async {
    _getUserInfo();

    var idAdd = id;
    var categoria = _tarefas[index]['categoria'];
    var nome = _tarefas[index]['nome'];
    var data = _tarefas[index]['data'];
    var hora = _tarefas[index]['hora'];
    var notificacao = _tarefas[index]['notificacao'];
    var descricao = _tarefas[index]['descricao'];
    var concluidoAdd = concluido;
    var createdAtAdd = _tarefas[index]['createdAt'];

    SQLHelper.atualizaTarefa(
      id,
      _tarefas[index]['categoria'],
      _tarefas[index]['nome'],
      _tarefas[index]['data'],
      _tarefas[index]['hora'],
      _tarefas[index]['notificacao'],
      _tarefas[index]['descricao'],
      concluido,
      _tarefas[index]['createdAt'],
    );
    _estaAtualizado = false;
    await xp.xPCalculator(_tarefas[index]['categoria']);

    if (await _verificarConexao()) {
      try {
        var path = '/usuarios/$userEmail/tarefas';
        await FirebaseFirestore.instance
            .collection(path)
            .doc(idAdd.toString())
            .set({
          'usuario': userEmail,
          'categoria': categoria,
          'nome': nome,
          'data': data,
          'hora': hora,
          'notificacao': notificacao,
          'descricao': descricao,
          'id': idAdd,
          'concluida': concluidoAdd,
          'createdAt': createdAtAdd,
        });

        print('Tarefa salva no Firestore com sucesso!');
      } catch (error) {
        print('Erro ao salvar tarefa no Firestore: $error');
        // Tratar erros conforme necessário.
      }
    } else {
      // Adiciona na fila para sincronização posterior
      await SQLHelper.adicionarTarefaPendenteAdd({
        'usuario': userEmail,
        'categoria': categoria,
        'nome': nome,
        'data': data,
        'hora': hora,
        'notificacao': notificacao,
        'descricao': descricao,
        'id': idAdd,
        'concluida': concluidoAdd,
        'createdAt': createdAtAdd,
      });

      print('Tarefa adicionada na fila para sincronização posterior.');
    }
  }

  void _apagaTarefa(int id) async {
    _getUserInfo();
    var idDel = id;
    await SQLHelper.apagaTarefa(id);

    if (await _verificarConexao()) {
      try {
        var path = '/usuarios/$userEmail/tarefas';
        await FirebaseFirestore.instance.collection(path).doc(idDel.toString()).delete();
        await AwesomeNotifications().cancel(idDel);

        print('Tarefa deletada do Firestore com sucesso!');
      } catch (error) {
        print('Erro ao deletar tarefa no Firestore: $error');
        // Tratar erros conforme necessário.
      }
    } else {
      // Adiciona na fila para sincronização posterior
      await SQLHelper.adicionarTarefaPendenteDelete(idDel);

      print('Tarefa adicionada na fila para sincronização posterior.');
    }

    _scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
      content: Text('Tarefa apagada!'),
    ));
    _estaAtualizado = false;
  }

  Future<void> sincronizarTarefasPendentes() async {
    bool isConnected = await _verificarConexao();

    if (isConnected) {
      await _sincronizarTarefasPorTipo(SQLHelper.obterTarefasPendentesAdd, SQLHelper.removerTarefaPendenteAdd, 'Adicionar');
      await _sincronizarTarefasPorTipo(SQLHelper.obterTarefasPendentesDelete, SQLHelper.removerTarefaPendenteDelete, 'Deletar');
    }
  }

  Future<void> _sincronizarTarefasPorTipo(
      Future<List<Map<String, dynamic>>> Function() obterTarefasPendentes,
      Future<void> Function(int) removerTarefaPendente,
      String tipo) async {
    List<Map<String, dynamic>> tarefasPendentes = await obterTarefasPendentes();

    for (Map<String, dynamic> tarefa in tarefasPendentes) {
      try {
        int tarefaId = tarefa['id'];
        var path = '/usuarios/$userEmail/tarefas';

        if (tipo == 'Adicionar') {
          await FirebaseFirestore.instance.collection(path).doc(tarefaId.toString()).set(tarefa);
        } else if (tipo == 'Deletar') {
          await FirebaseFirestore.instance.collection(path).doc(tarefaId.toString()).delete();
          await AwesomeNotifications().cancel(tarefaId);
        }

        await removerTarefaPendente(tarefaId);
        print('Tarefa sincronizada com sucesso: $tarefaId - Tipo: $tipo');
      } catch (error) {
        print('Erro ao sincronizar tarefa: ${tarefa['id']} - Tipo: $tipo, Erro: $error');
        // Adicione lógica adicional para lidar com erros, se necessário.
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    //_getUserInfo();
    sincronizarTarefasPendentes();
    final AppStyles appStyles = AppStyles();
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Tarefas ${widget.dataSelecionada!}'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white),
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
        backgroundColor: appStyles.highlightColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  _categoriaSelecionada.isEmpty ? "Filtro".toString() : _categoriaSelecionada.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: categoriaParaCor[_categoriaSelecionada] ?? Colors.black,
                  ),
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
                    ElevatedButton(
                      style: appStyles.customPositiveButtonStyle,
                      onPressed: () {
                        DateTime dataFormatada =
                        DateFormat('dd/MM/yyyy')
                            .parse(widget.dataSelecionada!);
                        //print(_dataFormatada);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CadastrarTarefa(
                                data: dataFormatada, editarTarefa: false
                            ),
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
                            color: categoriaParaCor[
                            _tarefas[indice]['categoria']] ??
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
                                  int valor = value! ? 1 : 0;
                                  String marcar = (valor == 0) ? '0' : DateFormat('dd/MM/yyyy').format(DateTime.now());
                                  //print('marcar $marcar');
                                  _marcarTarefa(_tarefas[indice]['id'], indice, marcar);
                                  _atualizaTarefas();
                                });
                                _printChecked();
                              },
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Center(
                                      child: Text(
                                        _tarefas[indice]['nome'],
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    content: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Categoria: ',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text: _tarefas[indice]['categoria'],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Data: ',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text: _tarefas[indice]['data'],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Horário: ',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text: _tarefas[indice]['hora'],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Descrição: ',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text: _tarefas[indice]['descricao'],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                                decoration: TextDecoration.lineThrough,
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
                                          title: const Text('Editar Tarefa'),
                                          content: const Text('Deseja editar esta tarefa?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                _estaAtualizado = false;
                                                DateTime dataTarefa = DateFormat('dd/MM/yyyy HH:mm').parse(
                                                    _tarefas[indice]['data'] + ' ' + _tarefas[indice]['hora']
                                                );
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => CadastrarTarefa(
                                                      data: dataTarefa,
                                                      editarTarefa: true,
                                                      idAtualizar: _tarefas[indice]['id'],
                                                      categoriaAtualizar: _tarefas[indice]['categoria'],
                                                      nomeAtualizar: _tarefas[indice]['nome'],
                                                      notificacaoAtualizar: _tarefas[indice]['notificacao'],
                                                      descricaoAtualizar: _tarefas[indice]['descricao'],
                                                      createdAt: _tarefas[indice]['createdAt'],
                                                    ),
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
                                                Navigator.of(context).pop();
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
                                      builder: (BuildContext context) {
                                          // Excluir somente esta tarefa
                                          return AlertDialog(
                                            title: const Text('Confirmação'),
                                            content: const Text('Deseja excluir esta tarefa?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  _apagaTarefa(_tarefas[indice]['id']);
                                                  _estaAtualizado = false;
                                                  Navigator.of(context).pop('Sim');
                                                  _atualizaTarefas();

                                                  // Mostrar diálogo de sucesso
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text('Sucesso'),
                                                        content: const Text('Sua tarefa foi deletada com sucesso!'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop(); // Fecha o AlertDialog de sucesso
                                                            },
                                                            child: const Text('OK'),
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
                                                  Navigator.of(context).pop('Não'); // Fecha o AlertDialog de confirmação com 'Não'
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