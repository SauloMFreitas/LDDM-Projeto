import 'package:flutter/material.dart';

class Lista extends StatelessWidget {



  List _itens = [];

  void _carregarItens(){
    _itens = [];
    for(int i=0; i<=10; i++){
      Map<String, dynamic> item = Map();
      item["titulo"] = "Titulo ${i} da lista";
      item["descricao"]="Descrição ${i} da lista";
      _itens.add(item);
    }
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
              //print("item ${indice}");
              //Map<String, dynamic> item =_itens[indice];
              //print("item ${_itens[indice]["titulo"]}");
              return ListTile(
                onTap: (){
                  //print("Clique com onTap ${indice}");
                  showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text(_itens[indice]["titulo"]),
                          titleTextStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            backgroundColor: Colors.yellow,
                          ),
                          content: Text(_itens[indice]["descricao"]),
                          actions: <Widget>[ //definir widgets
                            TextButton(
                                onPressed: (){
                                  _itens.remove(indice);
                                  print(_itens[indice]["titulo"] + " excluido");
                                  Navigator.pop(context);

                                },
                                child: Text("excluir")
                            ),
                            TextButton(
                                onPressed: (){
                                  print("Alterar "+_itens[indice]["titulo"]+"selecionado");
                                  Navigator.pop(context);
                                },
                                child: Text("alterar Item")
                            ),
                          ],
                        );
                      }
                  );
                },
                onLongPress: (){
                  //print("Clique com onLongPress ${indice}");
                },
                title: Text(_itens[indice]["titulo"]),
                subtitle: Text(_itens[indice]["descricao"]),
              );
            }
        ),
      ),
    );
  }
}