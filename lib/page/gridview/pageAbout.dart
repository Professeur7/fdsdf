import 'package:flutter/material.dart';

import '../../screen/home_screen.dart';


class CustomerInformationPage extends StatefulWidget {
  @override
  _CustomerInformationPageState createState() =>
      _CustomerInformationPageState();
}

class _CustomerInformationPageState extends State<CustomerInformationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String customerName = "";
  double measurements = 0.0;
  String preferences = "";
  String contactInfo = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion des Informations Clients"),
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
                builder: (context) => HomeScreen(), // Remplacez PageDefault par votre widget de page par défaut
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom du Client'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est requis';
                  }
                  return null;
                },
                onSaved: (value) {
                  customerName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mesures du Client'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est requis';
                  }
                  return null;
                },
                onSaved: (value) {
                  measurements = double.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Préférences du Client'),
                onSaved: (value) {
                  preferences = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Coordonnées du Client'),
                onSaved: (value) {
                  contactInfo = value!;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Enregistrez les informations du client dans votre base de données ou gérez-les de la manière souhaitée.
                  }
                },
                child: Text("Enregistrer Informations du Client"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
