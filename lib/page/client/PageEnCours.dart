import 'package:flutter/material.dart';
import 'package:fashion2/models/commande.dart'; // Importez votre modèle de données pour les commandes

class CommandeDetailsPage extends StatelessWidget {
  final Commande
      commande; // Utilisez votre modèle de données pour les commandes

  CommandeDetailsPage({required this.commande});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la Commande'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Numéro de commande: ${commande.etatCommande}'),
            Text('Date de commande: ${commande.dateCommande}'),
            Text('Produits commandés:'),
            // Affichez la liste des produits commandés
            //if (commande. != null && commande.produits!.isNotEmpty)
            //   for (var produit in commande.produits!)
            //     ListTile(
            //       title: Text(produit.nom),
            //       subtitle: Text('Quantité: ${produit.quantite}'),
            //       // Ajoutez d'autres informations sur le produit ici
            //     )
            // else
            Text('Aucun produit associé à cette commande.'),
            // Ajoutez d'autres informations de la commande ici
          ],
        ),
      ),
    );
  }
}
