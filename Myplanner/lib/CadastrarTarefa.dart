import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'assets/AppStyles.dart';
import 'Sobre.dart';
import 'SQLHelper.dart';
import 'Token.dart';
import 'Login.dart';

final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();
final formatCurrency = NumberFormat.simpleCurrency();

class AddTarefa extends StatefulWidget {

  DateTime? data;
  bool? editarTarefa = false;

  int? idAtualizar;

  String? categoriaAtualizar;
  String? nomeAtualizar;
  String? notificacaoAtualizar;
  String? frequenciaAtualizar;
  String? descricaoAtualizar;

  AddTarefa({
    DateTime? data,
    bool? editarTarefa,
    int? idAtualizar,
    String? categoriaAtualizar,
    String? nomeAtualizar,
    String? notificacaoAtualizar,
    String? frequenciaAtualizar,
    String? descricaoAtualizar}) {
    this.data = data ?? DateTime.now();
    this.editarTarefa = editarTarefa ?? false;

    this.idAtualizar = idAtualizar ?? -1;

    this.categoriaAtualizar = categoriaAtualizar ?? 'Faculdade';
    this.nomeAtualizar = nomeAtualizar ?? '';
    this.notificacaoAtualizar = notificacaoAtualizar ?? 'Não notificar';
    this.frequenciaAtualizar = frequenciaAtualizar ?? 'Não repetir';
    this.descricaoAtualizar = descricaoAtualizar ?? '';
  }

  @override
  _AddTarefaState createState() => _AddTarefaState();
}

class _AddTarefaState extends State<AddTarefa> {

  List<Map<String, dynamic>> _tarefas = [];

  @override
  void initState() {
    super.initState();
    _atualizaTarefas();
  }

