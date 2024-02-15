import 'package:fashion2/page/searchClient.dart';
import 'package:flutter/material.dart';
import 'package:fashion2/models/tailleurs.dart';

class TailleurDetailsPage extends StatelessWidget {
  final Tailleurs tailleur;

  TailleurDetailsPage({required this.tailleur});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF09126C),
        //title: Text('Paramètres'),
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
                    SearchPageClient(), // Remplacez PageDefault par votre widget de page par défaut
              ),
            );
          },
        ),
        title: Text('${tailleur.nom} ${tailleur.prenom}'),
        actions: [
          // Afficher l'image de profil dans le coin supérieur droit de la barre d'applications
          if (tailleur.image != null && tailleur.image!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(tailleur.image!),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (tailleur.atelier != null &&
                tailleur.atelier!.isNotEmpty &&
                tailleur.atelier![0].imageUrl != null &&
                tailleur.atelier![0].imageUrl!.isNotEmpty)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(tailleur.atelier![0].imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations personnelles',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .blue, // Changer la couleur selon vos préférences
                        ),
                      ),
                      Divider(height: 20, thickness: 2, color: Colors.blue),
                      buildInfoRow('Nom', '${tailleur.nom} ${tailleur.prenom}'),
                      buildInfoRow('Email', tailleur.email),
                      buildInfoRow('Téléphone', tailleur.telephone ?? ""),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Atelier',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .blue, // Changer la couleur selon vos préférences
                        ),
                      ),
                      Divider(height: 20, thickness: 2, color: Colors.blue),
                      if (tailleur.atelier != null &&
                          tailleur.atelier!.isNotEmpty)
                        for (var atelier in tailleur.atelier!)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildAtelierInfo(
                                  'Nom de l\'atelier', atelier.nom),
                              buildAtelierInfo(
                                  'Lieu de l\'atelier', atelier.lieu),
                              buildAtelierInfo(
                                  'Slogan de l\'atelier', atelier.slogan ?? ""),
                              // Ajoutez d'autres informations de l'atelier ici
                              SizedBox(height: 16.0),
                            ],
                          )
                      else
                        Text('Aucun atelier associé.'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction utilitaire pour construire chaque ligne d'information
  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fonction utilitaire pour construire chaque ligne d'information de l'atelier
  Widget buildAtelierInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }
}
