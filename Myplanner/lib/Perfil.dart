import 'package:flutter/material.dart';
import 'Login.dart';
import 'CadastrarUsuario.dart';
import 'assets/Styles.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Tarefas"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[

            ElevatedButton(
              child: Text("Logar"),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login()
                  ),
                );
              }
            ),

            ElevatedButton(
              child: Text("Cadastrar"),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastrarUsuario()
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




/*
              decoration: InputDecoration(
                labelText: 'Nome da Tarefa',
                hintText: 'John Doe',
                border: InputBorder.none, // Remove a borda interna do TextField
                contentPadding: EdgeInsets.all(16.0), // Espaçamento interno
                prefixIcon: Icon(Icons.person),
                suffixIcon: Icon(Icons.clear),
              ),
 */