import 'package:flutter/material.dart';
import 'assets/AppStyles.dart';

class CadastrarTarefa extends StatefulWidget {
  String? categoria = "";
  String? nome = "";
  String? data = "";
  String? notificacao = "";
  String? frequencia = "";
  String? descricao = "";

  CadastrarTarefa({
    this.categoria,
    this.nome,
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
                color: Colors.black,
              ),
            ),

            Text("\nNome Tarefa: " + widget.nome!,
              style: TextStyle(
                color: Colors.black,
              ),
            ),

            Text("\n Data: " + widget.data!,
              style: TextStyle(
                color: Colors.black,
              ),
            ),

            Text("\nNotificacao: " + widget.notificacao!,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            
            Text("\nFrequencia: " + widget.frequencia!,
              style: TextStyle(
                color: Colors.black,
              ),
            ),

            Text("\nDescricao: " + widget.descricao!,
              style: TextStyle(
                color: Colors.black,
              ),
            ),

          ],
        ),
      ),
    );
  }
}