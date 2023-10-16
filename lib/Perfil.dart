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
        title: const Text("Meu Perfil"),
        backgroundColor: AppStyles.highlightColor,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Logar"),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login()
                      ),
                    );
                  }
                ),

                const SizedBox(height: 16.0),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Cadastrar"),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddUsuario()
                      ),
                    );
                  }
                ),

                const SizedBox(height: 16.0),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Sobre Nós"),
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