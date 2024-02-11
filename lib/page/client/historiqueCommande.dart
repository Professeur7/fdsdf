import 'package:fashion2/page/client/PageEnCours.dart';
import 'package:flutter/material.dart';
import 'package:fashion2/models/commande.dart'; // Importez votre modèle de données pour les commandes
// Importez la page de détails de la commande

class HistoriqueCommandesPage extends StatelessWidget {
  final List<Commande>
      historiqueCommandes; // Utilisez votre modèle de données pour les commandes

  HistoriqueCommandesPage({required this.historiqueCommandes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des Commandes'),
      ),
      body: ListView.builder(
        itemCount: historiqueCommandes.length,
        itemBuilder: (context, index) {
          Commande commande = historiqueCommandes[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommandeDetailsPage(commande: commande),
                ),
              );
            },
            child: ListTile(
              title: Text('Commande #${commande.etatCommande}'),
              subtitle: Text('Date de commande: ${commande.dateCommande}'),
              // Ajoutez d'autres informations sur la commande ici
            ),
          );
        },
      ),
    );
  }
}
