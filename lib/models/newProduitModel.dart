import 'package:cloud_firestore/cloud_firestore.dart';

class NewProductModel {
  String token; // Identifiant unique du nouveau produit
  String nom;
  String description;
  double prix;
  String image;

  NewProductModel({
    required this.token,
    required this.nom,
    required this.description,
    required this.prix,
    required this.image,
  });

  factory NewProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return NewProductModel(
      token: snapshot.id,
      nom: data['Nom'] ?? '',
      description: data['Description'] ?? '',
      prix: data['Prix'] ?? 0.0,
      image: data['Image'] ?? '',
    );
  }
}
