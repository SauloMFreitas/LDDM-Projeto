import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sql_helper.dart';
import 'dart:async';
import 'package:intl/intl.dart';
/*
final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();
final formatCurrency = NumberFormat.simpleCurrency();

final brl = NumberFormat.currency(
    locale: 'br', customPattern: 'R\$ #,###', decimalDigits: 2);

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  List<Map<String, dynamic>> _tarefas = [];
  bool _estaAtualizando = true;

  void _atualizaTarefas() async {
    final data = await SQLHelper.pegaTarefas();
    setState(() {
      _tarefas = data;
      _estaAtualizando = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _atualizaTarefas();
  }

  @override
  void dispose() {
    _categoriaController.dispose();
    _nomeController.dispose();
    _dataController.dispose();
    _notificacaoController.dispose();
    _frequenciaController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  final TextEditingController _categoriaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _notificacaoController = TextEditingController();
  final TextEditingController _frequenciaController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  void _mostraEdicao(int? id) async {
    if (id != null) {
      final tarefaExistente =
      _tarefas.firstWhere((element) => element['id'] == id);
      _categoriaController.text = tarefaExistente['categoria'];
      _nomeController.text = tarefaExistente['nome'];
      _dataController.text = tarefaExistente['data'];
      _notificacaoController.text = tarefaExistente['notificacao'];
      _frequenciaController.text = tarefaExistente['frequencia'];
      _descricaoController.text = tarefaExistente['descricao'];

    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _nomeController,
                decoration:
                const InputDecoration(hintText: 'Nome da Tarefa'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await _adicionaTarefa();
                  }
                  if (id != null) {
                    await _atualizaTarefa(id);
                  }
                  _categoriaController.text = ' ';
                  _nomeController.text = ' ';
                  _dataController.text = ' ';
                  _notificacaoController.text = ' ';
                  _frequenciaController.text = ' ';
                  _descricaoController.text = ' ';
                  _atualizaTarefas();
                  if (!mounted) return;
                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'Adicionar' : 'Atualizar'),
              )
            ],
          ),
        ));
  }

  Future<void> _adicionaTarefa() async {
    await SQLHelper.adicionarTarefa(
        _categoriaController.text,
        _nomeController.text,
        _dataController.text,
        _notificacaoController.text,
        _frequenciaController.text,
        _descricaoController.text);
    _atualizaTarefas();
  }

  Future<void> _atualizaTarefa(int id) async {
    await SQLHelper.atualizaTarefa(
        id,
        _categoriaController.text,
        _nomeController.text,
        _dataController.text,
        _notificacaoController.text,
        _frequenciaController.text,
        _descricaoController.text);
    _atualizaTarefas();
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
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Lista de Tarefas'),
          ],
        ),
      ),
      body: _estaAtualizando
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _tarefas.length,
        itemBuilder: (context, index) => Card(
          color: Colors.orange[50],
          margin: const EdgeInsets.all(4),
          child: ListTile(
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _mostraEdicao(_tarefas[index]['id']),
                    ),
                    Text(_tarefas[index]['nome'],
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )

                    ),
                  ],
                ),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /*
                Column(
                  children: [
                    const Text("Valor Unitário",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 10,
                        )),
                    Text(brl.format(_produtos[index]['valor'])
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text("Qte",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 10,
                        )),
                    Text(_produtos[index]['qte'].toString()),
                  ],
                ),
                Column(
                  children: [
                    const Text("Total do Produto",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 10,
                        )),
                    Text(brl.format(_calculaTotal(
                        _produtos[index]['valor'], _produtos[index]['qte']))),
                  ],
                ),
                 */
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _apagaTarefa(_tarefas[index]['id']),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add,
          color: Colors.black,

        ),

        onPressed: () => _mostraEdicao(null),
      ),
    );
  }

}*/
