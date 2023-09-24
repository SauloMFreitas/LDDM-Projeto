import 'package:flutter/material.dart';
import 'assets/AppStyles.dart';

class Lista extends StatefulWidget {

  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {

  List<Map<String, dynamic>> _itens = [];

  void _carregarItens() {

    if(_itens.length == 0) {
      for (int i = 1; i <= 10; i++) {
        Map<String, dynamic> item = Map();
        item["titulo"] = "Tarefa ${i}";
        item["descricao"] = "Descrição";
        _itens.add(item);
      }
    }
  }

  void _excluirItem(int indice) {
    print('Item excluído = ' + _itens[indice]["titulo"]);
    setState(() {
      _itens.removeAt(indice);
    });
  }

  Widget build(BuildContext context) {
    _carregarItens();
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Tarefas'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: _itens.length,
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
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(_itens[indice]["titulo"]),
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

/**

 */