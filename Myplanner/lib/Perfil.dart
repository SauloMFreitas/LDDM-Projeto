import 'package:flutter/material.dart';
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
        backgroundColor: AppStyles.highlightColor,
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
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
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
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
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