import 'package:flutter/material.dart';

class CadastrarUsuario extends StatefulWidget {
  String? nome = "";
  String? celular = "";
  String? email = "";
  String? nomePet = "";
  String? senha = "";

  CadastrarUsuario({
    this.nome,
    this.celular,  
    this.email,  
    this.nomePet,  
    this.senha,                  
  });

  @override
  _CadastrarUsuarioState createState() => _CadastrarUsuarioState();
}

class _CadastrarUsuarioState extends State<CadastrarUsuario> {
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

            Text("\nNome: " + widget.nome!,
              style: TextStyle(
                color: Colors.orange,
              ),
            ),

            Text("\nCelular: " + widget.celular!,
              style: TextStyle(
                color: Colors.orange,
              ),
            ),

            Text("\nEmail: " + widget.email!,
              style: TextStyle(
                color: Colors.orange,
              ),
            ),

            Text("\nnomePet: " + widget.nomePet!,
              style: TextStyle(
                color: Colors.orange,
              ),
            ),
            
            Text("\nSenha: " + widget.senha!,
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