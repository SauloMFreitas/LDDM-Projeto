import 'package:flutter/material.dart';
import 'Sobre.dart';
import 'Login.dart';
import 'AddUsuario.dart';
import 'assets/AppStyles.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Perfil"),
        backgroundColor: Colors.blue,
              centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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

                SizedBox(height: 16.0),

                ElevatedButton(
                  child: Text("Cadastrar"),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddUsuario()
                      ),
                    );
                  }
                ),

                SizedBox(height: 16.0),

                ElevatedButton(
                  child: Text("Sobre Nós"),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Sobre()
                      ),
                    );
                  }
                ),
              ],
            )
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