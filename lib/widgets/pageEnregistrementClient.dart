import 'dart:io';

import 'package:fashion2/firestore.dart';
import 'package:fashion2/screen/clientHomeScreen.dart';
import 'package:fashion2/screen/introductionScreen.dart';
import 'package:fashion2/screen/loginSignupScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fashion2/models/models.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/client.dart';
import '../screen/home_screen.dart'; // Importez vos modèles ici

class ClientRegistrationPage extends StatefulWidget {
  @override
  _ClientRegistrationPageState createState() => _ClientRegistrationPageState();
}

class _ClientRegistrationPageState extends State<ClientRegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _nomController = TextEditingController();
  TextEditingController _prenomController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _genreController = TextEditingController();
  TextEditingController _trancheAgeController = TextEditingController();
  TextEditingController _telephoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  File? selectedImage;
  FirebaseStorage storage = FirebaseStorage.instance;
  String? imageURL;
  FirebaseManagement _management = Get.put(FirebaseManagement());

  Future<String?> uploadImage(File imageFile, String fileName) async {
    try {
      Reference ref = storage.ref().child('images/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask;

      String imageURL = await taskSnapshot.ref.getDownloadURL();

      return imageURL;
    } catch (e) {
      print('Erreur lors du chargement de l\'image : $e');
      return null;
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    imageURL = await uploadImage(File(pickedFile!.path), pickedFile.name);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription Client'),
        backgroundColor: const Color(0xFF09126C),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginSignupScreen(),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('                          Importer votre photo de profil'),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    child: selectedImage != null
                        ? CircleAvatar(
                            radius: 48,
                            backgroundImage: FileImage(selectedImage!),
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.add_a_photo,
                              size: 30, // Réduire la taille de l'icône
                              color: Colors.grey,
                            ),
                            onPressed: pickImage,
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: pickImage,
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ce champ est obligatoire';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _prenomController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Entrez une adresse e-mail valide';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _genreController,
                decoration: InputDecoration(
                  labelText: 'Genre',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _trancheAgeController,
                decoration: InputDecoration(
                  labelText: 'Tranche d\'âge',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _telephoneController,
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Créez une instance de Client avec les données du formulaire
                    final client = Client(
                      username: _usernameController.text,
                      nom: _nomController.text,
                      prenom: _prenomController.text,
                      email: _emailController.text,
                      genre: _genreController.text,
                      trancheAge: _trancheAgeController.text,
                      telephone: _telephoneController.text,
                      password: _passwordController.text,
                      imageURL: imageURL != null ? imageURL : "",
                    );

                    _management.updateClientInformation(
                        client, _management.clients.first.token);
                    setState(() {
                      _management.clients.first = client;
                    });
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FirstTimeUserIntroduction()));
                  }
                },
                child: Text('S\'inscrire'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
