import 'package:fashion2/firestore.dart';
import 'package:fashion2/screen/loginSignupScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fashion2/models/atelier.dart';
import 'package:fashion2/widgets/enregistrer_tailleur.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../screen/home_screen.dart';

// ignore: must_be_immutable
class AtelierRegistrationPage extends StatefulWidget {
  final Atelier? existingAtelier;
  File? selectedImage;

  AtelierRegistrationPage({Key? key, this.existingAtelier, this.selectedImage})
      : super(key: key);

  @override
  _AtelierRegistrationPageState createState() =>
      _AtelierRegistrationPageState();
}

class _AtelierRegistrationPageState extends State<AtelierRegistrationPage> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController lieuController = TextEditingController();
  final TextEditingController sloganController = TextEditingController();
  FirebaseStorage storage = FirebaseStorage.instance;
  String? imageUrl;
  File? selectedImage;

  @override
  void initState() {
    super.initState();

    // Fill in the fields with the existing atelier's data (if available)
    if (widget.existingAtelier != null) {
      nomController.text = widget.existingAtelier!.nom;
      lieuController.text = widget.existingAtelier!.lieu;
      sloganController.text = widget.existingAtelier!.slogan ?? '';
    }
  }

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
//  void pickImage(Function(File?) onImagePicked) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       onImagePicked(File(pickedFile.path));
//     }
//   }

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

  final FirebaseManagement c = Get.put(FirebaseManagement());

  @override
  Widget build(BuildContext context) {
    //final _management = Provider.of<FirebaseManagement>(context, listen: true);
    print("this is for get ${c.tailleurs.length}");
    print(
        "token tailleur ${c.tailleurs.length != 0 ? c.tailleurs.first.token : 22222222}");
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF09126C),
          title: Text("Atelier Registration"),
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
                      LoginSignupScreen(), // Remplacez PageDefault par votre widget de page par défaut
                ),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Importer votre logo'),
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
              Text("Nom de l'Atelier"),
              TextFormField(
                controller: nomController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Emplacement de l'Atelier"),
              TextFormField(
                controller: lieuController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Slogan (optionnel)"),
              TextFormField(
                controller: sloganController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Code pour enregistrer l'atelier, y compris l'image sélectionnée
                      final newAtelier = Atelier(
                        nom: nomController.text,
                        lieu: lieuController.text,
                        slogan: sloganController.text.isNotEmpty
                            ? sloganController.text
                            : null,
                        imageUrl: imageUrl != null
                            ? imageUrl // Remplacez cela par la logique réelle de téléchargement d'image vers Firebase
                            : "",
                      );
                      try {
                        if (widget.existingAtelier != null) {
                          c.createAtelier(
                              Atelier(
                                  nom: newAtelier.nom,
                                  lieu: newAtelier.lieu,
                                  slogan: newAtelier.slogan,
                                  imageUrl: newAtelier.imageUrl),
                              c.tailleurs.first.token!);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TailleurRegistrationPage(), // Remplacez "HomePage" par le nom de votre page d'accueil
                            ),
                          );
                        } else {
                          c.createAtelier(
                              Atelier(
                                  nom: newAtelier.nom,
                                  lieu: newAtelier.lieu,
                                  slogan: newAtelier.slogan,
                                  imageUrl: newAtelier.imageUrl),
                              c.tailleurs != []
                                  ? c.tailleurs.first.token!
                                  : "");
                        }

                        // Après l'enregistrement, vous pouvez afficher une confirmation à l'utilisateur
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TailleurRegistrationPage(), // Remplacez "HomePage" par le nom de votre page d'accueil
                          ),
                        );
                      } catch (e) {
                        // Gérer les erreurs ici
                        print(
                            'Erreur lors de l\'enregistrement de l\'atelier : $e');
                      }
                    },
                    icon: Icon(Icons.save),
                    label: Text("Enregistrer",
                        style: TextStyle(color: Color(0xFF09126C))),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Code de connexion
                    },
                    icon: Icon(Icons.login),
                    label: Text("Connexion",
                        style: TextStyle(color: Color(0xFF09126C))),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
