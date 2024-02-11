import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/produit.dart';

class AchatProduitModel {
  String nom;
  String description;
  double prix;
  String image;
  int qteCommande;
  //List<Produit> produit;

  AchatProduitModel(
      {required this.nom,
      required this.description,
      required this.prix,
      required this.image,
      required this.qteCommande});

  factory AchatProduitModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return AchatProduitModel(
        nom: data['Nom'],
        description: data['Description'],
        prix: data['Prix'],
        image: data['Image'],
        qteCommande: data['qteCommande']);
  }
}
