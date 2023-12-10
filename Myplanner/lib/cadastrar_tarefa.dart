import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'assets/app_styles.dart';
import 'sobre.dart';
import 'sql_helper.dart';
import 'token.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

final formatCurrency = NumberFormat.simpleCurrency();

class CadastrarTarefa extends StatefulWidget {
  DateTime? data;
  bool? editarTarefa = false;

  int? idAtualizar;
  int? idCopiaAtualizar;

  String? categoriaAtualizar;
  String? nomeAtualizar;
  String? notificacaoAtualizar;
  String? frequenciaAtualizar;
  String? descricaoAtualizar;
  String? createdAt;

  CadastrarTarefa({
    super.key,
    DateTime? data,
    bool? editarTarefa,
    int? idAtualizar,
    int? idCopiaAtualizar,
    String? categoriaAtualizar,
    String? nomeAtualizar,
    String? notificacaoAtualizar,
    String? frequenciaAtualizar,
    String? descricaoAtualizar,
    String? createdAt,
  }) {
    this.data = data ?? DateTime.now();
    this.editarTarefa = editarTarefa ?? false;

    this.idAtualizar = idAtualizar ?? -1;
    this.idCopiaAtualizar = idCopiaAtualizar ?? idAtualizar;

    this.categoriaAtualizar = categoriaAtualizar ?? 'Faculdade';
    this.nomeAtualizar = nomeAtualizar ?? '';
    this.notificacaoAtualizar = notificacaoAtualizar ?? 'Não notificar';
    this.frequenciaAtualizar = frequenciaAtualizar ?? 'Não repetir';
    this.descricaoAtualizar = descricaoAtualizar ?? '';
    this.createdAt = createdAt ?? '';
  }

  @override
  _CadastrarTarefa createState() => _CadastrarTarefa();
}

class _CadastrarTarefa extends State<CadastrarTarefa> {
  @override
  void initState() {
    super.initState();
  }

  void reset() {
    _categoria = 'Faculdade';
    _nomeController.text = '';
    _descricaoController.text = '';
    _dataFormatada = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _horaFormatada = DateFormat('HH:mm').format(DateTime.now());
    _notificacao = 'Não notificar';
    _frequencia = 'Não repetir';
  }

  // Função para verificar a validade do token e redirecionar para a tela de login se for inválido
  Future<void> _checkTokenValidity() async {
    final tokenManager = TokenManager();
    final isValidToken = await tokenManager.isValidToken();

    if (!isValidToken) {
      // Redirecione o usuário para a tela de login
      _redirectToLoginScreen();
    }
  }

  void _redirectToLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  List<String> arrayCategorias = ['Faculdade', 'Lazer', 'Saúde', 'Trabalho'];
  late String? _categoria = widget.categoriaAtualizar ?? 'Faculdade';

  List<String> arrayNotificacoes = [
    'Não notificar',
    '5 minutos antes',
    '15 minutos antes',
    '30 minutos antes'
  ];
  late String? _notificacao = widget.notificacaoAtualizar ?? 'Não notificar';

  List<String> arrayFrequencias = [
    'Não repetir',
    'Diariamente',
    'Semanalmente',
    'Mensalmente',
    'Anualmente'
  ];
  late String? _frequencia = widget.frequenciaAtualizar ?? 'Não repetir';

  late String _dataFormatada = (widget.data != null)
      ? DateFormat('dd/MM/yyyy').format(widget.data!)
      : DateFormat('dd/MM/yyyy').format(DateTime.now());
  late String _horaFormatada = (widget.data != null)
      ? DateFormat('HH:mm').format(widget.data!)
      : DateFormat('HH:mm').format(DateTime.now());

  late final TextEditingController _nomeController =
  TextEditingController(text: widget.nomeAtualizar ?? '');
  late final TextEditingController _descricaoController =
  TextEditingController(text: widget.descricaoAtualizar ?? '');

