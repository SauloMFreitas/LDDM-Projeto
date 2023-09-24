import 'package:flutter/material.dart';

class Lista extends StatefulWidget {
  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  List<Map<String, dynamic>> _itens = [];

  void _carregarItens() {
    for (int i = 1; i <= 10; i++) {
      Map<String, dynamic> item = Map();
      item["titulo"] = "Tarefa ${i}";
      item["descricao"] = "Descrição";
      _itens.add(item);
    }
  }

  void _excluirItem(int indice) {
    print('Item excluído = ' + _itens[indice]["titulo"]);
    setState(() {
      _itens.removeAt(indice);
    });
  }

  @override
  Widget build(BuildContext context) {
    _carregarItens();
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: _itens.length,
          itemBuilder: (context, indice) {
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                _excluirItem(indice);
              },
              background: Container(
                color: Colors.red,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              child: ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(_itens[indice]["titulo"]),
                        titleTextStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        content: Text(_itens[indice]["descricao"]),
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
                              print("Alterar " + _itens[indice]["titulo"] + " selecionado");
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
                title: Text(_itens[indice]["titulo"]),
                subtitle: Text(_itens[indice]["descricao"]),
              ),
            );
          },
        ),
      ),
    );
  }
}
