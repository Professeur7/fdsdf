import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../screen/home_screen.dart';
import 'mesureEnregistrer.dart';

class MesuresPage extends StatefulWidget {
  @override
  _MesuresPageState createState() => _MesuresPageState();
}

class _MesuresPageState extends State<MesuresPage> {
  List<Mesure> mesures = [];
  TextEditingController valeurController = TextEditingController();
  String? selectedTypeDeMesure;
  File? selectedImage1;
  File? selectedImage2;
  final _formKey = GlobalKey<FormState>();

  List<String> typesDeMesure = [
    'Tour de poitrine',
    'Tour de taille',
    'Tour de dos',
    'Tour de hanche',
    'Longueur des manches',
    'Largeur des épaules',
    'Longueur des jambes',
    'Hauteur entrejambe',
    'Longueur d\'ourlet',
    'Tour de bras',
    'Tour de poignet',
    'Hauteur totale',
    'Tour de cou',
  ];

  List<Pair<File?, String>> imagesWithDescriptions = [];
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3b5999),
        title: Text('Prise de Mesures'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MesuresEnregistreesListPage(mesures: mesures, clients: [],),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text('Habit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.grey,
                  ),
                  child: selectedImage1 != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.file(
                      selectedImage1!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Icon(
                    Icons.add_a_photo,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description de la mesure (Habit)'),
                ),
                SizedBox(height: 16),
                Text('Modèle', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.grey,
                  ),
                  child: selectedImage2 != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.file(
                      selectedImage2!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Icon(
                    Icons.add_a_photo,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description de la mesure (Modèle)'),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedTypeDeMesure,
                  items: typesDeMesure.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTypeDeMesure = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez sélectionner un type de mesure';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: valeurController,
                  decoration: InputDecoration(labelText: 'Valeur de la mesure'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez saisir une valeur';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      mesures.add(Mesure(
                        type: selectedTypeDeMesure!,
                        valeur: valeurController.text,
                      ));
                      valeurController.clear();
                      selectedTypeDeMesure = null;
                      setState(() {});
                    }
                  },
                  child: Text('Enregistrer la mesure'),
                ),
                if (mesures.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: mesures.map((mesure) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 2.0,
                        child: ListTile(
                          title: Text('Type de Mesure: ${mesure.type}'),
                          subtitle: Text('Valeur de la Mesure: ${mesure.valeur}'),
                        ),
                      );
                    }).toList(),
                  ),
                if (imagesWithDescriptions.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: imagesWithDescriptions.map((pair) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 2.0,
                        child: ListTile(
                          title: Text('Description: ${pair.second}'),
                          subtitle: Image.file(pair.first!),
                        ),
                      );
                    }).toList(),
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedImage1 != null && selectedImage2 != null) {
                      // Ajoutez ici la logique pour associer les images avec les mesures
                      // par exemple, envoyez les images et les mesures à votre base de données
                    }
                  },
                  child: Text('Enregistrer avec les images'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Mesure {
  final String type;
  final String valeur;

  Mesure({required this.type, required this.valeur});
}

class Pair<T, U> {
  final T first;
  final U second;

  Pair(this.first, this.second);
}
