import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'sql_helper.dart';
import 'dart:async';
import 'package:intl/intl.dart';

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
  List<Map<String, dynamic>> _produtos = [];
  double _valorTotal = 0.0;
  bool _estaAtualizando = true;

  void _atualizaProdutos() async {
    final data = await SQLHelper.pegaProdutos();
    setState(() {
      _produtos = data;
      _valorTotal = _total(_produtos);
      _estaAtualizando = false;
    });
  }

  double _total(List produtos) {
    double total = 0.0;
    for (var valor in produtos) {
      total += valor['qte'] * valor['valor'];
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    _atualizaProdutos();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _valorController.dispose();
    _eanController.dispose();
    _qteController.dispose();
    super.dispose();
  }

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _eanController = TextEditingController();
  final TextEditingController _qteController = TextEditingController();

  void _mostraEdicao(int? id) async {
    if (id != null) {
      final produtoExistente =
      _produtos.firstWhere((element) => element['id'] == id);
      _nomeController.text = produtoExistente['nome'];
      _valorController.text = produtoExistente['valor'].toString();
      _eanController.text = produtoExistente['ean'].toString();
      _qteController.text = produtoExistente['qte'].toString();
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
                const InputDecoration(hintText: 'Nome do Produto'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _valorController,
                decoration:
                const InputDecoration(hintText: 'Valor do Produto'),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _eanController,
                      decoration:
                      const InputDecoration(hintText: 'EAN do Produto'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.barcode_reader),
                    onPressed: () {
                      scanBarCode();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _qteController,
                decoration: const InputDecoration(
                    hintText: 'Quantidade do Produto'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await _adicionaProduto();
                  }
                  if (id != null) {
                    await _atualizaProduto(id);
                  }
                  _nomeController.text = '';
                  _valorController.text = '';
                  _eanController.text = '';
                  _qteController.text = '';
                  _atualizaProdutos();
                  if (!mounted) return;
                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'Adicionar' : 'Atualizar'),
              )
            ],
          ),
        ));
  }

  Future<void> _adicionaProduto() async {
    await SQLHelper.adicionarProduto(
        _nomeController.text,
        double.parse(_valorController.text),
        int.parse(_eanController.text),
        int.parse(_qteController.text));
    _atualizaProdutos();
  }

  Future<void> _atualizaProduto(int id) async {
    await SQLHelper.atualizaProduto(
        id,
        _nomeController.text,
        double.parse(_valorController.text),
        int.parse(_eanController.text),
        int.parse(_qteController.text));
    _atualizaProdutos();
  }

  void _apagaProduto(int id) async {
    await SQLHelper.apagaProduto(id);
    _scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
      content: Text('Produto apagado!'),
    ));
    _atualizaProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Lista de Produtos'),
            Text(brl.format(_valorTotal)),
          ],
        ),
      ),
      body: _estaAtualizando
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _produtos.length,
        itemBuilder: (context, index) => Card(
          color: Colors.orange[50],
          margin: const EdgeInsets.all(4),
          child: ListTile(
            title: Column(
              children: [
                Text("Código EAN: ${_produtos[index]['ean']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _mostraEdicao(_produtos[index]['id']),
                    ),
                    Text(_produtos[index]['nome'],
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
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _apagaProduto(_produtos[index]['id']),
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

  Future<void> scanBarCode() async {
    String resultadoBarCode="0000000000000";
    try {
      resultadoBarCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.BARCODE);

    } on PlatformException {
      resultadoBarCode = 'Erro ao pegar a versão da plataforma.';
    }
    if (!mounted) return;
    setState(() {
      _eanController.text = resultadoBarCode;
    });
  }

  double _calculaTotal(double valor, int qte) {
    double total = 0.0;
    total = valor * qte;
    return total;
  }
}
