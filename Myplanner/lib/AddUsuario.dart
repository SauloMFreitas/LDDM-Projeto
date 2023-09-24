import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'CadastrarUsuario.dart';
import 'assets/Styles.dart';

class AddUsuario extends StatefulWidget {
  @override
  _AddUsuarioState createState() => _AddUsuarioState();
}

class _AddUsuarioState extends State<AddUsuario> {

  TextEditingController _nome = TextEditingController();
  TextEditingController _celular = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _nomePet = TextEditingController();
  TextEditingController _senha = TextEditingController();
  TextEditingController _confirmacaoSenha = TextEditingController();


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

            TextField(
              keyboardType: TextInputType.name,
              decoration: Styles.decorationTextField(labelText: 'Nome'),
              style: Styles.styleTextField,
              controller: _nome,
              onSubmitted: (String _nome) {
                print('_nome = ' + _nome);
              }
            ),

            SizedBox(height: 16.0),
            
            TextField(
              keyboardType: TextInputType.phone,
              decoration: Styles.decorationTextField(labelText: 'Celular'),
              style: Styles.styleTextField,
              controller: _celular,
              onSubmitted: (String _celular) {
                print('_celular = ' + _celular);
              }
            ),

            SizedBox(height: 16.0),

            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: Styles.decorationTextField(labelText: 'E-mail'),
              style: Styles.styleTextField,
              controller: _email,
              onSubmitted: (String _email) {
                print('_email = ' + _email);
              }
            ),

            SizedBox(height: 16.0),

            TextField(
              keyboardType: TextInputType.name,
              decoration: Styles.decorationTextField(labelText: 'Nome do Pet'),
              style: Styles.styleTextField,
              controller: _nomePet,
              onSubmitted: (String _nomePet) {
                print('_nomePet = ' + _nomePet);
              }
            ),

            SizedBox(height: 16.0),

            TextField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: Styles.decorationTextField(labelText: 'Senha'),
              style: Styles.styleTextField,
              controller: _senha,
              onSubmitted: (String _senha) {
                print('_senha = ' + _senha);
              }
            ),

            SizedBox(height: 16.0),

            TextField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: Styles.decorationTextField(labelText: 'Confirme sua senha'),
              style: Styles.styleTextField,
              controller: _confirmacaoSenha,
              onSubmitted: (String _confirmacaoSenha) {
                print('_confirmacaoSenha = ' + _confirmacaoSenha);
              }
            ),

            SizedBox(height: 16.0),

            ElevatedButton(
              child: Text("Cadastrar Tarefa"),
              onPressed: (){
                if(_senha.text == _confirmacaoSenha.text) {
                  Navigator.push(
                    context,
                  MaterialPageRoute(
                    builder: (context) => CadastrarUsuario(
                                            nome: _nome.text,
                                            celular: _celular.text,
                                            email: _email.text,
                                            nomePet: _nomePet.text,
                                            senha: _senha.text,)
                  ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('As senhas não são iguais'),
                        titleTextStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        content: Text('As senhas não são iguais'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Voltar"),
                          ),
                        ],
                      );
                    },
                  );
                }
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