  bool _error = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<void> _adicionaTarefa() async {
    _getUserInfo();
    _getUserInfo();
    if (_nomeController.text != '') {
      var categoria = _categoria!;
      var nome = _nomeController.text;
      var data = _dataFormatada;
      var hora = _horaFormatada;
      var notificacao = _notificacao!;
      var frequencia = _frequencia!;
      var descricao = _descricaoController.text;
      var zero = '0';

      // Salvar no SQLite
      id = await SQLHelper.adicionarTarefa(
        _categoria!,
        _nomeController.text,
        _dataFormatada,
        _horaFormatada,
        _notificacao!,
        _frequencia!,
        _descricaoController.text,
        '0',
      );

      print(_categoria!);
      if (await _verificarConexao()) {
        print(_categoria!);
        try {
          // Salva no Firestore
          var path = '/usuarios/$userEmail/tarefas';
          await FirebaseFirestore.instance
              .collection(path)
              .doc(id.toString())
              .set({
            'usuario': userEmail,
            'categoria': categoria,
            'nome': nome,
            'data': data,
            'hora': hora,
            'notificacao': notificacao,
            'frequencia': frequencia,
            'descricao': descricao,
            'id': id,
            'concluida': 0,
            'idCopia': -1,
            'createdAt': getCurrentDateTime(),
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
          'frequencia': frequencia,
          'descricao': descricao,
          'id': id,
          'concluida': 0,
          'idCopia': -1,
          'createdAt': getCurrentDateTime(),
        });

        print('Tarefa adicionada na fila para sincronização posterior.');
      }
      _error = false;
    } else {
      _error = true;
    }
  }

  String getCurrentDateTime() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return formattedDate;
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
    _getUserInfo();
    for (Map<String, dynamic> tarefa in tarefasPendentes) {
      try {
        int tarefaId = tarefa['id'];
        var path = '/usuarios/$userEmail/tarefas';

        if (tipo == 'Adicionar') {
          await FirebaseFirestore.instance.collection(path).doc(tarefaId.toString()).set(tarefa);
        } else if (tipo == 'Deletar') {
          await FirebaseFirestore.instance.collection(path).doc(tarefaId.toString()).delete();
        }

        await removerTarefaPendente(tarefaId);
        print('Tarefa sincronizada com sucesso: $tarefaId - Tipo: $tipo');
      } catch (error) {
        print('Erro ao sincronizar tarefa: ${tarefa['id']} - Tipo: $tipo, Erro: $error');
        // Adicione lógica adicional para lidar com erros, se necessário.
      }
    }
  }

