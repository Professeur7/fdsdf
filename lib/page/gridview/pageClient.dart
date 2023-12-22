import 'package:fashion2/firestore.dart';
import 'package:fashion2/models/mesClients.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/client.dart';
import 'package:get/get.dart';

import '../../screen/home_screen.dart';

class ClientsScreen extends StatefulWidget {
  @override
  _ClientsScreenState createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final List<Client> clients = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Méthode pour ajouter un client par défaut
  final FirebaseManagement c = Get.put(FirebaseManagement());

  @override
  void initState() {
    super.initState();
    // Ajoutez le client par défaut lors de l'initialisation de l'écran
    c.getMesClient(c.tailleurs.first.token!);
  }

  // Boolean pour afficher ou masquer le formulaire d'ajout de client
  bool showAddClientForm = false;

  // Controllers pour les champs du formulaire d'ajout de client
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController trancheAgeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vos Clients'),
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
                builder: (context) =>
                    HomeScreen(), // Remplacez PageDefault par votre widget de page par défaut
              ),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: c.mesClients.length,
        itemBuilder: (context, index) {
          final client = c.mesClients[index];
          return ListTile(
            leading: Icon(Icons.person),
            title: c.mesClients.length == 0
                ? Text("data")
                : Text('${client.prenom} ${client.nom}'),
            subtitle: c.mesClients.length == 0
                ? Text("data")
                : Text(client.telephone!),
            trailing: IconButton(
              icon: Icon(Icons.show_chart),
              onPressed: () {
                // Affichez les mesures du client ou ajoutez les mesures ici.
                // Vous pouvez utiliser une nouvelle page ou un dialogue pour cela.
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF09126C),
        onPressed: () {
          showAdaptiveDialog(
              context: context, builder: (context) => AddClientForm());
        },
        child: Icon(showAddClientForm ? Icons.close : Icons.person_add),
      ),
      // Affichez le formulaire d'ajout de client lorsque showAddClientForm est vrai, sinon, affichez null
      //bottomSheet: showAddClientForm ? AddClientForm() : null,
    );
  }
}

class ClientDetailsScreen extends StatelessWidget {
  MesClients client;
  ClientDetailsScreen({required this.client});
  final FirebaseManagement c = Get.put(FirebaseManagement());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Client'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Nom Complet'),
            subtitle: Text('${client.prenom} ${client.nom}'),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text('Téléphone'),
            subtitle: Text(client.telephone!),
            leading: Icon(Icons.phone),
            trailing: IconButton(
              icon: Icon(Icons.call),
              onPressed: () {
                // Ajoutez ici la logique pour appeler le client
              },
            ),
          ),
          ListTile(
            title: Text('Email'),
            subtitle: Text(client.email!),
            leading: Icon(Icons.email),
          ),
          ListTile(
            title: Text('Genre'),
            subtitle: Text(client.genre!),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text('Tranche d\'âge'),
            subtitle: Text(client.trancheAge!),
            leading: Icon(Icons.access_time),
          ),
        ],
      ),
    );
  }
}

class AddClientForm extends StatefulWidget {
  @override
  _AddClientFormState createState() => _AddClientFormState();
}

class _AddClientFormState extends State<AddClientForm> {
  // Controllers pour les champs du formulaire d'ajout de client
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController trancheAgeController = TextEditingController();
  final FirebaseManagement c = Get.put(FirebaseManagement());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajouter un Client'),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // Largeur du dialogue
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomController,
                decoration: InputDecoration(labelText: 'Nom'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: prenomController,
                decoration: InputDecoration(labelText: 'Prénom'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: telephoneController,
                decoration: InputDecoration(labelText: 'Téléphone'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: genreController,
                decoration: InputDecoration(labelText: 'Genre'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: trancheAgeController,
                decoration: InputDecoration(labelText: 'Tranche d\'âge'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final newClient = MesClients(
              nom: nomController.text,
              prenom: prenomController.text,
              telephone: telephoneController.text,
              email: emailController.text,
              genre: genreController.text,
              trancheAge: trancheAgeController.text,
            );
            // Ajouter le client
            setState(() {
              c.creerMesClients(newClient, c.tailleurs.first.token!);
              Navigator.of(context).pop();
            });
          },
          child: Text('Ajouter Client'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fermer le dialogue
          },
          child: Text('Annuler'),
        ),
      ],
    );
  }
}

/*
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

 */
