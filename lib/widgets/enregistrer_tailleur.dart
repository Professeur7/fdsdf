import 'package:fashion2/screen/home_screen.dart';
import 'package:fashion2/widgets/atelierRegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/atelier.dart';
import 'package:fashion2/models/tailleurs.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class TailleurRegistrationPage extends StatefulWidget {
  @override
  _TailleurRegistrationPageState createState() =>
      _TailleurRegistrationPageState();
}

class _TailleurRegistrationPageState extends State<TailleurRegistrationPage> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController atelierController = TextEditingController();
  File? selectedImage;

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

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
        backgroundColor: const Color(0xFF09126C),
        title: Text('Enregistrement Tailleur'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AtelierRegistrationPage(), // Remplacez PageDefault par votre widget de page par défaut
              ),
            );
          },
        ),
      ),
      body: Consumer<Tailleurs>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Importer votre photo de profil'),
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
                  SizedBox(height: 20),
                  Text('Nom'),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                      controller: nomController,
                      decoration: InputDecoration(labelText: value.nom ?? ""),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Prénom'),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                        controller: prenomController,
                        decoration:
                            InputDecoration(labelText: value.prenom ?? "")),
                  ),
                  SizedBox(height: 20),
                  Text('Téléphone'),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                        controller: telephoneController,
                        decoration:
                            InputDecoration(labelText: value.telephone ?? "")),
                  ),
                  SizedBox(height: 20),
                  Text('Email'),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                        controller: emailController,
                        decoration:
                            InputDecoration(labelText: value.email ?? "")),
                  ),
                  SizedBox(height: 20),
                  Text('Genre'),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                        controller: genreController,
                        decoration: InputDecoration(labelText: value.genre)),
                  ),
                  SizedBox(height: 20),
                  Text('Code'),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                        controller: codeController,
                        decoration: InputDecoration(labelText: value.password)),
                  ),
                  SizedBox(height: 20),
                  Text('Atelier'),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                        controller: atelierController,
                        decoration: InputDecoration(
                            labelText: value.atelier == null
                                ? ""
                                : value.atelier!.nom)),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(), // Remplacez "HomePage" par le nom de votre page d'accueil
                          ),
                        );
                        // ... (votre code existant) ...
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(25), // Bordure du bouton
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_forward,
                                size: 30), // Icône de flèche
                            SizedBox(
                                width:
                                    10), // Espacement entre l'icône et le texte
                            Text('Enregistrer'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
