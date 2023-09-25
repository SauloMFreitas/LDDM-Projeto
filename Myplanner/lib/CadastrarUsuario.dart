import 'package:flutter/material.dart';
import 'assets/AppStyles.dart';
import 'Login.dart';
import 'Sobre.dart';

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
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            
            ElevatedButton(
              child: Text("Sobre"),
              onPressed: (){
                  Navigator.push(
                    context,
                  MaterialPageRoute(
                    builder: (context) => Sobre()
                  ),
                  );
              }
            ),
            
           SizedBox(height: 16.0),

            TextField(
                enabled: false,
                keyboardType: TextInputType.none,
                decoration: AppStyles.decorationTextField(labelText: "Nome: ${widget.nome!}"),
                style: AppStyles.styleTextField,
            ),

           SizedBox(height: 16.0),

            TextField(
                enabled: false,
                keyboardType: TextInputType.none,
                decoration: AppStyles.decorationTextField(labelText: "Celular: ${widget.celular!}"),
                style: AppStyles.styleTextField,
            ),

           SizedBox(height: 16.0),

            TextField(
                enabled: false,
                keyboardType: TextInputType.none,
                decoration: AppStyles.decorationTextField(labelText: "E-mail: ${widget.email!}"),
                style: AppStyles.styleTextField,
            ),

            SizedBox(height: 16.0),

            TextField(
              enabled: false,
              keyboardType: TextInputType.none,
              decoration: AppStyles.decorationTextField(labelText: "Nome Pet: ${widget.nomePet!}"),
              style: AppStyles.styleTextField,
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