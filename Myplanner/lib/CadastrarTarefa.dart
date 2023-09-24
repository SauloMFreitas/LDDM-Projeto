import 'package:flutter/material.dart';

class CadastrarTarefa extends StatefulWidget {
  String? categoria = "";
  String? nomeTarefa = "";
  String? data = "";
  String? notificacao = "";
  String? frequencia = "";
  String? descricao = "";

  CadastrarTarefa({
    this.categoria,
    this.nomeTarefa,  
    this.data,  
    this.notificacao,  
    this.frequencia,  
    this.descricao,                  
  });

  @override
  _CadastrarTarefaState createState() => _CadastrarTarefaState();
}

class _CadastrarTarefaState extends State<CadastrarTarefa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Segunda Tela"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Você está na segunda tela",
              style: TextStyle(
                backgroundColor: Colors.green,
              ),
            ),

            Text("\nCategoria: " + widget.categoria!,
              style: TextStyle(
                color: Colors.orange,
              ),
            ),

            Text("\nNome Tarefa: " + widget.nomeTarefa!,
              style: TextStyle(
                color: Colors.orange,
              ),
            ),

            Text("\n Data: " + widget.data!,
              style: TextStyle(
                color: Colors.orange,
              ),
            ),

            Text("\nNotificacao: " + widget.notificacao!,
              style: TextStyle(
                color: Colors.orange,
              ),
            ),
            
            Text("\nFrequencia: " + widget.frequencia!,
              style: TextStyle(
                color: Colors.orange,
              ),
            ),

            Text("\nDescricao: " + widget.descricao!,
              style: TextStyle(
                color: Colors.orange,
              ),
            ),

          ],
        ),
      ),
    );
  }
}