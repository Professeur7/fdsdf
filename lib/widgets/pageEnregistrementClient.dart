import 'package:fashion2/screen/clientHomeScreen.dart';
import 'package:fashion2/screen/introductionScreen.dart';
import 'package:flutter/material.dart';
import 'package:fashion2/models/models.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription Client'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
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
              TextFormField(
                controller: _genreController,
                decoration: InputDecoration(
                  labelText: 'Genre',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
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
              TextFormField(
                controller: _telephoneController,
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
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
                    );

                    // Enregistrez le client dans la base de données
                    // (vous devrez implémenter cette logique en fonction de votre base de données)
                    // Par exemple : client.saveToFirestore();

                    // Affichez un message de succès ou redirigez l'utilisateur vers une autre page
                    // après l'inscription réussie.
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => FirstTimeUserIntroduction())
                    );
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
