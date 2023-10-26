import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'CadastrarTarefa.dart';
import 'Sobre.dart';
import 'assets/AppStyles.dart';
import 'package:flutter/services.dart';
import 'sql_helper.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();
final formatCurrency = NumberFormat.simpleCurrency();

class AddTarefa extends StatefulWidget {
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
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  List<String> arrayCategorias = ['Faculdade', 'Lazer', 'Saúde', 'Trabalho'];
  String? _categoria = 'Faculdade';

  List<String> arrayNotificacoes = ['Não notificar', '5 minutos antes', '15 minutos antes', '30 minutos antes'];
  String? _notificacao = 'Não notificar';

  List<String> arrayFrequencias = ['Não repetir', 'Diariamente', 'Semanalmente', 'Mensalmente'];
  String? _frequencia = 'Não repetir';

  DateTime _data = DateTime.now().toLocal();
  String _dataFormatada = DateFormat('dd/MM/yyyy').format(DateTime.now().toLocal());
  String _horaFormatada = DateFormat('HH:mm').format(DateTime.now().toLocal());

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  Future<void> _adicionaTarefa() async {
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

  void _apagaTarefa(int id) async {
    await SQLHelper.apagaTarefa(id);
    _scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
      content: Text('Tarefa apagada!'),
    ));
    _atualizaTarefas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Tarefa'),
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
                            DateTime? novaData = await showDatePicker(
                              context: context,
                              initialDate: _data,
                              firstDate: DateTime.now().toLocal(),
                              lastDate: DateTime(2200),
                            );

                            if (novaData != null) {

                              setState(() {
                                _data = novaData!;
                                _dataFormatada = DateFormat('dd/MM/yyyy').format(_data);
                              });

                              TimeOfDay? novoHorario = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(_data),
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
                                  _data = novaData!;
                                  _horaFormatada = DateFormat('HH:mm').format(_data);
                                });
                              }
                            }

                            print('data = ' + _data.toString());
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
              child: Text("Cadastrar Tarefa"),
              onPressed: () async {
                await _adicionaTarefa();
                _atualizaTarefas();
              }
            ),
          ],
        ),
      ),
    );
  }
}