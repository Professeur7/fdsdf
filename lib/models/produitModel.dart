import 'package:cloud_firestore/cloud_firestore.dart';

class ProduitModel {
  String nom;
  String description;
  double prix;
  String image;
  bool? like;
  String? token;
  // Ajouter d'autres propriétés si nécessaire

  ProduitModel(
      {required this.nom,
      required this.description,
      required this.prix,
      required this.image,
      this.like,
      token
      // Ajouter d'autres propriétés si nécessaire
      });

  static ProduitModel fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return ProduitModel(
      nom: data['Nom'],
      description: data['Description'],
      prix: data['Prix'],
      image: data['Image'],
      like: data["like"],
      // Récupérer d'autres propriétés si nécessaire
    );
  }
}
