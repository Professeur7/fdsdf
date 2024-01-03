import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel {
  String token; // Identifiant unique du like
  String nom;
  String description;
  double prix;
  String image;
  bool isLiked;

  LikeModel({
    required this.token,
    required this.nom,
    required this.description,
    required this.prix,
    required this.image,
    required this.isLiked,
  });

  factory LikeModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return LikeModel(
      token: snapshot.id,
      nom: data['Nom'] ?? '',
      description: data['Description'] ?? '',
      prix: data['Prix'] ?? 0.0,
      image: data['Image'] ?? '',
      isLiked: data['Like'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Nom': nom,
      'Description': description,
      'Prix': prix,
      'Image': image,
      'Like': isLiked,
    };
  }
}
