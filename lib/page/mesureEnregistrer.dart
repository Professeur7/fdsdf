import 'package:fashion2/page/pageMesure.dart';
import 'package:flutter/material.dart';

class MesuresEnregistreesListPage extends StatefulWidget {
  final List<Client> clients;

  MesuresEnregistreesListPage({required this.clients, required  mesures});

  @override
  _MesuresEnregistreesListPageState createState() =>
      _MesuresEnregistreesListPageState();
}

class _MesuresEnregistreesListPageState
    extends State<MesuresEnregistreesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mesures Enregistrées'),
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
                builder: (context) => MesuresPage(), // Remplacez PageDefault par votre widget de page par défaut
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Naviguer vers la page d'enregistrement des mesures
              // Navigator.push(context, MaterialPageRoute(builder: (context) => MesuresPage()));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.clients.length,
        itemBuilder: (context, index) {
          final client = widget.clients[index];
          return ListTile(
            leading: CircleAvatar(
              // Afficher l'image de l'habit du client ici
              backgroundImage: AssetImage('assets/client_avatar.png'), // Remplacez par l'image de l'habit du client
            ),
            title: Text('Client: ${client.nom} ${client.prenom}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${client.email}'),
                Text('Téléphone: ${client.telephone}'),
              ],
            ),
            trailing: Icon(Icons.keyboard_arrow_right), // Ajoutez une icône pour ouvrir les détails des mesures
            onTap: () {
              // Naviguer vers la page de détails des mesures du client
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MesuresDetailsPage(client: client),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MesuresDetailsPage extends StatelessWidget {
  final Client client;

  MesuresDetailsPage({required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mesures de ${client.nom} ${client.prenom}'),
        backgroundColor: const Color(0xFF3b5999),
      ),
      body: Column(
        children: [
          // Afficher l'image de l'habit du client
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('assets/client_avatar.png'), // Remplacez par l'image de l'habit du client
          ),
          // Afficher les mesures du client ici
          // Parcourez client.mesures et affichez-les sous forme de liste ou de tableau
          // Exemple : client.mesures.map((mesure) => Text('${mesure.type}: ${mesure.valeur}')).toList(),
        ],
      ),
    );
  }
}

class Client {
  final String nom;
  final String prenom;
  final String email;
  final String telephone;
  final List<Mesure> mesures;

  Client({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.mesures,
  });
}

class Mesure {
  final String type;
  final String valeur;

  Mesure({required this.type, required this.valeur});
}