  void reset() {
    _categoria = 'Faculdade';
    //_nomeController.text = '';
    //_descricaoController.text = '';
    //_dataFormatada = DateFormat('dd/MM/yyyy').format(DateTime.now());
    //_horaFormatada = DateFormat('HH:mm').format(DateTime.now());
    //_notificacao = 'Não notificar';
   // _frequencia = 'Não repetir';
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
      MaterialPageRoute(builder: (context) => Login()),
    );
  }



  List<String> arrayCategorias = ['Faculdade', 'Lazer', 'Saúde', 'Trabalho'];
  late String? _categoria = widget.categoriaAtualizar ?? 'Faculdade';

  List<String> arrayNotificacoes = ['Não notificar', '5 minutos antes', '15 minutos antes', '30 minutos antes'];
  late String? _notificacao = widget.notificacaoAtualizar ?? 'Não notificar';


  List<String> arrayFrequencias = ['Não repetir', 'Diariamente', 'Semanalmente', 'Mensalmente'];
  late String? _frequencia = widget.frequenciaAtualizar ?? 'Não repetir';

  late String _dataFormatada = (widget.data != null) ? DateFormat('dd/MM/yyyy').format(widget.data!) : DateFormat('dd/MM/yyyy').format(DateTime.now());
  late String _horaFormatada = (widget.data != null) ? DateFormat('HH:mm').format(widget.data!) : DateFormat('HH:mm').format(DateTime.now());

  late TextEditingController _nomeController = TextEditingController(text: widget.nomeAtualizar ?? '');
  late TextEditingController _descricaoController = TextEditingController(text: widget.descricaoAtualizar ?? '');

  bool _error = false;

  Future<void> _adicionaTarefa() async {
    if(_nomeController.text != '' && _nomeController.text != null &&
        _descricaoController.text != '' && _descricaoController.text != null ) {
      await SQLHelper.adicionarTarefa(
          _categoria!,
          _nomeController.text,
          _dataFormatada!,
          _horaFormatada!,
          _notificacao!,
          _frequencia!,
          _descricaoController.text,
          0
      );
      _atualizaTarefas();
      _error = false;
    } else {
      _error = true;
    }
  }

  Future<void> _atualizaTarefa(int id) async {
    await SQLHelper.atualizaTarefa(
        id,
        _categoria!,
        _nomeController.text,
        _dataFormatada!,
        _horaFormatada,
        _notificacao!,
        _frequencia!,
        _descricaoController.text,
        0
    );
    _atualizaTarefas();
  }

  void _atualizaTarefas() async {
    final data = await SQLHelper.getTarefas();
    setState(() {
      _tarefas = data;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            DropdownButtonFormField(
              value: _categoria,

              onChanged: (novaCategoria) {
                setState(() {
                  _categoria = novaCategoria.toString();
                  print('Categoria selecionada: $_categoria');
                });
              },
              items: arrayCategorias.map((categoria) {
                return DropdownMenuItem(
                  value: categoria,
                  child: Text(categoria),
                );
              }).toList(),
              decoration: AppStyles.decorationTextFieldType2(labelText: 'Selecione uma categoria'),
            ),
            SizedBox(height: 16.0),

            TextField(
              keyboardType: TextInputType.text,
              decoration: AppStyles.decorationTextField(labelText: 'Nome da Tarefa'),
              style: AppStyles.styleTextField,
              controller: _nomeController,
              onSubmitted: (String _nome) {
                print('nome = ' + _nome);
              }
            ),

            SizedBox(height: 16.0),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyles.positiveButton,
                          ),
                          child: Text('Selecione a data e o horário da tarefa'),
                          onPressed: () async {
                            print("data: ${widget.data!}");
                            DateTime? novaData = await showDatePicker(
                              context: context,
                              initialDate: widget.data!,
                              firstDate: DateTime.now().toLocal(),
                              lastDate: DateTime(2200),
                            );

                            if (novaData != null) {

                              setState(() {
                                widget.data = novaData!;
                                _dataFormatada = DateFormat('dd/MM/yyyy').format(widget.data!);
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
                                  _horaFormatada = DateFormat('HH:mm').format(widget.data!);
                                });
                              }
                            }

                            print('data = ' + widget.data!.toString());
                          },
                        ),
                ),

                SizedBox(width: 16.0),

                Expanded(
                  child: TextField(
                    enabled: false,
                    keyboardType: TextInputType.none,
                    decoration: AppStyles.decorationTextField(labelText: '${_dataFormatada}'),
                    style: AppStyles.styleTextField,
                  ),
                ),

                SizedBox(width: 16.0),

                Expanded(
                  child: TextField(
                    enabled: false,
                    keyboardType: TextInputType.none,
                    decoration: AppStyles.decorationTextField(labelText: '${_horaFormatada}'),
                    style: AppStyles.styleTextField,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.0),

            DropdownButtonFormField(
              value: _notificacao,

              onChanged: (novaNotificacao) {
                setState(() {
                  _notificacao = novaNotificacao.toString();
                  print('Notificação selecionada: $_notificacao');
                });
              },
              items: arrayNotificacoes.map((notificacao) {
                return DropdownMenuItem(
                  value: notificacao,
                  child: Text(notificacao),
                );
              }).toList(),
              decoration: AppStyles.decorationTextFieldType2(labelText: 'Selecione o tempo de notificação'),
            ),
            SizedBox(height: 16.0),

            DropdownButtonFormField(
              value: _frequencia,

              onChanged: (novaFrequencia) {
                setState(() {
                  _frequencia = novaFrequencia.toString();
                  print('Frequência selecionada: $_frequencia');
                });
              },
              items: arrayFrequencias.map((frequencia) {
                return DropdownMenuItem(
                  value: frequencia,
                  child: Text(frequencia),
                );
              }).toList(),
              decoration: AppStyles.decorationTextFieldType2(labelText: 'Selecione a frequência da tarefa'),
            ),
            SizedBox(height: 16.0),

            TextField(
              keyboardType: TextInputType.multiline,
              decoration: AppStyles.decorationTextField(labelText: 'Descrição'),
              style: AppStyles.styleTextField,
              controller: _descricaoController,
              onSubmitted: (String _descricao) {
                print('descricao = ' + _descricao);
              }
            ),

            SizedBox(height: 16.0),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.positiveButton,
              ),
              child: Text(
                (widget.editarTarefa != null && widget.editarTarefa!)
                    ? 'Atualizar'
                    : 'Cadastrar Tarefa',
              ),
              onPressed: () async {
                //_checkTokenValidity();
                if (widget.editarTarefa != null && widget.editarTarefa!) {
                  await _atualizaTarefa(widget.idAtualizar!);
                } else {
                  await _adicionaTarefa();
                }
                _atualizaTarefas();

                if(!_error) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Sucesso'),
                        content: Text(
                          (widget.editarTarefa != null && widget.editarTarefa!)
                              ? 'Sua tarefa foi atualizada com sucesso!'
                              : 'Sua tarefa foi cadastrada com sucesso!',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              reset();
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              }
          ),
          ],
        ),
      ),
      ),
    );
  }
}
