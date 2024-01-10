import 'package:fashion2/firestore.dart';
import 'package:fashion2/models/tailleurs.dart';
import 'package:fashion2/screen/home_screen.dart';
import 'package:fashion2/widgets/atelierRegisterScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  FirebaseStorage storage = FirebaseStorage.instance;
  String? imageUrl;

  Future<String?> uploadImage(File imageFile, String fileName) async {
    try {
      Reference ref = storage.ref().child('images/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask;

      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Erreur lors du chargement de l\'image : $e');
      return null;
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    imageUrl = await uploadImage(File(pickedFile!.path), pickedFile.name);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  FirebaseManagement _management = Get.put(FirebaseManagement());

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
        body: SingleChildScrollView(
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
                      width: 150,
                      height: 150,
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
                    //decoration: InputDecoration(labelText: value.nom ?? ""),
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
                  ),
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
                  ),
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
                  ),
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
                  ),
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
                  ),
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
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Tailleurs newTailleuirs = Tailleurs(
                          password: codeController.text,
                          image: imageUrl ?? "",
                          nom: nomController.text,
                          token: _management.tailleurs.first.token,
                          username: _management.tailleurs.first.username,
                          email: emailController.text,
                          genre: genreController.text,
                          prenom: prenomController.text,
                          telephone: telephoneController.text);
                      _management.updateTailleurInformation(newTailleuirs);
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
        ));
  }
}
