import 'dart:io';

import 'package:fashion2/firestore.dart';
import 'package:fashion2/models/specialesPromotions.dart';
import 'package:fashion2/page/gridview/SpecialePromoTailleur.dart';
import 'package:fashion2/page/gridview/pagePromotion.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PublishSpecialPromotionPage extends StatefulWidget {
  @override
  _PublishSpecialPromotionPageState createState() =>
      _PublishSpecialPromotionPageState();
}

class _PublishSpecialPromotionPageState
    extends State<PublishSpecialPromotionPage> {
  final _formKey = GlobalKey<FormState>();
  FirebaseManagement _management = Get.put(FirebaseManagement());

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String? _imageUrl;
  File? selectedImage;
  // Use String? to handle nullable image URL
  TextEditingController _dateController = TextEditingController();
  FirebaseStorage storage = FirebaseStorage.instance;

  // Future<void> _getImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       // Set the _imageUrl with the picked image file path
  //       _imageUrl = pickedFile.path;
  //     });
  //   }
  // }
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
    _imageUrl = await uploadImage(File(pickedFile!.path), pickedFile.name);
    setState(() {
      selectedImage = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle Promotion Spéciale'),
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
                builder: (context) => NewPostPage(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.star_outline),
            onPressed: () {
              // Implémentez ici la logique pour voir les promotions spéciales
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SpecialPromotions(
                    specialPromotions: [],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir un titre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une description';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: TextEditingController(text: _imageUrl ?? ""),
                      enabled: false, // Disable text field for image URL
                      decoration: InputDecoration(labelText: 'URL de l\'image'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.photo_camera),
                    onPressed: () {
                      pickImage(); // Call the function to get the image
                    },
                  ),
                ],
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Soumettre la publication ici
                    SpecialPromotion newPromotion = SpecialPromotion(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      imageUrl: _imageUrl ?? "",
                      date: _dateController.text,
                    );
                    _management.postPublicationSpeciale(
                        newPromotion, _management.tailleurs.first.token!);
                    // Ajouter la logique pour gérer la nouvelle promotion spéciale
                    // Vous pouvez l'ajouter à votre liste existante ou la sauvegarder dans votre base de données.

                    // Réinitialiser les contrôleurs après la publication
                    _titleController.clear();
                    _descriptionController.clear();
                    _imageUrl = null; // Reset image URL
                    _dateController.clear();
                  }
                },
                child: Text('Publier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
