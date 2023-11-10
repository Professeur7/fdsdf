import 'package:fashion2/firestore.dart';
import 'package:fashion2/screen/loginSignupScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/atelier.dart';
import 'package:fashion2/widgets/enregistrer_tailleur.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../screen/home_screen.dart';

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

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        widget.selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //final _management = Provider.of<FirebaseManagement>(context, listen: true);

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
      body: Consumer<FirebaseManagement>(
        builder: (context, value, child) {
          print(
              "${value.tailleurs.length} la taiile de tailleurs dans ateliers registrations page");
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: widget.selectedImage != null
                          ? ClipOval(
                              child: Image.file(
                                widget.selectedImage!,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.add_a_photo,
                              size: 50, // Réduire la taille de l'icône
                              color: Colors.white,
                            ),
                    ),
                    Positioned(
                      bottom: -3,
                      child: Text(
                        "Importer votre logo",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: pickImage,
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
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
                          imageUrl: widget.selectedImage != null
                              ? 'chemin_de_l_image' // Remplacez cela par la logique réelle de téléchargement d'image vers Firebase
                              : null,
                        );

                        try {
                          final ateliersCollection =
                              FirebaseFirestore.instance.collection('ateliers');
                          if (widget.existingAtelier != null) {
                            // await ateliersCollection
                            //     .doc(widget.existingAtelier!.token)
                            //     .set({
                            //   'nom': newAtelier.nom,
                            //   'lieu': newAtelier.lieu,
                            //   'slogan': newAtelier.slogan,
                            //   'imageUrl': newAtelier.imageUrl,
                            //   // ... autres champs si nécessaire
                            // });
                            value.createAtelier(
                                Atelier(
                                    nom: newAtelier.nom,
                                    lieu: newAtelier.lieu,
                                    slogan: newAtelier.slogan,
                                    imageUrl: newAtelier.imageUrl),
                                value.tailleurs.first.token!);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TailleurRegistrationPage(), // Remplacez "HomePage" par le nom de votre page d'accueil
                              ),
                            );
                          } else {
                            // await ateliersCollection.add({
                            //   'nom': newAtelier.nom,
                            //   'lieu': newAtelier.lieu,
                            //   'slogan': newAtelier.slogan,
                            //   'imageUrl': newAtelier.imageUrl,
                            //   // ... autres champs si nécessaire
                            // });
                            value.createAtelier(
                                Atelier(
                                    nom: newAtelier.nom,
                                    lieu: newAtelier.lieu,
                                    slogan: newAtelier.slogan,
                                    imageUrl: newAtelier.imageUrl),
                                value.tailleurs.first.token!);
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
          );
        },
      ),
    );
  }
}
