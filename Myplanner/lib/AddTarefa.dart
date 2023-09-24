import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'SegundaTela.dart';
import 'assets/Styles.dart';

class AddTarefa extends StatefulWidget {
  @override
  _AddTarefaState createState() => _AddTarefaState();
}

class _AddTarefaState extends State<AddTarefa> {

  List<String> arrayCategorias = ['Faculdade', 'Lazer', 'Saúde'];
  String? _categoria = 'Faculdade';

  List<String> arrayNotificacoes = ['Não notificar', '5 minutos antes', '15 minutos antes', '30 minutos antes'];
  String? _notificacao = 'Não notificar';

  List<String> arrayFrequencias = ['Não repetir', 'Diariamente', 'Semanalmente', 'Mensalmente'];
  String? _frequencia = 'Não repetir';

  DateTime _data = DateTime.now().toLocal();
  String _dataFormatada = DateFormat('dd/MM/yyyy').format(DateTime.now().toLocal());
  String _horaFormatada = DateFormat('HH:mm').format(DateTime.now().toLocal());

  TextEditingController _nomeTarefa = TextEditingController();
  TextEditingController _descricao = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Tarefas"),
        backgroundColor: Colors.deepOrange,
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
              decoration: Styles.decorationTextField(labelText: 'Selecione uma categoria'),
            ),
            SizedBox(height: 16.0),

            TextField(
              keyboardType: TextInputType.text,
              decoration: Styles.decorationTextField(labelText: 'Nome da Tarefa'),
              style: Styles.styleTextField,
              controller: _nomeTarefa,
              onSubmitted: (String _nomeTarefa) {
                print('nomeTarefa = ' + _nomeTarefa);
              }
            ),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
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
                Expanded(
                  child: TextField(
                    enabled: false,
                    keyboardType: TextInputType.text,
                    decoration: Styles.decorationTextField(labelText: '${_dataFormatada}'),
                    style: Styles.styleTextField,
                  ),
                ),
                Expanded(
                  child: TextField(
                    enabled: false,
                    keyboardType: TextInputType.text,
                    decoration: Styles.decorationTextField(labelText: '${_horaFormatada}'),
                    style: Styles.styleTextField,
                  ),
                ),
              ],
            ),

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
              decoration: Styles.decorationTextField(labelText: 'Selecione o tempo de notificação'),
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
              decoration: Styles.decorationTextField(labelText: 'Selecione a frequência da tarefa'),
            ),
            SizedBox(height: 16.0),

            TextField(
              keyboardType: TextInputType.text,
              decoration: Styles.decorationTextField(labelText: 'Descrição'),
              style: Styles.styleTextField,
              controller: _descricao,
              onSubmitted: (String _descricao) {
                print('descricao = ' + _descricao);
              }
            ),

            ElevatedButton(
              child: Text("Cadastrar Tarefa"),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SegundaTela(
                                            categoria: _categoria.toString(),
                                            nomeTarefa: _nomeTarefa.text,
                                            data: _data.toString(),
                                            notificacao: _notificacao.toString(),
                                            frequencia: _frequencia.toString(),
                                            descricao: _descricao.text)
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}




/*
              decoration: InputDecoration(
                labelText: 'Nome da Tarefa',
                hintText: 'John Doe',
                border: InputBorder.none, // Remove a borda interna do TextField
                contentPadding: EdgeInsets.all(16.0), // Espaçamento interno
                prefixIcon: Icon(Icons.person),
                suffixIcon: Icon(Icons.clear),
              ),
 */