  Future<void> _atualizaTarefa(int id, String createdAt) async {
    _getUserInfo();
    var idAdd = id;
    var categoria = _categoria!;
    var nome = _nomeController.text;
    var data = _dataFormatada;
    var hora = _horaFormatada;
    var notificacao = _notificacao!;
    var frequencia = _frequencia!;
    var descricao = _descricaoController.text;
    var zero = '0';
    var createdAtAdd = createdAt;

    await SQLHelper.atualizaTarefa(
        id,
        -1,
        _categoria!,
        _nomeController.text,
        _dataFormatada,
        _horaFormatada,
        _notificacao!,
        _frequencia!,
        _descricaoController.text,
        '0',
        createdAt);

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
          'frequencia': frequencia,
          'descricao': descricao,
          'id': idAdd,
          'concluida': 0,
          'idCopia': -1,
          'createdAt': createdAt,
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
        'frequencia': frequencia,
        'descricao': descricao,
        'id': idAdd,
        'concluida': 0,
        'idCopia': -1,
        'createdAt': createdAt,
      });

      print('Tarefa adicionada na fila para sincronização posterior.');
    }
  }

  Future<void> _atualizaTarefaCopias(int idCopia) async {
    /*
    await SQLHelper.atualizaTarefaCopias(
        idCopia,
        _categoria!,
        _nomeController.text,
        _dataFormatada,
        _horaFormatada,
        _notificacao!,
        _frequencia!,
        _descricaoController.text,
        0
    );
    */
  }

  @override
  Widget build(BuildContext context) {
    sincronizarTarefasPendentes();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.editarTarefa != null && widget.editarTarefa!)
              ? 'Editar Tarefa'
              : 'Criar Tarefa',
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              DropdownButtonFormField(
                value: _categoria,
                onChanged: (novaCategoria) {
                  setState(() {
                    _categoria = novaCategoria.toString();
                    //print('Categoria selecionada: $_categoria');
                  });
                },
                items: arrayCategorias.map((categoria) {
                  return DropdownMenuItem(
                    value: categoria,
                    child: Text(categoria),
                  );
                }).toList(),
                decoration: AppStyles.decorationTextFieldType2(
                    labelText: 'Selecione uma categoria'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                  keyboardType: TextInputType.text,
                  decoration: AppStyles.decorationTextField(
                      labelText: 'Nome da Tarefa'),
                  style: AppStyles.styleTextField,
                  controller: _nomeController,
                  onSubmitted: (String nome) {
                    //print('nome = ' + nome);
                  }),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      keyboardType: TextInputType.none,
                      decoration: AppStyles.decorationTextField(
                          labelText: _dataFormatada),
                      style: AppStyles.styleTextField,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      enabled: false,
                      keyboardType: TextInputType.none,
                      decoration: AppStyles.decorationTextField(
                          labelText: _horaFormatada),
                      style: AppStyles.styleTextField,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: AppStyles.customPositiveButtonStyle,
                child: const Text('Selecione a data e horário'),
                onPressed: () async {
                  //print("data: ${widget.data!}");
                  DateTime? novaData = await showDatePicker(
                    context: context,
                    initialDate: widget.data!,
                    firstDate: DateTime.now().toLocal(),
                    lastDate: DateTime(2200),
                  );

                  if (novaData != null) {
                    setState(() {
                      widget.data = novaData!;
                      _dataFormatada =
                          DateFormat('dd/MM/yyyy').format(widget.data!);
                    });

                    TimeOfDay? novoHorario = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(widget.data!),
                    );

                    if (novoHorario != null) {
                      novaData = DateTime(
                        novaData.year,
                        novaData.month,
                        novaData.day,
                        novoHorario.hour,
                        novoHorario.minute,
                      );

                      setState(() {
                        widget.data = novaData!;
                        _horaFormatada =
                            DateFormat('HH:mm').format(widget.data!);
                      });
                    }
                  }
                  //print('data = ' + widget.data!.toString());
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField(
                value: _notificacao,
                onChanged: (novaNotificacao) {
                  setState(() {
                    _notificacao = novaNotificacao.toString();
                    //print('Notificação selecionada: $_notificacao');
                  });
                },
                items: arrayNotificacoes.map((notificacao) {
                  return DropdownMenuItem(
                    value: notificacao,
                    child: Text(notificacao),
                  );
                }).toList(),
                decoration: AppStyles.decorationTextFieldType2(
                    labelText: 'Selecione o tempo de notificação'),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField(
                value: _frequencia,
                onChanged: (novaFrequencia) {
                  setState(() {
                    _frequencia = novaFrequencia.toString();
                    //print('Frequência selecionada: $_frequencia');
                  });
                },
                items: arrayFrequencias.map((frequencia) {
                  return DropdownMenuItem(
                    value: frequencia,
                    child: Text(frequencia),
                  );
                }).toList(),
                decoration: AppStyles.decorationTextFieldType2(
                    labelText: 'Selecione a frequência da tarefa'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                  keyboardType: TextInputType.multiline,
                  decoration:
                  AppStyles.decorationTextField(labelText: 'Descrição'),
                  style: AppStyles.styleTextField,
                  controller: _descricaoController,
                  onSubmitted: (String descricao) {
                    //print('descricao = ' + descricao);
                  }),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: AppStyles.customPositiveButtonStyle,
                child: Text(
                  (widget.editarTarefa != null && widget.editarTarefa!)
                      ? 'Atualizar'
                      : 'Cadastrar Tarefa',
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      if (widget.editarTarefa != null && widget.editarTarefa!) {
                        if (widget.idCopiaAtualizar != -1) {
                          // Excluir tarefas futuras
                          return AlertDialog(
                            title: const Text('Esta é uma tarefa recorrente'),
                            content: const Text(
                                'Deseja atualizar somente esta ou todas as tarefas futuras também?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  _atualizaTarefa(
                                      widget.idAtualizar!, widget.createdAt!);
                                  reset();
                                  Navigator.of(context).pop('Somente esta');

                                  // Mostrar diálogo de sucesso
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Sucesso'),
                                        content: const Text(
                                            'Sua tarefa foi atualizada com sucesso!'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Fecha o AlertDialog de sucesso
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Somente esta'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _atualizaTarefa(
                                      widget.idAtualizar!, widget.createdAt!);
                                  reset();
                                  Navigator.of(context).pop('Todas as futuras');

                                  // Mostrar diálogo de sucesso
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Sucesso'),
                                        content: const Text(
                                            'Suas tarefas futuras foram atualizadas com sucesso!'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Fecha o AlertDialog de sucesso
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Todas as futuras'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Fecha o AlertDialog de confirmação
                                },
                                child: const Text('Cancelar'),
                              ),
                            ],
                          );
                        } else {
                          // Excluir somente esta tarefa
                          return AlertDialog(
                            title: const Text('Confirmação'),
                            content: const Text('Deseja alterar esta tarefa?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  _atualizaTarefa(
                                      widget.idAtualizar!, widget.createdAt!);
                                  reset();
                                  Navigator.of(context).pop('Sim');

                                  // Mostrar diálogo de sucesso
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Sucesso'),
                                        content: const Text(
                                            'Sua tarefa foi alerada com sucesso!'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Fecha o AlertDialog de sucesso
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
                                  Navigator.of(context).pop(
                                      'Não'); // Fecha o AlertDialog de confirmação com 'Não'
                                },
                                child: const Text('Não'),
                              ),
                            ],
                          );
                        }
                      } else if (_nomeController.text != '') {
                        return AlertDialog(
                          title: const Text('Sucesso'),
                          content: const Text(
                            'Sua tarefa foi cadastrada com sucesso!',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                _adicionaTarefa();
                                reset();
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      } else {
                        return AlertDialog(
                          title: const Text('Aviso'),
                          content: const Text(
                            'Preencha um nome para sua tarefa!',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                reset();
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}