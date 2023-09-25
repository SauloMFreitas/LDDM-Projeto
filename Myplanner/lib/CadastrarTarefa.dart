import 'package:flutter/material.dart';
import 'assets/AppStyles.dart';

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
        title: Text("Tarefa Cadastrada"),
        backgroundColor: AppStyles.highlightColor,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[

            Text("\nCategoria: " + widget.categoria!,
              style: TextStyle(
                color: Colors.white,
              ),
            ),

            Text("\nNome Tarefa: " + widget.nomeTarefa!,
              style: TextStyle(
                color: Colors.white,
              ),
            ),

            Text("\n Data: " + widget.data!,
              style: TextStyle(
                color: Colors.white,
              ),
            ),

            Text("\nNotificacao: " + widget.notificacao!,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            
            Text("\nFrequencia: " + widget.frequencia!,
              style: TextStyle(
                color: Colors.white,
              ),
            ),

            Text("\nDescricao: " + widget.descricao!,
              style: TextStyle(
                color: Colors.white,
              ),
            ),

          ],
        ),
      ),
    );
  }
}