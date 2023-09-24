import 'package:flutter/material.dart';
import 'assets/AppStyles.dart';
import 'Login.dart';

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
        title: Text("Seu Cadastro"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

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

            SizedBox(height: 16.0),

            ElevatedButton(
              child: Text("Login"),
              onPressed: (){
                  Navigator.push(
                    context,
                  MaterialPageRoute(
                    builder: (context) => Login()
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