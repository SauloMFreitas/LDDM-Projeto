import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'Sobre.dart';
import 'assets/AppStyles.dart';


class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  File? _image;
  final picker = ImagePicker();
  String userName = "Seu Nome";
  String userEmail = "seu.email@example.com";
  String petName = "Nome do Pet";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Perfil'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Sobre(),
                ),
              );
            },
          ),
        ],
        backgroundColor: AppStyles.highlightColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _pickImage();
                },
                child: Center( // Centraliza a imagem de perfil
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : AssetImage('assets/user_avatar.jpg') as ImageProvider,
                  ),
              ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  _pickImage();
                },
                child: Text('Trocar Imagem de Perfil'),
              ),
              SizedBox(height: 20),
              buildInfoRow("Nome", userName),
              buildInfoRow("Email", userEmail),
              buildInfoRow("Nome do Pet", petName),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.positiveButton, // Cor do botão de ação positiva
                ),
                onPressed: () {
                  // Navegar para a tela de atualização de perfil
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdatePerfil(
                        oldName: userName,
                        oldEmail: userEmail,
                        oldPetName: petName,
                      ),
                    ),
                  );
                },
                child: Text('Atualizar Informações'),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Widget buildInfoRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10.0), // Adicione o Padding aqui
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}

}

class UpdatePerfil extends StatefulWidget {
  final String oldName;
  final String oldEmail;
  final String oldPetName;

  UpdatePerfil({required this.oldName, required this.oldEmail, required this.oldPetName});

  @override
  _UpdatePerfilState createState() => _UpdatePerfilState();
}

class _UpdatePerfilState extends State<UpdatePerfil> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController petNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.oldName;
    emailController.text = widget.oldEmail;
    petNameController.text = widget.oldPetName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyles.highlightColor,
        title: Text('Atualizar Perfil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Sobre(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: confirmEmailController,
              decoration: InputDecoration(labelText: 'Confirme o Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirme a Senha'),
              obscureText: true,
            ),
            TextField(
              controller: petNameController,
              decoration: InputDecoration(labelText: 'Nome do Pet'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.positiveButton, // Cor do botão de ação positiva
                    ),
                  onPressed: () {
                    // Lógica para atualizar as informações no backend
                    // ...

                    Navigator.pop(context);
                  },
                  child: Text('Salvar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.negativeButton,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
